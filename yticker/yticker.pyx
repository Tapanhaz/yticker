
# -*- coding: utf-8 -*-
"""
    :description: Yahoo Ticker using picows.
    :author: Tapan Hazarika
    :created: On Tuesday Feb 11, 2025 23:22:49 GMT+05:30
"""
__author__ = "Tapan Hazarika"

import ssl
import time
import random
import signal
import orjson
import logging
import asyncio
from functools import wraps
from libc.stdint cimport uint8_t
from libc.stdlib cimport malloc, realloc, free
from cpython.bytes cimport PyBytes_AS_STRING, PyBytes_GET_SIZE
from yticker.yproto cimport (
    ystr, qf_PricingData, qf_PricingData_decode, qf_PricingData_to_dict,
    y_b64_decode, y_json_str_value, y_decode_error, Y_ERR_B64,
)
from picows.picows cimport WSFrame, WSTransport, WSListener
from picows import ws_connect, WSMsgType, WSCloseCode, WSError, WSAutoPingStrategy

logger = logging.getLogger(__name__)

cdef class YTicker:
    cdef:
        object _loop
        WSTransport _transport
        uint8_t* _scratch
        size_t _scratch_cap

        set _tokens
        str _ws_url
        bint _disconnect_socket
        bint _shutdown_initiated
        bint _shutdown_scheduled
        int _pending_signal
        int _fail_count
        bytes _disconnect_msg
        public object IS_CONNECTED
        object _stop_event
        object _abort_event
        object _ssl_context
        object _ticker_task
        object _signal_task
        dict _prev_handlers

        object _message_callback
        object _open_callback
        object _close_callback
        object _error_callback

        public double connect_timeout
        public double handshake_timeout
        public double min_backoff
        public double max_backoff
        public double backoff_multiplier
        public double backoff_jitter
        public double min_stable_secs

    def __cinit__(self, *args, **kwargs):
        self._scratch_cap = 4096
        self._scratch = <uint8_t*>malloc(self._scratch_cap)
        if self._scratch == NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._scratch != NULL:
            free(self._scratch)
            self._scratch = NULL


    def __init__(
            self,
            object loop
        )-> None:
        self._loop = loop
        self._ws_url= "wss://streamer.finance.yahoo.com/?version=2"

        self._ssl_context = ssl.create_default_context()
        self._transport = None
        self._ticker_task = None
        self._signal_task = None
        self._prev_handlers = {}

        self._open_callback = YTicker._dummy_callback
        self._close_callback = YTicker._dummy_callback
        self._message_callback = YTicker._dummy_callback
        self._error_callback = YTicker._dummy_error_callback

        self._disconnect_socket = False
        self._shutdown_initiated = False
        self._shutdown_scheduled = False
        self._pending_signal = 0
        self._fail_count = 0
        self._disconnect_msg = "Connection closed by the user.".encode("utf-8")
        self._tokens = set()

        self.IS_CONNECTED = asyncio.Event()
        self._abort_event = asyncio.Event()
        self._stop_event = asyncio.Event()

        self.connect_timeout = 8.0  
        self.handshake_timeout = 4.0
        self.min_backoff = 0.25
        self.max_backoff = 5.0
        self.backoff_multiplier = 2.0
        self.backoff_jitter = 0.3
        self.min_stable_secs = 10.0

        self.add_signal_handler()

    @staticmethod
    def run_in_thread():
        def decorator(func):
            @wraps(func)
            async def wrapper(*args, **kwargs):
                return await asyncio.to_thread(lambda: func(*args, **kwargs))
            return wrapper
        return decorator
    
    @staticmethod
    async def _dummy_callback(msg: object):
        logger.debug("unhandled callback payload :: %s", msg)

    @staticmethod
    async def _dummy_error_callback(err: object):
        logger.error("unhandled ticker error (no error_callback set) :: %r", err)

    @staticmethod
    cdef bytes _encode(object msg):
        return orjson.dumps(msg)

    def _on_signal(self, int signum):
        self._signal_task = self._loop.create_task(self.stop_signal_handler(signum))

    async def stop_signal_handler(self, signum= 0)-> None:
        if self._shutdown_initiated:
            return
        self._shutdown_initiated = True
        self._pending_signal = signum or 0
        logger.info("WebSocket closure initiated by user interrupt.")
        self.close_websocket()
        try:
            await asyncio.wait_for(self._stop_event.wait(), timeout=2)
        except asyncio.TimeoutError:
            self._initiate_shutdown()

    cdef void add_signal_handler(self):
        for signame in ('SIGINT', 'SIGTERM'):
            signum = int(getattr(signal, signame))
            self._prev_handlers[signum] = signal.getsignal(signum)
            try:
                self._loop.add_signal_handler(signum, self._on_signal, signum)
            except (NotImplementedError, RuntimeError, ValueError):
                logger.debug("signal handler for %s not supported on this loop/thread", signame)

    async def check_round_trip_time(self, count: int= 5)-> list:
        rtts: list = await self._transport.measure_roundtrip_time(count)
        return rtts

    cpdef _send_payload(self, bytes payload):
        if self._transport is not None:
            self._transport.send(WSMsgType.TEXT, payload)

    cdef void on_data_callback(self, bytes message):
        cdef:
            ystr v
            qf_PricingData pd
            Py_ssize_t m
            int rc
            uint8_t* tmp
            
        rc = y_json_str_value(<const uint8_t*>PyBytes_AS_STRING(message),
                              <size_t>PyBytes_GET_SIZE(message), b"message", 7, &v)
        if rc < 0:
            self._loop.create_task(self._error_callback(y_decode_error(rc)))
            return
        if <size_t>v.n + 4 > self._scratch_cap:
            tmp = <uint8_t*>realloc(self._scratch, <size_t>v.n + 4)
            if tmp == NULL:
                self._loop.create_task(self._error_callback(MemoryError()))
                return
            self._scratch = tmp
            self._scratch_cap = <size_t>v.n + 4
        m = y_b64_decode(v.p, v.n, self._scratch)
        if m < 0:
            rc = Y_ERR_B64
        else:
            rc = qf_PricingData_decode(self._scratch, <size_t>m, &pd)
        if rc < 0:
            self._loop.create_task(self._error_callback(y_decode_error(rc)))
            return
        self._loop.create_task(self._message_callback(qf_PricingData_to_dict(&pd)))

    
    cdef void _subscribe_blocking(self, list instruments):
        cdef bytes p = YTicker._encode({"subscribe": instruments})
        self._loop.call_soon_threadsafe(self._apply_subscribe, instruments, p)

    def _apply_subscribe(self, list instruments, bytes p):
        self._tokens.update(instruments)
        self._send_payload(p)

    cdef void _unsubscribe_blocking(self, list instruments):
        cdef bytes p = YTicker._encode({"unsubscribe": instruments})
        self._loop.call_soon_threadsafe(self._apply_unsubscribe, instruments, p)

    def _apply_unsubscribe(self, list instruments, bytes p):
        self._tokens.difference_update(instruments)
        self._send_payload(p)

    @run_in_thread()
    def subscribe(self, instruments: list)-> None:
        self._subscribe_blocking(list(instruments))

    @run_in_thread()
    def unsubscribe(self, instruments: list)-> None:
        self._unsubscribe_blocking(list(instruments))

    cdef void _resubscribe(self):
        if self._tokens:
            self._send_payload(YTicker._encode({"subscribe": list(self._tokens)}))
    
    async def _sleep_backoff(self):
        cdef double delay, jitter
        self._fail_count += 1

        delay = min(self.max_backoff,
                    self.min_backoff * (self.backoff_multiplier ** min(self._fail_count - 1, 30)))
        jitter = delay * self.backoff_jitter
        delay = max(0.0, delay + random.uniform(-jitter, jitter))
        logger.warning(f"Reconnect failed/unstable ({self._fail_count} in a row) :: backing off {delay:.2f}s")
        try:
            await asyncio.wait_for(self._abort_event.wait(), timeout=delay)
        except asyncio.TimeoutError:
            pass
        else:
            logger.info("Backoff aborted early -- close requested")

    async def start_ticker(self, bint reconnect= False):
        cdef double t_conn
        cdef bint was_connected

        while not self._disconnect_socket:
            listener = YListener(self, self._loop)
            was_connected = False
            t_conn = 0.0
            try:
                transport, _ = await asyncio.wait_for(
                    ws_connect(
                        lambda: listener,
                        self._ws_url,
                        ssl_context= self._ssl_context,
                        websocket_handshake_timeout= self.handshake_timeout,
                        enable_auto_ping= True,
                        auto_ping_idle_timeout= 3,
                        auto_ping_reply_timeout= 2,
                        auto_ping_strategy= WSAutoPingStrategy.PING_WHEN_IDLE
                    ),
                    timeout= self.connect_timeout
                )
                was_connected = True
                t_conn = time.monotonic()
                logger.info("Connected to Yahoo")
                await transport.wait_disconnected()
            except (OSError, WSError, asyncio.TimeoutError) as e:
                logger.error(f"Error occured on connect :: {e}")
            except Exception:
                logger.exception("Unexpected error in connection cycle")
            finally:
                self._transport = None
                self.IS_CONNECTED.clear()

            if self._disconnect_socket:
                break
            if was_connected and (time.monotonic() - t_conn) >= self.min_stable_secs:
                self._fail_count = 0
                logger.info("Connection lost, reconnecting..")
                continue
            await self._sleep_backoff()

        self._stop_event.set()
        self._initiate_shutdown()
    
    cpdef start_websocket(
                    self,
                    object message_update_callback = None,
                    object error_callback = None,
                    object open_callback = None,
                    object close_callback = None
                    ):
        if message_update_callback is not None:
            self._message_callback = message_update_callback
        if error_callback is not None:
            self._error_callback = error_callback
        if open_callback is not None:
            self._open_callback = open_callback
        if close_callback is not None:
            self._close_callback = close_callback

        self._ticker_task = self._loop.create_task(self.start_ticker())
    
    cpdef close_websocket(self):
        self._disconnect_socket = True
        self._abort_event.set()  
        if self._transport is not None:
            self._transport.send_close(
                            close_code= WSCloseCode.OK, 
                            close_message=self._disconnect_msg
                            )
    
    cdef void _initiate_shutdown(self):
        if self._shutdown_scheduled:
            return
        self._shutdown_scheduled = True
        logger.info("Websocket disconnected.")
        self.IS_CONNECTED.clear()
        self._loop.call_soon_threadsafe(
            self._schedule_async_shutdown
        )

    def _schedule_async_shutdown(self):
        self._loop.create_task(self._async_shutdown())

    async def _async_shutdown(self):
        cdef int signum = self._pending_signal
        cdef object prev_handler = self._prev_handlers.get(signum)

        current_task = asyncio.current_task()
        tasks = [t for t in asyncio.all_tasks(self._loop) if t is not current_task]
        for task in tasks:
            task.cancel()
        if tasks:
            await asyncio.gather(*tasks, return_exceptions=True)

        if signum:
            try:
                self._loop.remove_signal_handler(signum)
            except (NotImplementedError, RuntimeError, ValueError):
                pass
            #if prev_handler is not None:
            if prev_handler is not None and prev_handler != signal.SIG_IGN:
                signal.signal(signum, prev_handler)
        self._loop.stop()
        if signum:
            def _trigger_signal():
                if prev_handler == signal.default_int_handler:
                    signal.default_int_handler(signum, None)
                elif prev_handler is not None and callable(prev_handler):
                    prev_handler(signum, None)
                else:
                    signal.raise_signal(signum)

            self._loop.call_soon(_trigger_signal)


cdef class YListener(WSListener):
    cdef:
        YTicker _parent
        object _loop
        bytes __ping_msg

    def __init__(
            self,            
            YTicker parent,
            object loop
            ) -> None:
        super().__init__()
        self._loop = loop
        self._parent = parent  
        self.__ping_msg = "".encode("utf-8")
    
    cpdef send_user_specific_ping(self, WSTransport transport):
        logger.debug("sending ping")
        transport.send_ping(message= self.__ping_msg)
    
    cpdef on_ws_connected(self, WSTransport transport):
        cdef YTicker p = self._parent
        if p._disconnect_socket:
            transport.send_close(WSCloseCode.OK, p._disconnect_msg)
            return
        p._transport = transport
        p.IS_CONNECTED.set()
        p._resubscribe()
        self._loop.create_task(p._open_callback("Socket opened."))

    cpdef on_ws_frame(self, WSTransport transport, WSFrame frame):
        if frame.msg_type == WSMsgType.TEXT:
            msg = frame.get_payload_as_bytes()
            self._parent.on_data_callback(msg)
        elif frame.msg_type == WSMsgType.PONG:
            transport.notify_user_specific_pong_received()
        elif frame.msg_type == WSMsgType.CLOSE:
            close_msg = frame.get_close_message()
            close_code = frame.get_close_code()
            if close_msg:
                close_msg = close_msg.decode()
            if close_code == 1000 and not close_msg:
                close_msg = "Connection closed by the user."
            logger.info(f"YTicker disconnected with code :: {close_code}, message :: {close_msg} ")
            transport.disconnect()
    
    cpdef on_ws_disconnected(self, WSTransport transport):
        if self._parent._transport is transport:
            self._parent._transport = None
            self._parent.IS_CONNECTED.clear()
        self._loop.create_task(self._parent._close_callback("Socket closed."))


# -*- coding: utf-8 -*-
"""
    :description: Yahoo Ticker using picows.
    :author: Tapan Hazarika
    :created: On Tuesday Feb 11, 2025 23:22:49 GMT+05:30
"""
__author__ = "Tapan Hazarika"

# distutils: language = c++
# cython: language_level=3

import ssl
import socket
import signal
import orjson
import base64
cimport cython
import logging
import asyncio
from functools import wraps
from .yaticker_proto import yaticker
from picows.picows cimport WSFrame, WSTransport, WSListener
from picows import ws_connect, WSMsgType, WSCloseCode, WSError, WSAutoPingStrategy

logger = logging.getLogger(__name__)

cdef class YTicker:
    cdef:
        object __loop
        WSTransport __transport
        object __yaticker

        set __tokens_set
        str _ws_url
        bint _disconnect_socket
        bytes _disconnect_msg
        public object IS_CONNECTED
        object _stop_event

        object _message_callback
        object _open_callback
        object _close_callback
        object _error_callback

    def __init__(
            self,
            object loop
        )-> None:
        self.__loop = loop
        self.__yaticker= yaticker()
        self._ws_url= "wss://streamer.finance.yahoo.com/?version=2"

        self._open_callback= None
        self._close_callback= None
        self._message_callback= None
        self._error_callback= None

        self._disconnect_socket = False
        self._disconnect_msg = "Connection closed by the user.".encode("utf-8")
        self.__tokens_set = set()

        self.IS_CONNECTED = asyncio.Event()
        self._stop_event = asyncio.Event()

        self.add_signal_handler()

    @staticmethod
    def run_in_thread():
        def decorator(func):
            @wraps(func)
            async def wrapper(*args, **kwargs):
                return await asyncio.to_thread(lambda: func(*args, **kwargs))
            return wrapper
        return decorator
    
    async def stop_signal_handler(self, *args, **kwargs)-> None:
        logger.info(f"WebSocket closure initiated by user interrupt.")
        self.close_websocket()  
        try:
            await asyncio.wait_for(self._stop_event.wait(), timeout=2)
        except TimeoutError:
            self._initiate_shutdown() 

    cdef void add_signal_handler(self):
        for signame in ('SIGINT', 'SIGTERM'):
            self.__loop.add_signal_handler(
                                getattr(signal, signame),
                                lambda: self.__loop.create_task(self.stop_signal_handler())
                                )

    cdef void __ws_send(self, str method, list instruments):
        cdef dict msg = {method: instruments}
        self.__transport.send(WSMsgType.TEXT, orjson.dumps(msg))
    
    cdef void on_data_callback(self, bytes message):
        cdef dict msg= orjson.loads(message)
        try:            
            _ = self.__yaticker.ParseFromString(data= base64.b64decode(msg["message"])) 
            self.__loop.create_task(self._message_callback(self.__yaticker.SerializeToDict()))
        except Exception as e:
            if self._error_callback:
                self.__loop.create_task(self._error_callback(e))
    
    @run_in_thread()
    def subscribe(self, instruments: list)-> None:
        self.__ws_send(method= "subscribe", instruments= instruments)   
        self.__tokens_set.update(instruments)
    
    @run_in_thread()
    def unsubscribe(self, instruments: list)-> None:
        self.__ws_send(method= "unsubscribe", instruments= instruments)  
        self.__tokens_set.difference_update(instruments)

    cdef void __resubscribe(self):
        cdef list tokens_temp
        if self.__tokens_set:
            tokens_temp= list(self.__tokens_set)
            self.__tokens_set.clear()
            self.__loop.create_task(self.subscribe(instruments= tokens_temp)) 
    
    @run_in_thread()
    def _resubscribe(self):
        self.__resubscribe()
    
    async def start_ticker(self, bint reconnect= False):
        ssl_context = ssl.create_default_context()
        client= YListner(self, self.__loop)
        try:
            transport, client = await ws_connect(
                                lambda: client,
                                self._ws_url,
                                ssl_context= ssl_context,
                                enable_auto_ping= True,
                                auto_ping_idle_timeout= 3,
                                auto_ping_reply_timeout= 2,
                                auto_ping_strategy= WSAutoPingStrategy.PING_WHEN_IDLE
                                )
            await transport.wait_disconnected()            
        except (socket.gaierror, OSError, WSError) as e:
            logger.error(f"Error occured on connect :: {e}")            
            if reconnect:
                await asyncio.sleep(1)
                return await self.start_ticker(reconnect= True)
            else:
                self._initiate_shutdown()
    
    cpdef start_websocket(
                    self,
                    object message_update_callback,
                    object error_callback = None,
                    object open_callback = None,
                    object close_callback = None
                    ):
        self._message_callback = message_update_callback
        self._open_callback = open_callback
        self._close_callback = close_callback
        self._error_callback = error_callback

        self.__loop.create_task(self.start_ticker())
    
    cpdef close_websocket(self):
        self._disconnect_socket = True
        if self.__transport:
            self.__transport.send_close(
                            close_code= WSCloseCode.OK, 
                            close_message=self._disconnect_msg
                            )
    
    cdef void _initiate_shutdown(self):
        logger.info("Websocket disconnected.")
        self.__loop.call_soon_threadsafe(asyncio.create_task, YTicker.shutdown(self.__loop))
        self.IS_CONNECTED.clear()
    
    @staticmethod
    async def shutdown(loop):
        tasks = [
            t for t in asyncio.all_tasks() if t is not asyncio.current_task()
            ]
        for task in tasks:
            task.cancel()
        await asyncio.gather(*tasks, return_exceptions=True)
        loop.stop()     


cdef class YListner(WSListener):
    cdef:
        YTicker _parent
        object __loop
        bytes __ping_msg

    def __init__(
            self,            
            YTicker parent,
            object loop
            ) -> None:
        super().__init__()
        self.__loop = loop
        self._parent = parent  
        self.__ping_msg = "".encode("utf-8")
    
    cpdef send_user_specific_ping(self, WSTransport transport):
        logger.info("sending ping")
        transport.send_ping(message= self.__ping_msg)
    
    cpdef on_ws_connected(self, WSTransport transport):
        self._parent.__transport = transport
        self._parent.IS_CONNECTED.set()
        if self._parent._open_callback:
            self.__loop.create_task(self._parent._open_callback("Socket opened."))
        self.__loop.create_task(self._parent._resubscribe())

    cpdef on_ws_frame(self, WSTransport transport, WSFrame frame):
        if frame.msg_type == WSMsgType.TEXT:
            msg = frame.get_payload_as_bytes()
            self._parent.on_data_callback(msg)
        elif frame.msg_type == WSMsgType.PONG:
            transport.notify_user_specific_pong_received()
        if frame.msg_type == WSMsgType.CLOSE:
            close_msg = frame.get_close_message()
            close_code = frame.get_close_code()
            if close_msg:
                close_msg = close_msg.decode()
            if close_code == 1000 and not close_msg:
                close_msg = "Connection closed by the user."
            logger.info(f"YTicker disconnected with code :: {close_code}, message :: {close_msg} ")        
    
    cpdef on_ws_disconnected(self, WSTransport transport):
        if self._parent._close_callback:
            self.__loop.create_task(self._parent._close_callback("Socket closed."))
        if self._parent._disconnect_socket:
            self._parent._stop_event.set()
            self._parent._initiate_shutdown() 
        else: 
            logger.info("Trying to reconnect..")
            transport.disconnect()
            self._parent.IS_CONNECTED.clear()
            self.__loop.create_task(self._parent.start_ticker(reconnect=True))  

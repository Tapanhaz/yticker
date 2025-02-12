# yticker
Cython based async python websocket client for yahoo based on picows  : https://github.com/tarasko/picows  


For installation run:

```
pip install yticker
```

#Example ::
===================
```python

import time
import asyncio
import logging
import platform
import warnings
from yticker import YTicker

warnings.filterwarnings("error")

logging.basicConfig(level= logging.DEBUG)

if platform.system() == "Windows":
    import winloop
    asyncio.set_event_loop_policy(winloop.EventLoopPolicy())
else:
    import uvloop
    asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

async def on_tick(msg):
    print(msg)

async def on_open(msg):
    print(f"{time.asctime()} : {msg}")

async def on_close(msg):
    print(f"{time.asctime()} : {msg}")

async def on_error(msg):
    print(f"{time.asctime()} : {msg}")

async def main(loop):    
    ticker = YTicker(loop)
    ticker.start_websocket(
                message_update_callback= on_tick, 
                open_callback= on_open,
                close_callback= on_close,
                error_callback= on_error
                )
    await ticker.IS_CONNECTED.wait()
    await ticker.subscribe(["BTC-USD", "EURUSD=X", "^NSEI", "RELIANCE.NS", "SBIN.BO"])
    #Sample unsubscribe
    await asyncio.sleep(10)
    await ticker.unsubscribe(["BTC_USD", "^NSEI"])
    #Close websocket
    await asyncio.sleep(10)
    ticker.close_websocket()

if __name__ == "__main__":
    try:
        loop = asyncio.get_event_loop()
    except DeprecationWarning:
        loop = asyncio.new_event_loop() 
    loop.create_task(main(loop))
    loop.run_forever()

```
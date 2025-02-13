
from typing import Callable, Optional, List

class YTicker:
    def start_websocket(
            self,
            message_update_callback: Callable[[], None], 
            error_callback: Optional[Callable[[], None]] = None,
            open_callback: Optional[Callable[[], None]] = None, 
            close_callback: Optional[Callable[[], None]] = None 
            )-> None:...
    
    def close_websocket(self)-> None:...

    async def subscribe(self, instruments: List[str])-> None:...

    async def unsubscribe(self, instruments: List[str])-> None:...
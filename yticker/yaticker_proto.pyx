"""
This file is generated using pyrobuf
"""

# distutils: language = c++
# cython: language_level=3

from libc.stdint cimport *
from libc.string cimport *

from pyrobuf_list cimport *
from pyrobuf_util cimport *

import base64
import orjson
import warnings
import enum

class DecodeError(Exception):    
    pass

cdef class yaticker:

    def __cinit__(self):
        self._listener = noop_listener

    

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'id',
                          'price',
                          'time',
                          'currency',
                          'exchange',
                          'quoteType',
                          'marketHours',
                          'changePercent',
                          'dayVolume',
                          'dayHigh',
                          'dayLow',
                          'change',
                          'shortName',
                          'expireDate',
                          'openPrice',
                          'previousClose',
                          'strikePrice',
                          'underlyingSymbol',
                          'openInterest',
                          'optionsType',
                          'miniOption',
                          'lastSize',
                          'bid',
                          'bidSize',
                          'ask',
                          'askSize',
                          'priceHint',
                          'vol_24hr',
                          'volAllCurrencies',
                          'fromcurrency',
                          'lastMarket',
                          'circulatingSupply',
                          'marketcap',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    
    cpdef _id__reset(self):
        self._id = ""
        self.__field_bitmap0 &= ~1
    cpdef _price__reset(self):
        self._price = 0
        self.__field_bitmap0 &= ~2
    cpdef _time__reset(self):
        self._time = 0
        self.__field_bitmap0 &= ~4
    cpdef _currency__reset(self):
        self._currency = ""
        self.__field_bitmap0 &= ~8
    cpdef _exchange__reset(self):
        self._exchange = ""
        self.__field_bitmap0 &= ~16
    cpdef _quoteType__reset(self):
        self._quoteType = _yatickerQuoteType_NONE
        self.__field_bitmap0 &= ~32
    cpdef _marketHours__reset(self):
        self._marketHours = _yatickerMarketHoursType_PRE_MARKET
        self.__field_bitmap0 &= ~64
    cpdef _changePercent__reset(self):
        self._changePercent = 0
        self.__field_bitmap0 &= ~128
    cpdef _dayVolume__reset(self):
        self._dayVolume = 0
        self.__field_bitmap0 &= ~256
    cpdef _dayHigh__reset(self):
        self._dayHigh = 0
        self.__field_bitmap0 &= ~512
    cpdef _dayLow__reset(self):
        self._dayLow = 0
        self.__field_bitmap0 &= ~1024
    cpdef _change__reset(self):
        self._change = 0
        self.__field_bitmap0 &= ~2048
    cpdef _shortName__reset(self):
        self._shortName = ""
        self.__field_bitmap0 &= ~4096
    cpdef _expireDate__reset(self):
        self._expireDate = 0
        self.__field_bitmap0 &= ~8192
    cpdef _openPrice__reset(self):
        self._openPrice = 0
        self.__field_bitmap0 &= ~16384
    cpdef _previousClose__reset(self):
        self._previousClose = 0
        self.__field_bitmap0 &= ~32768
    cpdef _strikePrice__reset(self):
        self._strikePrice = 0
        self.__field_bitmap0 &= ~65536
    cpdef _underlyingSymbol__reset(self):
        self._underlyingSymbol = ""
        self.__field_bitmap0 &= ~131072
    cpdef _openInterest__reset(self):
        self._openInterest = 0
        self.__field_bitmap0 &= ~262144
    cpdef _optionsType__reset(self):
        self._optionsType = _yatickerOptionType_CALL
        self.__field_bitmap0 &= ~524288
    cpdef _miniOption__reset(self):
        self._miniOption = 0
        self.__field_bitmap0 &= ~1048576
    cpdef _lastSize__reset(self):
        self._lastSize = 0
        self.__field_bitmap0 &= ~2097152
    cpdef _bid__reset(self):
        self._bid = 0
        self.__field_bitmap0 &= ~4194304
    cpdef _bidSize__reset(self):
        self._bidSize = 0
        self.__field_bitmap0 &= ~8388608
    cpdef _ask__reset(self):
        self._ask = 0
        self.__field_bitmap0 &= ~16777216
    cpdef _askSize__reset(self):
        self._askSize = 0
        self.__field_bitmap0 &= ~33554432
    cpdef _priceHint__reset(self):
        self._priceHint = 0
        self.__field_bitmap0 &= ~67108864
    cpdef _vol_24hr__reset(self):
        self._vol_24hr = 0
        self.__field_bitmap0 &= ~134217728
    cpdef _volAllCurrencies__reset(self):
        self._volAllCurrencies = 0
        self.__field_bitmap0 &= ~268435456
    cpdef _fromcurrency__reset(self):
        self._fromcurrency = ""
        self.__field_bitmap0 &= ~536870912
    cpdef _lastMarket__reset(self):
        self._lastMarket = ""
        self.__field_bitmap0 &= ~1073741824
    cpdef _circulatingSupply__reset(self):
        self._circulatingSupply = 0
        self.__field_bitmap0 &= ~2147483648
    cpdef _marketcap__reset(self):
        self._marketcap = 0
        self.__field_bitmap0 &= ~4294967296

    cpdef void reset(self):
        # reset values and populate defaults
    
        self._id__reset()
        self._price__reset()
        self._time__reset()
        self._currency__reset()
        self._exchange__reset()
        self._quoteType__reset()
        self._marketHours__reset()
        self._changePercent__reset()
        self._dayVolume__reset()
        self._dayHigh__reset()
        self._dayLow__reset()
        self._change__reset()
        self._shortName__reset()
        self._expireDate__reset()
        self._openPrice__reset()
        self._previousClose__reset()
        self._strikePrice__reset()
        self._underlyingSymbol__reset()
        self._openInterest__reset()
        self._optionsType__reset()
        self._miniOption__reset()
        self._lastSize__reset()
        self._bid__reset()
        self._bidSize__reset()
        self._ask__reset()
        self._askSize__reset()
        self._priceHint__reset()
        self._vol_24hr__reset()
        self._volAllCurrencies__reset()
        self._fromcurrency__reset()
        self._lastMarket__reset()
        self._circulatingSupply__reset()
        self._marketcap__reset()
        return

    
    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, value):
        self.__field_bitmap0 |= 1
        if isinstance(value, bytes):
            self._id = value.decode('utf-8')
        elif isinstance(value, str):
            self._id = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def price(self):
        return self._price

    @price.setter
    def price(self, value):
        self.__field_bitmap0 |= 2
        self._price = value
        self._Modified()
    
    @property
    def time(self):
        return self._time

    @time.setter
    def time(self, value):
        self.__field_bitmap0 |= 4
        self._time = value
        self._Modified()
    
    @property
    def currency(self):
        return self._currency

    @currency.setter
    def currency(self, value):
        self.__field_bitmap0 |= 8
        if isinstance(value, bytes):
            self._currency = value.decode('utf-8')
        elif isinstance(value, str):
            self._currency = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def exchange(self):
        return self._exchange

    @exchange.setter
    def exchange(self, value):
        self.__field_bitmap0 |= 16
        if isinstance(value, bytes):
            self._exchange = value.decode('utf-8')
        elif isinstance(value, str):
            self._exchange = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def quoteType(self):
        return self._quoteType

    @quoteType.setter
    def quoteType(self, value):
        self.__field_bitmap0 |= 32
        if value == 0:
            self._quoteType = _yatickerQuoteType_NONE
                
        elif value == 5:
            self._quoteType = _yatickerQuoteType_ALTSYMBOL
                
        elif value == 7:
            self._quoteType = _yatickerQuoteType_HEARTBEAT
                
        elif value == 8:
            self._quoteType = _yatickerQuoteType_EQUITY
                
        elif value == 9:
            self._quoteType = _yatickerQuoteType_INDEX
                
        elif value == 11:
            self._quoteType = _yatickerQuoteType_MUTUALFUND
                
        elif value == 12:
            self._quoteType = _yatickerQuoteType_MONEYMARKET
                
        elif value == 13:
            self._quoteType = _yatickerQuoteType_OPTION
                
        elif value == 14:
            self._quoteType = _yatickerQuoteType_CURRENCY
                
        elif value == 15:
            self._quoteType = _yatickerQuoteType_WARRANT
                
        elif value == 17:
            self._quoteType = _yatickerQuoteType_BOND
                
        elif value == 18:
            self._quoteType = _yatickerQuoteType_FUTURE
                
        elif value == 20:
            self._quoteType = _yatickerQuoteType_ETF
                
        elif value == 23:
            self._quoteType = _yatickerQuoteType_COMMODITY
                
        elif value == 28:
            self._quoteType = _yatickerQuoteType_ECNQUOTE
                
        elif value == 41:
            self._quoteType = _yatickerQuoteType_CRYPTOCURRENCY
                
        elif value == 42:
            self._quoteType = _yatickerQuoteType_INDICATOR
                
        elif value == 1000:
            self._quoteType = _yatickerQuoteType_INDUSTRY
                
        else:
            raise ValueError("{} not a valid value for enum yatickerQuoteType".format(value))
        self._Modified()
    
    @property
    def marketHours(self):
        return self._marketHours

    @marketHours.setter
    def marketHours(self, value):
        self.__field_bitmap0 |= 64
        if value == 0:
            self._marketHours = _yatickerMarketHoursType_PRE_MARKET
                
        elif value == 1:
            self._marketHours = _yatickerMarketHoursType_REGULAR_MARKET
                
        elif value == 2:
            self._marketHours = _yatickerMarketHoursType_POST_MARKET
                
        elif value == 3:
            self._marketHours = _yatickerMarketHoursType_EXTENDED_HOURS_MARKET
                
        else:
            raise ValueError("{} not a valid value for enum yatickerMarketHoursType".format(value))
        self._Modified()
    
    @property
    def changePercent(self):
        return self._changePercent

    @changePercent.setter
    def changePercent(self, value):
        self.__field_bitmap0 |= 128
        self._changePercent = value
        self._Modified()
    
    @property
    def dayVolume(self):
        return self._dayVolume

    @dayVolume.setter
    def dayVolume(self, value):
        self.__field_bitmap0 |= 256
        self._dayVolume = value
        self._Modified()
    
    @property
    def dayHigh(self):
        return self._dayHigh

    @dayHigh.setter
    def dayHigh(self, value):
        self.__field_bitmap0 |= 512
        self._dayHigh = value
        self._Modified()
    
    @property
    def dayLow(self):
        return self._dayLow

    @dayLow.setter
    def dayLow(self, value):
        self.__field_bitmap0 |= 1024
        self._dayLow = value
        self._Modified()
    
    @property
    def change(self):
        return self._change

    @change.setter
    def change(self, value):
        self.__field_bitmap0 |= 2048
        self._change = value
        self._Modified()
    
    @property
    def shortName(self):
        return self._shortName

    @shortName.setter
    def shortName(self, value):
        self.__field_bitmap0 |= 4096
        if isinstance(value, bytes):
            self._shortName = value.decode('utf-8')
        elif isinstance(value, str):
            self._shortName = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def expireDate(self):
        return self._expireDate

    @expireDate.setter
    def expireDate(self, value):
        self.__field_bitmap0 |= 8192
        self._expireDate = value
        self._Modified()
    
    @property
    def openPrice(self):
        return self._openPrice

    @openPrice.setter
    def openPrice(self, value):
        self.__field_bitmap0 |= 16384
        self._openPrice = value
        self._Modified()
    
    @property
    def previousClose(self):
        return self._previousClose

    @previousClose.setter
    def previousClose(self, value):
        self.__field_bitmap0 |= 32768
        self._previousClose = value
        self._Modified()
    
    @property
    def strikePrice(self):
        return self._strikePrice

    @strikePrice.setter
    def strikePrice(self, value):
        self.__field_bitmap0 |= 65536
        self._strikePrice = value
        self._Modified()
    
    @property
    def underlyingSymbol(self):
        return self._underlyingSymbol

    @underlyingSymbol.setter
    def underlyingSymbol(self, value):
        self.__field_bitmap0 |= 131072
        if isinstance(value, bytes):
            self._underlyingSymbol = value.decode('utf-8')
        elif isinstance(value, str):
            self._underlyingSymbol = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def openInterest(self):
        return self._openInterest

    @openInterest.setter
    def openInterest(self, value):
        self.__field_bitmap0 |= 262144
        self._openInterest = value
        self._Modified()
    
    @property
    def optionsType(self):
        return self._optionsType

    @optionsType.setter
    def optionsType(self, value):
        self.__field_bitmap0 |= 524288
        if value == 0:
            self._optionsType = _yatickerOptionType_CALL
                
        elif value == 1:
            self._optionsType = _yatickerOptionType_PUT
                
        else:
            raise ValueError("{} not a valid value for enum yatickerOptionType".format(value))
        self._Modified()
    
    @property
    def miniOption(self):
        return self._miniOption

    @miniOption.setter
    def miniOption(self, value):
        self.__field_bitmap0 |= 1048576
        self._miniOption = value
        self._Modified()
    
    @property
    def lastSize(self):
        return self._lastSize

    @lastSize.setter
    def lastSize(self, value):
        self.__field_bitmap0 |= 2097152
        self._lastSize = value
        self._Modified()
    
    @property
    def bid(self):
        return self._bid

    @bid.setter
    def bid(self, value):
        self.__field_bitmap0 |= 4194304
        self._bid = value
        self._Modified()
    
    @property
    def bidSize(self):
        return self._bidSize

    @bidSize.setter
    def bidSize(self, value):
        self.__field_bitmap0 |= 8388608
        self._bidSize = value
        self._Modified()
    
    @property
    def ask(self):
        return self._ask

    @ask.setter
    def ask(self, value):
        self.__field_bitmap0 |= 16777216
        self._ask = value
        self._Modified()
    
    @property
    def askSize(self):
        return self._askSize

    @askSize.setter
    def askSize(self, value):
        self.__field_bitmap0 |= 33554432
        self._askSize = value
        self._Modified()
    
    @property
    def priceHint(self):
        return self._priceHint

    @priceHint.setter
    def priceHint(self, value):
        self.__field_bitmap0 |= 67108864
        self._priceHint = value
        self._Modified()
    
    @property
    def vol_24hr(self):
        return self._vol_24hr

    @vol_24hr.setter
    def vol_24hr(self, value):
        self.__field_bitmap0 |= 134217728
        self._vol_24hr = value
        self._Modified()
    
    @property
    def volAllCurrencies(self):
        return self._volAllCurrencies

    @volAllCurrencies.setter
    def volAllCurrencies(self, value):
        self.__field_bitmap0 |= 268435456
        self._volAllCurrencies = value
        self._Modified()
    
    @property
    def fromcurrency(self):
        return self._fromcurrency

    @fromcurrency.setter
    def fromcurrency(self, value):
        self.__field_bitmap0 |= 536870912
        if isinstance(value, bytes):
            self._fromcurrency = value.decode('utf-8')
        elif isinstance(value, str):
            self._fromcurrency = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def lastMarket(self):
        return self._lastMarket

    @lastMarket.setter
    def lastMarket(self, value):
        self.__field_bitmap0 |= 1073741824
        if isinstance(value, bytes):
            self._lastMarket = value.decode('utf-8')
        elif isinstance(value, str):
            self._lastMarket = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def circulatingSupply(self):
        return self._circulatingSupply

    @circulatingSupply.setter
    def circulatingSupply(self, value):
        self.__field_bitmap0 |= 2147483648
        self._circulatingSupply = value
        self._Modified()
    
    @property
    def marketcap(self):
        return self._marketcap

    @marketcap.setter
    def marketcap(self, value):
        self.__field_bitmap0 |= 4294967296
        self._marketcap = value
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # id
            if key == 10:
                self.__field_bitmap0 |= 1
                field_size = get_varint64(memory, &current_offset)
                self._id = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # price
            elif key == 21:
                self.__field_bitmap0 |= 2
                self._price = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # time
            elif key == 24:
                self.__field_bitmap0 |= 4
                self._time = get_signed_varint64(memory, &current_offset)
            # currency
            elif key == 34:
                self.__field_bitmap0 |= 8
                field_size = get_varint64(memory, &current_offset)
                self._currency = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # exchange
            elif key == 42:
                self.__field_bitmap0 |= 16
                field_size = get_varint64(memory, &current_offset)
                self._exchange = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # quoteType
            elif key == 48:
                self.quoteType = get_varint32(memory, &current_offset)
            # marketHours
            elif key == 56:
                self.marketHours = get_varint32(memory, &current_offset)
            # changePercent
            elif key == 69:
                self.__field_bitmap0 |= 128
                self._changePercent = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # dayVolume
            elif key == 72:
                self.__field_bitmap0 |= 256
                self._dayVolume = get_signed_varint64(memory, &current_offset)
            # dayHigh
            elif key == 85:
                self.__field_bitmap0 |= 512
                self._dayHigh = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # dayLow
            elif key == 93:
                self.__field_bitmap0 |= 1024
                self._dayLow = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # change
            elif key == 101:
                self.__field_bitmap0 |= 2048
                self._change = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # shortName
            elif key == 106:
                self.__field_bitmap0 |= 4096
                field_size = get_varint64(memory, &current_offset)
                self._shortName = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # expireDate
            elif key == 112:
                self.__field_bitmap0 |= 8192
                self._expireDate = get_signed_varint64(memory, &current_offset)
            # openPrice
            elif key == 125:
                self.__field_bitmap0 |= 16384
                self._openPrice = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # previousClose
            elif key == 133:
                self.__field_bitmap0 |= 32768
                self._previousClose = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # strikePrice
            elif key == 141:
                self.__field_bitmap0 |= 65536
                self._strikePrice = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # underlyingSymbol
            elif key == 146:
                self.__field_bitmap0 |= 131072
                field_size = get_varint64(memory, &current_offset)
                self._underlyingSymbol = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # openInterest
            elif key == 152:
                self.__field_bitmap0 |= 262144
                self._openInterest = get_signed_varint64(memory, &current_offset)
            # optionsType
            elif key == 160:
                self.optionsType = get_varint32(memory, &current_offset)
            # miniOption
            elif key == 168:
                self.__field_bitmap0 |= 1048576
                self._miniOption = get_signed_varint64(memory, &current_offset)
            # lastSize
            elif key == 176:
                self.__field_bitmap0 |= 2097152
                self._lastSize = get_signed_varint64(memory, &current_offset)
            # bid
            elif key == 189:
                self.__field_bitmap0 |= 4194304
                self._bid = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # bidSize
            elif key == 192:
                self.__field_bitmap0 |= 8388608
                self._bidSize = get_signed_varint64(memory, &current_offset)
            # ask
            elif key == 205:
                self.__field_bitmap0 |= 16777216
                self._ask = (<float *>&memory[current_offset])[0]
                current_offset += sizeof(float)
            # askSize
            elif key == 208:
                self.__field_bitmap0 |= 33554432
                self._askSize = get_signed_varint64(memory, &current_offset)
            # priceHint
            elif key == 216:
                self.__field_bitmap0 |= 67108864
                self._priceHint = get_signed_varint64(memory, &current_offset)
            # vol_24hr
            elif key == 224:
                self.__field_bitmap0 |= 134217728
                self._vol_24hr = get_signed_varint64(memory, &current_offset)
            # volAllCurrencies
            elif key == 232:
                self.__field_bitmap0 |= 268435456
                self._volAllCurrencies = get_signed_varint64(memory, &current_offset)
            # fromcurrency
            elif key == 242:
                self.__field_bitmap0 |= 536870912
                field_size = get_varint64(memory, &current_offset)
                self._fromcurrency = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # lastMarket
            elif key == 250:
                self.__field_bitmap0 |= 1073741824
                field_size = get_varint64(memory, &current_offset)
                self._lastMarket = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # circulatingSupply
            elif key == 257:
                self.__field_bitmap0 |= 2147483648
                self._circulatingSupply = (<double *>&memory[current_offset])[0]
                current_offset += sizeof(double)
            # marketcap
            elif key == 265:
                self.__field_bitmap0 |= 4294967296
                self._marketcap = (<double *>&memory[current_offset])[0]
                current_offset += sizeof(double)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        self._clearfield(field_name)
        self._Modified()

    cdef void _clearfield(self, field_name):
        if field_name == 'id':
            self._id__reset()
        elif field_name == 'price':
            self._price__reset()
        elif field_name == 'time':
            self._time__reset()
        elif field_name == 'currency':
            self._currency__reset()
        elif field_name == 'exchange':
            self._exchange__reset()
        elif field_name == 'quoteType':
            self._quoteType__reset()
        elif field_name == 'marketHours':
            self._marketHours__reset()
        elif field_name == 'changePercent':
            self._changePercent__reset()
        elif field_name == 'dayVolume':
            self._dayVolume__reset()
        elif field_name == 'dayHigh':
            self._dayHigh__reset()
        elif field_name == 'dayLow':
            self._dayLow__reset()
        elif field_name == 'change':
            self._change__reset()
        elif field_name == 'shortName':
            self._shortName__reset()
        elif field_name == 'expireDate':
            self._expireDate__reset()
        elif field_name == 'openPrice':
            self._openPrice__reset()
        elif field_name == 'previousClose':
            self._previousClose__reset()
        elif field_name == 'strikePrice':
            self._strikePrice__reset()
        elif field_name == 'underlyingSymbol':
            self._underlyingSymbol__reset()
        elif field_name == 'openInterest':
            self._openInterest__reset()
        elif field_name == 'optionsType':
            self._optionsType__reset()
        elif field_name == 'miniOption':
            self._miniOption__reset()
        elif field_name == 'lastSize':
            self._lastSize__reset()
        elif field_name == 'bid':
            self._bid__reset()
        elif field_name == 'bidSize':
            self._bidSize__reset()
        elif field_name == 'ask':
            self._ask__reset()
        elif field_name == 'askSize':
            self._askSize__reset()
        elif field_name == 'priceHint':
            self._priceHint__reset()
        elif field_name == 'vol_24hr':
            self._vol_24hr__reset()
        elif field_name == 'volAllCurrencies':
            self._volAllCurrencies__reset()
        elif field_name == 'fromcurrency':
            self._fromcurrency__reset()
        elif field_name == 'lastMarket':
            self._lastMarket__reset()
        elif field_name == 'circulatingSupply':
            self._circulatingSupply__reset()
        elif field_name == 'marketcap':
            self._marketcap__reset()
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

    cpdef void CopyFrom(self, yaticker other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (yaticker): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'id':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'price':
            return self.__field_bitmap0 & 2 == 2
        if field_name == 'time':
            return self.__field_bitmap0 & 4 == 4
        if field_name == 'currency':
            return self.__field_bitmap0 & 8 == 8
        if field_name == 'exchange':
            return self.__field_bitmap0 & 16 == 16
        if field_name == 'quoteType':
            return self.__field_bitmap0 & 32 == 32
        if field_name == 'marketHours':
            return self.__field_bitmap0 & 64 == 64
        if field_name == 'changePercent':
            return self.__field_bitmap0 & 128 == 128
        if field_name == 'dayVolume':
            return self.__field_bitmap0 & 256 == 256
        if field_name == 'dayHigh':
            return self.__field_bitmap0 & 512 == 512
        if field_name == 'dayLow':
            return self.__field_bitmap0 & 1024 == 1024
        if field_name == 'change':
            return self.__field_bitmap0 & 2048 == 2048
        if field_name == 'shortName':
            return self.__field_bitmap0 & 4096 == 4096
        if field_name == 'expireDate':
            return self.__field_bitmap0 & 8192 == 8192
        if field_name == 'openPrice':
            return self.__field_bitmap0 & 16384 == 16384
        if field_name == 'previousClose':
            return self.__field_bitmap0 & 32768 == 32768
        if field_name == 'strikePrice':
            return self.__field_bitmap0 & 65536 == 65536
        if field_name == 'underlyingSymbol':
            return self.__field_bitmap0 & 131072 == 131072
        if field_name == 'openInterest':
            return self.__field_bitmap0 & 262144 == 262144
        if field_name == 'optionsType':
            return self.__field_bitmap0 & 524288 == 524288
        if field_name == 'miniOption':
            return self.__field_bitmap0 & 1048576 == 1048576
        if field_name == 'lastSize':
            return self.__field_bitmap0 & 2097152 == 2097152
        if field_name == 'bid':
            return self.__field_bitmap0 & 4194304 == 4194304
        if field_name == 'bidSize':
            return self.__field_bitmap0 & 8388608 == 8388608
        if field_name == 'ask':
            return self.__field_bitmap0 & 16777216 == 16777216
        if field_name == 'askSize':
            return self.__field_bitmap0 & 33554432 == 33554432
        if field_name == 'priceHint':
            return self.__field_bitmap0 & 67108864 == 67108864
        if field_name == 'vol_24hr':
            return self.__field_bitmap0 & 134217728 == 134217728
        if field_name == 'volAllCurrencies':
            return self.__field_bitmap0 & 268435456 == 268435456
        if field_name == 'fromcurrency':
            return self.__field_bitmap0 & 536870912 == 536870912
        if field_name == 'lastMarket':
            return self.__field_bitmap0 & 1073741824 == 1073741824
        if field_name == 'circulatingSupply':
            return self.__field_bitmap0 & 2147483648 == 2147483648
        if field_name == 'marketcap':
            return self.__field_bitmap0 & 4294967296 == 4294967296
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    

        return True

    cpdef void MergeFrom(self, yaticker other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._id = other_msg._id
            self.__field_bitmap0 |= 1
        if other_msg.__field_bitmap0 & 2 == 2:
            self._price = other_msg._price
            self.__field_bitmap0 |= 2
        if other_msg.__field_bitmap0 & 4 == 4:
            self._time = other_msg._time
            self.__field_bitmap0 |= 4
        if other_msg.__field_bitmap0 & 8 == 8:
            self._currency = other_msg._currency
            self.__field_bitmap0 |= 8
        if other_msg.__field_bitmap0 & 16 == 16:
            self._exchange = other_msg._exchange
            self.__field_bitmap0 |= 16
        if other_msg.__field_bitmap0 & 32 == 32:
            self._quoteType = other_msg._quoteType
            self.__field_bitmap0 |= 32
        if other_msg.__field_bitmap0 & 64 == 64:
            self._marketHours = other_msg._marketHours
            self.__field_bitmap0 |= 64
        if other_msg.__field_bitmap0 & 128 == 128:
            self._changePercent = other_msg._changePercent
            self.__field_bitmap0 |= 128
        if other_msg.__field_bitmap0 & 256 == 256:
            self._dayVolume = other_msg._dayVolume
            self.__field_bitmap0 |= 256
        if other_msg.__field_bitmap0 & 512 == 512:
            self._dayHigh = other_msg._dayHigh
            self.__field_bitmap0 |= 512
        if other_msg.__field_bitmap0 & 1024 == 1024:
            self._dayLow = other_msg._dayLow
            self.__field_bitmap0 |= 1024
        if other_msg.__field_bitmap0 & 2048 == 2048:
            self._change = other_msg._change
            self.__field_bitmap0 |= 2048
        if other_msg.__field_bitmap0 & 4096 == 4096:
            self._shortName = other_msg._shortName
            self.__field_bitmap0 |= 4096
        if other_msg.__field_bitmap0 & 8192 == 8192:
            self._expireDate = other_msg._expireDate
            self.__field_bitmap0 |= 8192
        if other_msg.__field_bitmap0 & 16384 == 16384:
            self._openPrice = other_msg._openPrice
            self.__field_bitmap0 |= 16384
        if other_msg.__field_bitmap0 & 32768 == 32768:
            self._previousClose = other_msg._previousClose
            self.__field_bitmap0 |= 32768
        if other_msg.__field_bitmap0 & 65536 == 65536:
            self._strikePrice = other_msg._strikePrice
            self.__field_bitmap0 |= 65536
        if other_msg.__field_bitmap0 & 131072 == 131072:
            self._underlyingSymbol = other_msg._underlyingSymbol
            self.__field_bitmap0 |= 131072
        if other_msg.__field_bitmap0 & 262144 == 262144:
            self._openInterest = other_msg._openInterest
            self.__field_bitmap0 |= 262144
        if other_msg.__field_bitmap0 & 524288 == 524288:
            self._optionsType = other_msg._optionsType
            self.__field_bitmap0 |= 524288
        if other_msg.__field_bitmap0 & 1048576 == 1048576:
            self._miniOption = other_msg._miniOption
            self.__field_bitmap0 |= 1048576
        if other_msg.__field_bitmap0 & 2097152 == 2097152:
            self._lastSize = other_msg._lastSize
            self.__field_bitmap0 |= 2097152
        if other_msg.__field_bitmap0 & 4194304 == 4194304:
            self._bid = other_msg._bid
            self.__field_bitmap0 |= 4194304
        if other_msg.__field_bitmap0 & 8388608 == 8388608:
            self._bidSize = other_msg._bidSize
            self.__field_bitmap0 |= 8388608
        if other_msg.__field_bitmap0 & 16777216 == 16777216:
            self._ask = other_msg._ask
            self.__field_bitmap0 |= 16777216
        if other_msg.__field_bitmap0 & 33554432 == 33554432:
            self._askSize = other_msg._askSize
            self.__field_bitmap0 |= 33554432
        if other_msg.__field_bitmap0 & 67108864 == 67108864:
            self._priceHint = other_msg._priceHint
            self.__field_bitmap0 |= 67108864
        if other_msg.__field_bitmap0 & 134217728 == 134217728:
            self._vol_24hr = other_msg._vol_24hr
            self.__field_bitmap0 |= 134217728
        if other_msg.__field_bitmap0 & 268435456 == 268435456:
            self._volAllCurrencies = other_msg._volAllCurrencies
            self.__field_bitmap0 |= 268435456
        if other_msg.__field_bitmap0 & 536870912 == 536870912:
            self._fromcurrency = other_msg._fromcurrency
            self.__field_bitmap0 |= 536870912
        if other_msg.__field_bitmap0 & 1073741824 == 1073741824:
            self._lastMarket = other_msg._lastMarket
            self.__field_bitmap0 |= 1073741824
        if other_msg.__field_bitmap0 & 2147483648 == 2147483648:
            self._circulatingSupply = other_msg._circulatingSupply
            self.__field_bitmap0 |= 2147483648
        if other_msg.__field_bitmap0 & 4294967296 == 4294967296:
            self._marketcap = other_msg._marketcap
            self.__field_bitmap0 |= 4294967296

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        # id
        cdef bytes id_bytes
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(10, buf)
            id_bytes = self._id.encode('utf-8')
            set_varint64(len(id_bytes), buf)
            buf += id_bytes
        # price
        if self.__field_bitmap0 & 2 == 2:
            set_varint64(21, buf)
            buf += (<unsigned char *>&self._price)[:sizeof(float)]
        # time
        if self.__field_bitmap0 & 4 == 4:
            set_varint64(24, buf)
            set_signed_varint64(self._time, buf)
        # currency
        cdef bytes currency_bytes
        if self.__field_bitmap0 & 8 == 8:
            set_varint64(34, buf)
            currency_bytes = self._currency.encode('utf-8')
            set_varint64(len(currency_bytes), buf)
            buf += currency_bytes
        # exchange
        cdef bytes exchange_bytes
        if self.__field_bitmap0 & 16 == 16:
            set_varint64(42, buf)
            exchange_bytes = self._exchange.encode('utf-8')
            set_varint64(len(exchange_bytes), buf)
            buf += exchange_bytes
        # quoteType
        if self.__field_bitmap0 & 32 == 32:
            set_varint64(48, buf)
            set_varint32(self._quoteType, buf)
        # marketHours
        if self.__field_bitmap0 & 64 == 64:
            set_varint64(56, buf)
            set_varint32(self._marketHours, buf)
        # changePercent
        if self.__field_bitmap0 & 128 == 128:
            set_varint64(69, buf)
            buf += (<unsigned char *>&self._changePercent)[:sizeof(float)]
        # dayVolume
        if self.__field_bitmap0 & 256 == 256:
            set_varint64(72, buf)
            set_signed_varint64(self._dayVolume, buf)
        # dayHigh
        if self.__field_bitmap0 & 512 == 512:
            set_varint64(85, buf)
            buf += (<unsigned char *>&self._dayHigh)[:sizeof(float)]
        # dayLow
        if self.__field_bitmap0 & 1024 == 1024:
            set_varint64(93, buf)
            buf += (<unsigned char *>&self._dayLow)[:sizeof(float)]
        # change
        if self.__field_bitmap0 & 2048 == 2048:
            set_varint64(101, buf)
            buf += (<unsigned char *>&self._change)[:sizeof(float)]
        # shortName
        cdef bytes shortName_bytes
        if self.__field_bitmap0 & 4096 == 4096:
            set_varint64(106, buf)
            shortName_bytes = self._shortName.encode('utf-8')
            set_varint64(len(shortName_bytes), buf)
            buf += shortName_bytes
        # expireDate
        if self.__field_bitmap0 & 8192 == 8192:
            set_varint64(112, buf)
            set_signed_varint64(self._expireDate, buf)
        # openPrice
        if self.__field_bitmap0 & 16384 == 16384:
            set_varint64(125, buf)
            buf += (<unsigned char *>&self._openPrice)[:sizeof(float)]
        # previousClose
        if self.__field_bitmap0 & 32768 == 32768:
            set_varint64(133, buf)
            buf += (<unsigned char *>&self._previousClose)[:sizeof(float)]
        # strikePrice
        if self.__field_bitmap0 & 65536 == 65536:
            set_varint64(141, buf)
            buf += (<unsigned char *>&self._strikePrice)[:sizeof(float)]
        # underlyingSymbol
        cdef bytes underlyingSymbol_bytes
        if self.__field_bitmap0 & 131072 == 131072:
            set_varint64(146, buf)
            underlyingSymbol_bytes = self._underlyingSymbol.encode('utf-8')
            set_varint64(len(underlyingSymbol_bytes), buf)
            buf += underlyingSymbol_bytes
        # openInterest
        if self.__field_bitmap0 & 262144 == 262144:
            set_varint64(152, buf)
            set_signed_varint64(self._openInterest, buf)
        # optionsType
        if self.__field_bitmap0 & 524288 == 524288:
            set_varint64(160, buf)
            set_varint32(self._optionsType, buf)
        # miniOption
        if self.__field_bitmap0 & 1048576 == 1048576:
            set_varint64(168, buf)
            set_signed_varint64(self._miniOption, buf)
        # lastSize
        if self.__field_bitmap0 & 2097152 == 2097152:
            set_varint64(176, buf)
            set_signed_varint64(self._lastSize, buf)
        # bid
        if self.__field_bitmap0 & 4194304 == 4194304:
            set_varint64(189, buf)
            buf += (<unsigned char *>&self._bid)[:sizeof(float)]
        # bidSize
        if self.__field_bitmap0 & 8388608 == 8388608:
            set_varint64(192, buf)
            set_signed_varint64(self._bidSize, buf)
        # ask
        if self.__field_bitmap0 & 16777216 == 16777216:
            set_varint64(205, buf)
            buf += (<unsigned char *>&self._ask)[:sizeof(float)]
        # askSize
        if self.__field_bitmap0 & 33554432 == 33554432:
            set_varint64(208, buf)
            set_signed_varint64(self._askSize, buf)
        # priceHint
        if self.__field_bitmap0 & 67108864 == 67108864:
            set_varint64(216, buf)
            set_signed_varint64(self._priceHint, buf)
        # vol_24hr
        if self.__field_bitmap0 & 134217728 == 134217728:
            set_varint64(224, buf)
            set_signed_varint64(self._vol_24hr, buf)
        # volAllCurrencies
        if self.__field_bitmap0 & 268435456 == 268435456:
            set_varint64(232, buf)
            set_signed_varint64(self._volAllCurrencies, buf)
        # fromcurrency
        cdef bytes fromcurrency_bytes
        if self.__field_bitmap0 & 536870912 == 536870912:
            set_varint64(242, buf)
            fromcurrency_bytes = self._fromcurrency.encode('utf-8')
            set_varint64(len(fromcurrency_bytes), buf)
            buf += fromcurrency_bytes
        # lastMarket
        cdef bytes lastMarket_bytes
        if self.__field_bitmap0 & 1073741824 == 1073741824:
            set_varint64(250, buf)
            lastMarket_bytes = self._lastMarket.encode('utf-8')
            set_varint64(len(lastMarket_bytes), buf)
            buf += lastMarket_bytes
        # circulatingSupply
        if self.__field_bitmap0 & 2147483648 == 2147483648:
            set_varint64(257, buf)
            buf += (<unsigned char *>&self._circulatingSupply)[:sizeof(double)]
        # marketcap
        if self.__field_bitmap0 & 4294967296 == 4294967296:
            set_varint64(265, buf)
            buf += (<unsigned char *>&self._marketcap)[:sizeof(double)]

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        self._listener()
        self._cached_serialization = None

    

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = orjson.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into bytes.

        Returns:
            bytes
        """
        d = self.SerializeToDict()
        return orjson.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into bytes.

        Returns:
            bytes
        """
        d = self.SerializePartialToDict()
        return orjson.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.id = d["id"]
        except KeyError:
            pass
        try:
            self.price = d["price"]
        except KeyError:
            pass
        try:
            self.time = d["time"]
        except KeyError:
            pass
        try:
            self.currency = d["currency"]
        except KeyError:
            pass
        try:
            self.exchange = d["exchange"]
        except KeyError:
            pass
        try:
            self.quoteType = d["quoteType"]
        except KeyError:
            pass
        try:
            self.marketHours = d["marketHours"]
        except KeyError:
            pass
        try:
            self.changePercent = d["changePercent"]
        except KeyError:
            pass
        try:
            self.dayVolume = d["dayVolume"]
        except KeyError:
            pass
        try:
            self.dayHigh = d["dayHigh"]
        except KeyError:
            pass
        try:
            self.dayLow = d["dayLow"]
        except KeyError:
            pass
        try:
            self.change = d["change"]
        except KeyError:
            pass
        try:
            self.shortName = d["shortName"]
        except KeyError:
            pass
        try:
            self.expireDate = d["expireDate"]
        except KeyError:
            pass
        try:
            self.openPrice = d["openPrice"]
        except KeyError:
            pass
        try:
            self.previousClose = d["previousClose"]
        except KeyError:
            pass
        try:
            self.strikePrice = d["strikePrice"]
        except KeyError:
            pass
        try:
            self.underlyingSymbol = d["underlyingSymbol"]
        except KeyError:
            pass
        try:
            self.openInterest = d["openInterest"]
        except KeyError:
            pass
        try:
            self.optionsType = d["optionsType"]
        except KeyError:
            pass
        try:
            self.miniOption = d["miniOption"]
        except KeyError:
            pass
        try:
            self.lastSize = d["lastSize"]
        except KeyError:
            pass
        try:
            self.bid = d["bid"]
        except KeyError:
            pass
        try:
            self.bidSize = d["bidSize"]
        except KeyError:
            pass
        try:
            self.ask = d["ask"]
        except KeyError:
            pass
        try:
            self.askSize = d["askSize"]
        except KeyError:
            pass
        try:
            self.priceHint = d["priceHint"]
        except KeyError:
            pass
        try:
            self.vol_24hr = d["vol_24hr"]
        except KeyError:
            pass
        try:
            self.volAllCurrencies = d["volAllCurrencies"]
        except KeyError:
            pass
        try:
            self.fromcurrency = d["fromcurrency"]
        except KeyError:
            pass
        try:
            self.lastMarket = d["lastMarket"]
        except KeyError:
            pass
        try:
            self.circulatingSupply = d["circulatingSupply"]
        except KeyError:
            pass
        try:
            self.marketcap = d["marketcap"]
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if self.__field_bitmap0 & 2 == 2:
            out["price"] = self.price
        if self.__field_bitmap0 & 4 == 4:
            out["time"] = self.time
        if self.__field_bitmap0 & 8 == 8:
            out["currency"] = self.currency
        if self.__field_bitmap0 & 16 == 16:
            out["exchange"] = self.exchange
        if self.__field_bitmap0 & 32 == 32:
            out["quoteType"] = self.quoteType
        if self.__field_bitmap0 & 64 == 64:
            out["marketHours"] = self.marketHours
        if self.__field_bitmap0 & 128 == 128:
            out["changePercent"] = self.changePercent
        if self.__field_bitmap0 & 256 == 256:
            out["dayVolume"] = self.dayVolume
        if self.__field_bitmap0 & 512 == 512:
            out["dayHigh"] = self.dayHigh
        if self.__field_bitmap0 & 1024 == 1024:
            out["dayLow"] = self.dayLow
        if self.__field_bitmap0 & 2048 == 2048:
            out["change"] = self.change
        if self.__field_bitmap0 & 4096 == 4096:
            out["shortName"] = self.shortName
        if self.__field_bitmap0 & 8192 == 8192:
            out["expireDate"] = self.expireDate
        if self.__field_bitmap0 & 16384 == 16384:
            out["openPrice"] = self.openPrice
        if self.__field_bitmap0 & 32768 == 32768:
            out["previousClose"] = self.previousClose
        if self.__field_bitmap0 & 65536 == 65536:
            out["strikePrice"] = self.strikePrice
        if self.__field_bitmap0 & 131072 == 131072:
            out["underlyingSymbol"] = self.underlyingSymbol
        if self.__field_bitmap0 & 262144 == 262144:
            out["openInterest"] = self.openInterest
        if self.__field_bitmap0 & 524288 == 524288:
            out["optionsType"] = self.optionsType
        if self.__field_bitmap0 & 1048576 == 1048576:
            out["miniOption"] = self.miniOption
        if self.__field_bitmap0 & 2097152 == 2097152:
            out["lastSize"] = self.lastSize
        if self.__field_bitmap0 & 4194304 == 4194304:
            out["bid"] = self.bid
        if self.__field_bitmap0 & 8388608 == 8388608:
            out["bidSize"] = self.bidSize
        if self.__field_bitmap0 & 16777216 == 16777216:
            out["ask"] = self.ask
        if self.__field_bitmap0 & 33554432 == 33554432:
            out["askSize"] = self.askSize
        if self.__field_bitmap0 & 67108864 == 67108864:
            out["priceHint"] = self.priceHint
        if self.__field_bitmap0 & 134217728 == 134217728:
            out["vol_24hr"] = self.vol_24hr
        if self.__field_bitmap0 & 268435456 == 268435456:
            out["volAllCurrencies"] = self.volAllCurrencies
        if self.__field_bitmap0 & 536870912 == 536870912:
            out["fromcurrency"] = self.fromcurrency
        if self.__field_bitmap0 & 1073741824 == 1073741824:
            out["lastMarket"] = self.lastMarket
        if self.__field_bitmap0 & 2147483648 == 2147483648:
            out["circulatingSupply"] = self.circulatingSupply
        if self.__field_bitmap0 & 4294967296 == 4294967296:
            out["marketcap"] = self.marketcap

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if self.__field_bitmap0 & 2 == 2:
            out["price"] = self.price
        if self.__field_bitmap0 & 4 == 4:
            out["time"] = self.time
        if self.__field_bitmap0 & 8 == 8:
            out["currency"] = self.currency
        if self.__field_bitmap0 & 16 == 16:
            out["exchange"] = self.exchange
        if self.__field_bitmap0 & 32 == 32:
            out["quoteType"] = self.quoteType
        if self.__field_bitmap0 & 64 == 64:
            out["marketHours"] = self.marketHours
        if self.__field_bitmap0 & 128 == 128:
            out["changePercent"] = self.changePercent
        if self.__field_bitmap0 & 256 == 256:
            out["dayVolume"] = self.dayVolume
        if self.__field_bitmap0 & 512 == 512:
            out["dayHigh"] = self.dayHigh
        if self.__field_bitmap0 & 1024 == 1024:
            out["dayLow"] = self.dayLow
        if self.__field_bitmap0 & 2048 == 2048:
            out["change"] = self.change
        if self.__field_bitmap0 & 4096 == 4096:
            out["shortName"] = self.shortName
        if self.__field_bitmap0 & 8192 == 8192:
            out["expireDate"] = self.expireDate
        if self.__field_bitmap0 & 16384 == 16384:
            out["openPrice"] = self.openPrice
        if self.__field_bitmap0 & 32768 == 32768:
            out["previousClose"] = self.previousClose
        if self.__field_bitmap0 & 65536 == 65536:
            out["strikePrice"] = self.strikePrice
        if self.__field_bitmap0 & 131072 == 131072:
            out["underlyingSymbol"] = self.underlyingSymbol
        if self.__field_bitmap0 & 262144 == 262144:
            out["openInterest"] = self.openInterest
        if self.__field_bitmap0 & 524288 == 524288:
            out["optionsType"] = self.optionsType
        if self.__field_bitmap0 & 1048576 == 1048576:
            out["miniOption"] = self.miniOption
        if self.__field_bitmap0 & 2097152 == 2097152:
            out["lastSize"] = self.lastSize
        if self.__field_bitmap0 & 4194304 == 4194304:
            out["bid"] = self.bid
        if self.__field_bitmap0 & 8388608 == 8388608:
            out["bidSize"] = self.bidSize
        if self.__field_bitmap0 & 16777216 == 16777216:
            out["ask"] = self.ask
        if self.__field_bitmap0 & 33554432 == 33554432:
            out["askSize"] = self.askSize
        if self.__field_bitmap0 & 67108864 == 67108864:
            out["priceHint"] = self.priceHint
        if self.__field_bitmap0 & 134217728 == 134217728:
            out["vol_24hr"] = self.vol_24hr
        if self.__field_bitmap0 & 268435456 == 268435456:
            out["volAllCurrencies"] = self.volAllCurrencies
        if self.__field_bitmap0 & 536870912 == 536870912:
            out["fromcurrency"] = self.fromcurrency
        if self.__field_bitmap0 & 1073741824 == 1073741824:
            out["lastMarket"] = self.lastMarket
        if self.__field_bitmap0 & 2147483648 == 2147483648:
            out["circulatingSupply"] = self.circulatingSupply
        if self.__field_bitmap0 & 4294967296 == 4294967296:
            out["marketcap"] = self.marketcap

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'id', self.id
        yield 'price', self.price
        yield 'time', self.time
        yield 'currency', self.currency
        yield 'exchange', self.exchange
        yield 'quoteType', self.quoteType
        yield 'marketHours', self.marketHours
        yield 'changePercent', self.changePercent
        yield 'dayVolume', self.dayVolume
        yield 'dayHigh', self.dayHigh
        yield 'dayLow', self.dayLow
        yield 'change', self.change
        yield 'shortName', self.shortName
        yield 'expireDate', self.expireDate
        yield 'openPrice', self.openPrice
        yield 'previousClose', self.previousClose
        yield 'strikePrice', self.strikePrice
        yield 'underlyingSymbol', self.underlyingSymbol
        yield 'openInterest', self.openInterest
        yield 'optionsType', self.optionsType
        yield 'miniOption', self.miniOption
        yield 'lastSize', self.lastSize
        yield 'bid', self.bid
        yield 'bidSize', self.bidSize
        yield 'ask', self.ask
        yield 'askSize', self.askSize
        yield 'priceHint', self.priceHint
        yield 'vol_24hr', self.vol_24hr
        yield 'volAllCurrencies', self.volAllCurrencies
        yield 'fromcurrency', self.fromcurrency
        yield 'lastMarket', self.lastMarket
        yield 'circulatingSupply', self.circulatingSupply
        yield 'marketcap', self.marketcap

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'id'
        yield 'price'
        yield 'time'
        yield 'currency'
        yield 'exchange'
        yield 'quoteType'
        yield 'marketHours'
        yield 'changePercent'
        yield 'dayVolume'
        yield 'dayHigh'
        yield 'dayLow'
        yield 'change'
        yield 'shortName'
        yield 'expireDate'
        yield 'openPrice'
        yield 'previousClose'
        yield 'strikePrice'
        yield 'underlyingSymbol'
        yield 'openInterest'
        yield 'optionsType'
        yield 'miniOption'
        yield 'lastSize'
        yield 'bid'
        yield 'bidSize'
        yield 'ask'
        yield 'askSize'
        yield 'priceHint'
        yield 'vol_24hr'
        yield 'volAllCurrencies'
        yield 'fromcurrency'
        yield 'lastMarket'
        yield 'circulatingSupply'
        yield 'marketcap'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.id
        yield self.price
        yield self.time
        yield self.currency
        yield self.exchange
        yield self.quoteType
        yield self.marketHours
        yield self.changePercent
        yield self.dayVolume
        yield self.dayHigh
        yield self.dayLow
        yield self.change
        yield self.shortName
        yield self.expireDate
        yield self.openPrice
        yield self.previousClose
        yield self.strikePrice
        yield self.underlyingSymbol
        yield self.openInterest
        yield self.optionsType
        yield self.miniOption
        yield self.lastSize
        yield self.bid
        yield self.bidSize
        yield self.ask
        yield self.askSize
        yield self.priceHint
        yield self.vol_24hr
        yield self.volAllCurrencies
        yield self.fromcurrency
        yield self.lastMarket
        yield self.circulatingSupply
        yield self.marketcap

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.id = value
        yield setter
        def setter(value):
            self.price = value
        yield setter
        def setter(value):
            self.time = value
        yield setter
        def setter(value):
            self.currency = value
        yield setter
        def setter(value):
            self.exchange = value
        yield setter
        def setter(value):
            self.quoteType = value
        yield setter
        def setter(value):
            self.marketHours = value
        yield setter
        def setter(value):
            self.changePercent = value
        yield setter
        def setter(value):
            self.dayVolume = value
        yield setter
        def setter(value):
            self.dayHigh = value
        yield setter
        def setter(value):
            self.dayLow = value
        yield setter
        def setter(value):
            self.change = value
        yield setter
        def setter(value):
            self.shortName = value
        yield setter
        def setter(value):
            self.expireDate = value
        yield setter
        def setter(value):
            self.openPrice = value
        yield setter
        def setter(value):
            self.previousClose = value
        yield setter
        def setter(value):
            self.strikePrice = value
        yield setter
        def setter(value):
            self.underlyingSymbol = value
        yield setter
        def setter(value):
            self.openInterest = value
        yield setter
        def setter(value):
            self.optionsType = value
        yield setter
        def setter(value):
            self.miniOption = value
        yield setter
        def setter(value):
            self.lastSize = value
        yield setter
        def setter(value):
            self.bid = value
        yield setter
        def setter(value):
            self.bidSize = value
        yield setter
        def setter(value):
            self.ask = value
        yield setter
        def setter(value):
            self.askSize = value
        yield setter
        def setter(value):
            self.priceHint = value
        yield setter
        def setter(value):
            self.vol_24hr = value
        yield setter
        def setter(value):
            self.volAllCurrencies = value
        yield setter
        def setter(value):
            self.fromcurrency = value
        yield setter
        def setter(value):
            self.lastMarket = value
        yield setter
        def setter(value):
            self.circulatingSupply = value
        yield setter
        def setter(value):
            self.marketcap = value
        yield setter

    

class yatickerQuoteType(enum.IntEnum):
    NONE = _yatickerQuoteType_NONE
    ALTSYMBOL = _yatickerQuoteType_ALTSYMBOL
    HEARTBEAT = _yatickerQuoteType_HEARTBEAT
    EQUITY = _yatickerQuoteType_EQUITY
    INDEX = _yatickerQuoteType_INDEX
    MUTUALFUND = _yatickerQuoteType_MUTUALFUND
    MONEYMARKET = _yatickerQuoteType_MONEYMARKET
    OPTION = _yatickerQuoteType_OPTION
    CURRENCY = _yatickerQuoteType_CURRENCY
    WARRANT = _yatickerQuoteType_WARRANT
    BOND = _yatickerQuoteType_BOND
    FUTURE = _yatickerQuoteType_FUTURE
    ETF = _yatickerQuoteType_ETF
    COMMODITY = _yatickerQuoteType_COMMODITY
    ECNQUOTE = _yatickerQuoteType_ECNQUOTE
    CRYPTOCURRENCY = _yatickerQuoteType_CRYPTOCURRENCY
    INDICATOR = _yatickerQuoteType_INDICATOR
    INDUSTRY = _yatickerQuoteType_INDUSTRY
    

class yatickerOptionType(enum.IntEnum):
    CALL = _yatickerOptionType_CALL
    PUT = _yatickerOptionType_PUT
    

class yatickerMarketHoursType(enum.IntEnum):
    PRE_MARKET = _yatickerMarketHoursType_PRE_MARKET
    REGULAR_MARKET = _yatickerMarketHoursType_REGULAR_MARKET
    POST_MARKET = _yatickerMarketHoursType_POST_MARKET
    EXTENDED_HOURS_MARKET = _yatickerMarketHoursType_EXTENDED_HOURS_MARKET
    

    

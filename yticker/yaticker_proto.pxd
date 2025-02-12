from libc.stdint cimport *
from libc.string cimport *
from cpython.ref cimport PyObject

from pyrobuf_list cimport *
from pyrobuf_util cimport *

import orjson

cdef class yaticker:


    cdef str _id
    cpdef _id__reset(self)
    cdef float _price
    cpdef _price__reset(self)
    cdef int64_t _time
    cpdef _time__reset(self)
    cdef str _currency
    cpdef _currency__reset(self)
    cdef str _exchange
    cpdef _exchange__reset(self)
    cdef _yatickerQuoteType _quoteType
    cpdef _quoteType__reset(self)
    cdef _yatickerMarketHoursType _marketHours
    cpdef _marketHours__reset(self)
    cdef float _changePercent
    cpdef _changePercent__reset(self)
    cdef int64_t _dayVolume
    cpdef _dayVolume__reset(self)
    cdef float _dayHigh
    cpdef _dayHigh__reset(self)
    cdef float _dayLow
    cpdef _dayLow__reset(self)
    cdef float _change
    cpdef _change__reset(self)
    cdef str _shortName
    cpdef _shortName__reset(self)
    cdef int64_t _expireDate
    cpdef _expireDate__reset(self)
    cdef float _openPrice
    cpdef _openPrice__reset(self)
    cdef float _previousClose
    cpdef _previousClose__reset(self)
    cdef float _strikePrice
    cpdef _strikePrice__reset(self)
    cdef str _underlyingSymbol
    cpdef _underlyingSymbol__reset(self)
    cdef int64_t _openInterest
    cpdef _openInterest__reset(self)
    cdef _yatickerOptionType _optionsType
    cpdef _optionsType__reset(self)
    cdef int64_t _miniOption
    cpdef _miniOption__reset(self)
    cdef int64_t _lastSize
    cpdef _lastSize__reset(self)
    cdef float _bid
    cpdef _bid__reset(self)
    cdef int64_t _bidSize
    cpdef _bidSize__reset(self)
    cdef float _ask
    cpdef _ask__reset(self)
    cdef int64_t _askSize
    cpdef _askSize__reset(self)
    cdef int64_t _priceHint
    cpdef _priceHint__reset(self)
    cdef int64_t _vol_24hr
    cpdef _vol_24hr__reset(self)
    cdef int64_t _volAllCurrencies
    cpdef _volAllCurrencies__reset(self)
    cdef str _fromcurrency
    cpdef _fromcurrency__reset(self)
    cdef str _lastMarket
    cpdef _lastMarket__reset(self)
    cdef double _circulatingSupply
    cpdef _circulatingSupply__reset(self)
    cdef double _marketcap
    cpdef _marketcap__reset(self)


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef object _listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, yaticker other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, yaticker other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef void _clearfield(self, field_name)
    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef enum _yatickerQuoteType:
    _yatickerQuoteType_NONE = 0
    _yatickerQuoteType_ALTSYMBOL = 5
    _yatickerQuoteType_HEARTBEAT = 7
    _yatickerQuoteType_EQUITY = 8
    _yatickerQuoteType_INDEX = 9
    _yatickerQuoteType_MUTUALFUND = 11
    _yatickerQuoteType_MONEYMARKET = 12
    _yatickerQuoteType_OPTION = 13
    _yatickerQuoteType_CURRENCY = 14
    _yatickerQuoteType_WARRANT = 15
    _yatickerQuoteType_BOND = 17
    _yatickerQuoteType_FUTURE = 18
    _yatickerQuoteType_ETF = 20
    _yatickerQuoteType_COMMODITY = 23
    _yatickerQuoteType_ECNQUOTE = 28
    _yatickerQuoteType_CRYPTOCURRENCY = 41
    _yatickerQuoteType_INDICATOR = 42
    _yatickerQuoteType_INDUSTRY = 1000

cdef enum _yatickerOptionType:
    _yatickerOptionType_CALL = 0
    _yatickerOptionType_PUT = 1

cdef enum _yatickerMarketHoursType:
    _yatickerMarketHoursType_PRE_MARKET = 0
    _yatickerMarketHoursType_REGULAR_MARKET = 1
    _yatickerMarketHoursType_POST_MARKET = 2
    _yatickerMarketHoursType_EXTENDED_HOURS_MARKET = 3
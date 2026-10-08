
from libc.stdint cimport uint8_t, int8_t, int32_t, int64_t, uint32_t, uint64_t
from libc.string cimport memset, memcmp, memcpy
from libc.stdlib cimport realloc, free
from cpython.unicode cimport PyUnicode_DecodeUTF8

cdef enum:
    Y_OK = 0
    Y_ERR_WIRE = -1      # truncated / malformed wire data
    Y_ERR_REQUIRED = -2  # proto2 required field missing
    Y_ERR_NOMEM = -3
    Y_ERR_B64 = -4       # bad base64
    Y_ERR_JSON = -5      # envelope has no string "message"

cdef struct ystr:
    const uint8_t* p
    uint32_t n

# ---------------------------------------------------------------- enums
cdef enum qf_QuoteType:
    qf_QuoteType_NONE = 0
    qf_QuoteType_ALTSYMBOL = 5
    qf_QuoteType_HEARTBEAT = 7
    qf_QuoteType_EQUITY = 8
    qf_QuoteType_INDEX = 9
    qf_QuoteType_MUTUALFUND = 11
    qf_QuoteType_MONEYMARKET = 12
    qf_QuoteType_OPTION = 13
    qf_QuoteType_CURRENCY = 14
    qf_QuoteType_WARRANT = 15
    qf_QuoteType_BOND = 17
    qf_QuoteType_FUTURE = 18
    qf_QuoteType_ETF = 20
    qf_QuoteType_COMMODITY = 23
    qf_QuoteType_ECNQUOTE = 28
    qf_QuoteType_CRYPTOCURRENCY = 41
    qf_QuoteType_INDICATOR = 42
    qf_QuoteType_CUL_IDX = 43
    qf_QuoteType_CUL_SUB_IDX = 44
    qf_QuoteType_CUL_ASSET = 45
    qf_QuoteType_PRIVATE_COMPANY = 46
    qf_QuoteType_INDUSTRY = 1000

cdef enum qf_MarketHours:
    qf_MarketHours_PRE_MARKET = 0
    qf_MarketHours_REGULAR_MARKET = 1
    qf_MarketHours_POST_MARKET = 2
    qf_MarketHours_EXTENDED_HOURS_MARKET = 3
    qf_MarketHours_OVERNIGHT_MARKET = 4

cdef enum qf_OptionType:
    qf_OptionType_CALL = 0
    qf_OptionType_PUT = 1

cdef enum pm_Side:
    pm_Side_SIDE_UNSPECIFIED = 0
    pm_Side_BUY = 1
    pm_Side_SELL = 2

cdef enum pm_EventType:
    pm_EventType_EVENT_TYPE_UNSPECIFIED = 0
    pm_EventType_BOOK = 1
    pm_EventType_PRICE_CHANGE = 2
    pm_EventType_TICK_SIZE_CHANGE = 3
    pm_EventType_LAST_TRADE_PRICE = 4

# ---------------------------------------------------------------- structs
cdef struct qf_PricingData:
    uint64_t has
    ystr id
    float price
    int64_t time
    ystr currency
    ystr exchange
    int32_t quoteType
    int32_t marketHours
    float changePercent
    int64_t dayVolume
    float dayHigh
    float dayLow
    float change
    ystr shortName
    int64_t expireDate
    float openPrice
    float previousClose
    float strikePrice
    ystr underlyingSymbol
    int64_t openInterest
    int64_t optionsType
    int64_t miniOption
    int64_t lastSize
    float bid
    int64_t bidSize
    float ask
    int64_t askSize
    int64_t priceHint
    int64_t vol_24hr
    int64_t volAllCurrencies
    ystr fromcurrency
    ystr lastMarket
    double circulatingSupply
    double marketcap
    ystr components
    ystr indices[16]
    uint32_t indices_n
    uint32_t indices_dropped
    int64_t cmcRank
    ystr underlyingShortname
    float fiftyTwoWeekChange
    float fiftyTwoWeekChangePercent
    float latestAmountRaised
    int64_t latestFundingDate
    ystr latestShareClass
    float latestImpliedValuation
    float ytdReturn
    float qtdReturn
    float fullDayChange
    float fullDayChangePercent

cdef struct qf_StaticData:
    uint64_t has
    ystr id
    ystr displayName
    ystr currency
    ystr exchange
    float openPrice
    float closePrice
    float fiftytwoWkMovingAvgPrice
    float twohundredDataMovingAvgPrice

cdef struct qf_PriceUpdate:
    uint64_t has
    qf_PricingData pricingData

cdef struct qf_StaticUpdate:
    uint64_t has
    qf_StaticData staticData

cdef struct es_EarningSignals:
    uint64_t has
    ystr symbol
    int64_t dateTimeInMillis
    double epsEstimate
    double epsActual
    double epsSurprise
    double epsSurprisePercent

cdef struct pm_Order:
    uint64_t has
    ystr price
    ystr size

cdef struct pm_EventMessage:
    uint64_t has
    ystr id
    ystr ticker
    ystr slug
    ystr title
    ystr description

cdef struct pm_Order_vec:
    pm_Order* p
    uint32_t n
    uint32_t cap

cdef struct pm_BookEvent:
    uint64_t has
    int32_t eventType
    ystr assetId
    ystr market
    ystr timestamp
    ystr hash
    pm_Order_vec bids
    pm_Order_vec asks

cdef struct pm_PriceChange:
    uint64_t has
    ystr assetId
    ystr price
    ystr size
    int32_t side
    ystr hash
    ystr bestBid
    ystr bestAsk

cdef struct pm_PriceChange_vec:
    pm_PriceChange* p
    uint32_t n
    uint32_t cap

cdef struct pm_PriceChangeEvent:
    uint64_t has
    int32_t eventType
    ystr market
    pm_PriceChange_vec priceChanges
    ystr timestamp

cdef struct pm_TickSizeChangeEvent:
    uint64_t has
    int32_t eventType
    ystr assetId
    ystr market
    ystr oldTickSize
    ystr newTickSize
    ystr timestamp

cdef struct pm_LastTradePriceEvent:
    uint64_t has
    int32_t eventType
    ystr assetId
    ystr feeRateBps
    ystr market
    ystr price
    int32_t side
    ystr size
    ystr timestamp

cdef struct pm_MarketEvent:
    uint64_t has
    int32_t eventType
    pm_BookEvent bookEvent
    pm_PriceChangeEvent priceChangeEvent
    pm_TickSizeChangeEvent tickSizeChangeEvent
    pm_LastTradePriceEvent lastTradePriceEvent


# ---------------------------------------------------------------- errors
cdef inline object y_decode_error(int rc):
    if rc == Y_ERR_WIRE:
        return ValueError("malformed or truncated protobuf data")
    if rc == Y_ERR_REQUIRED:
        return ValueError("required protobuf field missing")
    if rc == Y_ERR_NOMEM:
        return MemoryError("out of memory while decoding")
    if rc == Y_ERR_B64:
        return ValueError("invalid base64 payload")
    if rc == Y_ERR_JSON:
        return ValueError("no string field 'message' in JSON envelope")
    return ValueError("decode error %d" % rc)

# ---------------------------------------------------------------- wire primitives
cdef inline int _varint(const uint8_t* b, size_t* pos, size_t end, uint64_t* out) noexcept nogil:
    cdef uint64_t r = 0
    cdef int shift = 0
    cdef size_t i = pos[0]
    cdef uint8_t c
    while i < end:
        c = b[i]
        i += 1
        r |= (<uint64_t>(c & 0x7F)) << shift
        if (c & 0x80) == 0:
            pos[0] = i
            out[0] = r
            return 0
        shift += 7
        if shift > 63:
            return -1
    return -1

cdef inline int64_t _zigzag(uint64_t v) noexcept nogil:
    return <int64_t>(v >> 1) ^ -(<int64_t>(v & 1))

cdef inline int _lenspan(const uint8_t* b, size_t* pos, size_t end, ystr* out) noexcept nogil:
    cdef uint64_t ln
    if _varint(b, pos, end, &ln) < 0:
        return -1
    if ln > <uint64_t>(end - pos[0]) or ln > <uint64_t>4294967295:
        return -1
    out.p = b + pos[0]
    out.n = <uint32_t>ln
    pos[0] += <size_t>ln
    return 0

cdef inline int _rd_f32(const uint8_t* b, size_t* pos, size_t end, float* out) noexcept nogil:
    cdef size_t p = pos[0]
    cdef uint32_t u
    if end - p < 4:
        return -1
    u = (<uint32_t>b[p]) | ((<uint32_t>b[p + 1]) << 8) | ((<uint32_t>b[p + 2]) << 16) | ((<uint32_t>b[p + 3]) << 24)
    memcpy(out, &u, 4)
    pos[0] = p + 4
    return 0

cdef inline int _rd_f64(const uint8_t* b, size_t* pos, size_t end, double* out) noexcept nogil:
    cdef size_t p = pos[0]
    cdef uint64_t u = 0
    cdef int k
    if end - p < 8:
        return -1
    for k in range(8):
        u |= (<uint64_t>b[p + k]) << (8 * k)
    memcpy(out, &u, 8)
    pos[0] = p + 8
    return 0

cdef inline int _skip(uint32_t wt, const uint8_t* b, size_t* pos, size_t end) noexcept nogil:
    cdef uint64_t tmp
    cdef ystr s
    if wt == 0:
        return _varint(b, pos, end, &tmp)
    if wt == 1:
        if end - pos[0] < 8:
            return -1
        pos[0] += 8
        return 0
    if wt == 2:
        return _lenspan(b, pos, end, &s)
    if wt == 5:
        if end - pos[0] < 4:
            return -1
        pos[0] += 4
        return 0
    return -1  # groups (3/4) and invalid wire types

cdef inline bint _has(uint64_t mask, int bit) noexcept nogil:
    return <bint>((mask >> bit) & 1)

cdef inline object _s(ystr s):
    return PyUnicode_DecodeUTF8(<const char*>s.p, <Py_ssize_t>s.n, b"replace")

# ---------------------------------------------------------------- base64 (std + urlsafe; JSON "\/" tolerated)
cdef inline int _b64val(uint8_t c) noexcept nogil:
    if c >= 65 and c <= 90:
        return c - 65
    if c >= 97 and c <= 122:
        return c - 71
    if c >= 48 and c <= 57:
        return c + 4
    if c == 43 or c == 45:
        return 62
    if c == 47 or c == 95:
        return 63
    return -1

cdef inline Py_ssize_t y_b64_decode(const uint8_t* src, size_t n, uint8_t* dst) noexcept nogil:
    cdef size_t i = 0
    cdef size_t o = 0
    cdef uint32_t acc = 0
    cdef int bits = 0
    cdef int val
    cdef uint8_t c
    while i < n:
        c = src[i]
        i += 1
        if c == 0x3D:  # '='
            break
        if c == 0x5C:  # JSON escape: only "\/" is legal inside base64
            if i >= n or src[i] != 0x2F:
                return -1
            i += 1
            c = 0x2F
        val = _b64val(c)
        if val < 0:
            return -1
        acc = (acc << 6) | <uint32_t>val
        bits += 6
        if bits >= 8:
            bits -= 8
            dst[o] = <uint8_t>((acc >> bits) & 0xFF)
            o += 1
            acc &= (<uint32_t>1 << bits) - 1
    return <Py_ssize_t>o

# ---------------------------------------------------------------- tiny JSON string-value finder
cdef inline int y_json_str_value(const uint8_t* b, size_t n, const char* key, size_t klen, ystr* out) noexcept nogil:
    cdef size_t i = 0
    cdef size_t j, start
    while i < n:
        if b[i] != 0x22:
            i += 1
            continue
        if n - i >= klen + 2 and memcmp(b + i + 1, key, klen) == 0 and b[i + 1 + klen] == 0x22:
            j = i + klen + 2
            while j < n and (b[j] == 0x20 or b[j] == 0x09 or b[j] == 0x0A or b[j] == 0x0D):
                j += 1
            if j < n and b[j] == 0x3A:  # ':'
                j += 1
                while j < n and (b[j] == 0x20 or b[j] == 0x09 or b[j] == 0x0A or b[j] == 0x0D):
                    j += 1
                if j >= n or b[j] != 0x22:
                    return Y_ERR_JSON
                j += 1
                start = j
                while j < n and b[j] != 0x22:
                    if b[j] == 0x5C:
                        j += 1
                    j += 1
                if j >= n:
                    return Y_ERR_JSON
                out.p = b + start
                out.n = <uint32_t>(j - start)
                return Y_OK
                
        i += 1
        while i < n and b[i] != 0x22:
            if b[i] == 0x5C:
                i += 1
            i += 1
        i += 1
    return Y_ERR_JSON

# ---------------------------------------------------------------- generated message code
cdef inline int qf_PricingData_decode_into(const uint8_t* b, size_t n, qf_PricingData* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # id
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.id = s
            o.has |= (<uint64_t>1) << 0
        elif key == 21:  # price
            if _rd_f32(b, &pos, n, &o.price) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 1
        elif key == 24:  # time
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.time = _zigzag(v)
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # currency
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.currency = s
            o.has |= (<uint64_t>1) << 3
        elif key == 42:  # exchange
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.exchange = s
            o.has |= (<uint64_t>1) << 4
        elif key == 48:  # quoteType (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.quoteType = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 5
        elif key == 56:  # marketHours (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.marketHours = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 6
        elif key == 69:  # changePercent
            if _rd_f32(b, &pos, n, &o.changePercent) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 7
        elif key == 72:  # dayVolume
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.dayVolume = _zigzag(v)
            o.has |= (<uint64_t>1) << 8
        elif key == 85:  # dayHigh
            if _rd_f32(b, &pos, n, &o.dayHigh) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 9
        elif key == 93:  # dayLow
            if _rd_f32(b, &pos, n, &o.dayLow) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 10
        elif key == 101:  # change
            if _rd_f32(b, &pos, n, &o.change) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 11
        elif key == 106:  # shortName
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.shortName = s
            o.has |= (<uint64_t>1) << 12
        elif key == 112:  # expireDate
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.expireDate = _zigzag(v)
            o.has |= (<uint64_t>1) << 13
        elif key == 125:  # openPrice
            if _rd_f32(b, &pos, n, &o.openPrice) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 14
        elif key == 133:  # previousClose
            if _rd_f32(b, &pos, n, &o.previousClose) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 15
        elif key == 141:  # strikePrice
            if _rd_f32(b, &pos, n, &o.strikePrice) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 16
        elif key == 146:  # underlyingSymbol
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.underlyingSymbol = s
            o.has |= (<uint64_t>1) << 17
        elif key == 152:  # openInterest
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.openInterest = _zigzag(v)
            o.has |= (<uint64_t>1) << 18
        elif key == 160:  # optionsType
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.optionsType = _zigzag(v)
            o.has |= (<uint64_t>1) << 19
        elif key == 168:  # miniOption
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.miniOption = _zigzag(v)
            o.has |= (<uint64_t>1) << 20
        elif key == 176:  # lastSize
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.lastSize = _zigzag(v)
            o.has |= (<uint64_t>1) << 21
        elif key == 189:  # bid
            if _rd_f32(b, &pos, n, &o.bid) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 22
        elif key == 192:  # bidSize
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.bidSize = _zigzag(v)
            o.has |= (<uint64_t>1) << 23
        elif key == 205:  # ask
            if _rd_f32(b, &pos, n, &o.ask) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 24
        elif key == 208:  # askSize
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.askSize = _zigzag(v)
            o.has |= (<uint64_t>1) << 25
        elif key == 216:  # priceHint
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.priceHint = _zigzag(v)
            o.has |= (<uint64_t>1) << 26
        elif key == 224:  # vol_24hr
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.vol_24hr = _zigzag(v)
            o.has |= (<uint64_t>1) << 27
        elif key == 232:  # volAllCurrencies
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.volAllCurrencies = _zigzag(v)
            o.has |= (<uint64_t>1) << 28
        elif key == 242:  # fromcurrency
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.fromcurrency = s
            o.has |= (<uint64_t>1) << 29
        elif key == 250:  # lastMarket
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.lastMarket = s
            o.has |= (<uint64_t>1) << 30
        elif key == 257:  # circulatingSupply
            if _rd_f64(b, &pos, n, &o.circulatingSupply) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 31
        elif key == 265:  # marketcap
            if _rd_f64(b, &pos, n, &o.marketcap) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 32
        elif key == 274:  # components
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.components = s
            o.has |= (<uint64_t>1) << 33
        elif key == 282:  # indices[]
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            if o.indices_n < 16:
                o.indices[o.indices_n] = s
                o.indices_n += 1
            else:
                o.indices_dropped += 1
            o.has |= (<uint64_t>1) << 34
        elif key == 288:  # cmcRank
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.cmcRank = _zigzag(v)
            o.has |= (<uint64_t>1) << 35
        elif key == 298:  # underlyingShortname
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.underlyingShortname = s
            o.has |= (<uint64_t>1) << 36
        elif key == 309:  # fiftyTwoWeekChange
            if _rd_f32(b, &pos, n, &o.fiftyTwoWeekChange) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 37
        elif key == 317:  # fiftyTwoWeekChangePercent
            if _rd_f32(b, &pos, n, &o.fiftyTwoWeekChangePercent) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 38
        elif key == 325:  # latestAmountRaised
            if _rd_f32(b, &pos, n, &o.latestAmountRaised) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 39
        elif key == 328:  # latestFundingDate
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.latestFundingDate = _zigzag(v)
            o.has |= (<uint64_t>1) << 40
        elif key == 338:  # latestShareClass
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.latestShareClass = s
            o.has |= (<uint64_t>1) << 41
        elif key == 349:  # latestImpliedValuation
            if _rd_f32(b, &pos, n, &o.latestImpliedValuation) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 42
        elif key == 357:  # ytdReturn
            if _rd_f32(b, &pos, n, &o.ytdReturn) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 43
        elif key == 365:  # qtdReturn
            if _rd_f32(b, &pos, n, &o.qtdReturn) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 44
        elif key == 373:  # fullDayChange
            if _rd_f32(b, &pos, n, &o.fullDayChange) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 45
        elif key == 381:  # fullDayChangePercent
            if _rd_f32(b, &pos, n, &o.fullDayChangePercent) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 46
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    return Y_OK


cdef inline int qf_PricingData_decode(const uint8_t* b, size_t n, qf_PricingData* o) noexcept nogil:
    memset(o, 0, sizeof(qf_PricingData))
    return qf_PricingData_decode_into(b, n, o)

cdef inline dict qf_PricingData_to_dict(const qf_PricingData* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["id"] = _s(o.id)
    if _has(o.has, 1):
        d["price"] = o.price
    if _has(o.has, 2):
        d["time"] = o.time
    if _has(o.has, 3):
        d["currency"] = _s(o.currency)
    if _has(o.has, 4):
        d["exchange"] = _s(o.exchange)
    if _has(o.has, 5):
        d["quoteType"] = o.quoteType
    if _has(o.has, 6):
        d["marketHours"] = o.marketHours
    if _has(o.has, 7):
        d["changePercent"] = o.changePercent
    if _has(o.has, 8):
        d["dayVolume"] = o.dayVolume
    if _has(o.has, 9):
        d["dayHigh"] = o.dayHigh
    if _has(o.has, 10):
        d["dayLow"] = o.dayLow
    if _has(o.has, 11):
        d["change"] = o.change
    if _has(o.has, 12):
        d["shortName"] = _s(o.shortName)
    if _has(o.has, 13):
        d["expireDate"] = o.expireDate
    if _has(o.has, 14):
        d["openPrice"] = o.openPrice
    if _has(o.has, 15):
        d["previousClose"] = o.previousClose
    if _has(o.has, 16):
        d["strikePrice"] = o.strikePrice
    if _has(o.has, 17):
        d["underlyingSymbol"] = _s(o.underlyingSymbol)
    if _has(o.has, 18):
        d["openInterest"] = o.openInterest
    if _has(o.has, 19):
        d["optionsType"] = o.optionsType
    if _has(o.has, 20):
        d["miniOption"] = o.miniOption
    if _has(o.has, 21):
        d["lastSize"] = o.lastSize
    if _has(o.has, 22):
        d["bid"] = o.bid
    if _has(o.has, 23):
        d["bidSize"] = o.bidSize
    if _has(o.has, 24):
        d["ask"] = o.ask
    if _has(o.has, 25):
        d["askSize"] = o.askSize
    if _has(o.has, 26):
        d["priceHint"] = o.priceHint
    if _has(o.has, 27):
        d["vol_24hr"] = o.vol_24hr
    if _has(o.has, 28):
        d["volAllCurrencies"] = o.volAllCurrencies
    if _has(o.has, 29):
        d["fromcurrency"] = _s(o.fromcurrency)
    if _has(o.has, 30):
        d["lastMarket"] = _s(o.lastMarket)
    if _has(o.has, 31):
        d["circulatingSupply"] = o.circulatingSupply
    if _has(o.has, 32):
        d["marketcap"] = o.marketcap
    if _has(o.has, 33):
        d["components"] = _s(o.components)
    if _has(o.has, 34):
        l = []
        for i in range(o.indices_n):
            l.append(_s(o.indices[i]))
        d["indices"] = l
    if _has(o.has, 35):
        d["cmcRank"] = o.cmcRank
    if _has(o.has, 36):
        d["underlyingShortname"] = _s(o.underlyingShortname)
    if _has(o.has, 37):
        d["fiftyTwoWeekChange"] = o.fiftyTwoWeekChange
    if _has(o.has, 38):
        d["fiftyTwoWeekChangePercent"] = o.fiftyTwoWeekChangePercent
    if _has(o.has, 39):
        d["latestAmountRaised"] = o.latestAmountRaised
    if _has(o.has, 40):
        d["latestFundingDate"] = o.latestFundingDate
    if _has(o.has, 41):
        d["latestShareClass"] = _s(o.latestShareClass)
    if _has(o.has, 42):
        d["latestImpliedValuation"] = o.latestImpliedValuation
    if _has(o.has, 43):
        d["ytdReturn"] = o.ytdReturn
    if _has(o.has, 44):
        d["qtdReturn"] = o.qtdReturn
    if _has(o.has, 45):
        d["fullDayChange"] = o.fullDayChange
    if _has(o.has, 46):
        d["fullDayChangePercent"] = o.fullDayChangePercent
    return d

cdef inline int qf_StaticData_decode_into(const uint8_t* b, size_t n, qf_StaticData* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # id
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.id = s
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # displayName
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.displayName = s
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # currency
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.currency = s
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # exchange
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.exchange = s
            o.has |= (<uint64_t>1) << 3
        elif key == 45:  # openPrice
            if _rd_f32(b, &pos, n, &o.openPrice) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 4
        elif key == 53:  # closePrice
            if _rd_f32(b, &pos, n, &o.closePrice) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 5
        elif key == 61:  # fiftytwoWkMovingAvgPrice
            if _rd_f32(b, &pos, n, &o.fiftytwoWkMovingAvgPrice) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 6
        elif key == 69:  # twohundredDataMovingAvgPrice
            if _rd_f32(b, &pos, n, &o.twohundredDataMovingAvgPrice) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 7
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    return Y_OK


cdef inline int qf_StaticData_decode(const uint8_t* b, size_t n, qf_StaticData* o) noexcept nogil:
    memset(o, 0, sizeof(qf_StaticData))
    return qf_StaticData_decode_into(b, n, o)

cdef inline dict qf_StaticData_to_dict(const qf_StaticData* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["id"] = _s(o.id)
    if _has(o.has, 1):
        d["displayName"] = _s(o.displayName)
    if _has(o.has, 2):
        d["currency"] = _s(o.currency)
    if _has(o.has, 3):
        d["exchange"] = _s(o.exchange)
    if _has(o.has, 4):
        d["openPrice"] = o.openPrice
    if _has(o.has, 5):
        d["closePrice"] = o.closePrice
    if _has(o.has, 6):
        d["fiftytwoWkMovingAvgPrice"] = o.fiftytwoWkMovingAvgPrice
    if _has(o.has, 7):
        d["twohundredDataMovingAvgPrice"] = o.twohundredDataMovingAvgPrice
    return d

cdef inline int qf_PriceUpdate_decode_into(const uint8_t* b, size_t n, qf_PriceUpdate* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # pricingData (message)
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            rc = qf_PricingData_decode_into(<const uint8_t*>s.p, s.n, &o.pricingData)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 0
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    return Y_OK


cdef inline int qf_PriceUpdate_decode(const uint8_t* b, size_t n, qf_PriceUpdate* o) noexcept nogil:
    memset(o, 0, sizeof(qf_PriceUpdate))
    return qf_PriceUpdate_decode_into(b, n, o)

cdef inline dict qf_PriceUpdate_to_dict(const qf_PriceUpdate* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["pricingData"] = qf_PricingData_to_dict(&o.pricingData)
    return d

cdef inline int qf_StaticUpdate_decode_into(const uint8_t* b, size_t n, qf_StaticUpdate* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # staticData (message)
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            rc = qf_StaticData_decode_into(<const uint8_t*>s.p, s.n, &o.staticData)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 0
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    return Y_OK


cdef inline int qf_StaticUpdate_decode(const uint8_t* b, size_t n, qf_StaticUpdate* o) noexcept nogil:
    memset(o, 0, sizeof(qf_StaticUpdate))
    return qf_StaticUpdate_decode_into(b, n, o)

cdef inline dict qf_StaticUpdate_to_dict(const qf_StaticUpdate* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["staticData"] = qf_StaticData_to_dict(&o.staticData)
    return d

cdef inline int es_EarningSignals_decode_into(const uint8_t* b, size_t n, es_EarningSignals* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # symbol
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.symbol = s
            o.has |= (<uint64_t>1) << 0
        elif key == 16:  # dateTimeInMillis
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.dateTimeInMillis = _zigzag(v)
            o.has |= (<uint64_t>1) << 1
        elif key == 25:  # epsEstimate
            if _rd_f64(b, &pos, n, &o.epsEstimate) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 2
        elif key == 33:  # epsActual
            if _rd_f64(b, &pos, n, &o.epsActual) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 3
        elif key == 41:  # epsSurprise
            if _rd_f64(b, &pos, n, &o.epsSurprise) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 4
        elif key == 49:  # epsSurprisePercent
            if _rd_f64(b, &pos, n, &o.epsSurprisePercent) < 0:
                return Y_ERR_WIRE
            o.has |= (<uint64_t>1) << 5
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    if (o.has & <uint64_t>3) != <uint64_t>3:
        return Y_ERR_REQUIRED
    return Y_OK


cdef inline int es_EarningSignals_decode(const uint8_t* b, size_t n, es_EarningSignals* o) noexcept nogil:
    memset(o, 0, sizeof(es_EarningSignals))
    return es_EarningSignals_decode_into(b, n, o)

cdef inline dict es_EarningSignals_to_dict(const es_EarningSignals* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["symbol"] = _s(o.symbol)
    if _has(o.has, 1):
        d["dateTimeInMillis"] = o.dateTimeInMillis
    if _has(o.has, 2):
        d["epsEstimate"] = o.epsEstimate
    if _has(o.has, 3):
        d["epsActual"] = o.epsActual
    if _has(o.has, 4):
        d["epsSurprise"] = o.epsSurprise
    if _has(o.has, 5):
        d["epsSurprisePercent"] = o.epsSurprisePercent
    return d

cdef inline int pm_Order_decode_into(const uint8_t* b, size_t n, pm_Order* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # price
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.price = s
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # size
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.size = s
            o.has |= (<uint64_t>1) << 1
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    return Y_OK


cdef inline int pm_Order_decode(const uint8_t* b, size_t n, pm_Order* o) noexcept nogil:
    memset(o, 0, sizeof(pm_Order))
    return pm_Order_decode_into(b, n, o)

cdef inline dict pm_Order_to_dict(const pm_Order* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["price"] = _s(o.price)
    if _has(o.has, 1):
        d["size"] = _s(o.size)
    return d

cdef inline int pm_EventMessage_decode_into(const uint8_t* b, size_t n, pm_EventMessage* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # id
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.id = s
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # ticker
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.ticker = s
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # slug
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.slug = s
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # title
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.title = s
            o.has |= (<uint64_t>1) << 3
        elif key == 42:  # description
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.description = s
            o.has |= (<uint64_t>1) << 4
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    return Y_OK


cdef inline int pm_EventMessage_decode(const uint8_t* b, size_t n, pm_EventMessage* o) noexcept nogil:
    memset(o, 0, sizeof(pm_EventMessage))
    return pm_EventMessage_decode_into(b, n, o)

cdef inline dict pm_EventMessage_to_dict(const pm_EventMessage* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["id"] = _s(o.id)
    if _has(o.has, 1):
        d["ticker"] = _s(o.ticker)
    if _has(o.has, 2):
        d["slug"] = _s(o.slug)
    if _has(o.has, 3):
        d["title"] = _s(o.title)
    if _has(o.has, 4):
        d["description"] = _s(o.description)
    return d


cdef inline pm_Order* pm_Order_vec_push(pm_Order_vec* v) noexcept nogil:
    cdef pm_Order* np
    cdef uint32_t ncap
    if v.n == v.cap:
        ncap = 8 if v.cap == 0 else v.cap * 2
        np = <pm_Order*>realloc(v.p, ncap * sizeof(pm_Order))
        if np == NULL:
            return NULL
        v.p = np
        v.cap = ncap
    memset(&v.p[v.n], 0, sizeof(pm_Order))
    v.n += 1
    return &v.p[v.n - 1]

cdef inline int pm_BookEvent_decode_into(const uint8_t* b, size_t n, pm_BookEvent* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    cdef pm_Order* el_Order
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 8:  # eventType (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.eventType = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # assetId
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.assetId = s
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # market
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.market = s
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # timestamp
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.timestamp = s
            o.has |= (<uint64_t>1) << 3
        elif key == 42:  # hash
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.hash = s
            o.has |= (<uint64_t>1) << 4
        elif key == 50:  # bids[]
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            el_Order = pm_Order_vec_push(&o.bids)
            if el_Order == NULL:
                return Y_ERR_NOMEM
            rc = pm_Order_decode_into(<const uint8_t*>s.p, s.n, el_Order)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 5
        elif key == 58:  # asks[]
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            el_Order = pm_Order_vec_push(&o.asks)
            if el_Order == NULL:
                return Y_ERR_NOMEM
            rc = pm_Order_decode_into(<const uint8_t*>s.p, s.n, el_Order)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 6
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    if (o.has & <uint64_t>1) != <uint64_t>1:
        return Y_ERR_REQUIRED
    return Y_OK


cdef inline int pm_BookEvent_decode(const uint8_t* b, size_t n, pm_BookEvent* o) noexcept nogil:
    memset(o, 0, sizeof(pm_BookEvent))
    return pm_BookEvent_decode_into(b, n, o)

cdef inline void pm_BookEvent_free(pm_BookEvent* o) noexcept nogil:
    if o.bids.p != NULL:
        free(o.bids.p)
    o.bids.p = NULL
    o.bids.n = 0
    o.bids.cap = 0
    if o.asks.p != NULL:
        free(o.asks.p)
    o.asks.p = NULL
    o.asks.n = 0
    o.asks.cap = 0

cdef inline dict pm_BookEvent_to_dict(const pm_BookEvent* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["eventType"] = o.eventType
    if _has(o.has, 1):
        d["assetId"] = _s(o.assetId)
    if _has(o.has, 2):
        d["market"] = _s(o.market)
    if _has(o.has, 3):
        d["timestamp"] = _s(o.timestamp)
    if _has(o.has, 4):
        d["hash"] = _s(o.hash)
    if _has(o.has, 5):
        l = []
        for i in range(o.bids.n):
            l.append(pm_Order_to_dict(&o.bids.p[i]))
        d["bids"] = l
    if _has(o.has, 6):
        l = []
        for i in range(o.asks.n):
            l.append(pm_Order_to_dict(&o.asks.p[i]))
        d["asks"] = l
    return d

cdef inline int pm_PriceChange_decode_into(const uint8_t* b, size_t n, pm_PriceChange* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 10:  # assetId
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.assetId = s
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # price
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.price = s
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # size
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.size = s
            o.has |= (<uint64_t>1) << 2
        elif key == 32:  # side (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.side = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 3
        elif key == 42:  # hash
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.hash = s
            o.has |= (<uint64_t>1) << 4
        elif key == 50:  # bestBid
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.bestBid = s
            o.has |= (<uint64_t>1) << 5
        elif key == 58:  # bestAsk
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.bestAsk = s
            o.has |= (<uint64_t>1) << 6
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    return Y_OK


cdef inline int pm_PriceChange_decode(const uint8_t* b, size_t n, pm_PriceChange* o) noexcept nogil:
    memset(o, 0, sizeof(pm_PriceChange))
    return pm_PriceChange_decode_into(b, n, o)

cdef inline dict pm_PriceChange_to_dict(const pm_PriceChange* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["assetId"] = _s(o.assetId)
    if _has(o.has, 1):
        d["price"] = _s(o.price)
    if _has(o.has, 2):
        d["size"] = _s(o.size)
    if _has(o.has, 3):
        d["side"] = o.side
    if _has(o.has, 4):
        d["hash"] = _s(o.hash)
    if _has(o.has, 5):
        d["bestBid"] = _s(o.bestBid)
    if _has(o.has, 6):
        d["bestAsk"] = _s(o.bestAsk)
    return d


cdef inline pm_PriceChange* pm_PriceChange_vec_push(pm_PriceChange_vec* v) noexcept nogil:
    cdef pm_PriceChange* np
    cdef uint32_t ncap
    if v.n == v.cap:
        ncap = 8 if v.cap == 0 else v.cap * 2
        np = <pm_PriceChange*>realloc(v.p, ncap * sizeof(pm_PriceChange))
        if np == NULL:
            return NULL
        v.p = np
        v.cap = ncap
    memset(&v.p[v.n], 0, sizeof(pm_PriceChange))
    v.n += 1
    return &v.p[v.n - 1]

cdef inline int pm_PriceChangeEvent_decode_into(const uint8_t* b, size_t n, pm_PriceChangeEvent* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    cdef pm_PriceChange* el_PriceChange
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 8:  # eventType (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.eventType = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # market
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.market = s
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # priceChanges[]
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            el_PriceChange = pm_PriceChange_vec_push(&o.priceChanges)
            if el_PriceChange == NULL:
                return Y_ERR_NOMEM
            rc = pm_PriceChange_decode_into(<const uint8_t*>s.p, s.n, el_PriceChange)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # timestamp
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.timestamp = s
            o.has |= (<uint64_t>1) << 3
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    if (o.has & <uint64_t>1) != <uint64_t>1:
        return Y_ERR_REQUIRED
    return Y_OK


cdef inline int pm_PriceChangeEvent_decode(const uint8_t* b, size_t n, pm_PriceChangeEvent* o) noexcept nogil:
    memset(o, 0, sizeof(pm_PriceChangeEvent))
    return pm_PriceChangeEvent_decode_into(b, n, o)

cdef inline void pm_PriceChangeEvent_free(pm_PriceChangeEvent* o) noexcept nogil:
    if o.priceChanges.p != NULL:
        free(o.priceChanges.p)
    o.priceChanges.p = NULL
    o.priceChanges.n = 0
    o.priceChanges.cap = 0

cdef inline dict pm_PriceChangeEvent_to_dict(const pm_PriceChangeEvent* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["eventType"] = o.eventType
    if _has(o.has, 1):
        d["market"] = _s(o.market)
    if _has(o.has, 2):
        l = []
        for i in range(o.priceChanges.n):
            l.append(pm_PriceChange_to_dict(&o.priceChanges.p[i]))
        d["priceChanges"] = l
    if _has(o.has, 3):
        d["timestamp"] = _s(o.timestamp)
    return d

cdef inline int pm_TickSizeChangeEvent_decode_into(const uint8_t* b, size_t n, pm_TickSizeChangeEvent* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 8:  # eventType (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.eventType = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # assetId
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.assetId = s
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # market
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.market = s
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # oldTickSize
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.oldTickSize = s
            o.has |= (<uint64_t>1) << 3
        elif key == 42:  # newTickSize
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.newTickSize = s
            o.has |= (<uint64_t>1) << 4
        elif key == 50:  # timestamp
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.timestamp = s
            o.has |= (<uint64_t>1) << 5
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    if (o.has & <uint64_t>1) != <uint64_t>1:
        return Y_ERR_REQUIRED
    return Y_OK


cdef inline int pm_TickSizeChangeEvent_decode(const uint8_t* b, size_t n, pm_TickSizeChangeEvent* o) noexcept nogil:
    memset(o, 0, sizeof(pm_TickSizeChangeEvent))
    return pm_TickSizeChangeEvent_decode_into(b, n, o)

cdef inline dict pm_TickSizeChangeEvent_to_dict(const pm_TickSizeChangeEvent* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["eventType"] = o.eventType
    if _has(o.has, 1):
        d["assetId"] = _s(o.assetId)
    if _has(o.has, 2):
        d["market"] = _s(o.market)
    if _has(o.has, 3):
        d["oldTickSize"] = _s(o.oldTickSize)
    if _has(o.has, 4):
        d["newTickSize"] = _s(o.newTickSize)
    if _has(o.has, 5):
        d["timestamp"] = _s(o.timestamp)
    return d

cdef inline int pm_LastTradePriceEvent_decode_into(const uint8_t* b, size_t n, pm_LastTradePriceEvent* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 8:  # eventType (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.eventType = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # assetId
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.assetId = s
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # feeRateBps
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.feeRateBps = s
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # market
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.market = s
            o.has |= (<uint64_t>1) << 3
        elif key == 42:  # price
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.price = s
            o.has |= (<uint64_t>1) << 4
        elif key == 48:  # side (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.side = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 5
        elif key == 58:  # size
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.size = s
            o.has |= (<uint64_t>1) << 6
        elif key == 66:  # timestamp
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            o.timestamp = s
            o.has |= (<uint64_t>1) << 7
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    if (o.has & <uint64_t>1) != <uint64_t>1:
        return Y_ERR_REQUIRED
    return Y_OK


cdef inline int pm_LastTradePriceEvent_decode(const uint8_t* b, size_t n, pm_LastTradePriceEvent* o) noexcept nogil:
    memset(o, 0, sizeof(pm_LastTradePriceEvent))
    return pm_LastTradePriceEvent_decode_into(b, n, o)

cdef inline dict pm_LastTradePriceEvent_to_dict(const pm_LastTradePriceEvent* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["eventType"] = o.eventType
    if _has(o.has, 1):
        d["assetId"] = _s(o.assetId)
    if _has(o.has, 2):
        d["feeRateBps"] = _s(o.feeRateBps)
    if _has(o.has, 3):
        d["market"] = _s(o.market)
    if _has(o.has, 4):
        d["price"] = _s(o.price)
    if _has(o.has, 5):
        d["side"] = o.side
    if _has(o.has, 6):
        d["size"] = _s(o.size)
    if _has(o.has, 7):
        d["timestamp"] = _s(o.timestamp)
    return d

cdef inline int pm_MarketEvent_decode_into(const uint8_t* b, size_t n, pm_MarketEvent* o) noexcept nogil:
    cdef size_t pos = 0
    cdef uint64_t key, v
    cdef ystr s
    cdef int rc
    cdef int32_t e32
    while pos < n:
        if _varint(b, &pos, n, &key) < 0:
            return Y_ERR_WIRE
        if key >> 32:
            return Y_ERR_WIRE
        if key == 8:  # eventType (enum)
            if _varint(b, &pos, n, &v) < 0:
                return Y_ERR_WIRE
            o.eventType = <int32_t>(<uint32_t>v)
            o.has |= (<uint64_t>1) << 0
        elif key == 18:  # bookEvent (message)
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            rc = pm_BookEvent_decode_into(<const uint8_t*>s.p, s.n, &o.bookEvent)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 1
        elif key == 26:  # priceChangeEvent (message)
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            rc = pm_PriceChangeEvent_decode_into(<const uint8_t*>s.p, s.n, &o.priceChangeEvent)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 2
        elif key == 34:  # tickSizeChangeEvent (message)
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            rc = pm_TickSizeChangeEvent_decode_into(<const uint8_t*>s.p, s.n, &o.tickSizeChangeEvent)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 3
        elif key == 42:  # lastTradePriceEvent (message)
            if _lenspan(b, &pos, n, &s) < 0:
                return Y_ERR_WIRE
            rc = pm_LastTradePriceEvent_decode_into(<const uint8_t*>s.p, s.n, &o.lastTradePriceEvent)
            if rc < 0:
                return rc
            o.has |= (<uint64_t>1) << 4
        else:
            if (key >> 3) == 0:
                return Y_ERR_WIRE
            if _skip(<uint32_t>(key & 7), b, &pos, n) < 0:
                return Y_ERR_WIRE
    if (o.has & <uint64_t>1) != <uint64_t>1:
        return Y_ERR_REQUIRED
    return Y_OK


cdef inline int pm_MarketEvent_decode(const uint8_t* b, size_t n, pm_MarketEvent* o) noexcept nogil:
    memset(o, 0, sizeof(pm_MarketEvent))
    return pm_MarketEvent_decode_into(b, n, o)

cdef inline void pm_MarketEvent_free(pm_MarketEvent* o) noexcept nogil:
    pm_BookEvent_free(&o.bookEvent)
    pm_PriceChangeEvent_free(&o.priceChangeEvent)

cdef inline dict pm_MarketEvent_to_dict(const pm_MarketEvent* o):
    cdef dict d = {}
    cdef list l
    cdef uint32_t i
    if _has(o.has, 0):
        d["eventType"] = o.eventType
    if _has(o.has, 1):
        d["bookEvent"] = pm_BookEvent_to_dict(&o.bookEvent)
    if _has(o.has, 2):
        d["priceChangeEvent"] = pm_PriceChangeEvent_to_dict(&o.priceChangeEvent)
    if _has(o.has, 3):
        d["tickSizeChangeEvent"] = pm_TickSizeChangeEvent_to_dict(&o.tickSizeChangeEvent)
    if _has(o.has, 4):
        d["lastTradePriceEvent"] = pm_LastTradePriceEvent_to_dict(&o.lastTradePriceEvent)
    return d

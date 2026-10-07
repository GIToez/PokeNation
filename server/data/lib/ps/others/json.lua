-- Minimal JSON codec for extended-opcode payloads (Lua 5.1 / LuaJIT).
-- Objects decode to tables, arrays to 1-based tables, null to nil.
-- Encoding: a table whose keys are exactly 1..n is an array; an empty table encodes as [].

json = {}

local escapes = { ['"'] = '\\"', ['\\'] = '\\\\', ['\b'] = '\\b', ['\f'] = '\\f',
    ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t' }

local function encodeString(s)
    return '"' .. s:gsub('[%c"\\]', function(c)
        return escapes[c] or string.format('\\u%04x', c:byte())
    end) .. '"'
end

local function isArray(t)
    local n = 0
    for k in pairs(t) do
        if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
            return false
        end
        n = n + 1
    end
    for i = 1, n do
        if t[i] == nil then
            return false
        end
    end
    return true
end

local encodeValue

local function encodeTable(t, depth)
    if depth > 16 then
        error("json.encode: nesting too deep")
    end
    local out = {}
    if isArray(t) then
        for i = 1, #t do
            out[i] = encodeValue(t[i], depth + 1)
        end
        return "[" .. table.concat(out, ",") .. "]"
    end
    for k, v in pairs(t) do
        out[#out + 1] = encodeString(tostring(k)) .. ":" .. encodeValue(v, depth + 1)
    end
    return "{" .. table.concat(out, ",") .. "}"
end

encodeValue = function(v, depth)
    local t = type(v)
    if t == "string" then
        return encodeString(v)
    elseif t == "number" then
        if v ~= v or v == math.huge or v == -math.huge then
            error("json.encode: invalid number")
        end
        if math.floor(v) == v then
            return string.format("%d", v)
        end
        return string.format("%.14g", v)
    elseif t == "boolean" then
        return tostring(v)
    elseif t == "nil" then
        return "null"
    elseif t == "table" then
        return encodeTable(v, depth)
    end
    error("json.encode: unsupported type " .. t)
end

function json.encode(v)
    return encodeValue(v, 0)
end

local decodeValue

local function skip(s, i)
    return s:find("[^ \t\r\n]", i) or #s + 1
end

local function decodeString(s, i)
    local out, j = {}, i + 1
    while true do
        local c = s:sub(j, j)
        if c == "" then
            error("json.decode: unterminated string")
        elseif c == '"' then
            return table.concat(out), j + 1
        elseif c == "\\" then
            local e = s:sub(j + 1, j + 1)
            local map = { b = "\b", f = "\f", n = "\n", r = "\r", t = "\t", ['"'] = '"', ["\\"] = "\\", ["/"] = "/" }
            if map[e] then
                out[#out + 1] = map[e]
                j = j + 2
            elseif e == "u" then
                local code = tonumber(s:sub(j + 2, j + 5), 16)
                if not code then
                    error("json.decode: bad unicode escape")
                end
                out[#out + 1] = code < 128 and string.char(code) or "?"
                j = j + 6
            else
                error("json.decode: bad escape")
            end
        else
            out[#out + 1] = c
            j = j + 1
        end
    end
end

decodeValue = function(s, i, depth)
    if depth > 16 then
        error("json.decode: nesting too deep")
    end
    i = skip(s, i)
    local c = s:sub(i, i)
    if c == "{" then
        local obj = {}
        i = skip(s, i + 1)
        if s:sub(i, i) == "}" then
            return obj, i + 1
        end
        while true do
            if s:sub(i, i) ~= '"' then
                error("json.decode: expected key")
            end
            local key
            key, i = decodeString(s, i)
            i = skip(s, i)
            if s:sub(i, i) ~= ":" then
                error("json.decode: expected ':'")
            end
            obj[key], i = decodeValue(s, i + 1, depth + 1)
            i = skip(s, i)
            local d = s:sub(i, i)
            if d == "}" then
                return obj, i + 1
            elseif d ~= "," then
                error("json.decode: expected ',' or '}'")
            end
            i = skip(s, i + 1)
        end
    elseif c == "[" then
        local arr = {}
        i = skip(s, i + 1)
        if s:sub(i, i) == "]" then
            return arr, i + 1
        end
        while true do
            arr[#arr + 1], i = decodeValue(s, i, depth + 1)
            i = skip(s, i)
            local d = s:sub(i, i)
            if d == "]" then
                return arr, i + 1
            elseif d ~= "," then
                error("json.decode: expected ',' or ']'")
            end
            i = i + 1
        end
    elseif c == '"' then
        return decodeString(s, i)
    elseif s:sub(i, i + 3) == "true" then
        return true, i + 4
    elseif s:sub(i, i + 4) == "false" then
        return false, i + 5
    elseif s:sub(i, i + 3) == "null" then
        return nil, i + 4
    end
    local num = s:match("^-?%d+%.?%d*[eE]?[-+]?%d*", i)
    if num and num ~= "" and tonumber(num) then
        return tonumber(num), i + #num
    end
    error("json.decode: unexpected character at " .. i)
end

-- Returns value or nil, errorMessage. Never throws.
function json.decode(s)
    if type(s) ~= "string" then
        return nil, "not a string"
    end
    local ok, value, nextIndex = pcall(decodeValue, s, 1, 0)
    if not ok then
        return nil, value
    end
    if skip(s, nextIndex) <= #s then
        return nil, "trailing characters"
    end
    return value
end

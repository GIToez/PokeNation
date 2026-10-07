string.split = function (str)
	local t = {}
	return not str:gsub("%w+", function(s) table.insert(t, s) return "" end):find("%S") and t or {}
end

string.trim = function (str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

string.explode = function (str, sep, limit)
	if(type(sep) ~= 'string' or isInArray({tostring(str):len(), sep:len()}, 0)) then
		return {}
	end

	local i, pos, tmp, t = 0, 1, "", {}
	for s, e in function() return string.find(str, sep, pos) end do
		tmp = str:sub(pos, s - 1):trim()
		table.insert(t, tmp)
		pos = e + 1

		i = i + 1
		if(limit ~= nil and i == limit) then
			break
		end
	end

	tmp = str:sub(pos):trim()
	table.insert(t, tmp)
	return t
end

string.expand = function (str)
	return string.gsub(str, "$(%w+)", function(n) return _G[n] end)
end

string.timediff = function (diff, cid)
	if (diff <= 0) then
        return {[1] = (not cid and "0 second" or __L(cid, "0 second"))}
    end

    local format = {
		{(not cid and "week" or __L(cid, "week")), diff / 60 / 60 / 24 / 7},
		{(not cid and "day" or __L(cid, "day")), diff / 60 / 60 / 24 % 7},
		{(not cid and "hour" or __L(cid, "hour")), diff / 60 / 60 % 24},
		{(not cid and "minute" or __L(cid, "minute")), diff / 60 % 60},
		{(not cid and "second" or __L(cid, "second")), diff % 60}
	}

	for k, v in ipairs(format) do
		if (v[2] <= 0) then
			table.remove(format, k)
		end
	end

	local t = {}
	for k, v in ipairs(format) do
		local d = math.floor(v[2])
		if(d > 0) then
			t[#t + 1] = ((k < table.maxn(format) or k == table.maxn(format) and #t == 0) and
					(table.maxn(t) > 0 and ", " or "") or (not cid and " and " or __L(cid, " and "))) .. d .." ".. v[1] .. (d ~= 1 and "s" or "")
		end
	end

	return t
end

local function tchelper(first, rest)
    return first:upper()..rest:lower()
end

-- Change an entire string to Title Case (i.e. capitalise the first letter of each word) http://lua-users.org/wiki/StringRecipes
string.capitalise = function(str)
    return str:gsub("(%a)([%w_']*)", tchelper)
end

string.concat = function(...)
    local t = {}
    for _, s in pairs({...}) do
        t[#t + 1] = tostring(s)
    end
    return table.concat(t)
end

string.createStory = function(s, limit)
    if (not limit) then
        limit = 150
    end
    if (string.len(s) > limit) then
        local res = {}
        local str = s
        while (string.len(str) > limit) do
            local pos = string.find(str, " ", limit)
            if (pos) then
                res[#res + 1] = (string.sub(str, 1, pos) .. "(...)")
                str = "(...) " .. string.sub(str, pos + 1, string.len(str))
            else
                break
            end
        end
        res[#res + 1] = str
        s = res
    else
        return {s}
    end
    return s
end

string.extractNumber = function(s)
    local ret = -1
    local b, e = string.find(s, "%d+")
    if b ~= nil and e ~= nil then
        ret = tonumber(string.sub(s, b, e))
    end
    return ret
end

function isString(v)
    return type(v) == "string"
end

-- Strip accents from a string
local tableAccents = {["à"] = "a", ["á"] = "a", ["â"] = "a", ["ã"] = "a", ["ä"] = "a", ["ç"] = "c", ["è"] = "e", ["é"] = "e", ["ê"] = "e", ["ë"] = "e", ["ì"] = "i", ["í"] = "i", ["î"] = "i", ["ï"] = "i", ["ñ"] = "n", ["ò"] = "o", ["ó"] = "o", ["ô"] = "o", ["õ"] = "o", ["ö"] = "o", ["ù"] = "u", ["ú"] = "u", ["û"] = "u", ["ü"] = "u", ["ý"] = "y", ["ÿ"] = "y", ["À"] = "A", ["Á"] = "A", ["Â"] = "A", ["Ã"] = "A", ["Ä"] = "A", ["Ç"] = "C", ["È"] = "E", ["É"] = "E", ["Ê"] = "E", ["Ë"] = "E", ["Ì"] = "I", ["Í"] = "I", ["Î"] = "I", ["Ï"] = "I", ["Ñ"] = "N", ["Ò"] = "O", ["Ó"] = "O", ["Ô"] = "O", ["Õ"] = "O", ["Ö"] = "O", ["Ù"] = "U", ["Ú"] = "U", ["Û"] = "U", ["Ü"] = "U", ["Ý"] = "Y"}
function string.stripAccents(str)
	local normalizedString = ""
	for strChar in str:gmatch"." do --for strChar in string.gfind(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		if tableAccents[strChar] ~= nil then
			normalizedString = normalizedString .. tableAccents[strChar]
		else
			normalizedString = normalizedString .. strChar
		end
	end
	return normalizedString
end
table.find = function (t, value)
	for i, v in pairs(t) do
		if (v == value) then
			return i
		end
	end

	return nil
end

table.findAsTable = function (t, value)
    local f
    for k, v in pairs(value) do
        f = table.find(t, v)
        if (f) then
            return f
        end
    end
    return f
end

table.removeValue = function (t, value, onlyFirst)
    if (not onlyFirst) then
        onlyFirst = true
    end

    local removed = false
    for k, v in pairs(t) do
        if (v == value) then
            table.remove(t, k)

            if (onlyFirst) then
                return true
            end

            removed = true
        end
    end

    return removed
end

table.contains = function (txt, str)
	for i, v in pairs(str) do
		if(txt:find(v) and not txt:find('(%w+)' .. v) and not txt:find(v .. '(%w+)')) then
			return true
		end
	end

	return false
end
table.isStrIn = table.contains

table.count = function (table, item)
	local count = 0
	for i, n in pairs(table) do
		if(item == n) then
			count = count + 1
		end
	end

	return count
end
table.countElements = table.count

table.getCombinations = function (table, num)
	local a, number, select, newlist = {}, #table, num, {}
	for i = 1, select do
		a[#a + 1] = i
	end

	local newthing = {}
	while(true) do
		local newrow = {}
		for i = 1, select do
			newrow[#newrow + 1] = table[a[i]]
		end

		newlist[#newlist + 1] = newrow
		i = select
		while(a[i] == (number - select + i)) do
			i = i - 1
		end

		if(i < 1) then
			break
		end

		a[i] = a[i] + 1
		for j = i, select do
			a[j] = a[i] + j - i
		end
	end

	return newlist
end

function table_concat(...)
    local t = {}
    for n = 1,select("#",...) do
        local arg = select(n,...)
        if type(arg)=="table" then
            for _,v in ipairs(arg) do
                t[#t+1] = v
            end
        else
            t[#t+1] = arg
        end
    end
    return t
end

table.random = function(t)
	return t[math.random(1, #t)]
end

function table.randFrom( t )
    local choice = "F"
    local n = 0
    for i, o in pairs(t) do
        n = n + 1
        if math.random() < (1/n) then
            choice = o
        end
    end
    return choice
end

table.randomRemove = function(t)
    local k = math.random(1, #t)
    local v = t[k]
    table.remove(t, k)
    return v
end

table.copy = function(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

table.deepcopy = function(o, seen) -- http://stackoverflow.com/a/16077650/1150772
    seen = seen or {}
    if o == nil then return nil end
    if seen[o] then return seen[o] end

    local no
    if type(o) == 'table' then
        no = {}
        seen[o] = no

        for k, v in next, o, nil do
            no[table.deepcopy(k, seen)] = table.deepcopy(v, seen)
        end
        setmetatable(no, table.deepcopy(getmetatable(o), seen))
    else -- number, string, boolean, etc
        no = o
    end
    return no
end

table.print = function(t, sub)
    if (not sub) then
        print("\n\nPrinting table:")
    end
    for k, v in pairs(t) do
        if (type(v) == "table") then
            print("Printing sub-table...")
            table.print(v, true)
        else
            print("[" .. tostring(k) .. "] = " .. tostring(v))
        end
    end
end

table.clear = function(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

table.set = function(t)
    local set = {}
    for _, v in pairs(t) do
        set[v] = true
    end
    return set
end

table.inverse = function(t)
    local r = {}
    for k, v in pairs(t) do
        r[v] = k
    end
    return r
end

table.shuffle = function(array)
    local function swap(array, index1, index2)
        array[index1], array[index2] = array[index2], array[index1]
    end

    local counter = #array
    local antiLoop = 0
    while counter > 1 do
        local index = getRandom(1, counter)
        swap(array, index, counter)
        counter = counter - 1

        if (antiLoop > 999999) then
            break
        end
        antiLoop = antiLoop + 1
    end
end

--[[
table.getMin = function (table)
	if (#table < 1) then
		return nil
	end

	local resultKey, resultValue, tableKey, tableValue = -1, -1

	for tableKey = 1, #table do
		tableValue = table[tableKey]

		if (tableValue > -1 and tableValue < resultValue) then
			resultKey = tableKey
			resultValue = tableValue
		end
	end

	if (resultValue > -1) then
		return resultKey

	else
		return nil
	end
end
]]

    -- "Sorted by key" table iterator
    -- Extracted from http://www.lua.org/pil/19.3.html

    --function pairsKeySorted(t, f)
    --local a = {}
    --for n in pairs(t) do
    --table.insert(a, n)
    --end
    --table.sort(a, f)

    --local i = 0 -- iterator variable
    --local iter = function () -- iterator function
    --i = i + 1
    --if a[i] == nil then
    --return nil
    --else
    --return a[i], t[a[i]]
    --end
    --end

    --return iter
    --end
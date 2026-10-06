function getPlayerExtraLootRateTime(cid)
    local r = getCreatureStorage(cid, playersStorages.extraLootRateTime)
    return r > -1 and r or 0
end

function setPlayerExtraLootRateTime(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraLootRateTime, value)
end

function getPlayerExtraLootRateValue(cid)
    local r = tonumber(getCreatureStorage(cid, playersStorages.extraLootRateValue))
    return r > -1 and r or 0
end

function setPlayerExtraLootRateValue(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraLootRateValue, value)
end

local function doExtraLootRateReset(pid)
    if (isPlayer(pid)) then
        setPlayerExtraLootRate(pid, 0)
        setPlayerExtraLootRateTime(pid, 0)
        setPlayerExtraLootRateValue(pid, 0)
        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Your bonus loot has ended.")
        doSendMagicEffect(getCreaturePosition(pid), EFFECT_RED_BUFF)
    end
end

function doExtraLootRateCheck(pid) -- Called onLogin
    local remaingTime = getPlayerExtraLootRateTime(pid) - os.time()
    if (remaingTime > 0) then
        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "Remaining %s minutes of bonus loot."), math.floor(remaingTime / 60)))
        setPlayerExtraLootRate(pid, getPlayerExtraLootRateValue(pid))
        addEvent(doExtraLootRateReset, remaingTime * 1000, pid)
    elseif (getPlayerExtraLootRateValue(pid) > 0) then
        doExtraLootRateReset(pid)
    end
end

function doExtraLootRateStart(pid, seconds, value)
    if (getPlayerExtraLootRate(pid) > 0) then
        return false
    end

    setPlayerExtraLootRate(pid, value)
    setPlayerExtraLootRateTime(pid, os.time() + seconds)
    setPlayerExtraLootRateValue(pid, value)
    doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "Your %s%% bonus loot has started. Duration: %s minutes."), math.round(value * 100), math.floor(seconds / 60)))
    doSendMagicEffect(getCreaturePosition(pid), EFFECT_RED_BUFF)
    addEvent(doExtraLootRateReset, seconds * 1000, pid)
    return true
end

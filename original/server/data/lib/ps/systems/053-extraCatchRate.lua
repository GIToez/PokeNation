function getPlayerExtraCatchRateTime(cid)
    local r = getCreatureStorage(cid, playersStorages.extraCatchRateTime)
    return r > -1 and r or 0
end

function setPlayerExtraCatchRateTime(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraCatchRateTime, value)
end

function getPlayerExtraCatchRateValue(cid)
    local r = tonumber(getCreatureStorage(cid, playersStorages.extraCatchRateValue))
    return r > -1 and r or 0
end

function setPlayerExtraCatchRateValue(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraCatchRateValue, value)
end

local function doExtraCatchRateReset(pid)
    if (isPlayer(pid)) then
--        setPlayerExtraCatchRate(pid, 0)
        setPlayerExtraCatchRateTime(pid, 0)
        setPlayerExtraCatchRateValue(pid, 0)
        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Your bonus catch has ended.")
        doSendMagicEffect(getCreaturePosition(pid), EFFECT_RED_BUFF)
    end
end

function doExtraCatchRateCheck(pid) -- Called onLogin
    local remaingTime = getPlayerExtraCatchRateTime(pid) - os.time()
    if (remaingTime > 0) then
        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "Remaining %s minutes of bonus catch."), math.floor(remaingTime / 60)))
--        setPlayerExtraCatchRate(pid, getPlayerExtraCatchRateValue(pid))
        addEvent(doExtraCatchRateReset, remaingTime * 1000, pid)
    elseif (getPlayerExtraCatchRateValue(pid) > 0) then
        doExtraCatchRateReset(pid)
    end
end

function doExtraCatchRateStart(pid, seconds, value)
    if (getPlayerExtraCatchRateTime(pid) - os.time() > 0) then
        return false
    end

    setPlayerExtraCatchRateTime(pid, os.time() + seconds)
    setPlayerExtraCatchRateValue(pid, value)
    doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "Your %s%% bonus catch has started. Duration: %s minutes."), math.round(value * 100), math.floor(seconds / 60)))
    doSendMagicEffect(getCreaturePosition(pid), EFFECT_RED_BUFF)
    addEvent(doExtraCatchRateReset, seconds * 1000, pid)
    return true
end

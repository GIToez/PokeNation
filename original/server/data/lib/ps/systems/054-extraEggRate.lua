function getPlayerExtraEggRateTime(cid)
    local r = getCreatureStorage(cid, playersStorages.extraEggRateTime)
    return r > -1 and r or 0
end

function setPlayerExtraEggRateTime(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraEggRateTime, value)
end

function getPlayerExtraEggRateValue(cid)
    local r = tonumber(getCreatureStorage(cid, playersStorages.extraEggRateValue))
    return r > -1 and r or 0
end

function setPlayerExtraEggRateValue(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraEggRateValue, value)
end

local function doExtraEggRateReset(pid)
    if (isPlayer(pid)) then
        --        setPlayerExtraEggRate(pid, 0)
        setPlayerExtraEggRateTime(pid, 0)
        setPlayerExtraEggRateValue(pid, 0)
        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Your bonus egg has ended.")
        doSendMagicEffect(getCreaturePosition(pid), EFFECT_RED_BUFF)
    end
end

function doExtraEggRateCheck(pid) -- Called onLogin
    local remaingTime = getPlayerExtraEggRateTime(pid) - os.time()
    if (remaingTime > 0) then
        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "Remaining %s minutes of bonus egg."), math.floor(remaingTime / 60)))
        --        setPlayerExtraEggRate(pid, getPlayerExtraEggRateValue(pid))
        addEvent(doExtraEggRateReset, remaingTime * 1000, pid)
    elseif (getPlayerExtraEggRateValue(pid) > 0) then
        doExtraEggRateReset(pid)
    end
end

function doExtraEggRateStart(pid, seconds, value)
    if (getPlayerExtraEggRateTime(pid) - os.time() > 0) then
        return false
    end

    setPlayerExtraEggRateTime(pid, os.time() + seconds)
    setPlayerExtraEggRateValue(pid, value)
    doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "Your %s%% bonus egg has started. Duration: %s minutes."), math.round(value * 100), math.floor(seconds / 60)))
    doSendMagicEffect(getCreaturePosition(pid), EFFECT_RED_BUFF)
    addEvent(doExtraEggRateReset, seconds * 1000, pid)
    return true
end

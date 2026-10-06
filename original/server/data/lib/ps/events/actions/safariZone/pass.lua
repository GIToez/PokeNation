local VERTICAL, HORIZONTAL, safePos = 0, 1, SAFARI_START_POSITION

local DIRECTION = {
    [100] = VERTICAL,
    [101] = HORIZONTAL,
    [102] = HORIZONTAL,
    [103] = VERTICAL,
    [104] = VERTICAL,
    [105] = HORIZONTAL,
    [106] = HORIZONTAL
}

local TELEPORT = {
    [VERTICAL] = {
        [NORTH] = SOUTH,
        [NORTHEAST] = SOUTH,
        [NORTHWEST] = SOUTH,
        [SOUTH] = NORTH,
        [SOUTHEAST] = NORTH,
        [SOUTHWEST] = NORTH
    },
    [HORIZONTAL] = {
        [NORTHWEST] = EAST,
        [WEST] = EAST,
        [SOUTHWEST] = EAST,
        [NORTHEAST] = WEST,
        [EAST] = WEST,
        [SOUTHEAST] = WEST
    }
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not DIRECTION[item.actionid]) then
        return true
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_FRAME)

    local pass = getPlayerSafariZonePass(cid)
    if (pass <= 0) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have none Safari Zone pass left, you will be teleported to the entrance.")
        doTeleportThing(cid, safePos, false)
        doSendMagicEffect(safePos, EFFECT_TELEPORT_FRAME)
        setUnderwaterStatus(cid, false)
        OxygenMask.doPlayerUnlock(cid)
        return true
    end

    local newPos = getPosByDir(toPosition,
        TELEPORT[DIRECTION[item.actionid]][getDirectionTo(toPosition, getCreaturePosition(cid))], 1)
    pass = pass - 1
    doTeleportThing(cid, newPos, false)
    doSendMagicEffect(newPos, EFFECT_TELEPORT_FRAME)
    setPlayerSafariZonePass(cid, pass)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You have now %s Safari Zone pass left."), pass))
    return true
end

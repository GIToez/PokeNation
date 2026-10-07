local TELEPORTS = {}
TELEPORTS[28166] = {
    position = {x = 5742, y = 120, z = 7},
    storage = 8720,
    factionStorage = 8695
} -- yellow

TELEPORTS[28167] = {
    position = {x = 5787, y = 162, z = 7},
    storage = 8718,
    factionStorage = 8694
} -- blue

TELEPORTS[28168] = {
    position = {x = 5855, y = 130, z = 7},
    storage = 8719,
    factionStorage = 8696
} -- green

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid)) then
        return true
    end

    local core = TELEPORTS[item.itemid]
    if (not core) then
        log(LOG_TYPES.ERROR, "Halloween Event - coreTeleport::unknown core", getCreatureName(cid), item, position, lastPosition, fromPosition, toPosition, actor)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (getCreatureStorage(cid, core.storage) ~= QUEST_STATUS.FINISHED or getCreatureStorage(cid, core.factionStorage) == QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        doTeleportThing(cid, lastPosition)
        return false
    end

    doSendMagicEffect(position, EFFECT_ELECTRIC_CLOUD)
    doTeleportThing(cid, core.position)
    doSendMagicEffect(core.position, EFFECT_ELECTRIC_CLOUD)

    return true
end
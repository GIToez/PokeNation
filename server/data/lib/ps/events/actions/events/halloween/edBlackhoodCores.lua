local CORES = {}
CORES[28039] = {
    position = {x = 5764, y = 188, z = 7},
    storage = 8718
} -- blue
CORES[28040] = {
    position = {x = 5768, y = 188, z = 7},
    storage = 8719
} -- green
CORES[28046] = {
    position = {x = 5759, y = 188, z = 7},
    storage = 8720
} -- yellow

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local core = CORES[item.itemid]
    if (not core) then
        log(LOG_TYPES.ERROR, "Halloween Event - edBlackhoodCores::unknown core", getCreatureName(cid), item, fromPosition, itemEx, toPosition)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (not doComparePositions(toPosition, core.position)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_ENERGY)
    doRemoveItem(item.uid)
    doSendMagicEffect(toPosition, EFFECT_ELECTRIC_CLOUD)
    doCreatureSetStorage(cid, core.storage, QUEST_STATUS.FINISHED)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The portal has been activated.")

    return true
end

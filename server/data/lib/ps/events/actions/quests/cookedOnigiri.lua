local QUEST_STORAGE = 8459

local NPCS = {
    ["Brockling Yolanda"] = 8476,
    ["Brockling Suzie"] = 8477,
    ["Brockling Timmy"] = 8478,
    ["Brockling Billy"] = 8479,
    ["Brockling Tilly"] = 8480,
    ["Brockling Cindy"] = 8481,
    ["Brockling Tommy"] = 8482,
    ["Brockling Forrest"] = 8483,
}
local REQUIRED_FOOD = 2

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) == QUEST_STATUS.FINISHED and not isNpc(itemEx.uid)) then
        return PokemonFood.onUse(cid, item, fromPosition, itemEx, toPosition)
    end

    if (getDistanceBetween(getCreaturePosition(cid), toPosition) > 4) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return true
    end

    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or not isNpc(itemEx.uid) or
            not NPCS[getCreatureName(itemEx.uid)]) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local name = getCreatureName(itemEx.uid)
    local storage = NPCS[name]
    local count = getCreatureStorage(cid, storage)

    if (count >= REQUIRED_FOOD) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "This Brockling is fed.")
        return true
    end

    local count = doCreatureIncreaseStorage(cid, storage)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "%s fed [%s/%s]."), name, count, REQUIRED_FOOD))

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EMOTION_HAPPY)
    doRemoveItem(item.uid, 1)

    return true
end

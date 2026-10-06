local QUEST_STORAGE = 8436
local PLACES = {
    {pos = {x = 5022, y = 472, z = 7}, storage = 8437},
    {pos = {x = 5025, y = 476, z = 7}, storage = 8438},
    {pos = {x = 5040, y = 480, z = 7}, storage = 8483},
    {pos = {x = 5039, y = 481, z = 7}, storage = 8484},
    {pos = {x = 5038, y = 494, z = 7}, storage = 8485},
    {pos = {x = 5022, y = 498, z = 7}, storage = 8486},
    {pos = {x = 5038, y = 502, z = 7}, storage = 8487}
}
local GARBAGES = {2250, 2253, 2252, 2254, 2251}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    for k, v in pairs(PLACES) do
        if (getSamePosition(toPosition, v.pos)) then
            local count = 0
            for _, place in pairs(PLACES) do
                if (getCreatureStorage(cid, place.storage) == QUEST_STATUS.FINISHED) then
                    count = count + 1
                end
            end

            if (getCreatureStorage(cid, v.storage) ~= QUEST_STATUS.FINISHED) then
                doCreatureSetStorage(cid, v.storage, QUEST_STATUS.FINISHED)
                count = count + 1
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
                doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
                if (table.find(GARBAGES, itemEx.itemid)) then
                    doRemoveItem(itemEx.uid, 1)
                    addEvent(doCreateItem, 60 * 1000, itemEx.itemid, 1, toPosition)
                end
            end

            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "This spot is clean. [%s/%s]"), count, #PLACES))
            return true
        end
    end

    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    return true
end

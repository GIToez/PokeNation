local QUEST_STORAGE = 8436
local ITEM_STORAGE = 8488
local ITEMS = {23544, 23559} -- laboratory card and laboratory note

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.FINISHED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Something has been found.")

    for _, itemid in pairs(ITEMS) do
        doPlayerSafeAddItem(cid, itemid, 1, true, true)
    end

    return true
end

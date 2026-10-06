local QUEST_STORAGE = 8461
local ITEM_STORAGE = 8465

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)

    if (doPlayerSafeAddItem(cid, 23594, 1, true, true)) then -- toy (moveable)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The toy has taken.")
        doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    end

    return true
end

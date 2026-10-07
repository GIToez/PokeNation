local QUEST_STORAGE = 8460
local ITEM_STORAGE = 8462

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) == QUEST_STATUS.FINISHED or not isNpc(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= "Flint's Golem") then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_POFF)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The Golem is happy now.")
    doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    doRemoveItem(item.uid)

    return true
end

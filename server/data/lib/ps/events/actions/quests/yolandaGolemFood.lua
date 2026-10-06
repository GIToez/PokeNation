local QUEST_STORAGE = 8460
local ITEM_STORAGE = 8464

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) == QUEST_STATUS.FINISHED or not isItem(itemEx) or
            itemEx.itemid ~= 23591) then -- empty pokemon bowl
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_POFF)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The bowl is full now.")
    doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    doRemoveItem(item.uid)
    doTransformItem(itemEx.uid, 23592) -- full pokemon bowl
    doDecayItem(itemEx.uid)

    return true
end

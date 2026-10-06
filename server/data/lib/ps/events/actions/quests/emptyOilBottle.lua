local PUDDLE_OF_OIL_ITEMID = 18884
local OIL_BOTTLE_ITEMID = 18881
local QUEST_STORAGE = 8388

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or itemEx.itemid ~= PUDDLE_OF_OIL_ITEMID or
            getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_POISON_TWO)
    doTransformItem(item.uid, OIL_BOTTLE_ITEMID)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "A gooey dark oil was collected.")
    doRemoveItem(itemEx.uid)

    return true
end

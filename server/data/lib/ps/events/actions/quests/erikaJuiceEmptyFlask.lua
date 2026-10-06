local QUEST_STORAGE = 8472

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or not isItem(itemEx) or
            itemEx.itemid ~= 23597) then -- bucket filled with juice
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    doSendMagicEffect(fromPosition, EFFECT_FIREWORK_YELLOW)
    doRemoveItem(item.uid, 1)
    doPlayerSafeAddItem(cid, 23596, 1, true, true) -- Erika's juice flask
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The juice has taken.")
    if (getRandom(1, 2) == 1) then
        doRemoveItem(itemEx.uid)
    end

    return true
end

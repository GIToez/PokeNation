local QUEST_STORAGE = 8458
local COUNT = 40

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.FINISHED or not isItem(itemEx) or
            itemEx.itemid ~= 23590) then -- seasoned onigiri
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (itemEx.type ~= COUNT) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You must use it on %s seasoned onigiris."), COUNT))
        return true
    end

    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    doSendMagicEffect(fromPosition, EFFECT_FIRE_FIELD)
    doTransformItem(itemEx.uid, 23574) -- cooked onigiri
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The onigiris are ready.")

    return true
end

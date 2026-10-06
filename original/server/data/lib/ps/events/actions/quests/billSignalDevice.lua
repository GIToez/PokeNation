local QUEST_STORAGE = 8431
local ITEM_STORAGE = 8432

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    doSendMagicEffect(toPosition, EFFECT_POFF)
    doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "I must warn... Bill. *fusk* Mew... two? Roc...t *fusk*, Cela..*fusk*..on.")

    return true
end

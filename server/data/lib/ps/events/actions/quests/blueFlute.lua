local QUEST_STORAGE = 8439
local ITEM_STORAGE = 8440

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) == QUEST_STATUS.FINISHED or not isNpc(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= "Sleeping Tauros") then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    doRemoveCreature(itemEx.uid)
    local npc = doCreateNpc("Justin's Tauros", toPosition, false)
    addEvent(function()
        local pos = getCreaturePosition(npc)
        doRemoveCreature(npc)
        doCreateNpc("Sleeping Tauros", pos, false)
    end, 30 * 60 * 1000)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The Pokemon woke up.")

    return true
end

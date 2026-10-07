local QUEST_STORAGE = 8418
local ITEM_STORAGE = 8420

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EMOTION_QUESTION)

    if (doPlayerSafeAddItem(cid, 23538, 1, true, true)) then -- Ash's letter
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "A letter has been found.")
        doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
        doShowTextDialog(cid, 23538, "To my mother:\n\nDear mother, I am concerned. I am writing to tell you about a few things. I discovered many interesting things about the new Pokemon on this continent, but I feel that I'm being followed. I'll be back in Kanto soon. I'll arrive by Viridian.\n\nPS: Talk to Gary that I sent an email to him, ok?\n\nAsh Ketchum")
    end

    return true
end

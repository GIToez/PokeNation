local QUEST_STORAGE = 8413
local ITEMEX_IDS = {
    [23535] = 8415,
    [23536] = 8416
}

local BUSH_ID = 23539
local BUSH_QUEST_STORAGE = 8417

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (isItem(itemEx) and itemEx.itemid == BUSH_ID and
            getCreatureStorage(cid, BUSH_QUEST_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        local dest = {x = 5216, y = 410, z = 7}
        doTeleportThing(cid, dest)
        doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
        return true
    end

    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            not isItem(itemEx) or not ITEMEX_IDS[itemEx.itemid] or
            getCreatureStorage(cid, ITEMEX_IDS[itemEx.itemid]) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_QUESTION)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Something happened here.")
    doCreatureSetStorage(cid, ITEMEX_IDS[itemEx.itemid], QUEST_STATUS.FINISHED)

    return true
end

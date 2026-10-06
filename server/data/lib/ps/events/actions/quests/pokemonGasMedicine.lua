local QUEST_STORAGE = 8444
local ITEM_STORAGE = 8445
local START_POSITION = {x = 3811, y = 270, z = 8}
local END_POSITION = {x = 3791, y = 296, z = 8}

local EVENT, onWork

local function onStop(npc, cid)
    if (EVENT) then
        stopEvent(EVENT)
    end
    EVENT = nil

    doTeleportThing(npc, START_POSITION)

    if (cid) then
        doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    end
end

onWork = function(npc, cid)
    if (not isCreature(cid)) then
        onStop(npc)
        return
    end

    local pos = getCreaturePosition(npc)
    if (getDistanceBetween(pos, END_POSITION) < 3) then
        onStop(npc, cid) -- success
        return
    end

    doCreatureFollowCreature(npc, cid)
    -- todo: only re-follow if isnt following
    EVENT = addEvent(onWork, 250, npc, cid)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (EVENT or getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ITEM_STORAGE) == QUEST_STATUS.FINISHED or not isNpc(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= "Poisonous Weezing") then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The Pokemon is following you now.")
    onWork(itemEx.uid, cid)

    return true
end

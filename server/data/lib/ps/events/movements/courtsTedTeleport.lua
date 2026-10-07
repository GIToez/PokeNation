function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid) or getCreatureStorage(cid, 8321) ~= QUEST_STATUS.STARTED) then
        return true
    end

    doTeleportThing(cid, {x = 4888, y = 305, z = 4})
    return true
end
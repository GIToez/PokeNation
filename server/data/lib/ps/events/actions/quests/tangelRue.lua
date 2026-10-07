local leavesStorage = 8294

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8214) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, leavesStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (doPlayerAddUniqueItem(cid, 18246, 1, false)) then
        doCreatureSetStorage(cid, leavesStorage, QUEST_STATUS.FINISHED)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You picked some leaves.")
        doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    end

	return true
end

local chestStorage = 8349

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8339) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, chestStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18634, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doCreatureSetStorage(cid, chestStorage, QUEST_STATUS.FINISHED)
    doTeleportThing(cid, {x = 2955, y = 2228, z = 8})

	return true
end

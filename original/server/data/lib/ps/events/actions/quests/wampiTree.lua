local questStorage = 8229
local wampiStorage = 8239

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, questStorage) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (getCreatureStorage(cid, wampiStorage) ~= QUEST_STATUS.FINISHED and
            doPlayerAddUniqueItem(cid, 18171, 1, false)) then
        doCreatureSetStorage(cid, wampiStorage, QUEST_STATUS.FINISHED)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a Wampi Fruit.")
        doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)

    else
        doPlayerSendCancel(cid, "You already got this fruit.")
    end

	return true
end

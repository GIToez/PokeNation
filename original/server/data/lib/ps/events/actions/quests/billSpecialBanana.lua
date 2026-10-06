function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8231) ~= QUEST_STATUS.STARTED or not isMonster(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= "Thief Aipom") then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (getDistanceBetween(getCreaturePosition(cid), toPosition) > 2) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_SLEEP, nil, cid)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Use your special net before Thief Aipom wakes up!")

	return true
end

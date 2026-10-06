function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8231) ~= QUEST_STATUS.STARTED or not isMonster(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= "Thief Aipom" or not getCreatureStatus(itemEx.uid, CREATURE_STATUS_SLEEP)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (getDistanceBetween(getCreaturePosition(cid), toPosition) > 3) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doRemoveCreature(itemEx.uid)
    doCreateItem(18320, 1, toPosition)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Now get the GS ball with the Thief Aipom!")

	return true
end

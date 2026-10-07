local keyStorage = 8330

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8329) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, keyStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)

    for i = 1, 6 do
        addEvent(doSendMagicEffect, i * 300, getPositionRandomAdjacent(toPosition), EFFECT_ELECTRIC_CLOUD)
    end

    doCreatureSetStorage(cid, keyStorage, QUEST_STATUS.FINISHED)
    doRemoveItem(item.uid)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The machine is working now!")

	return true
end

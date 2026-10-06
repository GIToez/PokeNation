local itemStorage = 8356

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (item.uid ~= 3158 or getCreatureStorage(cid, 8243) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, itemStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doPlayerSafeAddItem(cid, 18172, 1, false, true)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doCreatureSetStorage(cid, itemStorage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_GREEN_BUFF)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a restore stone.")

	return true
end

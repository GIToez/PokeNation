local ballStorage = 8334

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8259) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, ballStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18188, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doCreatureSetStorage(cid, ballStorage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_GREEN_BUFF)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a donphan toy ball.")

	return true
end

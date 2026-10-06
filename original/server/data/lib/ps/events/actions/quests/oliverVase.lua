local messageStorage = 8312

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, messageStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "It's empty.")
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18186, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doCreatureSetStorage(cid, messageStorage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_GREEN_BUFF)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a strange message.")

	return true
end

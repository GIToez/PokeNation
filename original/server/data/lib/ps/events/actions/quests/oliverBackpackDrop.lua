local storage = 8335

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8314) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18304, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Please check your backpack for free space.")
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received oliver backpack.")
    doRemoveItem(itemEx.uid)

	return true
end

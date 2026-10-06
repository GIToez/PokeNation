function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8245) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18256, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doSendMagicEffect(toPosition, EFFECT_SCRATCH)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a grape flower.")
    doTransformItem(itemEx.uid, 18257)
    doDecayItem(itemEx.uid)

	return true
end

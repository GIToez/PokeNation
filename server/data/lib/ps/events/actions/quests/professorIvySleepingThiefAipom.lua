function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8231) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18159, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doSendMagicEffect(toPosition, EFFECT_POFF)
    doRemoveItem(itemEx.uid)
    doSendMagicEffect(toPosition, EFFECT_TELEPORT_UP)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You took the GS Ball! Now you must see Professor Ivy.")
    doPlayerRemoveItem(cid, 18162, getPlayerItemCount(cid, 18162)) -- Special Banana
    doPlayerRemoveItem(cid, 18321, getPlayerItemCount(cid, 18321)) -- Special Net

	return true
end

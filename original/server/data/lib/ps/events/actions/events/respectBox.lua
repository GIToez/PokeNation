function onUse(cid, item, fromPosition, itemEx, toPosition)
	local amount = getRandom(1, 20)
    if (not doPlayerAddRespect(cid, amount)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doRemoveItem(item.uid, 1)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_BLUE)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Congratulations! You received %s respect point%s"), amount, (amount > 1 and "s!" or "!")))

	return true
end

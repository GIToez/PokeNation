function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not doPlayerAddUniqueItem(cid, table.random({14037, 14038, 14039}), 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doRemoveItem(item.uid)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Congratulations! You received a baby pokemon egg.")

	return true
end

function onSay(cid, words, param)
	local autoLoot = getPlayerAutoLoot(cid)
	setPlayerAutoLoot(cid, not autoLoot)
	setPlayerAutoLootSave(cid, not autoLoot)
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "Auto Loot %s!"), (autoLoot and "OFF" or "ON")))
	return true
end

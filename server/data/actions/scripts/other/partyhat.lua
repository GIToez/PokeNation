function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_RING).uid) then
		return false
	end

	doSendMagicEffect(getCreaturePosition(cid), table.random({EFFECT_FIREWORK_YELLOW, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_BLUE}))
	return true
end

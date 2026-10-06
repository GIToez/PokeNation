function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isItem(itemEx) or itemEx.itemid ~= 25199) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local count = getItemCount(item.uid)
	setGlobalStorageValue(GLOBAL_STORAGES.EVENT_CHRISTMAS_PRESENT_COUNT,
		getGlobalStorageValue(GLOBAL_STORAGES.EVENT_CHRISTMAS_PRESENT_COUNT) + count)
	doSendMagicEffect(toPosition, EFFECT_RED_BUFF)
	doPlayerSafeAddItem(cid, 25270, count, true, true) -- Token Box
	doRemoveItem(item.uid)
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "You recovered %s present%s!"), count, (count > 1 and "s" or "")))
	return true
end

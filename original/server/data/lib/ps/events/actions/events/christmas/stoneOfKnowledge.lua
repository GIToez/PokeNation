function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (itemEx.uid == cid and doExtraExpRateStart(cid, 60 * 60, 0.1)) then
		doRemoveItem(item.uid, 1)
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	end
	return true
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (item.uid <= LAST_UNIQUE_ID) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end

	onCreatureUseBerrySeed(cid, item, fromPosition, itemEx, toPosition)
    return true
end

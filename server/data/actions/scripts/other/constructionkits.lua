function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(fromPosition.x == CONTAINER_POSITION) then
		doPlayerSendCancel(cid, "Put the construction kit on the floor first.")
	elseif(not getTileInfo(fromPosition).house) then
		doPlayerSendCancel(cid,"You may construct this only inside a house.")
	elseif(CONSTRUCTION_KITS[item.itemid] ~= nil) then
		doRemoveItem(item.uid)
        doCreateItem(CONSTRUCTION_KITS[item.itemid], 1, toPosition)
		doSendMagicEffect(fromPosition, CONST_ME_POFF)
	else
		return false
	end

	return true
end

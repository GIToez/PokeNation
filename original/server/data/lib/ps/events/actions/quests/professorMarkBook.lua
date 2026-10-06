local STORAGE = 8015

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (item.uid > LAST_UNIQUE_ID) then
		return false
	end

	local storageStatus, result = getCreatureStorage(cid, STORAGE)

	if (not storageStatus or storageStatus == -1) then
        doPlayerSafeAddItem(cid, item.itemid, 1, true, true)
		doCreatureSetStorage(cid, STORAGE, 1)
		result = string.format(__L(cid, "You have found: %s"), getItemNameById(item.itemid))

	else
		result = __L(cid, "It is empty.")
	end

	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, result)
	return true
end

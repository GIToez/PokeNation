local FIELD_IDS = {13315, 2016, 13314, 13316, 13317, 2019, 18100, 18101, 18102}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local hasRemoved = false
	for _, fieldId in pairs(FIELD_IDS) do
		local tmpItem = getTileItemById(toPosition, fieldId)
        local count = 0 -- Just prevent infinite loop

		while (isItem(tmpItem) and count <= 255) do
			doRemoveItem(tmpItem.uid)

			hasRemoved = true
			tmpItem = getTileItemById(toPosition, fieldId)
            count = count + 1
		end
	end

	if (hasRemoved) then
		doRemoveItem(item.uid, 1)
		doSendMagicEffect(toPosition, EFFECT_POFF)
        doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	end

	return true
end

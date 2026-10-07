local BEDS = {
	[7904] = {{7811, 7812}, {7813, 7814}}, -- green kit
	[7905] = {{7815, 7816}, {7817, 7818}}, -- red kit
	[7906] = {{7819, 7820}, {7821, 7822}}, -- yellow kit
	[7907] = {{1754, 1755}, {1760, 1761}},  -- removal kit
	[30124] = {{29911, 29912}, {29913, 29914}},  -- red wooden
	[30125] = {{29919, 29920}, {29921, 29922}},  -- orange wooden
	[30126] = {{29927, 29928}, {29929, 29930}},  -- yellow wooden
	[30127] = {{29935, 29936}, {29937, 29938}},  -- green wooden
	[30128] = {{29943, 29944}, {29945, 29946}},  -- blue wooden
	[30129] = {{29951, 29952}, {29953, 29954}},  -- purple wooden
	[30130] = {{29959, 29960}, {29961, 29962}},  -- pink wooden
	[30131] = {{29967, 29968}, {29969, 29970}},  -- black wooden
	[30132] = {{29975, 29976}, {29977, 29978}},  -- white wooden
}

local function internalBedTransform(item, itemEx, toPosition, ids)
    local itemEx2 = getThingfromPos(toPosition)
    if (not isItem(itemEx2)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return
    end

	doTransformItem(itemEx.uid, ids[1])
	doTransformItem(itemEx2.uid, ids[2])

	doSendMagicEffect(getThingPos(itemEx.uid), CONST_ME_POFF)
	doSendMagicEffect(toPosition, CONST_ME_POFF)

	doRemoveItem(item.uid)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local newBed = BEDS[item.itemid]
	if(not newBed or not getHouseFromPos(getCreaturePosition(cid))) then
		return false
	end

	--TODO
	--Is it possible in real tibia, to use same modification on current used?
	if(isInArray({newBed[1][1], newBed[2][1]}, itemEx.itemid)) then
		doPlayerSendCancel(cid, "You already have this bed modification.")
		return true
	end

	for kit, bed in pairs(BEDS) do
		if(bed[1][1] == itemEx.itemid or itemEx.itemid == 1758) then
			toPosition.y = toPosition.y + 1
			internalBedTransform(item, itemEx, toPosition, newBed[1])
			break
		elseif(bed[2][1] == itemEx.itemid or itemEx.itemid == 1756) then
			toPosition.x = toPosition.x + 1
			internalBedTransform(item, itemEx, toPosition, newBed[2])
			break
		end
	end

	return true
end

-- Normal doors that work with this action need be included here
local DOORS = {}
--DOORS[itemid] = { array of allowed actionids }
DOORS[5120] = {1000}

function onStepOut(cid, item, position, fromPosition)
	if (not isPlayer(cid) or (DOORS[item.itemid] and not table.find(DOORS[item.itemid], item.actionid))) then
		return true
	end

	local newPosition = {x = position.x, y = position.y, z = position.z}
	if(isInArray(verticalOpenDoors, item.itemid)) then
		newPosition.x = newPosition.x + 1
	else
		newPosition.y = newPosition.y + 1
	end

	doRelocate(position, newPosition)
	local tmpPos = {x = position.x, y = position.y, z = position.z, stackpos = -1}
	local tileCount = getTileThingByPos(tmpPos)

	local i = 1
	local tmpItem = {uid = 1}
	while(tmpItem.uid ~= 0 and i < tileCount) do
		tmpPos.stackpos = i
		tmpItem = getTileThingByPos(tmpPos)
		if(tmpItem.uid ~= item.uid and tmpItem.uid ~= 0 and isMoveable(tmpItem.uid)) then
			doRemoveItem(tmpItem.uid)
		else
			i = i + 1
		end
	end

	doTransformItem(item.uid, item.itemid - 1)
	return true
end

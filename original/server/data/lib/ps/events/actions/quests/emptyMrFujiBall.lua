local storages = {
	["Fuji's Eevee"] = 8512,
	["Fuji's Cubone"] = 8513,
	["Fuji's Lickitung"] = 8514,
	["Fuji's Totodile"] = 8515,
	["Fuji's Pupitar"] = 8516
}

local function doSendProjectile(fromPosition, toCid, projectile)
	doSendDistanceShoot(fromPosition, getCreaturePosition(toCid), projectile)
end

local SPAWN_INTERVAL = 30 * 1000

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isCreature(itemEx.uid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true

	elseif (getDistanceBetween(getCreaturePosition(cid), toPosition) > 3) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
		return true
	end

	local name = getCreatureName(itemEx.uid)
	if (storages[name]) then
		if (getCreatureStorage(cid, storages[name]) ~= QUEST_STATUS.FINISHED) then
			local creaturePosition = getCreaturePosition(itemEx.uid)

			doSendMagicEffect(creaturePosition, EFFECT_POKEBALL_USE)
			doSendDistanceShoot(getCreaturePosition(cid), creaturePosition, PROJECTILE_POKEBALL)
			addEvent(doSendProjectile, 500, creaturePosition, cid, PROJECTILE_POKEBALL)
			doRemoveCreature(itemEx.uid)
			doRemoveItem(item.uid, 1)
			doPlayerSafeAddItem(cid, 25051, 1, true, true) -- charged mr. fuji poke ball
			doCreatureSetStorage(cid, storages[name], QUEST_STATUS.FINISHED)
			addEvent(doCreateNpc, SPAWN_INTERVAL, name, toPosition)

		else
			doPlayerSendCancel(cid, "You already caught this Pokemon.")
		end

	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	end

	return true
end

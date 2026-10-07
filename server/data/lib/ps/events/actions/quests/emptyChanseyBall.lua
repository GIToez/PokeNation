local function doSendProjectile(fromPosition, toCid, projectile)
	doSendDistanceShoot(fromPosition, getCreaturePosition(toCid), projectile)
end

local SPAWN_INTERVAL = 30 * 1000

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (isCreature(itemEx.uid) and getCreatureName(itemEx.uid) == "Kidnapped Chansey") then
		local creaturePosition = getCreaturePosition(itemEx.uid)

		doSendMagicEffect(creaturePosition, EFFECT_POKEBALL_USE)
		doSendDistanceShoot(getCreaturePosition(cid), creaturePosition, PROJECTILE_POKEBALL)
		addEvent(doSendProjectile, 500, creaturePosition, cid, PROJECTILE_POKEBALL)
		doRemoveCreature(itemEx.uid)
		doRemoveItem(item.uid, 1)
		doPlayerAddItem(cid, 13817, 1, true) -- charged chansey ball
		addEvent(doCreateNpc, SPAWN_INTERVAL, "Kidnapped Chansey", toPosition)

	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	end

	return true
end

local USE_POSITION = {x = 3893, y = 325, z = 8}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
	doSendMagicEffect(toPosition, EFFECT_JENNYS_RADAR)

	if (getSamePosition(toPosition, USE_POSITION)) then
		local destination = (getPlayerDefeatedNPC(cid, 9706) and {x = 3891, y = 390, z = 10} or {x = 3894, y = 329, z = 9})
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
		doTeleportThing(cid, destination)
		doSendMagicEffect(destination, EFFECT_TELEPORT_DOWN)
	end
	return true
end

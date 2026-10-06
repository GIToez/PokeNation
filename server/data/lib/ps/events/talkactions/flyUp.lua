local POSITION_Z_MIN = 0

function onSay(cid, words, param)
	if ((not isFlying(cid) and not isLevitating(cid)) or isUnderwater(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	else
		local playerPosition = getCreaturePosition(cid)
		local upPosition = {x = playerPosition.x, y = playerPosition.y, z = playerPosition.z, stackpos = STACKPOS_GROUND}
		local floors = tonumber(param) or 1
		local canUp = true
		for i = 1, floors do
			upPosition.z = upPosition.z - 1
			local upPositionThing = getTileThingByPos(upPosition)
			if (upPosition.z < POSITION_Z_MIN or isItem(upPositionThing) and upPositionThing.itemid ~= VOID_TILE_ID) then
				canUp = false
				break
			end
		end

		if (canUp) then
			for i, unsetTilePosition in ipairs(getUnsetTilesArroundPosition(upPosition)) do
				doCreateTileInPosition(VOID_TILE_ID, unsetTilePosition)
			end
			doTeleportThing(cid, upPosition)
			deleteTilesArroundPositionWithId(playerPosition, VOID_TILE_ID)
			doCreatureSay(cid, string.format(__L(cid, "%s, go up!"), getPlayerPokemonNickname(cid)), TALKTYPE_MONSTER)
            doSendMagicEffect(playerPosition, EFFECT_TELEPORT_FRAME)
            doSendMagicEffect(upPosition, EFFECT_TELEPORT_FRAME)

		else
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		end
	end

	return true
end

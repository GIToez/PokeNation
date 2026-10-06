local POSITION_Z_MAX = 15

function onSay(cid, words, param)
	if ((not isFlying(cid) and not isLevitating(cid)) or isUnderwater(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	else
		local playerPosition = getCreaturePosition(cid)
		local downPosition = {x = playerPosition.x, y = playerPosition.y, z = playerPosition.z, stackpos = STACKPOS_GROUND}
		local floors = tonumber(param) or 1
		local canDown = true

		if (not isItem(getTileItemById({x = playerPosition.x , y = playerPosition.y, z = playerPosition.z,
            stackpos = STACKPOS_GROUND}, VOID_TILE_ID))) then
			canDown = false
		else
			--local lastDownPositionThing
			for i = 1, floors do
				downPosition.z = downPosition.z + 1
				local downPositionThing = getTileThingByPos(downPosition)
				if (downPosition.z > POSITION_Z_MAX or getHouseFromPos(downPosition) or
                    (
                        isItem(downPositionThing) and
                        (
                            not isWalkable(cid, downPosition) or i < floors
                            --[[(lastDownPositionThing and lastDownPositionThing.itemid > 0)]]
                        )
                    )
                ) then
					canDown = false
					break
				end
				--lastDownPositionThing = downPositionThing
			end
		end

		if (canDown) then
			for i, unsetTilePosition in ipairs(getUnsetTilesArroundPosition(downPosition)) do
				doCreateTileInPosition(VOID_TILE_ID, unsetTilePosition)
			end
			doTeleportThing(cid, downPosition)
			deleteTilesArroundPositionWithId(playerPosition, VOID_TILE_ID)
			doCreatureSay(cid, string.format(__L(cid, "%s , go down!"), getPlayerPokemonNickname(cid)), TALKTYPE_MONSTER)
            doSendMagicEffect(playerPosition, EFFECT_TELEPORT_FRAME)
            doSendMagicEffect(downPosition, EFFECT_TELEPORT_FRAME)

		else
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		end
	end
	return true
end

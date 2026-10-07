local TELEPORT_TILE_BLUE_ID = 11906
local TELEPORT_TILE_RED_ID = 11905

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (isPlayer(cid)) then
		if (getPlayerMounted(cid) or isBiking(cid)) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
			doTeleportThing(cid, lastPosition)
		elseif (item.actionid == 100) then -- leaving from pvp-arena
			if (not doPvpArenaLeave(cid) and not getPlayerPvpArena(cid)) then -- Player trapped on arena
				doTeleportThing(cid, TRADE_ROOM_POSITION)
			end
		else
			local arena = getPvpArenaByActionId(item.actionid)
			if (arena and
                not doPvpArenaJoin(cid, arena, (item.itemid == TELEPORT_TILE_BLUE_ID and PVP_ARENA_TEAM_BLUE
                        or PVP_ARENA_TEAM_RED))) then
					doTeleportThing(cid, lastPosition)
			end
		end
	end
	return true
end

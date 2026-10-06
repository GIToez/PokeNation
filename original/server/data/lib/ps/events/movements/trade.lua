local REQUIREMENTS = {}
REQUIREMENTS[{x = 3010, y = 2895, z = 5}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end -- Valencia
REQUIREMENTS[{x = 3068, y = 1669, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end -- Pummelo

REQUIREMENTS[{x = 3270, y = 1490, z = 5}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end -- Tarroco
REQUIREMENTS[{x = 3466, y = 1474, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end -- Hamlin
REQUIREMENTS[{x = 3525, y = 1698, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end -- Kumquat

REQUIREMENTS[{x = 2951, y = 2237, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end -- Mandarin North
REQUIREMENTS[{x = 4119, y = 1745, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end -- Butwal
REQUIREMENTS[{x = 4458, y = 2239, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end -- Navel

REQUIREMENTS[{x = 4427, y = 1724, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end -- Ascorbia
REQUIREMENTS[{x = 4370, y = 2672, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end -- Seven Grapefruit
REQUIREMENTS[{x = 4167, y = 2958, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end -- Moro

REQUIREMENTS[{x = 4206, y = 3171, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Murcott
REQUIREMENTS[{x = 3600, y = 3289, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Mandarin South
REQUIREMENTS[{x = 3593, y = 3151, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Mandarin South
REQUIREMENTS[{x = 3485, y = 3221, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Mandarin South
REQUIREMENTS[{x = 3532, y = 1924, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Shamouti

local ACTION_ID_TELEPORT_BACK = 100

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (isPlayer(cid)) then
		if (item.actionid == 0) then
            for k, v in pairs(REQUIREMENTS) do
                if (getSamePosition(k, position)) then
                    if (not v(cid)) then
                        doTeleportThing(cid, lastPosition, false)
                        doPlayerSendCancel(cid, "You do not have enough access to enter here!")
                        return true
                    end
                    break
                end
            end

			setPlayerBackPosition(cid, fromPosition)
			doTeleportThing(cid, TRADE_ROOM_POSITION, false)

		elseif (item.actionid == ACTION_ID_TELEPORT_BACK) then
			doTeleportThing(cid, getPlayerBackPosition(cid), false)

		elseif (item.actionid == 152) then
			EliteFour.doRemovePlayer(cid)

		end
	end
	return true
end

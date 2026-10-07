local COOLDOWN = 30 * 60

local playerCache = {}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local guid = getPlayerGUID(cid)
    if (playerCache[guid] and os.time() - playerCache[guid] < COOLDOWN) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You received Suramoon essences recently, please try again later.")
        return true
    end

    doPlayerSafeAddItem(cid, 25185, 5, true, true, true)
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You received some Suramoon essences.")
    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_ENERGY)
    doSendMagicEffect(toPosition, EFFECT_BLUE_BUFF)
    playerCache[guid] = os.time()
    doTeleportThing(cid, TRADE_ROOM_POSITION, false)
	return true
end

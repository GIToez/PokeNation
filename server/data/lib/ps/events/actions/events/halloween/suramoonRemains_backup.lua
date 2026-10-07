local MAX_ESSENCE = 63
local ESSENCE_STORAGE = 8540
local COOLDOWN = 30 * 60

local playerCache = {}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local count = getCreatureStorage(cid, ESSENCE_STORAGE)
    if (count >= MAX_ESSENCE) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You already got all essences.")
        return true
    end

    local guid = getPlayerGUID(cid)
    if (playerCache[guid] and os.time() - playerCache[guid] < COOLDOWN) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You received Suramoon essences recently, please try again later.")
        return true
    end

    count = count > 0 and count or 0
    local adds = math.floor((100 - count) / 10)

    doPlayerSafeAddItem(cid, 25185, adds, true, true, true)
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You received some Suramoon essences.")
    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_ENERGY)
    doSendMagicEffect(toPosition, EFFECT_BLUE_BUFF)
    playerCache[guid] = os.time()
    doCreatureSetStorage(cid, ESSENCE_STORAGE, count + adds)
    doTeleportThing(cid, TRADE_ROOM_POSITION, false)
	return true
end

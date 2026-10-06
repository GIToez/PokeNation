-- teleports[itemid][actionid]
local teleports = {}

teleports[17082] = {}
teleports[17082][100] = function(cid, item, fromPosition, itemEx, toPosition) -- Going to Fly Tribe
    local pos = {x = 4957, y = 317, z = 7}
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)
end

teleports[17082][101] = function(cid, item, fromPosition, itemEx, toPosition) -- Leaving Fly Tribe
    local pos = {x = 3457, y = 2489, z = 1}
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)
end

--
teleports[16862] = {}
teleports[16862][100] = function(cid, item, fromPosition, itemEx, toPosition) -- Going to Mountain Tribe
    local pos = {x = 3663, y = 1680, z = 9}
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)
end

teleports[16862][101] = function(cid, item, fromPosition, itemEx, toPosition) -- Leaving Mountain Tribe
    local pos = {x = 3582, y = 1643, z = 8}
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)
end

--
teleports[15683] = {}
teleports[15683][100] = function(cid, item, fromPosition, itemEx, toPosition) -- Going to Sea Tribe
    local pos = {x = 4528, y = 2360, z = 10}
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)
end

teleports[15683][101] = function(cid, item, fromPosition, itemEx, toPosition) -- Leaving Sea Tribe
    local pos = {x = 4393, y = 2244, z = 10}
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)
end


function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not teleports[item.itemid] or not teleports[item.itemid][item.actionid]) then
        return true
    end

    teleports[item.itemid][item.actionid](cid, item, fromPosition, itemEx, toPosition)
	return true
end

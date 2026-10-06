local ROOMS = {
    {x = 3801, y = 809, z = 9},
    {x = 3810, y = 809, z = 9},
    {x = 3819, y = 809, z = 9},
    {x = 3801, y = 800, z = 9},
    {x = 3810, y = 800, z = 9},
    {x = 3819, y = 800, z = 9},
    {x = 3810, y = 792, z = 9},
}

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid) or isPlayerGhost(cid, true)) then
        return true

    elseif (getRandom(0, 100) <= 20) then
        setPlayerBackPosition(cid, position)
        local newPos = table.random(ROOMS)
        doSendMagicEffect(position, EFFECT_TELEPORT_UP)
        doTeleportThing(cid, newPos, false)
        doSendMagicEffect(newPos, EFFECT_TELEPORT_DOWN)
        return false
    end

    return true
end
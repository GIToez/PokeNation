function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid)) then
        return true
    end

    doTeleportThing(cid, {x = 3935, y = 666, z = 7})
    return false
end
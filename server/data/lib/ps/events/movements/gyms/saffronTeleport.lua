function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid)) then
        return true
    end

    doTeleportThing(cid, {x = 3404, y = 391, z = 6})
    return false
end
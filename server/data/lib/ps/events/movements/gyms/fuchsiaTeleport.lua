function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid) or item.actionid < 100) then
        return true

    elseif (item.actionid == 100) then -- Leaving
        doTeleportThing(cid, {x = 3861, y = 814, z = 7})
        return false

    elseif (item.actionid == 101) then -- Backing
        doTeleportThing(cid, getPlayerBackPosition(cid))
        return false

    else
        log(LOG_TYPES.ERROR, "onStepIn fuchsiaTeleport - Unknown actionid", item.actionid, position)
    end

    return true
end
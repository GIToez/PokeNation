function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid)) then
        return true
    end

    if (isPokemonOnline(cid)) then
		doPlayerUseBallOnSlot(cid)
    end

    if (not isPokemonOnline(cid)) then
        doTeleportThing(cid, {x = 5066, y = 152, z = 7}, false)
        doPlayerRemoveFrontierBalls(cid)
        setPlayerFrontierIsland(cid, false)
    else
        doSendMagicEffect(position, EFFECT_POFF)
    end
    return false
end
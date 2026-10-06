local TREASURE_POSITION = {x = 3217, y = 275, z = 6}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not doComparePositions(toPosition, TREASURE_POSITION)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local playerPosition = getCreaturePosition(cid)
    doSendDistanceShoot(playerPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EARTH_EXPLOSION)
    doPlayerSafeAddItem(cid, 28051, 1, true, true)
    doRemoveItem(item.uid)

    return true
end

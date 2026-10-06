local ROOM_CENTER_POS = {x = 5024, y = 288, z = 7}

local function doEffect(pos)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE_FIRE)
    addEvent(doSendMagicEffect, 300, pos, EFFECT_BIG_FLAMES)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    doRemoveItem(item.uid)
    doSendMagicEffect(fromPosition, EFFECT_BIG_FLAMES)
    doSendDistanceShoot(fromPosition, getSkyPosition(fromPosition), PROJECTILE_FIRE)

    -- Fire boss event
    for i = 0, 120 do
        addEvent(doEffect, (i * 200), getPositionRandomAdjacent(ROOM_CENTER_POS, getRandom(0, 7)))
    end

    addEvent(doSendMagicEffect, 30000, ROOM_CENTER_POS, EFFECT_MOLTRES_CRY)
    addEvent(doSendMagicEffect, 32000, ROOM_CENTER_POS, EFFECT_MOLTRES_CRY)
    addEvent(doCreateMonster, 33500, "Boss Moltres", ROOM_CENTER_POS)

    return true
end

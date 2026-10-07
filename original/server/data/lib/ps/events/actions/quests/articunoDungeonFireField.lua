local ROOM_CENTER_POS = {x = 5191, y = 283, z = 7}

local function doEffect(pos)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE_ICE)
    addEvent(doSendMagicEffect, 300, pos, EFFECT_ICEBERG)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    doRemoveItem(item.uid)
    doSendMagicEffect(fromPosition, EFFECT_ICEBERG)
    doSendDistanceShoot(fromPosition, getSkyPosition(fromPosition), PROJECTILE_ICE)

    -- Fire boss event
    for i = 0, 120 do
        addEvent(doEffect, (i * 200), getPositionRandomAdjacent(ROOM_CENTER_POS, getRandom(0, 7)))
    end

    addEvent(doSendMagicEffect, 30000, ROOM_CENTER_POS, EFFECT_ARTICUNO_CRY)
    addEvent(doSendMagicEffect, 32000, ROOM_CENTER_POS, EFFECT_ARTICUNO_CRY)
    addEvent(doCreateMonster, 33500, "Boss Articuno", ROOM_CENTER_POS)

    return true
end

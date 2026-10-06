local BARREL_ITEMID = 18745
local ROOM_CENTER_POS = {x = 5108, y = 289, z = 7}
local BARRELS = {
    {x = 5104, y = 281, z = 7},
    {x = 5098, y = 283, z = 7},
    {x = 5102, y = 290, z = 7},
    {x = 5108, y = 286, z = 7},
    {x = 5112, y = 281, z = 7},
    {x = 5118, y = 283, z = 7},
    {x = 5114, y = 290, z = 7}
}

local function doEffect(pos)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE_THUNDER)
    addEvent(doSendMagicEffect, 300, pos, EFFECT_ELECTRIC_CLOUD)
end

function onAddItem(moveItem, tileItem, position, cid)
    if (moveItem.itemid ~= BARREL_ITEMID) then
        return true
    end

    -- Check if barrels are on positions
    local items = {}
    for _, pos in pairs(BARRELS) do
        local item = getTileItemById(pos, BARREL_ITEMID)
        if (not isItem(item)) then
            return true
        end
        items[#items + 1] = item
    end

    -- Remove all barrels, to prevent another event execution
    for i, item in pairs(items) do
        doRemoveItem(item.uid)
        doSendMagicEffect(BARRELS[i], EFFECT_ELECTRIC_SPARK_TWO)
        doSendDistanceShoot(BARRELS[i], getSkyPosition(BARRELS[i]), PROJECTILE_THUNDER)
    end

    -- Fire boss event
    for i = 0, 120 do
        addEvent(doEffect, (i * 200), getPositionRandomAdjacent(ROOM_CENTER_POS, getRandom(0, 7)))
    end

    addEvent(doSendMagicEffect, 30000, ROOM_CENTER_POS, EFFECT_ZAPDOS_CRY)
    addEvent(doSendMagicEffect, 31500, ROOM_CENTER_POS, EFFECT_ZAPDOS_CRY)
    addEvent(doCreateMonster, 33000, "Boss Zapdos", ROOM_CENTER_POS)

    return true
end
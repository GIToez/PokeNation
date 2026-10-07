if (Dungeons) then
    return
end

Dungeons = {}

Dungeons.Articuno = {}
Dungeons.Articuno.doReset = function()
    local BLUEFIRE_POS = {x = 5191, y = 281, z = 7}
    local BLUEFIRE_ITEMID = 18738
    local SPAWN_CENTER_POS = {x = 5191, y = 288, z = 7}

    local blueFire = getTileItemById(BLUEFIRE_POS, BLUEFIRE_ITEMID)
    if (not isItem(blueFire)) then
        blueFire = doCreateItem(BLUEFIRE_ITEMID, 1, BLUEFIRE_POS)
    end

    local spec = getSpectators(SPAWN_CENTER_POS, 17, 12, false)
    if (spec) then
        for _, cid in pairs(spec) do
            doRemoveCreature(cid)
        end
    end
end

Dungeons.Zapdos = {}
Dungeons.Zapdos.doReset = function()
    local SPAWN_CENTER_POS = {x = 5107, y = 287, z = 7}
    local BARREL_ITEMID = 18745
    local BARREL_START_POS = {x = 5105, y = 289, z = 7}

    for i = 0, 6 do
        setItemScriptProtected(doCreateItem(BARREL_ITEMID, 1, {x = BARREL_START_POS.x + i, y = BARREL_START_POS.y,
            z = BARREL_START_POS.z}), true)
    end

    local spec = getSpectators(SPAWN_CENTER_POS, 17, 12, false)
    if (spec) then
        for _, cid in pairs(spec) do
            doRemoveCreature(cid)
        end
    end
end

Dungeons.Moltres = {}
Dungeons.Moltres.doReset = function()
    local TRUMPET_POS = {x = 5025, y = 279, z = 7}
    local TRUMPET_ITEMID = 18739
    local SPAWN_CENTER_POS = {x = 5024, y = 288, z = 7}

    local blueFire = getTileItemById(TRUMPET_POS, TRUMPET_ITEMID)
    if (not isItem(blueFire)) then
        blueFire = doCreateItem(TRUMPET_ITEMID, 1, TRUMPET_POS)
    end

    local spec = getSpectators(SPAWN_CENTER_POS, 17, 12, false)
    if (spec) then
        for _, cid in pairs(spec) do
            doRemoveCreature(cid)
        end
    end
end
local INV_TILE_ITEMID = 18743
local ICE_TILE_ITEMID = 6967
local ICE_PILLAR_ITEMID = 18742

local function doResetTile(pos)
    local spec = getSpectators(pos, 1, 1, false)
    if (spec) then
        for _, cid in pairs(spec) do
            doRelocate(pos, getClosestFreeTile(cid, pos, true), true)
            break
        end
    end

    local tile = getTileItemById(pos, ICE_TILE_ITEMID)
    if (isItem(tile)) then
        doRemoveItem(tile.uid)
    end

    local pillar = getTileItemById({x = pos.x, y = pos.y, z = pos.z + 1}, ICE_PILLAR_ITEMID)
    if (isItem(pillar)) then
        doRemoveItem(pillar.uid)
    end

    if (not isItem(getTileItemById(pos, INV_TILE_ITEMID))) then
        doCreateItem(INV_TILE_ITEMID, 1, pos)
    end

    doSendMagicEffect(pos, EFFECT_ICE_EXPLOSION)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or itemEx.itemid ~= INV_TILE_ITEMID) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doRemoveItem(itemEx.uid)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_ICE_TWO)
    doCreateItem(ICE_TILE_ITEMID, 1, toPosition)
    if (toPosition.z < 7) then -- 8+ doenst have tiles at this dungeon
        doCreateItem(ICE_PILLAR_ITEMID, 1, {x = toPosition.x, y = toPosition.y, z = toPosition.z + 1})
    end
    doSendMagicEffect(toPosition, EFFECT_ICEBERG_TWO)
    doRemoveItem(item.uid)

    addEvent(doResetTile, 20 * 60 * 1000, toPosition)
	return true
end

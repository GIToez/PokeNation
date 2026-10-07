TILE_SNOW = 670
TILE_FOOTPRINT_I = 6594
TILE_FOOTPRINT_II = 6598

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (not isPlayer(cid) or isPlayerGhost(cid, true)) then
		return true

    elseif (Ski.isUsing(cid)) then
        Ski.onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)

    else
        if (item.itemid == TILE_SNOW) then
            doTransformItem(item.uid, TILE_FOOTPRINT_I)
            doDecayItem(item.uid)

        elseif (item.itemid == TILE_FOOTPRINT_I) then
            doTransformItem(item.uid, TILE_FOOTPRINT_II)
            doDecayItem(item.uid)

        else
            doTransformItem(item.uid, TILE_FOOTPRINT_I)
        end
    end

	return true
end

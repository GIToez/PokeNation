local SAND_ITEMID = 231

local TRACES = {
    -- Dirt
    [351] = 18136,
    [352] = 18136,
    [353] = 18136,
    [354] = 18136,
    -- Grass
    [4526] = 18140,
    [4527] = 18140,
    [4528] = 18140,
    [4529] = 18140,
    [4530] = 18140,
    [4531] = 18140,
    [4532] = 18140,
    [4533] = 18140,
    [4534] = 18140,
    [4535] = 18140,
    [4536] = 18140,
    [4537] = 18140,
    [4538] = 18140,
    [4539] = 18140,
    [4540] = 18140,
    [4541] = 18140,
    -- Sand
    [SAND_ITEMID] = 18156
}

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (isPlayer(cid) and not isPlayerGhost(cid, true) and not isBiking(cid)) then
        if (item.itemid == SAND_ITEMID and Sandboard.isUsing(cid)) then
            Sandboard.onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        end

        if (getRandom(0, 1) == 0) then
            doTransformItem(item.uid, TRACES[item.itemid])
		    doDecayItem(item.uid)
        end
    end
	return true
end
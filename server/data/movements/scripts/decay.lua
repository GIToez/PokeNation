local TRAP_TILES = {293, 461}

function onStepIn(cid, item, position, fromPosition)
    if (table.find(TRAP_TILES, item.itemid) and not isPlayer(cid)) then -- Bug fix: If the Pokemon drop on a trap tile, the master will become invisible to all Pokemon on the upper floor. The best way to fix this is by source, but it's dangerous, let's leave this for now. TODO: <<<
        return true
    end

	doTransformItem(item.uid, item.itemid + 1)
	doDecayItem(item.uid)
	return true
end

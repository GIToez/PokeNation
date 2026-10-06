local GRASSES = {10736, 10737, 10738, 10739}

function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (not isPlayerGhost(cid, true) and getRandom(0, 100) <= 30) then
        doTransformItem(item.uid, table.random(GRASSES))
    end
	return true
end

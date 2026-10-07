local GRASSES = {6216, 6217, 6218, 6219}

function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (not isPlayerGhost(cid, true) and getRandom(0, 100) <= 30) then
        doTransformItem(item.uid, table.random(GRASSES))
    end
	return true
end

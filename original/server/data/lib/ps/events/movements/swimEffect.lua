local effect = {
    [NORTH] = EFFECT_SWIM_UP,
    [EAST] = EFFECT_SWIM_RIGHT,
    [SOUTH] = EFFECT_SWIM_DOWN,
    [WEST] = EFFECT_SWIM_LEFT
}

function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (not isPlayerGhost(cid, true)) then
        doSendMagicEffect(lastPosition, effect[getCreatureLookDirection(cid)])
    end
	return true
end

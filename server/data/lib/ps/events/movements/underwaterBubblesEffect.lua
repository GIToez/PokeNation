function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (not isPlayerGhost(cid, true) and getRandom(0, 100) <= 30) then
        doSendMagicEffect(lastPosition, EFFECT_BUBBLES_TWO)
    end
	return true
end

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (isPlayer(cid) and not isPlayerGhost(cid, true) and getRandom(0, 100) <= 30) then
        doCreatureTrueDamage(cid, -500, EFFECT_BIG_FLAMES, TEXTCOLOR_RED, position)
    end
	return true
end

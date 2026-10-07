local condition = createConditionObject(CONDITION_DAZZLED)
addDamageCondition(condition, 5, 2000, -200)

local paralyzeCondition = createConditionObject(CONDITION_PARALYZE, 5000)
setConditionFormula(paralyzeCondition, -0.7, 0, -0.7, 0)

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	if (not isPlayerGhost(cid, true) and getRandom(0, 100) <= 30) then
        doSendMagicEffect(position, EFFECT_BIG_ELECTRIC_BALL)
        doAddCondition(cid, condition)
        doAddCondition(cid, paralyzeCondition)
    end
	return true
end

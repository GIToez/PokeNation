local SKILL_NAME = "Leech Life"

function onTargetCreature_LeechLife(cid, target)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_YELLOW_CIRCLE_TWO)
	doSkillHealthDrain(cid, target, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LeechLife")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

local SKILL_NAME = "Chip Away"

function onTargetCreature_ChipAway(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ChipAway")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
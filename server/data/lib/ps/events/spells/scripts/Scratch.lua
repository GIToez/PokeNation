local SKILL_NAME = "Scratch"

function onTargetCreature_Scratch(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Scratch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

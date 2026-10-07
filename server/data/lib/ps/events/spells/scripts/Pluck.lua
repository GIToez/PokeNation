local SKILL_NAME = "Pluck"

function onTargetCreature_Pluck(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Pluck")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

local SKILL_NAME = "Crabhammer"

function onTargetCreature_Crabhammer(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Crabhammer")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

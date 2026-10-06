local SKILL_NAME = "Pound"

function onTargetCreature_Pound(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Pound")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

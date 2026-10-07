local SKILL_NAME = "Pursuit"

function onTargetCreature_Pursuit(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Pursuit")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

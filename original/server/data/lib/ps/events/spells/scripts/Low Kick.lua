local SKILL_NAME = "Low Kick"

function onTargetCreature_LowKick(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LowKick")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

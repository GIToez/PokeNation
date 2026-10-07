local SKILL_NAME = "Double Kick"

function onTargetCreature_DoubleKick(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DoubleKick")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

local SKILL_NAME = "Hammer Arm"

function onTargetCreature_HammerArm(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HammerArm")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

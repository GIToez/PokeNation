local SKILL_NAME = "Mach Punch"

function onTargetCreature_MachPunch(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MachPunch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
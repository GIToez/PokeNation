local SKILL_NAME = "Drain Punch"

function onTargetCreature_DrainPunch(cid, target)
	doSkillHealthDrain(cid, target, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DrainPunch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

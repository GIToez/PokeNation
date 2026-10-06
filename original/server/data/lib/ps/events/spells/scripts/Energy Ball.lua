local SKILL_NAME = "Energy Ball"

function onTargetCreature_EnergyBall(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_EnergyBall")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

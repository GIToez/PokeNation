local SKILL_NAME = "Take Down"

function onTargetCreature_TakeDown(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_TakeDown")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

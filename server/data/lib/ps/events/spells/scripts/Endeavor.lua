local SKILL_NAME = "Endeavor"

function onTargetCreature_Endeavor(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Endeavor")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

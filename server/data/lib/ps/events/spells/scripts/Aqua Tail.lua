local SKILL_NAME = "Aqua Tail"

function onTargetCreature_AquaTail(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AquaTail")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

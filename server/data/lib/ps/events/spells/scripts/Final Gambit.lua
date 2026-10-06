local SKILL_NAME = "Tackle"

function onTargetCreature_Tackle(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Tackle")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

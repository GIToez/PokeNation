local SKILL_NAME = "Sonic Boom"

function onTargetCreature_SonicBoom(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SonicBoom")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

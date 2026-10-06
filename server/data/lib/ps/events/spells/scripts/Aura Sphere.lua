local SKILL_NAME = "Aura Sphere"

function onTargetCreature_AuraSphere(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AuraSphere")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
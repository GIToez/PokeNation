local SKILL_NAME = "Power Whip"

function onTargetCreature_PowerWhip(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PowerWhip")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

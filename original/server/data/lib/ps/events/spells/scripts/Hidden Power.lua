local SKILL_NAME = "Hidden Power"

function onTargetCreature_HiddenPower(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HiddenPower")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

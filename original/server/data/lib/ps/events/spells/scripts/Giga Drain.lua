local SKILL_NAME = "Giga Drain"

function onTargetCreature_GigaDrain(cid, target)
	doSkillHealthDrain(cid, target, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_GigaDrain")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

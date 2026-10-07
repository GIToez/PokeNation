local SKILL_NAME = "Mega Drain"

function onTargetCreature_MegaDrain(cid, target)
	doSkillHealthDrain(cid, target, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MegaDrain")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end


local SKILL_NAME = "Absorb"

function onTargetCreature_Absorb(cid, target)
	doSkillHealthDrain(cid, target, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Absorb")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end


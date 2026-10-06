local SKILL_NAME = "Draining Kiss"

function onTargetCreature_DrainingKiss(cid, target)
	doSkillHealthDrain(cid, target, SKILL_NAME, 1.33) -- 75%
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DrainingKiss")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end


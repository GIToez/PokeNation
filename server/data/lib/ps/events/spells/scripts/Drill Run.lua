local SKILL_NAME = "Drill Run"

function onTargetCreature_DrillRun(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, 3)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DrillRun")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

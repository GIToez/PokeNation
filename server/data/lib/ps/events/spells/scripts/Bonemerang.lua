local SKILL_NAME = "Bonemerang"

function onTargetCreature_Bonemerang(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Bonemerang")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

local SKILL_NAME = "Rage"

function onTargetCreature_Rage(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, getRandom(2, 5))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Rage")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

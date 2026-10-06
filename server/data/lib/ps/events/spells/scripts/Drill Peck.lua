local SKILL_NAME = "Drill Peck"

function onTargetCreature_DrillPeck(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, 3, getPokemonSkillDamage(SKILL_NAME) / 3)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DrillPeck")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

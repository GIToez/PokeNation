local SKILL_NAME = "Wring Out"

function onTargetCreature_WringOut(cid, target)
    doSkillMultipleDamages(cid, SKILL_NAME, 5, math.floor((120 * (getCreatureHealth(target) / getCreatureMaxHealth(target))) / 5))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WringOut")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
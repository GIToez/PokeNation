local SKILL_NAME = "Belch"

function onTargetCreature_Belch(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Belch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
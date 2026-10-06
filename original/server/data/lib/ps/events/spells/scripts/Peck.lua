local SKILL_NAME = "Peck"

function onTargetCreature_Peck(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Peck")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

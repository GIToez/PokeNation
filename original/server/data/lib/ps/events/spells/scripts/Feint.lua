local SKILL_NAME = "Feint"

function onTargetCreature_Feint(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Feint")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

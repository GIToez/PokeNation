local SKILL_NAME = "Slash"

function onTargetCreature_Slash(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Slash")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

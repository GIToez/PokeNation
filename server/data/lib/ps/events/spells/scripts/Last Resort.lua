local SKILL_NAME = "Last Resort"

function onTargetCreature_LastResort(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LastResort")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

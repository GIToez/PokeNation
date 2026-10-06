local SKILL_NAME = "Shadow Punch"

function onTargetCreature_ShadowPunch(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ShadowPunch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

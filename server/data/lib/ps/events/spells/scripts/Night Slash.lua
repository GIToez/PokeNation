local SKILL_NAME = "Night Slash"

function onTargetCreature_NightSlash(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_NightSlash")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

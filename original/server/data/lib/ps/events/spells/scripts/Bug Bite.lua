local SKILL_NAME = "Bug Bite"

function onTargetCreature_BugBite(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_BugBite")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

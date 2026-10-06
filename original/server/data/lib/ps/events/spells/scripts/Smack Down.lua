local SKILL_NAME = "Smack Down"

function onTargetCreature_SmackDown(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SmackDown")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
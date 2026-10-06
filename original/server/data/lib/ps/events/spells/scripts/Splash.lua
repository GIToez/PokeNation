local SKILL_NAME = "Splash"

function onTargetCreature_Splash(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Splash")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

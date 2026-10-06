local SKILL_NAME = "Dragon Claw"

function onTargetCreature_DragonClaw(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DragonClaw")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

local SKILL_NAME = "Wood Hammer"

function onTargetCreature_WoodHammer(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WoodHammer")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

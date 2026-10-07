local SKILL_NAME = "Super Fang"

function onTargetCreature_SuperFang(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SuperFang")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

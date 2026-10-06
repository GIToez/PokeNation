local SKILL_NAME = "Horn Attack"

function onTargetCreature_HornAttack(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HornAttack")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

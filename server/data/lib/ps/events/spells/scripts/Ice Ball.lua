local SKILL_NAME = "Ice Ball"

function onTargetCreature_IceBall(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_IceBall")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

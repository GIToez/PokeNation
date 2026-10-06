local SKILL_NAME = "Guillotine"

function onTargetCreature_Guillotine(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Guillotine")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

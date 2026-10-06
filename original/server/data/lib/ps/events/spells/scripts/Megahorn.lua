local SKILL_NAME = "Megahorn"

function onTargetCreature_Megahorn(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Megahorn")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

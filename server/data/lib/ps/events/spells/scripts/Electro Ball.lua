local SKILL_NAME = "Electro Ball"

function onTargetCreature_ElectroBall(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ElectroBall")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

local SKILL_NAME = "Low Sweep"

function onTargetCreature_LowSweep(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
	if (not isCreature(target)) then return end -- Defeated
	doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LowSweep")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
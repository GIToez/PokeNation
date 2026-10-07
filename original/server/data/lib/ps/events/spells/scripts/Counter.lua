-- local SKILL_NAME = "Counter"

function onTargetCreature_Counter(cid, target)
	doCreatureAddStatus(cid, CREATURE_STATUS_COUNTER, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Counter")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

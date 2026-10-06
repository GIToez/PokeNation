-- local SKILL_NAME = "Rest"

function onTargetCreature_Rest(cid, target)
	if (doCreatureAddStatus(cid, CREATURE_STATUS_SLEEP, nil, cid)) then
        doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
    else
        doSendAnimatedText(getCreaturePosition(cid), "FAIL!", COLOR_WHITE)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Rest")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

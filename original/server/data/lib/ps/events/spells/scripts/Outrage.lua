local SKILL_NAME = "Outrage"

function onTargetCreature_Outrage(cid, target)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_PURGATORY)
    doSkillMultipleDamages(cid, SKILL_NAME, getRandom(2, 3))
	addEvent(doCreatureAddStatus, 3 * 500, cid, CREATURE_STATUS_CONFUSION, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Outrage")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

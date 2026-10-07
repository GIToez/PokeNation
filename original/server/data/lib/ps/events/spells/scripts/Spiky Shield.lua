-- local SKILL_NAME = "SpikyShield"

function onTargetCreature_SpikyShield(cid, target)
	doCreatureAddStatus(cid, CREATURE_STATUS_PROTECTION, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SpikyShield")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_MIRROR)
	return doCombat(cid, combat, var)
end

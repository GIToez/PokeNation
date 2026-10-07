-- local SKILL_NAME = "Scary Face"

function onTargetCreature_ScaryFace(cid, target)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_SCARY_FACE)
	doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BADMEDIUM, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ScaryFace")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

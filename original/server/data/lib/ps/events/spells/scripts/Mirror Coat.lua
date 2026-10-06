-- local SKILL_NAME = "Mirror Coat"

function onTargetCreature_MirrorCoat(cid, target) doCreatureAddStatus(target, CREATURE_STATUS_REFLECT, nil, cid) end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MirrorCoat")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_BIG_MIRROR)
    return doCombat(cid, combat, var)
end

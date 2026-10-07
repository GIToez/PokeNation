local SKILL_NAME = "Water Sport"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_WaterSport(cid, target)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_HIGH, cid)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_HIGH, cid)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WaterSport")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end

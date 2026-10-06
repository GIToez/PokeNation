local SKILL_NAME = "Cotton Guard"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_CottonGuard(cid, target)
    local pos = getCreaturePosition(cid)
	doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_HIGH, cid)
    doSendMagicEffect(pos, EFFECT)
    addEvent(executeInArea, 300, pos, AREA_SQUARE1X1, EFFECT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_CottonGuard")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

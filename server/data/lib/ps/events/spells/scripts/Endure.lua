local SKILL_NAME = "Endure"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_Endure(cid, target)
    local pos = getCreaturePosition(cid)
	doCreatureAddStatus(cid, CREATURE_STATUS_ENDURE, nil, cid)
    doSendMagicEffect(pos, EFFECT)
    addEvent(executeInArea, 300, pos, AREA_SQUARE1X1, EFFECT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Endure")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

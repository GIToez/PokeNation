local SKILL_NAME = "Mind Reader"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_MindReader(cid, target)
    local pos = getCreaturePosition(cid)
	doCreatureAddStatus(cid, CREATURE_STATUS_IGNORE_ACCURACY, nil, cid)
    doSendMagicEffect(pos, EFFECT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MindReader")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

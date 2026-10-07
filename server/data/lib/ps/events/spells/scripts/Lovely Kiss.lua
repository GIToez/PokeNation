local SKILL_NAME = "Lovely Kiss"
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_LovelyKiss(cid, target)
	doSendMagicEffect(getCreaturePosition(target), SKILL_EFFECT)
    doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LovelyKiss")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

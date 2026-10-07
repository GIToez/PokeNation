local SKILL_NAME = "Destiny Bond"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_DestinyBond(cid, target)
	local pos = getCreaturePosition(cid)
	doCreatureAddStatus(cid, CREATURE_STATUS_DESTINY_BOND, nil, cid)
	doSendMagicEffect(pos, EFFECT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DestinyBond")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

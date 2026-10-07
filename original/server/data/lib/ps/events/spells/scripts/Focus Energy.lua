local SKILL_NAME = "Focus Energy"

function onTargetCreature_FocusEnergy(cid, target)
	doCreatureAddStatus(cid, CREATURE_STATUS_HIGHCRITICALCHANCE, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FocusEnergy")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

local SKILL_NAME = "Refresh"

function onTargetCreature_Refresh(cid, target)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_BURN)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_PARALYSIS)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_POISON)
	doCreatureRemoveStatus(cid, CREATURE_STATUS_BADPOISON)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Refresh")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

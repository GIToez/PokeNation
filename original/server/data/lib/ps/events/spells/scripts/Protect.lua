local SKILL_NAME = "Protect"

function onTargetCreature_Protect(cid, target) doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_MEDIUM, cid) end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Protect")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

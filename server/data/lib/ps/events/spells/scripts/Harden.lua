local SKILL_NAME = "Harden"

function onTargetCreature_Harden(cid, target)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)
    doSendCreatureEffect(cid, CREATURE_EFFECTS.GRAY, 10 * 1000)
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Harden")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

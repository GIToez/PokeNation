local SKILL_NAME = "Eerie Impulse"

function onTargetCreature_EerieImpulse(cid, target)
    doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
    doSendMagicEffect(getCreaturePosition(target), getPokemonSkillEffect(SKILL_NAME))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_EerieImpulse")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end

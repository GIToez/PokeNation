local SKILL_NAME = "Memento"

function onTargetCreature_Memento(cid, target)
    doSendMagicEffect(getCreaturePosition(cid), getPokemonSkillEffect(SKILL_NAME))
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
    doCreatureDie(cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Memento")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
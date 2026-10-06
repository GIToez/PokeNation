local SKILL_NAME = "Flatter"

function onTargetCreature_Flatter(cid, target)
    doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
    doCreatureAddStatus(target, CREATURE_STATUS_CONFUSION, nil, cid)
    doSendMagicEffect(getCreaturePosition(target), getPokemonSkillEffect(SKILL_NAME))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Flatter")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end

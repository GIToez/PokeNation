local SKILL_NAME = "Water Pulse"

function onTargetCreature_WaterPulse(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 40 or 20)) then
        doCreatureAddStatus(target, CREATURE_STATUS_CONFUSION, nil, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WaterPulse")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
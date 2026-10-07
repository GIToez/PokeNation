local SKILL_NAME = "Sunny Day"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_SunnyDay(cid, target)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_HIGH, cid)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_HIGH, cid)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SunnyDay")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
    doCombat(cid, combat, var)

    if (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.FORECAST, nil)) then
        local tmp = getCreatureOutfit(cid)
        tmp.lookType = 1614

        doCreatureChangeOutfit(cid, tmp)
        setPokemonCustomType(cid, ELEMENT_FIRE)
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIRE_FIELD)
    end

    return true
end

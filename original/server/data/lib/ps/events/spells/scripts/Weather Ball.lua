local SKILL_NAME = "Weather Ball"

local function getType(cid)
    if (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.FORECAST, nil) and getPokemonCustomType(cid)) then
        return getPokemonCustomType(cid)
    end

    return getPokemonTypes(cid)[1]
end

function onTargetCreature_WeatherBall(cid, target)
    local type = getType(cid)
    local power = getPokemonSkillDamage(SKILL_NAME)
    if (type == ELEMENT_NORMAL) then
        power = power * 2
    end
    doSkillDamage(cid, target, SKILL_NAME, power, nil, type)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WeatherBall")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end

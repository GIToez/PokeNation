local SKILL_NAME = "Secret Power"
--local SKILL_AREAS = {
--    createCombatArea(AREA_CIRCLE3X3)
--}
--local SKILL_PROJECTILE = PROJECTILE_ICE

local ENVIRONMENT_EFFECTS = {
    {
        -- Building, road, plain terrain, and link battles
        projectile = PROJECTILE_GRAVEL,
        effect = EFFECT_POFF,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
            end
        end
    },
    {
        -- Electric Terrain
        projectile = PROJECTILE_THUNDER,
        effect = EFFECT_THUNDER_CLOUD,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
            end
        end
    },
    {
        -- Cave
        projectile = PROJECTILE_ROCK,
        effect = EFFECT_EARTH_EXPLOSION,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, nil, cid)
            end
        end
    },
    {
        -- Sand, dirt, and rock
        projectile = PROJECTILE_EARTH_SHOT,
        effect = EFFECT_MUD_SPLASH,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_LOWACCURACY, nil, cid)
            end
        end
    },
    {
        -- Water
        projectile = PROJECTILE_BUBBLES_TWO,
        effect = EFFECT_WATER_EMERGE,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, cid)
            end
        end
    },
    {
        -- Snow and ice
        projectile = PROJECTILE_ICE,
        effect = EFFECT_ICE_EMERGE,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_FREEZE, nil, cid)
            end
        end
    },
    {
        -- Ultra Space
        projectile = PROJECTILE_ENERGY,
        effect = EFFECT_PURPLE_CIRCLE,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BAD, cid)
            end
        end
    },
    {
        -- Grass, field, flowers, and Grassy Terrain
        projectile = PROJECTILE_LEAF_TWO,
        effect = EFFECT_ROOTS_FOUR,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
            end
        end
    },
    {
        -- Misty Terrain
        projectile = PROJECTILE_LOVE_HEART,
        effect = EFFECT_LOVE_HEARTS_FOUR,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, cid)
            end
        end
    },
    {
        -- Psychic Terrain
        projectile = PROJECTILE_PINK_BLAST,
        effect = EFFECT_PURPLE_ENERGIZE,
        onHit = function(cid, target)
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
            end
        end
    },
}

for k, environment in pairs(ENVIRONMENT_EFFECTS) do
    ENVIRONMENT_EFFECTS[k].combat = createCombatObject()
    _G['onTargetCreature_SecretPower' .. k] = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        environment.onHit(cid, target)
    end
    _G['onTargetTile_SecretPower' .. k]  = function(cid, position)
        if (math.random(0, 1) == 1) then
            doSendDistanceShoot(getSkyPosition(position), position, environment.projectile)
            addEvent(doSendMagicEffect, 150, position, environment.effect)
        end
    end
    setCombatCallback(ENVIRONMENT_EFFECTS[k].combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SecretPower" .. k)
    setCombatCallback(ENVIRONMENT_EFFECTS[k].combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_SecretPower" .. k)
    setCombatParam(ENVIRONMENT_EFFECTS[k].combat, COMBAT_PARAM_EFFECT, environment.effect)
    setCombatArea(ENVIRONMENT_EFFECTS[k].combat, createCombatArea(AREA_CIRCLE3X3))
end

local function doSpell(cid, combat, var)
    if (isCreature(cid)) then
        doCombat(cid, combat, var)
    end
end

local function doSpells(cid, var, environment)
    doSpell(cid, environment.combat, var)
end

function onCastSpell(cid, var)
    local environment = table.random(ENVIRONMENT_EFFECTS)

    local pos, i = getCreaturePosition(cid)
    for i = 1, 5 do
        if (i < 5) then
            addEvent(doSendDistanceShoot, 150 * (i - 1) + 1, pos, getSkyPosition(pos), environment.projectile)
        else
            addEvent(doSpells, 150 * (i - 1) + 1, cid, var, environment)
        end
    end
    return true
end

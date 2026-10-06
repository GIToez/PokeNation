local elements = {
    [ELEMENT_NORMAL] = {
        [ELEMENT_ROCK] = 0.5,
        [ELEMENT_GHOST] = 0,
        [ELEMENT_STEEL] = 0.5
    },
    [ELEMENT_FIGHT] = {
        [ELEMENT_NORMAL] = 2.0,
        [ELEMENT_FLYING] = 0.5,
        [ELEMENT_POISON] = 0.5,
        [ELEMENT_ROCK] = 2.0,
        [ELEMENT_BUG] = 0.5,
        [ELEMENT_GHOST] = 0,
        [ELEMENT_STEEL] = 2.0,
        [ELEMENT_PSYCHIC] = 0.5,
        [ELEMENT_ICE] = 2.0,
        [ELEMENT_DARK] = 2,
        [ELEMENT_FAIRY] = 0.5
    },
    [ELEMENT_FLYING] = {
        [ELEMENT_FIGHT] = 2.0,
        [ELEMENT_ROCK] = 0.5,
        [ELEMENT_BUG] = 2.0,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_GRASS] = 2.0,
        [ELEMENT_ELECTRIC] = 0.5
    },
    [ELEMENT_POISON] = {
        [ELEMENT_POISON] = 0.5,
        [ELEMENT_GROUND] = 0.5,
        [ELEMENT_ROCK] = 0.5,
        [ELEMENT_GHOST] = 0.5,
        [ELEMENT_STEEL] = 0,
        [ELEMENT_GRASS] = 2.0,
        [ELEMENT_FAIRY] = 2.0
    },
    [ELEMENT_GROUND] = {
        [ELEMENT_FLYING] = 0,
        [ELEMENT_POISON] = 2.0,
        [ELEMENT_ROCK] = 2.0,
        [ELEMENT_BUG] = 0.5,
        [ELEMENT_STEEL] = 2.0,
        [ELEMENT_FIRE] = 2.0,
        [ELEMENT_GRASS] = 0.5,
        [ELEMENT_ELECTRIC] = 2.0
    },
    [ELEMENT_ROCK] = {
        [ELEMENT_FIGHT] = 0.5,
        [ELEMENT_FLYING] = 2.0,
        [ELEMENT_GROUND] = 0.5,
        [ELEMENT_BUG] = 2.0,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_FIRE] = 2.0,
        [ELEMENT_ICE] = 2.0,
    },
    [ELEMENT_BUG] = {
        [ELEMENT_FIGHT] = 0.5,
        [ELEMENT_FLYING] = 0.5,
        [ELEMENT_POISON] = 0.5,
        [ELEMENT_GHOST] = 0.5,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_FIRE] = 0.5,
        [ELEMENT_GRASS] = 2.0,
        [ELEMENT_PSYCHIC] = 2.0,
        [ELEMENT_DARK] = 2.0,
        [ELEMENT_FAIRY] = 0.5
    },
    [ELEMENT_GHOST] = {
        [ELEMENT_NORMAL] = 0,
        [ELEMENT_GHOST] = 2.0,
        [ELEMENT_PSYCHIC] = 2.0,
        [ELEMENT_DARK] = 0.5
    },
    [ELEMENT_STEEL] = {
        [ELEMENT_ROCK] = 2.0,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_FIRE] = 0.5,
        [ELEMENT_WATER] = 0.5,
        [ELEMENT_ELECTRIC] = 0.5,
        [ELEMENT_ICE] = 2.0,
        [ELEMENT_FAIRY] = 2.0
    },
    [ELEMENT_FIRE] = {
        [ELEMENT_ROCK] = 0.5,
        [ELEMENT_BUG] = 2.0,
        [ELEMENT_STEEL] = 2.0,
        [ELEMENT_FIRE] = 0.5,
        [ELEMENT_WATER] = 0.5,
        [ELEMENT_GRASS] = 2.0,
        [ELEMENT_ICE] = 2.0,
        [ELEMENT_DRAGON] = 0.5
    },
    [ELEMENT_WATER] = {
        [ELEMENT_GROUND] = 2.0,
        [ELEMENT_ROCK] = 2.0,
        [ELEMENT_FIRE] = 2.0,
        [ELEMENT_WATER] = 0.5,
        [ELEMENT_GRASS] = 0.5,
        [ELEMENT_DRAGON] = 0.5
    },
    [ELEMENT_GRASS] = {
        [ELEMENT_FLYING] = 0.5,
        [ELEMENT_POISON] = 0.5,
        [ELEMENT_GROUND] = 2.0,
        [ELEMENT_ROCK] = 2.0,
        [ELEMENT_BUG] = 0.5,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_FIRE] = 0.5,
        [ELEMENT_WATER] = 2.0,
        [ELEMENT_GRASS] = 0.5,
        [ELEMENT_DRAGON] = 0.5
    },
    [ELEMENT_ELECTRIC] = {
        [ELEMENT_FLYING] = 2.0,
        [ELEMENT_GROUND] = 0,
        [ELEMENT_WATER] = 2.0,
        [ELEMENT_GRASS] = 0.5,
        [ELEMENT_ELECTRIC] = 0.5,
        [ELEMENT_DRAGON] = 0.5
    },
    [ELEMENT_PSYCHIC] = {
        [ELEMENT_FIGHT] = 2.0,
        [ELEMENT_POISON] = 2.0,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_PSYCHIC] = 0.5,
        [ELEMENT_DARK] = 0
    },
    [ELEMENT_ICE] = {
        [ELEMENT_FLYING] = 2.0,
        [ELEMENT_GROUND] = 2.0,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_FIRE] = 0.5,
        [ELEMENT_WATER] = 0.5,
        [ELEMENT_GRASS] = 2.0,
        [ELEMENT_ICE] = 0.5,
        [ELEMENT_DRAGON] = 2.0
    },
    [ELEMENT_DRAGON] = {
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_DRAGON] = 2.0,
        [ELEMENT_FAIRY] = 0
    },
    [ELEMENT_DARK] = {
        [ELEMENT_FIGHT] = 0.5,
        [ELEMENT_GHOST] = 2.0,
        [ELEMENT_PSYCHIC] = 2.0,
        [ELEMENT_DARK] = 0.5,
        [ELEMENT_FAIRY] = 0.5
    },
    [ELEMENT_FAIRY] = {
        [ELEMENT_FIGHT] = 2.0,
        [ELEMENT_POISON] = 0.5,
        [ELEMENT_STEEL] = 0.5,
        [ELEMENT_FIRE] = 0.5,
        [ELEMENT_DRAGON] = 2.0,
        [ELEMENT_DARK] = 2.0
    },
}

function isFriend(cid, target)
    if (cid == target or (isPokemonWild(cid) and isPokemonWild(target))) then
        return true
    elseif (isPokemonOfPlayer(cid)) then
        local creatureMaster = getCreatureMaster(target)
        local pokemonMaster = getCreatureMaster(cid)

        if (isPokemonOfPlayer(target) or isPlayer(target)) then
            if (getPlayerSurviveArena(creatureMaster) or getPlayerBattleing(creatureMaster)) then
                return false
            elseif (isPlayerOnPvpArena(pokemonMaster)) then
                return getPlayerPvpArenaTeam(creatureMaster) == getPlayerPvpArenaTeam(pokemonMaster)
            elseif ((not isDueling(creatureMaster)) or
                    (isInArray(getPartyDuelPartners(pokemonMaster), creatureMaster))) then
                return true
            end
        end
    end
    return false
end

function getElementMultipler(attackerType, defenderType, defenderCid)
    if (defenderCid and defenderType == ELEMENT_DARK and getCreatureStatus(defenderCid, CREATURE_STATUS_MIRACLE_EYE)) then
        return 1.0
    end

    return elements[attackerType][defenderType] or 1.0
end

--[[local function getDamageFormula(attackerLevel, attackerAttackStat, attackPower, defenderDefenseStat, stab, typeModifiers)
	local randomNumber = math.random(217, 255)
	return ((((((((2*attackerLevel/5+2)*attackerAttackStat*attackPower)/defenderDefenseStat)/50)+2)*stab)*typeModifiers/10)*randomNumber)--/255
end]]

local function getFinalDamage(fromCid, toCid, skillName, skillBasePower)
    local skillDamage = skillBasePower or getPokemonSkillDamage(skillName)
    if (skillDamage == 0) then
        return 0
    end

    local resultDamage = 0
    if (not isMonster(toCid)) then
        resultDamage = skillDamage + (getMonsterLevel(fromCid) * 2)

    else
        if (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.LEVITATE, nil, skillName) or
                doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.MAGIC_GUARD, nil, skillName) or
                doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.LIGHTNINGROD, nil, skillName) or
                doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.DAMAGEONE, nil)) then
            return -1
        end

        local targetName = getCreatureName(toCid)
        local elementMultipler = 1
        local damageLevel = 1
        local fromCidLevel, toCidLevel = getMonsterLevel(fromCid), getMonsterLevel(toCid)

        for _, pType in pairs(getPokemonTypes(toCid)) do
            elementMultipler = elementMultipler * getElementMultipler(getPokemonSkillDamageType(skillName), pType, toCid)
        end

        if (elementMultipler > 2.5) then
            elementMultipler = 2.5

        elseif (elementMultipler == 0 and
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SCRAPPY, toCid, skillName)) then
            elementMultipler = 1.0
        end

        if (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.WONDER_GUARD, nil, elementMultipler)) then
            return -1
        end

        if (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.FILTER, nil, elementMultipler)) then
            elementMultipler = elementMultipler * 0.75 -- 1/4
        elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.ANTICIPATION, nil, elementMultipler)) then
            elementMultipler = elementMultipler * 0.84 -- 1/6
        end

        -- skillDamage = move power
        if (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.RIVALRY, nil)) then
            local fromCidSex, toCidSex = getMonsterSex(fromCid), getMonsterSex(toCid)
            if (fromCidSex ~= POKEMON_SEX_UNKNOWN and toCidSex ~= POKEMON_SEX_UNKNOWN) then
                skillDamage = skillDamage * (fromCidSex == toCidSex and 1.25 or 0.75)
            end

        elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.TINTED_LENS, nil, elementMultipler) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.ADAPTABILITY, nil, skillName)) then
            skillDamage = skillDamage * 2

        elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.TECHNICIAN, nil, skillDamage) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.HUGE_POWER, nil, skillName)) then
            skillDamage = skillDamage * 1.5

        elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.THICK_FAT, nil, skillName)) then
            skillDamage = skillDamage * 0.5

        elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.DROUGHT, nil, skillName) or
                doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.DRIZZLE, nil, skillName)) then
            skillDamage = skillDamage * 1.2
        end

        if (getCreatureStatus(fromCid, CREATURE_STATUS_CHARGE) and getPokemonSkillDamageType(skillName) == ELEMENT_ELECTRIC) then
            skillDamage = skillDamage * 2
            doCreatureRemoveStatus(fromCid, CREATURE_STATUS_CHARGE)
        end

        if (table.find(getPokemonTypes(fromCid), getPokemonSkillDamageType(skillName))) then -- STAB +10%
            skillDamage = skillDamage * 1.1
        end

        if (not doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.FRISK, nil)) then
            skillDamage = skillDamage * PokemonHeldItem.getMovePowerModifier(fromCid, getPokemonSkillDamageType(skillName))
        end

        if (getPokemonSkillCategory(skillName) == MOVE_CATEGORY.PHYSICAL) then
            resultDamage = ((skillDamage * elementMultipler) * ((fromCidLevel + 10) * 0.2)) + (getPokemonAtk(fromCid, fromCidLevel) - getPokemonDef(toCid, toCidLevel))
        else -- SPECIAL and STATUS
            resultDamage = ((skillDamage * elementMultipler) * ((fromCidLevel + 10) * 0.2)) + (getPokemonSpAtk(fromCid, fromCidLevel) - getPokemonSpDef(toCid, toCidLevel))
        end

        if (not doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.SHELL_ARMOR, nil) and
                not doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.BATTLE_ARMOR, nil)) then
            local criticalChance = getPokemonSkillCriticalChance(skillName)
            if (getCreatureStatus(fromCid, CREATURE_STATUS_HIGHCRITICALCHANCE)) then
                criticalChance = 100
            end

            if (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SUPER_LUCK, nil)) then
                criticalChance = criticalChance * 1.2
            end

            if (getRandom(0, 100) <= criticalChance) then
                resultDamage = resultDamage *
                        (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SNIPER, nil) and 1.6 or 1.3)
                doSendAnimatedText(getCreaturePosition(fromCid), "CRITICAL!", COLOR_RED)

                if (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.ANGER_POINT, nil)) then
                    doCreatureAddStatus(toCid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_HIGH, fromCid)
                end
            end
        end

        resultDamage = resultDamage * (1 + getPokemonBonusAttack(fromCid))
        resultDamage = resultDamage / (1 + getPokemonBonusDefense(toCid))

        if (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.OVERGROW, nil, skillName) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.BLAZE, nil, skillName) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.TORRENT, nil, skillName) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SWARM, nil, skillName) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.GUTS, nil) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE, toCid) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.HUSTLE, nil)) then
            resultDamage = resultDamage * 1.5

        elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, nil, skillName) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.RECKLESS, nil, skillName) or
                doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.IRON_FIST, nil, skillName)) then
            resultDamage = resultDamage * 1.2
        elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.ILLUMINATE, toCid)) then
            resultDamage = resultDamage * 1.3
        end
    end

    if (resultDamage < 1) then
        return -1

    elseif (resultDamage > getCreatureHealth(toCid)) then
        return -getCreatureHealth(toCid) -- Correct max damage that this creature can receive, this fixes healthdrain-types amount
    end

    return -(math.ceil(resultDamage))
end


function doSkillDamage(fromCid, toCid, skillName, skillBasePower, damage, type)
    if (not type) then
        if (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.NORMALIZE, nil)) then
            type = ELEMENT_NORMAL
            skillBasePower = (skillBasePower and skillBasePower or getPokemonSkillDamage(skillName)) * 1.2 -- 20%
        else
            type = getPokemonSkillDamageType(skillName)
        end
    end

    local finalDamage, fromCidPos, toCidPos = damage, getCreaturePosition(fromCid), getCreaturePosition(toCid)
    if (not finalDamage) then
        finalDamage = getFinalDamage(fromCid, toCid, skillName, skillBasePower)
    end

    local skillProjectile = getPokemonSkillProjectile(skillName)
    if (skillProjectile) then
        doSendDistanceShoot(fromCidPos, toCidPos, skillProjectile)
    end

    if (isPokemonWild(toCid) and not hasTarget(toCid)) then
        doMonsterSetTarget(toCid, fromCid)
    end

    local backProjectile = getPokemonSkillBackProjectile(skillName)
    if (backProjectile) then
        addEvent(doSendDistanceShoot, 100, toCidPos, fromCidPos, backProjectile)
    end

    if (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.STURDY, nil, finalDamage)) then
        finalDamage = -(getCreatureHealth(toCid)) + 1
    end

    if (getCreatureStatus(toCid, CREATURE_STATUS_REFLECT) and
            not doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SUMMI, nil)) then
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_REFLECT)
        doSkillDamage(toCid, fromCid, skillName, skillBasePower, finalDamage)
        return

    elseif (getCreatureStatus(toCid, CREATURE_STATUS_PROTECTION) and
            not doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SUMMI, nil)) then
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_PROTECTION)
        doSendAnimatedText(getCreaturePosition(toCid), "PROTECTED", COLOR_GREEN)
        return

    elseif ((getCreatureStatus(toCid, CREATURE_STATUS_COUNTER) and
            getPokemonSkillCategory(skillName) == MOVE_CATEGORY.PHYSICAL) and
            not doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SUMMI, nil)) then
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_COUNTER)
        doSkillDamage(toCid, fromCid, skillName, skillBasePower, finalDamage * 2)
        return

    elseif (not getPokemonSkillIgnoreEvasion(skillName) and not getCreatureStatus(toCid, CREATURE_STATUS_MIRACLE_EYE) and (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.TANGLED_FEET, nil) or
            doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.SNOW_CLOAK, nil) or
            (doMasteryAdvantageCheck(getCreatureMaster(toCid), MASTERY_ADVANTAGES.EVASION_CHANCE) and getRandom(0, 100) <= 5))) then
        doSendAnimatedText(getCreaturePosition(toCid), "EVADED", COLOR_GREY)
        return

    else
        if (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.WATER_ABSORB, nil, skillName) or
                doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.VOLT_ABSORB, nil, skillName) or
                doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.RAIN_DISH, nil, skillName) or
                doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.ICE_BODY, nil, skillName)) then
            finalDamage = -(math.ceil(finalDamage * 0.25))
            if (finalDamage <= 0) then finalDamage = 1 end

        elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.DRY_SKIN, nil, skillName)) then
            if (type == ELEMENT_FIRE) then
                finalDamage = finalDamage * 1.25
            else -- ELEMENT_WATER will heal 1/4
                finalDamage = finalDamage * -0.25
                if (finalDamage <= 0) then finalDamage = 1 end
            end
        end

        doSendMagicEffect(toCidPos, getPokemonSkillEffect(skillName))
        doTargetCombatHealth(fromCid, toCid, getPokemonSkillDType(skillName), finalDamage, finalDamage, CONST_ME_NONE)

        if (not isCreature(toCid)) then -- The damage killed him?
            return
        end

        if (getPokemonSkillMakeJump(skillName)) then
            doSendCreatureJump(toCid)
        end

        if (getCreatureStatus(toCid, CREATURE_STATUS_STORE_DAMAGE) and getCreatureTarget(toCid) == fromCid and
                not doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SUMMI, nil)) then
            setPokemonStoredDamage(toCid, getPokemonStoredDamage(toCid) + finalDamage)
        end

        if (type == ELEMENT_ICE and doMasteryAdvantageCheck(getCreatureMaster(fromCid), MASTERY_ADVANTAGES.FREEZE_CHANCE) and getRandom(0, 100) <= 20) then -- Mastery Benefit
            doCreatureAddStatus(toCid, CREATURE_STATUS_FREEZE, nil, fromCid)
        end
    end

    if (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE, nil)) then
        local specs = getSpectators(toCidPos, 5, 5, false)
        if (specs) then
            for _, spec in pairs(specs) do
                if (isMonster(spec) and not isFriend(fromCid, spec) and getCreatureTarget(spec) > 0) then
                    doCreatureAddStatus(spec, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, fromCid)
                end
            end
        end

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.STATIC, nil, skillName)) then
        doCreatureAddStatus(fromCid, CREATURE_STATUS_PARALYSIS, nil, toCid)

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SAND_VEIL, nil, skillName)) then
        doCreatureAddStatus(toCid, CREATURE_STATUS_LOWACCURACY, nil, fromCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.POISON_POINT, nil, skillName)) then
        doCreatureAddStatus(fromCid, CREATURE_STATUS_POISON, getMonsterLevel(toCid), toCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.CUTE_CHARM, fromCid, skillName) and
            not doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.OBLIVIOUS, nil)) then
        doCreatureAddStatus(fromCid, CREATURE_STATUS_INFATUATE, nil, toCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.CHLOROPHYLL, nil, skillName)) then
        doCreatureAddStatus(toCid, CREATURE_STATUS_EXTRASPEED, nil, fromCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.EFFECT_SPORE, nil, skillName)) then
        local condition = table.random({ CREATURE_STATUS_PARALYSIS, CREATURE_STATUS_SLEEP, CREATURE_STATUS_POISON })
        doCreatureAddStatus(fromCid, condition,
            (condition == CREATURE_STATUS_POISON and getMonsterLevel(toCid) or true), toCid)

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.ARENA_TRAP, nil, skillName)) then
        doCreatureAddStatus(toCid, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, fromCid)

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.MAGNET_PULL, toCid)) then
        local specs = getSpectators(toCidPos, 5, 5, false)
        if (specs) then
            for _, spec in pairs(specs) do
                if (isMonster(spec) and not isFriend(fromCid, spec) and getCreatureTarget(spec) > 0) then
                    doCreatureAddStatus(spec, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, fromCid)
                end
            end
        end

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.HYDRATION, nil, skillName)) then
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_BADPOISON)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_BURN)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_CONFUSION)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_FREEZE)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_LOWACCURACY)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_PARALYSIS)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_POISON)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_SLEEP)

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.STENCH, nil)) then
        doCreatureAddStatus(toCid, CREATURE_STATUS_FLINCH, nil, fromCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.LIGHTNINGROD, nil, skillName) or
            doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.SOLAR_POWER, nil, skillName)) then
        doCreatureAddStatus(toCid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, fromCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.LEAF_GUARD, nil, skillName)) then
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_BADPOISON)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_BURN)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_FREEZE)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_PARALYSIS)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_POISON)
        doCreatureRemoveStatus(toCid, CREATURE_STATUS_SLEEP)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.SWIFT_SWIM, nil, skillName)) then
        doCreatureAddStatus(toCid, CREATURE_STATUS_EXTRASPEED, nil, fromCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.TRACE, fromCid)) then
        setMonsterSpecialAbility(toCid, getMonsterSpecialAbility(fromCid))

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.DOWNLOAD, toCid)) then
        doCreatureAddStatus(fromCid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, toCid)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.FLAME_BODY, nil, skillName)) then
        doCreatureAddStatus(fromCid, CREATURE_STATUS_BURN, getMonsterLevel(toCid), toCid)

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SPEED_BOOST, nil)) then
        doCreatureAddStatus(fromCid, CREATURE_STATUS_EXTRASPEED, nil, fromCid)

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.SAND_STREAM, nil)) then
        doCreatureAddStatus(toCid, CREATURE_STATUS_LOWACCURACY, nil, fromCid)

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.MINUS, nil) or doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.PLUS, nil)) then
        local specs = getSpectators(toCidPos, 5, 5, false)
        if (specs) then
            for _, spec in pairs(specs) do
                if (isMonster(spec) and isFriend(fromCid, spec) and (doPokemonSpecialAbilityCheck(spec, POKEMON_SPECIAL_ABILITY_IDS.MINUS, nil) or doPokemonSpecialAbilityCheck(spec, POKEMON_SPECIAL_ABILITY_IDS.PLUS, nil))) then
                    doCreatureAddStatus(fromCid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_MEDIUM, fromCid)
                    break
                end
            end
        end

    elseif (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.COLOR_CHANGE, nil)) then
        setPokemonCustomType(fromCid, type)

    elseif (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.ROUGH_SKIN, nil, skillName)) then
        local tmpDamage = finalDamage / 16
        doTargetCombatHealth(toCid, fromCid, getPokemonSkillDType(skillName), tmpDamage, tmpDamage, EFFECT_SCRATCH_FOUR)
    end

    if (doPokemonSpecialAbilityCheck(fromCid, POKEMON_SPECIAL_ABILITY_IDS.TRUANT, toCid)) then
        doCreatureAddStatus(fromCid, CREATURE_STATUS_RECHARGE, nil, fromCid)
    end
end

function doSkillMultipleDamages(fromCid, skillName, remaingRounds, skillBasePower, toCid)
    if (not toCid) then
        toCid = getCreatureTarget(fromCid)
    end

    if (isCreature(fromCid) and isCreature(toCid)) then
        local fromCidPosition = getCreaturePosition(fromCid)
        local toCidPosition = getCreaturePosition(toCid)

        if (getDistanceBetween(fromCidPosition, toCidPosition) <= getPokemonSkillMaxDistance(skillName) and
                isSightClear(fromCidPosition, toCidPosition, true)) then
            doSkillDamage(fromCid, toCid, skillName, skillBasePower)
        end

        if (remaingRounds > 1) then
            addEvent(doSkillMultipleDamages, 250, fromCid, skillName, remaingRounds - 1, skillBasePower, toCid)
        end
    end
end

function doSkillHealthDrain(fromCid, toCid, skillName, healDivider, damage)
    if (not damage) then
        damage = getFinalDamage(fromCid, toCid, skillName)
    end

    doSkillDamage(fromCid, toCid, skillName, nil, damage)
    --if (not isCreature(toCid)) then return end -- Defeated

    if (doPokemonSpecialAbilityCheck(toCid, POKEMON_SPECIAL_ABILITY_IDS.LIQUID_OOZE, nil, skillName)) then
        doSkillDamage(toCid, fromCid, skillName, nil, damage)
        return
    end

    local healthDrain = damage
    local fromCidPosition = getCreaturePosition(fromCid)
    local toCidPosition = getCreaturePosition(toCid)

    if (not healthDrain) then
        healthDrain = damage
    end
    if (healDivider) then
        healthDrain = healthDrain / healDivider
    end

    healthDrain = math.abs(math.floor(healthDrain))

    doCreatureAddHealth(fromCid, healthDrain)
    doSendMagicEffect(fromCidPosition, getPokemonSkillEffect(skillName))
end

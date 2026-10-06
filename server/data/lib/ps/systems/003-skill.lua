local SPECIAL_SKILLS = {
    TARGET_NEED_BE_SLEEPING = { "Dream Eater", "Nightmare" },
    USER_NEED_BE_SLEEPING = { "Snore", "Sleep Talk" },
    NEED_SUNDAY = {},
    BLOCKED_BY_INSOMNIA = { "Rest" },
    TARGET_NEED_BE_OPPOSITE_SEX = { "Captivate" },
    --TARGET_NEED_BE_TRAINED_BY_PLAYER = {"Disable"}
}

function callSkillFunction(pokemon, skillName)
    return doCreatureCastSpell(pokemon, SKILL_FUNCTION_PREFIX .. skillName)
end

function doPokemonUseSkill(pokemon, skillName)
    local _isPokemonWild = isPokemonWild(pokemon)
    local _isPokemonOfPlayer = isPokemonOfPlayer(pokemon)
    local pokemonMaster, pokemonMasterBall = getCreatureMaster(pokemon)
    local pokemonPosition = getCreaturePosition(pokemon)
    local pokemonName = getCreatureName(pokemon)

    if (getCreatureStatus(pokemon, CREATURE_STATUS_ENCORE)) then
        local lastMove = getPokemonLastUsedMove(pokemon)
        if (lastMove and skillName ~= lastMove) then
            if (_isPokemonOfPlayer) then
                doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon cant't use this move while it's under encore effect.")
            end
            return false
        end
    end

    if (getCreatureStatus(pokemon, CREATURE_STATUS_SUBSTITUTE)) then
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon cant't use moves while behind a substitute.")
        end
        return false
    end

    if (getCreatureStatus(pokemon, CREATURE_STATUS_RECHARGE)) then
        doSendAnimatedText(getCreaturePosition(pokemon), "TIRED!", COLOR_WHITE)
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon is recharging.")
        end
        return false
    end

    if (hasCondition(pokemon, CONDITION_EXHAUST)) then
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon is exhaust.")
        end
        return false
    end

    if (getCreatureStatus(pokemon, CREATURE_STATUS_FLINCH)) then
        doSendAnimatedText(getCreaturePosition(pokemon), "FLINCH!", COLOR_WHITE)
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon is flinching.")
        end
        return false
    end

    if (getCreatureStatus(pokemon, CREATURE_STATUS_SLEEP) and not isInArray(SPECIAL_SKILLS.USER_NEED_BE_SLEEPING, skillName)) then
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon is sleeping.")
        end
        return false
    end

    if (getMonsterLevel(pokemon) < getPokemonSkillRequiredLevel(pokemonName, skillName)) then
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, string.format(__L(pokemonMaster, "Sorry, your Pokemon level for this move is too low (%s)."), getPokemonSkillRequiredLevel(pokemonName, skillName)))
        end
        return false
    end

    if (_isPokemonOfPlayer) then
        if (getPokemonEnergy(pokemon) < getPokemonSkillRequiredEnergy(skillName)) then
            doPlayerSendCancel(pokemonMaster, string.format(__L(pokemonMaster, "Sorry, your Pokemon has insufficient energy (%s)."), getPokemonSkillRequiredEnergy(skillName)))
            return false

        else
            pokemonMasterBall = getPlayerBall(pokemonMaster)
            local remaingCooldown = getBallSkillCooldown(pokemonMasterBall.uid, skillName)

            if (remaingCooldown > 0) then
                doPlayerSendCancel(pokemonMaster, string.format(__L(pokemonMaster, "Sorry, your Pokemon is exhaust (%ss)."), remaingCooldown))
                return false
            end
        end
    end

    local pokemonTarget = getCreatureTarget(pokemon)
    if (isPokemonSkillTypeTarget(skillName)) then
        if (not isCreature(pokemonTarget)) then
            if (_isPokemonOfPlayer) then
                doPlayerSendCancel(pokemonMaster, "First get a target.")
            end
            return false
        end

        local pokemonTargetPosition = getCreaturePosition(pokemonTarget)

        if (getDistanceBetween(pokemonPosition, pokemonTargetPosition) > getPokemonSkillMaxDistance(skillName)) then
            if (_isPokemonOfPlayer) then
                doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon is too far from the target.")
            end
            return false

        elseif (not isSightClear(pokemonPosition, pokemonTargetPosition, true)) then
            if (_isPokemonOfPlayer) then
                doPlayerSendCancel(pokemonMaster, "Sorry, not possible.")
            end
            return false
            -- Special Case -
        elseif (isInArray(SPECIAL_SKILLS.TARGET_NEED_BE_SLEEPING, skillName) and not getCreatureStatus(pokemonTarget, CREATURE_STATUS_SLEEP)) then
            if (_isPokemonOfPlayer) then
                doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon target need to be sleeping to this move works.")
            end
            return false

        elseif (isInArray(SPECIAL_SKILLS.TARGET_NEED_BE_OPPOSITE_SEX, skillName)) then
            local pokemonTargetSex = getMonsterSex(pokemonTarget)

            if (getMonsterSex(pokemon) == pokemonTargetSex or pokemonTargetSex == POKEMON_SEX_UNKNOWN) then
                if (_isPokemonOfPlayer) then
                    doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon target need be opposite sex of your Pokemon.")
                end
                return false
            end

            --[[elseif (isInArray(SPECIAL_SKILLS.TARGET_NEED_BE_TRAINED_BY_PLAYER, skillName) and not isPokemonOfPlayer(pokemonTarget)) then
                if (_isPokemonOfPlayer) then
                    doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon can only use this move agaisnt Pokemon trained by players.")
                end
                return false]]
        end
    end

    -- Special Cases Start --
    if (isInArray(SPECIAL_SKILLS.USER_NEED_BE_SLEEPING, skillName) and not getCreatureStatus(pokemon, CREATURE_STATUS_SLEEP)) then
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon need to be sleeping to use this move.")
        end
        return false

    elseif (isInArray(SPECIAL_SKILLS.NEED_SUNDAY, skillName)) then
        local worldLightState = getWorldLightState()
        if (pokemonPosition.z > 7 or worldLightState == WORLD_LIGHT_STATE_NIGHT or worldLightState == WORLD_LIGHT_STATE_SUNSET) then
            if (_isPokemonOfPlayer) then
                doPlayerSendCancel(pokemonMaster, "Sorry, this move can not be used without sunlight.")
            end
            return false
        end

    elseif (isInArray(SPECIAL_SKILLS.BLOCKED_BY_INSOMNIA, skillName) and getCreatureStatus(pokemon, CREATURE_STATUS_INSOMNIA)) then
        if (_isPokemonOfPlayer) then
            doPlayerSendCancel(pokemonMaster, "Sorry, your Pokemon can not sleep while with insomnia.")
        end
        return false
    end
    -- Special Cases End --

    if ((not doPokemonSpecialAbilityCheck(pokemon, POKEMON_SPECIAL_ABILITY_IDS.NO_GUARD, nil) and not getCreatureStatus(pokemon, CREATURE_STATUS_IGNORE_ACCURACY) and
            (isMonster(pokemonTarget) and not doPokemonSpecialAbilityCheck(pokemonTarget, POKEMON_SPECIAL_ABILITY_IDS.NO_GUARD, nil)) and
            not getPokemonSkillIgnoreAccuracy(skillName)) and missAttack(pokemon)) then
        doSendAnimatedText(getCreaturePosition(pokemon), "MISS!", COLOR_WHITE)
        doAddExhaust(pokemon)
        return false
    end

    if (getCreatureStatus(pokemon, CREATURE_STATUS_INFATUATE) and getRandom(0, 100) <= 50) then
        doSendAnimatedText(getCreaturePosition(pokemon), "IN LOVE", COLOR_PINK)
        doAddExhaust(pokemon)
        return false
    end

    local failed = false
    if (getPokemonSkillMakeSelfdestruct(skillName)) then
        local specs = getSpectators(pokemonPosition, 8, 8, false)
        for _, spec in pairs(specs) do
            if (isMonster(spec) and not isFriend(pokemon, spec) and
                    doPokemonSpecialAbilityCheck(spec, POKEMON_SPECIAL_ABILITY_IDS.DAMP, nil)) then
                failed = true
                break
            end
        end
    end

    if (not failed and isMonster(pokemonTarget) and
            doPokemonSpecialAbilityCheck(pokemonTarget, POKEMON_SPECIAL_ABILITY_IDS.OBLIVIOUS, nil, skillName)) then
        failed = true
    end

    if (not failed and getPokemonSkillMakeHeal(skillName) and getCreatureStatus(pokemon, CREATURE_STATUS_HEALBLOCK)) then
        failed = true
    end

    local setCooldown
    if (failed) then
        doSendAnimatedText(getCreaturePosition(pokemon), "FAIL!", COLOR_WHITE)
        setCooldown = true
    else
        setCooldown = callSkillFunction(pokemon, skillName)
    end

    if (setCooldown) then
        if (_isPokemonWild) then
            doCreatureSay(pokemon, string.upper(skillName), TALKTYPE_MONSTER_YELL)
        else
            doCreatureSay(pokemonMaster, getCreatureNickname(pokemon) .. ", " .. skillName .. "!", TALKTYPE_MONSTER)
        end

        if (_isPokemonOfPlayer) then
            doPokemonAddEnergy(pokemon, -getPokemonSkillRequiredEnergy(skillName))
            doAddExhaust(pokemonMaster)

            if (isMonster(pokemonTarget)) then
                if (doPokemonSpecialAbilityCheck(pokemonTarget, POKEMON_SPECIAL_ABILITY_IDS.PRESSURE, nil)) then
                    setBallSkillCooldown(pokemonMaster, pokemonMasterBall.uid, skillName, getPokemonSkillCooldownTime(skillName) * 2)
                elseif (doPokemonSpecialAbilityCheck(pokemonTarget, POKEMON_SPECIAL_ABILITY_IDS.STALL, nil)) then
                    setBallSkillCooldown(pokemonMaster, pokemonMasterBall.uid, skillName, getPokemonSkillCooldownTime(skillName) * 1.1)
                else
                    setBallSkillCooldown(pokemonMaster, pokemonMasterBall.uid, skillName)
                end
            else
                setBallSkillCooldown(pokemonMaster, pokemonMasterBall.uid, skillName)
            end
        end

        setPokemonLastUsedMove(pokemon, skillName)
    end
    return true
end

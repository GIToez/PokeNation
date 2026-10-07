-- Is
function isPokemon(cid)
	return isMonster(cid) and isInArray(pokemonsNames, getCreatureName(cid))
end

function isPokemonWild(cid)
	return isMonster(cid) and getCreatureMaster(cid) == cid
end

function isPokemonOfNpc(cid)
	return getCreatureMaster(cid) ~= cid and isNpc(getCreatureMaster(cid))
end

function isPokemonOfPlayer(cid)
	return isCreature(cid) and getCreatureMaster(cid) ~= cid and isPlayer(getCreatureMaster(cid))
end

function isPokemonTransformed(pid)
	return getCreatureStorage(pid, pokemonsStorages.transform) ~= -1
end

function isPokemonUsingHealthPotion(cid)
	return getCreatureStorage(cid, pokemonsStorages.isUsingHealthPotion) ~= -1
end

function isPokemonUsingEnergyPotion(cid)
	return getCreatureStorage(cid, pokemonsStorages.isUsingEnergyPotion) ~= -1
end

-- Get
function getPokemonCurrentTransformation(pid)
	return getCreatureStorage(pid, pokemonsStorages.transform)
end

function getPokemonEnergy(cid)
	return getCreatureMana(getCreatureMaster(cid))
end

function getPokemonMaxEnergy(cid)
    return getCreatureMaxMana(getCreatureMaster(cid))
end

function doPokemonAddEnergy(cid, amount)
	doCreatureAddMana(getCreatureMaster(cid), amount, false)
end

function getPokemonPoisonDamage(cid)
	return getCreatureStorage(cid, POKEMON_STORAGES.POISON_DAMAGE) or 0
end

function getPokemonPoison(cid)
	return getCreatureStorage(cid, POKEMON_STORAGES.POISON) == 1
end

function getPokemonBurnDamage(cid)
	return getCreatureStorage(cid, POKEMON_STORAGES.BURN_DAMAGE) or 0
end

function getPokemonBurn(cid)
	return getCreatureStorage(cid, POKEMON_STORAGES.BURN) == 1
end

function getPokemonBadPoisonDamage(cid)
	return getCreatureStorage(cid, POKEMON_STORAGES.BADPOISON_DAMAGE) or 0
end

function getPokemonBadPoison(cid)
	return getCreatureStorage(cid, POKEMON_STORAGES.BADPOISON) == 1
end

-- Set
function setPokemonBadPoisonDamage(cid, damage)
	doCreatureSetStorage(cid, POKEMON_STORAGES.BADPOISON_DAMAGE, damage)
end

function setPokemonBadPoison(cid, poison)
	doCreatureSetStorage(cid, POKEMON_STORAGES.BADPOISON, (poison and 1 or 0))
end

function setPokemonPoisonDamage(cid, damage)
	doCreatureSetStorage(cid, POKEMON_STORAGES.POISON_DAMAGE, damage)
end

function setPokemonPoison(cid, poison)
	doCreatureSetStorage(cid, POKEMON_STORAGES.POISON, (poison and 1 or 0))
end

function setPokemonBurnDamage(cid, damage)
	doCreatureSetStorage(cid, POKEMON_STORAGES.BURN_DAMAGE, damage)
end

function setPokemonBurn(cid, burn)
    doCreatureSetStorage(cid, POKEMON_STORAGES.BURN, (burn and 1 or 0))
end

-- Has
function hasPokemonAbilitie(pokemonName, abilitieName)
	return isInArray(getPokemonAbilities(pokemonName), abilitieName)
end

-- Others
function missAttack(cid) -- only for wild pokemons cuz tameds check this on talkaction
	return (getCreatureStatus(cid, CREATURE_STATUS_LOWACCURACY) and getRandom(0, 2) == 1) or
            (getCreatureStatus(cid, CREATURE_STATUS_CONFUSION) and getRandom(0, 4) == 1)
end

function setIsPokemonUsingHealthPotion(cid, status)
	doCreatureSetStorage(cid, pokemonsStorages.isUsingHealthPotion, (status and 1 or -1))
end

function setIsPokemonUsingEnergyPotion(cid, status)
    doCreatureSetStorage(cid, pokemonsStorages.isUsingEnergyPotion, (status and 1 or -1))
end

-- Do
local function doPokemonUpdate(name, owner, position)
	if (isPlayer(owner)) then
		local pokemon = doSummonCreature(name, position, false)

		if(not isCreature(pokemon)) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

		else
			local ball = getPlayerBall(owner)
			local pokemonLevel = getBallPokemonLevel(ball.uid)
			local pokemonLastHP = getBallPokemonLastHp(ball.uid)
			local pokemonMaxHP = getCreatureMaxHealth(pokemon)
			local pokemonCurrentHP = pokemonLastHP - pokemonMaxHP
			local pokemonEnergy = getBallPokemonEnergy(ball.uid)
			local pokemonSex = getBallPokemonSex(ball.uid)
			local extraPoints = getBallPokemonExtraPoints(ball.uid)
            local specialAbility = getBallPokemonSpecialAbility(ball.uid)
            local pokemonNickname = getBallPokemonNickname(ball.uid)

			doConvinceCreature(owner, pokemon)
			setCreatureMaxHealth(pokemon, pokemonMaxHP)
			doCreatureAddHealth(pokemon, pokemonCurrentHP)
			doCreatureSetStorage(owner, playersStorages.isPokemonOnline, 1)
			doCreatureSetStorage(owner, playersStorages.pokemonUid, pokemon)
			doCreatureSetStorage(owner, playersStorages.pokemonName, name)
			registerCreatureEvent(pokemon, "onPokemonDeath")
			setPlayerVulnerable(owner, false)
			setCreatureMaxMana(owner, getBallPokemonMaxEnergy(ball.uid))
			doCreatureAddMana(owner, pokemonEnergy, false)
			doPokemonUpdateStats(pokemon, ball.uid)
			setMonsterExtraPoints(pokemon, extraPoints)
			setMonsterLevel(pokemon, pokemonLevel)
			setMonsterSex(pokemon, pokemonSex)
            setMonsterSpecialAbility(pokemon, specialAbility)
			doPlayerUpdatePokemonIcons(owner, name)

            if (pokemonNickname ~= nil and pokemonNickname ~= -1) then
                setCreatureNickname(pokemon, pokemonNickname)
            end

			doPlayerSendPokemonWindowRemovePokemonIcon(owner, getFastcallNumber(ball.uid))
			doFastcallLink(owner, ball.uid)
		end
	end
end

local function doCreateWildPokemon(name, inPosition, level, sex, target)
	local pokemon = doSummonCreature(name, inPosition, false)

	if (isCreature(pokemon)) then
		setMonsterLevel(pokemon, level)
		setMonsterSex(pokemon, sex)

		if (isCreature(target)) then
			doMonsterSetTarget(pokemon, target)
		end
	end
end

function doPokemonEvolve(cid, toPokemon)
	local pokemonName = getCreatureName(cid)
	local pokemonPosition = getCreaturePosition(cid)

	if (isPokemonOfPlayer(cid)) then
		local pokemonMaster = getCreatureMaster(cid)
		local ball = getPlayerBall(pokemonMaster)

        if (not table.find(getPokemonSpecialAbilities(toPokemon), getBallPokemonSpecialAbility(ball.uid))) then
            setBallPokemonSpecialAbility(ball.uid, getPokemonRandomSpecialAbility(toPokemon))
        end
        setBallPokemonName(ball.uid, toPokemon)
        doBallUpdateDescription(ball.uid)

		doPlayerSendTextMessage(pokemonMaster, MESSAGE_EVENT_ADVANCE, "Something is happening!")
		doCreatureSetStorage(pokemonMaster, playersStorages.isEvolving, 1)
        doPlayerAddStatistic(pokemonMaster, PLAYER_STATISTIC_IDS.EVOLVE_POKEMON, 1)
        doSendCreatureEffect(cid, CREATURE_EFFECTS.EVOLVE, getMonsterInfo(toPokemon, false).outfit.lookType)

		addEvent(function(pokemonMaster)
            if (isCreature(pokemonMaster)) then
                doPlayerSendTextMessage(pokemonMaster, MESSAGE_EVENT_ADVANCE, "Your Pokemon is evolving!")
            end
        end, 3000, pokemonMaster)

		addEvent(function(pokemonMaster, cidName, toPokemon, pokemonPosition)
            if (isCreature(pokemonMaster)) then
                doPlayerSendTextMessage(pokemonMaster, MESSAGE_EVENT_ADVANCE, string.format(__L(pokemonMaster, "Your %s has evolved into %s!"), cidName, __L(pokemonMaster, getMonsterInfo(toPokemon).description)))
                doCreatureSetStorage(pokemonMaster, playersStorages.isEvolving, -1)
                doPokemonUpdate(toPokemon, pokemonMaster, pokemonPosition)
            end
        end, 9500, pokemonMaster, getCreatureName(cid), toPokemon, pokemonPosition)

	else
		addEvent(doCreateWildPokemon, 9500, toPokemon, pokemonPosition, getMonsterLevel(cid), getMonsterSex(cid), getCreatureTarget(cid))
	end

    doRemoveCreature(cid)
	doSendMagicEffect(pokemonPosition, EFFECT_EVOLVE_CLOUD)
	doSendMagicEffect(pokemonPosition, EFFECT_EMOTION_EXCLAMATION)
end

function getPokemonBonusAttack(cid)
    local v = tonumber(getCreatureStorage(cid, pokemonsStorages.bonusAtk))
    return v > -1 and v or 0
end

function setPokemonBonusAttack(cid, value)
    doCreatureSetStorage(cid, pokemonsStorages.bonusAtk, value)
end

function getPokemonBonusDefense(cid)
    local v = tonumber(getCreatureStorage(cid, pokemonsStorages.bonusAtk))
    return v > -1 and v or 0
end

function setPokemonBonusDefense(cid, value)
    doCreatureSetStorage(cid, pokemonsStorages.bonusDef, value)
end

function getPokemonLastUsedMove(cid)
    local v = getCreatureStorage(cid, pokemonsStorages.lastUsedMove)
    return v ~= -1 and v or nil
end

function setPokemonLastUsedMove(cid, move)
    doCreatureSetStorage(cid, pokemonsStorages.lastUsedMove, move)
end

function getPokemonStoredDamage(cid)
    return getCreatureStorage(cid, pokemonsStorages.storedDamage)
end

function setPokemonStoredDamage(cid, v)
    doCreatureSetStorage(cid, pokemonsStorages.storedDamage, v)
end

function getPokemonHealthBeforeSubstitute(cid)
    return getCreatureStorage(cid, pokemonsStorages.healthBeforeSubstitute)
end

function setPokemonHealthBeforeSubstitute(cid, v)
    doCreatureSetStorage(cid, pokemonsStorages.healthBeforeSubstitute, v)
end

function checkPokemonHungry(cid)
    if (isCreature(cid)) then
        if (not hasCondition(cid, CONDITION_REGENERATION)) then
            local master = getCreatureMaster(cid)
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_HUNGRY)
            doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE,
                string.format(__L(master, "Your %s is hungry!"), getCreatureName(cid)))
            addEvent(checkPokemonHungry, 60 * 1000, cid)
        else
            addEvent(checkPokemonHungry, 15 * 60 * 1000, cid)
        end
    end
end

function getPokemonReferenceName(cid)
    return isPokemonTransformed(cid) and getPokemonCurrentTransformation(cid) or getCreatureName(cid)
end

function canWildPokemonEvolve(cid)
    return getCreatureStorage(cid, pokemonsStorages.canEvolve) == 1
end

function setWildPokemonEvolvable(cid, v)
    doCreatureSetStorage(cid, pokemonsStorages.canEvolve, v and 1 or 0)
end

function setPokemonCustomType(cid, type)
    doCreatureSetStorage(cid, pokemonsStorages.customType1, type)
end

function getPokemonCustomType(cid--[[, number]])
    --[[if (number == 1) then]]
        return getCreatureStorage(cid, pokemonsStorages.customType1)
    --[[elseif (number == 2) then
        return getCreatureStorage(cid, pokemonsStorages.customType2)
    end
    return -1]]
end

function setPokemonSummon(cid, v)
    doCreatureSetStorage(cid, pokemonsStorages.pokemonSummon, v and 1 or 0)
end

function getPokemonSummon(cid)
    return getCreatureStorage(cid, pokemonsStorages.pokemonSummon) > 0
end

function doPokemonActAtPosition(pokemon, position, callback)
    local check = nil
    check = function(cid, toPosition, ticks)
        if (isCreature(cid)) then
            if (getDistanceBetween(getCreaturePosition(cid), toPosition) < 2) then
                callback(cid, position, toPosition)
            elseif (ticks > 1) then
                addEvent(check, 500, cid, toPosition, ticks - 1)
            end
        end
    end

    local pokemonPos = getCreaturePosition(pokemon)
    local targetPos = (getDistanceBetween(pokemonPos, position) <= 1 and position or
            getPositionAdjacent(pokemon, position, true))

    if (targetPos and isSightClear(pokemonPos, targetPos, true) and getDistanceBetween(targetPos, position) <= 1 and
            getPathToEx(pokemon, targetPos)) then

        doCreatureWalkToPosition(pokemon, targetPos)
        check(pokemon, position, 20)
        return true
    end

    return false
end

function setPokemonHeldMovePowerModifier(cid, v)
    doCreatureSetStorage(cid, pokemonsStorages.heldMovePowerModifier, v)
end

function getPokemonHeldMovePowerModifier(cid)
    local v = getCreatureStorage(cid, pokemonsStorages.heldMovePowerModifier)
    return v ~= EMPTY_STORAGE and v or 1
end

function setPokemonHeldMovePowerType(cid, v, slot)
    if (not slot) then
        slot = 1
    end

    doCreatureSetStorage(cid, (slot == 1 and pokemonsStorages.heldMovePowerType or
            pokemonsStorages.heldMovePowerType2), v)
end

function getPokemonHeldMovePowerType(cid, slot)
    if (not slot) then
        slot = 1
    end

    return getCreatureStorage(cid, (slot == 1 and pokemonsStorages.heldMovePowerType or
            pokemonsStorages.heldMovePowerType2))
end
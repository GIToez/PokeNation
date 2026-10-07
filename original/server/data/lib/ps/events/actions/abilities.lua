local config = {
    borders = {
        -- surfX, surfY, deSurfX, deSurfY
        [4644] = { sX = 0, sY = -1, dX = 0, dY = 1 },
        [4645] = { sX = 1, sY = 0, dX = -1, dY = 0 },
        [4646] = { sX = 0, sY = 1, dX = 0, dY = -1 },
        [4647] = { sX = -1, sY = 0, dX = 1, dY = 0 },
        [4648] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [4649] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [4650] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [4651] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        [4652] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [4653] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [4654] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [4655] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        -- Ice borders
        [6627] = { sX = 0, sY = -1, dX = 0, dY = 1 },
        [6628] = { sX = 1, sY = 0, dX = -1, dY = 0 },
        [6629] = { sX = 0, sY = 1, dX = 0, dY = -1 },
        [6630] = { sX = -1, sY = 0, dX = 1, dY = 0 },
        [6634] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [6633] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [6632] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [6631] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        [6635] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [6636] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [6638] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [6637] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        -- Ice borders 2
        [6687] = { sX = 0, sY = -1, dX = 0, dY = 1 },
        [6688] = { sX = 1, sY = 0, dX = -1, dY = 0 },
        [6689] = { sX = 0, sY = 1, dX = 0, dY = -1 },
        [6690] = { sX = -1, sY = 0, dX = 1, dY = 0 },
        -- Ice borders 3
        [6691] = { sX = 0, sY = -1, dX = 0, dY = 1 },
        [6692] = { sX = 1, sY = 0, dX = -1, dY = 0 },
        [6693] = { sX = 0, sY = 1, dX = 0, dY = -1 },
        [6694] = { sX = -1, sY = 0, dX = 1, dY = 0 },
        -- Ice borders 4
        [6675] = { sX = 0, sY = 1, dX = 0, dY = -1 },
        [6676] = { sX = 1, sY = 0, dX = -1, dY = 0 },
        [6677] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [6678] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        [6679] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [6680] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [6681] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [6682] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        -- Rock borders
        [6639] = { sX = 0, sY = -1, dX = 0, dY = 1 },
        [6640] = { sX = 1, sY = 0, dX = -1, dY = 0 },
        [6641] = { sX = 0, sY = 1, dX = 0, dY = -1 },
        [6642] = { sX = -1, sY = 0, dX = 1, dY = 0 },
        [6643] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [6644] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [6645] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [6646] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        [6647] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [6648] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [6649] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [6650] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        -- Beach
        [4632] = { sX = 0, sY = -1, dX = 0, dY = 1 },
        [4635] = { sX = 1, sY = 0, dX = -1, dY = 0 },
        [4634] = { sX = 0, sY = 1, dX = 0, dY = -1 },
        [4633] = { sX = -1, sY = 0, dX = 1, dY = 0 },
        [4639] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [4638] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [4637] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [4636] = { sX = 1, sY = 1, dX = -1, dY = -1 },
        [4643] = { sX = -1, sY = -1, dX = 1, dY = 1 },
        [4642] = { sX = 1, sY = -1, dX = -1, dY = 1 },
        [4641] = { sX = -1, sY = 1, dX = 1, dY = -1 },
        [4640] = { sX = 1, sY = 1, dX = -1, dY = -1 }
    },
    nestThree = 12295,
    holes = { 468, 481, 483, 7932, 8579 },
    grasses = { 2782, 3985 },
    stones = { { itemId = 1285 }, { itemId = 18742 }, { itemId = 23563, aid = 123 } },
    waterfallItems = { 3569, 3570, 3571, 3572 },
    strengthItems = { 23443 },
    rockClimbItems = { 23448, 23449, 23446, 23447 },
    flyDisabledLocations = {
        { fromPosition = { x = 5374, y = 72, z = 7 }, toPosition = { x = 5658, y = 326, z = 7 } }
    }
}

local function isInStonesTable(item)
    for k, v in pairs(config.stones) do
        if (v.itemId == item.itemid and (not v.aid or v.aid == item.actionid)) then
            return true
        end
    end
    return false
end

local function onCustomOrder(cid, pokemon, toPosition, itemEx)
    if (isItem(itemEx)) then
        if (itemEx.itemid == 23549) then -- torch bearer (off)
            if (getCreatureStorage(cid, 8449) ~= QUEST_STATUS.STARTED or
                    not table.find(getPokemonTypes(pokemon), ELEMENT_FIRE)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end

            doPokemonActAtPosition(pokemon, toPosition, function(pokemon, fromPosition, toPosition)
                itemEx = getTileItemById(toPosition, itemEx.itemid)
                if (isItem(itemEx)) then
                    doCreateMonster("Scary Haunter", getCreaturePosition(pokemon))
                    local count = doCreatureIncreaseStorage(cid, 8451)
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You light the torch. [%s/8]"), count))
                    doSendDistanceShoot(getCreaturePosition(pokemon), toPosition, PROJECTILE_FIRE)
                    doSendMagicEffect(toPosition, EFFECT_FIRE_FIELD)

                    doTransformItem(itemEx.uid, 23550) -- torch bearer (on)
                    doDecayItem(itemEx.uid)
                end
            end)

            return true

        elseif (itemEx.itemid == 23568) then -- lia's wardrobe
            if (getCreatureStorage(cid, 8450) ~= QUEST_STATUS.STARTED or
                    not getPokemonAbilityAvailable(pokemon, POKEMON_ABILITIES.STRENGTH)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end

            doPokemonActAtPosition(pokemon, toPosition, function(pokemon, fromPosition, toPosition)
                itemEx = getTileItemById(toPosition, itemEx.itemid)
                if (isItem(itemEx)) then
                    if (getRandom(1, 100) <= 60) then
                        doCreateMonster("Felon Raticate", getCreaturePosition(pokemon))
                    end

                    local count = doCreatureIncreaseStorage(cid, 8452)
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You destroyed a wardrobe. [%s/6]"), count))
                    doSendDistanceShoot(getCreaturePosition(pokemon), toPosition, PROJECTILE_GRAVEL)
                    doSendMagicEffect(toPosition, EFFECT_EARTH_EXPLOSION)
                    doTransformItem(itemEx.uid, 23569) -- lia's wardrobe leftover
                    doDecayItem(itemEx.uid)
                end
            end)

            return true

        elseif (itemEx.itemid == 23587) then -- peppermoon bells
            if (getCreatureStorage(cid, 8473) == QUEST_STATUS.STARTED) then -- Koga quest #1
                doPokemonActAtPosition(pokemon, toPosition, function(pokemon, fromPosition, toPosition)
                    itemEx = getTileItemById(toPosition, itemEx.itemid)
                    if (isItem(itemEx)) then
                        if (getRandom(1, 4) == 1) then
                            doPlayerSafeAddItem(cid, 23588, 1, true, true) -- blue pollen
                        elseif (getRandom(1, 100) <= 60) then
                            doCreateMonster("Furious Venomoth", getCreaturePosition(pokemon))
                        end

                        doCreatureAddStatus(pokemon, CREATURE_STATUS_SLEEP)
                        doSendDistanceShoot(getCreaturePosition(pokemon), toPosition, PROJECTILE_GRAVEL)
                        doSendMagicEffect(toPosition, EFFECT_SCRATCH)
                        doRemoveItem(itemEx.uid)
                        addEvent(doCreateItem, 10 * 60 * 1000, itemEx.itemid, 1, toPosition)
                    end
                end)
            end

        elseif (itemEx.itemid == 23547) then -- blue weed
            if (getCreatureStorage(cid, 8442) == QUEST_STATUS.STARTED) then -- London Hamnet #2
                doPokemonActAtPosition(pokemon, toPosition, function(pokemon, fromPosition, toPosition)
                    itemEx = getTileItemById(toPosition, itemEx.itemid)
                    if (isItem(itemEx)) then
                        if (getPlayerItemCount(cid, 23564) <= 0) then -- blue weed
                            doPlayerSafeAddItem(cid, 23564, 1, true, true) -- blue weed
                        end
                        doSendDistanceShoot(getCreaturePosition(pokemon), toPosition, PROJECTILE_GRAVEL)
                        doSendMagicEffect(toPosition, EFFECT_SCRATCH)
                        doRemoveItem(itemEx.uid)
                        addEvent(doCreateItem, 10 * 60 * 1000, itemEx.itemid, 1, toPosition)
                    end
                end)
            end
        end
    end

    return false
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (toPosition.x == CONTAINER_POSITION) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local playerPosition = getCreaturePosition(cid)
    local pokemonName = getPlayerPokemonName(cid, true)

    if (doComparePositions(playerPosition, toPosition)) then
        if (isPlayerOnPvpArena(cid) or getPlayerTournamentReady(cid)) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

        elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.RIDE, pokemonName)) then
            local ball = getPlayerBall(cid)
            if (isItem(ball) and isEpicBall(ball.itemid)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end

            if (isUnderwater(cid)) then
                doPlayerSendCancel(cid, "You can not ride while you're underwater.")

            elseif (isRiding(cid)) then
                deRide(cid)

            elseif (isPokemonOnline(cid)) then
                if (hasCondition(cid, CONDITION_INFIGHT) or getPlayerDueling(cid) or
                        getPlayerMasteryDungeon(cid) > 0 or getPlayerFrontierIsland(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

                else
                    ride(cid)
                end
            end

        elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.FLY, pokemonName)) then
            local ball = getPlayerBall(cid)
            if (isItem(ball) and isEpicBall(ball.itemid)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end

            if (isUnderwater(cid)) then
                doPlayerSendCancel(cid, "You can not fly while you're underwater.")

            elseif (isFlying(cid) and playerPosition.z ~= 0 and
                    getItemNameById(getTileThingByPos({ x = playerPosition.x, y = playerPosition.y, z = playerPosition.z, stackpos = 0 }).itemid) ~= "shallow water" and
                    getTileThingByPos({ x = playerPosition.x, y = playerPosition.y, z = playerPosition.z, stackpos = 0 }).itemid ~= VOID_TILE_ID) then
                deFly(cid)

            elseif (isPokemonOnline(cid)) then
                if (not isPremium(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)

                elseif (hasCondition(cid, CONDITION_INFIGHT) or getPlayerDueling(cid) or
                        getPlayerMasteryDungeon(cid) > 0 or getPlayerFrontierIsland(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

                else
                    for k, v in pairs(config.flyDisabledLocations) do
                        if (isInRange(playerPosition, v.fromPosition, v.toPosition, true)) then
                            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                            return true
                        end
                    end

                    fly(cid)
                end
            end

        elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.LEVITATE, pokemonName)) then
            local ball = getPlayerBall(cid)
            if (isItem(ball) and isEpicBall(ball.itemid)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end

            if (isUnderwater(cid)) then
                doPlayerSendCancel(cid, "You can not levitate while you're underwater.")

            elseif (isLevitating(cid) and playerPosition.z ~= 0 and
                    getItemNameById(getTileThingByPos({ x = playerPosition.x, y = playerPosition.y, z = playerPosition.z, stackpos = 0 }).itemid) ~= "shallow water" and
                    getTileThingByPos({ x = playerPosition.x, y = playerPosition.y, z = playerPosition.z, stackpos = 0 }).itemid ~= VOID_TILE_ID) then
                deLevitate(cid)

            elseif (isPokemonOnline(cid)) then
                if (not isPremium(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)

                elseif (hasCondition(cid, CONDITION_INFIGHT) or getPlayerDueling(cid) or
                        getPlayerMasteryDungeon(cid) > 0 or getPlayerFrontierIsland(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

                else
                    levitate(cid)
                end
            end

        elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.DIVE, pokemonName)) then
            local ball = getPlayerBall(cid)
            if (isItem(ball) and isEpicBall(ball.itemid)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end

            if (isDiving(cid)) then
                deDive(cid)

            elseif (isPokemonOnline(cid) and isUnderwater(cid)) then
                if (not isPremium(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)

                elseif (hasCondition(cid, CONDITION_INFIGHT) or getPlayerDueling(cid) or
                        getPlayerMasteryDungeon(cid) > 0 or getPlayerFrontierIsland(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

                else
                    dive(cid)
                end
            end

        else
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        end

    else
        local conf = config.borders[getThingFromPos({ x = toPosition.x, y = toPosition.y, z = toPosition.z, stackpos = 1 }).itemid] ~= nil and
                config.borders[getThingFromPos({ x = toPosition.x, y = toPosition.y, z = toPosition.z, stackpos = 1 }).itemid] or
                config.borders[getThingFromPos({ x = toPosition.x, y = toPosition.y, z = toPosition.z, stackpos = 0 }).itemid]
        if (conf) then
            if (not isPremium(cid) and not isSurfing(cid)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)

            elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.SURF, pokemonName) and
                    getDistanceBetween(playerPosition, toPosition) < 2) then
                if (isSurfing(cid)) then
                    local groundName = "shallow water"
                    local nextTile = { x = toPosition.x + conf.dX, y = toPosition.y + conf.dY, z = toPosition.z }
                    local freeTile

                    while (groundName == "shallow water") do
                        freeTile = getClosestFreeTile(cid, nextTile, false, false)
                        groundName = getItemNameById(getThingFromPos(freeTile).itemid)
                        nextTile.x = nextTile.x + conf.dX
                        nextTile.y = nextTile.y + conf.dY
                    end

                    if (freeTile and getDistanceBetween(playerPosition, freeTile) < 3 and
                            isSightClear(playerPosition, freeTile, false) and isWalkable(cid, freeTile)) then
                        deSurf(cid, freeTile)
                    else
                        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                    end

                else
                    if (not isPokemonOnline(cid) or hasCondition(cid, CONDITION_INFIGHT) or not isPremium(cid)
                            or getPlayerDueling(cid) or getPlayerMasteryDungeon(cid) > 0 or
                            getPlayerFrontierIsland(cid) or getPlayerPvpArena(cid)) then
                        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                        return true
                    end

                    local newPos = { x = toPosition.x + conf.sX, y = toPosition.y + conf.sY, z = toPosition.z }
                    local newPosTile = getTileThingByPos({
                        x = toPosition.x + conf.sX,
                        y = toPosition.y + conf.sY,
                        z = toPosition.z,
                        stackpos = STACKPOS_GROUND
                    })
                    if (not isWalkable(cid, newPos) or (isItem(newPosTile) and
                            not table.find(WATER_IDS, newPosTile.itemid))) then
                        doPlayerSendCancel(cid, "You can't surf there.")
                        return true
                    end

                    surf(cid, newPos, toPosition)
                end

            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        else
            if (isInArray(config.waterfallItems, itemEx.itemid)) then
                if (not isPremium(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
                elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.WATERFALL, pokemonName)) then
                    PokemonAbility.onUseWaterfall(cid, toPosition, itemEx)
                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end
                return true
            end

            if (not isPokemonOnline(cid)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return true
            end

            local pokemon = getPlayerPokemon(cid)
            if (isInArray(config.holes, itemEx.itemid)) then
                if (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.DIG, pokemonName)) then
                    dig(cid, itemEx, toPosition)
                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end

            elseif (isInArray(config.grasses, itemEx.itemid)) then
                if (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.CUT, pokemonName)) then
                    cut(cid, itemEx, toPosition)
                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end

            elseif (isInStonesTable(itemEx)) then
                if (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.ROCK_SMASH, pokemonName)) then
                    rockSmash(cid, itemEx, toPosition)
                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end

            elseif (itemEx.itemid == config.nestThree) then
                if (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.HEADBUTT, pokemonName)) then
                    Headbutt.onHeadbutt(cid, itemEx, toPosition)
                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end

            elseif (isInArray(config.strengthItems, itemEx.itemid)) then
                if (not isPremium(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
                elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.STRENGTH, pokemonName)) then
                    PokemonAbility.onUseStrength(cid, toPosition, itemEx, pokemon)
                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end

            elseif (isInArray(config.rockClimbItems, itemEx.itemid)) then
                if (not isPremium(cid)) then
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
                elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.ROCK_CLIMB, pokemonName)) then
                    PokemonAbility.onUseRockClimb(cid, toPosition, itemEx, pokemon)
                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end

            else
                local pokemonPosition = getCreaturePosition(pokemon)
                if (toPosition.x == pokemonPosition.x and toPosition.y == pokemonPosition.y and toPosition.z == pokemonPosition.z) then
                    if (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.FLASH, pokemonName)) then
                        if (hasCondition(pokemon, CONDITION_LIGHT)) then
                            deLight(cid)
                        else
                            light(cid)
                        end

                    else
                        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                    end

                elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.BLINK, pokemonName) and canBlink(cid)) then
                    if (isWalkable(pokemon, toPosition) and isSightClear(pokemonPosition, toPosition, true) and
                            not getCreatureStatus(pokemon, CREATURE_STATUS_SLEEP)) then
                        blink(cid, toPosition)

                    else
                        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                    end

                elseif (getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.TRANSFORM, pokemonName) and
                        isMonster(itemEx.uid)) then
                    doAbilitieTransform(cid, pokemon, itemEx.uid)

                elseif (getTilePzInfo(toPosition)) then -- Block send pokemon to protected zones, prevent bugs like easy fishing skill
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

                elseif (onCustomOrder(cid, pokemon, toPosition, itemEx)) then -- Quests actions
                    doCreatureSay(cid, string.format(__L(cid, "%s, there is!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
                    return true

                elseif (getPathToEx(pokemon, toPosition)) then
                    doCreatureWalkToPosition(pokemon, toPosition)
                    doCreatureSay(cid, string.format(__L(cid, "%s, go there!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)

                else
                    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                end
            end
        end
    end

    return true
end

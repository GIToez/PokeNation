local function doPlayerRemoveRequiredItems(cid, items)
    for k, v in ipairs(items) do
        doPlayerRemoveItem(cid, v, 1)
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isPokemonOnline(cid) or isEvolving(cid) or getPlayerBattleing(cid) or getPlayerDueling(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local pokemonName = getPlayerPokemonName(cid)
    if (not havePokemonEvolution(pokemonName)) then
        doPlayerSendCancel(cid, "Your Pokemon can no longer evolve.")
        return true
    end

    local evolutions = getPokemonEvolutions(pokemonName)
    local evolve, extraPokemon, randomEvolves
    for _, evolution in ipairs(evolutions) do
        if (evolution.extraPokemon) then
            extraPokemon = evolution.name
        else
            local canEvolve = true
            if (evolution.requiredItems) then
                for i, itemId in ipairs(evolution.requiredItems) do
                    if (getPlayerItemCount(cid, itemId) < 1) then
                        canEvolve = false
                        break
                    end
                end
            end

            if (canEvolve and (evolution.requiredTime and getWorldLightState() ~= evolution.requiredTime) or (getPlayerPokemonLevel(cid) < evolution.requiredLevel)) then
                canEvolve = false
            end

            if (canEvolve) then
                if (evolution.random) then
                    if (isTable(randomEvolves)) then
                        randomEvolves[#randomEvolves + 1] = evolution
                    else
                        randomEvolves = { evolution }
                    end

                elseif (evolve) then
                    doPlayerSendCancel(cid, "You need to carry the items of only one evolution to evolve this Pokemon.")
                    return true

                else
                    evolve = evolution
                end
            end
        end
    end

    -- When evolve is a table, it means that we have a random evolution
    if (randomEvolves) then
        evolve = table.random(randomEvolves)
    end

    if (evolve and getMonsterInfo(evolve.name, false)) then -- Check if this Pokemon already exists, eg.: A shiny unavailable
        if (evolve.requiredItems) then
            doPlayerRemoveRequiredItems(cid, evolve.requiredItems)
        end
        local pokemon = getPlayerPokemon(cid)

        if (extraPokemon) then
            if (getPlayerFreeCap(cid) >= 1 and getPlayerItemCount(cid, balls["poke"].empty) > 0) then
                doCreatePokemonBall(cid, "poke", extraPokemon, getMonsterLevel(pokemon), getMonsterSex(pokemon), nil, getMonsterExtraPoints(pokemon))
                doPlayerRemoveItem(cid, balls["poke"].empty, 1)
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Congratulations, you received an extra Pokemon: " .. extraPokemon .. "!")
            end
        end

        doPokemonEvolve(pokemon, evolve.name)
    else
        doPlayerSendCancel(cid, "Your Pokemon can't evolve right now.")
    end

    return true
end

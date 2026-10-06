if (PokemonEgg) then
    return
end

PokemonEgg = {}

-- Constants
local SHINY_CHANCE = getConfigValue("shinyAppearChance")

local CHOOSING_EGG_MOVE_CONDITION = createConditionObject(CONDITION_CUSTOM, 10 * 60 * 1000, false,
    CONDITION_SUBID.CUSTOM.CHOOSING_EGG_MOVE)
setConditionParam(CHOOSING_EGG_MOVE_CONDITION, CONDITION_PARAM_LIGHT_LEVEL, CONST_ME_NONE) -- Effect Type

-- Vars

-- Local
local function doEggHatch(cid, incubator, pokemonName, replacingSlot)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Congratulations! Your %s egg hatches!"), pokemonName))
    if (getRandom(0, SHINY_CHANCE) == 0) then
        pokemonName = getMonsterInfo(pokemonName).shiny
    end
    local eggMove = nil
    local ball = doCreatePokemonBall(cid, "poke", pokemonName, 1, nil, nil, 10, nil, true, 9999999, nil, nil, nil,
        nil, nil, nil, nil, nil, nil,
        function(uid)
            if (replacingSlot) then
                eggMove = getItemAttribute(incubator.uid, ITEM_ATTRIBUTES.EGG_MOVE)
                setBallEggMove(uid, replacingSlot, getItemAttribute(incubator.uid, ITEM_ATTRIBUTES.EGG_MOVE))
                doBallUpdateDescription(uid)
            end
        end)

    doRemoveItem(incubator.uid)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)

    if (eggMove) then
        doDatalogEggMoveGenerate(os.time(), getPlayerGUID(cid), pokemonName, 1, 10, eggMove, true)
    end
end

-- Global
PokemonEgg.doGenerateEggMove = function(eggUid, eggName, plateType, isBall)
    local specieEggMoves = getPokemonEggMoves(eggName)
    local possibleEggMoves = table.copy(specieEggMoves)

    if (plateType) then
        for i = #possibleEggMoves, 1, -1 do
            local move = possibleEggMoves[i]
            if (getPokemonSkillDamageType(move) ~= plateType) then
                table.remove(possibleEggMoves, i)
            end
        end

        if (#possibleEggMoves == 0) then
            possibleEggMoves = table.copy(specieEggMoves)
        end
    end

    if (#possibleEggMoves > 0) then
        local eggMove = table.random(possibleEggMoves)
        if (isBall) then
            -- isBall is true when we are generating a Egg Move to an old Pokemon Egg, that doesnt have got the chance to have one Egg Move before.
            -- So, eggUid isn't really an egg, but a Pokemon Ball. We must put the generated Egg Move on the first move slot after Tackle, the player can change this slot via NPC later.
            local slot = PokemonEgg.getBallAvailableSlot(eggUid)
            if (slot) then
                setBallEggMove(eggUid, slot, eggMove)
                return eggMove
            end
        else
            doItemSetAttribute(eggUid, ITEM_ATTRIBUTES.EGG_MOVE, eggMove)
            return eggMove
        end
    end

    return nil
end

PokemonEgg.onEggHatch = function(cid, incubator, pokemonName)
    local eggMove = getItemAttribute(incubator.uid, ITEM_ATTRIBUTES.EGG_MOVE)
    if (not eggMove) then
        doEggHatch(cid, incubator, pokemonName)
        return
    end

    local replaceMoves = {}
    for _, replaceMove in pairs(getPokemonDefaultSkills(pokemonName)) do
        if (replaceMove ~= "Tackle") then
            replaceMoves[#replaceMoves + 1] = getPokemonSkillClientIconId(replaceMove)
        end
    end

    doPlayerSendTmWindow(cid, getPokemonSkillClientIconId(eggMove), replaceMoves)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Select the move that will be replaced by %s. (Shift + Click on move icon to details)"), eggMove))
    doAddCondition(cid, CHOOSING_EGG_MOVE_CONDITION)
    setPlayerLastUsedIncubator(cid, incubator.uid)

    local pokemonName = getItemAttribute(incubator.uid, 1001 --[[INCUBATOR_STORAGE_POKEMON_NAME]])
    local pokemonDescription = getMonsterInfo(pokemonName).description or pokemonName
    doItemSetSpecialDescription(incubator.uid, "This incubator is hatching " .. pokemonDescription .. " egg.\nReady to hatch!\nEgg Move: " .. eggMove .. ".")
end

PokemonEgg.isChoosingEggMove = function(cid)
    return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.CHOOSING_EGG_MOVE)
end

PokemonEgg.removeChooseCondition = function(cid)
    doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.CHOOSING_EGG_MOVE)
end

PokemonEgg.canReplaceMove = function(choosenMove, choosenSlot, ballUid)
    if (choosenMove == "Tackle") then
        return false
    end

    if (not ballUid) then -- Egg hatching
        return true
    end

    local tm1Slot = getBallTmSlot(ballUid, 1)
    if (tm1Slot and choosenSlot == tm1Slot) then
        return false
    end

    local tm2Slot = getBallTmSlot(ballUid, 2)
    if (tm2Slot and choosenSlot == tm2Slot) then
        return false
    end

    return true
end

PokemonEgg.getBallAvailableSlot = function(ballUid)
    local pokemonMoves = table.deepcopy(getPokemonDefaultSkills(getBallPokemonName(ballUid)))
    for slot, move in pairs(pokemonMoves) do
        if (PokemonEgg.canReplaceMove(move, slot, ballUid)) then
            return slot
        end
    end
    return nil
end

PokemonEgg.onMoveChoose = function(cid, replacedMoveClientItemId)
    PokemonEgg.removeChooseCondition(cid)

    local incubator = getPlayerLastUsedIncubator(cid)
    if (not isItem(incubator)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local replacingMove = getPokemonSkillByClientIconId(replacedMoveClientItemId)
    if (not PokemonEgg.canReplaceMove(replacingMove)) then
        doPlayerSendCancel(cid, "You can't replace this move.")
        return false
    end

    local pokemonName = getItemAttribute(incubator.uid, ITEM_ATTRIBUTES.INCUBATOR_POKEMON_NAME)
    local currentMoves = getPokemonDefaultSkills(pokemonName)
    local slot = table.find(currentMoves, getPokemonSkillByClientIconId(replacedMoveClientItemId))
    if (not slot) then
        log(LOG_TYPES.ERROR, "PokemonEgg.onMoveChoose - nil slot, replacingMove can't be found on currentMoves",
            getCreatureName(cid), pokemonName, currentMoves, replacedMoveClientItemId)
        return false
    end

    doEggHatch(cid, incubator, pokemonName, slot)
end

PokemonEgg.doRegenerateEggMove = function(ballUid)
    local regeneratedEggMoves = getBallRegeneratedEggMoves(ballUid)
    local possibleEggMoves = table.deepcopy(getPokemonEggMoves(getBallPokemonName(ballUid)))

    for _, v in pairs(regeneratedEggMoves) do
        table.removeValue(possibleEggMoves, v, false)
    end
    table.removeValue(possibleEggMoves, getBallEggMove(ballUid), false)

    if (#possibleEggMoves > 0) then
        local eggMove = table.randomRemove(possibleEggMoves)
        regeneratedEggMoves[#regeneratedEggMoves + 1] = eggMove

        setBallEggMovesRegenerated(ballUid, regeneratedEggMoves)
        setBallLastEggMoveRegenerated(ballUid, eggMove)

        if (#possibleEggMoves == 0) then
            setBallEggMoveRegenerateEnabled(ballUid, false)
        end

        return eggMove
    end

    return nil
end
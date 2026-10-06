if (PokemonAbility) then
    return
end

PokemonAbility = {}

-- Constants
local WATERFALL_DESTINATION_BY_ITEMID = {
    [3569] = {firstX = 0, firstY = 0, x = 0, y = 0, z = -1, endItemId = 3571}, -- Vertical Up
    [3570] = {firstX = 0, firstY = 0, x = 0, y = 0, z = -1, endItemId = 3572}, -- Horizontal Up
    [3571] = {firstX = 0, firstY = 1, x = 0, y = 0, z = 1, endItemId = 3573}, -- Vertical Down
    [3572] = {firstX = 1, firstY = 0, x = 0, y = 0, z = 1, endItemId = 3574}, -- Horizontal Down
}

local STRENGTH_MAX_PER_USE = 1
local STRENGTH_DUST_BY_DIR = {
    [NORTH] = EFFECT_DUST_DOWN,
    [SOUTH] = EFFECT_DUST_UP,
    [EAST] = EFFECT_DUST_LEFT,
    [WEST] = EFFECT_DUST_RIGHT
}

local ROCKCLIMB_DESTINATION_BY_ITEMID = {
    [23449] = {firstX = 0, firstY = -2, x = 0, y = 0, z = -1, endItemId = 23447}, -- Vertical Up
    [23448] = {firstX = -2, firstY = 0, x = 0, y = 0, z = -1, endItemId = 23446}, -- Horizontal Up
    [23446] = {firstX = 2, firstY = 0, x = 0, y = 0, z = 1, endItemId = 23448}, -- Vertical Down
    [23447] = {firstX = 0, firstY = 2, x = 0, y = 0, z = 1, endItemId = 23449}, -- Horizontal Down
}

-- Vars

-- Methods Local

-- Methods Global
PokemonAbility.onUseWaterfall = function(cid, position, itemEx)
    if (not WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid]) then
        log(LOG_TYPES.ERROR, "PokemonAbility.onUseWaterfall - Unknown itemEx.itemid", getCreatureName(cid), position,
            itemEx)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    if (not isSurfing(cid)) then
        doPlayerSendCancel(cid, "You must use Surf first.")
        return false

    elseif (getDistanceBetween(getCreaturePosition(cid), position) > 1) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return false
    end

    local toPos = {x = position.x + WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid].firstX,
        y = position.y + WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid].firstY,
        z = position.z + WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid].z}
    local currentPos = getCreaturePosition(cid)
    local antiLoop = 0
    local destination

    while (toPos) do
        currentPos = toPos

        local item = getTileItemById(currentPos, WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid].endItemId)
        if (isItem(item)) then
            destination = currentPos
            break

        elseif (currentPos.z < MAP_LAYER_MAX and currentPos.z > MAP_LAYER_MIN) then
            toPos = {x = currentPos.x + WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid].x,
                y = currentPos.y + WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid].y,
                z = currentPos.z + WATERFALL_DESTINATION_BY_ITEMID[itemEx.itemid].z }
        else
            toPos = nil
        end

        antiLoop = antiLoop + 1
        if (antiLoop > 999) then
            log(LOG_TYPES.WARNING, "PokemonAbility.onUseWaterfall - Anti loop max reached.", currentPos, itemEx,
                getCreatureName(cid))
            break
        end
    end

    if (destination) then
        doSendMagicEffect(position, EFFECT_SURF)
        doSendMagicEffect(destination, EFFECT_WATER_DISAPPEAR)
        doTeleportThing(cid, destination)
    end

    doCreatureSay(cid, string.format(__L(cid, "%s, let's go!"), getPlayerPokemonNickname(cid)), TALKTYPE_MONSTER)
end

PokemonAbility.onUseStrength = function(cid, position, itemEx, pokemon)
    local check = nil
    check = function(cid, itemEx, toPosition, ticks)
        if (isCreature(cid)) then
            if (getDistanceBetween(getCreaturePosition(cid), toPosition) < 2) then
                local i = 0
                local currentPos = table.copy(position)
                local direction = getDirectionTo(getCreaturePosition(cid), position, true)
                local nextPos = getPositionByDirection(position, direction, 1)

                local internalFunc = nil
                internalFunc = function()
                    if (not isCreature(cid) or not isWalkable(cid, nextPos)) then
                        return
                    end

                    itemEx = getTileItemById({x = currentPos.x, y = currentPos.y, z = currentPos.z}, itemEx.itemid)

                    doSendDistanceShoot(currentPos, nextPos, PROJECTILE_GRAVEL)
                    doSendMagicEffect(currentPos, STRENGTH_DUST_BY_DIR[direction])
                    doMoveItem(itemEx.uid, nextPos, true)
                    currentPos = table.copy(nextPos)

                    i = i + 1
                    nextPos = getPositionByDirection(nextPos, direction, 1)

                    if (i < STRENGTH_MAX_PER_USE) then
                        addEvent(internalFunc, (i / STRENGTH_MAX_PER_USE) * 100)
                    end
                end

                doSendMagicEffect(currentPos, EFFECT_BIG_PUNCH)
                internalFunc()

            elseif (ticks > 1) then
                addEvent(check, 500, cid, itemEx, toPosition, ticks - 1)
            end
        end
    end

    local pokemonPos = getCreaturePosition(pokemon)
    local targetPos = (getDistanceBetween(pokemonPos, position) <= 1 and position or
            getPositionAdjacent(pokemon, position, true))

    if (targetPos and isSightClear(pokemonPos, targetPos, true) and getDistanceBetween(targetPos, position) <= 1 and
            getPathToEx(pokemon, targetPos)) then
        doCreatureSay(cid, string.format(__L(cid, "%s, push it!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        doCreatureWalkToPosition(pokemon, targetPos)
        check(pokemon, itemEx, position, 20)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

PokemonAbility.onUseRockClimb = function(cid, position, itemEx, pokemon)
    if (not ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid]) then
        log(LOG_TYPES.ERROR, "PokemonAbility.onUseRockClimb - Unknown itemEx.itemid", getCreatureName(cid), position,
            itemEx)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local callback = function(pokemon, fromPosition, toPosition)
        local toPos = {x = position.x + ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid].firstX,
            y = position.y + ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid].firstY,
            z = position.z + ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid].z}
        local currentPos = getCreaturePosition(cid)
        local antiLoop = 0
        local destination

        while (toPos) do
            currentPos = toPos

            local item = getTileItemById(currentPos, ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid].endItemId)
            if (isItem(item)) then
                destination = currentPos
                break

            elseif (currentPos.z < MAP_LAYER_MAX and currentPos.z > MAP_LAYER_MIN) then
                toPos = {x = currentPos.x + ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid].x,
                    y = currentPos.y + ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid].y,
                    z = currentPos.z + ROCKCLIMB_DESTINATION_BY_ITEMID[itemEx.itemid].z }
            else
                toPos = nil
            end

            antiLoop = antiLoop + 1
            if (antiLoop > 999) then
                log(LOG_TYPES.WARNING, "PokemonAbility.onUseRockClimb - Anti loop max reached.", currentPos, itemEx,
                    getCreatureName(cid))
                break
            end
        end

        if (destination) then
            doSendMagicEffect(position, EFFECT_TELEPORT_UP)
            doSendMagicEffect(destination, EFFECT_TELEPORT_DOWN)
            doTeleportThing(cid, destination)
        end
    end

    if (doPokemonActAtPosition(pokemon, position, callback)) then
        doCreatureSay(cid, string.format(__L(cid, "%s, let's climb!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

PokemonAbility.afterHeadbutt = function(cid, pokemon, position) -- quest stuff
    if (getCreatureStorage(cid, 8466) == QUEST_STATUS.STARTED and getRandom(1, 5) == 1 and
            getPlayerItemCount(cid, 8466) < 15) then -- Misty quest #1
        doPlayerSafeAddItem(cid, 23580, 1, true, true) -- fine wood
    end
end

PokemonAbility.afterRockSmash = function(cid, pokemon, position) -- quest stuff
    if (getCreatureStorage(cid, 8466) == QUEST_STATUS.STARTED and getRandom(1, 5) == 1) then -- Misty quest #1
        local POSITIONS = {
            {x = 3912, y = 232, z = 9},
            {x = 3912, y = 222, z = 9},
            {x = 3919, y = 216, z = 9},
            {x = 3925, y = 226, z = 9},
            {x = 3939, y = 230, z = 9},
            {x = 3932, y = 246, z = 9},
            {x = 3938, y = 252, z = 9},
            {x = 3945, y = 241, z = 9},
        }

        local questPosition = false
        for k, v in pairs(POSITIONS) do
            if (getSamePosition(position, v)) then
                questPosition = true
                break
            end
        end

        if (questPosition) then
            doPlayerSafeAddItem(cid, 23581, 1, true, true) -- sea shell
        end

    elseif (getCreatureStorage(cid, 8453) == QUEST_STATUS.STARTED) then -- Rebbeca ribbons
        local POSITIONS = {
            {x = 3705, y = 488, z = 7, storage = 8477},
            {x = 3719, y = 477, z = 7, storage = 8478},
        }

        local questPosition
        for k, v in pairs(POSITIONS) do
            if (getSamePosition(position, v)) then
                questPosition = v
                break
            end
        end

        if (questPosition and getCreatureStorage(cid, questPosition.storage) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, questPosition.storage, QUEST_STATUS.FINISHED)
            doPlayerSafeAddItem(cid, 23551, 1, true, true) -- yellow ribbon
        end
    end
end

PokemonAbility.afterCut = function(cid, pokemon, position) -- quest stuff
    if (getCreatureStorage(cid, 8453) == QUEST_STATUS.STARTED) then -- Rebbeca ribbons
        local POSITIONS = {
            {x = 3705, y = 482, z = 7, storage = 8479},
            {x = 3715, y = 484, z = 7, storage = 8480},
            {x = 3717, y = 479, z = 7, storage = 8481},
        }

        local questPosition
        for k, v in pairs(POSITIONS) do
            if (getSamePosition(position, v)) then
                questPosition = v
                break
            end
        end

        if (questPosition and getCreatureStorage(cid, questPosition.storage) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, questPosition.storage, QUEST_STATUS.FINISHED)
            doPlayerSafeAddItem(cid, 23551, 1, true, true) -- yellow ribbon
        end
    end
end
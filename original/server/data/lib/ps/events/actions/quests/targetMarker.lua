local ELEMENT_PROJECTILE = {
    [ELEMENT_NORMAL] = PROJECTILE_GRAVEL,
    [ELEMENT_FIGHT] = PROJECTILE_GRAVEL,
    [ELEMENT_FLYING] = PROJECTILE_WIND,
    [ELEMENT_POISON] = PROJECTILE_POISON,
    [ELEMENT_GROUND] = PROJECTILE_GRAVEL_TWO,
    [ELEMENT_ROCK] = PROJECTILE_ROCK,
    [ELEMENT_BUG] = PROJECTILE_GRAVEL,
    [ELEMENT_GHOST] = PROJECTILE_GRAVEL,
    [ELEMENT_STEEL] = PROJECTILE_METAL_BALL,
    [ELEMENT_FIRE] = PROJECTILE_FIRE,
    [ELEMENT_WATER] = PROJECTILE_BUBBLE,
    [ELEMENT_GRASS] = PROJECTILE_LEAF,
    [ELEMENT_ELECTRIC] = PROJECTILE_THUNDER,
    [ELEMENT_PSYCHIC] = PROJECTILE_ENERGY,
    [ELEMENT_ICE] = PROJECTILE_ICE,
    [ELEMENT_DRAGON] = PROJECTILE_GRAVEL,
    [ELEMENT_DARK] = PROJECTILE_ENERGY,
}
local SHOOT_TICK_INTERVAL = 100
local SUBSTITUTE_TRICK_CHANCE = 40
local SHOOT_INTERVAL = 5
local SHOOT_POSITION = {x = 4903, y = 273, z = 8}
local NPC_NAME = "Target"
local TARGET_MARKER_ITEMID = 18885
local BEFORE_TARGET_ROOM_POSITION = {x = 4903, y = 289, z = 8}
local POKEMON_MIN_DISTANCE = 4

local SUBSTITUTES = {}
local SUBSTITUTE_POSITIONS = {
    {x = 4897, y = 274, z = 8},
    {x = 4898, y = 276, z = 8},
    {x = 4900, y = 278, z = 8},
    {x = 4903, y = 278, z = 8},
    {x = 4906, y = 278, z = 8},
    {x = 4908, y = 276, z = 8},
    {x = 4909, y = 274, z = 8}
}
local LAST_SHOOT = 0

local function doActivateSubstitute(cid)
    doCreatureAddStatus(cid, CREATURE_STATUS_SUBSTITUTE)
end

local function doExchangeSubstitutes(cid, target)
    if (cid ~= target and isCreature(cid) and isCreature(target)) then
        local cidPos = getCreaturePosition(cid)
        local targetPos = getCreaturePosition(target)
        doSendDistanceShoot(cidPos, targetPos, PROJECTILE_GRAVEL)
        doTeleportThing(cid, targetPos)
        doTeleportThing(target, cidPos)
    end
end

local function doShootTick(cid, pokemon, target, targetPosition, projectile, lastPosition)
    if (not isCreature(cid) or not isCreature(pokemon) or not isCreature(target)) then
        return
    end

    local nextPosition = {x = lastPosition.x, y = lastPosition.y, z = lastPosition.z }
    nextPosition = getPositionByDirection(nextPosition, getDirectionTo(nextPosition, targetPosition), 1)

    doSendDistanceShoot(lastPosition, nextPosition, projectile)

    if (getDistanceBetween(lastPosition, targetPosition) > 0) then
        addEvent(doShootTick, SHOOT_TICK_INTERVAL, cid, pokemon, target, targetPosition, projectile, nextPosition)

        if (getRandom(1, 100) <= SUBSTITUTE_TRICK_CHANCE) then
            doActivateSubstitute(table.random(SUBSTITUTES))
            doExchangeSubstitutes(table.random(SUBSTITUTES), table.random(SUBSTITUTES))
        end

    elseif (getCreatureStatus(target, CREATURE_STATUS_SUBSTITUTE)) then
            doCreatureRemoveStatus(target, CREATURE_STATUS_SUBSTITUTE)
            doSendAnimatedText(targetPosition, "FAIL", TEXTCOLOR_WHITE)

            if (getPlayerItemCount(cid, TARGET_MARKER_ITEMID) == 0) then
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You've reached the try limit without defeating all targets!")
                doTeleportThing(cid, BEFORE_TARGET_ROOM_POSITION)
            end

    else
        doSendMagicEffect(targetPosition, EFFECT_TELEPORT_UP)
        doRemoveCreature(target)
        table.removeValue(SUBSTITUTES, target)
    end
end

local function doShoot(cid, pokemon, target, targetPosition, pokemonPosition)
    table.clear(SUBSTITUTES)
    for _, pos in pairs(SUBSTITUTE_POSITIONS) do
        SUBSTITUTES[#SUBSTITUTES + 1] = getTopCreature(pos).uid
    end

    LAST_SHOOT = os.time()
    doCreatureSay(cid, string.format(__L(cid, "%s, shoot there!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
    doShootTick(cid, pokemon, target, targetPosition, ELEMENT_PROJECTILE[getPokemonTypes(pokemon)[1]], pokemonPosition)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isCreature(itemEx.uid) or not isNpc(itemEx.uid) or getCreatureName(itemEx.uid) ~= NPC_NAME) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not isPokemonOnline(cid)) then
        doPlayerSendCancel(cid, "First release your Pokemon.")
        return true

    elseif (os.time() - LAST_SHOOT < SHOOT_INTERVAL) then
        doPlayerSendCancel(cid, "Reloading, please try again in a few seconds.")
        return true

    elseif (not getSamePosition(getCreaturePosition(cid), SHOOT_POSITION)) then
        doPlayerSendCancel(cid, "Please go to the shoot spot.")
        return true
    end

    local pokemon = getPlayerPokemon(cid)
    local pokemonPosition = getCreaturePosition(pokemon)
    if (not isSightClear(pokemonPosition, toPosition, false)) then
        doPlayerSendCancel(cid, "Your Pokemon can't shoot from there.")
        return true

    elseif (getDistanceBetween(pokemonPosition, toPosition) < POKEMON_MIN_DISTANCE) then
        doPlayerSendCancel(cid, "Your Pokemon is too close to the target.")
        return true
    end

    doRemoveItem(item.uid, 1)
    doShoot(cid, pokemon, itemEx.uid, toPosition, pokemonPosition)

    return true
end

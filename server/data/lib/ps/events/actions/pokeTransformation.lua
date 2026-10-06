-- Pokemon Transformation Outfits
local LOAD_INTERVAL = 10000
local TRANSFORMATION_OUTFITS

local doLoadPokeTransformationMachine
doLoadPokeTransformationMachine = function()
    if (getGameState() ~= GAMESTATE_NORMAL) then
        addEvent(doLoadPokeTransformationMachine, LOAD_INTERVAL)
        return
    end

    TRANSFORMATION_OUTFITS = {}
    for _, name in pairs(pokemonNamesWithoutShiny) do
        local info = getMonsterInfo(name, false)
        if (info) then
            TRANSFORMATION_OUTFITS[name] = createConditionObject(CONDITION_OUTFIT, 30 * 60 * 1000,  nil,
                CONDITION_SUBID.OUTFITS.POKEMON_TRANSFORMATION)
            addOutfitCondition(TRANSFORMATION_OUTFITS[name], {lookType = info.outfit.lookType})
        end
    end
end

addEvent(doLoadPokeTransformationMachine, LOAD_INTERVAL)

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end
    
    local pokemon = DollCase.getPokemonNameByDollItemId(itemEx.itemid)
    if (not pokemon) then
        doPlayerSendCancel(cid, "This is not a Pokemon doll.")
    elseif (getPlayerItemCount(cid, itemEx.itemid) <= 0) then
        doPlayerSendCancel(cid, "You do not have this Pokemon doll.")
    elseif (getPlayerMounted(cid)) then
        doPlayerSendCancel(cid, "You can not transform while you are under a mount.")
    elseif (isBiking(cid)) then
        doPlayerSendCancel(cid, "You can not transform while you are biking.")
    elseif (not hasPlayerDexedPokemon(cid, pokemon)) then
        doPlayerSendCancel(cid, "Your Pokedex does not have registry about this Pokemon.")
    elseif (not TRANSFORMATION_OUTFITS[pokemon]) then
        doPlayerSendCancel(cid, "Something wrong is going. I'm calling the Gamemasters, do not worry.")
        log(LOG_TYPES.ERROR, "NPC Bill::PokemonTransformation - Unknown Pokemon Name Outfit", pokemon,
            getCreatureName(cid))
    else
        doPlayerRemoveItem(cid, itemEx.itemid, 1)
        doAddCondition(cid, TRANSFORMATION_OUTFITS[pokemon])
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_RED_TELEPORT)
        doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.USE_POKE_TRANSFORMATION, 1)
    end

    return true
end

setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

function sayStory(...) return npcHandler:sayStory(...) end

local FORBIDDEN_POKEMON = {
    "Unown", "Aerodactyl", "Articuno", "Zapdos", "Moltres", "Mewtwo", "Mew",
    "Raikou", "Entei", "Suicune", "Lugia", "Ho-Oh", "Celebi", "Shiny Aerodactyl",
    "Shiny Articuno", "Shiny Zapdos", "Shiny Moltres", "Shiny Mewtwo", "Shiny Mew",
    "Shiny Raikou", "Shiny Entei", "Shiny Suicune", "Shiny Lugia", "Shiny Ho-Oh", "Shiny Celebi",
    "Regice", "Registeel", "Regirock", "Latias", "Latios", "Groudon", "Kyogre", "Rayquaza", "Jirachi", "Deoxys"
}


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local pokemonName = msg

    if (not isPokemonName(pokemonName, true) or table.find(FORBIDDEN_POKEMON, pokemonName) or isShinyName(pokemonName) or getPokemonGenerationByName(pokemonName) ~= 3) then
        selfSay("Invalid Pokemon name.", cid)
        return true
    end

    local pokemonLevel = getPlayerLevel(cid) - MAX_LEVEL_DIFF_BETWEEN_PLAYER_POKEMON
    if (pokemonLevel > POKEMON_LEVEL_MAX) then
        pokemonLevel = POKEMON_LEVEL_MAX
    elseif (pokemonLevel <= 0) then
        pokemonLevel = 1
    end
    local pokemonExtraPoints = pokemonLevel + 9

    local ball = doCreatePokemonBall(cid, "poke", pokemonName, pokemonLevel, nil, nil, pokemonExtraPoints, nil, nil, 99999999999, nil, getPokemonRandomSpecialAbility(pokemonName))
    doBallUpdateDescription(ball)
    selfSay("Here is.", cid)
    return true
end)

npcHandler:addModule(FocusModule:new())

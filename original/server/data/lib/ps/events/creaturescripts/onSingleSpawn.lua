local CUSTOM = {
    ["Rocket Grunt"] = function(cid)
        local possiblePokemon = {"Venusaur", "Charizard", "Blastoise", "Beedrill", "Raticate", "Fearow", "Arbok", "Nidoqueen",
            "Nidoking", "Crobat", "Parasect", "Venomoth", "Primeape", "Alakazam", "Machamp", "Victreebel", "Tentacruel", "Dodrio",
            "Cloyster", "Gengar", "Hypno", "Weezing", "Seaking"}

        doCreatureChangeOutfit(cid, {lookType = getRandom(533, 534), lookHead = getRandom(1, 255), lookBody = getRandom(1, 255)})

        local team = {}
        local teamSize = getRandom(4, 6)
        for i = 1, teamSize do
            team[i] = table.random(possiblePokemon)
        end

        -- random pokemon team
        -- Kanto Main 12 Rockets are level 80 (inside Mewtwo Island)
        RocketBattle.onSpawn(cid, {pokemonTeam = team, difficulty = (isInRange(getCreaturePosition(cid), {x = 5374, y = 72, z = 7}, {x = 5658, y = 326, z = 7}) and 80 or 60)})
    end,
    ["Suramoon"] = function(cid)
        local team = {"Suramoon Blastoise", "Suramoon Charizard", "Suramoon Dragonite", "Suramoon Golem", "Suramoon Gyarados", "Suramoon Venusaur"}

        -- random pokemon team
        RocketBattle.onSpawn(cid, {pokemonTeam = team, difficulty = 100})
    end
}

function onMonsterSingleSpawn(cid)
    local name = getCreatureName(cid)
    if (CUSTOM[name]) then
        CUSTOM[name](cid)
    end

    return true
end
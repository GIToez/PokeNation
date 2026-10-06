local function doPlayerAddEpicBalls(cid)
    local PKS = {
        -- Normal, Flying, Fairy, Dragon
        PK1 = { "Salamence", "Castform", "Kecleon", "Altaria", "Zangoose", "Delcatty", "Exploud", "Slaking", "Swellow", "Lickitung", "Pidgeot", "Raticate", "Fearow", "Clefable", "Wigglytuff", "Persian", "Farfetchd", "Dodrio", "Kangaskhan", "Tauros", "Aerodactyl", "Snorlax", "Furret", "Noctowl", "Togetic", "Girafarig", "Dunsparce", "Granbull", "Ursaring", "Skarmory", "Porygon2", "Stantler", "Miltank", "Blissey", "Dragonite" },
        -- Fire, Fight
        PK2 = { "Camerupt", "Torkoal", "Medicham", "Hariyama", "Blaziken", "Charizard", "Ninetales", "Primeape", "Arcanine", "Machamp", "Rapidash", "Hitmonlee", "Hitmonchan", "Magmar", "Flareon", "Typhlosion", "Heracross", "Magcargo", "Houndoom", "Hitmontop" },
        -- Water, Dark, Ice
        PK3 = {  "Walrein", "Huntail", "Gorebyss", "Relicanth", "Absol", "Glalie", "Milotic", "Whiscash", "Crawdaunt", "Sharpedo", "Wailord", "Sableye", "Ludicolo", "Swampert", "Blastoise", "Golduck", "Poliwrath", "Tentacruel", "Dewgong", "Cloyster", "Kingler", "Seaking", "Starmie", "Jynx", "Gyarados", "Lapras", "Vaporeon", "Feraligatr", "Azumarill", "Politoed", "Umbreon", "Murkrow", "Sneasel", "Octillery", "Mantine", "Kingdra" },
        -- Electric, Ghost, Psychic
        PK4 = { "Gardevoir", "Chimecho", "Banette", "Dusclops", "Grumpig", "Manectric", "Raichu", "Magneton", "Gengar", "Electrode", "Electabuzz", "Jolteon", "Ampharos", "Misdreavus", "Alakazam", "Slowbro", "Hypno", "Mr. Mime", "Xatu", "Espeon", "Slowking", "Lanturn" },
        -- Grass, Bug, Poison
        PK5 = {  "Tropius", "Seviper", "Cacturne", "Ninjask", "Shedinja", "Shiftry", "Beautifly", "Dustox", "Sceptile", "Qwilfish", "Venusaur", "Butterfree", "Beedrill", "Arbok", "Vileplume", "Parasect", "Venomoth", "Muk", "Victreebel", "Exeggutor", "Weezing", "Tangela", "Pinsir", "Meganium", "Ledian", "Ariados", "Crobat", "Bellossom", "Jumpluff", "Sunflora", "Yanma", "Forretress", "Scizor", "Shuckle" },
        -- Rock, Ground, Steel
        PK6 = { "Metagross", "Claydol", "Cradily", "Armaldo", "Lunatone", "Solrock", "Flygon", "Mawile", "Aggron", "Sandslash", "Nidoqueen", "Nidoking", "Dugtrio", "Golem", "Marowak", "Rhydon", "Sudowoodo", "Gligar", "Steelix", "Piloswine", "Donphan", "Tyranitar", "Omastar", "Kabutops", "Corsola", "Quagsire" }
    }

    local balls = {}
    local ball
    for _, pks in pairs(PKS) do
        ball = doCreatePokemonBall(cid, "epic", table.random(pks), 100, nil, nil, 100, cid, nil,
            nil, nil, nil, nil, nil, nil, nil, nil, false, nil)
        if (ball) then
            balls[#balls + 1] = ball
        else
            for _, uid in pairs(balls) do
                doRemoveItem(uid, 1)
            end
            return false
        end
    end

    doMovePlayerItem(cid, ball, {y = PLAYER_SLOT_BALL, z = 0}) -- Move one to the slot, as this the player wont lose for dont have a poke there
    return true
end

function onTournamentStart(cid, tournamentId)
    if (getTournamentInfo(tournamentId).type == TOURNAMENT_TYPES.RANDOM) then
        doPlayerAddEpicBalls(cid)
    end
	return true
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastUserTournamentId = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local TOURNAMENTS = {}
local TOURNAMENT_ID_BY_NAME = {}
local TOURNAMENT_NAME_BY_ID = {}

local ENTRANCE_COUNT = {}

local lastTournamentId = getTournamentLastId()
if (lastTournamentId > 0) then
    for i = 1, lastTournamentId do
        if (getTournamentInfo(i)) then
            TOURNAMENTS[i] = getTournamentInfo(i)
            TOURNAMENT_ID_BY_NAME[string.lower(TOURNAMENTS[i].name)] = i
            TOURNAMENT_NAME_BY_ID[i] = string.lower(TOURNAMENTS[i].name)
            TOURNAMENTS[i].date = TOURNAMENTS[i].date
        end
    end
end

local function getTournamentsMessages()
    local message, messages = "", {}
    for i, tournament in ipairs(TOURNAMENTS) do
        if (tournament.type == TOURNAMENT_TYPES.RANDOM) then
            message = "Name: {" .. tournament.name .. "} - Capacity: {" ..
                    (tournament.capacity - tournament.freeCapacity) .. "}/{" .. tournament.capacity ..
                    "} - Type: {Random Pokemon} - Min. Trainer Level: {" .. tournament.minTrainerLevel ..
                    "}  - Inscription Price: {" .. tournament.inscriptionPrice ..
                    "} dollars - Date: {" .. os.date("%a %b %d %X %Y", tournament.date) .. "} (Remaing " ..
                    table.concat(string.timediff(tournament.date - os.time())) .. ")"

        else
            message = "Name: {" .. tournament.name .. "} - Capacity: {" ..
                    (tournament.capacity - tournament.freeCapacity) .. "}/{" .. tournament.capacity ..
                    "} - Min. Pokemon Level: {" .. tournament.minLevel .. "} - Max. Pokemon Level: {" ..
                    tournament.maxLevel .. "} - Inscription Price: {" .. tournament.inscriptionPrice ..
                    "} dollars - Date: {" .. os.date("%a %b %d %X %Y", tournament.date) .. "} (Remaing " ..
                    table.concat(string.timediff(tournament.date - os.time())) .. ")"
        end
        table.insert(messages, message)
    end
    return messages
end

--
local TOKENS = {}
TOKENS.TOURNAMENT = 0
TOKENS.EPIC = 1
TOKENS.MASTERY = 2

local TOKEN_CONFIG = {}
TOKEN_CONFIG[TOKENS.TOURNAMENT] = { id = 14648, name = "Tournament Token", legend = "TT" }
TOKEN_CONFIG[TOKENS.EPIC] = { id = 24607, name = "Epic Token", legend = "ET" }
TOKEN_CONFIG[TOKENS.MASTERY] = { id = 29863, name = "Mastery Token", legend = "MT" }

local TOKEN_OPTIONS = {
    { name = "TM Mega Punch", id = 17337, tokens = 60, count = 1, tokenUse = 1, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Razor Wind", id = 17338, tokens = 60, count = 1, tokenUse = 2, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Swords Dance", id = 17339, tokens = 60, count = 1, tokenUse = 3, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Body Slam", id = 17344, tokens = 60, count = 1, tokenUse = 4, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Take Down", id = 17345, tokens = 60, count = 1, tokenUse = 5, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Toxic", id = 17342, tokens = 90, count = 1, tokenUse = 6, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Horn Drill", id = 17343, tokens = 90, count = 1, tokenUse = 7, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Blizzard", id = 17350, tokens = 120, count = 1, tokenUse = 8, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Hyper Beam", id = 17351, tokens = 90, count = 1, tokenUse = 9, token = TOKENS.TOURNAMENT, unique = true },
    { name = "TM Thunder", id = 17360, tokens = 120, count = 1, tokenUse = 10, token = TOKENS.TOURNAMENT, unique = true },
    --  {name = "TM Avalanche", id = 24723, tokens = 120, count = 1, tokenUse = 18, token = TOKENS.TOURNAMENT},
    --  {name = "TM Aerial Ace", id = 24718, tokens = 120, count = 1, tokenUse = 19, token = TOKENS.TOURNAMENT},
    { name = "catcher clothes kit", id = 18717, tokens = 150, count = 1, tokenUse = 11, token = TOKENS.TOURNAMENT },
    { name = "academy addon #1 kit", id = 25071, tokens = 100, count = 1, tokenUse = 22, token = TOKENS.TOURNAMENT },
    { name = "academy addon #2 kit", id = 25072, tokens = 100, count = 1, tokenUse = 23, token = TOKENS.TOURNAMENT },
    { name = "adventurer addon #1 kit", id = 25073, tokens = 100, count = 1, tokenUse = 24, token = TOKENS.TOURNAMENT },
    { name = "adventurer addon #2 kit", id = 25074, tokens = 100, count = 1, tokenUse = 25, token = TOKENS.TOURNAMENT },
    { name = "eevee ticket", id = 24626, tokens = 50, count = 1, tokenUse = 12, token = TOKENS.EPIC },
    { name = "espeon ticket", id = 24627, tokens = 50, count = 1, tokenUse = 13, token = TOKENS.EPIC },
    { name = "flareon ticket", id = 24628, tokens = 50, count = 1, tokenUse = 14, token = TOKENS.EPIC },
    { name = "jolteon ticket", id = 24629, tokens = 50, count = 1, tokenUse = 15, token = TOKENS.EPIC },
    { name = "umbreon ticket", id = 24630, tokens = 50, count = 1, tokenUse = 16, token = TOKENS.EPIC },
    { name = "vaporeon ticket", id = 24631, tokens = 50, count = 1, tokenUse = 17, token = TOKENS.EPIC },
    --  {name = "TM Drain Punch", id = 24721, tokens = 60, count = 1, tokenUse = 20, token = TOKENS.EPIC},
    --  {name = "TM Poison Jab", id = 24722, tokens = 60, count = 1, tokenUse = 21, token = TOKENS.EPIC},
    { name = "elite trainer addon #1 kit", id = 25075, tokens = 50, count = 1, tokenUse = 26, token = TOKENS.EPIC },
    { name = "elite trainer addon #2 kit", id = 25076, tokens = 50, count = 1, tokenUse = 27, token = TOKENS.EPIC },
    { name = "mercenary addon #1 kit", id = 25081, tokens = 50, count = 1, tokenUse = 28, token = TOKENS.EPIC },
    { name = "mercenary addon #2 kit", id = 25082, tokens = 50, count = 1, tokenUse = 29, token = TOKENS.EPIC },

    { id = 29562, tokens = 30, count = 1, tokenUse = 30, token = TOKENS.TOURNAMENT },
    { id = 29563, tokens = 30, count = 1, tokenUse = 31, token = TOKENS.TOURNAMENT },
    { id = 29587, tokens = 30, count = 1, tokenUse = 32, token = TOKENS.TOURNAMENT },
    { id = 29588, tokens = 30, count = 1, tokenUse = 33, token = TOKENS.TOURNAMENT },
    { id = 29589, tokens = 30, count = 1, tokenUse = 34, token = TOKENS.TOURNAMENT },
    { id = 29591, tokens = 30, count = 1, tokenUse = 35, token = TOKENS.TOURNAMENT },
    { id = 29592, tokens = 30, count = 1, tokenUse = 36, token = TOKENS.TOURNAMENT },
    { id = 29593, tokens = 30, count = 1, tokenUse = 37, token = TOKENS.TOURNAMENT },
    { id = 29594, tokens = 30, count = 1, tokenUse = 38, token = TOKENS.TOURNAMENT },
    { id = 29595, tokens = 30, count = 1, tokenUse = 39, token = TOKENS.TOURNAMENT },

    { id = 29561, tokens = 40, count = 1, tokenUse = 40, token = TOKENS.TOURNAMENT },
    { id = 29570, tokens = 40, count = 1, tokenUse = 41, token = TOKENS.TOURNAMENT },
    { id = 29575, tokens = 40, count = 1, tokenUse = 42, token = TOKENS.TOURNAMENT },
    { id = 29576, tokens = 40, count = 1, tokenUse = 43, token = TOKENS.TOURNAMENT },
    { id = 29577, tokens = 40, count = 1, tokenUse = 44, token = TOKENS.TOURNAMENT },
    { id = 29578, tokens = 40, count = 1, tokenUse = 45, token = TOKENS.TOURNAMENT },
    { id = 29581, tokens = 40, count = 1, tokenUse = 46, token = TOKENS.TOURNAMENT },
    { id = 29714, tokens = 40, count = 1, tokenUse = 47, token = TOKENS.TOURNAMENT },
    { id = 29627, tokens = 40, count = 1, tokenUse = 48, token = TOKENS.TOURNAMENT },
    { id = 29630, tokens = 40, count = 1, tokenUse = 49, token = TOKENS.TOURNAMENT },

    { id = 29565, tokens = 50, count = 1, tokenUse = 50, token = TOKENS.TOURNAMENT },
    { id = 29579, tokens = 50, count = 1, tokenUse = 51, token = TOKENS.TOURNAMENT },
    { id = 29597, tokens = 50, count = 1, tokenUse = 52, token = TOKENS.TOURNAMENT },
    { id = 29616, tokens = 50, count = 1, tokenUse = 53, token = TOKENS.TOURNAMENT },
    { id = 29618, tokens = 50, count = 1, tokenUse = 54, token = TOKENS.TOURNAMENT },
    { id = 29622, tokens = 50, count = 1, tokenUse = 55, token = TOKENS.TOURNAMENT },
    { id = 29628, tokens = 50, count = 1, tokenUse = 56, token = TOKENS.TOURNAMENT },
    { id = 29629, tokens = 50, count = 1, tokenUse = 57, token = TOKENS.TOURNAMENT },
    { id = 29648, tokens = 50, count = 1, tokenUse = 58, token = TOKENS.TOURNAMENT },
    { id = 29649, tokens = 50, count = 1, tokenUse = 59, token = TOKENS.TOURNAMENT },

    { id = 29567, tokens = 60, count = 1, tokenUse = 60, token = TOKENS.TOURNAMENT },
    { id = 29583, tokens = 60, count = 1, tokenUse = 61, token = TOKENS.TOURNAMENT },
    { id = 29584, tokens = 60, count = 1, tokenUse = 62, token = TOKENS.TOURNAMENT },
    { id = 29585, tokens = 60, count = 1, tokenUse = 63, token = TOKENS.TOURNAMENT },
    { id = 29586, tokens = 60, count = 1, tokenUse = 64, token = TOKENS.TOURNAMENT },
    { id = 29604, tokens = 60, count = 1, tokenUse = 65, token = TOKENS.TOURNAMENT },
    { id = 29620, tokens = 60, count = 1, tokenUse = 66, token = TOKENS.TOURNAMENT },
    { id = 29624, tokens = 60, count = 1, tokenUse = 67, token = TOKENS.TOURNAMENT },
    { id = 29655, tokens = 60, count = 1, tokenUse = 68, token = TOKENS.TOURNAMENT },
    { id = 29658, tokens = 60, count = 1, tokenUse = 69, token = TOKENS.TOURNAMENT },

    { id = 29650, tokens = 50, count = 1, tokenUse = 70, token = TOKENS.EPIC },
    { id = 29651, tokens = 50, count = 1, tokenUse = 71, token = TOKENS.EPIC },
    { id = 29654, tokens = 50, count = 1, tokenUse = 72, token = TOKENS.EPIC },
    { id = 29656, tokens = 50, count = 1, tokenUse = 73, token = TOKENS.EPIC },
    { id = 29664, tokens = 50, count = 1, tokenUse = 74, token = TOKENS.EPIC },
    { id = 29665, tokens = 50, count = 1, tokenUse = 75, token = TOKENS.EPIC },
    { id = 29669, tokens = 50, count = 1, tokenUse = 76, token = TOKENS.EPIC },
    { id = 29670, tokens = 50, count = 1, tokenUse = 77, token = TOKENS.EPIC },
    { id = 29684, tokens = 50, count = 1, tokenUse = 78, token = TOKENS.EPIC },
    { id = 29685, tokens = 50, count = 1, tokenUse = 79, token = TOKENS.EPIC },

    { id = 29660, tokens = 60, count = 1, tokenUse = 80, token = TOKENS.EPIC },
    { id = 29662, tokens = 60, count = 1, tokenUse = 81, token = TOKENS.EPIC },
    { id = 29666, tokens = 60, count = 1, tokenUse = 82, token = TOKENS.EPIC },
    { id = 29719, tokens = 60, count = 1, tokenUse = 83, token = TOKENS.EPIC },
    { id = 29734, tokens = 60, count = 1, tokenUse = 84, token = TOKENS.EPIC },
    { id = 29743, tokens = 60, count = 1, tokenUse = 85, token = TOKENS.EPIC },
    { id = 29748, tokens = 60, count = 1, tokenUse = 86, token = TOKENS.EPIC },
    { id = 29750, tokens = 60, count = 1, tokenUse = 87, token = TOKENS.EPIC },
    { id = 29783, tokens = 60, count = 1, tokenUse = 88, token = TOKENS.EPIC },
    { id = 29784, tokens = 60, count = 1, tokenUse = 89, token = TOKENS.EPIC },

    { id = 29864, tokens = 60, count = 1, tokenUse = 90, token = TOKENS.MASTERY },
    { id = 29865, tokens = 60, count = 1, tokenUse = 91, token = TOKENS.MASTERY },
    { id = 29866, tokens = 60, count = 1, tokenUse = 92, token = TOKENS.MASTERY },
    { id = 29867, tokens = 60, count = 1, tokenUse = 93, token = TOKENS.MASTERY },
    { id = 29868, tokens = 60, count = 1, tokenUse = 94, token = TOKENS.MASTERY },
    { id = 29869, tokens = 60, count = 1, tokenUse = 95, token = TOKENS.MASTERY },
    { id = 29870, tokens = 60, count = 1, tokenUse = 96, token = TOKENS.MASTERY },
    { id = 29871, tokens = 60, count = 1, tokenUse = 97, token = TOKENS.MASTERY },
    { id = 29872, tokens = 60, count = 1, tokenUse = 98, token = TOKENS.MASTERY },
}

local TOKEN_OPTION_BY_NAME = {}
for k, v in pairs(TOKEN_OPTIONS) do
    if (not v.name) then
        v.name = getItemNameById(v.id)
    end

    TOKEN_OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 14648

local lastTokenOption = {}

local function getTokenOptionsMessage()
    local message = {}
    for i, option in ipairs(TOKEN_OPTIONS) do
        message[#message + 1] = i
        message[#message + 1] = "# "
        message[#message + 1] = option.name
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x]["
        message[#message + 1] = option.tokens
        message[#message + 1] = "x "
        message[#message + 1] = TOKEN_CONFIG[option.token].legend
        message[#message + 1] = "]\n"
    end
    for k, v in pairs(TOKEN_CONFIG) do
        message[#message + 1] = "\n"
        message[#message + 1] = v.legend
        message[#message + 1] = " = "
        message[#message + 1] = v.name
    end
    return table.concat(message)
end

local tokenOptionsMessage = getTokenOptionsMessage()
getTokenOptionsMessage = nil

local function doPlayerBallsAddUnique(cid, balls)
    for _, ball in pairs(balls) do
        if (not isItemUnique(ball.uid)) then
            setItemUniqueOwner(ball.uid, cid)
            setBallUniqueFromTournament(ball.uid, true)
        end
    end
end

local function checkPlayerTokens(cid)
    local backpack = getPlayerSlotItem(cid, PLAYER_SLOT_BACKPACK)
    if (isItem(backpack)) then
        local items = getContainerItems(backpack.uid, true)
        local guid = getPlayerGUID(cid)
        for _, item in pairs(items) do
            if (item.itemid == TOKEN_ID and getItemUniqueOwner(item.uid) ~= guid) then
                log(LOG_TYPES.WARNING, "tournament:checkPlayerTokens - Player carrying tokens from another player! Bug abuse!",
                    getCreatureName(cid), getItemUniqueOwner(item.uid), item)
            end
        end
    end
end

local function doPlayerAddEpicBallsTest(cid)
    local PKS = {
        -- Normal, Flying, Fairy, Dragon
        PK1 = { "Salamence", "Castform", "Kecleon", "Altaria", "Zangoose", "Delcatty", "Exploud", "Slaking", "Swellow", "Lickitung", "Pidgeot", "Raticate", "Fearow", "Clefable", "Wigglytuff", "Persian", "Farfetchd", "Dodrio", "Kangaskhan", "Tauros", "Aerodactyl", "Snorlax", "Furret", "Noctowl", "Togetic", "Girafarig", "Dunsparce", "Granbull", "Ursaring", "Skarmory", "Porygon2", "Stantler", "Miltank", "Blissey", "Dragonite" },
        -- Fire, Fight
        PK2 = { "Camerupt", "Torkoal", "Medicham", "Hariyama", "Blaziken", "Charizard", "Ninetales", "Primeape", "Arcanine", "Machamp", "Rapidash", "Hitmonlee", "Hitmonchan", "Magmar", "Flareon", "Typhlosion", "Heracross", "Magcargo", "Houndoom", "Hitmontop" },
        -- Water, Dark, Ice
        PK3 = { "Walrein", "Huntail", "Gorebyss", "Relicanth", "Absol", "Glalie", "Milotic", "Whiscash", "Crawdaunt", "Sharpedo", "Wailord", "Sableye", "Lombre", "Swampert", "Blastoise", "Golduck", "Poliwrath", "Tentacruel", "Dewgong", "Cloyster", "Kingler", "Seaking", "Starmie", "Jynx", "Gyarados", "Lapras", "Vaporeon", "Feraligatr", "Azumarill", "Politoed", "Umbreon", "Murkrow", "Sneasel", "Octillery", "Mantine", "Kingdra" },
        -- Electric, Ghost, Psychic
        PK4 = { "Chimecho", "Banette", "Dusclops", "Grumpig", "Manectric", "Raichu", "Magneton", "Gengar", "Electrode", "Electabuzz", "Jolteon", "Ampharos", "Misdreavus", "Alakazam", "Slowbro", "Hypno", "Mr. Mime", "Xatu", "Espeon", "Slowking", "Lanturn" },
        -- Grass, Bug, Poison
        PK5 = { "Tropius", "Seviper", "Cacturne", "Ninjask", "Shedinja", "Shiftry", "Beautifly", "Dustox", "Sceptile", "Qwilfish", "Venusaur", "Butterfree", "Beedrill", "Arbok", "Vileplume", "Parasect", "Venomoth", "Muk", "Victreebel", "Exeggutor", "Weezing", "Tangela", "Pinsir", "Meganium", "Ledian", "Ariados", "Crobat", "Bellossom", "Jumpluff", "Sunflora", "Yanma", "Forretress", "Scizor", "Shuckle" },
        -- Rock, Ground, Steel
        PK6 = { "Metagross", "Claydol", "Cradily", "Armaldo", "Lunatone", "Solrock", "Flygon", "Mawile", "Aggron", "Sandslash", "Nidoqueen", "Nidoking", "Dugtrio", "Golem", "Marowak", "Rhydon", "Sudowoodo", "Gligar", "Steelix", "Piloswine", "Donphan", "Tyranitar", "Omastar", "Kabutops", "Corsola", "Quagsire" }
    }

    local balls = {}
    for _, pks in pairs(PKS) do
        local ball = doCreatePokemonBall(cid, "epic", table.random(pks), 100, nil, nil, 100, cid, nil,
            nil, nil, nil, nil, nil, nil, nil, nil, false, nil, nil, true)
        if (ball) then
            balls[#balls + 1] = ball
        else
            for _, uid in pairs(balls) do
                doRemoveItem(uid, 1)
            end
            return false
        end
    end

    for k, v in pairs(balls) do
        doRemoveItem(v, 1)
    end

    return true
end

local FORBIDDEN_POKEMON = {
    "darkchu", "bulmander", "chartle", "squirsaur"
}
--

local TALKSTATE_NONE = 0
local TALKSTATE_JOIN = 1
local TALKSTATE_JOIN_CONFIRM = 2
local TALKSTATE_LEAVE = 3
local TALKSTATE_EXCHANGING = 4

function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'tournaments') or msgcontains(msg, 'list') or msgcontains(msg, 'torneio')) then
        for i, message in ipairs(getTournamentsMessages()) do
            selfSay(message, cid)
        end

        selfSay("Here you can also exchange tournament tokens into especial items, you can see the {options}.", cid)

    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'exchange') or msgcontains(msg, 'opcoes') or msgcontains(msg, 'trocar')) then
        doPlayerPopupFYI(cid, tokenOptionsMessage)
        selfSay("Here is! {NOTE: Every item that you buy here will be unique, this means that only you can use!}", cid)

    elseif (TOKEN_OPTION_BY_NAME[string.lower(msg)]) then
        msg = string.lower(msg)
        lastTokenOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s tournament token%s for a %s?"), TOKEN_OPTION_BY_NAME[msg].tokens, (TOKEN_OPTION_BY_NAME[msg].tokens > 1 and "s" or ""), msg), cid)

    elseif (TOKEN_OPTIONS[tonumber(msg)]) then
        msg = string.lower(TOKEN_OPTIONS[tonumber(msg)].name)
        lastTokenOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s tournament token%s for a %s?"), TOKEN_OPTION_BY_NAME[msg].tokens, (TOKEN_OPTION_BY_NAME[msg].tokens > 1 and "s" or ""), msg), cid)

    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and lastTokenOption[talkUser]) then
        local opt = TOKEN_OPTION_BY_NAME[lastTokenOption[talkUser]]
        checkPlayerTokens(cid)
        if (getPlayerItemCountByUnique(cid, TOKEN_CONFIG[opt.token].id) >= opt.tokens and doPlayerRemoveItemByUnique(cid, TOKEN_CONFIG[opt.token].id, opt.tokens)) then
            doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
            selfSay("Great choice, take it!", cid)
            doDatalogTokenBought(os.time(), getPlayerGUID(cid), opt.tokenUse, opt.tokens)
        else
            selfSay("You do not have enough tournament tokens for it.", cid)
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (msgcontains(msg, 'join') or msgcontains(msg, 'inscribe') or msgcontains(msg, 'inscription') or msgcontains(msg, 'inscricao') or msgcontains(msg, 'inscrever')) then
        selfSay("In which tournament you want to sign up? (You can see the options saying {tournaments})",
            cid)
        talkState[talkUser] = TALKSTATE_JOIN

    elseif (msgcontains(msg, 'leave') or msgcontains(msg, 'quit') or msgcontains(msg, 'unsubscribe') or msgcontains(msg, 'sair')) then
        if (getPlayerTournamentInscribed(cid)) then
            selfSay("You really want to unsubscribe to the tournament?", cid)
            talkState[talkUser] = TALKSTATE_LEAVE

        else
            selfSay("You are not subscribed to any tournament!", cid)
            talkState[talkUser] = TALKSTATE_NONE
        end

    elseif (msgcontains(msg, 'enter') or msgcontains(msg, 'entrar')) then
        if (not getPlayerTournamentInscribed(cid)) then
            selfSay("You are not subscribed to any tournament.", cid)

        elseif (getTournamentInfo(getPlayerTournamentId(cid)).started) then
            selfSay("This tournament already started!", cid)

        else
            if (getPlayerMounted(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)
                return true
            end

            local tournamentId = getPlayerTournamentId(cid)
            local balls = getPlayerAllBallsWithPokemon(cid)

            if (TOURNAMENTS[tournamentId].type == TOURNAMENT_TYPES.RANDOM) then
                if (ENTRANCE_COUNT[getPlayerGUID(cid)] and ENTRANCE_COUNT[getPlayerGUID(cid)][tournamentId]) then
                    selfSay("You already entered this tournament room today! You cannot enter again, please try tomorrow.", cid)
                    return true
                end

                if (#balls > 0) then
                    selfSay("You cannot enter in the tournament room while you are carrying Pokemon!", cid)
                    return true
                end

                if (not doPlayerAddEpicBallsTest(cid)) then
                    selfSay("Please check your backpack for free space!", cid)
                    return true
                end

            else
                if (#balls < PLAYER_BALL_MAX) then
                    selfSay(string.format(__L(cid, "You need at least %s Pokemon to enter in the tournament!"), PLAYER_BALL_MAX), cid)
                    return true
                end

                local names = {}
                for i, ball in pairs(balls) do
                    local pokemonName = getBallPokemonName(ball.uid)

                    local prior = getPokemonPriorEvolution(pokemonName)
                    if (prior) then
                        for _, evolution in pairs(getPokemonEvolutions(prior)) do
                            if (evolution.name == pokemonName) then
                                if (evolution.requiredLevel > getBallPokemonLevel(ball.uid)) then
                                    selfSay(string.format(__L(cid, "Your team can not have Pokemon early evolved! (%s)"), pokemonName), cid)
                                    return true
                                end
                                break
                            end
                        end
                    end

                    pokemonName = string.lower(pokemonName)
                    pokemonName = pokemonName:gsub("shiny ", "")

                    if (table.find(FORBIDDEN_POKEMON, pokemonName)) then
                        selfSay("Your team has banned Pokemon!", cid)
                        return true
                    end

                    if (isInArray(names, pokemonName)) then
                        selfSay("Your team can not have two Pokemon alike!", cid)
                        return true
                    else
                        table.insert(names, pokemonName)
                    end
                end

                for i, ball in ipairs(balls) do
                    local pokemonLevel = getBallPokemonLevel(ball.uid)
                    if (pokemonLevel < TOURNAMENTS[tournamentId].minLevel) then
                        selfSay(string.format(__L(cid, "You have Pokemon with low level for this tournament, the minimum is level %s."), TOURNAMENTS[tournamentId].minLevel), cid)
                        return true

                    elseif (pokemonLevel > TOURNAMENTS[tournamentId].maxLevel) then
                        selfSay(string.format(__L(cid, "You have Pokemon with high level for this tournament, the maximum is level %s."), TOURNAMENTS[tournamentId].maxLevel), cid)
                        return true

                    elseif (TOURNAMENTS[tournamentId].type == TOURNAMENT_TYPES.MASTERY and not table.findAsTable(getPokemonTypes(nil, getBallPokemonName(ball.uid)), getMasteryElements(getPlayerMastery(cid)))) then
                        selfSay("You can only take Pokemon that makes the type of your Mastery!", cid)
                        return true
                    end
                end
            end

            if (doTeleportThing(cid, { x = 4721, y = 100, z = 7 })) then
                if (ENTRANCE_COUNT[getPlayerGUID(cid)]) then
                    ENTRANCE_COUNT[getPlayerGUID(cid)][tournamentId] = true
                else
                    ENTRANCE_COUNT[getPlayerGUID(cid)] = { [tournamentId] = true }
                end

                doPlayerBallsAddUnique(cid, balls)
                if (TOURNAMENTS[tournamentId].type == TOURNAMENT_TYPES.RANDOM) then
                    selfSay("WARNING: Remember that you will receive your Pokemon 1 minute before the tournament starts! Good luck!", cid)
                else
                    selfSay("WARNING: Do not forget to put a full poke ball in the ball slot! Do NOT call your Pokemon, he will be called automatically when the battle starts! Good luck!", cid)
                end
                doCreatureSay(cid, __L(cid, "hi"), TALKTYPE_SAY) -- Auto heal
                setPlayerTournamentReady(cid, true)
                setPlayerDisconnectAtExit(cid, false)
            else
                -- todo remove epic balls if needed
            end
        end

    elseif (talkState[talkUser] == TALKSTATE_JOIN) then
        if (TOURNAMENT_ID_BY_NAME[msg]) then
            msg = string.lower(msg)
            lastUserTournamentId[talkUser] = TOURNAMENT_ID_BY_NAME[msg]
            selfSay(string.format(__L(cid, "You really want to join the %s tournament? (This will cost you %s dollars)"), msg, TOURNAMENTS[lastUserTournamentId[talkUser]].inscriptionPrice), cid)
            talkState[talkUser] = TALKSTATE_JOIN_CONFIRM

        else
            selfSay("Sorry, there is no tournament with this name. Please enter the correct name.", cid)
        end

    elseif (talkState[talkUser] == TALKSTATE_JOIN_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            if ((getPlayerLevel(cid) - 5 < TOURNAMENTS[lastUserTournamentId[talkUser]].minLevel) or (getPlayerLevel(cid) < TOURNAMENTS[lastUserTournamentId[talkUser]].minTrainerLevel)) then
                selfSay("Sorry, you do not have the minimum level to participate this tournament.", cid)

            elseif (getPlayerTournamentInscribed(cid)) then
                selfSay("You are already inscribed in a tournament, you can only inscribe in one tournament at a time. If you want to change the tournament, first {leave} your subscription.", cid)

            elseif (getPlayerMoney(cid) < TOURNAMENTS[lastUserTournamentId[talkUser]].inscriptionPrice) then
                selfSay("You do not have enough money to join!", cid)

            elseif (TOURNAMENTS[lastUserTournamentId[talkUser]].type == TOURNAMENT_TYPES.MASTERY and not getPlayerMastery(cid)) then
                selfSay("Only Mastery members players can join this tournament!", cid)

            elseif (doTournamentJoin(cid, lastUserTournamentId[talkUser])) then
                doPlayerRemoveMoney(cid, TOURNAMENTS[lastUserTournamentId[talkUser]].inscriptionPrice)
                selfSay("It is done! You are subscribed, so stay tuned to the date of the tournament! Do not miss it.", cid)
                TOURNAMENTS[lastUserTournamentId[talkUser]].freeCapacity = TOURNAMENTS[lastUserTournamentId[talkUser]].freeCapacity - 1

            else
                selfSay("Sorry, you can't join this tournament.", cid)
            end

            talkState[talkUser] = TALKSTATE_NONE

        else
            selfSay("Ok...", cid)
            talkState[talkUser] = TALKSTATE_NONE
        end

    elseif (talkState[talkUser] == TALKSTATE_LEAVE) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            if (doTournamentLeave(cid, getPlayerTournamentId(cid))) then
                selfSay("Done, your inscription has been canceled!", cid)
                TOURNAMENTS[lastUserTournamentId[talkUser]].freeCapacity = TOURNAMENTS[lastUserTournamentId[talkUser]].freeCapacity + 1
            else
                selfSay("You can not leave the tournament now! Try again later.", cid)
            end

            talkState[talkUser] = TALKSTATE_NONE
        else
            selfSay("Ok...", cid)
        end

        talkState[talkUser] = TALKSTATE_NONE

    else
        selfSay("Sorry?", cid)
        talkState[talkUser] = TALKSTATE_NONE
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

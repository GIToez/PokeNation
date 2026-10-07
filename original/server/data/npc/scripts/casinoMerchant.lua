setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

--[[
[Print][Fri Jan 02 20:30:54 2015]: RESULT ON 1000000 ROLLS: 119527

[Print][Fri Jan 02 20:30:54 2015]: MONEY SPENT: 100000000

[Print][Fri Jan 02 20:30:57 2015]: RESULT ON 1000000 ROLLS: 117144

[Print][Fri Jan 02 20:30:57 2015]: MONEY SPENT: 100000000

[Print][Fri Jan 02 20:31:00 2015]: RESULT ON 1000000 ROLLS: 119049

[Print][Fri Jan 02 20:31:00 2015]: MONEY SPENT: 100000000

[Print][Fri Jan 02 20:31:02 2015]: RESULT ON 1000000 ROLLS: 120528

[Print][Fri Jan 02 20:31:02 2015]: MONEY SPENT: 100000000

[Print][Fri Jan 02 20:31:05 2015]: RESULT ON 1000000 ROLLS: 121620

[Print][Fri Jan 02 20:31:05 2015]: MONEY SPENT: 100000000

[Print][Fri Jan 02 20:31:07 2015]: RESULT ON 1000000 ROLLS: 117973

[Print][Fri Jan 02 20:31:07 2015]: MONEY SPENT: 100000000

[Print][Fri Jan 02 20:31:10 2015]: RESULT ON 1000000 ROLLS: 120027

[Print][Fri Jan 02 20:31:10 2015]: MONEY SPENT: 100000000

0,00120027 per dollar
833,14 dollars
]]

local OPTIONS = {
    { name = "calcium vitamin", id = 23450, tokens = 10, count = 1 },
    { name = "carbos vitamin", id = 23451, tokens = 10, count = 1 },
    { name = "hp up vitamin", id = 23452, tokens = 10, count = 1 },
    { name = "iron vitamin", id = 23453, tokens = 10, count = 1 },
    { name = "pp max vitamin", id = 23454, tokens = 50, count = 1 },
    { name = "pp up vitamin", id = 23455, tokens = 10, count = 1 },
    { name = "protein vitamin", id = 23456, tokens = 10, count = 1 },
    { name = "zinc vitamin", id = 23457, tokens = 10, count = 1 },

    { name = "bug container", id = 19009, tokens = 5, count = 1 },
    { name = "dark container", id = 19010, tokens = 5, count = 1 },
    { name = "dragon container", id = 19011, tokens = 5, count = 1 },
    { name = "electric container", id = 19012, tokens = 5, count = 1 },
    { name = "fairy container", id = 19013, tokens = 5, count = 1 },
    { name = "fighting container", id = 19014, tokens = 5, count = 1 },
    { name = "fire container", id = 19015, tokens = 5, count = 1 },
    { name = "flying container", id = 19016, tokens = 5, count = 1 },
    { name = "ghost container", id = 19017, tokens = 5, count = 1 },
    { name = "grass container", id = 19018, tokens = 5, count = 1 },
    { name = "ground container", id = 19019, tokens = 5, count = 1 },
    { name = "ice container", id = 19020, tokens = 5, count = 1 },
    { name = "normal container", id = 19021, tokens = 5, count = 1 },
    { name = "poison container", id = 19022, tokens = 5, count = 1 },
    { name = "psychic container", id = 19023, tokens = 5, count = 1 },
    { name = "rock container", id = 19024, tokens = 5, count = 1 },
    { name = "steel container", id = 19025, tokens = 5, count = 1 },
    { name = "water container", id = 19026, tokens = 5, count = 1 },
    { name = "jynx bag", id = 23464, tokens = 5, count = 1 },
    { name = "golduck bag", id = 23465, tokens = 5, count = 1 },
    { name = "aerodactyl bag", id = 23466, tokens = 5, count = 1 },
    { name = "eevee bag", id = 23467, tokens = 5, count = 1 },
    { name = "sneasel bag", id = 23468, tokens = 5, count = 1 },
    { name = "mr. mime bag", id = 23469, tokens = 5, count = 1 },
    { name = "flareon bag", id = 23470, tokens = 5, count = 1 },
    { name = "jolteon bag", id = 23471, tokens = 5, count = 1 },
    { name = "vaporeon bag", id = 23472, tokens = 5, count = 1 },
    { name = "wartortle bag", id = 23473, tokens = 5, count = 1 },
    { name = "sandslash bag", id = 23474, tokens = 5, count = 1 },
    { name = "umbreon bag", id = 23475, tokens = 5, count = 1 },
    { name = "espeon bag", id = 23476, tokens = 5, count = 1 },
    { name = "scizor bag", id = 23477, tokens = 5, count = 1 },
    { name = "chikorita bag", id = 23478, tokens = 5, count = 1 },
    { name = "mew bag", id = 23479, tokens = 50, count = 1 },
    { name = "mewtwo bag", id = 23480, tokens = 50, count = 1 },
    { name = "arbok bag", id = 23481, tokens = 5, count = 1 },
    { name = "charizard bag", id = 23482, tokens = 5, count = 1 },
    { name = "pikachu bag", id = 23483, tokens = 5, count = 1 },
    { name = "snorlax bag", id = 23484, tokens = 5, count = 1 },
    { name = "scyther bag", id = 23485, tokens = 5, count = 1 },
    { name = "victreebel bag", id = 23486, tokens = 5, count = 1 },
    { name = "pidgeot bag", id = 23487, tokens = 5, count = 1 },
    { name = "machamp bag", id = 23488, tokens = 5, count = 1 },
    { name = "haunter bag", id = 23489, tokens = 5, count = 1 },
    { name = "marowak bag", id = 23490, tokens = 5, count = 1 },
    { name = "dragonite bag", id = 23491, tokens = 5, count = 1 },
    { name = "red bag", id = 23492, tokens = 5, count = 1 },
    { name = "white bag", id = 23493, tokens = 5, count = 1 },
    { name = "yellow bag", id = 23494, tokens = 5, count = 1 },
    { name = "green bag", id = 23495, tokens = 5, count = 1 },
    { name = "blue bag", id = 23496, tokens = 5, count = 1 },

    { name = "TM Flamethrower", id = 24719, tokens = 50, count = 1 },
    { name = "TM Water Pulse", id = 24716, tokens = 50, count = 1 },
    { name = "rapper addon #1 kit", id = 25083, tokens = 50, count = 1 },
    { name = "rapper addon #2 kit", id = 25084, tokens = 50, count = 1 },

    { name = "TM Avalanche", id = 24723, tokens = 120, count = 1 },
    { name = "TM Aerial Ace", id = 24718, tokens = 120, count = 1 },

    { id = 29596, tokens = 5, count = 1 },
    { id = 29598, tokens = 5, count = 1 },
    { id = 29600, tokens = 5, count = 1 },
    { id = 29601, tokens = 5, count = 1 },
    { id = 29602, tokens = 5, count = 1 },

    { id = 29639, tokens = 15, count = 1 },
    { id = 29676, tokens = 15, count = 1 },
    { id = 29682, tokens = 15, count = 1 },
    { id = 29693, tokens = 15, count = 1 },
    { id = 29694, tokens = 15, count = 1 },

    { id = 29686, tokens = 50, count = 1 },
    { id = 29687, tokens = 50, count = 1 },
    { id = 29695, tokens = 50, count = 1 },
    { id = 29700, tokens = 50, count = 1 },
    { id = 29704, tokens = 50, count = 1 },
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    if (not v.name) then
        v.name = getItemNameById(v.id)
    end

    OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 23497 -- poke coin

local lastOption = {}

local TALKSTATE_NONE = 0
local TALKSTATE_EXCHANGING = 10

local function getOptionsMessage()
    local message = {}
    for i, option in ipairs(OPTIONS) do
        message[#message + 1] = i
        message[#message + 1] = "# "
        message[#message + 1] = option.name
        if (option.description) then
            message[#message + 1] = " ("
            message[#message + 1] = option.description
            message[#message + 1] = ")"
        end
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x]["
        message[#message + 1] = option.tokens
        message[#message + 1] = "x PC]\n"
    end
    message[#message + 1] = "\nPC = Poke Coins"
    return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

--
function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (OPTION_BY_NAME[msg]) then
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s poke coins for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

    elseif (OPTIONS[tonumber(msg)]) then
        msg = string.lower(OPTIONS[tonumber(msg)].name)
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s poke coins for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'poke coin') or msgcontains(msg, 'opcoes')) then
        doPlayerPopupFYI(cid, optionsMessage)

    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
            lastOption[talkUser]) then
        local opt = OPTION_BY_NAME[lastOption[talkUser]]

        if (opt.canBuy and not opt.canBuy(cid)) then
            selfSay(opt.onBuyError, cid)

        elseif (getPlayerItemCountByUnique(cid, TOKEN_ID) >= opt.tokens and
                doPlayerRemoveItemByUnique(cid, TOKEN_ID, opt.tokens)) then
            if (opt.id) then
                doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
            end
            selfSay("Here is, thanks!", cid)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end

            doDatalogCasinoTokenBought(os.time(), getPlayerGUID(cid), opt.id, opt.count, opt.tokens)

        else
            selfSay("You do not have enough poke coins for it.", cid)
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Sure.", cid)
        talkState[talkUser] = TALKSTATE_NONE

    else
        selfSay("Welcome to our Casino! If you have got some {poke coins} I can exchange it for you.", cid)
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

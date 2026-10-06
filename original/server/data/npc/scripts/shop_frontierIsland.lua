setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local OPTIONS = {
    { name = "bug container", id = 19009, tokens = 20, count = 1 },
    { name = "dark container", id = 19010, tokens = 20, count = 1 },
    { name = "dragon container", id = 19011, tokens = 20, count = 1 },
    { name = "electric container", id = 19012, tokens = 20, count = 1 },
    { name = "fairy container", id = 19013, tokens = 20, count = 1 },
    { name = "fighting container", id = 19014, tokens = 20, count = 1 },
    { name = "fire container", id = 19015, tokens = 20, count = 1 },
    { name = "flying container", id = 19016, tokens = 20, count = 1 },
    { name = "ghost container", id = 19017, tokens = 20, count = 1 },
    { name = "grass container", id = 19018, tokens = 20, count = 1 },
    { name = "ground container", id = 19019, tokens = 20, count = 1 },
    { name = "ice container", id = 19020, tokens = 20, count = 1 },
    { name = "normal container", id = 19021, tokens = 20, count = 1 },
    { name = "poison container", id = 19022, tokens = 20, count = 1 },
    { name = "psychic container", id = 19023, tokens = 20, count = 1 },
    { name = "rock container", id = 19024, tokens = 20, count = 1 },
    { name = "steel container", id = 19025, tokens = 20, count = 1 },
    { name = "water container", id = 19026, tokens = 20, count = 1 },
    {
        name = "champion outfit",
        tokens = 200,
        count = 1,
        canBuy = function(cid) return not canPlayerWearOutfitId(cid, 48, 0) end,
        onBuyError = "You already have got this outfit!",
        onBuy = function(cid)
            doPlayerAddOutfitId(cid, 48, 0)
            doPlayerSendOutfitWindow(cid)
        end
    },
    { name = "jynx bag", id = 23464, tokens = 20, count = 1 },
    { name = "golduck bag", id = 23465, tokens = 20, count = 1 },
    { name = "aerodactyl bag", id = 23466, tokens = 20, count = 1 },
    { name = "eevee bag", id = 23467, tokens = 20, count = 1 },
    { name = "sneasel bag", id = 23468, tokens = 20, count = 1 },
    { name = "mr. mime bag", id = 23469, tokens = 20, count = 1 },
    { name = "flareon bag", id = 23470, tokens = 20, count = 1 },
    { name = "jolteon bag", id = 23471, tokens = 20, count = 1 },
    { name = "vaporeon bag", id = 23472, tokens = 20, count = 1 },
    { name = "wartortle bag", id = 23473, tokens = 20, count = 1 },
    { name = "sandslash bag", id = 23474, tokens = 20, count = 1 },
    { name = "umbreon bag", id = 23475, tokens = 20, count = 1 },
    { name = "espeon bag", id = 23476, tokens = 20, count = 1 },
    { name = "scizor bag", id = 23477, tokens = 20, count = 1 },
    { name = "chikorita bag", id = 23478, tokens = 20, count = 1 },
    { name = "mew bag", id = 23479, tokens = 150, count = 1 },
    { name = "mewtwo bag", id = 23480, tokens = 150, count = 1 },
    { name = "arbok bag", id = 23481, tokens = 20, count = 1 },
    { name = "charizard bag", id = 23482, tokens = 20, count = 1 },
    { name = "pikachu bag", id = 23483, tokens = 20, count = 1 },
    { name = "snorlax bag", id = 23484, tokens = 20, count = 1 },
    { name = "scyther bag", id = 23485, tokens = 20, count = 1 },
    { name = "victreebel bag", id = 23486, tokens = 20, count = 1 },
    { name = "pidgeot bag", id = 23487, tokens = 20, count = 1 },
    { name = "machamp bag", id = 23488, tokens = 20, count = 1 },
    { name = "haunter bag", id = 23489, tokens = 20, count = 1 },
    { name = "marowak bag", id = 23490, tokens = 20, count = 1 },
    { name = "dragonite bag", id = 23491, tokens = 20, count = 1 },
    { name = "red bag", id = 23492, tokens = 20, count = 1 },
    { name = "white bag", id = 23493, tokens = 20, count = 1 },
    { name = "yellow bag", id = 23494, tokens = 20, count = 1 },
    { name = "green bag", id = 23495, tokens = 20, count = 1 },
    { name = "blue bag", id = 23496, tokens = 20, count = 1 },
    { name = "TM Rock Tomb", id = 24717, tokens = 100, count = 1 },
    { name = "TM Energy Ball", id = 24720, tokens = 100, count = 1 },
    { name = "hiker addon #1 kit", id = 25077, tokens = 50, count = 1 },
    { name = "hiker addon #2 kit", id = 25078, tokens = 50, count = 1 },
    { name = "jamaica addon #1 kit", id = 25079, tokens = 50, count = 1 },
    { name = "jamaica addon #2 kit", id = 25080, tokens = 50, count = 1 },

    { name = "TM Drain Punch", id = 24721, tokens = 60, count = 1 },
    { name = "TM Poison Jab", id = 24722, tokens = 60, count = 1 },

    { id = 29696, tokens = 30, count = 1 },
    { id = 29697, tokens = 30, count = 1 },
    { id = 29702, tokens = 30, count = 1 },
    { id = 29706, tokens = 30, count = 1 },
    { id = 29711, tokens = 30, count = 1 },

    { id = 29707, tokens = 60, count = 1 },
    { id = 29708, tokens = 60, count = 1 },
    { id = 29709, tokens = 60, count = 1 },
    { id = 29724, tokens = 60, count = 1 },
    { id = 29723, tokens = 60, count = 1 },

    { id = 29786, tokens = 100, count = 1 },
    { id = 29788, tokens = 100, count = 1 },
    { id = 29789, tokens = 100, count = 1 },
    { id = 29792, tokens = 100, count = 1 },
    { id = 29793, tokens = 100, count = 1 },
}

--[[
2820

round - amount

coop elite
6 - 1
12 - 2
18 - 3
24 - 4
30 - 5
36 - 6
TOTAL 21

coop titan
6 - 1
12 - 2
18 - 3
24 - 4
30 - 5
36 - 6
TOTAL 21

gladiator igual
--]]

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    if (not v.name) then
        v.name = getItemNameById(v.id)
    end

    OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 18128

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
        message[#message + 1] = "x FT]\n"
    end
    message[#message + 1] = "\nFT = Frontier Tokens"
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
        selfSay(string.format(__L(cid, "You want to exchange %s frontier tokens for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

    elseif (OPTIONS[tonumber(msg)]) then
        msg = string.lower(OPTIONS[tonumber(msg)].name)
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s frontier tokens for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
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

        else
            selfSay("You do not have enough frontier tokens for it.", cid)
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Sure.", cid)
        talkState[talkUser] = TALKSTATE_NONE

    else
        selfSay("Welcome to the Frontier Island! I'm here to exhcange your {frontier tokens} into {rewards}! Just type {options} to see.", cid)
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

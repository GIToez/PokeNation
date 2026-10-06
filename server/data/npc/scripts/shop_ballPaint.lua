setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local PAINT_OPTIONS = {
    { name = "blue", ticket = 0, category = "default" },
    { name = "red", ticket = 0, category = "default" },
    { name = "yellow", ticket = 0, category = "default" },
    { name = "dark purple", ticket = 0, category = "default" },
    { name = "azure", ticket = 0, category = "default" },
    { name = "brown", ticket = 0, category = "default" },
    { name = "gold", ticket = 0, category = "default" },
    { name = "green", ticket = 0, category = "default" },
    { name = "pink", ticket = 0, category = "default" },
    { name = "lilac", ticket = 0, category = "default" },
    { name = "silver", ticket = 0, category = "default" },
    { name = "sandwisp", ticket = 0, category = "default" },

    { name = "star", ticket = 14449, category = "events" },
    { name = "yereblu", ticket = 14450, category = "events" },

    { name = "pumpkin", ticket = 14459, category = "halloween" },
    { name = "skull", ticket = 14460, category = "halloween" },
    { name = "black", ticket = 18734, category = "halloween" },
    { name = "fang", ticket = 18735, category = "halloween" },
    { name = "horn", ticket = 18736, category = "halloween" },
    { name = "invisible", ticket = 25179, category = "halloween" },
    { name = "magic", ticket = 25180, category = "halloween" },
    { name = "pumpkinface", ticket = 25181, category = "halloween" },
    { name = "pumpkinhead", ticket = 25182, category = "halloween" },
    { name = "x-gold", ticket = 25183, category = "halloween" },
    { name = "yellow trace", ticket = 25184, category = "halloween" },

    { name = "black cat", ticket = 27998, category = "halloween" },
    { name = "halloween ghost", ticket = 28002, category = "halloween" },
    { name = "halloween", ticket = 28006, category = "halloween" },
    { name = "moonlight", ticket = 28010, category = "halloween" },
    { name = "orange bat", ticket = 28014, category = "halloween" },
    { name = "silver bat", ticket = 28018, category = "halloween" },
    { name = "dark pumpkin", ticket = 28022, category = "halloween" },
    { name = "eye", ticket = 28026, category = "halloween" },
    { name = "mummy", ticket = 28030, category = "halloween" },
    { name = "neon", ticket = 28034, category = "halloween" },
    { name = "witch", ticket = 28038, category = "halloween" },
    { name = "black tearful", ticket = 28144, category = "halloween" },
    { name = "blue tearful", ticket = 28145, category = "halloween" },
    { name = "brain", ticket = 28146, category = "halloween" },
    { name = "green tearful", ticket = 28147, category = "halloween" },
    { name = "orange tearful", ticket = 28148, category = "halloween" },
    { name = "pink tearful", ticket = 28149, category = "halloween" },
    { name = "pirate skull", ticket = 28150, category = "halloween" },
    { name = "purple tearful", ticket = 28151, category = "halloween" },
    { name = "red tearful", ticket = 28152, category = "halloween" },
    { name = "strange skull", ticket = 28153, category = "halloween" },
    { name = "sunshine", ticket = 28154, category = "halloween" },
    { name = "white tearful", ticket = 28155, category = "halloween" },

    { name = "blue egg", ticket = 18867, category = "easter" },
    { name = "carrot", ticket = 18868, category = "easter" },
    { name = "chocolate", ticket = 18869, category = "easter" },
    { name = "green egg", ticket = 18870, category = "easter" },
    { name = "white egg", ticket = 18871, category = "easter" },
    { name = "blue easter", ticket = 24563, category = "easter" },
    { name = "green easter", ticket = 24564, category = "easter" },
    { name = "red easter", ticket = 24565, category = "easter" },
    { name = "blue chocoegg", ticket = 25394, category = "easter" },
    { name = "brown chocoegg", ticket = 25395, category = "easter" },
    { name = "golden easter", ticket = 25396, category = "easter" },
    { name = "king chocoegg", ticket = 25397, category = "easter" },
    { name = "mint chocoegg", ticket = 25398, category = "easter" },
    { name = "ocean chocoegg", ticket = 25399, category = "easter" },
    { name = "orange chocoegg", ticket = 25400, category = "easter" },
    { name = "pink chocoegg", ticket = 25401, category = "easter" },
    { name = "purple chocoegg", ticket = 25402, category = "easter" },
    { name = "red chocoegg", ticket = 25403, category = "easter" },
    { name = "yellow chocoegg", ticket = 25404, category = "easter" },
    { name = "green chocoegg", ticket = 25433, category = "easter" },

    { name = "dragonborn", ticket = 18895, category = "events" },
    { name = "grinch", ticket = 18896, category = "events" },
    { name = "minus", ticket = 18897, category = "events" },
    { name = "jurassic", ticket = 24604, category = "events" },
    { name = "the companions", ticket = 24605, category = "events" },
    { name = "yin yang", ticket = 24606, category = "events" },
    { name = "divine", ticket = 29876, category = "events" },
    { name = "skyller", ticket = 29880, category = "events" },
    { name = "xdark", ticket = 29884, category = "events" },

    { name = "flame", ticket = 18908, category = "surprise box" },
    { name = "zap", ticket = 18909, category = "surprise box" },
    { name = "splash", ticket = 18910, category = "surprise box" },

    { name = "nightmare", ticket = 18942, category = "referral" },
    { name = "shadow", ticket = 18943, category = "referral" },
    { name = "spark", ticket = 18944, category = "referral" },

    { name = "avalanche", ticket = 19064, category = "mastery" },
    { name = "blaze", ticket = 19065, category = "mastery" },
    { name = "gaia", ticket = 19066, category = "mastery" },
    { name = "heremit", ticket = 19067, category = "mastery" },
    { name = "hurricane", ticket = 19068, category = "mastery" },
    { name = "spectrum", ticket = 19069, category = "mastery" },
    { name = "vital", ticket = 19070, category = "mastery" },
    { name = "voltagic", ticket = 19071, category = "mastery" },
    { name = "zen", ticket = 19072, category = "mastery" },

    { name = "bat", ticket = 19083, category = "halloween" },
    { name = "dark eye", ticket = 19084, category = "halloween" },
    { name = "spectral", ticket = 19085, category = "halloween" },

    { name = "eevee", ticket = 24626, category = "tournament" },
    { name = "espeon", ticket = 24627, category = "tournament" },
    { name = "flareon", ticket = 24628, category = "tournament" },
    { name = "jolteon", ticket = 24629, category = "tournament" },
    { name = "umbreon", ticket = 24630, category = "tournament" },
    { name = "vaporeon", ticket = 24631, category = "tournament" },

    { name = "cake", ticket = 24698, category = "anniversary" },
    { name = "power green", ticket = 24699, category = "anniversary" },
    { name = "power light purple", ticket = 24700, category = "anniversary" },
    { name = "power pink", ticket = 24701, category = "anniversary" },
    { name = "power purple", ticket = 24702, category = "anniversary" },
    { name = "power red", ticket = 24703, category = "anniversary" },
    { name = "fire legendary", ticket = 27778, category = "anniversary" },
    { name = "green vision", ticket = 27782, category = "anniversary" },
    { name = "l", ticket = 27786, category = "anniversary" },
    { name = "o", ticket = 27790, category = "anniversary" },
    { name = "ocean vision", ticket = 27794, category = "anniversary" },
    { name = "p", ticket = 27798, category = "anniversary" },
    { name = "purple vision", ticket = 27802, category = "anniversary" },
    { name = "s", ticket = 27806, category = "anniversary" },
    { name = "u", ticket = 27810, category = "anniversary" },
    { name = "power yellow", ticket = 24704, category = "anniversary" },
    { name = "firestone", ticket = 29890, category = "anniversary" },
    { name = "golem", ticket = 29894, category = "anniversary" },
    { name = "sunstone", ticket = 29898, category = "anniversary" },
    { name = "tentacruel", ticket = 29902, category = "anniversary" },
    { name = "vanish", ticket = 29906, category = "anniversary" },
    { name = "waterstone", ticket = 29910, category = "anniversary" },

    { name = "blue present", ticket = 25349, category = "christmas" },
    { name = "christmas night", ticket = 25350, category = "christmas" },
    { name = "christmas tree", ticket = 25351, category = "christmas" },
    { name = "ginger", ticket = 25352, category = "christmas" },
    { name = "green present", ticket = 25353, category = "christmas" },
    { name = "north pole", ticket = 25354, category = "christmas" },
    { name = "purple present", ticket = 25355, category = "christmas" },
    { name = "red present", ticket = 25356, category = "christmas" },
    { name = "yellow present", ticket = 25357, category = "christmas" },

    { name = "bg jester", ticket = 28173, category = "christmas" },
    { name = "blue christmas light", ticket = 28177, category = "christmas" },
    { name = "blue christmas present", ticket = 28181, category = "christmas" },
    { name = "christmas chimney", ticket = 28185, category = "christmas" },
    { name = "garland", ticket = 28189, category = "christmas" },
    { name = "golden christmas", ticket = 28193, category = "christmas" },
    { name = "green christmas light", ticket = 28197, category = "christmas" },
    { name = "green christmas present", ticket = 28201, category = "christmas" },
    { name = "grinch christmas", ticket = 28205, category = "christmas" },
    { name = "noel", ticket = 28209, category = "christmas" },
    { name = "orange christmas light", ticket = 28213, category = "christmas" },
    { name = "pine tree", ticket = 28217, category = "christmas" },
    { name = "pink christmas light", ticket = 28221, category = "christmas" },
    { name = "purple christmas light", ticket = 28225, category = "christmas" },
    { name = "red christmas light", ticket = 28229, category = "christmas" },
    { name = "reindeer", ticket = 28233, category = "christmas" },
    { name = "rgb present", ticket = 28237, category = "christmas" },
    { name = "ry jester", ticket = 28241, category = "christmas" },
    { name = "silver christmas", ticket = 28245, category = "christmas" },
    { name = "sky blue christmas light", ticket = 28249, category = "christmas" },
    { name = "snowman", ticket = 28253, category = "christmas" },
    { name = "yellow christmas light", ticket = 28257, category = "christmas" },
    { name = "yellow christmas present", ticket = 28261, category = "christmas" },

    { name = "bug", ticket = 27730, category = "elemental" },
    { name = "insect", ticket = 27731, category = "elemental" },
    { name = "dark", ticket = 27732, category = "elemental" },
    { name = "dread", ticket = 27733, category = "elemental" },
    { name = "draco", ticket = 27734, category = "elemental" },
    { name = "dragon", ticket = 27735, category = "elemental" },
    { name = "electric", ticket = 27736, category = "elemental" },
    { name = "pixie", ticket = 27737, category = "elemental" },
    { name = "fighting", ticket = 27738, category = "elemental" },
    { name = "fist", ticket = 27739, category = "elemental" },
    { name = "fire", ticket = 27740, category = "elemental" },
    { name = "flying", ticket = 27741, category = "elemental" },
    { name = "sky", ticket = 27742, category = "elemental" },
    { name = "ghost", ticket = 27743, category = "elemental" },
    { name = "spooky", ticket = 27744, category = "elemental" },
    { name = "grass", ticket = 27745, category = "elemental" },
    { name = "meadow", ticket = 27746, category = "elemental" },
    { name = "earth", ticket = 27747, category = "elemental" },
    { name = "ground", ticket = 27748, category = "elemental" },
    { name = "ice", ticket = 27749, category = "elemental" },
    { name = "icicle", ticket = 27750, category = "elemental" },
    { name = "normal", ticket = 27751, category = "elemental" },
    { name = "plate", ticket = 27752, category = "elemental" },
    { name = "poison", ticket = 27753, category = "elemental" },
    { name = "toxic", ticket = 27754, category = "elemental" },
    { name = "mind", ticket = 27755, category = "elemental" },
    { name = "psychic", ticket = 27756, category = "elemental" },
    { name = "rock", ticket = 27757, category = "elemental" },
    { name = "stone", ticket = 27758, category = "elemental" },
    { name = "iron", ticket = 27759, category = "elemental" },
    { name = "steel", ticket = 27760, category = "elemental" },
    { name = "water", ticket = 27761, category = "elemental" },
    { name = "fairy", ticket = 27762, category = "elemental" },
}

local PAINT_TICKETS = {}
local PAINT_CATEGORIES = {}
local PAINT_OPTION_BY_NAME = {}
for k, v in pairs(PAINT_OPTIONS) do
    if (v.ticket) then
        PAINT_TICKETS[v.name] = v.ticket
    end

    if (not PAINT_CATEGORIES[v.category]) then
        PAINT_CATEGORIES[v.category] = {}
    end
    PAINT_CATEGORIES[v.category][#PAINT_CATEGORIES[v.category] + 1] = v

    PAINT_OPTION_BY_NAME[v.name] = v
end

local PAINT_CATEGORIES_MESSAGE = {}
for option, _ in pairs(PAINT_CATEGORIES) do
    PAINT_CATEGORIES_MESSAGE[#PAINT_CATEGORIES_MESSAGE + 1] = "{"
    PAINT_CATEGORIES_MESSAGE[#PAINT_CATEGORIES_MESSAGE + 1] = option
    PAINT_CATEGORIES_MESSAGE[#PAINT_CATEGORIES_MESSAGE + 1] = "}"
    PAINT_CATEGORIES_MESSAGE[#PAINT_CATEGORIES_MESSAGE + 1] = ", "
end
PAINT_CATEGORIES_MESSAGE[#PAINT_CATEGORIES_MESSAGE] = "."
PAINT_CATEGORIES_MESSAGE = table.concat(PAINT_CATEGORIES_MESSAGE)

local PRICE = 1000
local lastOption = {}

local QUESTSTATUS_UNSTARTED = -1
local QUESTSTATUS_STARTED = 0
local QUESTSTATUS_FINISHED = 1
local QUESTSTATUS_WAITINGTIME = 2

local TALKSTATE_NONE = 0
local TALKSTATE_PAINTING = 1
local TALKSTATE_BROWSING = 2

local function getPaintOptionsMessage(category)
    local message = ""
    for i, v in ipairs(category) do
        local option = v.name
        if (i ~= #category) then
            message = message .. "{" .. option .. "}, "
        else
            message = message .. "{" .. option .. "}."
        end
    end
    return message
end

function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'paint') or msgcontains(msg, 'pintar')) then
        selfSay("Here you can paint your pokeballs, I have several color {options} available.", cid)
    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
        selfSay(string.format(__L(cid, "First, you want to see the options of what category? %s"), PAINT_CATEGORIES_MESSAGE), cid)
        talkState[talkUser] = TALKSTATE_BROWSING
    elseif (talkState[talkUser] == TALKSTATE_BROWSING and PAINT_CATEGORIES[msg]) then
        selfSay(string.format(__L(cid, "The options in this category are: %s"), getPaintOptionsMessage(PAINT_CATEGORIES[msg])), cid)
    elseif (PAINT_OPTION_BY_NAME[msg]) then
        lastOption[talkUser] = string.lower(msg)
        talkState[talkUser] = TALKSTATE_PAINTING
        if (PAINT_OPTION_BY_NAME[lastOption[talkUser]].ticket > 0) then
            selfSay(string.format(__L(cid, "You want to paint your pokeball with option %s for %s dollars and a %s ticket?"), msg, PRICE, lastOption[talkUser]), cid)
        else
            selfSay(string.format(__L(cid, "You want to paint your pokeball with option %s for %s dollars?"), msg, PRICE), cid)
        end
    elseif (PAINT_CATEGORIES[msg]) then
        selfSay(string.format(__L(cid, "The options in this category are: %s"), getPaintOptionsMessage(PAINT_CATEGORIES[msg])), cid)
    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_PAINTING and lastOption[talkUser]) then
        local ball = getPlayerBall(cid)
        if (not isItem(ball)) then
            selfSay("Where is your pokeball? Put it in the correct slot!", cid)
        elseif (PAINT_OPTION_BY_NAME[lastOption[talkUser]].ticket > 0 and getPlayerItemCount(cid, PAINT_OPTION_BY_NAME[lastOption[talkUser]].ticket) == 0) then
            selfSay("You can only paint with this option if you have a ticket for it!", cid)
        elseif (getPlayerMoney(cid) < PRICE) then
            selfSay("You do not have enough money for it.", cid)
        elseif (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
            selfSay("You can not do it while you have a Pokemon out of the ball.", cid)
        elseif (isEpicBall(ball.itemid)) then
            selfSay("You can not paint this kind of ball.", cid)
            log(LOG_TYPES.WARNING, "Ball paint - Epic ball detected, bug abuser?", getCreatureName(cid), ball)
            return true

        else
            if (not balls[lastOption[talkUser]]) then
                log(LOG_TYPES.ERROR, "ShopBallPaint - Unknown Ball", getCreatureName(cid), lastOption[talkUser])
                return true
            end

            local newBall = balls[lastOption[talkUser]].charged
            if (newBall) then
                if (PAINT_OPTION_BY_NAME[lastOption[talkUser]].ticket > 0) then
                    doPlayerRemoveItem(cid, PAINT_OPTION_BY_NAME[lastOption[talkUser]].ticket, 1)
                end
                doPlayerRemoveMoney(cid, PRICE)
                doTransformItem(ball.uid, newBall)
                selfSay("Here is! Thanks!", cid)
            end
        end
        talkState[talkUser] = TALKSTATE_NONE
    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Ok!", cid)
        talkState[talkUser] = TALKSTATE_NONE
    else
        selfSay("Sorry, do not know what you're talking about.", cid)
        talkState[talkUser] = TALKSTATE_NONE
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

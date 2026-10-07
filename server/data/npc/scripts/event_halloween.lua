setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local OPTIONS = {
    -- {name = "toy mouse", id = 7487, halloweenTokens = 20, count = 1}, Sprite removed
    { name = "toy spider", id = 9006, halloweenTokens = 20, count = 1 },
    { name = "vampire doll", id = 9019, halloweenTokens = 30, count = 1 },
    { name = "mummy doll", id = 11201, halloweenTokens = 20, count = 1 },
    { name = "bat decoration", id = 6492, halloweenTokens = 15, count = 1 },
    { name = "skull tapestry", id = 5616, halloweenTokens = 8, count = 1 },
    { name = "skeleton decoration", id = 6526, halloweenTokens = 15, count = 1 },
    { name = "pumpkin amulet", id = 14462, halloweenTokens = 20, count = 1 },
    { name = "skull backpack", id = 5926, halloweenTokens = 30, count = 1 },
    { name = "skull bag", id = 5927, halloweenTokens = 18, count = 1 },
    { name = "enchanted staff", id = 14457, halloweenTokens = 2, count = 10 },
    { name = "light wand", id = 14458, halloweenTokens = 1, count = 10 },
    { name = "pumpkin ball", id = 14459, halloweenTokens = 40, count = 1 },
    { name = "skull ball", id = 14460, halloweenTokens = 40, count = 1 },
    {
        name = "rare candy",
        id = 14463,
        halloweenTokens = 100,--60,
        count = 1,
        unique = true,
        onBuy = function(cid)
            doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.BUY_RARE_CANDY)
            setPlayerBoughtRareCandy(cid, getPlayerBoughtRareCandy(cid) + 1)
        end,
        canBuy = function(cid) return getPlayerBoughtRareCandy(cid) < 15 end,
        onBuyError = "You can only buy 15 Rare Candys during this event, your account already bought all!"
    },
    { name = "halloween kit 1", id = 18719, halloweenTokens = 50, count = 1, description = "skull / frankenstein" },
    { name = "halloween kit 2", id = 18720, halloweenTokens = 100, count = 1, description = "witch / mummy" },
    { name = "halloween kit 3", id = 18721, halloweenTokens = 150, count = 1, description = "naughty devil / skeleton" },
    { name = "halloween kit 4", id = 18722, halloweenTokens = 200, count = 1, description = "dark witch / vampire" },
    -- {name = "halloween kit 5", id = 19091, halloweenTokens = 250, count = 1, description = "halloween monster"}, Quest
    -- {name = "gengar backpack", id = 18723, halloweenTokens = 50, count = 1}, Boss drop
    { name = "gastly lamp", id = 18056, halloweenTokens = 50, count = 1 },
    { name = "cubone lamp", id = 18058, halloweenTokens = 50, count = 1 },
    { name = "black pikachu doll", id = 19086, halloweenTokens = 100, count = 1 },
    { name = "blue pikachu doll", id = 19087, halloweenTokens = 100, count = 1 },
    { name = "bulbasaur doll", id = 19088, halloweenTokens = 100, count = 1 },
    { name = "charmander doll", id = 19089, halloweenTokens = 100, count = 1 },
    { name = "squirtle doll", id = 19090, halloweenTokens = 100, count = 1 },
    { name = "halloween kit 6", id = 25157, halloweenTokens = 200, count = 1, description = "panico" },
    { name = "halloween kit 7", id = 25158, halloweenTokens = 200, count = 1, description = "clown" },
    { name = "zubat statue kit", id = 25143, halloweenTokens = 100, count = 1 },
    { name = "golbat statue kit", id = 25144, halloweenTokens = 100, count = 1 },
    { name = "crobat statue kit", id = 25145, halloweenTokens = 100, count = 1 },
    { name = "skull chair kit", id = 25146, halloweenTokens = 100, count = 1 },
    { name = "blue skull chair kit", id = 25147, halloweenTokens = 100, count = 1 },
    { name = "pumpkin chair kit", id = 25148, halloweenTokens = 100, count = 1 },
    { name = "pumpkin freezer kit", id = 25149, halloweenTokens = 100, count = 1 },
    { name = "halloween table kit", id = 25150, halloweenTokens = 100, count = 1 },
    { name = "golbat computer kit", id = 25151, halloweenTokens = 100, count = 1 },
    { name = "halloween stand #1 kit", id = 25152, halloweenTokens = 100, count = 1 },
    { name = "halloween stand #2 kit", id = 25153, halloweenTokens = 100, count = 1 },
    { name = "halloween stand #3 kit", id = 25154, halloweenTokens = 100, count = 1 },
    { name = "halloween stand #4 kit", id = 25155, halloweenTokens = 100, count = 1 },
    { name = "pumpkin tree kit", id = 25156, halloweenTokens = 100, count = 1 },
    { name = "green misdreavus curtain kit", id = 25187, halloweenTokens = 30, count = 1 },
    { name = "purple misdreavus curtain kit", id = 25188, halloweenTokens = 30, count = 1 },
    { name = "pumpkin curtain kit", id = 25189, halloweenTokens = 30, count = 1 },
    { name = "pumpkinhead", id = 25094, halloweenTokens = 50, count = 1 },
    { name = "pumpkin flower kit", id = 25190, halloweenTokens = 50, count = 1 },

    { name = "elder god statue kit", id = 28159, halloweenTokens = 50, count = 1 },
    { name = "imperial boat decoration kit", id = 28156, halloweenTokens = 50, count = 1 },
    { name = "kraken boat decoration kit", id = 28157, halloweenTokens = 50, count = 1 },
    { name = "pirate boat decoration kit", id = 28158, halloweenTokens = 50, count = 1 },

--    { name = "ghost pillow backpack", id = 27938, halloweenTokens = 50, count = 1 },
--    { name = "haunted backpack", id = 27939, halloweenTokens = 50, count = 1 },
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    OPTION_BY_NAME[string.lower(v.name)] = v
end

local HALLOWEEN_TOKEN_ID = 14461

local lastOption = {}

local TALKSTATE_NONE = 0
local TALKSTATE_EXCHANGING = 1

local function getOptionsMessage()
    local message = {}
    for i, option in ipairs(OPTIONS) do
        message[#message + 1] = option.name
        if (option.description) then
            message[#message + 1] = " ("
            message[#message + 1] = option.description
            message[#message + 1] = ")"
        end
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x]["
        message[#message + 1] = option.halloweenTokens
        message[#message + 1] = "x HT]\n"
    end
    message[#message + 1] = "\nHT = Halloween Tokens"
    return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (OPTION_BY_NAME[msg]) then
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s halloween tokens for a %s?"), OPTION_BY_NAME[msg].halloweenTokens, msg), cid)

    elseif (msgcontains(msg, 'halloween') or msgcontains(msg, 'gift') or msgcontains(msg, 'dia das bruxas') or msgcontains(msg, 'presente')) then
        selfSay("Here you can exchange halloween tokens into halloween gifts, you can see the {options}.", cid)

    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
        doPlayerPopupFYI(cid, optionsMessage)

    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
            lastOption[talkUser]) then
        local opt = OPTION_BY_NAME[lastOption[talkUser]]

        if (opt.canBuy and not opt.canBuy(cid)) then
            selfSay(opt.onBuyError, cid)

        elseif (getPlayerItemCountByUnique(cid, HALLOWEEN_TOKEN_ID) >= opt.halloweenTokens and
                doPlayerRemoveItemByUnique(cid, HALLOWEEN_TOKEN_ID, opt.halloweenTokens)) then
            doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
            selfSay("Heereee is... thaaanksss!", cid)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end

        else
            selfSay("You do not have enough halloween coins for it.", cid)
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Huuuumm...", cid)
        talkState[talkUser] = TALKSTATE_NONE

    else
        selfSay("Whaat?", cid)
        talkState[talkUser] = TALKSTATE_NONE
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

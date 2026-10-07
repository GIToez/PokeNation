setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastCount = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local TALK_STATES = { NONE = 0 }
local LETTERS_OPTIONS = {
    { name = "kangaskhan locker", id = 26182, count = 1 },
    { name = "aggron locker", id = 26183, count = 1 },
    { name = "absol locker", id = 26184, count = 1 },
    { name = "sceptile locker", id = 26185, count = 1 },
    { name = "rhydon locker", id = 26186, count = 1 },
    { name = "gardevoir locker", id = 26187, count = 1 },
    { name = "electivire locker", id = 26188, count = 1 },
    { name = "feraligatr locker", id = 26189, count = 1 },
    { name = "infernape locker", id = 26190, count = 1 },
    { name = "dragonair locker", id = 26191, count = 1 },
}

local LETTERS_OPTION_BY_NAME = {}
for k, v in pairs(LETTERS_OPTIONS) do
    LETTERS_OPTION_BY_NAME[string.lower(v.name)] = v
end

local LETTERS_ID = { 14438, 14439, 14440, 14441, 14442 }

local lastLettersOption = {}

local TALKSTATE_LETTERS_EXCHANGING = 200

local function getOptionsMessage()
    local message = {}
    for i, option in pairs(LETTERS_OPTION_BY_NAME) do
        message[#message + 1] = option.name
        if (option.description) then
            message[#message + 1] = " ("
            message[#message + 1] = option.description
            message[#message + 1] = ")"
        end
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x]\n"
    end
    return table.concat(message)
end

local lettersOptionsMessage = getOptionsMessage()
getOptionsMessage = nil

--[[ ]]
local OPTIONS = {
    { name = "tm energy ball", id = 24720, tokens = 80, count = 1 },
    { name = "tm poison jab", id = 24722, tokens = 80, count = 1 },
    { name = "tm rock tomb", id = 24717, tokens = 80, count = 1 },
    { name = "tm drain punch", id = 24721, tokens = 80, count = 1 },

    { name = "god crespi doll", id = 27816, tokens = 40, count = 1 },
    { name = "god loki doll", id = 27817, tokens = 40, count = 1 },
    { name = "god slowmotion doll", id = 27818, tokens = 40, count = 1 },

    { name = "azurill/blastoise costume", id = 29885, tokens = 50, count = 1, description = "Outfit" },
    { name = "pikachu/charizard costume", id = 29886, tokens = 50, count = 1, description = "Outfit" },

    { name = "skarmory battle armor", id = 29848, tokens = 70, count = 1, description = "Pokemon Addon" },
    { name = "kingdra battle armor", id = 29849, tokens = 70, count = 1, description = "Pokemon Addon" },
    { name = "charizard battle armor", id = 29857, tokens = 70, count = 1, description = "Pokemon Addon" },
    { name = "battle armor", id = 29850, tokens = 70, count = 1, description = "Pokemon Addon" },
    { name = "royal armor", id = 29818, tokens = 70, count = 1, description = "Pokemon Addon" },
    { name = "boo costume", id = 29819, tokens = 70, count = 1, description = "Pokemon Addon" },

    { name = "firestone paint ticket", id = 29890, tokens = 25, count = 1 },
    { name = "sunstone paint ticket", id = 29898, tokens = 25, count = 1 },
    { name = "waterstone paint ticket", id = 29910, tokens = 25, count = 1 },
    { name = "golem paint ticket", id = 29894, tokens = 25, count = 1 },
    { name = "tentacruel paint ticket", id = 29902, tokens = 25, count = 1 },
    { name = "vanish paint ticket", id = 29906, tokens = 25, count = 1 },

    { name = "ruby tapestry", id = 29985, tokens = 3, count = 1 },
    { name = "citrine tapestry", id = 29988, tokens = 3, count = 1 },
    { name = "topaz tapestry", id = 29991, tokens = 3, count = 1 },
    { name = "sapphire tapestry", id = 29994, tokens = 3, count = 1 },
    { name = "lapis lazuli tapestry", id = 29997, tokens = 3, count = 1 },
    { name = "charoite tapestry", id = 30000, tokens = 3, count = 1 },
    { name = "pearl tapestry", id = 30102, tokens = 3, count = 1 },
    { name = "diamond tapestry", id = 30105, tokens = 3, count = 1 },
    { name = "morganite tapestry", id = 30135, tokens = 3, count = 1 },

    { name = "red wooden bed", id = 30124, tokens = 15, count = 1 },
    { name = "orange wooden bed", id = 30125, tokens = 15, count = 1 },
    { name = "yellow wooden bed", id = 30126, tokens = 15, count = 1 },
    { name = "green wooden bed", id = 30127, tokens = 15, count = 1 },
    { name = "blue wooden bed", id = 30128, tokens = 15, count = 1 },
    { name = "purple wooden bed", id = 30129, tokens = 15, count = 1 },
    { name = "pink wooden bed", id = 30130, tokens = 15, count = 1 },
    { name = "black wooden bed", id = 30131, tokens = 15, count = 1 },
    { name = "white wooden bed", id = 30132, tokens = 15, count = 1 },
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 27935

local lastOption = {}

local TALKSTATE_NONE = 0
local TALKSTATE_EXCHANGING = 100

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
        message[#message + 1] = option.tokens
        if (option.tokenId) then
            message[#message + 1] = "x "
            message[#message + 1] = getItemNameById(option.tokenId)
            message[#message + 1] = "]\n"
        else
            message[#message + 1] = "x AT]\n"
        end
    end
    message[#message + 1] = "\nAT = Anniversary Token"
    return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil
--[[ ]]

function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    msg = string.lower(msg)

    if (msgcontains(msg, 'gift') or msgcontains(msg, 'presente')) then
        selfSay("Here you can exchange the 'psoul' letters for exclusive items.", cid)
        doPlayerPopupFYI(cid, lettersOptionsMessage)

    elseif (LETTERS_OPTION_BY_NAME[msg]) then
        lastLettersOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_LETTERS_EXCHANGING
        selfSay(string.format(__L(cid, "Do you really want to exchange 'psoul' letters for a %s?"), msg), cid)

    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_LETTERS_EXCHANGING and lastLettersOption[talkUser]) then
        local opt = LETTERS_OPTION_BY_NAME[lastLettersOption[talkUser]]

        if (opt.canBuy and not opt.canBuy(cid)) then
            selfSay(opt.onBuyError, cid)

        else
            for _, letterItemId in pairs(LETTERS_ID) do
                if (getPlayerItemCount(cid, letterItemId) <= 0) then
                    selfSay("You do not have enough letters for it.", cid)
                    return true
                end
            end

            for _, letterItemId in pairs(LETTERS_ID) do
                doPlayerRemoveItem(cid, letterItemId, 1)
            end

            doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
            selfSay("Oh, thanks!", cid)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (OPTION_BY_NAME[msg]) then
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        if (OPTION_BY_NAME[msg].tokenId) then
            selfSay(string.format(__L(cid, "You want to exchange %s %s for a %s?"), OPTION_BY_NAME[msg].tokens, getItemNameById(OPTION_BY_NAME[msg].tokenId), msg), cid)
        else
            selfSay(string.format(__L(cid, "You want to exchange %s anniversary token for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)
        end

    elseif (msgcontains(msg, 'anniversary') or msgcontains(msg, 'aniversário')) then
        selfSay("Here you can exchange anniversary tokens into gifts, you can see the {options}.", cid)

    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
        doPlayerPopupFYI(cid, optionsMessage)

    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and lastOption[talkUser]) then
        local opt = OPTION_BY_NAME[lastOption[talkUser]]

        if (opt.canBuy and not opt.canBuy(cid)) then
            selfSay(opt.onBuyError, cid)

        elseif (getPlayerItemCount(cid, (opt.tokenId and opt.tokenId or TOKEN_ID)) >= opt.tokens and
                doPlayerRemoveItem(cid, (opt.tokenId and opt.tokenId or TOKEN_ID), opt.tokens)) then
            doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
            selfSay("Oh, thanks!", cid)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end

        else
            selfSay("You do not have enough token(s) for it.", cid)
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Ok.", cid)
        talkState[talkUser] = TALKSTATE_NONE

    else
        talkState[talkUser] = TALK_STATES.NONE

        selfSay("Ok...", cid)
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

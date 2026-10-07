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
    { name = "impetus potion", reagents = { { itemId = 12103, count = 20 }, { itemId = 14498, count = 5 }, { itemId = 12118, count = 5 } }, potionItemId = 27944, limitPerDay = 10 },
    { name = "gallantry potion", reagents = { { itemId = 12113, count = 10 }, { itemId = 12138, count = 10 }, { itemId = 14468, count = 10 } }, potionItemId = 27943, limitPerDay = 10 },
    { name = "resistor potion", reagents = { { itemId = 12104, count = 50 }, { itemId = 12112, count = 10 }, { itemId = 14503, count = 5 } }, potionItemId = 27948, limitPerDay = 10 },
    { name = "diablerie potion", reagents = { { itemId = 12101, count = 50 }, { itemId = 12123, count = 15 }, { itemId = 14497, count = 10 } }, potionItemId = 27942, limitPerDay = 10 },
    { name = "patronage potion", reagents = { { itemId = 12138, count = 15 }, { itemId = 12124, count = 10 }, { itemId = 12115, count = 5 } }, potionItemId = 27946, limitPerDay = 10 },
    { name = "momentum potion", reagents = { { itemId = 12102, count = 50 }, { itemId = 12140, count = 10 }, { itemId = 17802, count = 5 } }, potionItemId = 27945, limitPerDay = 10 },
    { name = "pulse potion", reagents = { { itemId = 12142, count = 50 }, { itemId = 12138, count = 5 }, { itemId = 12091, count = 5 } }, potionItemId = 27947, limitPerDay = 10 },
    { name = "sense potion", reagents = { { itemId = 12113, count = 10 }, { itemId = 12096, count = 5 }, { itemId = 12142, count = 10 } }, potionItemId = 27949, limitPerDay = 5 },
    { name = "vigilance potion", reagents = { { itemId = 12124, count = 5 }, { itemId = 12104, count = 20 }, { itemId = 12096, count = 10 } }, potionItemId = 27950, limitPerDay = 5 },
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    OPTION_BY_NAME[string.lower(v.name)] = v
end

local LIMIT_PER_DAY = 15

local lastOption = {}
local lastBoughts = {} -- Structure: {total: 0 --[[ Total potions bought ]], boughts = {[0] = 0, [1] = 0, [2] = 0} --[[ Individual potion bought count ]]}

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

        for j, reagent in pairs(option.reagents) do
            message[#message + 1] = reagent.count
            message[#message + 1] = "x "
            message[#message + 1] = getItemNameById(reagent.itemId)
            message[#message + 1] = ","
        end

        message[#message] = "]\n"
    end
    return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

local function doPlayerCheckReagents(cid, reagents)
    for k, reagent in pairs(reagents) do
        if (getPlayerItemCount(cid, reagent.itemId) < reagent.count) then
            return false
        end
    end
    return true
end

local function doPlayerRemoveReagents(cid, reagents)
    for k, reagent in pairs(reagents) do
        doPlayerRemoveItem(cid, reagent.itemId, reagent.count)
    end
    return true
end

local function getReagentsMessage(reagents)
    local ret = {}
    for k, reagent in pairs(reagents) do
        ret[#ret + 1] = reagent.count
        ret[#ret + 1] = "x "
        ret[#ret + 1] = getItemNameById(reagent.itemId)
        ret[#ret + 1] = ", "
    end
    ret[#ret] = nil -- Remove last comma
    return table.concat(ret)
end

local function doPlayerCanBuyPotion(cid, option)
    local guid = getPlayerGUID(cid)
    if (not lastBoughts[guid]) then
        return true
    end

    if (lastBoughts[guid].total >= LIMIT_PER_DAY or (lastBoughts[guid].boughts[option.potionItemId] and lastBoughts[guid].boughts[option.potionItemId] >= option.limitPerDay)) then
        return false
    end

    local count = 0
    for k, v in pairs(lastBoughts[guid].boughts) do
        count = count + v
    end

    return count <= LIMIT_PER_DAY
end

local function doPlayerRegisterPotionBought(cid, option)
    local guid = getPlayerGUID(cid)
    if (not lastBoughts[guid]) then
        lastBoughts[guid] = { total = 0, boughts = {} }
    end

    lastBoughts[guid].total = lastBoughts[guid].total + 1

    if (not lastBoughts[guid].boughts[option.potionItemId]) then
        lastBoughts[guid].boughts[option.potionItemId] = 0
    end

    lastBoughts[guid].boughts[option.potionItemId] = lastBoughts[guid].boughts[option.potionItemId] + 1
end

function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (OPTION_BY_NAME[msg]) then
        lastOption[talkUser] = msg
        talkState[talkUser] = TALKSTATE_EXCHANGING
        selfSay(string.format(__L(cid, "You want to exchange %s for the %s?"), getReagentsMessage(OPTION_BY_NAME[msg].reagents), OPTION_BY_NAME[msg].name), cid)

    elseif (msgcontains(msg, 'halloween') or msgcontains(msg, 'gift') or msgcontains(msg, 'dia das bruxas') or msgcontains(msg, 'presente')) then
        selfSay("I can create magic {potions} for you!", cid)

    elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes') or msgcontains(msg, 'potion') or msgcontains(msg, 'poçao') or msgcontains(msg, { 'poçoes', 'pocoes' })) then
        doPlayerPopupFYI(cid, optionsMessage)

    elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
            lastOption[talkUser]) then
        local opt = OPTION_BY_NAME[lastOption[talkUser]]

        if (not doPlayerCanBuyPotion(cid, opt)) then
            selfSay("Errr! You have already generated many potions today! Please try again tomorrow!", cid)

        elseif (doPlayerCheckReagents(cid, opt.reagents) and doPlayerRemoveReagents(cid, opt.reagents)) then
            doPlayerSafeAddItem(cid, opt.potionItemId, 1, true, true)
            selfSay("Here is, thanks!", cid)
            doPlayerRegisterPotionBought(cid, opt)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end

        else
            selfSay("You do not have reagents for it.", cid)
        end

        talkState[talkUser] = TALKSTATE_NONE

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Hmmm...", cid)
        talkState[talkUser] = TALKSTATE_NONE

    else
        selfSay("What?", cid)
        talkState[talkUser] = TALKSTATE_NONE
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

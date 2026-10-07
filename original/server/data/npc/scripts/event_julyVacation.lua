setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

--[[
1x Fragment: 1x Seal Box Comum
5x Fragment: 1x Vitamin Box
5x Fragment: 1x Mastery Ball Box
10x Fragment: 5x Rare Lollipop
10x Fragment: 1x TM Box Nível 20
10x Fragment: 1x Paint TIcket Box Raro
15x Fragment: 3x Rare Candy
20x Fragment: 1x TM Box Nível 40
25x Fragment: 1x TM Box Nível 60
 ]]

local OPTIONS = {
    {name = "common seal box", id = 29125, tokens = 1, count = 1},
    {name = "vitamin box", id = 23949, tokens = 5, count = 1},
    {name = "mastery ball box", id = 29129, tokens = 5, count = 1},
    {name = "rare lollipop", id = 24632, tokens = 3, count = 1, onCreate = function(item, cid)
        doItemSetAttribute(item, 1000, getPlayerLevel(cid))
    end},
    {name = "common TM box", id = 27764, tokens = 10, count = 1},
    {name = "rare paint ticket box", id = 29127, tokens = 10, count = 1},
    {name = "rare candy", id = 14463, tokens = 15, count = 3},
    {name = "rare TM box", id = 27767, tokens = 20, count = 1},
    {name = "legendary TM box", id = 27768, tokens = 25, count = 1},
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 29132

local lastOption = {}

local TALKSTATE_NONE = 0
local TALKSTATE_EXCHANGING = 10

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
        message[#message + 1] = "x F]\n"
    end
    message[#message + 1] = "\nCT = Fragment of The Choosen Ones"
	return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

--

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    msg = string.lower(msg)

    if (OPTION_BY_NAME[msg]) then
		lastOption[talkUser] = msg
		talkState[talkUser] = TALKSTATE_EXCHANGING
		selfSay(string.format(__L(cid, "You want to exchange %s tokens for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

	elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
		doPlayerPopupFYI(cid, optionsMessage)

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
            lastOption[talkUser]) then
        local opt = OPTION_BY_NAME[lastOption[talkUser]]

        if (opt.canBuy and not opt.canBuy(cid)) then
            selfSay(opt.onBuyError, cid)

        elseif (getPlayerItemCountByUnique(cid, TOKEN_ID) >= opt.tokens and
                doPlayerRemoveItemByUnique(cid, TOKEN_ID, opt.tokens)) then
			doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique, true, opt.onCreate)
			selfSay("Here is, thanks!", cid)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end

		else
			selfSay("You do not have enough tokens for it.", cid)
        end

		talkState[talkUser] = TALKSTATE_NONE

	elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
		selfSay("Ho ho ho!", cid)
		talkState[talkUser] = TALKSTATE_NONE

	else
		selfSay("Here you can exchange Fragments of The Choosen One into gifts, you can see the {options}.", cid)
    end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastCount = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

local TALK_STATES = {
	NONE = 0,
	DEPOSIT = 1,
	HOW_MUCH_BALLS = 2,
	EXCHANGE_CONFIRM = 3
}

local function addEggs(cid, yellow, red, blue, green, purple)
	setGlobalStorageValue(1000, getGlobalStorageValue(1000) + yellow)
	setGlobalStorageValue(1001, getGlobalStorageValue(1001) + red)
	setGlobalStorageValue(1002, getGlobalStorageValue(1002) + blue)
	setGlobalStorageValue(1003, getGlobalStorageValue(1003) + green)
	setGlobalStorageValue(1004, getGlobalStorageValue(1004) + purple)
	setPlayerDeliveredEasterEggs(cid, getPlayerDeliveredEasterEggs(cid) + yellow + red + blue + green + purple)
end

--[[ ]]
local OPTIONS = {
	{name = "100 empty white easter ball", id = 24568, tokens = 500, count = 100},
	{name = "10 empty white easter ball", id = 24568, tokens = 50, count = 10},
	{name = "empty white easter ball", id = 24568, tokens = 5, count = 1},
	{name = "blue easter ticket", id = 24563, tokens = 20, count = 1},
	{name = "green easter ticket", id = 24564, tokens = 20, count = 1},
	{name = "red easter ticket", id = 24565, tokens = 20, count = 1},
	{name = "blue delicious machine", id = 25425, tokens = 100, count = 1, unique = true},
	{name = "green delicious machine", id = 25426, tokens = 100, count = 1, unique = true},
	{name = "red delicious machine", id = 25427, tokens = 100, count = 1, unique = true},
	{name = "yellow delicious machine", id = 25428, tokens = 100, count = 1, unique = true},
	{name = "decoration easter", description = "decoration easter eggs", id = 25430, tokens = 50, count = 1},
	{name = "black easter shoes", id = 25429, tokens = 100, count = 1},
	{name = "white easter shoes", id = 25432, tokens = 100, count = 1},
	{name = "rare candy", id = 14463, tokens = 75, count = 1, unique = true,
		onBuy = function(cid)
			setPlayerBoughtRareCandy(cid, getPlayerBoughtRareCandy(cid) + 1)
		end,
		canBuy = function(cid) return getPlayerBoughtRareCandy(cid) < 15 end,
		onBuyError = "You can only buy 15 Rare Candys during this event, your account already bought all!"
	},
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
	OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 24549

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
		message[#message + 1] = "x GEE]\n"
	end
	message[#message + 1] = "\nGEE = Golden Easter Egg"
	return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil
--[[ ]]

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	msg = string.lower(msg)

	if (msgcontains(msg, 'egg') or msgcontains(msg, 'colored') or msgcontains(msg, 'ovo') or msgcontains(msg, 'colorido')) then
    selfSay("We are not collecting eggs anymore! Thank you!", cid)
--		talkState[talkUser] = TALK_STATES.DEPOSIT

--		selfSay("You found some colored egg?", cid)

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALK_STATES.DEPOSIT) then
		local yellowEgg, redEgg, blueEgg, greenEgg, purpleEgg = getPlayerItemCount(cid, 6541), getPlayerItemCount(cid, 6542), getPlayerItemCount(cid, 6543), getPlayerItemCount(cid, 6544), getPlayerItemCount(cid, 6545)

		if (yellowEgg > 0 or redEgg > 0 or blueEgg > 0 or greenEgg > 0 or purpleEgg > 0) then
			doPlayerRemoveItem(cid, 6541, yellowEgg)
			doPlayerRemoveItem(cid, 6542, redEgg)
			doPlayerRemoveItem(cid, 6543, blueEgg)
			doPlayerRemoveItem(cid, 6544, greenEgg)
			doPlayerRemoveItem(cid, 6545, purpleEgg)
			addEggs(cid, yellowEgg, redEgg, blueEgg, greenEgg, purpleEgg)
			selfSay("Thanks! But do not stop looking, there are still missing eggs.", cid)

		else
			selfSay("No, you have no colored egg.", cid)
		end

		talkState[talkUser] = TALK_STATES.NONE

	elseif (OPTION_BY_NAME[msg]) then
		lastOption[talkUser] = msg
		talkState[talkUser] = TALKSTATE_EXCHANGING
		selfSay(string.format(__L(cid, "You want to exchange %s golden easter egg for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

	elseif (msgcontains(msg, 'golden easter') or msgcontains(msg, 'easter')) then
		selfSay("Here you can exchange golden easter eggs into gifts, you can see the {options}.", cid)

	elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
		doPlayerPopupFYI(cid, optionsMessage)

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
			lastOption[talkUser]) then
		local opt = OPTION_BY_NAME[lastOption[talkUser]]

		if (opt.canBuy and not opt.canBuy(cid)) then
			selfSay(opt.onBuyError, cid)

		elseif (getPlayerItemCount(cid, TOKEN_ID) >= opt.tokens and
				doPlayerRemoveItem(cid, TOKEN_ID, opt.tokens)) then
			doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
			selfSay("Oh, thanks!", cid)

			if (opt.onBuy) then
				opt.onBuy(cid)
			end

		else
			selfSay("You do not have enough golden easter egg for it.", cid)
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

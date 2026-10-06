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
    {name = "christmas kit 1", id = 18748, tokens = 50, count = 1, description = "outfit"},
	{name = "christmas kit 2", id = 18749, tokens = 50, count = 1, description = "outfit"},
	{name = "christmas kit 3", id = 18750, tokens = 100, count = 1, description = "outfit"},
	{name = "santa claus present", id = 14639, tokens = 30, count = 1},
    {name = "chinchou lamp", id = 18052, tokens = 50, count = 1},
    {name = "pikachu lamp", id = 18054, tokens = 50, count = 1},
    {name = "poke table", id = 18752, tokens = 50, count = 1, description = "package for houses"},
    {name = "pichu carpet", id = 18061, tokens = 50, count = 1},
    {name = "aipom carpet", id = 18062, tokens = 50, count = 1},
    {name = "noctowl carpet", id = 18063, tokens = 50, count = 1},
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 14632

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
        message[#message + 1] = "x CT]\n"
    end
    message[#message + 1] = "\nCT = Christmas Tokens"
	return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

--
local firstTmRewardStorage = 8374
local secondTmRewardStorage = 8376

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    -- First TM Quest
    if (getCreatureStorage(cid, 8373) == QUEST_STATUS.FINISHED and
            getCreatureStorage(cid, firstTmRewardStorage) ~= QUEST_STATUS.FINISHED) then
        local tmItemId = 0
        if (msgcontains(msg, '16')) then
            tmItemId = 17352
        elseif (msgcontains(msg, '23')) then
            tmItemId = 17359
        elseif (msgcontains(msg, '27')) then
            tmItemId = 17363
        elseif (msgcontains(msg, '39')) then
            tmItemId = 17375
        elseif (msgcontains(msg, '46')) then
            tmItemId = 17382
        end

        if (tmItemId == 0) then
            selfSay("What reward you want? Your options are: {TM 16} (Submission), {TM 23} (Thunderbolt), {TM 27} (Psychic), {TM 39} (Dream Eater) and {TM 46} (Tri Attack).", cid)
            return true
        end

        if (doPlayerSafeAddItem(cid, tmItemId, 1, true, true)) then
            doCreatureSetStorage(cid, firstTmRewardStorage, QUEST_STATUS.FINISHED)
            selfSay("Ok, here is!", cid)
        end

        return true
    end

    -- Second TM Quest
    if (getCreatureStorage(cid, 8375) == QUEST_STATUS.FINISHED and
            getCreatureStorage(cid, secondTmRewardStorage) ~= QUEST_STATUS.FINISHED) then
        local tmItemId = 0
        if (msgcontains(msg, '10')) then
            tmItemId = 17346
        elseif (msgcontains(msg, '13')) then
            tmItemId = 17349
        elseif (msgcontains(msg, '21')) then
            tmItemId = 17357
        elseif (msgcontains(msg, '26')) then
            tmItemId = 17362
        elseif (msgcontains(msg, '32')) then
            tmItemId = 17368
        end

        if (tmItemId == 0) then
            selfSay("What reward you want? Your options are: {TM 10} (Double-Edge), {TM 13} (Ice Beam), {TM 21} (Solar Beam), {TM 26} (Fissure) and {TM 32} (Metronome).", cid)
            return true
        end

        if (doPlayerSafeAddItem(cid, tmItemId, 1, true, true)) then
            doCreatureSetStorage(cid, secondTmRewardStorage, QUEST_STATUS.FINISHED)
            selfSay("Ok, here is!", cid)
        end

        return true
    end

	--
    if (OPTION_BY_NAME[msg]) then
		lastOption[talkUser] = msg
		talkState[talkUser] = TALKSTATE_EXCHANGING
		selfSay(string.format(__L(cid, "You want to exchange %s christmas tokens for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

    elseif (msgcontains(msg, 'christmas') or msgcontains(msg, 'gift') or msgcontains(msg, 'presente') or msgcontains(msg, 'natal')) then
		selfSay("Here you can exchange christmas tokens into christmas gifts, you can see the {options}.", cid)

	elseif (msgcontains(msg, 'option') or msgcontains(msg, 'opcoes')) then
		doPlayerPopupFYI(cid, optionsMessage)

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == TALKSTATE_EXCHANGING and
            lastOption[talkUser]) then
        local opt = OPTION_BY_NAME[lastOption[talkUser]]

        if (opt.canBuy and not opt.canBuy(cid)) then
            selfSay(opt.onBuyError, cid)

        elseif (getPlayerItemCountByUnique(cid, TOKEN_ID) >= opt.tokens and
                doPlayerRemoveItemByUnique(cid, TOKEN_ID, opt.tokens)) then
			doPlayerSafeAddItem(cid, opt.id, opt.count, true, opt.unique)
			selfSay("Here is, thanks!", cid)

            if (opt.onBuy) then
                opt.onBuy(cid)
            end

		else
			selfSay("You do not have enough christmas tokens for it.", cid)
        end

		talkState[talkUser] = TALKSTATE_NONE

	elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
		selfSay("Ho ho ho!", cid)
		talkState[talkUser] = TALKSTATE_NONE

	else
		npcHandler.talkState[talkUser] = doQuestTalk(cid, "Santa Claus", msg, npcHandler.talkState[talkUser])
    end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

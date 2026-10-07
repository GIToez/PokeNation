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
	{name = "santa claus present", id = 14639, tokens = 5, count = 1},
    {name = "chinchou lamp", id = 18052, tokens = 50, count = 1},
    {name = "pikachu lamp", id = 18054, tokens = 50, count = 1},
    {name = "poke table", id = 18752, tokens = 50, count = 1, description = "package for houses"},
    {name = "pichu carpet", id = 18061, tokens = 50, count = 1},
    {name = "aipom carpet", id = 18062, tokens = 50, count = 1},
    {name = "noctowl carpet", id = 18063, tokens = 50, count = 1},
    {name = "elfin clothes kit", id = 25316, tokens = 100, count = 1, description = "outfit"},
    {name = "helper grinch clothes kit", id = 25317, tokens = 100, count = 1, description = "outfit"},
    {name = "blue present paint ticket", id = 25349, tokens = 30, count = 1},
    {name = "christmas night paint ticket", id = 25350, tokens = 30, count = 1},
    {name = "christmas tree paint ticket", id = 25351, tokens = 30, count = 1},
    {name = "ginger paint ticket", id = 25352, tokens = 30, count = 1},
    {name = "green present paint ticket", id = 25353, tokens = 30, count = 1},
    {name = "north pole paint ticket", id = 25354, tokens = 30, count = 1},
    {name = "purple present paint ticket", id = 25355, tokens = 30, count = 1},
    {name = "red present paint ticket", id = 25356, tokens = 30, count = 1},
    {name = "yellow present paint ticket", id = 25357, tokens = 30, count = 1},

    {name = "bg jester paint ticket", id = 28173, tokens = 30, count = 1},
    {name = "blue christmas light paint ticket", id = 28177, tokens = 30, count = 1},
    {name = "blue christmas present paint ticket", id = 28181, tokens = 30, count = 1},
    {name = "christmas chimney paint ticket", id = 28185, tokens = 30, count = 1},
    {name = "garland paint ticket", id = 28189, tokens = 30, count = 1},
    {name = "golden christmas paint ticket", id = 28193, tokens = 30, count = 1},
    {name = "green christmas light paint ticket", id = 28197, tokens = 30, count = 1},
    {name = "green christmas present paint ticket", id = 28201, tokens = 30, count = 1},
    {name = "grinch christmas paint ticket", id = 28205, tokens = 30, count = 1},
    {name = "noel paint ticket", id = 28209, tokens = 30, count = 1},
    {name = "orange christmas light paint ticket", id = 28213, tokens = 30, count = 1},
    {name = "pine tree paint ticket", id = 28217, tokens = 30, count = 1},
    {name = "pink christmas light paint ticket", id = 28221, tokens = 30, count = 1},
    {name = "purple christmas light paint ticket", id = 28225, tokens = 30, count = 1},
    {name = "red christmas light paint ticket", id = 28229, tokens = 30, count = 1},
    {name = "reindeer paint ticket", id = 28233, tokens = 30, count = 1},
    {name = "rgb present paint ticket", id = 28237, tokens = 30, count = 1},
    {name = "silver christmas paint ticket", id = 28245, tokens = 30, count = 1},
    {name = "sky blue christmas light paint ticket", id = 28249, tokens = 30, count = 1},
    {name = "snowman paint ticket", id = 28253, tokens = 30, count = 1},
    {name = "yellow christmas light paint ticket", id = 28257, tokens = 30, count = 1},
    {name = "yellow christmas present paint ticket", id = 28261, tokens = 30, count = 1},

    {name = "bygone snow doll", id = 28262, tokens = 50, count = 1},
    {name = "nowaday snow doll", id = 28263, tokens = 50, count = 1},
    {name = "to be snow doll", id = 28264, tokens = 50, count = 1},
}

local OPTION_BY_NAME = {}
for k, v in pairs(OPTIONS) do
    OPTION_BY_NAME[string.lower(v.name)] = v
end

local TOKEN_ID = 25270

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
        message[#message + 1] = "x TB]\n"
    end
    message[#message + 1] = "\nTB = Token Boxes"
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

	--
    if (OPTION_BY_NAME[msg]) then
		lastOption[talkUser] = msg
		talkState[talkUser] = TALKSTATE_EXCHANGING
		selfSay(string.format(__L(cid, "You want to exchange %s token boxes for a %s?"), OPTION_BY_NAME[msg].tokens, msg), cid)

    elseif (msgcontains(msg, 'christmas') or msgcontains(msg, 'gift') or msgcontains(msg, 'presente') or msgcontains(msg, 'natal')) then
		selfSay("Here you can exchange token boxes into christmas gifts, you can see the {options}.", cid)

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
			selfSay("You do not have enough token boxes for it.", cid)
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

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (getCreatureStorage(cid, 8639) == QUEST_STATUS.STARTED or getCreatureStorage(cid, 8572) == QUEST_STATUS.FINISHED) then
        selfSay("Ho Ho Ho! I can exchange Token Boxes for {christmas gifts}. Shhh! ... How is the {mission}?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

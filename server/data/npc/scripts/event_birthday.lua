setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local lastOption = {}

local TALKSTATE_NONE = 0
local TALKSTATE_PIKACHU = 1
local TALKSTATE_MOON = 2
local TALKSTATE_STAR = 3
local TALKSTATE_YEREBLU = 4

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'gift') or msgcontains(msg, 'presente')) then
		selfSay("Here you can exchange the 'psoul' letters for exclusive items. The items are: {Pikachu Backpack}, {Moon Backpack}, ticket for {Star Ball} painting or ticket for {Yereblu Ball} painting. ", cid)

	elseif (msgcontains(msg, 'pikachu')) then
		talkState[talkUser] = TALKSTATE_PIKACHU
		selfSay("Do you really want to exchange 'psoul' letters for a Pikachu Backpack?", cid)
	elseif (msgcontains(msg, 'moon')) then
		talkState[talkUser] = TALKSTATE_MOON
		selfSay("Do you really want to exchange 'psoul' letters for a Moon Backpack?", cid)
	elseif (msgcontains(msg, 'star')) then
		talkState[talkUser] = TALKSTATE_STAR
		selfSay("Do you really want to exchange 'psoul' letters for a ticket for Star Ball painting?", cid)
	elseif (msgcontains(msg, 'yereblu')) then
		talkState[talkUser] = TALKSTATE_YEREBLU
		selfSay("Do you really want to exchange 'psoul' letters for a ticket for Yereblu Ball painting?", cid)

	elseif((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] ~= TALKSTATE_NONE) then
		if (getPlayerItemCount(cid, 14438) == 0 or getPlayerItemCount(cid, 14439) == 0 or getPlayerItemCount(cid, 14440) == 0 or getPlayerItemCount(cid, 14441) == 0 or getPlayerItemCount(cid, 14442) == 0) then
			talkState[talkUser] = TALKSTATE_NONE
			selfSay("Sorry, you do not have the letters.", cid)

		elseif (talkState[talkUser] == TALKSTATE_PIKACHU) then
			talkState[talkUser] = TALKSTATE_NONE
			doPlayerRemoveItem(cid, 14438, 1)
			doPlayerRemoveItem(cid, 14439, 1)
			doPlayerRemoveItem(cid, 14440, 1)
			doPlayerRemoveItem(cid, 14441, 1)
			doPlayerRemoveItem(cid, 14442, 1)
			doPlayerAddItem(cid, 13215)
			selfSay("Here it is!", cid)

		elseif (talkState[talkUser] == TALKSTATE_MOON) then
			talkState[talkUser] = TALKSTATE_NONE
			doPlayerRemoveItem(cid, 14438, 1)
			doPlayerRemoveItem(cid, 14439, 1)
			doPlayerRemoveItem(cid, 14440, 1)
			doPlayerRemoveItem(cid, 14441, 1)
			doPlayerRemoveItem(cid, 14442, 1)
			doPlayerAddItem(cid, 10521)
			selfSay("Here it is!", cid)

		elseif (talkState[talkUser] == TALKSTATE_STAR) then
			talkState[talkUser] = TALKSTATE_NONE
			doPlayerRemoveItem(cid, 14438, 1)
			doPlayerRemoveItem(cid, 14439, 1)
			doPlayerRemoveItem(cid, 14440, 1)
			doPlayerRemoveItem(cid, 14441, 1)
			doPlayerRemoveItem(cid, 14442, 1)
			doPlayerAddItem(cid, 14449)
			selfSay("Here it is!", cid)

		elseif (talkState[talkUser] == TALKSTATE_YEREBLU) then
			talkState[talkUser] = TALKSTATE_NONE
			doPlayerRemoveItem(cid, 14438, 1)
			doPlayerRemoveItem(cid, 14439, 1)
			doPlayerRemoveItem(cid, 14440, 1)
			doPlayerRemoveItem(cid, 14441, 1)
			doPlayerRemoveItem(cid, 14442, 1)
			doPlayerAddItem(cid, 14450)
			selfSay("Here it is!", cid)
		end

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

setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local QUEST_STORAGE = 8039
local QUEST_LEVEL = 80
local MESSAGE_STORAGE = 8040
local TIME_STORAGE = 8041

local QUESTSTATUS_UNSTARTED = -1
local QUESTSTATUS_STARTED = 0
local QUESTSTATUS_FINISHED = 1
local QUESTSTATUS_WAITINGTIME = 2

local TALKSTATE_NONE = 0
local TALKSTATE_ACCEPTING = 1
local TALKSTATE_FINISHING = 2
local TALKSTATE_DELIVERING = 3

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'fossil') or msgcontains(msg, 'fosseis')) then
		local questStatus = getCreatureStorage(cid, QUEST_STORAGE)

		if (questStatus == QUESTSTATUS_UNSTARTED) then
			if (getCreatureStorage(cid, MESSAGE_STORAGE) == QUESTSTATUS_UNSTARTED) then
				if (getPlayerLevel(cid) >= QUEST_LEVEL) then
					selfSay("Oh! You have a message from my brother for me?", cid)
					npcHandler.talkState[talkUser] = TALKSTATE_DELIVERING

				else
					selfSay(string.format(__L(cid, "Sorry, you do not have the required level to accept this mission. The minimum is %s."), QUEST_LEVEL), cid)
					npcHandler.talkState[talkUser] = TALKSTATE_NONE
				end

			else
				selfSay("You want to help me in my excavations?", cid)
				npcHandler.talkState[talkUser] = TALKSTATE_ACCEPTING
			end

		elseif (questStatus == QUESTSTATUS_STARTED) then
			selfSay("You could find some fossil rock?", cid)
			npcHandler.talkState[talkUser] = TALKSTATE_FINISHING

		elseif (questStatus == QUESTSTATUS_WAITINGTIME) then
			local waitingTime = getCreatureStorage(cid, TIME_STORAGE)
			if (waitingTime < getCurrentTimeInSeconds()) then
				local fossil = table.random({12088, 12092})
				doPlayerAddItem(cid, fossil)
				doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_FINISHED)
				selfSay(string.format(__L(cid, "I have good news, you found a %s! Congratulations! Take him to my brother, he will help you to examine it."), getItemNameById(fossil)), cid)
			else
				selfSay("I'm still cleaning the fossil, come back later.", cid)
			end

			npcHandler.talkState[talkUser] = TALKSTATE_NONE

		else
			selfSay("Thank you for all the help I have no more missions for now. Give the fossil for my brother, he can help you.", cid)
			npcHandler.talkState[talkUser] = TALKSTATE_NONE
		end

	elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		if (npcHandler.talkState[talkUser] == TALKSTATE_DELIVERING) then
			if (getPlayerItemCount(cid, 14366) > 0) then -- Professor Josh Rock message to William Rock
				doPlayerRemoveItem(cid, 14366, 1)
				selfSay("Oh, thanks! So you want to help me in my excavations?", cid)
				npcHandler.talkState[talkUser] = TALKSTATE_ACCEPTING
				doCreatureSetStorage(cid, MESSAGE_STORAGE, QUESTSTATUS_FINISHED)

			else
				selfSay("Sorry, I do not know you. I do not need your help.", cid)
				npcHandler.talkState[talkUser] = TALKSTATE_NONE
			end

		elseif (npcHandler.talkState[talkUser] == TALKSTATE_ACCEPTING) then
			selfSay("Right! I think I'm very close to finding some fossils, I need your help. At the end of this cave there is a special rock, try to do some digging in it with this shovel. Good luck, be careful there!", cid)
			setItemUniqueOwner(doPlayerAddItem(cid, 5710), cid) -- Light Shovel
			doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_STARTED)
			npcHandler.talkState[talkUser] = TALKSTATE_NONE

		elseif (npcHandler.talkState[talkUser] == TALKSTATE_FINISHING) then
			if (getPlayerItemCount(cid, 14363) > 0) then -- Fossil Rock
				doPlayerRemoveItem(cid, 14363, 1)
				doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_WAITINGTIME)
				doCreatureSetStorage(cid, TIME_STORAGE, getCurrentTimeInSeconds() + 60 * 60)
				selfSay("Congratulations! You did it! Let me examine this rock, I'll clean it, come back in an hour.", cid)
			else
				selfSay("No.. you have not found.", cid)
			end

			npcHandler.talkState[talkUser] = TALKSTATE_NONE

		else
			selfSay("Sorry?", cid)
			npcHandler.talkState[talkUser] = TALKSTATE_NONE
		end

	elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
		selfSay("Ok!", cid)
		npcHandler.talkState[talkUser] = TALKSTATE_NONE

	else
		selfSay("Sorry, do not know what you're talking about.", cid)
		npcHandler.talkState[talkUser] = TALKSTATE_NONE
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

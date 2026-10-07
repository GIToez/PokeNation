setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local QUEST_STORAGE = 8037
local QUEST_LEVEL = 80
local TIME_STORAGE = 8038

local QUESTSTATUS_UNSTARTED = -1
local QUESTSTATUS_STARTED = 0
local QUESTSTATUS_FINISHED = 1
local QUESTSTATUS_WAITINGOMANYTEEGG = 2
local QUESTSTATUS_WAITINGKABUTOEGG = 3

local TALKSTATE_NONE = 0
local TALKSTATE_ACCEPTING = 1
local TALKSTATE_FINISHING = 2

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
			if (getPlayerLevel(cid) >= QUEST_LEVEL) then
				selfSay("I've been searching the fossil Pokemon for a long time, but could never get close to one. My brother William is doing an excavation in Mt Moon and said he was close to finding them, I need you to deliver a letter for him and help him find the fossils. Do you want help me?", cid)
				npcHandler.talkState[talkUser] = TALKSTATE_ACCEPTING
			else
				selfSay(string.format(__L(cid, "Sorry, you do not have the required level to accept this mission. The minimum is %s."), QUEST_LEVEL), cid)
				npcHandler.talkState[talkUser] = TALKSTATE_NONE
			end

		elseif (questStatus == QUESTSTATUS_STARTED) then
			selfSay("You could find a fossil?", cid)
			npcHandler.talkState[talkUser] = TALKSTATE_FINISHING

		elseif (questStatus == QUESTSTATUS_WAITINGOMANYTEEGG) then
			local eggTime = getCreatureStorage(cid, TIME_STORAGE)
			if (eggTime < getCurrentTimeInSeconds()) then
				doPlayerAddItem(cid, 14364) -- Omanyte Egg
				doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_FINISHED)
				selfSay("I managed to extract DNA from fossil and produce an egg! Here, take good care of it!", cid)
                doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.REVIVE_FOSSIL)
			else
				selfSay("I'm still studying the fossil, check back later.", cid)
			end

			npcHandler.talkState[talkUser] = TALKSTATE_NONE

		elseif (questStatus == QUESTSTATUS_WAITINGKABUTOEGG) then
			local eggTime = getCreatureStorage(cid, TIME_STORAGE)

			if (eggTime < getCurrentTimeInSeconds()) then
				doPlayerAddItem(cid, 14365) -- Kabuto Egg
				doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_FINISHED)
				selfSay("I managed to extract DNA from fossil and produce an egg! Here, take good care of it!", cid)
                doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.REVIVE_FOSSIL)
			else
				selfSay("I'm still studying the fossil, check back later.", cid)
			end

		else
			selfSay("You have helped me, thanks! If you want to hatch the egg go talk to the Old Lady and get an incubator.", cid)
			npcHandler.talkState[talkUser] = TALKSTATE_NONE
		end

	elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		if (npcHandler.talkState[talkUser] == TALKSTATE_ACCEPTING) then
			selfSay("My brother is in a dig at Mt Moon, go there find him, deliver this letter and ask about the fossils.", cid)
			doPlayerAddItem(cid, 14366) -- Professor Josh Rock message to William Rock
			doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_STARTED)
			npcHandler.talkState[talkUser] = TALKSTATE_NONE

		elseif (npcHandler.talkState[talkUser] == TALKSTATE_FINISHING) then
			if (getPlayerItemCount(cid, 12088) > 0) then -- Dome Fossil
				doPlayerRemoveItem(cid, 12088, 1)
				selfSay("You really did it! Congratulations! I'm seeing a real fossil! Thank you! I will start studying it now, come back 24 hours to see if there was any news.", cid)
				doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_WAITINGKABUTOEGG)
				doCreatureSetStorage(cid, TIME_STORAGE, getCurrentTimeInSeconds() + 60 * 60 * 24)

			elseif (getPlayerItemCount(cid, 12092) > 0) then -- Helix Fossil
				doPlayerRemoveItem(cid, 12092, 1)
				selfSay("You really did it! Congratulations! I'm seeing a real fossil! Thank you! I will start studying it now, come back 24 hours to see if there was any news.", cid)
				doCreatureSetStorage(cid, QUEST_STORAGE, QUESTSTATUS_WAITINGOMANYTEEGG)
				doCreatureSetStorage(cid, TIME_STORAGE, getCurrentTimeInSeconds() + 60 * 60 * 24)

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

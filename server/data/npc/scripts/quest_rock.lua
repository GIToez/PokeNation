setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local TALKSTATE_RENEW = 5
local refundStorage = 8202
local questStorage = 8023
-- Storage 8024 isnt used anymore, this was used to choose between hitmonchan and hitmonlee

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	--[[if (getCreatureStorage(cid, questStorage) == 1 and getCreatureStorage(cid, 8024) ~= 1) then
		if (isPlayerWithBackpackFull(cid)) then
			selfSay("Sorry, your backpack is full.", cid)

		elseif (msgcontains(msg, 'Hitmonchan')) then
			selfSay("Here, take care of it!", cid)
            doPlayerAddItem(cid, 14025, 1)
			doCreatureSetStorage(cid, 8024, 1)

		elseif (msgcontains(msg, 'Hitmonlee')) then
			selfSay("Here, take care of it!", cid)
            doPlayerAddItem(cid, 14024, 1)
			doCreatureSetStorage(cid, 8024, 1)

		else
			selfSay("So, you want a {Hitmonchan} or a {Hitmonlee}?", cid)
		end

	else]]if(msgcontains(msg, 'hungry') or msgcontains(msg, 'task') or msgcontains(msg, 'mission') or
            msgcontains(msg, 'final test') or msgcontains(msg, 'fome') or msgcontains(msg, 'missao') or msgcontains(msg, 'teste final')
			or msgcontains(msg, 'tarefa')) then
		if (getCreatureStorage(cid, refundStorage) == -1 and getCreatureStorage(cid, questStorage) == 1) then -- Quest done but with old reward
            selfSay("You've done this mission and has the old reward, I can renew your reward. Do you want it?", cid)
            npcHandler.talkState[talkUser] = TALKSTATE_RENEW
        else
            npcHandler.talkState[talkUser] = doQuestTalkStart(cid, "Rock")
        end

	elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		if (npcHandler.talkState[talkUser] == TALKSTATE_RENEW) then
            doPokemonRewardFix(cid, {"Hitmonlee", "Hitmonchan"}, refundStorage)
            npcHandler.talkState[talkUser] = 0

        else
            npcHandler.talkState[talkUser] = doQuestTalkEnd(cid, "Rock", npcHandler.talkState[talkUser])
        end

	else
		selfSay("What?", cid)
		npcHandler.talkState[talkUser] = 0
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

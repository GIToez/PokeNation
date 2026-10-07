setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local TALKSTATE_RENEW = 5
local refundStorage = 8203
local questStorage = 8016

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

	if(msgcontains(msg, 'Pokemon mansion') or msgcontains(msg, 'mansao pokemon')) then
		if (getCreatureStorage(cid, refundStorage) == -1 and getCreatureStorage(cid, questStorage) == 1) then -- Quest done but with old reward
            selfSay("You've done this mission and has the old reward, I can renew your reward. Do you want it?", cid)
            npcHandler.talkState[talkUser] = TALKSTATE_RENEW
        else
            npcHandler.talkState[talkUser] = doQuestTalkStart(cid, "Professor Mark")
        end

	elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		if (npcHandler.talkState[talkUser] == TALKSTATE_RENEW) then
            doPokemonRewardFix(cid, {"Porygon", "Ditto", "Mr. Mime"}, refundStorage)
            npcHandler.talkState[talkUser] = 0

        else
            npcHandler.talkState[talkUser] = doQuestTalkEnd(cid, "Professor Mark", npcHandler.talkState[talkUser])
        end

	else
		selfSay("Hmm?", cid)
		npcHandler.talkState[talkUser] = 0
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

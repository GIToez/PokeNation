setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local name = "PokeMart"

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

	return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (getCreatureStorage(cid, 8359) == QUEST_STATUS.STARTED and -- Quest Started and package isn't get yet
            getCreatureStorage(cid, 8367) ~= QUEST_STATUS.FINISHED) then
        npcHandler.talkState[cid] = doQuestTalk(cid, name, "quest", npcHandler.talkState[cid])
		npcHandler:addFocus(cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())

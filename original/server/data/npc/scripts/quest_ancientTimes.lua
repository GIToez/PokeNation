setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	npcHandler.talkState[cid] = doQuestTalk(cid, "Ancient Times", msg, npcHandler.talkState[cid])

	return true
end

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getCreatureStorage(cid, 8328) == QUEST_STATUS.STARTED) then -- Orange Archipelago Main #3 completed?
        npcHandler.talkState[cid] = doQuestTalk(cid, "Ancient Times", "quest", npcHandler.talkState[cid])
        npcHandler:addFocus(cid)
    else
        selfSay("You're not ready...", cid)
    end
    return false
end)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

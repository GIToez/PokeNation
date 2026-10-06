setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

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

    if (getCreatureStorage(cid, 8345) == QUEST_STATUS.FINISHED and (msgcontains(msg, 'letter') or msgcontains(msg, 'carta'))) then
        selfSay("You understand my dilemma? She did not want me anymore... and nothing I do can {help} me.", cid)

    else
		npcHandler.talkState[talkUser] = doQuestTalk(cid, "Juanito Cruz", msg, npcHandler.talkState[talkUser])
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

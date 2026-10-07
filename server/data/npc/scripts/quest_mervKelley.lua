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
	npcHandler.talkState[talkUser] = doQuestTalk(cid, "Merv Kelley", msg, npcHandler.talkState[talkUser])

	return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    local status = getCreatureStorage(cid, 8229)
    if (status == QUEST_STATUS.UNSTARTED) then -- Last quest of the chain
        npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, my name is Merv Kelley, I'm a Pokemon researcher, currently study on the behavior of Pokemon insects when feed with fruits, but I'm now experiencing terrible {problems}.")
    elseif (status == QUEST_STATUS.STARTED) then
        npcHandler:setMessage(MESSAGE_GREET, "Hey! How are you doing?")
    else
        npcHandler:setMessage(MESSAGE_GREET, "Hey! Have you heard the latest rumors? There is a mysterious legend in the Orange Archipelago, my friend Adventurer Lucy has not slept in days behind it.")
    end

    return true
end)

npcHandler:addModule(FocusModule:new())

setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local questStorage = 8352

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'quest') or msgcontains(msg, 'mission') or msgcontains(msg, 'missao')) then
        if (getCreatureStorage(cid, questStorage) == QUEST_STATUS.STARTED) then
            selfSay("How are you doing? Keep helping us please!", cid)
        else
            doCreatureSetStorage(cid, questStorage, QUEST_STATUS.STARTED)
            selfSay("We need help here. Talk to those who are to receive mission offers.", cid)
        end

	else
		selfSay("Sorry? I think I can't help you.", cid)
    end

	return true
end)
npcHandler:addModule(FocusModule:new())

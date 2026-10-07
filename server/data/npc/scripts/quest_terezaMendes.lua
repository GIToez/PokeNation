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

    if (getCreatureStorage(cid, 8248) == QUEST_STATUS.STARTED) then
        if (msgcontains(msg, 'juanito')) then
            selfSay("He's needing {help}? Oh my.", cid)
            return true

        elseif (msgcontains(msg, 'help') or msgcontains(msg, 'ajuda')) then
            selfSay("Since our childhood I wait for it... does he want me now? I need a new {lipstick} first.", cid)
            return true
        end
    end

    npcHandler.talkState[talkUser] = doQuestTalk(cid, "Tereza Mendes", msg, npcHandler.talkState[talkUser])
	return true
end)

npcHandler:addModule(FocusModule:new())

setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'rock')) then
		selfSay("Rock? It is an old friend. Hehe, time does not see it.", cid)

		if (getCreatureStorage(cid, 8020) == 0 and getCreatureStorage(cid, 8021) ~= 1) then -- Doing Rock Task
			selfSay("Also, I got a letter to deliver to him. You do this favor for me?", cid)
			npcHandler.talkState[talkUser] = 1
		end

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and npcHandler.talkState[talkUser] == 1) then
		selfSay("Ok, here is.", cid)
		doPlayerAddItem(cid, 13011, 1, true)
		doCreatureSetStorage(cid, 8021, 1)
		npcHandler.talkState[talkUser] = 0
	end

	return true
end)
npcHandler:addModule(FocusModule:new())

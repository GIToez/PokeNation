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

	if (getCreatureStorage(cid, 8028) == 1 and getCreatureStorage(cid, 8029) ~= 1) then
		if (msgcontains(msg, 'fire')) then
			doPlayerAddItem(cid, 18083, 1, true)
			doCreatureSetStorage(cid, 8029, 1)
			selfSay("Congratulations! You've received a Fire Stone!", cid)

		elseif (msgcontains(msg, 'water')) then
			doPlayerAddItem(cid, 18088, 1, true)
			doCreatureSetStorage(cid, 8029, 1)
			selfSay("Congratulations! You've received a Water Stone!", cid)

		elseif (msgcontains(msg, 'leaf')) then
			doPlayerAddItem(cid, 18086, 1, true)
			doCreatureSetStorage(cid, 8029, 1)
			selfSay("Congratulations! You've received a Leaf Stone!", cid)

		else
			selfSay("You can choose a {Fire Stone} or a {Water Stone} or a {Leaf Stone}. What is your choice?", cid)
		end

	else
		npcHandler.talkState[talkUser] = doQuestTalk(cid, "George Carter", msg, npcHandler.talkState[talkUser])
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

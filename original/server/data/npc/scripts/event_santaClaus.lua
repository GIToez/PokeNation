setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if(msgcontains(msg, 'mission') or msgcontains(msg, 'help') or msgcontains(msg, 'save') or msgcontains(msg, 'missao') or msgcontains(msg, 'ajuda') or msgcontains(msg, 'salvar')) then
		talkState[talkUser] = doQuestTalkStart(cid, "Santa Claus")

	elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		talkState[talkUser] = doQuestTalkEnd(cid, "Santa Claus", talkState[talkUser])

	else
		selfSay("Hmm?", cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

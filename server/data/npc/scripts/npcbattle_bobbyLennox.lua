local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9300, 9700, npcHandler)
npcBattle:setPokemons({"Sandslash", "Persian", "Tentacruel", "Arcanine", "Pinsir"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(65)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setRequired(function(cid) return getCreatureStorage(cid, 8542) == QUEST_STATUS.STARTED end)
npcBattle:setOnEnd(function(cid, playerWin, npc)
	if (playerWin and doCreatureIncreaseStorage(cid, 8543) >= 4) then
		doPlayerSafeAddItem(cid, 25263, 1, true, true)
	end
end)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
		talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

	elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

	else
		selfSay("Ok..", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

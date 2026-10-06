local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9257, 9657, npcHandler)
npcBattle:setPokemons({"Sunflora", "Jumpluff", "Azumarill", "Ampharos", "Lanturn", "Octillery", "Skarmory"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardUniqueItems({18169, 1})
npcBattle:setDifficulty(78)
npcBattle:setOneWin(true)
npcBattle:setRequired(function(cid) return getCreatureStorage(cid, 8228) == QUEST_STATUS.STARTED end)
npcBattle:setPokemonDefeatExperienced(true)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'orenji') or msgcontains(msg, 'fruit')) then
        selfSay("So you're interested in the Orenji fruit? I can give you one if you won a {battle} against me.", cid)

    elseif (msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel')) then
		talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

	elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

	else
		selfSay("Ok..", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

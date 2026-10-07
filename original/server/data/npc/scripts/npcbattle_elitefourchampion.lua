local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9296, 9696, npcHandler)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(100)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setPokemonTeamEvolvable(false)
npcBattle:setPokemonExtraStats(0.3)
npcBattle:setRewardItems({25048, 1}) -- Empty Elemental Stone
npcBattle:setOnEnd(function(cid, playerWin, npc)
	if (playerWin) then
		doSendMagicEffect(getCreaturePosition(npc), EFFECT_TELEPORT_UP)
		EliteFour.doRegisterChampion(cid)
		EliteFour.doRemovePlayer(cid)
	else
		EliteFour.onPlayerLoose(cid)
	end
	doRemoveCreature(npc)
end)

local battleing = nil
function onCreatureMove(cid, oldPos, newPos)
	if (isPlayer(cid) and not battleing and getDistanceBetween(getNpcPos(), newPos) <= 8) then
		battleing = true
		npcBattle:setPokemons(EliteFour.getChampionPokemonTeam())
		npcBattle:setPokemonMovesets(EliteFour.getChampionPokemonTeamMovesets())
		--npcBattle:doForceBattleStart(getNpcId(), cid)
		EliteFour.doMemberTalk(cid, getNpcId(), EliteFour.MEMBER_IDS.CHAMPION, npcBattle)
	end
end

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

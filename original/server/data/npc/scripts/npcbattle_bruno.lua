local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9288, 9688, npcHandler)
npcBattle:setPokemons({"Onix", "Hitmonchan", "Hitmonlee", "Onix", "Machamp", "Primeape"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(100)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setPokemonExtraStats(0.3)
npcBattle:setOnEnd(function(cid, playerWin, npc)
	if (playerWin) then
		doSendMagicEffect(getCreaturePosition(npc), EFFECT_TELEPORT_UP)
		doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.ELITE_FOUR_BRUNO)
	else
		EliteFour.onPlayerLoose(cid)
	end
	doRemoveCreature(npc)
end)

local tmp = {}
for i, pokemon in pairs(npcBattle:getPokemons()) do
	tmp[i] = getPokemonDefaultSkills(pokemon)
	for j = 1, 3 do
		local tries = 0
		while (true) do
			local move = table.random(getPokemonLearnableTms(pokemon))
			if (getPokemonSkillExists(move)) then
				tmp[i][#tmp[i] + 1] = move
			end

			if (tries >= 1000) then
				break
			end

			tries = tries + 1
		end
	end
end
npcBattle:setPokemonMovesets(tmp)
tmp = nil

local talking = nil
function onCreatureMove(cid, oldPos, newPos)
	if (isPlayer(cid) and not talking and getDistanceBetween(getNpcPos(), newPos) <= 8) then
		talking = true
		EliteFour.doMemberTalk(cid, getNpcId(), EliteFour.MEMBER_IDS.BRUNO, npcBattle)
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

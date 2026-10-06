local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9290, 9690, npcHandler)
npcBattle:setPokemons({"Gyarados", "Dragonair", "Dragonair", "Aerodactyl", "Dragonite", "Gyarados"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(100)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setPokemonExtraStats(0.3)
npcBattle:setOnEnd(function(cid, playerWin, npc)
	if (playerWin) then
		doSendMagicEffect(getCreaturePosition(npc), EFFECT_TELEPORT_UP)
		doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.ELITE_FOUR_LANCE)
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
npcBattle:setPokemonMovesets(
	tmp
	--[[{
		-- Gyarados
		{
			"Tackle", "Bite", "Headbutt", "Thrash", "Water Gun", "Twister", "Aqua Tail", "Hydro Pump", "Rain Dance", "Hydro Cannon", "Hyper Beam", "Avalanche", "Zap Cannon", "Ice Beam", "Blizzard"
		},
		-- Dragonair
		{
			"Tackle", "Slam", "Thunder Wave", "Twister", "Dragon Tail", "Agility", "Aqua Tail", "Outrage", "Hyper Beam", "Flamethrower", "Zap Cannon", "Thunderbolt", "Mimic"
		},
		-- Dragonair
		{
			"Tackle", "Slam", "Thunder Wave", "Twister", "Dragon Tail", "Agility", "Aqua Tail", "Outrage", "Hyper Beam", "Double Team", "Bide", "Fire Blast", "Rest"
		},
		-- Aerodactyl
		{
			"Tackle", "Ice Fang", "Fire Fang", "Thunder Fang", "Wing Attack", "Supersonic", "Bite", "Scary Face", "Agility", "Ancient Power", "Crunch", "Take Down", "Hyper Beam", "Rock Slide", "Giga Impact", "Substitute", "Earthquake", "Fire Blast"
		},
		-- Dragonite
		{
			"Tackle", "Slam", "Thunder Wave", "Twister", "Dragon Tail", "Agility", "Aqua Tail", "Outrage", "Hyper Beam", "Fire Punch", "Thunder Punch", "Wing Attack", "Dragon Dance", "Hurricane", "Rock Tomb", "Fire Punch", "Thunder Punch", "Ice Punch"
		},
		-- Gyarados
		{

		}
	}]]
)
tmp = nil

local talking = nil
function onCreatureMove(cid, oldPos, newPos)
	if (isPlayer(cid) and not talking and getDistanceBetween(getNpcPos(), newPos) <= 8) then
		talking = true
		EliteFour.doMemberTalk(cid, getNpcId(), EliteFour.MEMBER_IDS.LANCE, npcBattle)
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

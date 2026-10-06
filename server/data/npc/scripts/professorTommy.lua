local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local EMPTY_SOUL_BALL_ID = 13492
local CHARGED_SOUL_BALL_ID = 13494
local UNCHARGED_SOUL_BALL_ID = 13495
local SPECIAL_SMALL_STONE_ID = 13497
local UNLOCKED_BACKPACK_ID = 12282
local LOCKED_BACKPACK_ID = 13499

local RANDOM_POKEMON = {"Rattata", "Caterpie", "Weedle"}

local TALK_STATE_CITY_CHOOSE = 1
local TALK_STATE_CITY_VIRIDIAN = 2
local TALK_STATE_CITY_PEWTER = 3
local TALK_STATE_CITY_CERULEAN = 4
local TALK_STATE_CITY_SAFFRON = 5
local TALK_STATE_CITY_CELADON = 6
local TALK_STATE_CITY_VERMILION = 7
local TALK_STATE_CITY_FUCHSIA = 8
local TALK_STATE_CITY_CINNABAR = 9
local TALK_STATE_SKIP_ISLAND = 10

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'pokemon')) then
		selfSay("{PT-BR}: Voc� est�� nesta ilha para capturar seu primeiro Pokemon, tente capturar um usando as suas pedras e depois usando a soul ball. Depois disso venha conversar comigo sobre sua {jornada}. A qualquer momento voc� pode sair desta ilha, diga '{sair}'.", cid)
		selfSay("{EN-US}: You are on this island to capture your first Pokemon, try to capture a wild with your special small stones and your empty soul ball. After that come to talk about your {journey}. Anytime you can get off this island, just say '{skip}'.", cid)

	elseif (msgcontains(msg, 'skip') or msgcontains(msg, 'sair')) then
		talkState[talkUser] = TALK_STATE_SKIP_ISLAND
		selfSay("{PT-BR}: Para qual cidade voc� quer ir? Vou lhe dar um Pokemon caso voc� n�o tenha um.", cid)
		selfSay("{EN-US} To which city you want to go? I will give you a Pokemon if you dont have one.", cid)
		selfSay("({Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia}, {Cinnabar}.)", cid)

	elseif (msgcontains(msg, 'journey') or msgcontains(msg, 'jornada')) then
		if (#getPlayerAllBallsWithPokemon(cid) > 1) then
			selfSay("{PT-BR}: Voc� n�o pode sair daqui com mais de um Pokemon!", cid)
			selfSay("{EN-US} You can't leave with more then one Pokemon!", cid)

		elseif (getPlayerItemCount(cid, SPECIAL_SMALL_STONE_ID) > 0 or getPlayerItemCount(cid, EMPTY_SOUL_BALL_ID) > 0) then
			selfSay("{PT-BR}: Voc� n�o pode sair des ilha caso esteja com soul balls vazias ou pedras.", cid)
			selfSay("{EN-US}: You can't leave this island if you are with empty soul balls or special small stones.", cid)

		else
			talkState[talkUser] = TALK_STATE_CITY_CHOOSE

			selfSay("{PT-BR}: Parab�ns na sua primeira captura! Agora voc� deve ir para o pr�ximo continente para come�ar sua jornada. Para qual cidade voc� quer ir?", cid)
			selfSay("{EN-US}: Congratulations on your first catch! Now you must go to the next continent to start your journey. To which city you want to go?", cid)
			selfSay("({Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia}, {Cinnabar}.)", cid)
		end

	elseif (talkState[talkUser] == TALK_STATE_SKIP_ISLAND) then
		local townId
		if (msgcontains(msg, "viridian")) then
			townId = getTownId("viridian")

		elseif (msgcontains(msg, "pewter")) then
			townId = getTownId("pewter")

		elseif (msgcontains(msg, "cerulean")) then
			townId = getTownId("cerulean")

		elseif (msgcontains(msg, "saffron")) then
			townId = getTownId("saffron")

		elseif (msgcontains(msg, "celadon")) then
			townId = getTownId("celadon")

		elseif (msgcontains(msg, "vermilion")) then
			townId = getTownId("vermilion")

		elseif (msgcontains(msg, "fuchsia")) then
			townId = getTownId("fuchsia")

		elseif (msgcontains(msg, "cinnabar")) then
			townId = getTownId("cinnabar")

		else
			selfSay("{PT-BR}: Por favor repita, suas op��es s�o: {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia} ou {Cinnabar}.", cid)
			selfSay("{EN-US}: Please re-peat, your options are: {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia} or {Cinnabar}.", cid)
			return true
		end

		doPlayerRemoveItem(cid, 13820, getPlayerItemCount(cid, 13820)) -- Removing start cookies
		doPlayerRemoveItem(cid, EMPTY_SOUL_BALL_ID, getPlayerItemCount(cid, EMPTY_SOUL_BALL_ID))
		doPlayerRemoveItem(cid, SPECIAL_SMALL_STONE_ID, getPlayerItemCount(cid, SPECIAL_SMALL_STONE_ID))

		local playerBallsWithPokemon = getPlayerAllBallsWithPokemon(cid)
		if (#playerBallsWithPokemon == 0) then
			doCreatePokemonBall(cid, "soul", RANDOM_POKEMON[math.random(1, #RANDOM_POKEMON)], 5, nil, nil, 0, cid, false, nil, nil)

		elseif (#playerBallsWithPokemon > 1) then
			local i, ball
			for i, ball in ipairs(playerBallsWithPokemon) do
				if (i ~= #playerBallsWithPokemon) then -- dont remove the last ball, let the player with one ball, remove all others
					doRemoveItem(ball.uid)
				end
			end
		end

		local lockedBackpack = getPlayerItemById(cid, true, LOCKED_BACKPACK_ID)
		if (isItem(lockedBackpack)) then
			doTransformItem(lockedBackpack.uid, UNLOCKED_BACKPACK_ID)
		end

		local playerLevel = getPlayerLevel(cid)
		if (playerLevel < 5) then
			doPlayerAddLevel(cid, 5 - playerLevel, round)
		end

		doPlayerAddMainItems(cid)
		doTeleportThing(cid, getTownTemplePosition(townId), false)
		doPlayerSetTown(cid, townId)
		selfSay("{PT-BR}: Certo, boa sorte!", cid)
		selfSay("{EN-US}: Alright, good luck!", cid)

	elseif (talkState[talkUser] == TALK_STATE_CITY_CHOOSE) then
		if (msgcontains(msg, "viridian")) then
			talkState[talkUser] = TALK_STATE_CITY_VIRIDIAN
			selfSay("{PT-BR}: Viridian, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Viridian, are you sure? {Yes} or {No}", cid)

		elseif (msgcontains(msg, "pewter")) then
			talkState[talkUser] = TALK_STATE_CITY_PEWTER
			selfSay("{PT-BR}: Pewter, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Pewter, are you sure? {Yes} or {No}", cid)

		elseif (msgcontains(msg, "Cerulean")) then
			talkState[talkUser] = TALK_STATE_CITY_CERULEAN
			selfSay("{PT-BR}: Cerulean, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Cerulean, are you sure? {Yes} or {No}", cid)

		elseif (msgcontains(msg, "Saffron")) then
			talkState[talkUser] = TALK_STATE_CITY_SAFFRON
			selfSay("{PT-BR}: Saffron, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Saffron, are you sure? {Yes} or {No}", cid)

		elseif (msgcontains(msg, "Celadon")) then
			talkState[talkUser] = TALK_STATE_CITY_CELADON
			selfSay("{PT-BR}: Celadon, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Celadon, are you sure? {Yes} or {No}", cid)

		elseif (msgcontains(msg, "Vermilion")) then
			talkState[talkUser] = TALK_STATE_CITY_VERMILION
			selfSay("{PT-BR}: Vermilion, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Vermilion, are you sure? {Yes} or {No}", cid)

		elseif (msgcontains(msg, "Fuchsia")) then
			talkState[talkUser] = TALK_STATE_CITY_FUCHSIA
			selfSay("{PT-BR}: Fuchsia, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Fuchsia, are you sure? {Yes} or {No}", cid)

		elseif (msgcontains(msg, "Cinnabar")) then
			talkState[talkUser] = TALK_STATE_CITY_CINNABAR
			selfSay("{PT-BR}: Cinnabar, tem certeza? {Sim} ou {Nao}", cid)
			selfSay("{EN-US}: Cinnabar, are you sure? {Yes} or {No}", cid)

		else
			talkState[talkUser] = TALK_STATE_CITY_CHOOSE
			selfSay("{PT-BR}: Por favor repita, suas op�oees s�o: {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia} ou {Cinnabar}.", cid)
			selfSay("{EN-US}: Please re-peat, your options are: {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion}, {Fuchsia} or {Cinnabar}.", cid)
		end

	elseif (msgcontains(msg, "yes") or msgcontains(msg, "sim")) then
		local ballsWithPokemon = #getPlayerAllBallsWithPokemon(cid)
		if (ballsWithPokemon > 1) then
			talkState[talkUser] = 0

			selfSay("{PT-BR}: Voc� n�o pode sair daqui com mais de um Pokemon!", cid)
			selfSay("{EN-US} You can't leave with more then one Pokemon!", cid)

		elseif (getPlayerItemCount(cid, SPECIAL_SMALL_STONE_ID) > 0 or getPlayerItemCount(cid, EMPTY_SOUL_BALL_ID) > 0) then
			talkState[talkUser] = 0

			selfSay("{PT-BR}: Voc� n�o pode sair des ilha caso esteja com soul balls vazias ou pedras.", cid)
			selfSay("{EN-US}: You can't leave this island if you are with empty soul balls or special small stones.", cid)

		else
			local newTownId
			if (talkState[talkUser] == TALK_STATE_CITY_VIRIDIAN) then
				newTownId = 1
			elseif (talkState[talkUser] == TALK_STATE_CITY_PEWTER) then
				newTownId = 2
			elseif (talkState[talkUser] == TALK_STATE_CITY_CERULEAN) then
				newTownId = 3
			elseif (talkState[talkUser] == TALK_STATE_CITY_SAFFRON) then
				newTownId = 4
			elseif (talkState[talkUser] == TALK_STATE_CITY_CELADON) then
				newTownId = 5
			elseif (talkState[talkUser] == TALK_STATE_CITY_VERMILION) then
				newTownId = 6
			elseif (talkState[talkUser] == TALK_STATE_CITY_FUCHSIA) then
				newTownId = 8
			elseif (talkState[talkUser] == TALK_STATE_CITY_CINNABAR) then
				newTownId = 9
			else
				selfSay("Ok...", cid)
				talkState[talkUser] = 0
			end

			if (newTownId ~= nil) then
				local lockedBackpack = getPlayerItemById(cid, true, LOCKED_BACKPACK_ID)
				if (isItem(lockedBackpack)) then
					doTransformItem(lockedBackpack.uid, UNLOCKED_BACKPACK_ID)
				end

				local playerLevel = getPlayerLevel(cid)
				if (playerLevel < 5) then
					doPlayerAddLevel(cid, 5 - playerLevel, round)
				end

				if (ballsWithPokemon == 0) then
					doCreatePokemonBall(cid, "soul", RANDOM_POKEMON[math.random(1, #RANDOM_POKEMON)], 5, nil, nil, 0, cid, false, nil, nil)
				end

				doPlayerRemoveItem(cid, 13820, getPlayerItemCount(cid, 13820)) -- Removing start cookies
				doTeleportThing(cid, getTownTemplePosition(newTownId), false)
				doPlayerSetTown(cid, newTownId)
				doPlayerAddMainItems(cid)

				selfSay("{PT-BR}: Certo, boa sorte!", cid)
				selfSay("{EN-US}: Alright, good luck!", cid)
			end
		end

	else
		selfSay("Hmm?", cid)
		talkState[talkUser] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

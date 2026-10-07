local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function doPlayerBallsRemoveUnique(cid, balls)
    for _, ball in pairs(balls) do
        if (isItemUnique(ball.uid) and getBallUniqueFromTournament(ball.uid)) then
            doItemEraseUniqueOwner(ball.uid)
            setBallUniqueFromTournament(ball.uid, false)
        end
    end
end

local TALKSTATE_NONE = 0
local TALKSTATE_LEAVE = 1

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'leave') or msgcontains(msg, 'exit') or msgcontains(msg, 'sair')) then
		selfSay("You really want to leave this room? You can be disqualified for that tournament.", cid)
		talkState[talkUser] = TALKSTATE_LEAVE

	elseif (talkState[talkUser] == TALKSTATE_LEAVE) then
		if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
			if (getPlayerActiveTournamentId(cid) and getTournamentInfo(getPlayerActiveTournamentId(cid)) and getTournamentInfo(getPlayerActiveTournamentId(cid)).started) then
				selfSay("Sorry, you cannot leave right now.", cid)
				return true
			end

			if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
				selfSay("You can not do it while you have a Pokemon out of the ball.", cid)
				return true
			end

			doPlayerRemoveEpicBalls(cid)
            doPlayerBallsRemoveUnique(cid, getPlayerAllBallsWithPokemon(cid))
            setPlayerTournamentReady(cid, false)
			doTeleportThing(cid, {x = 4721, y = 118, z = 7})
			talkState[talkUser] = TALKSTATE_NONE
			selfSay("Here you go!", cid)

		else
			selfSay("Ok...", cid)
		end

		talkState[talkUser] = TALKSTATE_NONE

	else
		selfSay("Sorry?", cid)
		talkState[talkUser] = TALKSTATE_NONE
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local STATE_LEAVE = 1

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'saffari') or msgcontains(msg, 'zone') or msgcontains(msg, 'safari') or msgcontains(msg, 'zona')) then
		selfSay("Safari the largest of these lands, here you will find many species of Pokemon, many of the same, so be very careful!", cid)

	elseif (msgcontains(msg, 'leave') or msgcontains(msg, 'back') or msgcontains(msg, 'city') or msgcontains(msg, 'fuchsia') or msgcontains(msg, 'sair')) then
		selfSay("Alright, do you want to back to Fuchsia City?", cid)
		talkState[talkUser] = STATE_LEAVE

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == STATE_LEAVE) then
		doTeleportThing(cid, SAFARI_ENTRANCE_POSITION, false)
		doPlayerRemoveSafariZoneItems(cid)
		talkState[talkUser] = 0
		setSafariZone(cid, false)
        setPlayerDisconnectAtExit(cid, true)

	else
		selfSay("Uh?")
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

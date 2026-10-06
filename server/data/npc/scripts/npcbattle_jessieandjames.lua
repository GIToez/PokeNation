local function getRocketsNextPosition(nid)
	local pos = getCreaturePosition(nid)
	if (pos.x == 398 and pos.y == 915 and pos.z == 7) then
		return {x = 2824, y = 597, z = 7}  -- TODO POS FIX
	elseif (pos.x == 474 and pos.y == 597 and pos.z == 7) then
		return {x = 2825, y = 288, z = 7}
	elseif (pos.x == 475 and pos.y == 288 and pos.z == 7) then
		return {x = 3387, y = 239, z = 7}
	elseif (pos.x == 1037 and pos.y == 239 and pos.z == 7) then
		return {x = 3384, y = 368, z = 6}
	elseif (pos.x == 1034 and pos.y == 368 and pos.z == 6) then
		return {x = 3233, y = 412, z = 7}
	elseif (pos.x == 883 and pos.y == 412 and pos.z == 7) then
		return {x = 3549, y = 512, z = 7}
	elseif (pos.x == 1199 and pos.y == 512 and pos.z == 7) then
		return {x = 3371, y = 620, z = 7}
	elseif (pos.x == 1021 and pos.y == 620 and pos.z == 7) then
		return {x = 3263, y = 783, z = 6}
	elseif (pos.x == 913 and pos.y == 783 and pos.z == 6) then
		return {x = 2847, y = 555, z = 7}
	elseif (pos.x == 497 and pos.y == 555 and pos.z == 7) then
		return {x = 3360, y = 179, z = 7}
	elseif (pos.x == 1010 and pos.y == 179 and pos.z == 7) then
		return {x = 3202, y = 394, z = 7}
	elseif (pos.x == 852 and pos.y == 394 and pos.z == 7) then
		return {x = 3378, y = 644, z = 7}
	elseif (pos.x == 1028 and pos.y == 644 and pos.z == 7) then
		return {x = 2759, y = 881, z = 7}
	elseif (pos.x == 1028 and pos.y == 644 and pos.z == 7) then
		return {x = 2843, y = 264, z = 7}
	elseif (pos.x == 493 and pos.y == 264 and pos.z == 7) then
		return {x = 3358, y = 415, z = 6}
	elseif (pos.x == 1008 and pos.y == 415 and pos.z == 6) then
		return {x = 3341, y = 579, z = 7}
	elseif (pos.x == 991 and pos.y == 579 and pos.z == 7) then
		return {x = 3258, y = 809, z = 7}
	elseif (pos.x == 908 and pos.y == 809 and pos.z == 7) then
		return {x = 3236, y = 430, z = 7}
	elseif (pos.x == 886 and pos.y == 430 and pos.z == 7) then
		return {x = 3396, y = 237, z = 7}
	elseif (pos.x == 1046 and pos.y == 237 and pos.z == 7) then
		return {x = 2804, y = 574, z = 7}
	elseif (pos.x == 454 and pos.y == 574 and pos.z == 7) then
		return {x = 3437, y = 623, z = 7}
	elseif (pos.x == 1087 and pos.y == 623 and pos.z == 7) then
		return {x = 2779, y = 914, z = 7}
	else
		return {x = 2748, y = 915, z = 7}
	end
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9139, 9525, npcHandler)
npcBattle:setPokemons({"Arbok", "Victreebel", "Weezing", "Venusaur", "Charizard", "Blastoise"})
npcBattle:setRewardBaseExp(2000)
npcBattle:setRewardItems({14636, 2, 14637, 2, 14638, 2})
npcBattle:setDifficulty(NPC_DIFFICULTY_DYNAMIC)
npcBattle:setOnWin(function(nid) doCreatureSay(nid, "Team Rocket blasting off again.", TALKTYPE_SAY) doSendMagicEffect(getCreaturePosition(nid), EFFECT_TELEPORT_TWO) addEvent(doCreateNpc, 10 * 60 * 1000, "Jessie and James", getRocketsNextPosition(nid)) doRemoveCreature(nid) end)

local canBattle = false
local speeching = false

local function speech(cid)
	speeching = true
	addEvent(doCreatureSay, 1000, cid, "Jessie - Prepare for trouble!", TALKTYPE_SAY)
	addEvent(doCreatureSay, 3000, cid, "James - And make it double!", TALKTYPE_SAY)

	addEvent(doCreatureSay, 6000, cid, "Jessie - To protect the world from devastation!", TALKTYPE_SAY)
	addEvent(doCreatureSay, 7000, cid, "James - To unite all people within our nation!", TALKTYPE_SAY)

	addEvent(doCreatureSay, 10000, cid, "Jessie - To denouce the evils of truth and love!", TALKTYPE_SAY)
	addEvent(doCreatureSay, 11000, cid, "James - To extend our reach to the stars above!", TALKTYPE_SAY)

	addEvent(doCreatureSay, 14000, cid, "Jessie - Jessie!", TALKTYPE_SAY)
	addEvent(doCreatureSay, 15000, cid, "James - James!", TALKTYPE_SAY)

	addEvent(doCreatureSay, 18000, cid, "Jessie - Team Rocket blasting off at the speed of light!", TALKTYPE_SAY)
	addEvent(doCreatureSay, 19000, cid, "James - Surrender now or prepare to fight!", TALKTYPE_SAY)
	addEvent(doCreatureSay, 21000, cid, "Meowth - Meoow, That's right!", TALKTYPE_SAY)

	addEvent(function() canBattle = true end, 20000)
end

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
	if (getNpcId() == cid) then
		canBattle = false
		speeching = false
	end
end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)
	if (not canBattle and not speeching and NpcHandler:isInRange(cid) and msg == 'hi') then
		speech(getNpcId())
	else
		npcHandler:onCreatureSay(cid, type, msg)
	end
end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (canBattle) then
		if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
		    talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

        elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

		else
			selfSay("Ok..", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
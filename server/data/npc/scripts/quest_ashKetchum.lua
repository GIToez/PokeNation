setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local KIDNAPPED_ASH_POSITION = {x = 5207, y = 502, z = 7}
local END_POSITION = {x = 5191, y = 515, z = 7}
local QUEST_STORAGE = 8525
local KANTOMAIN12_ASH_POSITION = {x = 5518, y = 236, z = 6}
--local ASH_TELEPORTING_STORAGE = 1000

local EVENT = nil
local following = nil

local function onEndFollowing(cid, fail, npcId)
	local function resetAsh()
		doSendMagicEffect(getCreaturePosition(npcId), EFFECT_TELEPORT_UP)
		doTeleportThing(npcId, KIDNAPPED_ASH_POSITION, false)
		doSendMagicEffect(KIDNAPPED_ASH_POSITION, EFFECT_TELEPORT_DOWN)
		following = nil
		doCreatureFollowCreature(npcId, nil, true) -- Release follow
	end

	if (not fail) then
		doCreatureSetStorage(cid, QUEST_STORAGE, QUEST_STATUS.FINISHED)
		doCreatureSay(npcId, __L(cid, "Thank you. We have not much time before they come after us with everything again. I'll hide for a while. Tell Bill and Gary that I will be in the usual place. Thanks again, trainer."), TALKTYPE_SAY)
		addEvent(resetAsh, 5000)
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Ash is no longer following you.")
		resetAsh()
	end

	EVENT = nil
end

local function onStartFollowing(cid)
	doCreatureFollowCreature(getNpcId(), cid)
	selfSay("I will follow you! Let's go!", cid)
	following = true
	npcHandler:releaseFocus(cid)

	local onFollow
	onFollow = function(npcId)
		if (not isCreature(npcId)) then
			log(LOG_TYPES.ERROR, "quest_ashKetchum::onFollow - Unknown npcId", getCreatureName(cid))
			return
		end

		if (not isCreature(cid)) then
			onEndFollowing(cid, true, npcId)
			return

		elseif (getCreatureFollowCreature(npcId) ~= cid) then
			if (getDistanceBetween(getCreaturePosition(npcId), getCreaturePosition(cid)) <= 8) then
				-- This bug occurs when the player changes his visibility
				doCreatureFollowCreature(npcId, nil, true) -- Release follow
				doCreatureFollowCreature(npcId, cid)
			else
				onEndFollowing(cid, true, npcId)
				return
			end
		end

		--if (getCreatureStorage(cid, ASH_TELEPORTING_STORAGE) <= 0) then
		local pos = getCreaturePosition(npcId)
		if (getDistanceBetween(pos, getCreaturePosition(cid)) > 8) then
			onEndFollowing(cid, true, npcId)
			return

		elseif (getDistanceBetween(pos, END_POSITION) <= 3) then
			onEndFollowing(cid, false, npcId)
			return
		end
		--end

		EVENT = addEvent(onFollow, 250, npcId)
	end

	onFollow(getNpcId())
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if (following) then
		return false
	end

	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (getSamePosition(getNpcPos(), KIDNAPPED_ASH_POSITION) and
			getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.FINISHED) then
		if (following) then
			return true
		end

		if (msgcontains(msg, 'help') or msgcontains(msg, 'ajude')) then
			onStartFollowing(cid)

		else
			selfSay("Finally... someone got here. It was a very long and exhausting journey. They kidnapped me and held me here. I am some days without eating or drinking... we need to get out of here quickly. Please {help} me.", cid)
		end

		return true
	end

	npcHandler.talkState[talkUser] = doQuestTalk(cid, "Ash Ketchum", msg, npcHandler.talkState[talkUser])

	return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
	if (following) then
		return false
	end
  
  if (getSamePosition(getNpcPos(), {x = 5523, y = 234, z = 6})) then
    return false
  end

	if (not npcHandler:isInRange(cid)) then
		return false
	end

	if (getSamePosition(getNpcPos(), KIDNAPPED_ASH_POSITION)) then
		selfSay("Finally ... someone got here. It was a very long and exhausting journey. They kidnapped me and held me here. I am some days without eating or drinking ... we need to get out of here quickly. Please {help} me.", cid)
		npcHandler:addFocus(cid)
		return false

--	elseif (getSamePosition(getNpcPos(), KANTOMAIN12_ASH_POSITION) and getPlayerDefeatedNPC(cid, 9707)--[[todo storage check]]) then
--		selfSay("Pikachu! I can not believe it took Pikachu <crying>... We have to recover our Pokemon, please go ahead, the body of the nurse must have some key.", cid)
--		return false
	end
	return true
end)

npcHandler:addModule(FocusModule:new())

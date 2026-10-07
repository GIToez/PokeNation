setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local TALKSTATE_RENEW = 5
local refundStorage = 8201
local questStorage = 8017

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local name = getNpcName()

local function isPlayerAbleToRefund(cid)
    return getCreatureStorage(cid, refundStorage) == -1 and getCreatureStorage(cid, questStorage) == 1 -- Quest done but with old reward
end

local KANTOMAIN10_POSITION = {x = 5032, y = 578, z = 9}
local EVENT_CHRISTMAS_POSITION = {x = 5423, y = 383, z = 7}
local EVENT_CHRISTMAS_TRAP_POSITION = {x = 3898, y = 329, z = 10}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    --[[if (getSamePosition(getNpcPos(), EVENT_CHRISTMAS_TRAP_POSITION)) then
        if (msgcontains(msg, 'yes') or msgcontains(msg,' sim')) then
            selfSay("Okay, so go on, but carefully.", cid)
        else
            selfSay("Glad you came, I should not have come alone, I fell into a trap, please try to find some way to get me out, but beware, here is full of traps, the suspect is very cunning, stay tuned, you will return to help me?", cid)
        end
        return true
    end]]

    if (msgcontains(msg, 'chansey') and isPlayerAbleToRefund(cid)) then
        selfSay("You've done this mission and has the old reward, I can renew your reward. Do you want it?", cid)
        npcHandler.talkState[talkUser] = TALKSTATE_RENEW
        return true

    elseif (npcHandler.talkState[talkUser] == TALKSTATE_RENEW) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            doPokemonRewardFix(cid, {"Chansey"}, refundStorage)
        end

        npcHandler.talkState[talkUser] = 0
        return true
    end

    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    -- todo check storages

    if (getSamePosition(getNpcPos(), KANTOMAIN10_POSITION)) then
        if (getCreatureStorage(cid, 8547) ~= QUEST_STATUS.FINISHED) then
            selfSay("So you're a friend of Bill? Wait a minute I will confirm this... Looks like Bill know you, I will let you go, but I do not want to see you getting into the affairs of the police without permission, OK?", cid)
            doCreatureSetStorage(cid, 8547, QUEST_STATUS.FINISHED)
            doCreatureSetStorage(cid, 8546, QUEST_STATUS.STARTED) -- Start Mistery Guy quest
        else
            selfSay("I do not want to see you getting into the affairs of the police without permission, OK?", cid)
        end
        npcHandler:addFocus(cid)
        return false

    elseif (getSamePosition(getNpcPos(), EVENT_CHRISTMAS_POSITION)) then
        if (getCreatureStorage(cid, 8562) ~= QUEST_STATUS.FINISHED) then
            selfSay("Sorry I'm here to investigate something suspicious, if you do not have information about something strange going on here do not take my time.", cid)
        else
            selfSay("So you saw someone stealing {presents}?", cid)
            npcHandler:addFocus(cid)
        end

        return false

    elseif (getSamePosition(getNpcPos(), EVENT_CHRISTMAS_TRAP_POSITION)) then
        npcHandler.talkState[cid] = doQuestTalk(cid, name, "quest", npcHandler.talkState[cid])
        npcHandler:addFocus(cid)
        return false
    end
    return true
end)


--[[
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'chansey')) then
		if (getCreatureStorage(cid, refundStorage) == -1 and getCreatureStorage(cid, questStorage) == 1) then -- Quest done but with old reward
            selfSay("You've done this mission and has the old reward, I can renew your reward. Do you want it?", cid)
            npcHandler.talkState[talkUser] = TALKSTATE_RENEW
        else
            npcHandler.talkState[talkUser] = doQuestTalkStart(cid, "Officer Jeny")
        end

	elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		if (npcHandler.talkState[talkUser] == TALKSTATE_RENEW) then
            doPokemonRewardFix(cid, {"Chansey"}, refundStorage)
            npcHandler.talkState[talkUser] = 0

        else
            npcHandler.talkState[talkUser] = doQuestTalkEnd(cid, "Officer Jeny", npcHandler.talkState[talkUser])
        end

	else
		selfSay("What?", cid)
		npcHandler.talkState[talkUser] = 0
	end
	return true
end)
]]
npcHandler:addModule(FocusModule:new())

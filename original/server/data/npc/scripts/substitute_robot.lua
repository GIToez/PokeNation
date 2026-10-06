local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local ROBOT_STORAGE = 1000
local ROBOT_VALUE = 1
local QUEST_STEP_STORAGE = 8397
local TRIES_MAX = 10

local function getTries()
    local r = getStorage(GLOBAL_STORAGES.QUEST_TM_SUBSTITUTE_ROBOT_TRIES)
    return r >= 0 and r or 0
end

local function setTries(v)
    doSetStorage(GLOBAL_STORAGES.QUEST_TM_SUBSTITUTE_ROBOT_TRIES, v)
end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, "robot") or msgcontains(msg, 'robo')) then
        if (getCreatureStorage(getNpcId(), ROBOT_STORAGE) == ROBOT_VALUE) then
            local tries = getTries() + 1
            setTries(tries)

            selfSay("Ooops! I'm a robot!", cid)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Substitute tries: %s/%s."), tries, TRIES_MAX))

            if (tries >= TRIES_MAX) then
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You've reached the try limit without discovering the real Substitute!")
                doTeleportThing(cid, {x = 4897, y = 303, z = 8})
                setTries(0)
            end

        else
            selfSay("You got me! I'm the real!", cid)
            doCreatureSetStorage(cid, QUEST_STEP_STORAGE, QUEST_STATUS.FINISHED)
        end

        npcHandler:unGreet(cid)
    end

	return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        if (getCreatureStorage(cid, QUEST_STEP_STORAGE) == QUEST_STATUS.FINISHED) then
            selfSay("You already finished this step, please move to the next.", cid)
            return false
        end
    end
    return true
end)

npcHandler:addModule(FocusModule:new())

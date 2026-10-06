setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

function sayStory(...) return npcHandler:sayStory(...) end

local name = getNpcName()

local SEA_DRAGON_QUEST_STORAGE = 8674
local WILL_KID_LAST_BATTLE_STORAGE = 9712
local LAST_QUEST_STORAGE = 8701

local TALK_SEQUENCE_STATE = {}
local TALK_SEQUENCE = {}
TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'yes', 'sim' },
    onSay = function(cid)
        npcHandler:sayStory(string.createStory(__L(cid, 'Thank you, you have been helpful. Seems to me that you have a bright future as a Seaman, if you prove yourself worthy, you can join our crew. However, I cannot deal with this right now. I was going through my notes end I may have some leads to what happen to us. The last thing I remember is to leave the pirate sanctuary, heading to the {Black Waters}... RRR Why I am telling you this? ... Never mind, perhaps you may know something...')), cid)
        return true
    end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    if (getCreatureStorage(cid, SEA_DRAGON_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
        selfSay("Well, I made a mistake, I'm waiting for an order from the Sea Dragons, if you're not the deliverer, then you're not welcome.", cid)
        doTeleportThing(cid, {x = 4214, y = 330, z = 7})
        return true
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and not getPlayerDefeatedNPC(cid, WILL_KID_LAST_BATTLE_STORAGE)) then
        doCreatureAddStatus(cid, CREATURE_STATUS_SLEEP)
        doTeleportThing(cid, {x = 5745, y = 267, z = 5})
        doCreatureSetNoMove(cid, true)
        doMutePlayer(cid, 60)
        setPlayerBlockLogout(cid, true)

        if (not getNpcAtPosition({x = 5745, y = 263, z = 5}, "Will Kid")) then
            local npcPos = {x = 5745, y = 263, z = 5}
            local npcId = doCreateNpc("Will Kid", npcPos)
            doSendMagicEffect(npcPos, EFFECT_TELEPORT_FRAME)
            doCreatureSetLookDirection(npcId, SOUTH)
        end
    end

    return true
end)


npcHandler:addModule(FocusModule:new())

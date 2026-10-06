local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'sim') or msgcontains(msg, 'yes')) then
        selfSay("So talk to my Rudolph, my Stantler, he has the ability to talk to you mentally, do not worry no one will listen to you, he was here somewhere, I can not look it now why I have to keep avoiding appearances they discover us, when you find Rundolph, tell him what city you want to get that in time he will inform me, do not worry, it will take you to this city.", cid)
    end
    return true
end)
npcHandler:addModule(FocusModule:new())

--[[npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (getCreatureStorage(cid, 8577) ~= QUEST_STATUS.FINISHED) then
        selfSay("Disguise, I'm disguised as Santa to prevent it get me, it worked so far, I'm all present and must deliver all the houses so that Christmas is not lost, so can you help me?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)]]
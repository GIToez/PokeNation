setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

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
    npcHandler.talkState[talkUser] = doQuestTalk(cid, "Martha May", msg, npcHandler.talkState[talkUser])
    return true
end)
npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (getPlayerDefeatedNPC(cid, 9706)) then
        selfSay("Then he wrote a letter to me? He still loves me, why he never sent me the letter? ... Well I will tell you about the Grinch, he was born different but it was always affectionate, we fell in love, but people did not like the situation pro he was different, then at Christmas made a bad joke with him that ended up hurting his feelings, he ran away and was never seen again, you know where he {hides}?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)
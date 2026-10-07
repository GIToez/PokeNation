setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.HEAR_STORY = 10 -- Higher to not conflict with quest system talk state

keywordHandler:addKeyword(
    {'yes', 'sim'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid) or npcHandler.talkState[cid] ~= TALKSTATES.HEAR_STORY) then
            return false
        end

        npcHandler:sayStory(string.createStory(__L(cid, "Once there were three kings who ruled their small tribes that were always hidden. These tribes have always helped each other in secret and cooperated to maintain balance in the Islands. Once an evil being would awaken an ancient guardian of the seas to cause chaos in the archipelago, and for that he would need the mystical artifact of the three legendary birds. The three kings knowing the plan, were behind the evil and be locked up inside a Stone along with his household using psychic powers. Unfortunately during the three kings perished and fell before the exhaust by using so much energy. This is the story that I know, and seeking the {location of prophecy} since.")), cid)
        npcHandler.talkState[cid] = TALKSTATES.NONE

        return true
    end,
    {})

keywordHandler:addKeyword(
    {'elder', 'sabio', 'sábio'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        selfSay("I know! An old Slowking lives as a hermit on the Shamouti Island. Try to communicate with him and maybe he has the answer!", cid)

        return true
    end,
    {})

keywordHandler:addKeyword(
    {'.*'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        npcHandler.talkState[cid] = doQuestTalk(cid, "Adventurer Lucy", message, npcHandler.talkState[cid])

        return true
    end,
    {})

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getCreatureStorage(cid, 8229) ~= QUEST_STATUS.FINISHED) then -- Orange Archipelago Main #3 completed?
        selfSay("Excuse, I'm busy now!", cid)
        return false
    end

    local status = getCreatureStorage(cid, 8240)
    if (status == QUEST_STATUS.UNSTARTED) then
        npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, you want to hear a good story?")
        npcHandler.talkState[cid] = TALKSTATES.HEAR_STORY

    elseif (status == QUEST_STATUS.STARTED) then
        npcHandler:setMessage(MESSAGE_GREET, "Hey, how are you doing? Any news about the {prophecy}?")

    else
        npcHandler:setMessage(MESSAGE_GREET, "Hey! Did you find the {elder}?")
    end
	return true
end)

npcHandler:addModule(FocusModule:new())

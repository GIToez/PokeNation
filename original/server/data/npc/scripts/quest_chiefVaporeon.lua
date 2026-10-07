setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local auxTalkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.CAN_UNDERSTAND = 1
TALKSTATES.EVIL_USE = 2
TALKSTATES.HELP = 3

local NODES = {}
NODES[1] = keywordHandler:addKeyword(
    {'yes', 'sim'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        if (npcHandler.talkState[cid] == TALKSTATES.CAN_UNDERSTAND) then
            selfSay("This is PPOREN amazing! And VAAPP what brings you to VAPOREONN our tribe reviewer?", cid)
        else
            auxTalkState[cid] = doQuestTalkEnd(cid, "Chief Vaporeon", auxTalkState[cid])
        end

        npcHandler.talkState[cid] = TALKSTATES.NONE

        return true
    end,
    {})

NODES[2] = NODES[1]:addChildKeyword(
    {'deepsoul'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        selfSay("You would not dare VAPP go after this REONN evil thing! I will not VAPPP allow! Our king has sacrificed VAPOREONN for it. You want to use it for evil?", cid)

        return true
    end,
    {})

NODES[3] = NODES[2]:addChildKeyword(
    {'no', 'nao'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        auxTalkState[cid] = doQuestTalkStart(cid, "Chief Vaporeon")

        return true
    end,
    {})

NODES[4] = NODES[3]:addChildKeyword(
    {'yes', 'sim'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        auxTalkState[cid] = doQuestTalkEnd(cid, "Chief Vaporeon", auxTalkState[cid])

        return true
    end,
    {})

keywordHandler:addKeyword(
    {'restore', 'deepsoul', 'stone'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        auxTalkState[cid] = doQuestTalkStart(cid, "Chief Vaporeon")

        return true
    end,
    {})

keywordHandler:addKeyword(
    {'chief', 'chefe'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        selfSay("You can find the Mountain Tribe at the Kumquat Island and the Sky Tribe at the Fairchild Island.", cid)

        return true
    end,
    {})

table.clear(NODES)
NODES = nil

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        local item = getPlayerItemById(cid, true, 18252)
        if (not isItem(item)) then
            return false
        end
    end

    if (getCreatureStorage(cid, 8242) == QUEST_STATUS.UNSTARTED) then -- Prophet Slowking Quest
        selfSay("I can't help you right now.", cid)
        return false
    end

    -- TODO: redo greet
    local status = getCreatureStorage(cid, 8243)
    if (status == QUEST_STATUS.UNSTARTED) then
        npcHandler:setMessage(MESSAGE_GREET, "A human! Speaking with me! You can understand me? VAPOREONN")
        npcHandler.talkState[cid] = TALKSTATES.CAN_UNDERSTAND

    elseif (status == QUEST_STATUS.STARTED) then
        npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, VAPP did you find REON the {Restore} Stones?")

    else
        npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|!")
    end

    return true
end)

npcHandler:addModule(FocusModule:new())

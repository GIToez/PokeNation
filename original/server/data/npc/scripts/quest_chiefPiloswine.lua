setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.UNDERSTAND = 1
TALKSTATES.CAN_UNDERSTAND = 2

local NODES = {}
NODES[1] = keywordHandler:addKeyword(
    {'understand', 'entender'},
    function(cid, message, keywords, parameters, node)
        if (not parameters.npcHandler:isFocused(cid) or
                parameters.npcHandler.talkState[cid] ~= TALKSTATES.CAN_UNDERSTAND) then
            return false
        end

        parameters.npcHandler:say("By the beard PILOSS of the King! You know SWINEE what I mean! What brings you here?", cid)

        return true
    end,
    {npcHandler = npcHandler, onlyFocus = true})

NODES[2] = NODES[1]:addChildKeyword(
    {'deepsoul'},
    StdModule.say,
    {npcHandler = npcHandler, onlyFocus = true, text = 'What do you LOSSWI want with that damn stone? You want to do something with it? Think about PILOSWINEEE it in your reply!'})

NODES[3] = NODES[2]:addChildKeyword(
    {'help', 'ajuda'},
    StdModule.say,
    {npcHandler = npcHandler, onlyFocus = true, text = 'You want to help PILOSS strengthen the protection of stone? First then you have to pick one of the {Restore} Stones that resides in this mountain. We Pokemon PILOSSW could not get near it because reverberate too much negative energy, then maybe you can.'})

NODES[4] = NODES[3]:addChildKeyword(
    {'restore'},
    StdModule.say,
    {npcHandler = npcHandler, onlyFocus = true, text = 'She sits WINEE on one of the lower PILLL floors. Good luck.'})

keywordHandler:addKeyword(
    {'.*'},
    function(cid, message, keywords, parameters, node)
        if (not parameters.npcHandler:isFocused(cid) or
                parameters.npcHandler.talkState[cid] ~= TALKSTATES.UNDERSTAND) then
            return false
        end

        parameters.npcHandler:say("You are insistent, PILOSS you will not {understand} WINEE me...", cid)
        parameters.npcHandler.talkState[cid] = TALKSTATES.CAN_UNDERSTAND

        return true
    end,
    {npcHandler = npcHandler, onlyFocus = true})

table.clear(NODES)
NODES = nil

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        local item = getPlayerItemById(cid, true, 18252)
        if (not isItem(item)) then
            return false
        end
    end

    if (getCreatureStorage(cid, 8243) == QUEST_STATUS.UNSTARTED) then -- Chief Vaporeon Quest
        selfSay("I can't help you right now.", cid)
        return false
    end

    -- TODO: redo greet
    npcHandler:setMessage(MESSAGE_GREET, "The first human PILLS to visit us! It would be wasting my time WINEEE trying to communicate with you...")
    npcHandler.talkState[cid] = TALKSTATES.UNDERSTAND

    return true
end)

npcHandler:addModule(FocusModule:new())
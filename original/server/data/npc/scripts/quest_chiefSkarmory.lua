setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local NODES = {}
NODES[1] = keywordHandler:addKeyword(
    {'restore', 'stone', 'deepsoul'},
    StdModule.say,
    {npcHandler = npcHandler, onlyFocus = true, text = 'What do you SKARR want with her? We do not need your help... moreover, you can not {understand} me.'})

NODES[2] = NODES[1]:addChildKeyword(
    {'understand', 'entender'},
    StdModule.say,
    {npcHandler = npcHandler, onlyFocus = true, text = 'Are you saying that this MORRYY device makes us understand? Impressive. You could... wants to help strengthen the {Deepsoul Stone}?'})

NODES[3] = NODES[2]:addChildKeyword(
    {'yes', 'deepsoul', 'sim'},
    StdModule.say,
    {npcHandler = npcHandler, onlyFocus = true, text = 'So grab the Restore Stone residing at sea, SKARRM protected by my guardian. You have to prove your worth to have her. Good luck...'})

keywordHandler:addKeyword(
    {'.*'},
    StdModule.say,
    {npcHandler = npcHandler, onlyFocus = true, text = '???'})

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
    npcHandler:setMessage(MESSAGE_GREET, "How did you get here? SKARMOOR Using this Pokemon as your slave?! We are free! Free to RYYY fly wherever we want.")
    return true
end)

npcHandler:addModule(FocusModule:new())
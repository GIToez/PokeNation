setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local sleepTime = 5 * 60 * 1000
local sleepCondition = createConditionObject(CONDITION_SLEEP, sleepTime)
setConditionParam(sleepCondition, CONDITION_PARAM_EFFECTTICKS, 1000)

local nextSleep = os.time()
local function checkSleep(cid)
    if (os.time() >= nextSleep) then
        doAddCondition(cid, sleepCondition)
        nextSleep = os.time() + ((sleepTime / 1000) * 3)
    end
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)
    if (not getCreatureCondition(getNpcId(), CONDITION_SLEEP)) then
        npcHandler:onCreatureSay(cid, type, msg)
    end
end
function onThink() npcHandler:onThink() checkSleep(getNpcId()) end
function sayStory(...) return npcHandler:sayStory(...) end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'map') or msgcontains(msg, 'mapa')) then
        selfSay("So you came here for the map? But before we give you the map, I need you to do some {tasks} for me.", cid)

	else
		npcHandler.talkState[talkUser] = doQuestTalk(cid, "Pistachio", msg, npcHandler.talkState[talkUser])
    end

	return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    npcHandler:setMessage(MESSAGE_GREET, table.random({"Pokemon, Pokemon, I love Pokemon! MUAHAHAHAHAHA!",
        "Did you know that Butterfree is the evolution of Venonat? Muahahaha.",
        "One day I saw a surfing Pikachu. He was too good to ... hahahahaha!",
        "Did you know that Venomoth is the evolution of Metapod?",
        "Charmander, CHAR CHAR!",
        "Pokemon, Pokemon, Pokemon I love... they are digital!"}))
    return true
end)

npcHandler:addModule(FocusModule:new())
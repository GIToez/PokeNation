local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end

local VITAMIN_BY_NAME = {}
for k, v in pairs(VITAMIN_IDS) do
    VITAMIN_BY_NAME[string.lower(Vitamin.getName(v))] = v
end

local VITAMINS_MESSAGE = {}
VITAMINS_MESSAGE[1] = "Here you can take one of these Vitamins: "

for name, id in pairs(VITAMIN_BY_NAME) do
    if (#VITAMINS_MESSAGE > 1) then
        VITAMINS_MESSAGE[#VITAMINS_MESSAGE + 1] = ", "
    end
    VITAMINS_MESSAGE[#VITAMINS_MESSAGE + 1] = "{" .. name .. "}"
end
VITAMINS_MESSAGE[#VITAMINS_MESSAGE + 1] = "."
VITAMINS_MESSAGE = table.concat(VITAMINS_MESSAGE)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    msg = string.lower(msg)

    if (VITAMIN_BY_NAME[msg]) then
        doPlayerSafeAddItem(cid, Vitamin.getItemId(VITAMIN_BY_NAME[msg]), 1, true)
        selfSay("Here is!", cid)

    else
        selfSay(VITAMINS_MESSAGE, cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

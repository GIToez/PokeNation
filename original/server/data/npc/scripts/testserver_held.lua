local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end

local HELD_BY_NAME = {}
for k, v in pairs(HELD_IDS) do
    HELD_BY_NAME[string.lower(PokemonHeldItem.getHeldName(v))] = v
end

local HELDS_MESSAGE = {}
HELDS_MESSAGE[1] = "Here you can take one of these Held Itens: "

for name, heldId in pairs(HELD_BY_NAME) do
    if (#HELDS_MESSAGE > 1) then
        HELDS_MESSAGE[#HELDS_MESSAGE + 1] = ", "
    end
    HELDS_MESSAGE[#HELDS_MESSAGE + 1] = "{" .. name .. "}"
end
HELDS_MESSAGE[#HELDS_MESSAGE + 1] = "."
HELDS_MESSAGE = table.concat(HELDS_MESSAGE)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    msg = string.lower(msg)

    if (HELD_BY_NAME[msg]) then
        doPlayerSafeAddItem(cid, PokemonHeldItem.getHeldItemId(HELD_BY_NAME[msg]), 1, true)
        selfSay("Here is!", cid)

    else
        selfSay(HELDS_MESSAGE, cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

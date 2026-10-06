local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_ONSELL, function(cid, itemid, subType, amount, ignoreCap, inBackpacks)
    doCreatureSetStorage(cid, 8755, QUEST_STATUS.FINISHED) -- Gameplay Tutorial Sell Quest
    doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, __L(cid, "Right, you can also buy some groceries at this location, such as healing potions and empty Pokeballs. Try to buy some."))
    return true
end)
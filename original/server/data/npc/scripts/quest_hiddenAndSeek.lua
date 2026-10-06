setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local hiddenAndSeekStorage = {}
hiddenAndSeekStorage["Lucas Ross"] = 8251
hiddenAndSeekStorage["Jayla Nonie"] = 8252
hiddenAndSeekStorage["Clemency Pamela"] = 8253
hiddenAndSeekStorage["Thorburn Tylor"] = 8254
hiddenAndSeekStorage["Karaugh Janae"] = 8255

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

    if ((msgcontains(msg, 'hidden') or msgcontains(msg, 'seek') or msgcontains(msg, 'esconde')) and
            getCreatureStorage(cid, 8250) == QUEST_STATUS.STARTED) then
        if (getCreatureStorage(cid, hiddenAndSeekStorage[getNpcName()]) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, hiddenAndSeekStorage[getNpcName()], QUEST_STATUS.FINISHED)
            selfSay("You find me! Haha!", cid)

        else
            selfSay("You already found me! Look for the next.", cid)
        end

	else
		selfSay("Hmm?", cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

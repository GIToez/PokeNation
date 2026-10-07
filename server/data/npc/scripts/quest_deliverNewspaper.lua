setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local countStorage = 8299
local deliverStorage = {}
deliverStorage["Hugh Morgan"] = 8300
deliverStorage["Robby Drummond"] = 8301
deliverStorage["Dusty Cheyenne"] = 8302
deliverStorage["Darius Linton"] = 8303
deliverStorage["Giles Shaw"] = 8304
deliverStorage["Brigham Corwin"] = 8305
deliverStorage["Irene Jaylyn"] = 8306
deliverStorage["Karin Sybil"] = 8307
deliverStorage["Delaney Dinah"] = 8308
deliverStorage["Aaren Mattie"] = 8309

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

    if (not msgcontains(msg, 'newspaper') and not msgcontains(msg, 'deliver') or msgcontains(msg, 'jornal') or msgcontains(msg, 'entrega')) then
        selfSay("I don't know what you're talking about.", cid)
        return true

    elseif (getCreatureStorage(cid, 8295) ~= QUEST_STATUS.STARTED) then
        selfSay("Sorry, I can't help you.", cid)
        return true

    elseif (getCreatureStorage(cid, deliverStorage[getNpcName()]) == QUEST_STATUS.FINISHED) then
        selfSay("You already gave me the newspaper!", cid)
        return true

    elseif (not doPlayerRemoveItem(cid, 18190, 1)) then -- Newspaper
        selfSay("Where is the newspaper?", cid)
        return true
    end

    doCreatureSetStorage(cid, deliverStorage[getNpcName()], QUEST_STATUS.FINISHED)
    doCreatureIncreaseStorage(cid, countStorage)
    selfSay("The newspaper? Thanks.", cid)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
        string.format(__L(cid, "Newspaper deliver step complete [%s/10]."), getCreatureStorage(cid, countStorage)))

	return true
end)
npcHandler:addModule(FocusModule:new())

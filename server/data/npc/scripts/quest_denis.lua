setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	if (getCreatureStorage(cid, 8341) ~= QUEST_STATUS.FINISHED) then
        selfSay("Sorry?", cid)

	elseif (msgcontains(msg, 'warnings') or msgcontains(msg, 'aviso')) then
        selfSay("That's right, they are why I do not want company... that day still haunts me. That {monster}!", cid)

    elseif (msgcontains(msg, 'monster') or msgcontains(msg, 'monstro')) then
        selfSay("Tyranitar is his name. I remember when captured in its first form... the Larvitar. So beautiful and so cute... then he turned that bloody thing! And just when we were about to {find} out about that...", cid)

    elseif (msgcontains(msg, 'find') or msgcontains(msg, 'encontrar')) then
        doCreatureSetStorage(cid, 8342, QUEST_STATUS.FINISHED)
        doCreatureSetStorage(cid, 8343, QUEST_STATUS.STARTED)
        selfSay("Yes, yes... we were to discover something, but fear does not help me remember. How about talking to Aleb, he was also there. Get out of here soon, you may be being followed! Go...", cid)

	else
		selfSay("Hmm?", cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

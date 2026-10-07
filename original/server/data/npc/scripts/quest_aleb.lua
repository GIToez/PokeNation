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

	if (getCreatureStorage(cid, 8342) ~= QUEST_STATUS.FINISHED) then
        selfSay("Sorry?", cid)

	elseif (msgcontains(msg, 'orange') or msgcontains(msg, 'archipelago') or msgcontains(msg, 'laranja')) then
        selfSay(string.format(__L(cid, "That place is beautiful %s. I lived moments there, and various {battles} and adventures and got lost... Han, hi."), getPlayerName(cid)), cid)

    elseif (msgcontains(msg, 'battles') or msgcontains(msg, 'batalhas')) then
        selfSay("Oh yes, there are many {secret places}, with trainers, with Pokemon... ah, ah... hi.", cid)

    elseif (msgcontains(msg, 'secret') or msgcontains(msg, 'places') or msgcontains(msg, 'secreto') or msgcontains(msg, 'lugares')) then
        doCreatureSetStorage(cid, 8343, QUEST_STATUS.FINISHED)
        --selfSay("I do not remember them but had water, had dark, had lightning, fire and ice... ah... hi.", cid)
        selfSay("I do not remember them but had water, had dark, had lightning, fire and ice... oh, Runford can remember... Who is he? A sailor...? Ah... hi.", cid)

	else
		selfSay("Hmm?", cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

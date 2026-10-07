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

    if (getCreatureStorage(cid, 8340) ~= QUEST_STATUS.FINISHED) then
        selfSay("Sorry?", cid)

	elseif (msgcontains(msg, 'orange') or msgcontains(msg, 'archipelago') or msgcontains(msg, 'laranja')) then
        selfSay("What? Ah, you say the islands south? Hicks! They are a tremendous young {adventure}! Hicks!", cid)

    elseif (msgcontains(msg, 'adventure') or msgcontains(msg, 'aventura')) then
        selfSay("There are many that I do not even like to talk about... I experienced every wonder that place. Are mountains, submerged islands, clouds, fire, water! Ya Ya! Me and my {Pokemon}... Hicks!", cid)

    elseif (msgcontains(msg, 'pokemon')) then
        selfSay("Hicks! There are many! They are quite different from those found here and many of them are not cataloged... Hicks! They are incredible powers and {evolutions}... My first one was captured Spinarak.", cid)

    elseif (msgcontains(msg, 'evolutions') or msgcontains(msg, 'evolucoes')) then
        doCreatureSetStorage(cid, 8341, QUEST_STATUS.FINISHED)
        doCreatureSetStorage(cid, 8342, QUEST_STATUS.STARTED)
        selfSay("Look buddy... Hicks! Who understands... Hicks!... this is more about Denis. You can search it out there. I heard he... Hicks!... was afraid of things he saw there. You brought my beer?", cid)

	else
		selfSay("Hmm?", cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

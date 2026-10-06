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

    if (msgcontains(msg, 'orange') or msgcontains(msg, 'archipelago') or msgcontains(msg, 'laranja')) then
        selfSay("Ahh! It's a nice place and full of cute {Pokemon}. It is a group of islands... I do not know the total... but they are quite large and full of experienced trainers.", cid)

    elseif (msgcontains(msg, 'pokemon')) then
        selfSay("Cool your interest in Pokemon. They come in a huge {variety} and some I know nothing. It has many strengths, in fact, especially one that is called Kingdra. I heard he is the dragon type... that scares you?", cid)

    elseif (msgcontains(msg, 'variety') or msgcontains(msg, 'variedade')) then
        doCreatureSetStorage(cid, 8340, QUEST_STATUS.FINISHED)
        doCreatureSetStorage(cid, 8341, QUEST_STATUS.STARTED)
        selfSay("You are very curious! How about asking more about it to my friend Juhn? I was going over the business in the islands, he attended the most mysterious places... think about it, want to buy a trinket? Do not tell anyone. Hehe!", cid)

	else
		selfSay("Hmm?", cid)
	end
	return true
end)

npcHandler:addModule(FocusModule:new())

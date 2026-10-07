setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local rocks = {
	{pos = {x = 903, y = 1669,z = 4}, toId = 18478}, -- - 144
	{pos = {x = 903, y = 1670,z = 4}, toId = 18479},
	{pos = {x = 903, y = 1671,z = 4}, toId = 18480},
	{pos = {x = 903, y = 1672,z = 4}, toId = 18481},
	{pos = {x = 903, y = 1673,z = 4}, toId = 18482},
	{pos = {x = 903, y = 1674,z = 4}, toId = 18483},
	{pos = {x = 903, y = 1675,z = 4}, toId = 18484},
	{pos = {x = 903, y = 1676,z = 4}, toId = 18485},
	
	{pos = {x = 904, y = 1668,z = 4}, toId = 18486},
	{pos = {x = 904, y = 1669,z = 4}, toId = 18487},
	{pos = {x = 904, y = 1670,z = 4}, toId = 18488},
	{pos = {x = 904, y = 1671,z = 4}, toId = 18489},
	{pos = {x = 904, y = 1672,z = 4}, toId = 18490},
	{pos = {x = 904, y = 1673,z = 4}, toId = 18491},
	{pos = {x = 904, y = 1674,z = 4}, toId = 18492},
	{pos = {x = 904, y = 1675,z = 4}, toId = 18493},
	{pos = {x = 904, y = 1676,z = 4}, toId = 18494},
	{pos = {x = 904, y = 1677,z = 4}, toId = 18495},
	
	{pos = {x = 905, y = 1667,z = 4}, toId = 18496},
	{pos = {x = 905, y = 1668,z = 4}, toId = 18497},
	{pos = {x = 905, y = 1669,z = 4}, toId = 18498},
	{pos = {x = 905, y = 1670,z = 4}, toId = 18499},
	{pos = {x = 905, y = 1671,z = 4}, toId = 18500},
	{pos = {x = 905, y = 1672,z = 4}, toId = 18501},
	{pos = {x = 905, y = 1673,z = 4}, toId = 18502},
	{pos = {x = 905, y = 1674,z = 4}, toId = 18503},
	{pos = {x = 905, y = 1675,z = 4}, toId = 18504},
	{pos = {x = 905, y = 1676,z = 4}, toId = 18505},
	{pos = {x = 905, y = 1677,z = 4}, toId = 18506},
	{pos = {x = 905, y = 1678,z = 4}, toId = 18507},
	
	{pos = {x = 906, y = 1667,z = 4}, toId = 18508},
	{pos = {x = 906, y = 1668,z = 4}, toId = 18509},
	{pos = {x = 906, y = 1669,z = 4}, toId = 18510},
	{pos = {x = 906, y = 1670,z = 4}, toId = 18511},
	{pos = {x = 906, y = 1671,z = 4}, toId = 18512},
	{pos = {x = 906, y = 1672,z = 4}, toId = 18513},
	{pos = {x = 906, y = 1673,z = 4}, toId = 18514},
	{pos = {x = 906, y = 1674,z = 4}, toId = 18515},
	{pos = {x = 906, y = 1675,z = 4}, toId = 18516},
	{pos = {x = 906, y = 1676,z = 4}, toId = 18517},
	{pos = {x = 906, y = 1677,z = 4}, toId = 18518},
	{pos = {x = 906, y = 1678,z = 4}, toId = 18519},
	
	{pos = {x = 907, y = 1667,z = 4}, toId = 18520},
	{pos = {x = 907, y = 1668,z = 4}, toId = 18521},
	{pos = {x = 907, y = 1669,z = 4}, toId = 18522},
	{pos = {x = 907, y = 1670,z = 4}, toId = 18523},
	{pos = {x = 907, y = 1671,z = 4}, toId = 18524},
	{pos = {x = 907, y = 1672,z = 4}, toId = 18525},
	{pos = {x = 907, y = 1673,z = 4}, toId = 18526},
	{pos = {x = 907, y = 1674,z = 4}, toId = 18527},
	{pos = {x = 907, y = 1675,z = 4}, toId = 18528},
	{pos = {x = 907, y = 1676,z = 4}, toId = 18529},
	{pos = {x = 907, y = 1677,z = 4}, toId = 18530},
	{pos = {x = 907, y = 1678,z = 4}, toId = 18531},
	
	{pos = {x = 908, y = 1667,z = 4}, toId = 18532},
	{pos = {x = 908, y = 1668,z = 4}, toId = 18533},
	{pos = {x = 908, y = 1669,z = 4}, toId = 18534},
	{pos = {x = 908, y = 1670,z = 4}, toId = 18535},
	{pos = {x = 908, y = 1671,z = 4}, toId = 18536},
	{pos = {x = 908, y = 1672,z = 4}, toId = 18537},
	{pos = {x = 908, y = 1673,z = 4}, toId = 18538},
	{pos = {x = 908, y = 1674,z = 4}, toId = 18539},
	{pos = {x = 908, y = 1675,z = 4}, toId = 18540},
	{pos = {x = 908, y = 1676,z = 4}, toId = 18541},
	{pos = {x = 908, y = 1677,z = 4}, toId = 18542},
	{pos = {x = 908, y = 1678,z = 4}, toId = 18543},
	
	{pos = {x = 909, y = 1667,z = 4}, toId = 18544},
	{pos = {x = 909, y = 1668,z = 4}, toId = 18545},
	{pos = {x = 909, y = 1669,z = 4}, toId = 18546},
	{pos = {x = 909, y = 1670,z = 4}, toId = 18547},
	{pos = {x = 909, y = 1671,z = 4}, toId = 18548},
	{pos = {x = 909, y = 1672,z = 4}, toId = 18549},
	{pos = {x = 909, y = 1673,z = 4}, toId = 18550},
	{pos = {x = 909, y = 1674,z = 4}, toId = 18551},
	{pos = {x = 909, y = 1675,z = 4}, toId = 18552},
	{pos = {x = 909, y = 1676,z = 4}, toId = 18553},
	{pos = {x = 909, y = 1677,z = 4}, toId = 18554},
	{pos = {x = 909, y = 1678,z = 4}, toId = 18555},
	
	{pos = {x = 910, y = 1667,z = 4}, toId = 18556},
	{pos = {x = 910, y = 1668,z = 4}, toId = 18557},
	{pos = {x = 910, y = 1669,z = 4}, toId = 18558},
	{pos = {x = 910, y = 1670,z = 4}, toId = 18559},
	{pos = {x = 910, y = 1671,z = 4}, toId = 18560},
	{pos = {x = 910, y = 1672,z = 4}, toId = 18561},
	{pos = {x = 910, y = 1673,z = 4}, toId = 18562},
	{pos = {x = 910, y = 1674,z = 4}, toId = 18563},
	{pos = {x = 910, y = 1675,z = 4}, toId = 18564},
	{pos = {x = 910, y = 1676,z = 4}, toId = 18565},
	{pos = {x = 910, y = 1677,z = 4}, toId = 18566},
	{pos = {x = 910, y = 1678,z = 4}, toId = 18567},
	
	{pos = {x = 911, y = 1667,z = 4}, toId = 18568},
	{pos = {x = 911, y = 1668,z = 4}, toId = 18569},
	{pos = {x = 911, y = 1669,z = 4}, toId = 18570},
	{pos = {x = 911, y = 1670,z = 4}, toId = 18571},
	{pos = {x = 911, y = 1671,z = 4}, toId = 18572},
	{pos = {x = 911, y = 1672,z = 4}, toId = 18573},
	{pos = {x = 911, y = 1673,z = 4}, toId = 18574},
	{pos = {x = 911, y = 1674,z = 4}, toId = 18575},
	{pos = {x = 911, y = 1675,z = 4}, toId = 18576},
	{pos = {x = 911, y = 1676,z = 4}, toId = 18577},
	{pos = {x = 911, y = 1677,z = 4}, toId = 18578},
	{pos = {x = 911, y = 1678,z = 4}, toId = 18579},
	
	{pos = {x = 912, y = 1667,z = 4}, toId = 18580},
	{pos = {x = 912, y = 1668,z = 4}, toId = 18581},
	{pos = {x = 912, y = 1669,z = 4}, toId = 18582},
	{pos = {x = 912, y = 1670,z = 4}, toId = 18583},
	{pos = {x = 912, y = 1671,z = 4}, toId = 18584},
	{pos = {x = 912, y = 1672,z = 4}, toId = 18585},
	{pos = {x = 912, y = 1673,z = 4}, toId = 18586},
	{pos = {x = 912, y = 1674,z = 4}, toId = 18587},
	{pos = {x = 912, y = 1675,z = 4}, toId = 18588},
	{pos = {x = 912, y = 1676,z = 4}, toId = 18589},
	{pos = {x = 912, y = 1677,z = 4}, toId = 18590},
	{pos = {x = 912, y = 1678,z = 4}, toId = 18591},
	
	{pos = {x = 913, y = 1667,z = 4}, toId = 18592},
	{pos = {x = 913, y = 1668,z = 4}, toId = 18593},
	{pos = {x = 913, y = 1669,z = 4}, toId = 18594},
	{pos = {x = 913, y = 1670,z = 4}, toId = 18595},
	{pos = {x = 913, y = 1671,z = 4}, toId = 18596},
	{pos = {x = 913, y = 1672,z = 4}, toId = 18597},
	{pos = {x = 913, y = 1673,z = 4}, toId = 18598},
	{pos = {x = 913, y = 1674,z = 4}, toId = 18599},
	{pos = {x = 913, y = 1675,z = 4}, toId = 18600},
	{pos = {x = 913, y = 1676,z = 4}, toId = 18601},
	{pos = {x = 913, y = 1677,z = 4}, toId = 18602},
	{pos = {x = 913, y = 1678,z = 4}, toId = 18603},
	
	{pos = {x = 914, y = 1668,z = 4}, toId = 18604},
	{pos = {x = 914, y = 1669,z = 4}, toId = 18605},
	{pos = {x = 914, y = 1670,z = 4}, toId = 18606},
	{pos = {x = 914, y = 1671,z = 4}, toId = 18607},
	{pos = {x = 914, y = 1672,z = 4}, toId = 18608},
	{pos = {x = 914, y = 1673,z = 4}, toId = 18609},
	{pos = {x = 914, y = 1674,z = 4}, toId = 18610},
	{pos = {x = 914, y = 1675,z = 4}, toId = 18611},
	{pos = {x = 914, y = 1676,z = 4}, toId = 18612},
	{pos = {x = 914, y = 1677,z = 4}, toId = 18613},
	
	{pos = {x = 915, y = 1669,z = 4}, toId = 18614},
	{pos = {x = 915, y = 1670,z = 4}, toId = 18615},
	{pos = {x = 915, y = 1671,z = 4}, toId = 18616},
	{pos = {x = 915, y = 1672,z = 4}, toId = 18617},
	{pos = {x = 915, y = 1673,z = 4}, toId = 18618},
	{pos = {x = 915, y = 1674,z = 4}, toId = 18619},
	{pos = {x = 915, y = 1675,z = 4}, toId = 18620},
	{pos = {x = 915, y = 1676,z = 4}, toId = 18621},
}

local EFFECTS = {EFFECT_BLUE_BUFF, EFFECT_GREEN_BUFF, EFFECT_RED_BUFF}
local function doEffect(pos)
    doSendMagicEffect(pos, table.random(EFFECTS))
end

local function transformItem(pos, fromId, toId)
    local item = getTileItemById(pos, fromId)
    if (isItem(item)) then
        doTransformItem(item.uid, toId)
    end
end

function doProphetSlowkingEffect()
    for k, v in pairs(rocks) do
        transformItem(v.pos, (v.toId - 144), v.toId)
        addEvent(transformItem, (10 * 60 * 1000), v.pos, v.toId, (v.toId - 144))

        if (getRandom(0, 2) == 1) then
            doEffect(v.pos)
        end
        addEvent(doEffect, getRandom(1000, 10000), v.pos)
    end
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local rewardStorage = 8372

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, 8240) ~= QUEST_STATUS.FINISHED) then -- Adventurer Lucy completed?
        selfSay("Please do not interrupt, I'm coming in harmony with nature now.", cid)
        return true
    end

    if (getCreatureStorage(cid, 8368) == QUEST_STATUS.FINISHED and
            getCreatureStorage(cid, rewardStorage) ~= QUEST_STATUS.FINISHED) then
        local reward = 0
        if (msgcontains(msg, 'dragon') or msgcontains(msg, 'scale')) then
            reward = 18090 -- Dragon Scale
        elseif (msgcontains(msg, 'king') or msgcontains(msg, 'rock')) then
            reward = 18091 -- King's Rock
        elseif (msgcontains(msg, 'metal') or msgcontains(msg, 'coat')) then
            reward = 18092 -- Metal Coat
        end

        if (reward == 0) then
            selfSay("What reward you want? Your options are: {Dragon Scale}, {King's Rock} or {Metal Coat}.", cid)
            return true
        end

        if (doPlayerSafeAddItem(cid, reward, 1, true, false)) then
            doCreatureSetStorage(cid, rewardStorage, QUEST_STATUS.FINISHED)
            selfSay("Great choice! Here is.", cid)
        end

        return true
    end

	if (msgcontains(msg, 'sea') or msgcontains(msg, 'mar')) then
        selfSay("You will need to look my friend, I suggest you to start looking in Navel. Also talk to a scientist of your kind and get a translator to talk to the Pokemon that live there. The machine is under construction I think. Good luck", cid)

    elseif ((msgcontains(msg, 'restore') or msgcontains(msg, 'recuperar')) and getCreatureStorage(cid, 8242) == QUEST_STATUS.FINISHED) then -- Check for Chief Vaporeon quest complete
        selfSay("Great, you got a great stage of your adventure. As of now there is no return... the Deepsoul Stone was recently removed from its original location and is now guarded by a large Pokemon. You need to go after a new treasure to get to her. Go talk to your professor, he is already aware of the situation. At the end go back to my presence. Good luck!", cid)

    elseif (msgcontains(msg, 'quest') or msgcontains(msg, 'mission') or msgcontains(msg, 'task') or
            msgcontains(msg, 'elder') or msgcontains(msg, 'prophecy') or msgcontains(msg, 'missao') or msgcontains(msg, 'tarefa') or msgcontains(msg, 'profecia')) then
		npcHandler.talkState[talkUser] = doQuestTalkStart(cid, "Prophet Slowking")

	elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		npcHandler.talkState[talkUser] = doQuestTalkEnd(cid, "Prophet Slowking", npcHandler.talkState[talkUser])

	else
		selfSay("Hmm?", cid)
		npcHandler.talkState[talkUser] = 0
    end

	return true
end)

npcHandler:addModule(FocusModule:new())

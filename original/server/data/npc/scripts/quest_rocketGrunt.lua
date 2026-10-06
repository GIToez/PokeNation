setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local npcBattle = NpcBattle:new(getNpcName(), 9283, 9683, npcHandler)
npcBattle:setPokemons({"Tangela", "Goldeen", "Voltorb", "Charmeleon", "Nidorana", "Venonat"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(50)
npcBattle:setRequired(function(cid) return getCreatureStorage(cid, 8435) == QUEST_STATUS.FINISHED end)
npcBattle:setOnEnd(function(cid)
    npcHandler:say("You're tough, I will not be able to hold you here anyway. I hope that others give you a lesson down there. Step the last right tile now... get out!", cid)
end)

keywordHandler:addKeyword(
    {'we', 'nos'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        selfSay("Am I alone here! Others are {down} there... I MEAN, are stealing Pokemon around!", cid)

        return true
    end,
    {})

keywordHandler:addKeyword(
    {'down', 'embaixo'},
    function(cid, message, keywords, parameters, node)
        if (not npcHandler:isFocused(cid)) then
            return false
        end

        selfSay("You do not give up do you? I WANT A {BATTLE}!", cid)

        return true
    end,
    {})

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getPlayerDefeatedNPC(cid, 9683)) then
        selfSay("Get out!", cid)
        return false
    end

    npcHandler:setMessage(MESSAGE_GREET, "Get out, this is no place for nosy. {We}'re... I mean, I'm busy!")
	return true
end)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'battle') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelo')) then
        npcHandler.talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        npcHandler.talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, npcHandler.talkState[talkUser])

    else
        selfSay("Humpf!?", cid)
    end

    return true
end)

npcHandler:addModule(FocusModule:new())

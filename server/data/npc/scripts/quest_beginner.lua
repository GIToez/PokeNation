setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local npcBattle = NpcBattle:new(getNpcName(), 8364, 8366, npcHandler)
npcBattle:setPokemons({"Caterpie", "Weedle"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(5)
npcBattle:setRequired(function(cid) return getCreatureStorage(cid, 8363) == QUEST_STATUS.FINISHED end)

local name = getNpcName()

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (not getPlayerGotStarterPokemon(cid)) then
        msg = string.capitalise(msg)
        if (table.find({"Bulbasaur", "Charmander", "Squirtle"}, msg)) then
            doCreatePokemonBall(cid, "soul", msg, 5, nil, nil, 0, cid, false, 999999, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, function(ball) setBallOriginalTrainer(ball, cid) end)
            setPlayerGotStarterPokemon(cid, true)
            selfSay("Here is, congratulations!", cid)
            return true
        end

        selfSay("What Pokemon do you want? {Bulbasaur}, {Charmander} or {Squirtle}.", cid)
        return true
    end

    if (getCreatureStorage(cid, 8363) == QUEST_STATUS.FINISHED and
            getCreatureStorage(cid, 8364) == QUEST_STATUS.UNSTARTED) then
        if (msgcontains(msg, 'mission') or msgcontains(msg, 'help') or msgcontains(msg, 'task') or
                msgcontains(msg, 'battle') or msgcontains(msg, 'missao') or msgcontains(msg, 'ajuda') or msgcontains(msg, 'tarefa') or msgcontains(msg, 'batalha')) then
            npcHandler.talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            npcHandler.talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, npcHandler.talkState[talkUser])

        else
            selfSay("What do you think to test your skills in a real Pokemon {battle}?", cid)
        end

        return true
    end

	npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

	return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (not getPlayerGotStarterPokemon(cid)) then
        selfSay("Oh, you can receive a new starter Pokemon! What do you want? {Bulbasaur}, {Charmander} or {Squirtle}.", cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, 8358) == QUEST_STATUS.STARTED or
            getCreatureStorage(cid, 8359) == QUEST_STATUS.STARTED or
            getCreatureStorage(cid, 8360) == QUEST_STATUS.STARTED or
            getCreatureStorage(cid, 8361) == QUEST_STATUS.STARTED or
            getCreatureStorage(cid, 8362) == QUEST_STATUS.STARTED or
            getCreatureStorage(cid, 8363) == QUEST_STATUS.STARTED or
            getCreatureStorage(cid, 8365) == QUEST_STATUS.STARTED) then
        npcHandler.talkState[cid] = doQuestTalk(cid, name, "quest", npcHandler.talkState[cid])
		npcHandler:addFocus(cid)
        return false

    elseif (getCreatureStorage(cid, 8363) == QUEST_STATUS.FINISHED and -- Battle quest
            getCreatureStorage(cid, 8364) == QUEST_STATUS.UNSTARTED) then
        selfSay("What do you think to test your skills in a real Pokemon {battle}?", cid)
        npcHandler:addFocus(cid)
        return false

    elseif (getCreatureStorage(cid, 8365) == QUEST_STATUS.FINISHED) then
        selfSay("Hello, how have you been?", cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())

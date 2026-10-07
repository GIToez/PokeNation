setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local npcBattle = NpcBattle:new(getNpcName(), 9274, 9674, npcHandler)
npcBattle:setPokemons({"Squirtle", "Eevee", "Doduo", "Growlithe"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(10)
npcBattle:setRequired(function(cid) return getCreatureStorage(cid, 8413) == QUEST_STATUS.FINISHED end)
npcBattle:setOnWin(function(cid)
    doCreatureSetStorage(cid, 8414, QUEST_STATUS.STARTED)
end)

local name = getNpcName()

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, 8413) == QUEST_STATUS.FINISHED and
            not getPlayerDefeatedNPC(cid, name)) then
        if (msgcontains(msg, 'mission') or msgcontains(msg, 'help') or msgcontains(msg, 'task') or
                msgcontains(msg, 'battle') or msgcontains(msg, 'quest') or msgcontains(msg, 'missao') or msgcontains(msg, 'ajuda') or msgcontains(msg, 'tarefa') or msgcontains(msg, 'batalha')) then
            npcHandler.talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            npcHandler.talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, npcHandler.talkState[talkUser])

        else
            selfSay("Let's {battle}?", cid)
        end

        return true
    end

	npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

	return true
end)

npcHandler:addModule(FocusModule:new())

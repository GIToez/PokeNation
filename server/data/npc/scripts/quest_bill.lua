setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local ivyQuestStorage = 8231
local bananaStorage = 8232

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'poketransformation')) then
        selfSay("Give me a doll of any Pokemon you have in your PokeDex and I can trasform you into this Pokemon for 30 minutes. That's my new machine.", cid)
        return true
    end

    if (msgcontains(msg, 'thief') or msgcontains(msg, 'aipom') or msgcontains(msg, 'ivy')) then
        if (getCreatureStorage(cid, ivyQuestStorage) == QUEST_STATUS.STARTED) then
            if (getCreatureStorage(cid, bananaStorage) ~= QUEST_STATUS.FINISHED) then
                if (doPlayerAddUniqueItem(cid, 18162, 15, false)) then
                    doCreatureSetStorage(cid, bananaStorage, QUEST_STATUS.FINISHED)
                    selfSay("Ivy called me giving this information. Look, try this special banana... this can work. The thief Aipom is on Valencia Island.", cid)
                end

            else
                selfSay("You must now use the special bananas to hook the Thief Aipom!", cid)
            end

        else
            selfSay("Sorry, I don't know what you're talking about.", cid)
        end

    else
        npcHandler.talkState[talkUser] = doQuestTalk(cid, "Bill", msg, npcHandler.talkState[talkUser])
    end

    return true
end)

npcHandler:addModule(FocusModule:new())

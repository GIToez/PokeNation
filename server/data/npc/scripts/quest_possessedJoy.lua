setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local doScenes = nil
local mewtwo = nil

doScenes = function(take, npcId)
    if (take == 1) then
        selfSay("You will meet my master, the greatest pokemon trainer in the world.")

    elseif (take == 2) then
        local mewtwoPos = {x = 5523, y = 231, z = 6}
        mewtwo = doCreateNpc("Mewtwo", mewtwoPos)
        doSendMagicEffect(mewtwoPos, EFFECT_TELEPORT_DOWN)
        doSendMagicEffect(mewtwoPos, EFFECT_TELEPORT_FRAME)

    elseif (take == 3) then
        selfSay("This is New Island master and soon will be worldwide, Mewtwo.")

    elseif (take == 4) then
        selfSay("Humans. You are facing your new master.")
        doCreatureSay(mewtwo, "Humans. You are facing your new master.", TALKTYPE_SAY)

    elseif (take == 5) then
        doCreatureSay(mewtwo, "Your usefulness has ended.", TALKTYPE_SAY)

    elseif (take == 6) then
        local npcPos = getCreaturePosition(npcId)
        doRemoveCreature(npcId)
        doCreateItem(25194, 1, npcPos)
        doSendMagicEffect(npcPos, EFFECT_STAR_BUFF)

    elseif (take == 7) then
        doCreatureSay(mewtwo, "I am the new lord of this earth, the master of humans and also of pokemon.", TALKTYPE_SAY)

    elseif (take == 8) then
        doCreatureSay(mewtwo, "You humans are a dangerous species, always looking for destruction and this quest you brought me into this world for the sole purpose of turning me into a slave, but now I have my own goal. I will create my own world to the cost of the destruction of you, no one will be spared, not even your Pokemon, they fell from grace to serve humans. Soon you will see my greatest achievement.", TALKTYPE_SAY)

    elseif (take == 9) then
        doCreatureSay(mewtwo, "How about I give a proof of my power for you in the meantime? Come {duel} with me trainer.", TALKTYPE_SAY)
        return
    end

    addEvent(doScenes, 1000, take + 1, npcId)
end

local acting = nil
function onCreatureMove(cid, oldPos, newPos)
    if (isPlayer(cid) and not acting and getDistanceBetween(getNpcPos(), newPos) <= 8--[[todo check storage]]) then
        acting = true
        doScenes(1, getNpcId())
    end
end

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'invitation')) then
        if (getPlayerItemCountByUnique(cid, 25192) > 0) then
            selfSay("Sure you can go ahead, I'll meet you later.", cid)
            doTeleportThing(cid, {x = 5486, y = 226, z = 6})

        else
            selfSay("You are not with the invitation!", cid)
        end
    end

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    -- todo check storages

    if (getSamePosition(getNpcPos(), KANTOMAIN10_POSITION)) then
        if (getCreatureStorage(cid, 8547) ~= QUEST_STATUS.FINISHED) then
            selfSay("So you're a friend of Bill? Wait a minute I will confirm this... Looks like Bill know you, I will let you go, but I do not want to see you getting into the affairs of the police without permission, OK?", cid)
            doCreatureSetStorage(cid, 8547, QUEST_STATUS.FINISHED)
            doCreatureSetStorage(cid, 8546, QUEST_STATUS.STARTED) -- Start Mistery Guy quest
        else
            selfSay("I do not want to see you getting into the affairs of the police without permission, OK?", cid)
        end
        npcHandler:addFocus(cid)
        return false
    end
    return true
end)

npcHandler:addModule(FocusModule:new())

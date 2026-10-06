setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

function sayStory(...) return npcHandler:sayStory(...) end

local name = getNpcName()
local willId = nil

--[[ FINAL BATTLE - Cursed Gengar ]]
local finalNpcBattle = NpcBattle:new(getNpcName(), 9312, 9712, npcHandler)
finalNpcBattle:setPokemons({ "Cursed Gengar", "White Gengar" })
finalNpcBattle:setLinealOrder(true)
finalNpcBattle:setOneWin(true)
finalNpcBattle:setDifficulty(NPC_DIFFICULTY_DYNAMIC)
finalNpcBattle:setPokemonDefeatExperienced(true)
--finalNpcBattle:setOnWin(function(cid)
--    doSendDistanceShoot(getCreaturePosition(willId), getCreaturePosition(cid), PROJECTILE_METAL_BALL)
--    doSendMagicEffect(getCreaturePosition(cid), EFFECT_EXPLOSION)
--    doCreatureAddStatus(cid, CREATURE_STATUS_SLEEP)
--    doTeleportThing(cid, {x = 4720, y = 133, z = 7})
--end)
finalNpcBattle:setOnEnd(function(cid, playerWin, npc)
    doSendDistanceShoot(getCreaturePosition(npc), getCreaturePosition(cid), PROJECTILE_METAL_BALL)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_EXPLOSION)
    doCreatureAddStatus(cid, CREATURE_STATUS_SLEEP)
    doTeleportThing(cid, {x = 4720, y = 133, z = 7})

    doRemoveCreature(npc)
end)
finalNpcBattle:setRewardUniqueItems({ 28129, 1 })
finalNpcBattle:setBattleInterval(10 * 60)

--[[ FIRST BATTLE - 3 BOSSES ]]
local npcBattle = NpcBattle:new(getNpcName(), 9311, 9711, npcHandler)
npcBattle:setPokemons({ "Charculla", "Darkeon", "Maskmar" })
npcBattle:setOneWin(true)
npcBattle:setDifficulty(NPC_DIFFICULTY_DYNAMIC)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setOnWin(function(cid)
    addEvent(function() if (isPlayer(cid) and isNpc(npcBattle.uid)) then finalNpcBattle:doForceBattleStart(npcBattle.uid, cid) end end, 1000)
end)
npcBattle:setLossSpeech("You're stronger than I thought, but the best is yet to come ... my favorite Pokemon, Gengar ... well he learned some tricks with me ... I hope he does not scare ... too hahahhahaha ....")
npcBattle:setBattleInterval(10 * 60)
npcBattle:setOnEnd(function(cid, playerWin, npc)
    if (not playerWin) then
        doSendDistanceShoot(getCreaturePosition(npc), getCreaturePosition(cid), PROJECTILE_METAL_BALL)
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_EXPLOSION)
        doCreatureAddStatus(cid, CREATURE_STATUS_SLEEP)
        doTeleportThing(cid, {x = 4720, y = 133, z = 7})

        doRemoveCreature(npc)
    end
end)

local actions = {
    {
        action = function(cid)
            doCreatureSay(willId, __L(cid, "So you got really close to the truth, I neglected to have eliminated you before ..."), TALKTYPE_SAY)
        end,
        delay = 2000
    },
    {
        action = function(cid)
            doCreatureSay(willId, __L(cid, "It is strange that I speak, is not it? Well, I say yes, my father knows this, I always talk to him, he's a good father..."), TALKTYPE_SAY)
        end,
        delay = 8000
    },
    {
        action = function(cid)
            doCreatureSay(willId, __L(cid, "But he softened that heart, we were to exterminate any lord and ship captain, and avenge Rickon ... but he decided to join this stupid alliance, delayed our plans, and we lost focus, he spent more time inventing things than Bothering to punish those who took the life of my dear brother Rickon ..."), TALKTYPE_SAY)
        end,
        delay = 14000
    },
    {
        action = function(cid)
            doCreatureSay(willId, __L(cid, "Well, I know you know about Circulo, and you should be surprised to know that I can get off the ship, well, the truth is that I was the one who made the runes of resurrection, the price was high, who came back to life, Could not leave his gravesite, so they are all stuck to their ships ... as for me, well I did not die, so I can leave ..."), TALKTYPE_SAY)
        end,
        delay = 20000
    },
    {
        action = function(cid)
            doCreatureSay(willId, __L(cid, "I used a rune to perpetuate my existence, the price was high ... I will always be like this, I do not grow old, while my father sleeps, I judge those who deserve to be judged ..."), TALKTYPE_SAY)
        end,
        delay = 26000
    },
    {
        action = function(cid)
            doCreatureSay(willId, __L(cid, "You do not look bad, but you're disturbing me, I'll have to eliminate you ... luckily, I have no more lethal cartridges, but by all means, I've read all my father's magic books, and learned to conjure up little friends. ..."), TALKTYPE_SAY)
        end,
        delay = 34000
    },
    {
        action = function(cid)
            doCreatureSay(willId, __L(cid, "I want you to know now ... Charculla, Darkeon and Maskmar ... my perfect conjurations ... this is going to be fun .... muahahahhahaha"), TALKTYPE_SAY)
        end,
        delay = 40000
    },
    {
        action = function(cid)
            if (npcBattle:isBattleing() or finalNpcBattle:isBattleing()) then
                selfSay("I'm battling at the moment, please wait.", cid)
                return false
            end

            doCreatureSetNoMove(cid, false)
            setPlayerBlockLogout(cid, false)
            npcBattle:doForceBattleStart(willId, cid)
        end,
        delay = 48000
    },
}

local ED_BLACKHOOD_QUEST_STORAGE = 8677
local SCOPE_ITEM_ID = 28041
local ITEM_STORAGE = 8714

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    if (msgcontains(msg, { 'scope', 'luneta' })) then
        if (getCreatureStorage(cid, ED_BLACKHOOD_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
            if (getPlayerItemCount(cid, SCOPE_ITEM_ID) <= 0) then
                selfSay("???", cid)
            else
                doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
                doPlayerRemoveItem(cid, SCOPE_ITEM_ID, 1)
                selfSay("...", cid)
            end

        else
            selfSay("???", cid)
        end

        return true
    end
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (doComparePositions(getNpcPos(), {x = 5745, y = 263, z = 5})) then
        if (npcBattle:isBattleing() or finalNpcBattle:isBattleing()) then
            selfSay("I'm battling at the moment, please wait.", cid)
            return false
        end

        willId = getNpcId()

        for k, v in pairs(actions) do
            addEvent(v.action, v.delay, cid)
        end
    end

    return true
end)


npcHandler:addModule(FocusModule:new())

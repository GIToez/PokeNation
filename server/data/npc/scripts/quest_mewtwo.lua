local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9304, 9704, npcHandler)
npcBattle:setPokemons({"Clone Venusaur", "Clonse Blastoise", "Clone Charizard"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(100)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setOnEnd(function(cid, playerWin, npc)
    if (playerWin) then
        selfSay("Well, well, these clone should be defective, you have to destroy them. What about your Pokemon, they are mine from now!", cid)

        if (isPokemonOnline(cid)) then -- Try to call Pokemon back
            doPlayerUseBallOnSlot(cid)
        end

        if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
            --todo
        end

        -- todo store player Pokemons
        -- todo remove npcs pokemons also
        doSendMagicEffect(getCreaturePosition(npc), EFFECT_TELEPORT_FRAME)
    else
        --[[todo]]
    end

    doRemoveCreature(npc)
end)

--[[ FINAL MEWTWO START]]
local FINALMEWTWO_POS = {x = 0, y = 0, z = 0} -- todo

local doScenes = nil
local mew = nil

doScenes = function(take, npcId)
    if (take == 1) then
        local mewPos = {x = 0, y = 0, z = 0}--[[todo]]
        mew = doCreateNpc("Mew", mewPos)
        doSendMagicEffect(mewPos, EFFECT_TELEPORT_DOWN)
        doSendMagicEffect(mewPos, EFFECT_TELEPORT_FRAME)

    elseif (take == 2) then
        selfSay("Mew ... Finally we meet, then you have come to witness the birth of a new era? I may have been cloned from you, but I will prove to you that Mewtwo is higher than Mew.")

    elseif (take == 3) then
        doCreatureSay(mew, "Mew... Mew, Mew...", TALKTYPE_SAY)

    elseif (take == 4) then
        selfSay("How can you imply that my clones are weak because they have no heart?")

    elseif (take == 5) then
        -- todo make each other battle
        -- -- return
    end

    addEvent(doScenes, 1000, take + 1, npcId)
end

local finalNpcBattle = NpcBattle:new(getNpcName(), 9305, 9705, npcHandler)
finalNpcBattle:setPokemons({""}) -- todo
finalNpcBattle:setOneWin(true)
finalNpcBattle:setDifficulty(100)
finalNpcBattle:setPokemonDefeatExperienced(true)
finalNpcBattle:setPokemonExtraStats(0.5)
finalNpcBattle:setOnEnd(function(cid, playerWin, npc)
    if (playerWin) then
        selfSay("Impossible... My Pokemon are superior, I am superior!", cid)
        doScenes(1, npc)
    else
        --[[todo]]
    end
end)
--[[ FINAL MEWTWO END]]

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    local npcBattleVariant = getSamePosition(getNpcPos(), FINALMEWTWO_POS) and finalNpcBattle or npcBattle

    if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
        talkState[talkUser] =  npcBattleVariant:doTalkStart(getNpcId(), cid)

    elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        talkState[talkUser] =  npcBattleVariant:doTalkEnd(getNpcId(), cid, talkState[talkUser])

    else
        selfSay("Ok..", cid)
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

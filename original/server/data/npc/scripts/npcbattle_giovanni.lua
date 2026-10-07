local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

-- GYM STUFF [START]
local TM_STORAGE = 8403
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 17362, 1, true, false, true) -- TM 26 Fissure
end

local npcBattle = NpcBattle:new(getNpcName(), 9108, 9519, npcHandler)
npcBattle:setPokemons({"Tauros", "Arbok", "Nidoking", "Machamp", "Rhydon", "Sandslash", "Dugtrio", "Onix", "Marowak",
    "Nidoqueen"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardBadge(BADGES.EARTH)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(200)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(80)
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Kelly Oquin") and
                                getPlayerDefeatedNPC(cid, "Clinton Elton") and
                                getPlayerDefeatedNPC(cid, "Max Antes") and
                                getPlayerDefeatedNPC(cid, "Elinor Rameau") and
                                getPlayerDefeatedNPC(cid, "Margery Meidinger") and
                                getPlayerDefeatedNPC(cid, "Tanisha Ditmore") and
                                getPlayerDefeatedNPC(cid, "Rosalinda Fails")
                        end)
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.EARTH_BADGE)
    giveTm(cid)
end)
npcBattle:setPokemonDefeatExperienced(true)
-- GYM STUFF [END]

-- KANTO MAIN 10 Stuff [START]
local function doJennyScene(cid, npcId)
    local npcsPos = {
        jenny = {x = 5032, y = 578, z = 9},
        police1 = {x = 5031, y = 574, z = 9},
        police2 = {x = 5033, y = 574, z = 9}
    }
    local npcs = {
        jenny = doCreateNpc("Officer Jeny", npcsPos.jenny),
        police1 = doCreateNpc("Police Officer", npcsPos.police1),
        police2 = doCreateNpc("Police Officer", npcsPos.police2)
    }

    doCreatureSetLookDir(npcs.jenny, NORTH)
    doCreatureSetLookDir(npcs.police1, EAST)
    doCreatureSetLookDir(npcs.police2, WEST)

    doSendMagicEffect(npcsPos.jenny, EFFECT_POFF)
    doSendMagicEffect(npcsPos.police1, EFFECT_POFF)
    doSendMagicEffect(npcsPos.police2, EFFECT_POFF)

    doCreatureSay(npcs.jenny, "Giovanni, you are under arrest!", TALKTYPE_SAY)

    addEvent(function(npcId)
        if (getCreatureStorage(cid, 8547) ~= QUEST_STATUS.FINISHED) then
            doCreatureSay(npcs.jenny, "So you're a friend of Bill? Wait a minute I will confirm this... Looks like Bill know you, I will let you go, but I do not want to see you getting into the affairs of the police without permission, OK?", TALKTYPE_SAY)
            doCreatureSetStorage(cid, 8547, QUEST_STATUS.FINISHED)
            doCreatureSetStorage(cid, 8546, QUEST_STATUS.STARTED) -- Start Mistery Guy quest
        end
        
        doSendMagicEffect(npcsPos.police1, EFFECT_TELEPORT_UP)
        doRemoveCreature(npcs.police1)
        doSendMagicEffect(npcsPos.police2, EFFECT_TELEPORT_UP)
        doRemoveCreature(npcs.police2)
        doSendMagicEffect(getCreaturePosition(npcId), EFFECT_TELEPORT_UP)
        addEvent(function(pos, jenny) doCreateNpc("Giovanni", pos) doRemoveCreature(jenny) end, 60 * 1000, getCreaturePosition(npcId), npcs.jenny)
        doRemoveCreature(npcId)
    end, 3000, npcId)
end

local npcBattleKantoMain = NpcBattle:new(getNpcName(), 9302, 9702, npcHandler)
npcBattleKantoMain:setPokemons({"Tauros", "Arbok", "Nidoking", "Machamp", "Rhydon", "Sandslash", "Dugtrio", "Onix", "Marowak",
    "Nidoqueen"})
npcBattleKantoMain:setRewardBaseExp(5000)
npcBattleKantoMain:setOneWin(true)
npcBattleKantoMain:setDifficulty(80)
npcBattleKantoMain:setPokemonDefeatExperienced(true)
npcBattleKantoMain:setOnEnd(function(cid, playerWin, npc)
    if (playerWin) then
        --local pos = {x = 5029, y = 485, z = 8}
        local pos = {x = 5030, y = 575, z = 9}
        local misteryGuy = doCreateNpc("Mistery Guy", pos)
        doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)

        addEvent(doCreatureSay, 3000, misteryGuy, "That's right trainer, thank you, meet me at my father.", TALKTYPE_SAY)
        addEvent(doRemoveCreature, 6000, misteryGuy)
        addEvent(doJennyScene, 6500, cid, npc)
    else
    end
end)

local GIOVANNI_KANTOMAIN10_POSITION = {x = 5031, y = 484, z = 8}
local GIOVANNI_KANTOMAIN10_2_POSITION = {x = 5032, y = 574, z = 9}
local isMisteryGuyAppearing = nil

local function doMisteryGuyAppear(cid)
    if (isMisteryGuyAppearing) then
        return
    end

    isMisteryGuyAppearing = true
    selfSay("Oh, I almost forgot. Guards! Bring him.", cid)
    
    local pos = {x = 5029, y = 485, z = 8}
    local npc = doCreateNpc("Mistery Guy", pos)
    doSendMagicEffect(pos, EFFECT_TELEPORT_DOWN)

    local rocket1Pos = {x = 5028, y = 485, z = 8}
    local rocket1 = doCreateNpc("Rocket", rocket1Pos)
    doSendMagicEffect(rocket1Pos, EFFECT_TELEPORT_DOWN)

    local rocket2Pos = {x = 5030, y = 485, z = 8}
    local rocket2 = doCreateNpc("Rocket", rocket2Pos)
    doSendMagicEffect(rocket2Pos, EFFECT_TELEPORT_DOWN)

    addEvent(doCreatureSay, 5000, npc, "ESCAPE MY FRIEND, RUN AWAY, GET HELP WITH MY FATHER! BRISCOE LEN!", TALKTYPE_SAY)
    addEvent(function()
        for i = 1, 30 do
            local tmpPos = getPositionRandomAdjacent(pos, 7)
            addEvent(function()
                doSendDistanceShoot(pos, tmpPos, PROJECTILE_GRAVEL)
                doSendMagicEffect(tmpPos, EFFECT_BIG_EXPLOSION)
            end, getRandom(1, 800))
        end end, 9000)
    addEvent(function()
        doCreatureSetStorage(cid, 8545, QUEST_STATUS.FINISHED) -- Just to enable Briscoe Lenn part
        doTeleportThing(cid, {x = 3652, y = 467, z = 7})
        isMisteryGuyAppearing = nil
        end, 10000)
    addEvent(function()
        doRemoveCreature(npc)
        doRemoveCreature(rocket1)
        doRemoveCreature(rocket2)
    end, 11000, npc)
    -- todo prevent this mistery guy version talk and the giovanni to talk too
end
-- KANTO MAIN 10 Stuff [END]

-- KANTO MAIN 12 Stuff [START]
local npcBattleKantoMain12 = NpcBattle:new(getNpcName(), 9303, 9703, npcHandler)
npcBattleKantoMain12:setPokemons({"Tauros", "Arbok", "Nidoking", "Machamp", "Rhydon", "Sandslash", "Dugtrio", "Onix", "Marowak",
    "Nidoqueen"})
npcBattleKantoMain12:setRewardBaseExp(5000)
npcBattleKantoMain12:setOneWin(true)
npcBattleKantoMain12:setDifficulty(80)
npcBattleKantoMain12:setPokemonDefeatExperienced(true)
npcBattleKantoMain12:setPokemonExtraStats(0.3)
npcBattleKantoMain12:setOnEnd(function(cid, playerWin, npc)
    if (playerWin) then
        selfSay("Now boy, you made me feel something I have not felt for many years. I had completely forgotten how to have that euphoria during duels pokemon, how it feels as one with your pokemon and I ended up turning it into a {business} only.", cid)
        npcHandler:addFocus(cid)
    else
    end
end)

local GIOVANNI_KANTOMAIN12_POSITION = {x = 5505, y = 88, z = 7}
-- KANTO MAIN 12 Stuff [END]

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    -- Kanto Main 10 Giovanni Version
    if (getSamePosition(getNpcPos(), GIOVANNI_KANTOMAIN10_POSITION)) then
        if (msgcontains(msg, 'friend') or msgcontains(msg, 'amigo')) then
            doMisteryGuyAppear(cid)
        else
            selfSay("So you are the kid who is messing me? Your {friend} told me a lot about you.", cid)
        end
        return true
    end

    -- Kanto Main 12 Giovanni Version
    if (getSamePosition(getNpcPos(), GIOVANNI_KANTOMAIN12_POSITION)) then
        if (getPlayerDefeatedNPC(cid, 9703)) then
            if (msgcontains(msg, 'business') or msgcontains(msg, 'negocio')) then
                selfSay("I do not regret having facilitated the creation of Mewtwo, but I will let him free he will decide what is best for you, now I and my subordinates of {team rocket} will from this island.", cid)

            elseif (msgcontains(msg, 'team') or msgcontains(msg, 'rocket') or msgcontains(msg, 'equipe')) then
                selfSay("The team rocket will continue with their activities, more than a different way ... Wait and see with their own eyes boy. See you some other day.", cid)
                doSendMagicEffect(getNpcPos(), EFFECT_TELEPORT_UP)
                doRemoveCreature(getNpcId())

            else
                selfSay("Now boy, you made me feel something I have not felt for many years. I had completely forgotten how to have that euphoria during duels pokemon, how it feels as one with your pokemon and I ended up turning it into a {business} only.", cid)
            end

        elseif(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
            talkState[talkUser] =  npcBattleKantoMain12:doTalkStart(getNpcId(), cid)

        elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            talkState[talkUser] =  npcBattleKantoMain12:doTalkEnd(getNpcId(), cid, talkState[talkUser])
        else
            selfSay("Your damn kid promise that this will be the last time you will annoy me! Let's {duel}!", cid)
        end
        return true
    end

    -- Giovanni Gym Version
    if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
        talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

    elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

    elseif (msgcontains(msg, 'tm')) then
        if (not getPlayerDefeatedNPC(cid, getNpcName())) then
            selfSay("You must defeat me before receive your reward.", cid)

        elseif (getCreatureStorage(cid, TM_STORAGE) == QUEST_STATUS.FINISHED) then
            selfSay("You already got this reward.", cid)

        else
            giveTm(cid)
            selfSay("Oh, here is!", cid)
        end

    else
        selfSay("Ok..", cid)
    end
    return true
end)
npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (getSamePosition(getNpcPos(), GIOVANNI_KANTOMAIN10_POSITION)) then
        selfSay("So you are the kid who is messing me? Your {friend} told me a lot about you.", cid)
        npcHandler:addFocus(cid)
        return false

    elseif (getSamePosition(getNpcPos(), GIOVANNI_KANTOMAIN10_2_POSITION)) then
        if (getCreatureStorage(cid, 8544) == QUEST_STATUS.STARTED) then
            if (not getPlayerDefeatedNPC(cid, 9702)) then
              selfSay("Your damn kid, I'll stop you now! Ready or not, it's time to duel!", cid)
              npcBattleKantoMain:doForceBattleStart(getNpcId(), cid)
            else
              selfSay("...", cid)
            end
        else
            selfSay("So you are the kid who is messing me? Your {friend} told me a lot about you.", cid)
        end

        npcHandler:addFocus(cid)
        return false

    elseif (getSamePosition(getNpcPos(), GIOVANNI_KANTOMAIN12_POSITION)) then
        selfSay("Your damn kid promise that this will be the last time you will annoy me! Let's {duel}!", cid)
        npcHandler:addFocus(cid)
        return false
    end
    return true
end)

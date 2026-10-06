setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

function onPlayerCloseChannel(cid) npcHandler:onPlayerCloseChannel(cid) end

function onPlayerEndTrade(cid) npcHandler:onPlayerEndTrade(cid) end

function sayStory(...) return npcHandler:sayStory(...) end

local FIRST_POKEMON_STORAGE = 8506
--local FIRSTY_CITY_STORAGE = 8507

local lastChoice = {}
local TALKSTATE_CONFIRM = 200
local TALKSTATE_CONFIRM_SEX = 201
local TALKSTATE_FIX_ASK = 202
--local starterTowns = { "viridian", "pewter", "cerulean", "saffron", "celadon", "vermilion", "fuchsia" }
--local inverseStarterTowns = table.inverse(starterTowns)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'fix') or msgcontains(msg, 'corrigir')) then
        selfSay("Yes, I can transform an old Starter Pokemon into an Egg Starter Pokemon. Do you want to do that?", cid)
        npcHandler.talkState[cid] = TALKSTATE_FIX_ASK
        return true
    elseif (npcHandler.talkState[cid] == TALKSTATE_FIX_ASK) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            elseif (not isItem(ball)) then
                selfSay("Please, put the poke ball at the ball slot!", cid)

            elseif (isBallPokemonFromEgg(ball.uid)) then
                selfSay("This is a Pokemon from egg!", cid)

            elseif (getBallOriginalTrainer(ball.uid) ~= getPlayerGUID(cid)) then
                selfSay("You aren't the Pokemon original trainer.", cid)

            else
                setBallIsNotPokemonFromEgg(ball.uid, false)
                setBallPokemonExtraPoints(ball.uid, getBallPokemonLevel(ball.uid) + 9)
                doBallUpdateDescription(ball.uid)
                selfSay("It's done!", cid)
            end

        else
            selfSay("Ok, maybe later.", cid)
        end

        npcHandler.talkState[cid] = nil
        return true
    end

    if (getCreatureStorage(cid, FIRST_POKEMON_STORAGE) ~= QUEST_STATUS.FINISHED and not getPlayerGotStarterPokemon(cid)) then
        if (msgcontains(msg, 'charmander')) then
            lastChoice[cid] = 'Charmander'
            npcHandler.talkState[cid] = TALKSTATE_CONFIRM
            selfSay("{YES} or {NO}", cid)
            selfSay("You really want a Charmander?", cid)

        elseif (msgcontains(msg, 'squirtle')) then
            lastChoice[cid] = 'Squirtle'
            npcHandler.talkState[cid] = TALKSTATE_CONFIRM
            selfSay("{YES} or {NO}", cid)
            selfSay("You really want a Squirtle?", cid)

        elseif (msgcontains(msg, 'bulbasaur')) then
            lastChoice[cid] = 'Bulbasaur'
            npcHandler.talkState[cid] = TALKSTATE_CONFIRM
            selfSay("{YES} or {NO}", cid)
            selfSay("You really want a Bulbasaur?", cid)

        elseif (npcHandler.talkState[cid] == TALKSTATE_CONFIRM) then
            if (msgcontains(msg, { 'yes', 'sim' })) then
                selfSay("Your Pokemon will be {female} or {male}?", cid)
                npcHandler.talkState[cid] = TALKSTATE_CONFIRM_SEX
            else
                selfSay("You can choose a {Charmander} or a {Squirtle} or a {Bulbasaur}. What is your choice?", cid)
                npcHandler.talkState[cid] = nil
            end

        elseif (npcHandler.talkState[cid] == TALKSTATE_CONFIRM_SEX) then
            local sex = nil
            if (msgcontains(msg, 'female') or msgcontains(msg, 'femea')) then
                sex = POKEMON_SEX_FEMALE
            elseif (msgcontains(msg, 'male') or msgcontains(msg, 'macho')) then
                sex = POKEMON_SEX_MALE
            end

            if (sex) then
                doCreatePokemonBall(cid, "soul", lastChoice[cid], 5, sex, nil, 14, cid, false, 999999, nil, nil, nil, nil, nil, nil, nil, nil, nil, function(ball) setBallOriginalTrainer(ball, cid) end)
                setPlayerGotStarterPokemon(cid, true)
                doPlayerAddMainItems(cid)
                doCreatureSetStorage(cid, FIRST_POKEMON_STORAGE, QUEST_STATUS.FINISHED)
                --                          selfSay("Here is, congratulations! Now which city you want to start out? {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion} or {Fuchsia}.", cid)
                selfSay("Good choice! Congratulations, here is your first {Pokemon}! Now, let's see if you're able to call him out of the Pokeball.", cid)
                doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "002-callPokemon")
                doCreatureSetStorage(cid, 8751, QUEST_STATUS.STARTED) -- Prof Oak quest auto-start
                npcHandler.talkState[cid] = nil
                lastChoice[cid] = nil

            else
                selfSay("Your Pokemon will be {female} or {male}?", cid)
            end

            return true

        else
            selfSay("You can choose a {Charmander} or a {Squirtle} or a {Bulbasaur}. What is your choice?", cid)
        end

        --    elseif (getCreatureStorage(cid, FIRSTY_CITY_STORAGE) ~= QUEST_STATUS.FINISHED and
        --            getCreatureStorage(cid, FIRST_POKEMON_STORAGE) == QUEST_STATUS.FINISHED) then
        --        msg = string.lower(msg)
        --        if (inverseStarterTowns[msg]) then
        --            local townId = getTownId(msg)
        --            doPlayerSetTown(cid, townId)
        --            selfSay("Here you go! Good luck! Remember that Pallet is always open to trainers that want to help!", cid)
        --            doCreatureSetStorage(cid, FIRSTY_CITY_STORAGE, QUEST_STATUS.FINISHED)
        --            doTeleportThing(cid, getTownTemplePosition(townId), false)
        --            doPlayerPopupFYI(cid, string.format("You are now in %s! Try to walk around and talk with NPCs to start out quests!\nSimple speak out \"Hi\" and \"Quest\". Try with \"Ray Fitz\".", msg))
        --
        --        else
        --            selfSay("Now which city you want to start out? {Viridian}, {Pewter}, {Cerulean}, {Saffron}, {Celadon}, {Vermilion} or {Fuchsia}.", cid)
        --        end

    elseif (getCreatureStorage(cid, 8753) == QUEST_STATUS.FINISHED) then
        selfSay("Now you must head to the north to find Red and complete your initial mission.", cid)

    else
        npcHandler.talkState[talkUser] = doQuestTalk(cid, "Professor Oak", msg, npcHandler.talkState[talkUser])
    end

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getSamePosition(getNpcPos(), { x = 5020, y = 788, z = 7 }) and getCreatureStorage(cid, FIRST_POKEMON_STORAGE) ~= QUEST_STATUS.FINISHED) then
        selfSay("You can choose a {Charmander} or a {Squirtle} or a {Bulbasaur}. What is your choice?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())

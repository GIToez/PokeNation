-- LAST STORAGE: 8397

local REWARD_TYPE = {}
REWARD_TYPE.ITEM = 1
REWARD_TYPE.POKEMON = 2
REWARD_TYPE.ADDON = 3

local QUEST_TYPE = {}
QUEST_TYPE.BRING_ITEMS = 0
QUEST_TYPE.BRING_POKEMON = 1
QUEST_TYPE.DEX_POKEMONS = 2
QUEST_TYPE.DEFEAT_POKEMON = 3 -- NOTE: This quest type only works with one defeat, example: Defeat 30 Charmander. Never try to: Defeat 30 Charmander and 25 Pikachu, this does not work
QUEST_TYPE.CATCH_POKEMON = 4 -- NOTE: This quest type only works with one caught, example: Caught 30 Charmander. Never try to: Caught 30 Charmander and 25 Pikachu, this does not work
QUEST_TYPE.CUSTOM = 5 -- Custom request function

QUEST_STATUS = {} -- Set as global to be used inside other systems
QUEST_STATUS.UNSTARTED = -1
QUEST_STATUS.STARTED = 0
QUEST_STATUS.FINISHED = 1
QUEST_STATUS.ERROR = 2 -- This fix the problem if the quest inst correctly configured, on getQuestStatus.

local TALK_STATE = {}
TALK_STATE.ERASE = 0
TALK_STATE.ACCEPTING = 1
TALK_STATE.FINISHING = 2

local DEFAULT_KEYWORDS = { "quest", "mission", "task", "help", "missao", "tarefa", "ajuda", "hi", "oi" }
local KEYWORDS = {}
KEYWORDS["Gary Oak"] = { "mission", "pokemon", "trainer", "quest", "mission", "task", "help", "missao", "tarefa", "ajuda", "treinador" }
KEYWORDS["Gord Scottie"] = { "mission", "task", "quest", "grape", "missao", "tarefa", "ajuda", "uva" }
KEYWORDS["Professor Ivy"] = { "mission", "task", "quest", "problem", "help", "missao", "tarefa", "ajuda", "problema" }
KEYWORDS["Roman"] = { "addon" }
KEYWORDS["Runford"] = { "orange", "archipelago", "arquipelago", "laranja" }
KEYWORDS["Stiller"] = { "addon" }
KEYWORDS["Zazi"] = { "fishing", "rod", "pesca" }
KEYWORDS["Abi"] = { "addon" }
KEYWORDS["Adventurer Lucy"] = { "mission", "task", "quest", "problem", "help", "location", "prophecy", "problema", "localizacao", "profecia", "missao", "tarefa", "ajuda" }
KEYWORDS["George Carter"] = { "mission", "research", "missao", "tarefa", "ajuda", "pesquisa" }
KEYWORDS["Mateo"] = { "quest", "mission", "task", "help", "onix", "missao", "tarefa", "ajuda" }
KEYWORDS["Merv Kelley"] = { "quest", "mission", "task", "help", "problems", "ingredients", "second", "fruit", "problemas", "ingredientes", "segunda", "fruta", "missao", "tarefa", "ajuda" }
KEYWORDS["Tereza Mendes"] = { "quest", "mission", "task", "help", "lipstick", "missao", "tarefa", "ajuda", "batom" }
KEYWORDS["Woodworker Courts Ted"] = { "quest", "mission", "task", "help", "boards", "missao", "tarefa", "ajuda", "tabuas" }
KEYWORDS["Oliver Terrel"] = { "quest", "mission", "task", "help", "finally", "missao", "tarefa", "ajuda", "finalmente" }
KEYWORDS["Jarrod"] = { "quest", "mission", "task", "help", "tests", "missao", "tarefa", "ajuda", "testes" }
KEYWORDS["Maurice"] = { "quest", "mission", "task", "help", "tv", "camera", "missao", "tarefa", "ajuda" }
KEYWORDS["Santa Claus"] = { "quest", "mission", "task", "help", "save", "missao", "tarefa", "ajuda", "salvar" }
KEYWORDS["Ash Ketchum"] = { "quest", "mission", "task", "help", "save", "missao", "tarefa", "ajuda", "salvar" }
KEYWORDS["Alex"] = { "quest", "mission", "task", "help", "forward", "last", "research", "missao", "tarefa", "ajuda", "em frente", "última", "pesquisa" }
KEYWORDS["Drew Wisdom"] = { "quest", "mission", "task", "help", "second", "outfit", "missao", "tarefa", "ajuda", "roupa" }
KEYWORDS["Julia"] = { "quest", "mission", "task", "help", "addon", "missao", "tarefa", "ajuda" }
KEYWORDS["Aldo Vumblevore"] = { "quest", "mission", "task", "help", "defeat", "missao", "tarefa", "ajuda", "derrotarmos" }
KEYWORDS["Daisy Oak"] = { "quest", "mission", "task", "help", "mountain", "missao", "tarefa", "ajuda", "montanha" }
KEYWORDS["Bill"] = { "quest", "mission", "task", "help", "find", "missao", "tarefa", "ajuda", "encontrar", "look", "olhar", "capture", "capturar" }
KEYWORDS["London Hamnet"] = { "quest", "mission", "task", "help", "red", "missao", "tarefa", "ajuda", "vermelha" }
KEYWORDS["Flanagan"] = { "quest", "mission", "task", "help", "ready", "continue", "instructions", "action", "missao", "tarefa", "ajuda", "pronto", "continuar", "instrucoes", "acao" }
KEYWORDS["Gosse"] = { "quest", "mission", "task", "help", "continue", "different", "missao", "tarefa", "ajuda", "continuar", "diferente" }
KEYWORDS["Shelley"] = { "quest", "mission", "task", "help", "continue", "pokedex", "HM", "missao", "tarefa", "ajuda", "continuar" }
KEYWORDS["Professor Oak"] = { "quest", "mission", "task", "help", "pokemon", "missao", "tarefa", "ajuda" }
KEYWORDS["Patton"] = { "quest", "mission", "task", "help", "pokemon", "journey", "missao", "tarefa", "ajuda", "jornada" }
KEYWORDS["Assistant Jofrey"] = { "quest", "mission", "task", "help", "professor", "headbutting", "missao", "tarefa", "ajuda", "cabecada" }
KEYWORDS["Brockling Salvadore"] = { "quest", "mission", "task", "help", "cost", "missao", "tarefa", "ajuda", "custo" }
KEYWORDS["Mistery Guy"] = { "quest", "mission", "task", "help", "terrible", "missao", "tarefa", "ajuda", "terrivel", "terrível", "terríveis" }
KEYWORDS["Queter Phill"] = { "quest", "mission", "task", "help", "defeat", "derrotar", "volunteers", "voluntarios", "ready", "pronto", "continue", "continuar" }
KEYWORDS["Officer Jeny"] = { "quest", "mission", "task", "help", "present", "presente" }
KEYWORDS["Martha May"] = { "quest", "mission", "task", "help", "hide", "esconde" }
KEYWORDS["Nagumo Harbor"] = { "quest", "mission", "task", "help", "paper", "papel", "molor vahoaris" }
KEYWORDS["Sotashi"] = { "quest", "mission", "task", "help", "nagumo" }
KEYWORDS["Ed Blackhood"] = { "quest", "mission", "task", "help", "sea dragon", "missao", "think", "pensar", "remember", "lembrei" }
KEYWORDS["Barba Roja"] = { "quest", "mission", "task", "help", "gold", "ouro" }
KEYWORDS["Calico"] = { "quest", "mission", "task", "help", "debt", "divida" }
KEYWORDS["Javy Dones"] = { "quest", "mission", "task", "help", "vacation", "ferias" }
KEYWORDS["Jack Spearow"] = { "quest", "mission", "task", "help", "second", "segunda", "shadow", "sombra" }
KEYWORDS["Kenelm Reilly"] = { "quest", "missao", "mission", "task", "tarefa", "help", "ajuda", "research", "pesquisa" }
KEYWORDS["Arron Deforest"] = { "quest", "missao", "mission", "task", "tarefa", "help", "ajuda", "pokemon", "trainer", "treinador" }
KEYWORDS["Warwick Howard"] = { "quest", "missao", "mission", "task", "tarefa", "help", "ajuda", "pokemon" }
KEYWORDS["Bertina Stacy"] = { "quest", "missao", "mission", "task", "tarefa", "help", "ajuda", "pokemon" }
KEYWORDS["Rusty Barret"] = { "quest", "missao", "mission", "task", "tarefa", "help", "ajuda", "fisherman", "pescador", "fish", "peixe" }

-- Quests
local QUESTS = {}

dofile(PS_LIB_CONFIG_DIR .. "003-quest.lua")

for k, v in pairs(QUESTS_CONFIG) do
    QUESTS[k] = v
end

QUESTS_CONFIG = table.clear(QUESTS_CONFIG)

--[[ This run on script load, automatic getting all the quests by type ]]
local DEFEAT_POKEMON_QUESTS, CATCH_POKEMON_QUESTS = {}, {}
for i, npcQuests in pairs(QUESTS) do
    for j, quest in ipairs(npcQuests) do
        if (quest.questType == QUEST_TYPE.DEFEAT_POKEMON) then
            table.insert(DEFEAT_POKEMON_QUESTS, quest)
        elseif (quest.questType == QUEST_TYPE.CATCH_POKEMON) then
            table.insert(CATCH_POKEMON_QUESTS, quest)
        end

        --
        --quest.talk_questStarting = string.createStory(quest.talk_questStarting)
        --quest.talk_questStarted = string.createStory(quest.talk_questStarted)
    end
end

local function getQuestStatus(pid, quest)
    return getCreatureStorage(pid, quest.storage) or QUEST_STATUS.ERROR
end

local function getCurrentQuest(pid, npcName)
    if (not QUESTS[npcName]) then
        log(LOG_TYPES.ERROR, "Quest:getCurrentQuest - Unkown NPC.", npcName)
        return false
    end

    for i = 1, #QUESTS[npcName] do
        local status = getQuestStatus(pid, QUESTS[npcName][i])
        if (status ~= QUEST_STATUS.FINISHED and status ~= QUEST_STATUS.ERROR and (status == QUEST_STATUS.STARTED or
                        (-- Quest status is unstarted
                        not QUESTS[npcName][i].blockStart and (not QUESTS[npcName][i].canStart or QUESTS[npcName][i].canStart(pid))))) then
            if (QUESTS[npcName][i].daily) then
                if (status > 100000) then -- Isn't the first time that I done this quest
                    for j, nextQuest in ipairs(QUESTS[npcName]) do
                        local nextQuestStatus = getQuestStatus(pid, nextQuest)
                        if ((nextQuest.daily and nextQuestStatus < 100000) or
                                (not nextQuest.daily and nextQuestStatus ~= QUEST_STATUS.FINISHED and
                                        nextQuestStatus ~= QUEST_STATUS.ERROR)) then
                            return nextQuest
                        end
                    end
                    if ((status - os.time()) <= 0) then
                        return QUESTS[npcName][i]
                    end
                end
                return QUESTS[npcName][i] -- TODO test
            elseif (not QUESTS[npcName][i].startPosition or getSamePosition(getNpcPos(), QUESTS[npcName][i].startPosition)) then
                return QUESTS[npcName][i]
            end
        end
    end
    return false --QUESTS[npcName][#QUESTS[npcName]] -- No more quests to do, just return the last
end

local function getQuestMessageFinish(quest, cid)
    local msg = __L(cid, quest.talk_questFinishing)
    if (quest.questType == QUEST_TYPE.BRING_ITEMS) then
        msg = msg .. " ("
        for i = 1, #quest.questRequest, 2 do
            msg = msg .. quest.questRequest[i + 1] .. " " .. getItemNameById(quest.questRequest[i])
            if ((i + 1) ~= #quest.questRequest) then
                msg = msg .. ", "
            end
        end
        msg = msg .. ")"
    elseif (quest.questType == QUEST_TYPE.BRING_POKEMON) then
        msg = msg .. " (" .. quest.questRequest .. ")"
    elseif (quest.questType == QUEST_TYPE.DEX_POKEMONS) then
        msg = msg .. " (" .. quest.questRequest .. __L(cid, " Pokemon dexed)")
    elseif (quest.questType == QUEST_TYPE.DEFEAT_POKEMON) then
        msg = msg .. " (" .. quest.questRequest[2] .. " " .. quest.questRequest[1] .. ")"
    elseif (quest.questType == QUEST_TYPE.CATCH_POKEMON) then
        msg = msg .. " (" .. quest.questRequest[2] .. " " .. quest.questRequest[1] .. ")"
    end
    return msg
end

local function setPlayerQuestStatus(pid, quest, status)
    doCreatureSetStorage(pid, quest.storage, status)
end

local function say(msg, cid)
    if (isString(msg)) then
        return selfSay(msg, cid)
    end
    return sayStory(msg, cid)
end

local function canFinishQuest(pid, quest)
    local questStatus = getQuestStatus(pid, quest)
    --    if ((questStatus > 100000 and quest.daily) and (questStatus - os.time()) > 0) then -- Daily quest
    if ((questStatus > 100000 and quest.daily) and (questStatus > getGlobalStorageValue(GLOBAL_STORAGES.SERVER_START_TIME))) then -- Daily quest
        return false
    end

    if (quest.canFinish and not quest.canFinish(pid)) then
        return false
    end

    if (quest.finishPosition and not getSamePosition(getNpcPos(), quest.finishPosition)) then
        return false
    end

    if (quest.questType == QUEST_TYPE.BRING_ITEMS) then
        for i = 1, #quest.questRequest, 2 do
            if (getPlayerItemCount(pid, quest.questRequest[i]) < quest.questRequest[i + 1]) then
                return false
            end
        end
        return true

    elseif (quest.questType == QUEST_TYPE.BRING_POKEMON) then
        if (isPokemonOnline(pid) or getPlayerMounted(pid) or isEvolving(pid)) then
            say("Before you complete this mission you need to call your Pokemon back.", pid)
            return false
        end

        for i, ball in ipairs(getPlayerAllBallsWithPokemon(pid)) do
            if (getBallPokemonName(ball.uid) == quest.questRequest and
                    getItemUniqueOwner(ball.uid) == ITEM_UNIQUE_OWNER_NONE) then
                return true
            end
        end
        return false

    elseif (quest.questType == QUEST_TYPE.DEX_POKEMONS) then
        return getPlayerTotalDexedPokemons(pid) >= quest.questRequest

    elseif (quest.questType == QUEST_TYPE.DEFEAT_POKEMON) then
        return getCreatureStorage(pid, quest.counterStorage) >= quest.questRequest[2]

    elseif (quest.questType == QUEST_TYPE.CATCH_POKEMON) then
        if (isPokemonOnline(pid)) then
            say("Before you complete this mission you need to call your Pokemon back.", pid)
            return false
        end

        if (getCreatureStorage(pid, quest.counterStorage) >= quest.questRequest[2]) then
            local count = quest.questRequest[2]
            for i, ball in ipairs(getPlayerAllBallsWithPokemon(pid)) do
                if (getBallPokemonName(ball.uid) == quest.questRequest[1] and not (getBallPokemonExtraPoints(ball.uid) > 0 or getBallHeld(ball.uid) or getBallTotalVitamins(ball.uid) > 0 or getBallPokemonNickname(ball.uid))) then
                    count = count - 1
                end
            end
            return count <= 0
        end

    elseif (quest.questType == QUEST_TYPE.CUSTOM and quest.questRequest) then
        return quest.questRequest(pid)
    end

    return false
end

function doPlayerStartQuest(pid, quest, npcName, questStorage)
    if (questStorage) then
        for _, q in pairs(QUESTS[npcName]) do
            if (q.storage == questStorage) then
                quest = q
                break
            end
        end
    end

    if (quest.daily) then -- Clear all dailys of this Npc to prevent conflict
        for _, q in pairs(QUESTS[npcName]) do
            if (q.daily) then
                setPlayerQuestStatus(pid, q, QUEST_STATUS.UNSTARTED)
            end
        end
    end

    say(string.createStory(__L(pid, quest.talk_questStarted)), pid)
    setPlayerQuestStatus(pid, quest, QUEST_STATUS.STARTED)

    if (quest.questStartItems) then
        for i = 1, #quest.questStartItems, 2 do
            doPlayerAddUniqueItem(pid, quest.questStartItems[i], quest.questStartItems[i + 1], true)
        end
    end

    if (quest.counterStorage) then
        doCreatureSetStorage(pid, quest.counterStorage, 0)
    end

    if (quest.onStart) then
        quest.onStart(pid)
    end
end

local function doPlayerFinishQuest(pid, quest)
    -- Remove player requested items, pokemon, etc.
    if (quest.questType == QUEST_TYPE.BRING_ITEMS) then
        for i = 1, #quest.questRequest, 2 do
            if (not doPlayerRemoveItem(pid, quest.questRequest[i], quest.questRequest[i + 1])) then
                log(LOG_TYPES.ERROR, "Quest::doPlayerFinishQuest - Can't remove player item.", getCreatureName(pid), quest)
            end
        end

    elseif (quest.questType == QUEST_TYPE.BRING_POKEMON) then
        for i, ball in ipairs(getPlayerAllBallsWithPokemon(pid)) do
            if (getBallPokemonName(ball.uid) == quest.questRequest and
                    getItemUniqueOwner(ball.uid) == ITEM_UNIQUE_OWNER_NONE) then
                if (not doRemoveItem(ball.uid)) then
                    log(LOG_TYPES.ERROR, "Quest::doPlayerFinishQuest - Can't remove player bring pokemon.", getCreatureName(pid), quest)
                end
                break
            end
        end

    elseif (quest.questType == QUEST_TYPE.CATCH_POKEMON) then
        local count = quest.questRequest[2]
        for i, ball in ipairs(getPlayerAllBallsWithPokemon(pid)) do
            if (getBallPokemonName(ball.uid) == quest.questRequest[1] and not (getBallPokemonExtraPoints(ball.uid) > 0 or getBallHeld(ball.uid) or getBallTotalVitamins(ball.uid) > 0 or getBallPokemonNickname(ball.uid))) then
                if (not doRemoveItem(ball.uid)) then
                    log(LOG_TYPES.ERROR, "Quest::doPlayerFinishQuest - Can't remove player catch pokemon.", getCreatureName(pid), quest)
                end
                count = count - 1
                if (count <= 0) then
                    break
                end
            end
        end
    end

    -- Add player quest items
    if (quest.rewardItems) then
        for i, questReward in ipairs(quest.rewardItems) do
            if (questReward.type == REWARD_TYPE.ITEM) then
                if (not doPlayerSafeAddItem(pid, questReward.id, questReward.count, true, questReward.unique)) then
                    log(LOG_TYPES.ERROR, "quest:doPlayerFinishQues - Give Reward - Can't give reward.", getCreatureName(pid), quest, questReward)
                end

            elseif (questReward.type == REWARD_TYPE.POKEMON) then
                if (questReward.unique) then
                    setItemUniqueOwner(doCreatePokemonBall(pid, "poke", questReward.name, questReward.level, nil, nil, 0, nil, false), pid)
                else
                    doCreatePokemonBall(pid, "poke", questReward.name, questReward.level, nil, nil, 0, nil, false, 999999)
                end

            elseif (questReward.type == REWARD_TYPE.ADDON) then
                if (questReward.female) then
                    doPlayerAddOutfit(pid, questReward.female.looktype, questReward.female.addons)
                end
                if (questReward.male) then
                    doPlayerAddOutfit(pid, questReward.male.looktype, questReward.male.addons)
                end

                doPlayerSendOutfitWindow(pid)
                doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You got a new outfit.")
            end
        end
    end

    -- Add player quest experience
    if (quest.rewardExp and quest.rewardExp > 0) then
        doPlayerAddExperience(pid, quest.rewardExp)
        doSendAnimatedText(getCreaturePosition(pid), "+EXP!", COLOR_LIGHTGREEN)
    end

    if (quest.daily) then
        --    setPlayerQuestStatus(pid, quest, (os.time() + 23 * 60 * 60))
        setPlayerQuestStatus(pid, quest, os.time())
        doPlayerAddStatistic(pid, PLAYER_STATISTIC_IDS.COMPLETE_DAILY_QUEST, 1)
    else
        setPlayerQuestStatus(pid, quest, QUEST_STATUS.FINISHED)
        doPlayerAddStatistic(pid, PLAYER_STATISTIC_IDS.COMPLETE_QUEST, 1)
    end

    --    say(quest.talk_questFinished, pid)
    say(string.createStory(__L(pid, quest.talk_questFinished)), pid)

    if (quest.onEnd) then
        quest.onEnd(pid)
    end
end

local function canStartQuest(pid, quest)
    if (quest.startPosition and not getSamePosition(getNpcPos(), quest.startPosition)) then
        return false
    end

    local questStatus = getQuestStatus(pid, quest)
    if (questStatus == QUEST_STATUS.UNSTARTED) then
        return not quest.requiredLevel or getPlayerLevel(pid) >= quest.requiredLevel

    elseif (questStatus > 100000 and quest.daily) then -- Daily quest
        --    return (questStatus - os.time()) <= 0
        return questStatus <= getGlobalStorageValue(GLOBAL_STORAGES.SERVER_START_TIME)
    end

    return false
end

function doQuestTalkStart(pid, npcName, quest)
    local currentQuest = quest or getCurrentQuest(pid, npcName)
    if (currentQuest) then
        local questStatus = getQuestStatus(pid, currentQuest)

        if (questStatus == QUEST_STATUS.UNSTARTED) then
            if (currentQuest.startPosition and not getSamePosition(getNpcPos(), currentQuest.startPosition)) then
                selfSay("Sorry, I can't help you.", pid)
                return TALK_STATE.ERASE
            end

            if (currentQuest.requiredLevel and getPlayerLevel(pid) < currentQuest.requiredLevel) then
                selfSay(string.format(__L(pid, "Sorry, you need at least level %s to accept this mission."), currentQuest.requiredLevel), pid)
                return TALK_STATE.ERASE

            else
                selfSay("(Start quest? {YES} or {NO})", pid)
                say(string.createStory(__L(pid, currentQuest.talk_questStarting)), pid)
                return TALK_STATE.ACCEPTING
            end

        elseif (questStatus == QUEST_STATUS.STARTED) then
            if (currentQuest.finishPosition and not getSamePosition(getNpcPos(), currentQuest.finishPosition)) then
                selfSay("Sorry, I can't help you.", pid)
                return TALK_STATE.ERASE
            end

            selfSay("(End quest? {YES} or {NO})", pid)
            say(getQuestMessageFinish(currentQuest, pid), pid)
            return TALK_STATE.FINISHING

        elseif (questStatus > 100000 and currentQuest.daily) then -- Daily quest
            --      local diff = questStatus - os.time()
            local diff = questStatus - getGlobalStorageValue(GLOBAL_STORAGES.SERVER_START_TIME)
            if (diff > 0) then
                diff = getGlobalStorageValue(GLOBAL_STORAGES.SERVER_START_TIME) + 23 * 60 * 60
            end

            if (diff > 0) then
                selfSay(string.format(__L(pid, "You have done this mission in the last 24 hours, you must wait %s minutes to be able to do it again."), math.ceil(diff / 60)), pid)
            else
                selfSay("(Start quest? {YES} or {NO})", pid)
                say(string.createStory(__L(pid, currentQuest.talk_questStarting)), pid)
                return TALK_STATE.ACCEPTING
                --[[
                        selfSay("(End daily quest? {yes} or {no})", pid)
                        say(currentQuest.talk_questFinishing, pid)
                        return TALK_STATE.FINISHING
                        ]]
            end

        else
            selfSay("Sorry, I can't help you.", pid)
            return TALK_STATE.ERASE
        end
    else
        selfSay("Sorry, I can't help you right now.", pid) --say(currentQuest.talk_questDone, pid)
        return TALK_STATE.ERASE
    end
end

function doQuestTalkEnd(pid, npcName, talkState, quest)
    local currentQuest = quest or getCurrentQuest(pid, npcName)
    if (currentQuest) then
        if (talkState == TALK_STATE.ACCEPTING) then
            if (canStartQuest(pid, currentQuest)) then
                doPlayerStartQuest(pid, currentQuest, npcName)
            else
                selfSay("Sorry, I can't help you.", pid)
            end

        elseif (talkState == TALK_STATE.FINISHING) then
            if (canFinishQuest(pid, currentQuest)) then
                doPlayerFinishQuest(pid, currentQuest)
            else
                say(currentQuest.talk_questFinishFail, pid)
            end

        else
            selfSay("Hmm?", pid)
        end
    else
        selfSay("Sorry, I can't help you.", pid)
    end
    return TALK_STATE.ERASE
end

function doQuestTalk(pid, npcName, msg, talkState, quest)
    if (msgcontains(msg, "yes") or msgcontains(msg, 'sim')) then
        return doQuestTalkEnd(pid, npcName, talkState, quest)
    end

    local continue = false
    for _, keyword in pairs(DEFAULT_KEYWORDS) do
        if (msgcontains(msg, keyword)) then
            continue = true
            break
        end
    end

    if (not continue and KEYWORDS[npcName]) then
        for _, keyword in pairs(KEYWORDS[npcName]) do
            if (msgcontains(msg, keyword)) then
                continue = true
                break
            end
        end
    end

    if (continue) then
        return doQuestTalkStart(pid, npcName, quest)
    end

    selfSay("Hmm?", pid)
    return TALK_STATE.ERASE
end

function doQuestDefeat(cid, pokemonName)
    for i, quest in ipairs(DEFEAT_POKEMON_QUESTS) do
        if (quest.questRequest[1] == pokemonName and getQuestStatus(cid, quest) == QUEST_STATUS.STARTED) then
            local count = getCreatureStorage(cid, quest.counterStorage)
            if (count < quest.questRequest[2]) then
                doCreatureSetStorage(cid, quest.counterStorage, count + 1)
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Defeat Task: %s - step complete [%s/%s]."), pokemonName, count + 1, quest.questRequest[2]))
                return
            end
        end
    end
end

function doQuestCatch(cid, pokemonName)
    for i, quest in ipairs(CATCH_POKEMON_QUESTS) do
        if (quest.questRequest[1] == pokemonName and getQuestStatus(cid, quest) == QUEST_STATUS.STARTED) then
            local count = getCreatureStorage(cid, quest.counterStorage)
            if (count < quest.questRequest[2]) then
                doCreatureSetStorage(cid, quest.counterStorage, count + 1)
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Catch Task: %s - step complete [%s/%s]."), pokemonName, count + 1, quest.questRequest[2]))
                return
            end
        end
    end
end

function getNpcRandomQuest(npcName)
    return table.random(QUESTS[npcName])
end

function getNpcQuests(npcName)
    return QUESTS[npcName]
end
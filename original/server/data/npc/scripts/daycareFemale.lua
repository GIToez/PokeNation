local EGG_RANDOM_MAX = 300

-- Counter Feature Start
local function getPlayerEggTries(cid, pokemonNumber)
    local ret, res = 0, db.getResult("SELECT tries FROM `egg_counter` WHERE `player_id`=" ..
            getPlayerGUID(cid) .. " AND `pokemon_id`=" .. pokemonNumber .. " LIMIT 1;")
    if (res:getID() ~= -1) then
        ret = res:getDataInt("tries")
        res:free()
    end
    return ret
end

local function doPlayerIncreaseEggTries(cid, pokemonNumber)
    local query = {}
    query[1] = "INSERT INTO `egg_counter` (`player_id`, `pokemon_id`, `tries`) VALUES ("
    query[2] = getPlayerGUID(cid)
    query[3] = ","
    query[4] = pokemonNumber
    query[5] = ",1) ON DUPLICATE KEY UPDATE `tries`=`tries` + 1;"

    if (not db.executeQuery(table.concat(query))) then
        log(LOG_TYPES.ERROR, "doPlayerIncreaseEggTries - Couldn't execute query", table.concat(query))
    end
end

local function doPlayerResetEggTries(cid, pokemonNumber)
    local query = {}
    query[1] = "DELETE FROM `egg_counter` WHERE `player_id`="
    query[2] = getPlayerGUID(cid)
    query[3] = " AND `pokemon_id`="
    query[4] = pokemonNumber
    query[5] = ";"

    if (not db.executeQuery(table.concat(query))) then
        log(LOG_TYPES.ERROR, "doPlayerResetEggTries - Couldn't execute query", table.concat(query))
    end
end

local function getPlayerEggChance(cid, pokemonOnDaycare)
    local defaultChance = (getPokemonEggGenerationChance(pokemonOnDaycare:getDataString('pokemon_name')) + (getPlayerExtraEggRateValue(cid) * 10))
    local triesFactor = getPlayerEggTries(cid, getPokemonNumberByName(pokemonOnDaycare:getDataString('pokemon_name'))) / (31 --[[60]] - defaultChance) -- 31 = 1 [min_chance] (eg eevee) + min_days_to_activate ignore this -> (old)55 ~ 40
    return math.ceil(defaultChance + (triesFactor > 1.0 and ((triesFactor - 1.0) * (EGG_RANDOM_MAX - defaultChance) --[[(defaultChance)]]) or 0))
end

--local function getPlayerEggChance(cid, pokemonOnDaycare)
--local defaultChance = getPokemonEggGenerationChance(pokemonOnDaycare:getDataString('pokemon_name'))
--local triesFactor = getPlayerEggTries(cid, getPokemonNumberByName(pokemonOnDaycare:getDataString('pokemon_name'))) / (60 - defaultChance) -- 55 ~ 40
--local ret = defaultChance + (triesFactor > 1.0 and ((triesFactor - 1.0) * (--[[300 - ]]defaultChance)) or 0)
--ret = ret * 1.5
--return math.ceil(ret)
--end
-- Counter Feature End
-- Plates S
local function getPlayerDaycarePlate(cid)
    local r = db.getResult(string.concat("SELECT item_id FROM `daycare_plates` WHERE `player_id`='",
        getPlayerGUID(cid), "' LIMIT 1;"))
    if (r:getID() ~= -1) then
        local v = r:getDataInt('item_id')
        r:free()
        return v
    end
    return nil
end

local function setPlayerDaycarePlate(cid, item_id)
    if (item_id) then
        local query = {}
        query[1] = "INSERT INTO `daycare_plates` (`player_id`, `item_id`) VALUES ("
        query[2] = getPlayerGUID(cid)
        query[3] = ","
        query[4] = item_id
        query[5] = ");"

        if (not db.executeQuery(table.concat(query))) then
            log(LOG_TYPES.ERROR, "setPlayerDaycarePlate - Add - Couldn't execute query", table.concat(query))
            return false
        end
        return true

    else -- Delete it
        local query = {}
        query[1] = "DELETE FROM `daycare_plates` WHERE `player_id`="
        query[2] = getPlayerGUID(cid)
        query[3] = ";"

        if (not db.executeQuery(table.concat(query))) then
            log(LOG_TYPES.ERROR, "setPlayerDaycarePlate - Remove - Couldn't execute query", table.concat(query))
        end
    end

    return false
end

-- Plates E

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastName = {}
local lastTrainTime = {}
local lastPlate = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local TALK_STATES = {
    NONE = 0,
    QUESTION_LEAVE_POKEMON_NAME = 1,
    QUESTION_LEAVE_POKEMON = 2,
    QUESTION_WITHDRAW_POKEMON = 3,
    QUESTION_WITHDRAW_POKEMON_WITHOUT_TRAINING = 4,
    QUESTION_LEAVE_POKEMON_TIME = 5,
    ASKING_PLATE_NAME = 6,
    DEPOSIT_PLATE_CONFIRM = 7,
    REMOVE_PLATE_CONFIRM = 8
}

local EGG_STATUS_NO_MALE_POKEMON = 0
local EGG_STATUS_NEED_MORE_TIME = 1
local EGG_STATUS_INCOMPATIBLE = 2
local EGG_STATUS_HAS_CHANCE = 3
local EGG_STATUS_PLAYER_NEED_MORE_TIME = 4

local TIME_BETWEEN_EACH_EGG = 60 * 60 * 24 * 15 -- 15 days
local TRAIN_TIME_OPTIONS = { 1440, 2880 }
local MIN_TRAIN_TIME_TO_EGG = TRAIN_TIME_OPTIONS[1] --1440
local MAX_TRAIN_TIME = TRAIN_TIME_OPTIONS[#TRAIN_TIME_OPTIONS] --2880 -- 2 days

local function getPokemonGainExpPerMinute(pokemonLevel)
    if (pokemonLevel >= 100) then
        return 0
    elseif (pokemonLevel > 75) then
        return 210
    elseif (pokemonLevel > 50) then
        return 140
    end
    return 70
end

local function getPricePerMinute(pokemonLevel)
    if (pokemonLevel > 75) then
        return 4
    elseif (pokemonLevel > 50) then
        return 2
    end
    return 1
end

local function getPlayerPokemonOnDaycareByGUID(guid)
    local dbResult = db.getResult("SELECT * FROM `daycare_female` WHERE `player_id` = '" .. guid .. " LIMIT 1';")
    if dbResult:getID() == -1 then
        return false
    end
    return dbResult
end

local function getPlayerPokemonOnDaycare(cid)
    return getPlayerPokemonOnDaycareByGUID(getPlayerGUID(cid))
end

local function getPlayerMalePokemonOnDaycare(cid)
    local dbResult = db.getResult("SELECT * FROM `daycare_male` WHERE `player_id` = '" .. getPlayerGUID(cid) .. " LIMIT 1';")
    if dbResult:getID() == -1 then
        return false
    end
    return dbResult
end

local function getPlayerLastEggTime(cid)
    local accountPlayers = getAllPlayersByAccountId(getPlayerAccountId(cid))
    local lastTime = 0
    for i, player in ipairs(accountPlayers) do
        local result = db.getResult("SELECT `lasteggtime` FROM `players` WHERE `id` = '" .. player .. "' LIMIT 1;")
        if (result:getID() ~= -1 and result:getDataInt('lasteggtime') > lastTime) then
            lastTime = result:getDataInt('lasteggtime')
        end
    end
    return lastTime
end

local function setPlayerLastEggTime(cid, mTime)
    db.executeQuery("UPDATE `" .. getConfigValue('sqlDatabase') .. "`.`players` SET `lasteggtime` = '" .. mTime .. "' WHERE `players`.`id` ='" .. getPlayerGUID(cid) .. "';")
end

local function getPlayerPokemonOnDaycareTrainedMinutes(cid, data)
    if (not data) then
        data = getPlayerPokemonOnDaycare(cid)
    end
    local trainedMinutes = math.floor((os.time() - data:getDataInt('date')) / 60)
    local maxTrainTime = data:getDataInt('max_training_minutes')
    if (trainedMinutes > maxTrainTime) then
        trainedMinutes = maxTrainTime
    end
    return trainedMinutes
end

local function doPlayerLeavePokemonOnDaycare(cid, ball, trainTime)
    local query = string.concat("INSERT INTO daycare_female (player_id, date, ball_id, max_training_minutes, pokemon_name, pokemon_level, attributes) VALUES (",
        getPlayerGUID(cid), ",",
        os.time(), ",",
        ball.itemid, ",",
        trainTime, ",",
        "'", getBallPokemonName(ball.uid), "',",
        "'", getBallPokemonLevel(ball.uid), "',",
        getItemAttributesBlob(ball.uid), ");")

    if (db.executeQuery(query)) then
        doRemoveItem(ball.uid)
        doPlayerSave(cid) -- let's save to prevent clone balls
        return true
    else
        log(LOG_TYPES.ERROR, "daycareFemale:doPlayerLeavePokemonOnDaycare - Can't query.", query)
    end

    return false
end

local function doPlayerWithdrawPokemonFromDaycare(cid, data, cancelTraining)
    if (not data) then
        data = getPlayerPokemonOnDaycare(cid)
    end

    local beforeDepotFunction = function(ball) -- This need to be executed before the item goes to depot, because the item can't be modified after it goes to depot
        local minTrained = getPlayerPokemonOnDaycareTrainedMinutes(cid, data)
        local pokemonLevel = getBallPokemonLevel(ball)
        local pokemonExp = getBallPokemonExp(ball)
        local gainExtraPoints = pokemonLevel

        if (not cancelTraining) then
            pokemonExp = pokemonExp + (getPokemonGainExpPerMinute(pokemonLevel) * minTrained)
            if (pokemonExp > getExperienceForLevel(POKEMON_LEVEL_MAX)) then
                pokemonExp = getExperienceForLevel(POKEMON_LEVEL_MAX)
            end

            pokemonLevel = getLevelByExp(pokemonExp)
        end
        gainExtraPoints = math.floor((pokemonLevel - gainExtraPoints) / 2) -- 50% of gain level

        setBallPokemonExp(ball, pokemonExp)
        setBallPokemonLevel(ball, pokemonLevel)
        setBallPokemonExtraPoints(ball, getBallPokemonExtraPoints(ball) + gainExtraPoints)
        doBallUpdateDescription(ball)
    end

    local ball
    if (data:getDataInt('pokemon_maxenergy') > 0) then -- Fix to older trains
        ball = doCreatePokemonBall(cid, data:getDataInt('ball_id'), data:getDataString('pokemon_name'),
            data:getDataInt('pokemon_level'), data:getDataInt('pokemon_sex'),
            data:getDataString('pokemon_nickname'), data:getDataInt('pokemon_extrapoints'), nil, nil, 999999,
            data:getDataInt('pokemon_experience'), data:getDataInt('pokemon_specialability'),
            data:getDataInt('pokemon_tm1'), data:getDataInt('pokemon_tm1_slot'),
            data:getDataInt('pokemon_tm2'), data:getDataInt('pokemon_tm2_slot'), data:getDataInt('ball_seal'),
            nil, nil, beforeDepotFunction)
    else
        ball = doCreatePokemonBall(cid, data:getDataInt('ball_id'), nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil, true, { column = 'attributes', result = data:getID() },
            beforeDepotFunction)
    end

    if (not ball) then
        log(LOG_TYPES.ERROR, "daycareFemale:doPlayerWithdrawPokemonFromDaycare - Can't create ball.",
            getCreatureName(cid), data)
        return false
    end

    local query = string.concat("DELETE FROM daycare_female WHERE player_id='", data:getDataInt('player_id'),
        "'")
    if (db.executeQuery(query)) then
        doPlayerSave(cid) -- let's save to prevent clone balls
        return true
    else
        log(LOG_TYPES.ERROR, "daycareFemale:doPlayerWithdrawPokemonFromDaycare - Can't query.", query)
        doRemoveItem(ball)
    end

    return false
end

local function getPlayerRemaingTimeToGenerateAnotherEgg(cid)
    return (getPlayerLastEggTime(cid) + TIME_BETWEEN_EACH_EGG) - os.time()
end

local function getPokemonOnDaycareEggStatus(cid, femalePokemonOnDaycare)
    local malePokemonOnDaycare = getPlayerMalePokemonOnDaycare(cid)

    if (not malePokemonOnDaycare or
            ((malePokemonOnDaycare:getDataString('pokemon_name') ~= "Ditto" and
                    femalePokemonOnDaycare:getDataString('pokemon_name') ~= "Ditto") and
                    getMonsterInfo(malePokemonOnDaycare:getDataString('pokemon_name')).sex == POKEMON_SEX_UNKNOWN)) then
        return EGG_STATUS_NO_MALE_POKEMON

    elseif (getPlayerPokemonOnDaycareTrainedMinutes(cid, femalePokemonOnDaycare) < MIN_TRAIN_TIME_TO_EGG or
            getPlayerPokemonOnDaycareTrainedMinutes(cid, malePokemonOnDaycare) < MIN_TRAIN_TIME_TO_EGG) then
        return EGG_STATUS_NEED_MORE_TIME

    elseif (not canPokemonBreed(femalePokemonOnDaycare:getDataString('pokemon_name'),
        malePokemonOnDaycare:getDataString('pokemon_name'))) then
        return EGG_STATUS_INCOMPATIBLE

    elseif (getPlayerRemaingTimeToGenerateAnotherEgg(cid) > 0) then
        return EGG_STATUS_PLAYER_NEED_MORE_TIME

    else
        return EGG_STATUS_HAS_CHANCE
    end
end

local function doPlayerAddPokemonEgg(cid, femalePokemonOnDaycare, malePokemonOnDaycare)
    local femaleName = femalePokemonOnDaycare:getDataString('pokemon_name')
    local maleName = malePokemonOnDaycare:getDataString('pokemon_name')
    local egg = femaleName

    if (femaleName == "Ditto") then -- When the female is a Ditto, the egg will be by the male race
        egg = maleName

    elseif (femaleName == "Nidorana" and maleName == "Ditto") then -- When the female is a Nidorana and the male is a Ditto, the egg wil be a Nidorana or a Nidorano
        egg = table.random({ "Nidorana", "Nidorano" })
    end

    local plateType
    if (getPlayerDaycarePlate(cid)) then
        plateType = TYPE_BY_PLATE_ITEMID[getPlayerDaycarePlate(cid)]
    end

    if (PokemonEgg.doGenerateEggMove(doPlayerAddItem(cid, getPokemonEggId(egg), 1, true), egg, plateType)) then
        setPlayerDaycarePlate(cid, nil)
    end
    setPlayerLastEggTime(cid, os.time())
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.GENERATE_POKEMON_EGG, 1)
    doDatalogEggGenerate(cid, egg, os.time(), getPlayerEggTries(cid, getPokemonNumberByName(egg)))
end

local function hasSameAccountCharacterUsingDaycare(cid)
    local accountPlayers = getAllPlayersByAccountId(getPlayerAccountId(cid))
    for i, player in ipairs(accountPlayers) do
        if (getPlayerPokemonOnDaycareByGUID(player)) then
            return true
        end
    end
    return false
end

local function getTrainOptionsMessage(cid)
    local message = ""
    for i, option in ipairs(TRAIN_TIME_OPTIONS) do
        if (i ~= #TRAIN_TIME_OPTIONS) then
            message = message .. "{" .. option .. __L(cid, "} minutes, ")
        else
            message = message .. __L(cid, "or {") .. option .. __L(cid, "} minutes.")
        end
    end
    return message
end

--local trainOptionsMessage = getTrainOptionsMessage()
--getTrainOptionsMessage = nil

--

function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    msg = string.lower(msg)

    if (msgcontains(msg, 'daycare')) then
        selfSay("In this place you can {leave} your Pokemon in our care, we will train him for you. You can also {deposit} a plate to influence your Pokemon egg move generation.", cid)

    elseif (msgcontains(msg, 'pokemon')) then
        if (getPlayerPokemonOnDaycare(cid)) then
            selfSay("You have a Pokemon being trained by me at this moment! You can see his {status}, {egg status} or {withdraw} it.", cid)

        else
            selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)
        end

    elseif (msgcontains(msg, 'deposit') or msgcontains(msg, 'depositar')) then
        selfSay("Oh, you want to deposit a plate here huh? So what plate do you want to deposit?", cid)
        talkState[talkUser] = TALK_STATES.ASKING_PLATE_NAME

    elseif (talkState[talkUser] == TALK_STATES.ASKING_PLATE_NAME) then
        local msg = string.lower(msg)
        if (not getPlateItemIdByName(msg)) then
            selfSay("Sorry, there is no plate with this name!", cid)
            talkState[talkUser] = TALK_STATES.NONE
            return true
        end

        local plateItemId = getPlateItemIdByName(msg)

        selfSay(string.format(__L(cid, "You really want to deposit %s %s?"), __L(cid, getItemArticleById(plateItemId)),
            getItemNameById(plateItemId)), cid)
        talkState[talkUser] = TALK_STATES.DEPOSIT_PLATE_CONFIRM
        lastPlate[cid] = plateItemId

    elseif (talkState[talkUser] == TALK_STATES.DEPOSIT_PLATE_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            if (getPlayerDaycarePlate(cid)) then
                selfSay("You already have got a plate here! You can {remove} it if you want.", cid)

            elseif (getPlayerItemCount(cid, lastPlate[cid]) < 1) then
                selfSay("You don't have any of this plate!", cid)

            elseif (setPlayerDaycarePlate(cid, lastPlate[cid])) then
                doPlayerRemoveItem(cid, lastPlate[cid], 1)
                selfSay("Great, I will keep it for you.", cid)
            else
                selfSay("Something goes wrong! Please try again later.", cid)
                log(LOG_TYPES.ERROR, "DaycareFemale::depositPlate - Can't save player plate.", getPlayerName(cid),
                    lastPlate[cid])
            end
        else
            selfSay("Yah, maybe later.", cid)
        end

        talkState[talkUser] = TALK_STATES.NONE
        lastPlate[cid] = nil

    elseif (msgcontains(msg, 'remove') or msgcontains(msg, 'remover')) then
        selfSay("Do you really want to remove the plate that you deposited here?", cid)
        talkState[talkUser] = TALK_STATES.REMOVE_PLATE_CONFIRM

    elseif (talkState[talkUser] == TALK_STATES.REMOVE_PLATE_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            if (not getPlayerDaycarePlate(cid)) then
                selfSay("You do not have any plate here!", cid)

            else
                local plate = getPlayerDaycarePlate(cid)
                setPlayerDaycarePlate(cid, nil)
                doPlayerSafeAddItem(cid, plate, 1, true)
                selfSay("Ok, I found it. It's here.", cid)
            end
        else
            selfSay("Yah, maybe later.", cid)
        end

        talkState[talkUser] = TALK_STATES.NONE
        lastPlate[cid] = nil

    elseif (msgcontains(msg, 'status')) then
        local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)
        if (not pokemonOnDaycare) then
            selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)

        else
            local min = getPlayerPokemonOnDaycareTrainedMinutes(cid, pokemonOnDaycare)
            local pokemonLevel = pokemonOnDaycare:getDataInt('pokemon_level')
            local eggStatus = getPokemonOnDaycareEggStatus(cid, pokemonOnDaycare)

            selfSay(string.format(__L(cid, "Your {%s} has been training for {%s minutes} and has earned {%s experience points}. The price to remove your Pokemon is {%s dollars}. You can also {cancel} the training.%s"), pokemonOnDaycare:getDataString('pokemon_name'), min, getPokemonGainExpPerMinute(pokemonLevel) * min, getPricePerMinute(pokemonLevel) * min, (getPlayerDaycarePlate(cid) and (string.format(__L(cid, " Remeber that I have one of your %s plate here."), PLATE_NAME_BY_ITEMID[getPlayerDaycarePlate(cid)])) or "")), cid)

            local remaingTime = getPlayerRemaingTimeToGenerateAnotherEgg(cid)
            if (remaingTime > 0) then
                selfSay(string.format(__L(cid, "Egg status: You have already generated an egg recently, you must wait fifteen days after produce an egg to generate another. Remaing %s."), table.concat(string.timediff(remaingTime, cid))), cid)
                return true
            end

            if (eggStatus == EGG_STATUS_PLAYER_NEED_MORE_TIME) then
                selfSay(string.format(__L(cid, "Egg status: You have already generated an egg recently, you must wait fifteen days after produce an egg to generate another. Remaing %s."), table.concat(string.timediff((getPlayerLastEggTime(cid) + TIME_BETWEEN_EACH_EGG) - os.time(), cid))), cid)

            elseif (eggStatus == EGG_STATUS_NO_MALE_POKEMON) then
                selfSay("Egg status: You don't have a male Pokemon being trained as well.", cid)

            elseif (eggStatus == EGG_STATUS_NEED_MORE_TIME) then
                selfSay(string.format(__L(cid, "Egg status: The two need to be training for at least %s minutes (24 hours) to take chances to breed."), MIN_TRAIN_TIME_TO_EGG), cid)

            elseif (eggStatus == EGG_STATUS_INCOMPATIBLE) then
                selfSay("Egg status: The two don't seem to like each other. No chance of producing an egg.", cid)

            elseif (eggStatus == EGG_STATUS_HAS_CHANCE) then
                selfSay("Egg status: The two seem to get along very well. There is a chance of producing an egg, when you remove the Pokemon from here you will see the result.", cid)
            end
        end

    elseif (msgcontains(msg, 'withdraw') or msgcontains(msg, 'sacar')) then
        local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

        if (not pokemonOnDaycare) then
            selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)

        else
            talkState[talkUser] = TALK_STATES.QUESTION_WITHDRAW_POKEMON

            selfSay("Do you want to remove your Pokemon from the daycare?", cid)
        end

    elseif (msgcontains(msg, 'leave') or msgcontains(msg, 'deixar')) then
        local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

        if (pokemonOnDaycare) then
            selfSay("You have a Pokemon being trained by me at this moment! You can {withdraw} it if you want.", cid)

        else
            if (getPlayerLevel(cid) < 85) then
                selfSay("Sorry, only players with at least level 85 can use this service.", cid)

            elseif (not isPremium(cid)) then
                selfSay("Sorry, only players with a premium account can use this service.", cid)

            elseif (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            elseif (hasSameAccountCharacterUsingDaycare(cid)) then
                selfSay("Sorry, a character of your account is already using our services.", cid)

            else
                talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON_NAME

                selfSay("So what's the name of your Pokemon that you want to leave here?", cid)
            end
        end

    elseif (msgcontains(msg, 'cancel') or msgcontains(msg, 'cancelar')) then
        local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

        if (pokemonOnDaycare) then
            talkState[talkUser] = TALK_STATES.QUESTION_WITHDRAW_POKEMON_WITHOUT_TRAINING

            selfSay("Do you really want to cancel your Pokemon training? He will not gain any experience points and generate eggs, but you still have to pay the amount.", cid)

        else
            selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)
        end

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (talkState[talkUser] == TALK_STATES.QUESTION_LEAVE_POKEMON and lastName[talkUser] and lastTrainTime[talkUser]) then
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            else
                local daycareBall

                for i, ball in ipairs(getPlayerAllBallsWithPokemon(cid)) do
                    if (getBallPokemonName(ball.uid) == lastName[talkUser]) then
                        daycareBall = ball
                        break
                    end
                end

                if (not daycareBall) then
                    talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON_NAME

                    selfSay("You do not have this Pokemon! Please tell the name of a Pokemon that is with you.", cid)

                elseif (getPlayerMoney(cid) < 100) then
                    talkState[talkUser] = TALK_STATES.NONE

                    selfSay("You do not have enough money for this.", cid)

                elseif (getBallPokemonSex(daycareBall.uid) == POKEMON_SEX_MALE) then
                    talkState[talkUser] = TALK_STATES.NONE

                    selfSay("Sorry, I care only female and sexless Pokemon.", cid)

                else
                    talkState[talkUser] = TALK_STATES.NONE

                    doPlayerRemoveMoney(cid, 100)
                    doPlayerLeavePokemonOnDaycare(cid, daycareBall, lastTrainTime[talkUser])
                    selfSay("Thank you for using our services, your Pokemon will be fine here.", cid)
                end
            end

        elseif (talkState[talkUser] == TALK_STATES.QUESTION_WITHDRAW_POKEMON) then
            local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

            local remaingTrainTime = (pokemonOnDaycare:getDataInt('max_training_minutes')) - (math.floor((os.time() - pokemonOnDaycare:getDataInt('date')) / 60))
            if (remaingTrainTime > 0) then
                selfSay(string.format(__L(cid, "You can't withdraw your Pokemon right now. There's remaing %s minutes of training. If you really want, you can {cancel} the trainment."), remaingTrainTime), cid)
                talkState[talkUser] = TALK_STATES.NONE
                return true
            end

            local priceToWithdraw = getPricePerMinute(pokemonOnDaycare:getDataInt('pokemon_level')) * getPlayerPokemonOnDaycareTrainedMinutes(cid, pokemonOnDaycare) -- price per minutes * minutes
            if (getPlayerMoney(cid) < priceToWithdraw) then
                selfSay(string.format(__L(cid, "You do not have enough money for this. You need %s dollars."), priceToWithdraw), cid)

            else
                if (getPokemonOnDaycareEggStatus(cid, pokemonOnDaycare) == EGG_STATUS_HAS_CHANCE and
                        getRandom(1, EGG_RANDOM_MAX) <= getPlayerEggChance(cid, pokemonOnDaycare)) then
                    doPlayerAddPokemonEgg(cid, pokemonOnDaycare, getPlayerMalePokemonOnDaycare(cid))
                    doPlayerResetEggTries(cid, getPokemonNumberByName(pokemonOnDaycare:getDataString('pokemon_name')))
                    selfSay("An egg was generated! Congratulations!", cid)

                else
                    selfSay("No egg was generated.", cid)

                    if (getPokemonOnDaycareEggStatus(cid, pokemonOnDaycare) == EGG_STATUS_HAS_CHANCE) then
                        doPlayerIncreaseEggTries(cid, getPokemonNumberByName(pokemonOnDaycare:getDataString('pokemon_name')))
                    end
                end

                doPlayerWithdrawPokemonFromDaycare(cid, pokemonOnDaycare)
                doPlayerRemoveMoney(cid, priceToWithdraw)
                selfSay("Done. Thank you for using our services!", cid)
            end

            talkState[talkUser] = TALK_STATES.NONE

        elseif (talkState[talkUser] == TALK_STATES.QUESTION_WITHDRAW_POKEMON_WITHOUT_TRAINING) then
            local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)
            local priceToWithdraw = getPricePerMinute(pokemonOnDaycare:getDataInt('pokemon_level')) * getPlayerPokemonOnDaycareTrainedMinutes(cid, pokemonOnDaycare) -- price per minutes * minutes

            if (getPlayerMoney(cid) < priceToWithdraw) then
                selfSay(string.format(__L(cid, "You do not have enough money for this. You need %s dollars."), priceToWithdraw), cid)

            else
                doPlayerWithdrawPokemonFromDaycare(cid, pokemonOnDaycare, true)
                doPlayerRemoveMoney(cid, priceToWithdraw)
                selfSay("Done. Thank you for using our services!", cid)
            end

            talkState[talkUser] = TALK_STATES.NONE
        end

    else
        if (talkState[talkUser] == TALK_STATES.QUESTION_LEAVE_POKEMON_NAME) then
            if (not isPokemonName(msg)) then
                selfSay("Please, say the name of a Pokemon! What the name of your Pokemon that you want to leave here?", cid)

            else
                local trueName, i, word

                for i, word in ipairs(string.explode(msg, " ")) do
                    if (i == 1) then
                        trueName = word:gsub("^%l", string.upper)

                    else
                        trueName = trueName .. " " .. word:gsub("^%l", string.upper)
                    end
                end

                lastName[talkUser] = trueName
                talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON_TIME

                selfSay(string.format(__L(cid, "And how much train time do you want? The options are: %s"), getTrainOptionsMessage(cid)), cid)
            end

        elseif (talkState[talkUser] == TALK_STATES.QUESTION_LEAVE_POKEMON_TIME) then
            msg = tonumber(msg)
            if (not isInArray(TRAIN_TIME_OPTIONS, msg)) then
                selfSay(string.format(__L(cid, "Your options are: %s"), getTrainOptionsMessage(cid)), cid)

            else
                talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON
                lastTrainTime[talkUser] = msg

                selfSay(string.format(__L(cid, "Do you want to leave your %s here for %s minutes? This will cost 100 dollars to enter and an additional 1, 2 or 4 dollars per minute that he stay here (depends on the level of your Pokemon)."), lastName[talkUser], msg), cid)
            end

        else
            talkState[talkUser] = TALK_STATES.NONE

            selfSay("Ok...", cid)
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

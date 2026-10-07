setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:addModule(FocusModule:new())

--[[ ]]
local VALUE_MIN = 50
local VALUE_MAX = 20000000
local TAX = 0.01
local OFFERTS_PER_PAGE = 15
local MAXIMUM_OFFERTS_PER_POKEMON = 100

local function doPlayerLeavePokemonOnMarket(cid, ball, value)
    local query = string.concat(
        "INSERT INTO pokemon_market (player_id, date, pokemon_name, pokemon_level, pokemon_extrapoints, pokemon_sex, pokemon_specialability, ball_id, attributes, value, pokemon_eggmove) VALUES (",
        getPlayerGUID(cid), ",",
        os.time(), ",",
        "'", getBallPokemonName(ball.uid), "',",
        "'", getBallPokemonLevel(ball.uid), "',",
        "'", getBallPokemonExtraPoints(ball.uid), "',",
        "'", getBallPokemonSex(ball.uid), "',",
        "'", getBallPokemonSpecialAbility(ball.uid), "',",
        ball.itemid, ",",
        getItemAttributesBlob(ball.uid), ",",
        value, ",",
        "'", getBallEggMove(ball.uid), "');"
    )

    if (db.executeQuery(query)) then
        doRemoveItem(ball.uid)
        doPlayerSave(cid) -- let's save to prevent clone balls
        return true
    else
        log(LOG_TYPES.ERROR, "pokemonMarket:doPlayerLeavePokemonOnMarket - Can't query.", query)
    end

    return false
end

local function getPokemonFromMarket(id)
    local dbResult = db.getResult("SELECT * FROM `pokemon_market` WHERE `id` = '" .. id .. " LIMIT 1';")
    if dbResult:getID() == -1 then
        return false
    end
    return dbResult
end

local function doPlayerWithdrawPokemonFromMarket(cid, offer, datalogSell)
    local data = getPokemonFromMarket(offer.id)
    if (not data) then
        return false
    end

    local ball = doCreatePokemonBall(cid, data:getDataInt('ball_id'), nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil, true, {column = 'attributes', result = data:getID()})

    if (not ball) then
        log(LOG_TYPES.ERROR, "pokemonMarket:doPlayerWithdrawPokemonFromMarket - Can't create ball.",
            getCreatureName(cid), data)
        return false
    end

    if (datalogSell) then
        doDatalogPokemonMarket(offer.id, getPlayerGUID(cid), os.time())
    end

    local query = string.concat("DELETE FROM pokemon_market WHERE id='", data:getDataInt('id'), "'")
    if (db.executeQuery(query)) then
        doPlayerSave(cid) -- let's save to prevent clone balls
        return true
    else
        log(LOG_TYPES.ERROR, "pokemonMarket:doPlayerWithdrawPokemonFromMarket - Can't query.", query)
        doRemoveItem(ball)
    end

    return false
end

local function getOfferts(pokemonName)
    local r = db.getResult("SELECT `id`, `player_id`, `pokemon_name`, `pokemon_level`, `pokemon_extrapoints`, `pokemon_sex`, `pokemon_specialability`, `value`, `pokemon_eggmove` FROM `pokemon_market` WHERE `pokemon_name` = '"
            .. pokemonName .. "';")
    if r:getID() == -1 then
        return false
    end

    local ret = {}
    repeat
        ret[#ret + 1] = {
            id = r:getDataInt('id'),
            seller = r:getDataInt('player_id'),
            name = r:getDataString('pokemon_name'),
            level = r:getDataInt('pokemon_level'),
            extraPoints = r:getDataInt('pokemon_extrapoints'),
            sex = r:getDataInt('pokemon_sex'),
            specialAbility = r:getDataInt('pokemon_specialability'),
            value = r:getDataInt('value'),
            eggMove = r:getDataString('pokemon_eggmove')
        }
        until not r:next()
    r:free()

    return ret
end

local function getPlayerOfferts(cid)
    local r = db.getResult("SELECT `id`, `pokemon_name`, `pokemon_level`, `pokemon_extrapoints`, `pokemon_sex`, `pokemon_specialability`, `value`, `pokemon_eggmove` FROM `pokemon_market` WHERE `player_id` = '"
            .. getPlayerGUID(cid) .. "';")
    if r:getID() == -1 then
        return false
    end

    local ret = {}
    repeat
        ret[#ret + 1] = {
            id = r:getDataInt('id'),
            name = r:getDataString('pokemon_name'),
            level = r:getDataInt('pokemon_level'),
            extraPoints = r:getDataInt('pokemon_extrapoints'),
            sex = r:getDataInt('pokemon_sex'),
            specialAbility = r:getDataInt('pokemon_specialability'),
            value = r:getDataInt('value'),
            eggMove = r:getDataString('pokemon_eggmove')
        }
        until not r:next()
    r:free()

    return ret
end

local function getShinyOfferts()
    local r = db.getResult("SELECT `id`, `player_id`, `pokemon_name`, `pokemon_level`, `pokemon_extrapoints`, `pokemon_sex`, `pokemon_specialability`, `value`, `pokemon_eggmove` FROM `pokemon_market` WHERE `pokemon_name` LIKE '%shiny%';")
    if r:getID() == -1 then
        return false
    end

    local ret = {}
    repeat
        ret[#ret + 1] = {
            id = r:getDataInt('id'),
            seller = r:getDataInt('player_id'),
            name = r:getDataString('pokemon_name'),
            level = r:getDataInt('pokemon_level'),
            extraPoints = r:getDataInt('pokemon_extrapoints'),
            sex = r:getDataInt('pokemon_sex'),
            specialAbility = r:getDataInt('pokemon_specialability'),
            value = r:getDataInt('value'),
            eggMove = r:getDataString('pokemon_eggmove')
        }
        until not r:next()
    r:free()

    return ret
end

local function doSendPlayerSellMoney(cid, offert)
    local profit = math.floor(offert.value * (1.00 - TAX))
    local sellerName = getPlayerNameByGUID(offert.seller)

    local letter = doCreateItem(2598, getCreaturePosition(cid))
    if (not letter) then
        return false
    end

    if (not doItemSetAttribute(letter, "text", string.concat("Pokemon Market: Sale completed.\nPokemon: ", offert.name,
        "\nProfit: $", profit, " (", offert.value, " - ", math.ceil(offert.value * TAX), ")",
        "\n\nThis amount has been credited to your bank account."))) then
        doRemoveItem(letter)
        return false
    end

    if (not doPlayerAddDepotItemByName(sellerName, letter)) then
        doRemoveItem(letter)
        return false
    end

    return doPlayerAddBalanceByName(sellerName, profit)
end

local function getTotalOfferts(pokemonName)
    local r = db.getResult("SELECT COUNT(*) AS total FROM `pokemon_market` WHERE `pokemon_name` = '"
            .. pokemonName .. "';")
    if r:getID() == -1 then
        return 0
    end

    local v = r:getDataInt('total')
    r:free()

    return v
end

local function doPlayerShowOfferts(cid, offerts, includeName)
    local count = 0
    local message
    if (includeName) then
        message = {"No | Name | Level | Extra Points | Sex | Special Ability | Egg Move | Value\n" }
    else
        message = {"No | Level | Extra Points | Sex | Special Ability | Egg Move | Value\n" }
    end

    for i, offert in ipairs(offerts) do
        message[#message + 1] = i
        message[#message + 1] = " - "
        if (includeName) then
            message[#message + 1] = offert.name
            message[#message + 1] = " - "
        end
        message[#message + 1] = offert.level
        message[#message + 1] = " - +"
        message[#message + 1] = offert.extraPoints
        message[#message + 1] = " - "
        message[#message + 1] = getSexDescription(offert.sex)
        message[#message + 1] = " - "
        message[#message + 1] = getPokemonSpecialAbilityName(offert.specialAbility)
        message[#message + 1] = " - "
        message[#message + 1] = offert.eggMove
        message[#message + 1] = " - $"
        message[#message + 1] = offert.value
        message[#message + 1] = "\n"

        count = count + 1
        if (count >= OFFERTS_PER_PAGE) then
            doPlayerPopupFYI(cid, table.concat(message))

            if (i < #offerts) then -- If we have more offerts to show
                message = {"No | Level | Extra Points | Sex | Special Ability | Egg Move | Value\n" }
                count = 0
            else
                message = nil
            end
        end
    end

    if (message) then
        doPlayerPopupFYI(cid, table.concat(message))
    end
end

--

local CURRENT_NAME = {}
local CURRENT_VALUE = {}
local CURRENT_OFFERTS = {}
local CURRENT_BUY = {}

local TALKSTATE = {}
TALKSTATE.CANCEL1 = 1
TALKSTATE.SELL1 = 2
TALKSTATE.BUY1 = 3
TALKSTATE.SELL2 = 4
TALKSTATE.SELL3 = 5
TALKSTATE.BUY2 = 6
TALKSTATE.BUY3 = 7
TALKSTATE.CANCEL2 = 8
TALKSTATE.CANCEL3 = 9

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    local message = msg

    if (msgcontains(msg, 'sell') or msgcontains(msg, 'vender')) then
        selfSay("Please tell me the Pokemon name that you want to sell.", cid)
        npcHandler.talkState[talkUser] = TALKSTATE.SELL1

    elseif (msgcontains(msg, 'buy') or msgcontains(msg, 'comprar')) then
        selfSay("Please tell me the Pokemon name that you want to buy. If you want to list all shinies, enter {shiny}!", cid)
        npcHandler.talkState[talkUser] = TALKSTATE.BUY1

    elseif (msgcontains(msg, 'list') or msgcontains(msg, 'lista')) then
        local list = getPlayerOfferts(cid)
        if (not list) then
            npcHandler:say("You don't have any offerts!", cid)
            return true
        end

        doPlayerShowOfferts(cid, list, true)
        npcHandler:say("These are your current offerts. You can {cancel} then anytime.", cid)

    elseif (msgcontains(msg, 'cancel') or msgcontains(msg, 'cancelar')) then
        local list = getPlayerOfferts(cid)
        if (not list) then
            npcHandler:say("You don't have any offerts!", cid)
            return true
        end

        doPlayerShowOfferts(cid, list, true)
        npcHandler:say("What offert do you want to cancel?", cid)
        CURRENT_OFFERTS[cid] = list
        npcHandler.talkState[talkUser] = TALKSTATE.CANCEL1

    elseif (npcHandler.talkState[talkUser] == TALKSTATE.SELL1) then
        message = string.capitalise(message)

        if (not isPokemonName(message)) then
            npcHandler:say("Please type a Pokemon name!", cid)
            npcHandler.talkState[talkUser] = nil
            return true
        end

        CURRENT_NAME[cid] = message
        npcHandler:say(string.format(__L(cid, "How much you want for your %s?"), message), cid)
        npcHandler.talkState[talkUser] = TALKSTATE.SELL2

    elseif (npcHandler.talkState[talkUser] == TALKSTATE.SELL2) then
        local value = string.extractNumber(message)

        if (value < VALUE_MIN or value > VALUE_MAX) then
            npcHandler:say(string.format(__L(cid, "You must enter a price between %s and %s dollars."), VALUE_MIN, VALUE_MAX), cid)
            npcHandler.talkState[talkUser] = nil
            return true
        end

        CURRENT_VALUE[cid] = value
        npcHandler:say(string.format(__L(cid, "You really want to sell your %s for %s dollars?"), CURRENT_NAME[cid], value), cid)
        npcHandler.talkState[talkUser] = TALKSTATE.SELL3

    elseif (npcHandler.talkState[talkUser] == TALKSTATE.BUY1) then
        message = string.capitalise(message)

        local offerts, showNames
        if (message == "Shiny") then
            if (not isPremium(cid)) then
                npcHandler:say("Sorry, only premium account players can use this feature.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            offerts = getShinyOfferts()
            showNames = true

        else
            if (not isPokemonName(message)) then
                npcHandler:say("You must enter a Pokemon name.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            offerts = getOfferts(message)
        end

        if (not offerts) then
            npcHandler:say("There are no offerts for this Pokemon!", cid)
            npcHandler.talkState[talkUser] = nil
            return true
        end

        doPlayerShowOfferts(cid, offerts, showNames)
        npcHandler:say("Offerts! Please type the offert number that you want to buy.", cid)
        CURRENT_OFFERTS[cid] = offerts
        npcHandler.talkState[talkUser] = TALKSTATE.BUY2

    elseif (npcHandler.talkState[talkUser] == TALKSTATE.BUY2) then
        local id = string.extractNumber(message)
        if (not CURRENT_OFFERTS[cid] or not CURRENT_OFFERTS[cid][id]) then
            npcHandler:say("You did not like theses offerts? Maybe next time.", cid)
            npcHandler.talkState[talkUser] = nil
            return true
        end

        CURRENT_BUY[cid] = CURRENT_OFFERTS[cid][id]
        npcHandler:say(string.format(__L(cid, "You really want to buy this Pokemon (%s %s+%s) for %s dollars?"), CURRENT_BUY[cid].name, CURRENT_BUY[cid].level, CURRENT_BUY[cid].extraPoints, CURRENT_BUY[cid].value), cid)
        npcHandler.talkState[talkUser] = TALKSTATE.BUY3

    elseif (npcHandler.talkState[talkUser] == TALKSTATE.CANCEL1) then
        local id = string.extractNumber(message)
        if (not CURRENT_OFFERTS[cid] or not CURRENT_OFFERTS[cid][id]) then
            npcHandler:say("Something got wrong.", cid)
            npcHandler.talkState[talkUser] = nil
            return true
        end

        CURRENT_BUY[cid] = CURRENT_OFFERTS[cid][id]
        npcHandler:say("You really want to cancel this offert?", cid)
        npcHandler.talkState[talkUser] = TALKSTATE.CANCEL2

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (npcHandler.talkState[talkUser] == TALKSTATE.SELL3) then
            if (getTotalOfferts(CURRENT_NAME[cid]) >= MAXIMUM_OFFERTS_PER_POKEMON) then
                npcHandler:say("We reached the limit of offerts for this Pokemon! Please try again later.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            local ball
            for i, tmpBall in ipairs(getPlayerAllBallsWithPokemon(cid)) do
                if (getBallPokemonName(tmpBall.uid) == CURRENT_NAME[cid]) then
                    ball = tmpBall
                    break
                end
            end

            if (not ball) then
                npcHandler:say("You do not have this Pokemon! Please tell the name of a Pokemon that is with you.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            if (getItemUniqueOwner(ball.uid) ~= ITEM_UNIQUE_OWNER_NONE) then
                npcHandler:say("You can not sell an unique Pokemon!", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            if (getBallSeal(ball.uid) ~= BALL_SEAL_IDS.NONE) then
                npcHandler:say("You can not sell Pokemon with seal!", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            if (getBallTm(ball.uid, 1) ~= TM_IDS.NONE or getBallTm(ball.uid, 2) ~= TM_IDS.NONE) then
                npcHandler:say("You can not sell Pokemon with TMs!", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                npcHandler:say("You can not do it while you have a Pokemon out of the ball.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            if (doPlayerLeavePokemonOnMarket(cid, ball, CURRENT_VALUE[cid])) then
                npcHandler:say("Your Pokemon is now available in our offerts. Thank you for using our services!", cid)
                return true

            else
                npcHandler:say("Not possible, please try again later.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            npcHandler.talkState[talkUser] = nil

        elseif (npcHandler.talkState[talkUser] == TALKSTATE.BUY3) then
            if (CURRENT_BUY[cid].seller == getPlayerGUID(cid)) then
                npcHandler:say("You cannot buy your own offerts! You can {cancel} it if you want.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            if (getPlayerMoney(cid) < CURRENT_BUY[cid].value) then
                npcHandler:say("You do not have enough money.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            if (doPlayerWithdrawPokemonFromMarket(cid, CURRENT_BUY[cid], true)) then
                doPlayerRemoveMoney(cid, CURRENT_BUY[cid].value)
                doSendPlayerSellMoney(cid, CURRENT_BUY[cid])
                npcHandler:say("Done! Thank you for using our services.", cid)
                return true

            else
                npcHandler:say("This offert is not available.", cid)
                npcHandler.talkState[talkUser] = nil
                return true
            end

            npcHandler.talkState[talkUser] = nil

        elseif (npcHandler.talkState[talkUser] == TALKSTATE.CANCEL2) then
            if (doPlayerWithdrawPokemonFromMarket(cid, CURRENT_BUY[cid])) then
                npcHandler:say("Done.", cid)
                return true
            end

            npcHandler.talkState[talkUser] = nil

        else
            npcHandler:say("Here you can {buy} or {sell} Pokemon. You can also {list} or {cancel} your offerts.", cid)
            npcHandler.talkState[talkUser] = nil
        end

    else
        npcHandler:say("Here you can {buy} or {sell} Pokemon. You can also {list} or {cancel} your offerts.", cid)
        npcHandler.talkState[talkUser] = nil
    end

    return true
end)
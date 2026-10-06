local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Pre Methods
local function getPlayerBoughtOnPokeTrader(cid, itemId)
    local dbResult = db.getResult(string.concat("SELECT 1 FROM `datalog_poketrader_boughts` WHERE player_id=",
        getPlayerGUID(cid), " AND item_id=", itemId, ";"))
    local ret = {}
    if (dbResult:getID() == EMPTY_RESULT) then
        ret = false
    end
    repeat
        ret = true
    until not dbResult:next()
    if (ret) then
        dbResult:free()
    end
    return ret
end

-- Consts
local INTERVAL_BETWEEN_BIDS = 7 * 24 * 60 * 60
local MIN_NEXT_BID = 1.01

local OFFERT_ITEMS = {
    { -- Rare
        chance = 30,
        itemLimit = 1,
        items = {
            {itemId = 18083, count = 1, minBid = 22500}, -- Fire Stone
            {itemId = 18086, count = 1, minBid = 22000}, -- Leaf Stone
            {itemId = 18084, count = 1, minBid = 25500}, -- Moon Stone
            {itemId = 18085, count = 1, minBid = 24500}, -- Sun Stone
            {itemId = 18087, count = 1, minBid = 22000}, -- Thunderstone
            {itemId = 18088, count = 1, minBid = 22500}, -- Water Stone
            {itemId = 18089, count = 1, minBid = 30000}, -- Up-Grade
            {itemId = 18090, count = 1, minBid = 30000}, -- Dragon Scale
            {itemId = 18091, count = 1, minBid = 30500}, -- King's Rock
            {itemId = 18092, count = 1, minBid = 27500}, -- Metal Coat
            {itemId = 18093, count = 1, minBid = 25500}, -- Soothe Bell
            {itemId = 18094, count = 1, minBid = 30000}, -- Punch Machine
            {itemId = 18095, count = 1, minBid = 30000}, -- Kick Machine
            {itemId = 18096, count = 1, minBid = 30000}, -- Spin Machine
        }
    },
    { -- Semi-Rare
        chance = 80,
        itemLimit = 2,
        items = {
            {itemId = 17346, count = 1, minBid = 10000}, -- TM Double-Edge
            {itemId = 17349, count = 1, minBid = 10000}, -- TM Ice Beam
            {itemId = 17352, count = 1, minBid = 5000}, -- TM Submission
            {itemId = 17357, count = 1, minBid = 10000}, -- TM Solar Beam
            {itemId = 17358, count = 1, minBid = 1000}, -- TM Dragon Rage
            {itemId = 17359, count = 1, minBid = 5000}, -- TM Thunderbolt
            {itemId = 17362, count = 1, minBid = 10000}, -- TM Fissure
            {itemId = 17363, count = 1, minBid = 5000}, -- TM Psychic
            {itemId = 17368, count = 1, minBid = 10000}, -- TM Metronome
            {itemId = 17370, count = 1, minBid = 10000}, -- TM Egg Bomb
            {itemId = 17371, count = 1, minBid = 10000}, -- TM Fire Blast
            {itemId = 17375, count = 1, minBid = 5000}, -- TM Dream Eater
            {itemId = 17376, count = 1, minBid = 10000}, -- TM Sky Attack
            {itemId = 17378, count = 1, minBid = 5000}, -- TM Thunder Wave
            {itemId = 17379, count = 1, minBid = 10000}, -- TM Psywave
            {itemId = 17381, count = 1, minBid = 5000}, -- TM Rock Slide
            {itemId = 17382, count = 1, minBid = 5000}, -- TM Tri Attack
            {itemId = 18912, count = 1, minBid = 10000}, -- TM Dynamic Punch
            {itemId = 18913, count = 1, minBid = 5000}, -- TM Headbutt
            {itemId = 18914, count = 1, minBid = 5000}, -- TM Curse
            {itemId = 18915, count = 1, minBid = 10000}, -- TM Zap Cannon
            {itemId = 18916, count = 1, minBid = 1000}, -- TM Snore
            {itemId = 18917, count = 1, minBid = 5000}, -- TM Icy Wind
            {itemId = 18918, count = 1, minBid = 5000}, -- TM Protect
            {itemId = 18919, count = 1, minBid = 10000}, -- TM Rain Dance
            {itemId = 18920, count = 1, minBid = 10000}, -- TM Giga Drain
            {itemId = 18921, count = 1, minBid = 5000}, -- TM Iron Tail
            {itemId = 18922, count = 1, minBid = 5000}, -- TM Shadow Ball
            {itemId = 18923, count = 1, minBid = 1000}, -- TM Mud-Slap
            {itemId = 18924, count = 1, minBid = 5000}, -- TM Ice Punch
            {itemId = 18925, count = 1, minBid = 5000}, -- TM Sludge Bomb
            {itemId = 18926, count = 1, minBid = 1000}, -- TM Defense Curl
            {itemId = 18927, count = 1, minBid = 5000}, -- TM Thunder Punch
            {itemId = 18928, count = 1, minBid = 5000}, -- TM Steel Wing
            {itemId = 18929, count = 1, minBid = 5000}, -- TM Fire Punch
            {itemId = 18930, count = 1, minBid = 5000}, -- TM Fury Cutter

            {itemId = 12229, count = 1, minBid = 7000}, -- flame plate
            {itemId = 12230, count = 1, minBid = 6000}, -- splash plate
            {itemId = 12231, count = 1, minBid = 3000}, -- meadow plate
            {itemId = 12232, count = 1, minBid = 5000}, -- love plate
            {itemId = 12233, count = 1, minBid = 10000}, -- mind plate
            {itemId = 12234, count = 1, minBid = 4000}, -- stone plate
            {itemId = 12235, count = 1, minBid = 3000}, -- toxic plate
            {itemId = 12236, count = 1, minBid = 5000}, -- icicle plate
            {itemId = 12237, count = 1, minBid = 5000}, -- zap plate
            {itemId = 12240, count = 1, minBid = 15000}, -- draco plate
            {itemId = 12241, count = 1, minBid = 2000}, -- insect plate
            {itemId = 12242, count = 1, minBid = 10000}, -- dread plate
            {itemId = 12243, count = 1, minBid = 10000}, -- fist plate
            {itemId = 13807, count = 1, minBid = 5000}, -- earth plate
            {itemId = 17814, count = 1, minBid = 10000}, -- iron plate
            {itemId = 18081, count = 1, minBid = 5000}, -- sky plate
            {itemId = 18082, count = 1, minBid = 10000}, -- spooky plate
            {itemId = 23946, count = 1, minBid = 8000}, -- pixie plate
        }
    },
    { -- Normal
        chance = 100,
        itemLimit = 3,
        items = {
            {itemId = 13305, count = 100, minBid = 5000}, -- lava cookie
        }
    },
    { -- Quest
        chance = 100,
        itemLimit = 1,
        items = {
            {itemId = 23546, count = 1, minBid = 1000, unique = true,
                canBid = function(cid) return not getPlayerBoughtOnPokeTrader(cid, 23546) end}, -- blue flute
        }
    }
}

-- Vars
local OFFERTS = {}
local ACCEPTING_BIDS = false -- This will be set off when the NPC is working at the current auctions, prevent data corruption

local lastOffert = {}
local lastBid = {}
local lastCancelOffert = {}

local TALKSTATE_WAITING_OFFERT_CONFIRMATION = 1
local TALKSTATE_WAITING_BID_CONFIRMATION = 2
local TALKSTATE_WAITING_CANCEL = 3
local TALKSTATE_WAITING_FINAL_CANCEL = 4


-- Internal Methods
local doLoadOfferts

local function doStartAuction() -- Generate new items to offer
    local offerts = {}

    for _, offertGroup in pairs(OFFERT_ITEMS) do
        if (getRandom(1, 100) <= offertGroup.chance) then
            local tmpItems = table.deepcopy(offertGroup.items) -- copy cuz we will delete the items, let's keep the original intact
            for i = 1, offertGroup.itemLimit do
                if (#tmpItems > 0) then
                    offerts[#offerts + 1] = table.randomRemove(tmpItems)
                end
            end
        end
    end

    if (#offerts <= 0) then
        return false
    end

    local query = {"INSERT INTO poketrader_offerts (item_id, count, min_bid, created, deadline, world_id) VALUES "}

    for _, offert in pairs(offerts) do
        query[#query + 1] = "("
        query[#query + 1] = offert.itemId
        query[#query + 1] = ","
        query[#query + 1] = offert.count
        query[#query + 1] = ","
        query[#query + 1] = offert.minBid
        query[#query + 1] = ","
        query[#query + 1] = os.time()
        query[#query + 1] = ","
        query[#query + 1] = os.time() + INTERVAL_BETWEEN_BIDS
        query[#query + 1] = ","
        query[#query + 1] = getConfigValue('worldId')
        query[#query + 1] = ")"
        query[#query + 1] = ","
    end
    query[#query] = ";"
    query = table.concat(query)

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "PokeTrader::doStartAuction - Can't query.", query)
        return false
    end

    return true
end

local function doDeleteOffertRecord(offertId) -- Delete an offert from the Database
    return db.executeQuery(string.concat("DELETE FROM `poketrader_offerts` WHERE id='", offertId,
        "' and world_id='", getConfigValue("worldId"), "';"))
end

local function doDeleteBidRecord(offertId, playerId) -- Delete a bid from the Database
    return db.executeQuery(string.concat("DELETE FROM `poketrader_bids` WHERE player_id='", playerId,
        "' and offert_id='", offertId, "';"))
end

local function doDeleteOffertBids(offertId) -- Delete offert bids
    return db.executeQuery(string.concat("DELETE FROM `poketrader_bids` WHERE offert_id=", offertId, ";"))
end

local function doDeleteOfferts() -- Delete all offerts
    return db.executeQuery(string.concat("DELETE FROM `poketrader_offerts` WHERE world_id='",
        getConfigValue("worldId"), "';"))
end

local function getOfferConfig(itemId, count, minBid)
    for _, offertGroup in pairs(OFFERT_ITEMS) do
        for __, item in pairs(offertGroup.items) do
            if (item.itemId == itemId and item.count == count and item.minBid == minBid) then
                return item
            end
        end
    end
    return nil
end

local function doEndAuction() -- Stop receiving bids and finish the opened auctions
    ACCEPTING_BIDS = false

    for _, offert in pairs(OFFERTS) do
        local dbResult = db.getResult(string.concat("SELECT `bid`, `player_id` FROM `poketrader_bids` WHERE `offert_id` = ",
            offert.id, " ORDER BY `bid` DESC LIMIT 1;"))
        if (dbResult:getID() ~= EMPTY_RESULT) then
            local playerGuid = dbResult:getDataInt('player_id')
            local highestBid = dbResult:getDataInt('bid')
            dbResult:free()

            doDatalogPokeTraderBought(playerGuid, offert.itemId, offert.count, highestBid, os.time())
            doDeleteBidRecord(offert.id, playerGuid)
            -- send player item and letter
            local item = doCreateItem(offert.itemId, offert.count, getNpcPos())
            if (item) then
                if (getOfferConfig(offert.itemId, offert.count, offert.minBid) and
                        getOfferConfig(offert.itemId, offert.count, offert.minBid).unique) then
                    setItemUniqueOwner(item, 0, playerGuid)
                end

                if (not doPlayerAddDepotItemByName(getPlayerNameByGUID(playerGuid), item)) then
                    doRemoveItem(item)
                    --
                end
            else
                --
            end

            -- give all others money back
            dbResult = db.getResult(string.concat("SELECT `player_id`, `offert_id`, `bid` FROM `poketrader_bids` WHERE `offert_id` = ", offert.id, ";"))
            if (dbResult:getID() ~= EMPTY_RESULT) then
                repeat
                    doPlayerAddBalanceByName(getPlayerNameByGUID(dbResult:getDataInt('player_id')),
                        dbResult:getDataInt('bid'))
                until not dbResult:next()
                dbResult:free()
                -- log(LOG_TYPES.ERROR, "PokeTrader::doLoadOfferts - Can't load/generate offerts.")
            end
            doDeleteOffertBids(offert.id)

        --else
            -- we have no bid for this offert, remove it
            --log(LOG_TYPES.ERROR, "PokeTrader::doEndAuction - Can't get bid for offert.", offert, os.time())
        end
    end

    doDeleteOfferts()
    doLoadOfferts()
    return true
end

doLoadOfferts = function(selfCalling) -- Load the offerts from the Database or create new ones if needed
    OFFERTS = {}
    local dbResult = db.getResult(string.concat("SELECT `id`, `item_id`, `count`, `deadline`, `min_bid` FROM `poketrader_offerts` WHERE world_id=",
        getConfigValue('worldId'), ";"))
    if (dbResult:getID() == EMPTY_RESULT) then
        if (selfCalling) then -- We already tried to create new offerts, something wrong is goin on
            log(LOG_TYPES.ERROR, "PokeTrader::doLoadOfferts - Can't load/generate offerts.")
            return false
        end

        if (doStartAuction()) then
            return doLoadOfferts(true)
        end
    end
    repeat
        OFFERTS[#OFFERTS + 1] = {
            id = dbResult:getDataInt('id'),
            itemId = dbResult:getDataInt('item_id'),
            count = dbResult:getDataInt('count'),
            deadline = dbResult:getDataInt('deadline'),
            minBid = dbResult:getDataInt('min_bid')
        }
    until not dbResult:next()
    dbResult:free()

    if (#OFFERTS <= 0) then
        return false
    end

    addEvent(doEndAuction, (OFFERTS[1].deadline - os.time()) * 1000)

    ACCEPTING_BIDS = true
    return true
end
--[[
local function doCreateBid()
    if (not ACCEPTING_BIDS) then
        return false
    end

    return true
end

local function doDeleteBid()
    if (not ACCEPTING_BIDS) then
        return false
    end

    return true
end
]]
local function getHighestBid(offertId)
    local dbResult = db.getResult(string.concat("SELECT `bid` FROM `poketrader_bids` WHERE `offert_id` = ",
        offertId, " ORDER BY `bid` DESC LIMIT 1;"))
    local ret = 0
    if (dbResult:getID() ~= EMPTY_RESULT) then
        ret = dbResult:getDataInt('bid')
        dbResult:free()
    end
    return ret
end

local function getPlayerOffertBid(cid, offertId)
    local dbResult = db.getResult(string.concat("SELECT 1 FROM `poketrader_bids` WHERE offert_id=",
        offertId, " AND player_id=", getPlayerGUID(cid), ";"))
    local ret = false
    if (dbResult:getID() ~= EMPTY_RESULT) then
        ret = true
        dbResult:free()
    end
    return ret
end

local function getPlayerOffertBidValue(cid, offertId)
    local dbResult = db.getResult(string.concat("SELECT bid FROM `poketrader_bids` WHERE offert_id=",
        offertId, " AND player_id=", getPlayerGUID(cid), ";"))
    local ret = 0
    if (dbResult:getID() ~= EMPTY_RESULT) then
        ret = dbResult:getDataInt('bid')
        dbResult:free()
    end
    return ret
end

-- NPC Methods
local function getOfferts()
    return #OFFERTS > 0 and OFFERTS or false
end

local function doShowOfferts(cid, offerts)
    local message = {}
    for i, option in ipairs(offerts) do
        message[#message + 1] = getItemNameById(option.itemId)
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x][Min bid: "
        message[#message + 1] = option.minBid
        message[#message + 1] = " dollars]\n"
    end
    doPlayerPopupFYI(cid, table.concat(message))
end

local function getOffertByName(name)
    name = string.lower(name)
    name = name:gsub("[%-...]", "%%%0") -- Fix lua string find with hyphen problem
    for _, offert in pairs(OFFERTS) do
        if (string.find(string.lower(getItemNameById(offert.itemId)), name)) then
            return offert
        end
    end
    return nil
end

local function doAskOffertConfirmation(cid, offert)
    selfSay(string.format(__L(cid, "Nice, so you want to make a bid for the %s. How much is your bid?"), getItemNameById(offert.itemId)), cid)
    lastOffert[cid] = offert
    npcHandler.talkState[cid] = TALKSTATE_WAITING_OFFERT_CONFIRMATION
end

local function getWaitingOffertConfirmation(cid)
    return npcHandler.talkState[cid] == TALKSTATE_WAITING_OFFERT_CONFIRMATION
end

local function doBidConfirmation(cid, value)
    if (value <= 0) then
        selfSay("Please enter a value bigger then zero.", cid)
        return
    end

    selfSay(string.format(__L(cid, "You really want to make a bid for the %s by %s dollars?"), getItemNameById(lastOffert[cid].itemId), value), cid)
    lastBid[cid] = value
    npcHandler.talkState[cid] = TALKSTATE_WAITING_BID_CONFIRMATION
end

local function getPlayerBids(cid)
    local dbResult = db.getResult(string.concat("SELECT `offert_id`, `bid` FROM `poketrader_bids` WHERE player_id=",
        getPlayerGUID(cid), ";"))
    local ret = {}
    if (dbResult:getID() == EMPTY_RESULT) then
        ret = false
    else
        repeat
            ret[#ret + 1] = {offertId = dbResult:getDataInt('offert_id'), bid = dbResult:getDataInt('bid')}
        until not dbResult:next()
    end

    if (ret) then
        dbResult:free()
    end
    return ret
end

local function doShowPlayerBids(cid, bids)
    local message = {}
    for i, option in ipairs(bids) do
        local dbResult = db.getResult(string.concat("SELECT `item_id` FROM `poketrader_offerts` WHERE id=",
            option.offertId, ";"))
        if (dbResult:getID() ~= EMPTY_RESULT) then
            message[#message + 1] = getItemNameById(dbResult:getDataInt('item_id'))
            message[#message + 1] = " for "
            message[#message + 1] = option.bid
            message[#message + 1] = " dollars (highest: "
            message[#message + 1] = (getHighestBid(option.offertId) == option.bid and "Yours" or
                    getHighestBid(option.offertId))
            message[#message + 1] = ")\n"

            dbResult:free()
        else
            -- todo log
        end

    end
    doPlayerPopupFYI(cid, table.concat(message))
end

local function getWaitingBidConfirmation(cid)
    return npcHandler.talkState[cid] == TALKSTATE_WAITING_BID_CONFIRMATION
end

local function doConfirmBidOffert(cid)
    if (not lastOffert[cid] or not lastBid[cid]) then
        return false
    end

    if (getPlayerMoney(cid) < lastBid[cid]) then
        selfSay("You do not have this amount.", cid)
        return false
    end

    if (lastBid[cid] < lastOffert[cid].minBid) then
        selfSay(string.format(__L(cid, "Your bid is less than the minimum of %s dollars."), lastOffert[cid].minBid), cid)
        return false
    end

    if (lastBid[cid] <= getHighestBid(lastOffert[cid].id)) then
        selfSay(string.format(__L(cid, "Your bid is less than the highest of %s dollars."), getHighestBid(lastOffert[cid].id)), cid)
        return false
    end

    if (lastBid[cid] < getHighestBid(lastOffert[cid].id) * MIN_NEXT_BID) then
        selfSay(string.format(__L(cid, "Your bid is less than the minimum acceptable of %s dollars."), getHighestBid(lastOffert[cid].id) * MIN_NEXT_BID), cid)
        return false
    end

    if (getPlayerOffertBid(cid, lastOffert[cid].id)) then
        selfSay("You already make a bid for this offert. If you want to bid it again, please {cancel} first.", cid)
        return false
    end

    if (lastOffert[cid].canBid and not lastOffert[cid].canBid(cid)) then
        selfSay("Sorry, you can not make a bid for this offert.", cid)
        return false
    end

    local query = {"INSERT INTO poketrader_bids (player_id, offert_id, created, bid) VALUES ("}
    query[#query + 1] = getPlayerGUID(cid)
    query[#query + 1] = ","
    query[#query + 1] = lastOffert[cid].id
    query[#query + 1] = ","
    query[#query + 1] = os.time()
    query[#query + 1] = ","
    query[#query + 1] = lastBid[cid]
    query[#query + 1] = ")"
    query[#query + 1] = ","
    query[#query] = ";"
    query = table.concat(query)

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "PokeTrader::doConfirmBidOffert - Can't query.", query)
        return false
    end

    doPlayerRemoveMoney(cid, lastBid[cid])
    selfSay("Its done! Your bid has been recorded.", cid)
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.BID_ON_POKETRADER, 1)
    lastBid[cid] = nil
    lastOffert[cid] = nil
    npcHandler.talkState[cid] = nil
end

local function doResetTalk(cid)
    npcHandler.talkState[cid] = nil
end

local function doAskCancelConfirmation(cid)
    selfSay("I see, what offert do you want to cancel a {bid}?", cid)
    npcHandler.talkState[cid] = TALKSTATE_WAITING_CANCEL
end

local function getWaitingCancel(cid)
    return npcHandler.talkState[cid] == TALKSTATE_WAITING_CANCEL
end

local function doAskCancelFinalConfirmation(cid, msg)
    local offert = getOffertByName(msg)
    if (not offert) then
        selfSay("Ya ya? I don't have this offert.", cid)
        doResetTalk(cid)
        return false
    end
    
    if (not getPlayerOffertBid(cid, offert.id)) then
        selfSay("You did not make any bid for this offert.", cid)
        doResetTalk(cid)
        return false
    end

    if (getHighestBid(offert.id) == getPlayerOffertBidValue(cid, offert.id)) then
        selfSay("You cannot remove your bid while it's the highest.", cid)
        doResetTalk(cid)
        return false
    end
    
    lastCancelOffert[cid] = offert
    npcHandler.talkState[cid] = TALKSTATE_WAITING_FINAL_CANCEL
    selfSay("You really want to cancel your bid for this offert?", cid)
    return true
end

local function getWaitingCancelFinalConfirmation(cid)
    return npcHandler.talkState[cid] == TALKSTATE_WAITING_FINAL_CANCEL
end

local function doCancelBidOffert(cid)
    if (not lastCancelOffert[cid]) then
        return false
    end

    local value = getPlayerOffertBidValue(cid, lastCancelOffert[cid].id)

    if (doDeleteBidRecord(lastCancelOffert[cid].id, getPlayerGUID(cid))) then
        doPlayerAddBalanceByName(getPlayerName(cid), value)
        selfSay("It's done, canceled!", cid)
    end

    lastCancelOffert[cid] = nil
    return true
end

local function doTellRemaingTime(cid)
    selfSay(string.format(__L(cid, "Remaining %s to end the current offerts."), table.concat(string.timediff((OFFERTS[1].deadline - os.time()), cid))), cid)
end

-- Callback
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
    end

    if (msgcontains(msg, 'offer') or msgcontains(msg, 'oferta')) then
        local offerts = getOfferts()
        if (not offerts) then
            selfSay("Err, I already sold all goods. Maybe you got luck next time.", cid)
            return true
        end

        selfSay("Mmm... Let me see, oh here is! These are my offerts.", cid)
        doShowOfferts(cid, offerts)

    elseif (msgcontains(msg, 'bid') or msgcontains(msg,'current') or msgcontains(msg, 'lance')) then
        local bids = getPlayerBids(cid)
        if (bids) then
            selfSay("Yes! Here are your current bids.", cid)
            doShowPlayerBids(cid, bids)

        else
            selfSay("Argh, you do not have any bid offert now! Please take a look at my {offerts}.", cid)
        end

    elseif (msgcontains(msg, 'cancel') or msgcontains(msg, 'cancelar')) then
        doAskCancelConfirmation(cid)

    elseif (msgcontains(msg, 'time') or msgcontains(msg, 'tempo')) then
        doTellRemaingTime(cid)

    elseif (getWaitingCancel(cid)) then
        doAskCancelFinalConfirmation(cid, msg)

    elseif (getWaitingCancelFinalConfirmation(cid)) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            doCancelBidOffert(cid)

        else
            doResetTalk(cid)
            selfSay("Ok, it's fine.", cid)
        end

    elseif (getWaitingOffertConfirmation(cid)) then
        if (string.extractNumber(msg)) then
            doBidConfirmation(cid, string.extractNumber(msg))

        else
            doResetTalk(cid)
            selfSay("Why not?! ... ... ... Ok, ok, I'm sorry about that. It's fine.", cid)
        end

    elseif (getWaitingBidConfirmation(cid)) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            doConfirmBidOffert(cid)

        else
            doResetTalk(cid)
            selfSay("Why not?! ... ... ... Ok, ok, I'm sorry about that. It's fine.", cid)
        end

    else
        msg = string.lower(msg)
        if (getOffertByName(msg)) then
            doAskOffertConfirmation(cid, getOffertByName(msg))

        else
            selfSay("Yaya? Sorry, I can't understand you. Do you want to see my {offerts}? I can show you your current {bids} and the remaing {time} to end my current offerts.", cid)
        end
    end

	return true
end)
npcHandler:addModule(FocusModule:new())
--
doLoadOfferts()
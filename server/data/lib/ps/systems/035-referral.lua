if (Referral) then
    return
end

Referral = {}

-- Constants
local GENERATE_UNIQUE = false
local SEND_TO_DEPOT = true
local SHOW_MESSAGE = true
local REFERRAL_FRIEND_LEVEL = 50
local REFERRAL_FRIEND_GAIN_POINTS = 5

local OPTIONS = {
    ["nightmare paint ticket"] = {name = "nightmare paint ticket", itemId = 18942, count = 1, points = 5},
    ["shadow paint ticket"] = {name = "shadow paint ticket", itemId = 18943, count = 1, points = 5},
    ["spark paint ticket"] = {name = "spark paint ticket", itemId = 18944, count = 1, points = 5},

    ["hunter outfit"] = {name = "hunter outfit", outfits = {1194, 1195}, count = 1, points = 25},

    ["rare seal box"] = {name = "rare seal box", itemId = 18766, count = 1, points = 5},
    ["pikachu backpack"] = {name = "pikachu backpack", itemId = 13215, count = 1, points = 15},
    ["doll box"] = {name = "doll box", itemId = 18945, count = 1, points = 10},
}

-- Vars

-- Local
local function getOptionsMessage()
    local message = {}
    for i, option in pairs(OPTIONS) do
        message[#message + 1] = option.name
        if (option.description) then
            message[#message + 1] = " ("
            message[#message + 1] = option.description
            message[#message + 1] = ")"
        end
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x]["
        message[#message + 1] = option.points
        message[#message + 1] = "x RP]\n"
    end
    message[#message + 1] = "\nCT = Referral Points"
    return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

local function doAccountAddReferralPoints(account, v)
    return db.executeQuery("UPDATE `"..getConfigValue('sqlDatabase').."`.`accounts` SET `referral_points` = `referral_points` + '".. v ..
            "' WHERE `accounts`.`id` ='".. account .."';")
end

local function getPlayerAccountReferralPoints(cid)
    local r = db.getResult("SELECT `referral_points` FROM `accounts` WHERE `id` = '"..
            getPlayerAccountId(cid) .."';")

    if (r:getID() == -1) then
        return 0
    end

    local ret = r:getDataInt("referral_points")
    r:free()
    return ret
end

local function isReferralFriend(referralAccount, friendAccount)
    local r = db.getResult("SELECT 1 FROM `referral_friends` WHERE `account_referral` = '"..
            referralAccount .."' AND `account_friend` = '".. friendAccount .."';")

    if (r:getID() == -1) then
        return false
    end

    r:free()
    return true
end

local function getPlayerReferralAccount(cid)
    local r = db.getResult("SELECT `referral` FROM `accounts` WHERE `id` = '".. getPlayerAccountId(cid) .."';")

    if (r:getID() == -1) then
        return nil
    end

    local ret = r:getDataInt("referral")
    r:free()
    return ret
end

local function doRecordReferralFriends(referralAccount, friendAccount)
    local query = string.concat("INSERT INTO `referral_friends` (`account_referral`, `account_friend`) VALUES ('",
        referralAccount , "', '", friendAccount, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doRecordReferralFriends - Can't query.", query, referralAccount, friendAccount)
        return false
    end

    return true
end

-- Global
Referral.getRewardByName = function(s)
    return OPTIONS[string.lower(s)]
end

Referral.onPlayerBuy = function(cid, option)
    if (getPlayerAccountReferralPoints(cid) < option.points or
            not doAccountAddReferralPoints(getPlayerAccountId(cid), -option.points)) then
        return false
    end

    local r
    if (option.outfits) then
        for _, cloth in pairs(option.outfits) do
            doPlayerAddOutfit(cid, cloth, 0)
        end

        doPlayerSendOutfitWindow(cid)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You got a new outfit.")
        r = true
    end

    if (option.itemId) then
        r = doPlayerSafeAddItem(cid, option.itemId, option.count, SHOW_MESSAGE, GENERATE_UNIQUE, SEND_TO_DEPOT)
    end

    if (r) then
        doDatalogReferralExchange(getPlayerGUID(cid), option.name, os.time())
    end

    return r
end

Referral.doPlayerShowOptions = function(cid)
    doPlayerPopupFYI(cid, optionsMessage)
end

Referral.onPlayerAcquirePremium = function(cid)
    if (getPlayerLevel(cid) < REFERRAL_FRIEND_LEVEL) then
        return
    end

    local referralAccount = getPlayerReferralAccount(cid)
    if (not referralAccount or referralAccount == 0) then
        return
    end

    local friendAccount = getPlayerAccountId(cid)
    if (isReferralFriend(referralAccount, friendAccount)) then
        return
    end

    doAccountAddReferralPoints(referralAccount, REFERRAL_FRIEND_GAIN_POINTS)
    doRecordReferralFriends(referralAccount, friendAccount)
end
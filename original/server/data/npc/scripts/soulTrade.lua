setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

npcHandler:addModule(FocusModule:new())

local SOUL_COIN_ID = 6500

-- Pokemon Addon Stuff Start
local OPTIONS = {
    { itemId = 29827, count = 1, coins = 15 },
    { itemId = 29826, count = 1, coins = 15 },
    { itemId = 29829, count = 1, coins = 15 },
    { itemId = 29830, count = 1, coins = 15 },
    { itemId = 29855, count = 1, coins = 15 },
}

-- Vars

-- Local
local function getOptionsMessage()
    local message = {}
    for i, option in pairs(OPTIONS) do
        option.name = string.lower(getItemNameById(option.itemId))
        OPTIONS[option.name] = option
        OPTIONS[i] = nil

        message[#message + 1] = option.name
        if (option.description) then
            message[#message + 1] = " ("
            message[#message + 1] = option.description
            message[#message + 1] = ")"
        end
        message[#message + 1] = " ["
        message[#message + 1] = option.count
        message[#message + 1] = "x]["
        message[#message + 1] = option.coins
        message[#message + 1] = "x SC]\n"
    end
    message[#message + 1] = "\nSC = Soul Coin"
    return table.concat(message)
end

local optionsMessage = getOptionsMessage()
getOptionsMessage = nil

PokemonAddon.getRewardByName = function(s)
    return OPTIONS[string.lower(s)]
end

PokemonAddon.onPlayerBuy = function(cid, option)
    if (not doPlayerRemoveItem(cid, SOUL_COIN_ID, option.coins)) then
        return false
    end

    return doPlayerSafeAddItem(cid, option.itemId, option.count, true)
end

PokemonAddon.doPlayerShowOptions = function(cid)
    doPlayerPopupFYI(cid, optionsMessage)
end
-- Pokemon Addon Stuff End

--[[local cities = {"viridian",	"pewter", "cerulean", "saffron", "celadon", "vermilion", "lavender", "fuchsia",
    "cinnabar", "hamlin", "kumquat", "pummelo", "shamouti", "butwal", "ascorbia", "navel", "seven grapefruit",
    "moro", "murcott", "pinkan", "valencia", "tangelo", "sunburst", "mikan", "mandarin north", "tarroco",
    "trovitopolis", "mandarin south"}]]

local NICK_LENGTH_MAX = 20
local NICK_LENGTH_MIN = 4
local forbbidenWords = { "shiny", "shini", "shyni", "shyny" }

--[[local CITY_REQUIREMENT = {}
CITY_REQUIREMENT["valencia"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end
CITY_REQUIREMENT["pinkan"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end
CITY_REQUIREMENT["pummelo"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end

CITY_REQUIREMENT["tarroco"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
CITY_REQUIREMENT["hamlin"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end
CITY_REQUIREMENT["kumquat"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

CITY_REQUIREMENT["mandarin north"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
CITY_REQUIREMENT["butwal"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end
CITY_REQUIREMENT["navel"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end

CITY_REQUIREMENT["ascorbia"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end
CITY_REQUIREMENT["seven grapefruit"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end
CITY_REQUIREMENT["moro"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

CITY_REQUIREMENT["shamouti"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
CITY_REQUIREMENT["mandarin south"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
CITY_REQUIREMENT["murcott"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end]]

local function isNickAcceptable(nick)
    local nickLength, i = string.len(nick)

    if (nickLength < NICK_LENGTH_MIN or nickLength > NICK_LENGTH_MAX) then
        return false
    end

    nick = string.lower(nick)
    local letter

    for letter in string.gmatch(nick, ".") do -- Letter by letter
        if (not string.find(letter, '[a-z]') and letter ~= " ") then
            return false
        end
    end

    for i, forbbidenWord in ipairs(forbbidenWords) do -- Word by word
        if (string.find(nick, forbbidenWord) or isPokemonName(nick)) then
            return false
        end
    end

    return true
end

local function getPlayerAccountSoulCoins(cid)
    local dbResult = db.getResult("SELECT `soulcoins` FROM `accounts` WHERE `id` = '" .. getPlayerAccountId(cid) .. "';")

    if dbResult:getID() == -1 then
        return false
    end

    return dbResult:getDataInt("soulcoins")
end

local function setPlayerAccountSoulCoins(cid, count)
    db.executeQuery("UPDATE `" .. getConfigValue('sqlDatabase') .. "`.`accounts` SET `soulcoins` = '" .. count .. "' WHERE `accounts`.`id` ='" .. getPlayerAccountId(cid) .. "';")
end

local function getCountFromMessage(msg)
    local ret = -1
    local b, e = string.find(msg, "%d+")
    if b ~= nil and e ~= nil then
        ret = tonumber(string.sub(msg, b, e))
    end
    return ret
end

local REQUIREMENTS = {}
-- Valencia

-- Pummelo
REQUIREMENTS["Easton"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end

-- Pinkan

-- Tarroco
REQUIREMENTS["Lenard"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Hamlin
REQUIREMENTS["Elliot"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Kumquat
REQUIREMENTS["Lou"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end

-- Butwal
REQUIREMENTS["Selby"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end

-- Navel

-- Mandarin North
REQUIREMENTS["Cree"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end

-- Ascorbia
REQUIREMENTS["Erik"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Seven Grapefruit
REQUIREMENTS["Cairo"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Moro
REQUIREMENTS["Roscoe"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end

-- Shamouti
REQUIREMENTS["Curtis"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

-- Murcott
REQUIREMENTS["Selwyn"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

-- Mandarin South
REQUIREMENTS["Gyles"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end
REQUIREMENTS["Tobias"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end

local talkState = {}
local lastCount = {}
--local lastCity = {}
local lastNickname = {}
local lastGuildName = {}
local lastReferralOption = {}
local lastAddonOption = {}

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        if (REQUIREMENTS[getNpcName()] and not REQUIREMENTS[getNpcName()](cid)) then
            selfSay("You do not have enough access to deal here!", cid)
            return false
        end
    end
    return true
end)

local COIN_USE_IDS = {}
COIN_USE_IDS.PREMIUM = 1
COIN_USE_IDS.CHANGE_SEX = 2
--COIN_USE_IDS.CHANGE_CITY = 3
COIN_USE_IDS.BLESS = 4
COIN_USE_IDS.POKEMON_NICKNAME = 5
COIN_USE_IDS.STAMINA_RECOVER = 6
COIN_USE_IDS.WITHDRAW = 7
COIN_USE_IDS.CREATE_GUILD = 8
COIN_USE_IDS.CREATE_GUILD_RANK = 9
-- VITAMIN = 10
COIN_USE_IDS.EGG_MOVE_CAPSULE = 11
COIN_USE_IDS.POKEMON_ADDON = 12

local NODES = {
    -- PREMIUM
    {
        keywords = { 'premium', 'vip', 'premmium' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            --onlyFocus = true,
            text = 'Oh, then you want a premium account. You can buy 30 days for 10 Soul Coins. Do you want it?'
        },
        childs = {
            {
                keywords = { 'yes', 'sim' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.premium called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    if (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 10)) then
                        npcHandler:say("You need at least 10 Soul Coins to do it.", cid)
                        return true
                    end

                    doPlayerAddPremiumDays(cid, 30)
                    selfSay("Thanks! Was credited 30 days of premium to your account.", cid)
                    doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.PREMIUM, 10)
                    Referral.onPlayerAcquirePremium(cid)

                    npcHandler:resetNpc(cid)
                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                }
            },
            {
                keywords = { 'no', 'nao' },
                callback = StdModule.say,
                parameters = {
                    npcHandler = npcHandler,
                    onlyFocus = true,
                    reset = true,
                    text = 'Maybe latter.'
                }
            }
        }
    },
    -- SEX
    {
        keywords = { 'sex', 'sexo' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'Do you want to change your sex? The price is 3 Souls Coins.'
        },
        childs = {
            {
                keywords = { 'yes', 'sim' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.sex called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    if (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 3)) then
                        npcHandler:say("You need at least 3 Soul Coins to change your sex.", cid)
                        return true
                    end

                    doPlayerSetSex(cid, getPlayerSex(cid) == 1 and 0 or 1)
                    doPlayerSendOutfitWindow(cid)
                    selfSay("Thanks! Your sex was exchanged.", cid)
                    doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.CHANGE_SEX, 3)

                    npcHandler:resetNpc(cid)
                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                }
            },
            {
                keywords = { 'no', 'nao' },
                callback = StdModule.say,
                parameters = {
                    npcHandler = npcHandler,
                    onlyFocus = true,
                    reset = true,
                    text = 'Maybe latter.'
                }
            }
        }
    },
    -- CITY
    --[[ Disabled, its free now
    {
        keywords = {'city', 'hometown'},
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'What will be your new hometown? This will cost 5 Souls Coins.'
        },
        childs = {
            {
                keywords = {'.*'},
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.city called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    message = string.lower(message)
                    if (not isInArray(cities, message)) then
                        npcHandler:say("Sorry?", cid)
                        npcHandler:resetNpc(cid)
                        return true

                    elseif (CITY_REQUIREMENT[message] and not CITY_REQUIREMENT[message](cid)) then
                        npcHandler:say("You do not have enough access to live there.", cid)
                        return true
                    end

                    selfSay("You really want to live in " .. message .. "?", cid)
                    lastCity[cid] = message

                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                },
                childs = {
                    {
                        keywords = {'yes','sim'},
                        callback = function(cid, message, keywords, parameters, node)
                            local npcHandler = parameters.npcHandler
                            if (npcHandler == nil) then
                                error('soulTrade.city called without any npcHandler instance.')
                            end

                            if (not npcHandler:isFocused(cid) or not lastCity[cid]) then
                                return false
                            end

                            if (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 5)) then
                                npcHandler:say("You need at least 5 Soul Coins to change your hometown.", cid)
                                return true
                            end

                            if (not doPlayerSetTown(cid, getTownId(lastCity[cid]))) then
								doPlayerAddItem(cid, SOUL_COIN_ID, 5, true)
								npcHandler:say("Please, try again later.", cid)
								return true
							end

                            selfSay("Thanks! Your hometown was changed.", cid)
                            doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.CHANGE_CITY, 5)

                            npcHandler:resetNpc(cid)
                            return true
                        end,
                        parameters = {
                            npcHandler = npcHandler
                        }
                    },
                    {
                        keywords = {'no', 'nao'},
                        callback = StdModule.say,
                        parameters = {
                            npcHandler = npcHandler,
                            onlyFocus = true,
                            reset = true,
                            text = 'Maybe latter.'
                        }
                    }
                }
            }
        }
    },]]
    -- BLESS
    --[[{
        keywords = {'bless'},
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'Do you want blessing? With this you will lose less experience when you faint. This will cost 1 Soul Coin.'
        },
        childs = {
            {
                keywords = {'yes','sim'},
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.bless called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    if (getPlayerBlessing(cid, 5)) then
                        selfSay("You're already blessed.", cid)
                        return true
                    end

                    if (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 1)) then
                        npcHandler:say("You need at least 1 Soul Coin to blessed.", cid)
                        return true
                    end

                    doPlayerAddBlessing(cid, 1)
                    doPlayerAddBlessing(cid, 2)
                    doPlayerAddBlessing(cid, 3)
                    doPlayerAddBlessing(cid, 4)
                    doPlayerAddBlessing(cid, 5)
                    selfSay("Thanks!", cid)
                    doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.BLESS, 1)

                    npcHandler:resetNpc(cid)
                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                }
            },
            {
                keywords = {'no', 'nao'},
                callback = StdModule.say,
                parameters = {
                    npcHandler = npcHandler,
                    onlyFocus = true,
                    reset = true,
                    text = 'Maybe latter.'
                }
            }
        }
    },]]
    -- POKEMON NICK CHANGE
    {
        keywords = { 'pokemon nick change', 'troca de apelido pokemon', 'nick change', 'troca apelido', 'troca de apelido' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'I can create or change your Pokemon nickname for 1 Soul Coins. What nickname you want?'
        },
        childs = {
            {
                keywords = { '.*' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.pokemonNickChange called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    lastNickname[cid] = message
                    npcHandler:say(string.format(__L(cid, "%s, are you sure?"), message), cid)

                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                },
                childs = {
                    {
                        keywords = { 'yes', 'sim' },
                        callback = function(cid, message, keywords, parameters, node)
                            local npcHandler = parameters.npcHandler
                            if (npcHandler == nil) then
                                error('soulTrade.pokemonNickChange called without any npcHandler instance.')
                            end

                            if (not npcHandler:isFocused(cid) or not lastNickname[cid]) then
                                return false
                            end

                            if (not isItem(getPlayerBall(cid))) then
                                npcHandler:say("To do that, first put a ball in your ball slot.", cid)
                                return true

                            elseif (not isNickAcceptable(lastNickname[cid])) then
                                npcHandler:say("Sorry, your Pokemon nick can't contain invalid symbols and need be between 4 and 20 characters, please try again.", cid)
                                return true

                            elseif (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 1)) then
                                npcHandler:say("You need at least 1 Soul Coin to change your pokemon nickname.", cid)
                                return true
                            end

                            local oldNick = getBallPokemonNickname(getPlayerBall(cid).uid)

                            setPlayerPokemonNickname(cid, lastNickname[cid], false)
                            doDatalogPokeNickChange(cid, oldNick and oldNick or "", lastNickname[cid], os.time())
                            doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.CHANGE_POKEMON_NICKNAME, 1)
                            lastNickname[cid] = nil
                            npcHandler:say("Thanks! Your Pokemon nickname has been changed successfully!", cid)
                            doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.POKEMON_NICKNAME, 1)

                            npcHandler:resetNpc(cid)
                            return true
                        end,
                        parameters = {
                            npcHandler = npcHandler
                        }
                    },
                    {
                        keywords = { 'no', 'nao' },
                        callback = StdModule.say,
                        parameters = {
                            npcHandler = npcHandler,
                            onlyFocus = true,
                            reset = true,
                            text = 'Maybe latter.'
                        }
                    }
                }
            }
        }
    },
    -- POKEMON NICK REMOVE
    {
        keywords = { 'pokemon nick remove', 'remocao de apelido pokemon', 'nick remove', 'remocao de apelido', 'remocao apelido' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'I can remove your Pokemon nickname for free, do you want?'
        },
        childs = {
            {
                keywords = { 'yes', 'sim' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.pokemonNickRemove called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    if (not isItem(getPlayerBall(cid))) then
                        npcHandler:say("To do that, first put a ball in your ball slot.", cid)
                        return true
                    end

                    local pokemonName = getBallPokemonName(getPlayerBall(cid).uid)
                    if (string.find(pokemonName, "Shiny")) then
                        pokemonName = string.gsub(pokemonName, "%Shiny ", "")
                    end

                    local oldNick = getBallPokemonNickname(getPlayerBall(cid).uid)
                    setPlayerPokemonNickname(cid, pokemonName, true)
                    doDatalogPokeNickChange(cid, oldNick and oldNick or "", "", os.time())
                    npcHandler:say("Thanks! Your Pokemon nickname has been removed successfully!", cid)

                    npcHandler:resetNpc(cid)
                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                }
            },
            {
                keywords = { 'no', 'nao' },
                callback = StdModule.say,
                parameters = {
                    npcHandler = npcHandler,
                    onlyFocus = true,
                    reset = true,
                    text = 'Maybe latter.'
                }
            }
        }
    },
    -- SOUL COIN WITHDRAW
    {
        keywords = { 'withdraw', 'sacar' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'How much soul coins do you want to withdraw?'
        },
        childs = {
            {
                keywords = { '.*' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.withdraw called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    local count = getCountFromMessage(message)
                    if (count <= 0) then
                        npcHandler:say("Maybe later.", cid)
                        npcHandler:resetNpc(cid)
                        return true
                    end

                    local playerSoulCoins = getPlayerAccountSoulCoins(cid)
                    if (count > playerSoulCoins) then
                        npcHandler:say("Sorry, your account does not have that number of Soul Coins.", cid)
                        return true
                    end

                    setPlayerAccountSoulCoins(cid, playerSoulCoins - count)
                    doPlayerAddItem(cid, SOUL_COIN_ID, count)
                    doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.WITHDRAW, count)
                    npcHandler:say("Alright, it's here.", cid)

                    npcHandler:resetNpc(cid)
                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                }
            }
        }
    },
    -- SOUL COIN BALANCE
    {
        keywords = { 'balance', 'saldo' },
        callback = function(cid, message, keywords, parameters, node)
            local npcHandler = parameters.npcHandler
            if (npcHandler == nil) then
                error('soulTrade.balance called without any npcHandler instance.')
            end

            if (not npcHandler:isFocused(cid)) then
                return false
            end

            npcHandler:say(string.format(__L(cid, "Your account soul coins balance is: %s."), getPlayerAccountSoulCoins(cid)), cid)

            npcHandler:resetNpc(cid)
            return true
        end,
        parameters = {
            npcHandler = npcHandler
        }
    },
    -- STAMINA RECOVER
    {
        keywords = { 'stamina' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'I can sell you a stamina recover for 1 Soul Coins, do you want?'
        },
        childs = {
            {
                keywords = { 'yes', 'sim' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.stamina called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    if (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 1)) then
                        npcHandler:say("You need at least 1 Soul Coin to buy a Stamina Recover.", cid)
                        return true
                    end

                    doPlayerAddItem(cid, 13971, 1, true)
                    npcHandler:say("Thanks! Here is.", cid)
                    doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.STAMINA_RECOVER, 1)

                    npcHandler:resetNpc(cid)
                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                }
            },
            {
                keywords = { 'no', 'nao' },
                callback = StdModule.say,
                parameters = {
                    npcHandler = npcHandler,
                    onlyFocus = true,
                    reset = true,
                    text = 'Maybe latter.'
                }
            }
        }
    },
    -- SOUL COINS
    {
        keywords = { 'soul' },
        callback = function(cid, message, keywords, parameters, node)
            local npcHandler = parameters.npcHandler
            if (npcHandler == nil) then
                error('soulTrade.soul called without any npcHandler instance.')
            end

            if (not npcHandler:isFocused(cid)) then
                return false
            end

            npcHandler:say("Souls are valuable coins that can be exchanged for the following benefits: {premium account}, {exchange of sex}, {Pokemon nick change}, {Pokemon nick remove}, {stamina recover}, to form a {guild}, create a guild {rank}, buy {Egg Move Capsule} and {Pokemon Addon}. You can also {withdraw} or {balance} your account Soul Coins.", cid)

            npcHandler:resetNpc(cid)
            return true
        end,
        parameters = {
            npcHandler = npcHandler
        }
    },
    -- GUILD
    {
        keywords = { 'guild', 'guilda' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'You can create your own guild here for 5 Soul Coins. What will be the name of your guild?'
        },
        childs = {
            {
                keywords = { '.*' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.guild called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    lastGuildName[cid] = message
                    npcHandler:say(string.format(__L(cid, "%s, are you sure?"), message), cid)

                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                },
                childs = {
                    {
                        keywords = { 'yes', 'sim' },
                        callback = function(cid, message, keywords, parameters, node)
                            local npcHandler = parameters.npcHandler
                            if (npcHandler == nil) then
                                error('soulTrade.guild called without any npcHandler instance.')
                            end

                            if (not npcHandler:isFocused(cid) or not lastGuildName[cid]) then
                                return false
                            end

                            if (getPlayerGuildId(cid) > 0) then
                                npcHandler:say("You are already in a guild.", cid)
                                return true

                            elseif (not isNickAcceptable(lastGuildName[cid])) then
                                npcHandler:say("That guild name contains illegal characters or is too short or long, please choose another name.", cid)
                                return true

                            elseif (getGuildId(lastGuildName[cid])) then
                                npcHandler:say("There is already a guild with that name.", cid)
                                return true

                            elseif (getPlayerLevel(cid) < getConfigValue("levelToFormGuild")) then
                                npcHandler:say(string.format(__L(cid, "You need at least level %s to form a guild."), getConfigValue("levelToFormGuild")), cid)
                                return true

                            elseif (getPlayerPremiumDays(cid) < getConfigValue("premiumDaysToFormGuild")) then
                                npcHandler:say(string.format(__L(cid, "You need to have at least %s premium days to form a guild."), getConfigValue("premiumDaysToFormGuild")), cid)
                                return true

                            elseif (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 5)) then
                                npcHandler:say("You need at least 5 Soul Coins to form a guild.", cid)
                                return true

                            elseif (doCreateGuild(cid, lastGuildName[cid])) then
                                npcHandler:say("Congratulations! Your guild has been formed!", cid)
                                doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.CREATE_GUILD, 5)

                            else
                                npcHandler:say("That guild name contains illegal characters or is too short or long, please choose another name.", cid)
                                doPlayerSafeAddItem(cid, SOUL_COIN_ID, 5, false, false)
                            end

                            lastGuildName[cid] = nil
                            npcHandler:resetNpc(cid)
                            return true
                        end,
                        parameters = {
                            npcHandler = npcHandler
                        }
                    },
                    {
                        keywords = { 'no', 'nao' },
                        callback = StdModule.say,
                        parameters = {
                            npcHandler = npcHandler,
                            onlyFocus = true,
                            reset = true,
                            text = 'Maybe latter.'
                        }
                    }
                }
            }
        }
    },
    -- GUILD RANK
    {
        keywords = { 'rank', 'categoria' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'You can create a new rank for you guild for 1 soul coin. What will be the name of the new rank?'
        },
        childs = {
            {
                keywords = { '.*' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.guildRank called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    lastGuildName[cid] = message
                    npcHandler:say(string.format(__L(cid, "%s, are you sure?"), message), cid)

                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                },
                childs = {
                    {
                        keywords = { 'yes', 'sim' },
                        callback = function(cid, message, keywords, parameters, node)
                            local npcHandler = parameters.npcHandler
                            if (npcHandler == nil) then
                                error('soulTrade.guildRank called without any npcHandler instance.')
                            end

                            if (not npcHandler:isFocused(cid) or not lastGuildName[cid]) then
                                return false
                            end

                            if (getPlayerGuildId(cid) == 0) then
                                npcHandler:say("You aren't in a guild.", cid)
                                return true

                            elseif (getPlayerGuildLevel(cid) ~= GUILDLEVEL_LEADER) then
                                npcHandler:say("You aren't the leader of your guild.", cid)
                                return true

                            elseif (not isNickAcceptable(lastGuildName[cid])) then
                                npcHandler:say("That rank name contains illegal characters or is too short or long, please choose another name.", cid)
                                return true

                            elseif (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 1)) then
                                npcHandler:say("You need at least 1 Soul Coin to create a new guild rank.", cid)
                                return true

                            elseif (doGuildCreateRank(getPlayerGuildId(cid), lastGuildName[cid])) then
                                npcHandler:say("Congratulations! Your guild rank has been created! You must use the command \"/setrank[name,rank]\" to change a member rank.", cid)
                                doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.CREATE_GUILD_RANK, 1)

                            else
                                npcHandler:say("Sorry, not possible.", cid)
                                doPlayerSafeAddItem(cid, SOUL_COIN_ID, 1, false, false)
                            end

                            lastGuildName[cid] = nil
                            npcHandler:resetNpc(cid)
                            return true
                        end,
                        parameters = {
                            npcHandler = npcHandler
                        }
                    },
                    {
                        keywords = { 'no', 'nao' },
                        callback = StdModule.say,
                        parameters = {
                            npcHandler = npcHandler,
                            onlyFocus = true,
                            reset = true,
                            text = 'Maybe latter.'
                        }
                    }
                }
            }
        },
    },
    -- REFERRAL REWARDS
    {
        keywords = { 'referral', 'referencia' },
        callback = function(cid, message, keywords, parameters, node)
            local npcHandler = parameters.npcHandler
            if (npcHandler == nil) then
                error('soulTrade.referral called without any npcHandler instance.')
            end

            if (not npcHandler:isFocused(cid)) then
                return false
            end

            npcHandler:say('Yes, here you can exchange your account referral points into rewards. These are the reward options. Just say the name of what you want.', cid)
            Referral.doPlayerShowOptions(cid)

            return true
        end,
        parameters = {
            npcHandler = npcHandler
        },
        childs = {
            {
                keywords = { '.*' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.referral called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    local option = Referral.getRewardByName(message)
                    if (not option) then
                        selfSay("There is no option with that name!", cid)
                        npcHandler:resetNpc(cid)
                        return true
                    end

                    lastReferralOption[cid] = option
                    npcHandler:say(string.format(__L(cid, "You really want to exchange %s referral points into a %s?"), option.points, option.name), cid)

                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                },
                childs = {
                    {
                        keywords = { 'yes', 'sim' },
                        callback = function(cid, message, keywords, parameters, node)
                            local npcHandler = parameters.npcHandler
                            if (npcHandler == nil) then
                                error('soulTrade.referral called without any npcHandler instance.')
                            end

                            if (not npcHandler:isFocused(cid) or not lastReferralOption[cid]) then
                                return false
                            end

                            if (Referral.onPlayerBuy(cid, lastReferralOption[cid])) then
                                npcHandler:say("Thanks! Here is!", cid)
                            else
                                npcHandler:say("Something went wrong! Please try again later. Did you have enough referral points?", cid)
                            end

                            npcHandler:resetNpc(cid)
                            return true
                        end,
                        parameters = {
                            npcHandler = npcHandler
                        }
                    },
                    {
                        keywords = { 'no', 'nao' },
                        callback = StdModule.say,
                        parameters = {
                            npcHandler = npcHandler,
                            onlyFocus = true,
                            reset = true,
                            text = 'Maybe latter.'
                        }
                    }
                }
            }
        }
    },
    -- POKEMON ADDON
    {
        keywords = { 'addon' },
        callback = function(cid, message, keywords, parameters, node)
            local npcHandler = parameters.npcHandler
            if (npcHandler == nil) then
                error('soulTrade.addon called without any npcHandler instance.')
            end

            if (not npcHandler:isFocused(cid)) then
                return false
            end

            npcHandler:say('Yes, here you can exchange your soul coins into Pokemon addons. These are the options. Just say the name of what you want.', cid)
            PokemonAddon.doPlayerShowOptions(cid)

            return true
        end,
        parameters = {
            npcHandler = npcHandler
        },
        childs = {
            {
                keywords = { '.*' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.addon called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    local option = PokemonAddon.getRewardByName(message)
                    if (not option) then
                        selfSay("There is no option with that name!", cid)
                        npcHandler:resetNpc(cid)
                        return true
                    end

                    lastAddonOption[cid] = option
                    npcHandler:say(string.format(__L(cid, "You really want to exchange %s soul coin(s) into a %s?"), option.coins, option.name), cid)

                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                },
                childs = {
                    {
                        keywords = { 'yes', 'sim' },
                        callback = function(cid, message, keywords, parameters, node)
                            local npcHandler = parameters.npcHandler
                            if (npcHandler == nil) then
                                error('soulTrade.addon called without any npcHandler instance.')
                            end

                            if (not npcHandler:isFocused(cid) or not lastAddonOption[cid]) then
                                return false
                            end

                            if (PokemonAddon.onPlayerBuy(cid, lastAddonOption[cid])) then
                                npcHandler:say("Thanks! Here is!", cid)
                            else
                                npcHandler:say("Something went wrong! Please try again later.", cid)
                            end

                            npcHandler:resetNpc(cid)
                            return true
                        end,
                        parameters = {
                            npcHandler = npcHandler
                        }
                    },
                    {
                        keywords = { 'no', 'nao' },
                        callback = StdModule.say,
                        parameters = {
                            npcHandler = npcHandler,
                            onlyFocus = true,
                            reset = true,
                            text = 'Maybe latter.'
                        }
                    }
                }
            }
        }
    },
    -- EGG MOVE CAPSULE
    {
        keywords = { 'egg move capsule' },
        callback = StdModule.say,
        parameters = {
            npcHandler = npcHandler,
            text = 'I can sell you an Egg Move Capsule for 1 Soul Coin, do you want?'
        },
        childs = {
            {
                keywords = { 'yes', 'sim' },
                callback = function(cid, message, keywords, parameters, node)
                    local npcHandler = parameters.npcHandler
                    if (npcHandler == nil) then
                        error('soulTrade.eggMoveCapsule called without any npcHandler instance.')
                    end

                    if (not npcHandler:isFocused(cid)) then
                        return false
                    end

                    if (not doPlayerRemoveItem(cid, SOUL_COIN_ID, 1)) then
                        npcHandler:say("You need at least 1 Soul Coin to buy an Egg Move Capsule.", cid)
                        return true
                    end

                    doPlayerAddItem(cid, 28915, 1, true)
                    npcHandler:say("Thanks! Here is.", cid)
                    doDatalogCoinUse(os.time(), getPlayerGUID(cid), COIN_USE_IDS.EGG_MOVE_CAPSULE, 1)

                    npcHandler:resetNpc(cid)
                    return true
                end,
                parameters = {
                    npcHandler = npcHandler
                }
            },
            {
                keywords = { 'no', 'nao' },
                callback = StdModule.say,
                parameters = {
                    npcHandler = npcHandler,
                    onlyFocus = true,
                    reset = true,
                    text = 'Maybe latter.'
                }
            }
        }
    },
}

for k, v in pairs(NODES) do
    local node = keywordHandler:addKeyword(v.keywords, v.callback, v.parameters)
    if (v.childs) then
        for _k, _v in pairs(v.childs) do
            local subNode = node:addChildKeyword(_v.keywords, _v.callback, _v.parameters)
            if (_v.childs) then
                for __k, __v in pairs(_v.childs) do
                    subNode:addChildKeyword(__v.keywords, __v.callback, __v.parameters)
                end
            end
        end
    end
end

NODES = nil
local DESTS = {}
DESTS["viridian"] = { channelId = CHANNEL_VIRIDIAN }
DESTS["pewter"] = { channelId = CHANNEL_PEWTER }
DESTS["cerulean"] = { channelId = CHANNEL_CERULEAN }
DESTS["saffron"] = { channelId = CHANNEL_SAFFRON }
DESTS["celadon"] = { channelId = CHANNEL_CELADON }
DESTS["vermilion"] = { channelId = CHANNEL_VERMILION }
DESTS["lavender"] = { channelId = CHANNEL_LAVENDER }
DESTS["fuchsia"] = { channelId = CHANNEL_FUCHSIA }
DESTS["cinnabar"] = { channelId = CHANNEL_CINNABAR }

DESTS["tangelo"] = { channelId = CHANNEL_TANGELO }
DESTS["sunburst"] = { channelId = CHANNEL_SUNBURST }
DESTS["mikan"] = { channelId = CHANNEL_MIKAN }

DESTS["pummelo"] = { channelId = CHANNEL_PUMMELO, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end }
DESTS["pinkan"] = { channelId = CHANNEL_PINKAN, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end }
DESTS["valencia"] = { channelId = CHANNEL_VALENCIA, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end }

DESTS["hamlin"] = { channelId = CHANNEL_HAMLIN, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end }
DESTS["kumquat"] = { channelId = CHANNEL_KUMQUAT, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end }
DESTS["tarroco"] = { channelId = CHANNEL_TARROCO, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end }

DESTS["butwal"] = { channelId = CHANNEL_BUTWAL, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end }
DESTS["navel"] = { channelId = CHANNEL_NAVEL, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end }
DESTS["mandarin north"] = { channelId = CHANNEL_MANDARIN_NORTH, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end }

DESTS["ascorbia"] = { channelId = CHANNEL_ASCORBIA, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end }
DESTS["seven grapefruit"] = { channelId = CHANNEL_SEVEN_GRAPEFRUIT, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end }
DESTS["moro"] = { channelId = CHANNEL_MORO, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end }

DESTS["shamouti"] = { channelId = CHANNEL_SHAMOUTI, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end }
DESTS["murcott"] = { channelId = CHANNEL_MURCOTT, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end }
DESTS["trovitopolis"] = { channelId = CHANNEL_TROVITOPOLIS, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end }
DESTS["mandarin south"] = { townName = "Mandarin South 02", channelId = CHANNEL_MANDARIN_SOUTH, require = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end }

DESTS["littleroot"] = { channelId = CHANNEL_LITTLEROOT }
DESTS["oldale"] = { channelId = CHANNEL_OLDALE }
DESTS["petalburg"] = { channelId = CHANNEL_PETALBURG }
DESTS["rustboro"] = { channelId = CHANNEL_RUSTBORO }
DESTS["dewford"] = { channelId = CHANNEL_DEWFORD }
DESTS["slateport"] = { channelId = CHANNEL_SLATEPORT }
DESTS["mauville"] = { channelId = CHANNEL_MAUVILLE }
DESTS["verdanturf"] = { channelId = CHANNEL_VERDANTURF }
DESTS["fallarbor"] = { channelId = CHANNEL_FALLARBOR }
DESTS["lavaridge"] = { channelId = CHANNEL_LAVARIDGE }
DESTS["fortree"] = { channelId = CHANNEL_FORTREE }
DESTS["lilycove"] = { channelId = CHANNEL_LILYCOVE }
DESTS["mossdeep"] = { channelId = CHANNEL_MOSSDEEP }
DESTS["sootopolis"] = { channelId = CHANNEL_SOOTOPOLIS }
DESTS["pacifidlog"] = { channelId = CHANNEL_PACIFIDLOG }

local TELEPORT_WAITING_TIME = {
    ["Chartle"] = 30,
    ["Darkchu"] = 30,
    ["Squirsaur"] = 30,
    ["Bulmander"] = 30,
    ["Abra"] = 30,
    ["Kadabra"] = 25,
    ["Alakazam"] = 20,
    ["Drowzee"] = 30,
    ["Hypno"] = 20,
    ["Mr. Mime"] = 25,
    ["Mewtwo"] = 15,
    ["Mew"] = 15,
    ["Porygon"] = 20,
    ["Espeon"] = 20,
    ["Natu"] = 30,
    ["Porygon2"] = 20,
    ["Slowking"] = 20,
    ["Unown"] = 20,
    ["Wobbuffet"] = 20,
    ["Xatu"] = 20,
    ["Girafarig"] = 20,

    ["Baltoy"] = 20,
    ["Beldum"] = 20,
    ["Chimecho"] = 20,
    ["Claydol"] = 20,
    ["Deoxys"] = 20,
    ["Gardevoir"] = 20,
    ["Grumpig"] = 20,
    ["Jirachi"] = 20,
    ["Kirlia"] = 20,
    ["Latias"] = 20,
    ["Latios"] = 20,
    ["Lunatone"] = 20,
    ["Medicham"] = 20,
    ["Meditite"] = 20,
    ["Metang"] = 20,
    ["Ralts"] = 20,
    ["Solrock"] = 20,
    ["Spoink"] = 20,
    ["Wynaut"] = 20,
    ["Metagross"] = 20,
    -- Shiny
    ["Shiny Abra"] = 30,
    ["Shiny Kadabra"] = 25,
    ["Shiny Alakazam"] = 20,
    ["Shiny Drowzee"] = 30,
    ["Shiny Hypno"] = 20,
    ["Shiny Mr. Mime"] = 25,
    ["Shiny Mewtwo"] = 15,
    ["Shiny Mew"] = 15,
    ["Shiny Porygon"] = 20,
    ["Shiny Espeon"] = 20,
    ["Shiny Natu"] = 30,
    ["Shiny Porygon2"] = 20,
    ["Shiny Slowking"] = 20,
    ["Shiny Unown"] = 20,
    ["Shiny Wobbuffet"] = 20,
    ["Shiny Xatu"] = 20,
    ["Shiny Girafarig"] = 20,
}

local function getDestinations(cid)
    local dests = { CHANNEL_HOUSE, CHANNEL_GUILD_HOUSE }
    for dest, conf in pairs(DESTS) do
        if (not conf.require or conf.require(cid)) then
            dests[#dests + 1] = conf.channelId
        end
    end
    return dests
end

function onSay(cid, words, param, channel)
    if ((not isPokemonOnline(cid) and not getPlayerMounted(cid)) or not isPremium(cid) or isUnderwater(cid) or isPlayerOnPvpArena(cid) or
            hasCondition(cid, CONDITION_INFIGHT) or getPlayerWatchingTV(cid) or getPlayerDueling(cid) or
            getPlayerMasteryDungeon(cid) > 0 or getPlayerFrontierIsland(cid) or getPlayerTournamentReady(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

    elseif (param == "") then
        doPlayerSendChannelsDialog(cid, getDestinations(cid))

    else
        local ball = getPlayerBall(cid)
        if (isItem(ball) and isEpicBall(ball.itemid)) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return true
        end

        local pokemonName = getPlayerPokemonName(cid, true)
        param = string.lower(param)

        if (not getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.TELEPORT, getPlayerPokemonName(cid, true))) then
            doPlayerSendCancel(cid, "Your Pokemon does not have this ability.")

        elseif (not DESTS[param] and param ~= "home" and param ~= "house" and param ~= "guild"
                and param ~= "guild house") then
            doPlayerSendCancel(cid, "This destination does not exist.")

        elseif (DESTS[param] and DESTS[param].require and not DESTS[param].require(cid)) then
            doPlayerSendCancel(cid, "You do not have enough access to teleport to this destination.")

        else
            local teleportTime = getCreatureStorage(cid, playersStorages.teleport) or -1
            if (teleportTime <= os.time()) then
                local townName
                if (DESTS[param] and DESTS[param].townName) then
                    townName = DESTS[param].townName
                else
                    townName = param
                end
                local town, newPosition, message = getTownId(townName)

                if (town) then
                    newPosition = getTownTemplePosition(town)
                    message = string.capitalise(param)

                elseif (param == "home" or param == "house") then
                    local house = getHouseByPlayerGUID(getPlayerGUID(cid))
                    if (not house) then
                        doPlayerSendCancel(cid, "To use this command you need to own a house.")
                        return true
                    else
                        newPosition = getHouseEntry(house)
                        message = __L(cid, "my house")
                    end

                elseif (param == "guild" or param == "guild house") then
                    local guild = getPlayerGuildId(cid)
                    if (guild == 0) then
                        doPlayerSendCancel(cid, "To use this command you must be in a guild.")
                        return true
                    end

                    local house = getHouseByGuildId(guild)
                    if (not house) then
                        doPlayerSendCancel(cid, "To use this command your guild must own a guild house.")
                        return true
                    else
                        newPosition = getHouseEntry(house)
                        message = __L(cid, "my guild house")
                    end

                else
                    return false
                end

                local time = TELEPORT_WAITING_TIME[pokemonName]
                if (not time) then
                    time = 30
                    log(LOG_TYPES.ERROR, "Teleport::onSay - Unknown pokemonName", pokemonName)
                end
                if (doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.TELEPORT_COOLDOWN)) then
                    time = math.ceil(time / 1.2)
                end

                doTeleportThing(cid, newPosition, false)
                doSendMagicEffect(newPosition, EFFECT_TELEPORT_TWO)
                doCreatureSetStorage(cid, playersStorages.teleport, os.time() + ((time or 30) * 60))
                doCreatureSay(cid, string.format(__L(cid, "%s, teleport us to %s!"), getPlayerPokemonNickname(cid), message), TALKTYPE_MONSTER)
                setPlayerBlockLogout(cid, false)

            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You must wait %s to use teleport again."), table.concat(string.timediff((teleportTime - os.time()), cid))))
            end
        end
    end

    return true
end

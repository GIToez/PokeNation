if (SurviveChallenge) then
    return
end
--
local ITEMID_TOKEN = 18128
local ITEMID_REVIVE = 12248
local ITEMID_HEALTHPOTION = 12247 -- Super Pokemon Potion
local ITEMID_ENERGYPOTION = 13819 -- Pokemon Great Energy Potion

SurviveChallenge = {}

SurviveChallenge.Config = {}
SurviveChallenge.Config.REQUIRED_PLAYERS = 8
SurviveChallenge.Config.ARENA_RADIUS = 20

SurviveChallenge.REASON_IDS = {
    NOBODY = 0,
    ONE_LEFT = 1
}

SurviveChallenge.ARENA = {
    startPos = {x = 5065, y = 246, z = 9}, exitPos = {x = 5066, y = 183, z = 8}, centerPos = {x = 5065, y = 246, z = 9},
    spawnPos = {
        {x = 5055, y = 238, z = 9}, {x = 5067, y = 239, z = 9}, {x = 5072, y = 248, z = 9},
        {x = 5067, y = 254, z = 9}, {x = 5059, y = 253, z = 9}, {x = 5055, y = 246, z = 9},
        {x = 5062, y = 240, z = 9}, {x = 5053, y = 245, z = 9}},
    working = false, players = {}
}

SurviveChallenge.ROOMS = { -- WAITING ROOMS
    {
        startPos = {x = 2715, y = 223, z = 9},
        players = {}
    },
    {
        startPos = {x = 2714, y = 267, z = 9},
        players = {}
    }
}

SurviveChallenge.exitPlayer = function(cid, teleport)
    if (teleport) then
        doTeleportThing(cid, SurviveChallenge.ARENA.exitPos)
    end
    setPlayerFrontierIsland(cid, false)
    setPlayerSurviveArena(cid, false)
end

SurviveChallenge.onStart = function()
    SurviveChallenge.ARENA.working = true

    for _, room in pairs(SurviveChallenge.ROOMS) do
        SurviveChallenge.ARENA.players = table_concat(SurviveChallenge.ARENA.players, room.players)
        table.clear(room.players)
        room.players = {}
    end

    for _, cid in pairs(SurviveChallenge.ARENA.players) do
        setPlayerFrontierIsland(cid, true)
        setPlayerSurviveArena(cid, true)
        doTeleportThing(cid, table.random(SurviveChallenge.ARENA.spawnPos))
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Survive Challenge has started!")
    end
end

SurviveChallenge.onEnd = function(reason, winner)
    if (reason ~= SurviveChallenge.REASON_IDS.NOBODY) then
        for _, cid in pairs(SurviveChallenge.ARENA.players) do
            SurviveChallenge.exitPlayer(cid, true)
            if (cid == winner) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Congratulations! You won the Survive Challenge!")
                doPlayerAddHighscoreValue(cid, HIGHSCORE_IDS.SURVIVE_CHALLENGE, 10)
                doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.WIN_FRONTIER_ISLAND, 1)
            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "You was defeated in the Survive Challenge!")
            end
        end
    end

    table.clear(SurviveChallenge.ARENA.players)
    SurviveChallenge.ARENA.players = {}
    SurviveChallenge.ARENA.working = false
end

SurviveChallenge.onThink = function()
    if (SurviveChallenge.ARENA.working) then
        for k, cid in pairs(SurviveChallenge.ARENA.players) do
            if (not isCreature(cid)) then
                SurviveChallenge.ARENA.players[k] = nil

            elseif (getDistanceBetween(getCreaturePosition(cid), SurviveChallenge.ARENA.centerPos) >
                    SurviveChallenge.Config.ARENA_RADIUS) then
                SurviveChallenge.exitPlayer(cid)
                SurviveChallenge.ARENA.players[k] = nil
            end
        end

        local spec = getSpectators(SurviveChallenge.ARENA.centerPos, SurviveChallenge.Config.ARENA_RADIUS,
            SurviveChallenge.Config.ARENA_RADIUS, false)
        if (spec) then
            local winner
            for k, v in pairs(spec) do
                if (isPlayer(v)) then
                    if (not winner) then
                        winner = v
                    else
                        winner = nil
                        break
                    end
                end
            end

            if (winner) then
                SurviveChallenge.onEnd(SurviveChallenge.REASON_IDS.ONE_LEFT, winner)
            end
        else
            SurviveChallenge.onEnd(SurviveChallenge.REASON_IDS.NOBODY)
        end

    else
        for _, room in pairs(SurviveChallenge.ROOMS) do
            for k, cid in pairs(room.players) do
                if (not isCreature(cid) or getDistanceBetween(getCreaturePosition(cid), room.startPos) > 9) then
                    room.players[k] = nil
                end
            end
        end

        local count = 0
        for _, room in pairs(SurviveChallenge.ROOMS) do
            count = count + #room.players
        end

        if (count == SurviveChallenge.Config.REQUIRED_PLAYERS) then
            SurviveChallenge.onStart()
        end
    end

    addEvent(SurviveChallenge.onThink, 1000)
end

SurviveChallenge.getFreeArena = function()
    return not SurviveChallenge.ARENA.working
end

SurviveChallenge.joinPlayer = function(cid)
    local count = 0
    for _, room in pairs(SurviveChallenge.ROOMS) do
        count = count + #room.players
    end

    if (count >= SurviveChallenge.Config.REQUIRED_PLAYERS) then
        return false
    end

    count = count + 1
    for _, room in pairs(SurviveChallenge.ROOMS) do
        for __, cid in pairs(room.players) do
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                string.format(__L(cid, "A new player has joined the Survive Challenge. Remaing now %s player(s) to start!"), (SurviveChallenge.Config.REQUIRED_PLAYERS - count)))
        end
    end

    local room = table.random(SurviveChallenge.ROOMS)
    room.players[#room.players + 1] = cid

    if (doTeleportThing(cid, room.startPos)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have been teleported to the waiting room. Wait until all players get ready!")
        return true
    end

    return false
end

addEvent(SurviveChallenge.onThink, 60 * 1000)
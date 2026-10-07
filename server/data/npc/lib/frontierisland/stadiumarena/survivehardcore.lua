if (SurviveHardcore) then
    return
end
--
local ITEMID_TOKEN = 18128
local ITEMID_REVIVE = 12248
local ITEMID_HEALTHPOTION = 12247 -- Super Pokemon Potion
local ITEMID_ENERGYPOTION = 13819 -- Pokemon Great Energy Potion

SurviveHardcore = {}

SurviveHardcore.Config = {}
SurviveHardcore.Config.REQUIRED_PLAYERS = 8
SurviveHardcore.Config.ARENA_RADIUS = 20
SurviveHardcore.Config.BOSS_COUNT = 2
SurviveHardcore.Config.BOSSES = {"FI The Dream Eater", "FI The Hipnotist", "FI The Hunter", "FI The Lovely", "FI The Thousand Arms", "FI The War Dog"}

SurviveHardcore.REASON_IDS = {
    NOBODY = 0,
    ONE_LEFT = 1
}

SurviveHardcore.ARENA = {
    startPos = {x = 5065, y = 246, z = 10}, exitPos = {x = 5066, y = 183, z = 8}, centerPos = {x = 5065, y = 246, z = 10},
    spawnPos = {
        {x = 5055, y = 238, z = 10}, {x = 5067, y = 239, z = 10}, {x = 5072, y = 248, z = 10},
        {x = 5067, y = 254, z = 10}, {x = 5059, y = 253, z = 10}, {x = 5055, y = 246, z = 10},
        {x = 5062, y = 240, z = 10}, {x = 5053, y = 245, z = 10}},
    working = false, players = {}
}

SurviveHardcore.ROOMS = { -- WAITING ROOMS
    {
        startPos = {x = 2715, y = 223, z = 10},
        players = {}
    },
    {
        startPos = {x = 2714, y = 267, z = 10},
        players = {}
    }
}

SurviveHardcore.exitPlayer = function(cid, teleport)
    if (teleport) then
        doTeleportThing(cid, SurviveHardcore.ARENA.exitPos)
    end
    setPlayerFrontierIsland(cid, false)
    setPlayerSurviveArena(cid, false)
end

SurviveHardcore.onStart = function()
    SurviveHardcore.ARENA.working = true

    for _, room in pairs(SurviveHardcore.ROOMS) do
        SurviveHardcore.ARENA.players = table_concat(SurviveHardcore.ARENA.players, room.players)
        table.clear(room.players)
        room.players = {}
    end

    for _, cid in pairs(SurviveHardcore.ARENA.players) do
        setPlayerFrontierIsland(cid, true)
        setPlayerSurviveArena(cid, true)
        doTeleportThing(cid, table.random(SurviveHardcore.ARENA.spawnPos))
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Survive Hardcore has started!")
    end

    for i = 1, SurviveHardcore.Config.BOSS_COUNT do
        doCreateMonster(table.random(SurviveHardcore.Config.BOSSES),
            table.random(SurviveHardcore.ARENA.spawnPos))
    end
end

SurviveHardcore.onEnd = function(reason, winner)
    if (reason ~= SurviveHardcore.REASON_IDS.NOBODY) then
        for _, cid in pairs(SurviveHardcore.ARENA.players) do
            SurviveHardcore.exitPlayer(cid, true)
            if (cid == winner) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Congratulations! You won the Survive Hardcore!")
                doPlayerAddHighscoreValue(cid, HIGHSCORE_IDS.SURVIVE_HARDCORE, 10)
                doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.WIN_FRONTIER_ISLAND, 1)
            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "You was defeated in the Survive Hardcore!")
            end
        end
    end

    table.clear(SurviveHardcore.ARENA.players)
    SurviveHardcore.ARENA.players = {}
    SurviveHardcore.ARENA.working = false
end

SurviveHardcore.onThink = function()
    if (SurviveHardcore.ARENA.working) then
        for k, cid in pairs(SurviveHardcore.ARENA.players) do
            if (not isCreature(cid)) then
                SurviveHardcore.ARENA.players[k] = nil

            elseif (getDistanceBetween(getCreaturePosition(cid), SurviveHardcore.ARENA.centerPos) >
                    SurviveHardcore.Config.ARENA_RADIUS) then
                SurviveHardcore.exitPlayer(cid)
                SurviveHardcore.ARENA.players[k] = nil
            end
        end

        local spec = getSpectators(SurviveHardcore.ARENA.centerPos, SurviveHardcore.Config.ARENA_RADIUS,
            SurviveHardcore.Config.ARENA_RADIUS, false)
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
                SurviveHardcore.onEnd(SurviveHardcore.REASON_IDS.ONE_LEFT, winner)
            end
        else
            SurviveHardcore.onEnd(SurviveHardcore.REASON_IDS.NOBODY)
        end

    else
        for _, room in pairs(SurviveHardcore.ROOMS) do
            for k, cid in pairs(room.players) do
                if (not isCreature(cid) or getDistanceBetween(getCreaturePosition(cid), room.startPos) > 9) then
                    room.players[k] = nil
                end
            end
        end

        local count = 0
        for _, room in pairs(SurviveHardcore.ROOMS) do
            count = count + #room.players
        end

        if (count == SurviveHardcore.Config.REQUIRED_PLAYERS) then
            SurviveHardcore.onStart()
        end
    end

    addEvent(SurviveHardcore.onThink, 1000)
end

SurviveHardcore.getFreeArena = function()
    return not SurviveHardcore.ARENA.working
end

SurviveHardcore.joinPlayer = function(cid)
    local count = 0
    for _, room in pairs(SurviveHardcore.ROOMS) do
        count = count + #room.players
    end

    if (count >= SurviveHardcore.Config.REQUIRED_PLAYERS) then
        return false
    end

    count = count + 1
    for _, room in pairs(SurviveHardcore.ROOMS) do
        for __, cid in pairs(room.players) do
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                string.format(__L(cid, "A new player has joined the Survive Hardcore. Remaing now %s player(s) to start!"), (SurviveHardcore.Config.REQUIRED_PLAYERS - count)))
        end
    end

    local room = table.random(SurviveHardcore.ROOMS)
    room.players[#room.players + 1] = cid

    if (doTeleportThing(cid, room.startPos)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have been teleported to the waiting room. Wait until all players get ready!")
        return true
    end

    return false
end

addEvent(SurviveHardcore.onThink, 60 * 1000)
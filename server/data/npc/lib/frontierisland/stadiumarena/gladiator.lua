if (Gladiator) then
    return
end
--
local ITEMID_TOKEN = 18128
local ITEMID_REVIVE = 12248
local ITEMID_HEALTHPOTION = 12247 -- Super Pokemon Potion
local ITEMID_ENERGYPOTION = 13819 -- Pokemon Great Energy Potion

Gladiator = {}
Gladiator.ARENA_IDS = {
    1, 2
}

Gladiator.REASON_IDS = {
    PLAYER_OFFLINE = 0,
    PLAYER_WIN = 1,
    PLAYER_AWAY = 2
}

Gladiator.ARENAS = {
    [1] = {
        startPos = {x = 5065, y = 117, z = 9}, exitPos = {x = 5066, y = 183, z = 8},
        spawnPos = {
            {x = 5063, y = 111, z = 9}, {x = 5068, y = 113, z = 9}, {x = 5069, y = 121, z = 9},
            {x = 5060, y = 120, z = 9}, {x = 5059, y = 117, z = 9}, {x = 5061, y = 113, z = 9},
            {x = 5064, y = 114, z = 9}, {x = 5065, y = 119, z = 9}},
        working = false, monsters = {}
    },
    [2] = {
        startPos = {x = 5065, y = 117, z = 10}, exitPos = {x = 5066, y = 183, z = 8},
        spawnPos = {
            {x = 5064, y = 111, z = 10}, {x = 5069, y = 116, z = 10}, {x = 5069, y = 123, z = 10},
            {x = 5059, y = 119, z = 10}, {x = 5060, y = 114, z = 10}, {x = 5063, y = 112, z = 10},
            {x = 5066, y = 117, z = 10}, {x = 5063, y = 115, z = 10}
            },
        working = false, monsters = {}
    },
}

Gladiator.ROUNDS = {
    [1] = {
        spawns = {
            "FI Abra", 4
        },
        rewardScore = 10
    },
    [2] = {
        spawns = {
            "FI Ledyba", 4
        },
        rewardScore = 15
    },
    [3] = {
        spawns = {
            "FI Marill", 4
        },
        rewardScore = 20
    },
    [4] = {
        spawns = {
            "FI Natu", 4
        },
        rewardScore = 25
    },
    [5] = {
        spawns = {
            "FI Ponyta", 4
        },
        rewards = {
            {itemid = ITEMID_REVIVE, count = 1, unique = true}
        },
        rewardScore = 30
    },
    [6] = {
        spawns = {
            "FI The Bird", 1
        },
        rewards = {
            {itemid = ITEMID_TOKEN, count = 1, unique = true, toDepot = true}
        },
        rewardScore = 35
    },
    [7] = {
        spawns = {
            "FI Psyduck", 4
        },
        rewardScore = 40
    },
    [8] = {
        spawns = {
            "FI Spearow", 4
        },
        rewardScore = 45
    },
    [9] = {
        spawns = {
            "FI Squirtle", 4
        },
        rewardScore = 50
    },
    [10] = {
        spawns = {
            "FI Voltorb", 4
        },
        rewardScore = 55
    },
    [11] = {
        spawns = {
            "FI Vulpix", 4
        },
        rewardScore = 60
    },
    [12] = {
        spawns = {
            "FI The Iron Tooth", 1
        },
        rewards = {
            {itemid = ITEMID_TOKEN, count = 2, unique = true, toDepot = true}
        },
        rewardScore = 65
    },
    [13] = {
        spawns = {
            "FI Beedrill", 4
        },
        rewardScore = 70
    },
    [14] = {
        spawns = {
            "FI Butterfree", 4
        },
        rewardScore = 75
    },
    [15] = {
        spawns = {
            "FI Corsola", 4
        },
        rewardScore = 80
    },
    [16] = {
        spawns = {
            "FI Croconaw", 4
        },
        rewardScore = 85
    },
    [17] = {
        spawns = {
            "FI Dunsparce", 4
        },
        rewardScore = 90
    },
    [18] = {
        spawns = {
            "FI The Flameless Gecko", 1
        },
        rewards = {
            {itemid = ITEMID_TOKEN, count = 3, unique = true, toDepot = true}
        },
        rewardScore = 95
    },
    [19] = {
        spawns = {
            "FI Yanma", 4
        },
        rewardScore = 100
    },
    [20] = {
        spawns = {
            "FI Gloom", 4
        },
        rewardScore = 105
    },
    [21] = {
        spawns = {
            "FI Golbat", 4
        },
        rewardScore = 110
    },
    [22] = {
        spawns = {
            "FI Kingler", 4
        },
        rewardScore = 115
    },
    [23] = {
        spawns = {
            "FI Sneasel", 4
        },
        rewardScore = 120
    },
    [24] = {
        spawns = {
            "FI The Small Turtle", 1
        },
        rewards = {
            {itemid = ITEMID_TOKEN, count = 4, unique = true, toDepot = true}
        },
        rewardScore = 125
    },
    [25] = {
        spawns = {
            "FI Alakazam", 4
        },
        rewardScore = 130
    },
    [26] = {
        spawns = {
            "FI Ampharos", 4
        },
        rewardScore = 135
    },
    [27] = {
        spawns = {
            "FI Arcanine", 4
        },
        rewardScore = 140
    },
    [28] = {
        spawns = {
            "FI Azumarill", 4
        },
        rewardScore = 145
    },
    [29] = {
        spawns = {
            "FI Charizard", 4
        },
        rewardScore = 150
    },
    [30] = {
        spawns = {
            "FI The Alligator Fist", 1
        },
        rewards = {
            {itemid = ITEMID_TOKEN, count = 5, unique = true, toDepot = true}
        },
        rewardScore = 155
    },
    [31] = {
        spawns = {
            "FI Electabuzz", 4
        },
        rewardScore = 160
    },
    [32] = {
        spawns = {
            "FI Gyarados", 4
        },
        rewardScore = 165
    },
    [33] = {
        spawns = {
            "FI Meganium", 4
        },
        rewardScore = 170
    },
    [34] = {
        spawns = {
            "FI Shuckle", 4
        },
        rewardScore = 175
    },
    [35] = {
        spawns = {
            "FI Typhlosion", 4
        },
        rewardScore = 180
    },
    [36] = {
        spawns = {
            "FI The Thousand Arms", 1
        },
        rewards = {
            {itemid = ITEMID_TOKEN, count = 6, unique = true, toDepot = true}
        },
        rewardScore = 185
    },
}

Gladiator.onStart = function(cid, arenaId)
    if (doTeleportThing(cid, Gladiator.ARENAS[arenaId].startPos)) then
        Gladiator.ARENAS[arenaId].working = true
        setPlayerFrontierIsland(cid, true)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "First round start in 15 seconds!")
        addEvent(Gladiator.onThink, 15000, cid, arenaId, 1, true)
        return true
    end
    return false
end

Gladiator.onEnd = function(cid, arenaId, reason)
    if (reason ~= Gladiator.REASON_IDS.PLAYER_OFFLINE) then
        doTeleportThing(cid, Gladiator.ARENAS[arenaId].exitPos)
        setPlayerFrontierIsland(cid, false)
        if (reason == Gladiator.REASON_IDS.PLAYER_WIN) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Congratulations! You won the Gladiator Arena!")
            doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.WIN_FRONTIER_ISLAND, 1)
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "You was defeated in the Gladiator Arena!")
        end
    end

    for k, monster in pairs(Gladiator.ARENAS[arenaId].monsters) do
        if (isCreature(monster)) then
            doRemoveCreature(monster)
        end
    end

    table.clear(Gladiator.ARENAS[arenaId].monsters)
    Gladiator.ARENAS[arenaId].monsters = {}
    Gladiator.ARENAS[arenaId].working = false
end

Gladiator.onThink = function(cid, arenaId, round, startRound)
    if (not isCreature(cid)) then
        Gladiator.onEnd(cid, arenaId, Gladiator.REASON_IDS.PLAYER_OFFLINE)
        return
    end

    if (getDistanceBetween(getCreaturePosition(cid), Gladiator.ARENAS[arenaId].startPos) > 20) then
        Gladiator.onEnd(cid, arenaId, Gladiator.REASON_IDS.PLAYER_AWAY)
        return
    end

    for k, monster in pairs(Gladiator.ARENAS[arenaId].monsters) do
        if (not isCreature(monster)) then
            Gladiator.ARENAS[arenaId].monsters[k] = nil
        end
    end

    if (#Gladiator.ARENAS[arenaId].monsters == 0) then
        if (startRound) then
            local level = getPlayerLevel(cid)
            if (level > POKEMON_LEVEL_MAX) then
                level = POKEMON_LEVEL_MAX
            end

            for i = 1, #Gladiator.ROUNDS[round].spawns, 2 do
                local count = 0
                while (count < Gladiator.ROUNDS[round].spawns[i + 1]) do
                    local pos = table.random(Gladiator.ARENAS[arenaId].spawnPos)
                    local m = doCreateMonster(Gladiator.ROUNDS[round].spawns[i], pos)
                    if (m) then
                        doSendMagicEffect(pos, EFFECT_POISON_GAS_THREE)
                        setMonsterLevel(m, level)
                        Gladiator.ARENAS[arenaId].monsters[#Gladiator.ARENAS[arenaId].monsters + 1] = m
                    else
                        log(LOG_TYPES.ERROR, "Gladiator.onThink - Can't summon monster.", getCreatureName(cid), round, Gladiator.ROUNDS[round].spawns[i])
                    end
                    count = count + 1
                end
            end
            doTeleportThing(cid, Gladiator.ARENAS[arenaId].startPos)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, string.format(__L(cid, "Round %s started!"), round))

        else
            local continue = true
            local spec = getSpectators(Gladiator.ARENAS[arenaId].startPos, 20, 20, false)
            if (spec) then
                for k, v in pairs(spec) do -- Fixing bug that sometimes is occur
                    if (isMonster(v) and not isSummon(v)) then
                        continue = false
                        break
                    end
                end
            end

            if (continue) then
                if (Gladiator.ROUNDS[round].rewards) then
                    for _, v in pairs(Gladiator.ROUNDS[round].rewards) do
                        local item = doCreateItemEx(v.itemid, v.count)
                        if (item) then
                            if (v.unique) then
                                setItemUniqueOwner(item, cid)
                            end
                            if (v.toDepot) then
                                doPlayerAddDepotItem(cid, 0, item)
                                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You received %sx %s directly into your depot."), v.count, getItemNameById(v.itemid)))
                            else
                                doPlayerAddItemEx(cid, item, false)
                                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You received %sx %s."), v.count, getItemNameById(v.itemid)))
                            end
                        else
                            log(LOG_TYPES.ERROR, "Gladiator.onThink - Can't create reward",
                                getCreatureName(cid), v.itemid, v.count, v.unique, round)
                        end
                    end
                end

                doPlayerAddHighscoreValue(cid, HIGHSCORE_IDS.GLADIATOR, Gladiator.ROUNDS[round].rewardScore)
                doPlayerAddHighscoreValue(cid, HIGHSCORE_IDS.FRONTIER_ISLAND,
                    math.ceil(Gladiator.ROUNDS[round].rewardScore / 10))

                round = round + 1
                if (Gladiator.ROUNDS[round]) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Next round start in 15 seconds!")
                    addEvent(Gladiator.onThink, 15000, cid, arenaId, round, true)
                else
                    Gladiator.onEnd(cid, arenaId, Gladiator.REASON_IDS.PLAYER_WIN)
                end
                return
            end
        end
    end

    addEvent(Gladiator.onThink, 1000, cid, arenaId, round, nil)
end

Gladiator.getFreeArena = function()
    for _, arena in pairs(Gladiator.ARENA_IDS) do
        if (not Gladiator.ARENAS[arena].working) then
            return arena
        end
    end
    return nil
end
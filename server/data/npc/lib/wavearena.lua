if (WaveArena) then
    return
end
--
local LOLLIPOP_LEVEL_ATTR = 1000
local LOLLIPOP_ITEMID = 24632
local ROUND_AMOUNT = 20
local MONSTER_INCREASE_BY_ROUND = 1
local MAX_MONSTER = 4
local FORBIDDEN_POKEMON = {"Ditto", "Aerodactyl", "Articuno", "Zapdos", "Moltres", "Mewtwo", "Mew", "Unown", "Raikou",
    "Entei", "Suicune", "Lugia", "Ho-Oh", "Celebi", "Easter Pikachu", "Easter Bulbasaur", "Easter Squirtle", "Easter Charmander",
    "Christmas Abra", "Christmas Bulbasaur", "Christmas Caterpie", "Christmas Charmander", "Christmas Diglett", "Christmas Ekans",
    "Christmas Gastly", "Christmas Geodude", "Christmas Grimer", "Christmas Machop", "Christmas Meowth", "Christmas Pidgey",
    "Christmas Pikachu", "Christmas Rattata", "Christmas Sandshrew", "Christmas Spearow", "Christmas Squirtle", "Christmas Weedle"}

WaveArena = {}
WaveArena.ARENA_IDS = {
    1, 2, 3, 4, 5, 6, 7, 8, 9
}

WaveArena.REASON_IDS = {
    PLAYER_OFFLINE = 0,
    PLAYER_WIN = 1,
    PLAYER_AWAY = 2
}

WaveArena.ARENAS = {
    [1] = {
        startPos = {x = 5174, y = 105, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5173, y = 97, z = 7}, {x = 5179, y = 98, z = 7}, {x = 5184, y = 102, z = 7},
            {x = 5183, y = 109, z = 7}, {x = 5176, y = 111, z = 7}, {x = 5170, y = 111, z = 7},
            {x = 5166, y = 108, z = 7}, {x = 5164, y = 106, z = 7}, {x = 5166, y = 100, z = 7},
            {x = 5170, y = 99, z = 7}, {x = 5177, y = 103, z = 7}, {x = 5172, y = 107, z = 7}
        },
        working = false, monsters = {}
    },
    [2] = {
        startPos = {x = 5176, y = 164, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5175, y = 157, z = 7}, {x = 5180, y = 157, z = 7}, {x = 5186, y = 161, z = 7},
            {x = 5185, y = 169, z = 7}, {x = 5180, y = 171, z = 7}, {x = 5175, y = 170, z = 7},
            {x = 5169, y = 168, z = 7}, {x = 5168, y = 164, z = 7}, {x = 5171, y = 158, z = 7},
            {x = 5174, y = 155, z = 7}, {x = 5181, y = 161, z = 7}, {x = 5175, y = 166, z = 7}
        },
        working = false, monsters = {}
    },
    [3] = {
        startPos = {x = 5177, y = 218, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5177, y = 212, z = 7}, {x = 5185, y = 213, z = 7}, {x = 5187, y = 222, z = 7},
            {x = 5178, y = 225, z = 7}, {x = 5170, y = 224, z = 7}, {x = 5169, y = 217, z = 7},
            {x = 5172, y = 212, z = 7}, {x = 5180, y = 213, z = 7}, {x = 5187, y = 216, z = 7},
            {x = 5181, y = 224, z = 7}, {x = 5172, y = 221, z = 7}, {x = 5177, y = 213, z = 7}
        },
        working = false, monsters = {}
    },
    [4] = {
        startPos = {x = 5242, y = 104, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5241, y = 96, z = 7}, {x = 5251, y = 102, z = 7}, {x = 5248, y = 113, z = 7},
            {x = 5237, y = 113, z = 7}, {x = 5233, y = 107, z = 7}, {x = 5234, y = 99, z = 7},
            {x = 5240, y = 96, z = 7}, {x = 5249, y = 101, z = 7}, {x = 5249, y = 110, z = 7},
            {x = 5236, y = 110, z = 7}, {x = 5237, y = 102, z = 7}, {x = 5243, y = 100, z = 7}
        },
        working = false, monsters = {}
    },
    [5] = {
        startPos = {x = 5246, y = 163, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5244, y = 156, z = 7}, {x = 5255, y = 161, z = 7}, {x = 5251, y = 171, z = 7},
            {x = 5241, y = 171, z = 7}, {x = 5238, y = 165, z = 7}, {x = 5240, y = 159, z = 7},
            {x = 5244, y = 156, z = 7}, {x = 5252, y = 163, z = 7}, {x = 5250, y = 170, z = 7},
            {x = 5241, y = 167, z = 7}, {x = 5243, y = 159, z = 7}, {x = 5248, y = 167, z = 7}
        },
        working = false, monsters = {}
    },
    [6] = {
        startPos = {x = 5245, y = 218, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5245, y = 211, z = 7}, {x = 5254, y = 219, z = 7}, {x = 5245, y = 227, z = 7},
            {x = 5236, y = 221, z = 7}, {x = 5238, y = 213, z = 7}, {x = 5244, y = 211, z = 7},
            {x = 5251, y = 215, z = 7}, {x = 5249, y = 224, z = 7}, {x = 5240, y = 222, z = 7},
            {x = 5242, y = 216, z = 7}, {x = 5249, y = 216, z = 7}, {x = 5246, y = 218, z = 7}
        },
        working = false, monsters = {}
    },
    [7] = {
        startPos = {x = 5313, y = 105, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5313, y = 99, z = 7}, {x = 5320, y = 107, z = 7}, {x = 5312, y = 111, z = 7},
            {x = 5304, y = 106, z = 7}, {x = 5308, y = 100, z = 7}, {x = 5317, y = 101, z = 7},
            {x = 5317, y = 110, z = 7}, {x = 5308, y = 109, z = 7}, {x = 5309, y = 100, z = 7},
            {x = 5314, y = 101, z = 7}, {x = 5315, y = 107, z = 7}, {x = 5309, y = 105, z = 7}
        },
        working = false, monsters = {}
    },
    [8] = {
        startPos = {x = 5316, y = 164, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5316, y = 157, z = 7}, {x = 5323, y = 165, z = 7}, {x = 5316, y = 171, z = 7},
            {x = 5308, y = 163, z = 7}, {x = 5311, y = 157, z = 7}, {x = 5320, y = 159, z = 7},
            {x = 5320, y = 168, z = 7}, {x = 5310, y = 167, z = 7}, {x = 5311, y = 160, z = 7},
            {x = 5317, y = 158, z = 7}, {x = 5318, y = 165, z = 7}, {x = 5312, y = 165, z = 7}
        },
        working = false, monsters = {}
    },
    [9] = {
        startPos = {x = 5316, y = 219, z = 7}, exitPos = {x = 4721, y = 139, z = 7},
        spawnPos = {
            {x = 5316, y = 212, z = 7}, {x = 5323, y = 219, z = 7}, {x = 5316, y = 226, z = 7},
            {x = 5308, y = 218, z = 7}, {x = 5311, y = 213, z = 7}, {x = 5321, y = 213, z = 7},
            {x = 5321, y = 224, z = 7}, {x = 5310, y = 222, z = 7}, {x = 5311, y = 214, z = 7},
            {x = 5315, y = 215, z = 7}, {x = 5318, y = 220, z = 7}, {x = 5312, y = 221, z = 7}
        },
        working = false, monsters = {}
    },
}

local POKEMON_LIST = table.deepcopy(pokemonNamesWithoutShiny)
for i = #POKEMON_LIST, 1, -1 do
    local v = POKEMON_LIST[i]
    if ((table.find(FORBIDDEN_POKEMON, v)) or (getPokemonPriorEvolution(v))) then
        POKEMON_LIST[i] = nil
    end
end
FORBIDDEN_POKEMON = nil

local function doPokemonAttackPlayer(cid, player)
    for k, v in pairs(getCreatureSummons(player)) do
        if (doMonsterSetTarget(cid, v)) then
            return
        end
    end
    doMonsterSetTarget(cid, player)
end

WaveArena.onStart = function(cid, arenaId)
    local ret = true

    WaveArena.ARENAS[arenaId].working = true
    setPlayerBlockLogout(cid, true)
    if (not doTeleportThing(cid, WaveArena.ARENAS[arenaId].startPos)) then
        ret = false
    end
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "First round start in 15 seconds!")
    addEvent(WaveArena.onThink, 15000, cid, arenaId, 1, true)

    return ret
end

WaveArena.onEnd = function(cid, arenaId, reason)
    if (isCreature(cid)) then
        if (doTeleportThing(cid, WaveArena.ARENAS[arenaId].exitPos)) then
            setPlayerBlockLogout(cid, false)
            setPlayerColosseumArenaPaid(cid, false)
            if (reason == WaveArena.REASON_IDS.PLAYER_WIN) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Congratulations! You won the Colosseum Arena!")
                -- doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.WIN_FRONTIER_ISLAND, 1) -- TODO
                doDatalogColosseumArena(os.time(), getPlayerAccountId(cid))
                doPlayerSafeAddItem(cid, LOLLIPOP_ITEMID, 1, true, true, true, function(item) doItemSetAttribute(item, LOLLIPOP_LEVEL_ATTR, getPlayerLevel(cid)) end)
            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "You was defeated in the Colosseum Arena!")
            end
        end
    end

    for k, monster in pairs(WaveArena.ARENAS[arenaId].monsters) do
        if (isCreature(monster)) then
            doRemoveCreature(monster)
        end
    end

    table.clear(WaveArena.ARENAS[arenaId].monsters)
    WaveArena.ARENAS[arenaId].monsters = {}
    WaveArena.ARENAS[arenaId].working = false
end

WaveArena.onThink = function(cid, arenaId, round, startRound)
    if (not isCreature(cid)) then
        WaveArena.onEnd(cid, arenaId, WaveArena.REASON_IDS.PLAYER_OFFLINE)
        return
    end

    if (getDistanceBetween(getCreaturePosition(cid), WaveArena.ARENAS[arenaId].startPos) > 20) then
        WaveArena.onEnd(cid, arenaId, WaveArena.REASON_IDS.PLAYER_AWAY)
        return
    end

    for k, monster in pairs(WaveArena.ARENAS[arenaId].monsters) do
        if (not isCreature(monster)) then
            WaveArena.ARENAS[arenaId].monsters[k] = nil
        end
    end

    if (#WaveArena.ARENAS[arenaId].monsters == 0) then
        if (startRound) then
            local diffLevel = 15
            local level = getPlayerLevel(cid) - diffLevel
            if (level > (POKEMON_LEVEL_MAX - diffLevel)) then
                level = (POKEMON_LEVEL_MAX - diffLevel)
            end

            local tmpPokemonList = table.deepcopy(POKEMON_LIST)
            for i = table.maxn(tmpPokemonList), 1, -1 do
                local v = tmpPokemonList[i]
                if (v) then
                    if (getMonsterInfo(v, false).minLevel > level) then
                        tmpPokemonList[i] = nil
                    else
                        local evolutions = getPokemonEvolutions(v)
                        while (evolutions and #evolutions > 0) do
                            local tmpEvolutions = evolutions
                            evolutions = nil

                            for _k, _v in ipairs(tmpEvolutions) do
                                if (level >= _v.requiredLevel) then
                                    tmpPokemonList[i] = _v.name
                                    evolutions = getPokemonEvolutions(_v.name)
                                    break
                                end
                            end
                        end
                    end
                end
            end

            local randomPokemon = table.randFrom(tmpPokemonList)
            local spawns = math.floor(MONSTER_INCREASE_BY_ROUND * round)
            if (spawns > MAX_MONSTER) then
                spawns = MAX_MONSTER
            end

            for i = 1, spawns do
                local pos = table.random(WaveArena.ARENAS[arenaId].spawnPos)
                local m = doCreateMonster(randomPokemon, pos)
                if (m) then
                    registerCreatureEvent(m, "onDeath_Remove")
                    doSendMagicEffect(pos, EFFECT_POISON_GAS_THREE)
                    setMonsterLevel(m, level)
                    WaveArena.ARENAS[arenaId].monsters[#WaveArena.ARENAS[arenaId].monsters + 1] = m
                    doPokemonAttackPlayer(m, cid)
                end
            end

            doTeleportThing(cid, {x = WaveArena.ARENAS[arenaId].startPos.x,
                y = WaveArena.ARENAS[arenaId].startPos.y,
                z = WaveArena.ARENAS[arenaId].startPos.z})
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, string.format(__L(cid, "Round %s started!"), round))

        else
            local continue = true
            local spec = getSpectators(WaveArena.ARENAS[arenaId].startPos, 20, 20, false)
            if (spec) then
                for k, v in pairs(spec) do -- Fixing bug that sometimes is occur
                    if (isMonster(v) and not isSummon(v)) then
                        continue = false
                        break
                    end
                end
            end

            if (continue) then
                round = round + 1
                if (round <= ROUND_AMOUNT) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Next round start in 15 seconds!")
                    addEvent(WaveArena.onThink, 15000, cid, arenaId, round, true)
                else
                    WaveArena.onEnd(cid, arenaId, WaveArena.REASON_IDS.PLAYER_WIN)
                end
                return
            end
        end
    end

    addEvent(WaveArena.onThink, 1000, cid, arenaId, round, nil)
end

WaveArena.getFreeArena = function()
    for _, arena in pairs(WaveArena.ARENA_IDS) do
        if (not WaveArena.ARENAS[arena].working) then
            return arena
        end
    end
    return nil
end
local STARTUP = {}
STARTUP[#STARTUP + 1] = {
    msg = "Cleaning players online status...",
    action = function()
        db.executeQuery("UPDATE `players` SET `online` = 0 WHERE `world_id` = " .. getConfigValue('worldId')
                .. ";")
    end
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading PvP Arenas...",
    action = startPvpArenas
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Caught Highscores...",
    action = doCaughtHighscoreCheck
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Tournament Highscores...",
    action = doTournamentHighscoreCheck
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Berry Trees...",
    action = startBerryTrees
}

STARTUP[#STARTUP + 1] = {
    msg = "Cleaning Mastery Dungeons...",
    action = function()
        for i, dungeon in pairs(MASTERY_DUNGEON_IDS) do
            setGlobalStorageValue(getMasteryDungeonGlobalStorageUser(dungeon), 0)
            setGlobalStorageValue(getMasteryDungeonGlobalStorageCleanEvent(dungeon), 0)
        end
    end
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Bosses...",
    action = doBossStart
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Highscores...",
    action = doHighscoreTextUpdate
}

STARTUP[#STARTUP + 1] = { -- Quest Stuff
    action = function()
        doCreateItem(18170, 1, table.random({{x = 3932, y = 1953, z = 1}, {x = 3484, y = 1611, z = 5},
            {x = 2826, y = 1803, z = 3}})) -- Wampi Tree

        addEvent(function() doDecayItem(doCreateItem(18180, 1, {x = 3940, y = 432, z = 7})) end,
            (getRandom(3, 18) * 60 * 60) * 1000) -- Juanito Letter #2

        addEvent(doCreateNpc, (getRandom(15, 30) * 60 * 60) * 1000, "Crystal Onix",
            {x = 3035, y = 2504, z = 12})

        local npcs = {
            {"Raymund Headley", {x = 3037, y = 1692, z = 7}},
            {"Charlie Anselm", {x = 3035, y = 1698, z = 7}},
            {"Nolan Peter", {x = 3040, y = 1699, z = 7}},
            {"Sanford Fulk", {x = 3040, y = 1699, z = 6}},
            {"Paulina Megan", {x = 3035, y = 1693, z = 6}},
            {"Regena Loraine", {x = 3042, y = 1692, z = 6}},
            {"Hettie Sibyl", {x = 3037, y = 1692, z = 8}},
            {"Harmonie Rainbow", {x = 3041, y = 1697, z = 5}},
            {"Flossie Cherise", {x = 3032, y = 1702, z = 7}},
            {"Joetta Mabella", {x = 3038, y = 1694, z = 8}},
        }

        for i = 1, 5 do
            table.remove(npcs, getRandom(1, #npcs))
        end

        for _, npc in pairs(npcs) do
            doCreateNpc(npc[1], npc[2])
        end
        npcs = table.clear(npcs)

        local createWhirlpool
        createWhirlpool = function()
            doCreateItem(8632, 1, {x = 3581, y = 2748, z = 7})

            addEvent(function() -- Aerodactyl Whirlpool Remove
                local item = getTileItemById({x = 3581, y = 2748, z = 7}, 8632)
                if (isItem(item)) then
                    doRemoveItem(item.uid)
                end

                addEvent(createWhirlpool, 3 * 60 * 60 * 1000)

            end, 1 * 60 * 60 * 1000)
        end

        createWhirlpool()

        -- Good oxygen mask quest - black shell spawn
        local pos = {
            {x = 3819, y = 578, z = 8},
            {x = 3786, y = 576, z = 9},
            {x = 3719, y = 605, z = 8},
            {x = 3836, y = 629, z = 9},
            {x = 3828, y = 592, z = 9},
        }
        doCreateItem(18877, 1, table.random(pos)) -- black shell
        pos = table.clear(pos)

        -- Ski quest - ice yolk stone spawn
        local pos = {
            {x = 3731, y = 1097, z = 8},
            {x = 3748, y = 1076, z = 8},
            {x = 3758, y = 1064, z = 9},
            {x = 3759, y = 1064, z = 9},
            {x = 3684, y = 1065, z = 9},
        }
        doCreateItem(18879, 1, table.random(pos)) -- ice yolk stone
        pos = table.clear(pos)

        -- Ski quest - piece of cloth spawn
        local pos = {
            {x = 3661, y = 1124, z = 8},
            {x = 3664, y = 1122, z = 8},
            {x = 3665, y = 1119, z = 8},
            {x = 3668, y = 1124, z = 8},
            {x = 3667, y = 1129, z = 8},
        }
        doCreateItem(18882, 1, table.random(pos)) -- immoble piece of cloth
        pos = table.clear(pos)

        -- Kanto Main #3 - Bill signal device
        local pos = {
            {x = 3990, y = 566, z = 7},
            {x = 4058, y = 635, z = 7},
            {x = 3880, y = 505, z = 3}
        }

        doCreateItem(23557, 1, table.random(pos))
        pos = table.clear(pos)

        -- PokeTrader
        local SPAWN_POSITIONS = {
            {x = 3823, y = 835, z = 7}, -- Fuchsia
            {x = 3319, y = 1021, z = 7}, -- Cinnabar
            {x = 3321, y = 554, z = 7}, -- Viridian
            {x = 3358, y = 294, z = 7}, -- Pewter
            {x = 3916, y = 234, z = 6}, -- Cerulean
            {x = 3635, y = 453, z = 7}, -- Celadon
            {x = 3885, y = 495, z = 7}, -- Saffron
            {x = 3928, y = 642, z = 7}, -- Vermilion
            {x = 4210, y = 526, z = 7} -- Lavender
        }
        doCreateNpc("Tiger Kelsey", table.random(SPAWN_POSITIONS))
        SPAWN_POSITIONS = table.clear(SPAWN_POSITIONS)

        EliteFour.setChallengingPlayer(-1)
        AnniversaryEvent.doResetState() -- remove after event end
        
        setGlobalStorageValue(GLOBAL_STORAGES.SERVER_START_TIME, os.time())
    end
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Ball Pillars...",
    action = function()
        local r = db.getResult("SELECT `positionx`, `positiony`, `positionz`, `attributes`, `ball_id`, `creature_name`, `creature_sex` FROM `ball_pillars` WHERE `world_id` = ".. getConfigValue("worldId") ..";")
        if (r:getID() ~= -1) then
            repeat
                local pos = {x = r:getDataInt("positionx"), y = r:getDataInt("positiony"),
                    z = r:getDataInt("positionz")}

                if (getTileItemById(pos, 18649) and isItem(getTileItemById(pos, 18649))) then
                    local ball = doCreateItemEx(r:getDataInt("ball_id"), 1)
                    if (ball) then
                        doItemLoadAttributes(ball, "attributes", r)

                        local npc = doCreateNpc(table.random({"Pillar Model", "Pillar Model Slow", "Pillar Model Fast"}), pos)
                        
                        if (npc) then
                            pos = getPositionAdjacent(npc, pos)
                            if (pos and getHouseFromPos(pos)) then -- Just to spawn at another position, diff from the Pillar
                                npc = doCreateNpc(table.random({"Pillar Model", "Pillar Model Slow", "Pillar Model Fast"}), pos)
                            end
                        end
                        
                        if (npc) then
                            setNpcHouser(npc, true)
                            setCreatureNickname(npc, r:getDataString("creature_name"))

                            local outfit = getBallCurrentAddon(ball)
                            if (outfit) then
                                doSetCreatureOutfit(npc, outfit, -1)
                            else
                                doCreatureChangeOutfit(npc, getMonsterInfo(getBallPokemonName(ball)).outfit)
                            end

                            local sex = r:getDataInt("creature_sex")
                            if (sex == POKEMON_SEX_MALE) then
                                doCreatureSetSkullType(npc, SKULL_BLACK)
                            elseif (sex == POKEMON_SEX_FEMALE) then
                                doCreatureSetSkullType(npc, SKULL_RED)
                            else
                                doCreatureSetSkullType(npc, SKULL_YELLOW)
                            end
                            
                        else
                            log(LOG_TYPES.ERROR, "onStartup::LoadBallPillars - Can't create NPC.", pos)
                        end
                    else
                        log(LOG_TYPES.ERROR, "onStartup::LoadBallPillars - Can't create ball.", pos)
                    end

                    if (ball) then
                        doRemoveItem(ball)
                    end

                else
                    db.executeQuery("DELETE FROM `ball_pillars` WHERE positionx='".. pos.x .. "' and positiony='" ..
                            pos.y .."' and positionz='".. pos.z .."' and world_id='" .. getConfigValue("worldId") .. "';")
                end
            until not r:next()
            r:free()
        end
    end
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Citizens...",
    action = doStartCitizens
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading SupriseBox...",
    action = SurpriseBox.onGameStart
}

STARTUP[#STARTUP + 1] = {
    msg = "Loading Ranks...",
    action = function()
        if (type(getConfigValue("updateHighscores")) == "boolean" and not getConfigValue("updateHighscores")) then
            log(LOG_TYPES.WARNING, "Ranks Update - updateHighscores is off.")
            return
        end

        db.executeQuery("CALL `update_rank`();")
    end
}

function onStartup()
    for _, cmd in pairs(STARTUP) do
        if (cmd.msg) then
            print(">> " .. cmd.msg)
            local x = os.clock()
            cmd.action()
            print(string.format("> Done in %.2f seconds", os.clock() - x))
        else
            cmd.action()
        end
    end

    table.clear(STARTUP)
    STARTUP = nil

	print(">> All done on ".. os.date("%a %b %d %X %Y", os.time()))
    return true
end

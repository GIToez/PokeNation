if (EliteFour) then
    return
end

EliteFour = {}

-- Constants
local FORBIDDEN_POTION_ITEM_IDS = {12244, 12245, 12246, 12247, 12248, 12250} -- todo
local ENTRANCE_POSITION = {x = 3115, y = 585, z = 7}
local ICE_SLIP_SPEED = 100 -- ms
local REQUIRED_LEVEL = 95
local ELITE_FOUR_CHAMPION_NPC_NAME = "Elite Four Champion"
local ELITE_FOUR_CHAMPION_POSITION = {x = 3112, y = 382, z = 1 }
local ELITE_FOUR_TROPHY_ITEMID = 20270

EliteFour.getChallengingPlayer = function()
    local v = tonumber(getGlobalStorageValue(GLOBAL_STORAGES.ELITE_FOUR_CHALLENGER))
    if (v and v > -1) then
        return getPlayerByGUID(v)
    end
    return false
end

EliteFour.setChallengingPlayer = function(v)
    setGlobalStorageValue(GLOBAL_STORAGES.ELITE_FOUR_CHALLENGER, (v ~= -1 and getPlayerGUID(v) or v))
end

EliteFour.doIceSlip = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    doCreatureSetNoMove(cid, true)
    local slipMe
    slipMe = function(cid, direction, lastPos)
        local nextPos = getPositionByDirection(lastPos, direction, 1)
        if (isWalkable(cid, nextPos)) then
            doSendDistanceShoot(lastPos, nextPos, PROJECTILE_GRAVEL)
            doTeleportThing(cid, nextPos, true)
            addEvent(slipMe, ICE_SLIP_SPEED, cid, direction, nextPos)
        else
            doCreatureSetNoMove(cid, false)
        end
    end

    slipMe(cid, getDirectionTo(lastPosition, position), position)
end

EliteFour.doCheckPlayerEntrance = function(cid)
    for _, badge in pairs({BADGES.BOULDER, BADGES.CASCADE, BADGES.THUNDER, BADGES.RAINBOW, BADGES.SOUL,
        BADGES.MARSH, BADGES.VOLCANO, BADGES.EARTH}) do
        if (getPlayerItemCount(cid, badge.newItemId) == 0) then
            return 'You must collect Kanto badges first.'
        end
    end

    if (EliteFour.getChallengingPlayer() and isPlayer(EliteFour.getChallengingPlayer())) then
        return 'Someone is challenging the Elite Four right now, please try again later.'
    end

    for _, itemId in pairs(FORBIDDEN_POTION_ITEM_IDS) do
        if (getPlayerItemCount(cid, itemId) >= 1) then
            return 'You cannot challenge while you are carrying any type of potion.'
        end
    end

    if (#getPlayerAllBallsWithPokemon(cid) < PLAYER_BALL_MAX) then
        return string.format(__L(cid, 'You need at least %s Pokemon to challenge.'), PLAYER_BALL_MAX)
    end

    if (getPlayerLevel(cid) < REQUIRED_LEVEL) then
        return string.format(__L(cid, 'You need at least level %s to challenge.'), REQUIRED_LEVEL)
    end

    local interval = os.time() - getPlayerLastEliteFourTry(cid)
    local enterInterval = 23 * 60 * 60
    if (interval < enterInterval) then
        return string.format(__L(cid, 'You have visited the Elite Four recently, you must wait %s to enter again.'),
            table.concat(string.timediff(enterInterval - interval, cid)))
    end

    if (getPlayerDefeatedNPC(cid, 9696)) then -- Champion battle storage
        return 'You already won this challenge.'
    end
    
    if (isPokemonOnline(cid) or getPlayerMounted(cid)) then
        return 'You can not do it while you have a Pokemon out of the ball.'
    end

    return true
end

EliteFour.doPlayerEnter = function(cid)
    doTeleportThing(cid, ENTRANCE_POSITION)

    EliteFour.PuzzleRock.doVariate()
    EliteFour.MazeGame.doVariate()
    setPlayerBlockLogout(cid, true)
    setPlayerLastEliteFourTry(cid, os.time())
    EliteFour.setChallengingPlayer(cid)
    registerCreatureEvent(cid, 'onLogout_EliteFour')
end

EliteFour.MEMBER_IDS = {
    LORELEI = 1,
    BRUNO = 2,
    AGATHA = 3,
    LANCE = 4,
    CHAMPION = 5,
}

EliteFour.MEMBERS = {
    [EliteFour.MEMBER_IDS.LORELEI] = {
        greetings = {"Welcome to POKEMON LEAGUE!", "I am LORELEI of the ELITE FOUR!", "No one can best me when it comes to icy POKEMON!", "Freezing moves are powerful!", "Your POKEMON will be at my mercy when they are frozen solid! Hahaha!", "Are you ready?"},
        appearPosition = {x = 3112, y = 382, z = 5},
        npcName = "Lorelei"
    },
    [EliteFour.MEMBER_IDS.BRUNO] = {
        greetings = {"I am BRUNO of the ELITE FOUR!", "Through rigorous training, people and POKEMON can become stronger!", "I've weight trained with my POKEMON!", "|PLAYERNAME|! We will grind you down with our superior power! Hoo hah!"},
        appearPosition = {x = 3112, y = 382, z = 4},
        npcName = "Bruno"
    },
    [EliteFour.MEMBER_IDS.AGATHA] = {
        greetings = {"I am AGATHA of the ELITE FOUR!", "OAK's taken a lot of interest in you, child!", "That old duff was once tough and handsome! That was decades ago!", "Now he just wants to fiddle with his POKEDEX! He's wrong! POKEMON are for fighting!", "|PLAYERNAME|! I'll show you how a real trainer fights!"},
        appearPosition = {x = 3112, y = 382, z = 3},
        npcName = "Agatha"
    },
    [EliteFour.MEMBER_IDS.LANCE] = {
        greetings = {"Ah! I heard about you |PLAYERNAME|!", "I lead the ELITE FOUR! You can call me LANCE the dragon trainer!", "You know that dragons are mythical POKEMON!", "They're hard to catch and raise, but their powers are superior! They're virtually indestructible!", "Well, are you ready to lose? Your LEAGUE challenge ends with me, |PLAYERNAME|!"},
        appearPosition = {x = 3112, y = 382, z = 2},
        npcName = "Lance"
    },
    [EliteFour.MEMBER_IDS.CHAMPION] = {
        greetings = {"Oh! Finally! Let's battle!"},
        appearPosition = {x = 3112, y = 382, z = 2},
        npcName = "Elite Four Champion"
    }
}

EliteFour.doMemberTalk = function(cid, npc, member, npcBattle)
    local doTalk
    doTalk = function(step)
        if (EliteFour.MEMBERS[member].greetings[step]) then
            local msg = string.gsub(__L(cid, EliteFour.MEMBERS[member].greetings[step]), '|PLAYERNAME|', getCreatureName(cid))
            doCreatureSay(npc, msg, TALKTYPE_SAY)
            addEvent(doTalk, 5000, step + 1)
        elseif (not isPokemonOnline(cid)) then
            doCreatureSay(npc, "Call your Pokemon!", TALKTYPE_SAY)
            addEvent(doTalk, 5000, step)
        else
            npcBattle:doForceBattleStart(npc, cid)
        end
    end
    doTalk(1)
end

EliteFour.doMemberAppear = function(cid, member)
    doSendMagicEffect(EliteFour.MEMBERS[member].appearPosition, EFFECT_TELEPORT_DOWN)
    doCreateNpc(EliteFour.MEMBERS[member].npcName, EliteFour.MEMBERS[member].appearPosition, false)
    doCreatureSetNoMove(cid, true)
end

EliteFour.onPlayerLoose = function(cid)
    EliteFour.doRemovePlayer(cid)
end

EliteFour.getLastChampion = function()
    local r = db.getResult(string.concat("SELECT `player_id`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons` FROM `elite_four_champions` ORDER BY `date` DESC LIMIT 1;"))
    if (r:getID() ~= -1) then
        local championGuid = r:getDataInt('player_id')
        local champion = {
            name = getPlayerNameByGUID(championGuid), outfit = {lookBody = r:getDataInt('lookbody'),
                lookFeet = r:getDataInt('lookfeet'), lookHead = r:getDataInt('lookhead'), lookLegs = r:getDataInt('looklegs'),
                lookType = r:getDataInt('looktype'), lookAddons = r:getDataInt('lookaddons')},
            pokemon = {}
            }
        r:free()

        local dbResult = db.getResult("SELECT `name`, `level`, `nickname`, `sex`, `extra_points`, `special_ability`, `moveset` FROM `elite_four_champion_pokemons` WHERE `player_id` = '".. championGuid .."';")
        if dbResult:getID() == -1 then
            log(LOG_TYPES.ERROR, "EliteFour.getLastChampion - Cant find champion Pokemons.", championGuid)
        end
        repeat
            table.insert(champion.pokemon, {name = dbResult:getDataString('name'), level = dbResult:getDataInt('level'),
                nickname = dbResult:getDataString('nickname'), sex = dbResult:getDataInt('sex'),
                extraPoints = dbResult:getDataInt('extra_points'), specialAbility = dbResult:getDataInt('special_ability'),
                moveset = doGeneratePokemonMovesetFromString(dbResult:getDataString('moveset'))})
        until not dbResult:next()
        dbResult:free()

        return champion
    end
    return {
        name = "Joey Knock", outfit = {lookBody = 100, lookFeet = 100, lookHead = 100, lookLegs = 100, lookType = 612,
        lookAddons = 0},
        pokemon = {
            {
                name = "Charizard", level = 100, nickname = nil, sex = POKEMON_SEX_FEMALE, extraPoints = 109,
                specialAbility = POKEMON_SPECIAL_ABILITY_IDS.BLAZE,
                moveset = getPokemonDefaultSkills("Charizard")
            },
            {
                name = "Gyarados", level = 100, nickname = nil, sex = POKEMON_SEX_MALE, extraPoints = 109,
                specialAbility = POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE,
                moveset = getPokemonDefaultSkills("Gyarados")
            },
            {
                name = "Exeggutor", level = 100, nickname = nil, sex = POKEMON_SEX_FEMALE, extraPoints = 109,
                specialAbility = POKEMON_SPECIAL_ABILITY_IDS.CHLOROPHYLL,
                moveset = getPokemonDefaultSkills("Exeggutor")
            },
            {
                name = "Rhydon", level = 100, nickname = nil, sex = POKEMON_SEX_MALE, extraPoints = 109,
                specialAbility = POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD,
                moveset = getPokemonDefaultSkills("Rhydon")
            },
            {
                name = "Alakazam", level = 100, nickname = nil, sex = POKEMON_SEX_FEMALE, extraPoints = 109,
                specialAbility = POKEMON_SPECIAL_ABILITY_IDS.SYNCHRONIZE,
                moveset = getPokemonDefaultSkills("Alakazam")
            },
            {
                name = "Pidgeot", level = 100, nickname = nil, sex = POKEMON_SEX_MALE, extraPoints = 109,
                specialAbility = POKEMON_SPECIAL_ABILITY_IDS.TANGLED_FEET,
                moveset = getPokemonDefaultSkills("Pidgeot")
            }
        }
    }
end

EliteFour.doChampionAppear = function()
    local npc = doCreateNpc(ELITE_FOUR_CHAMPION_NPC_NAME, ELITE_FOUR_CHAMPION_POSITION, false)
    local champion = EliteFour.getLastChampion()

    doCreatureChangeOutfit(npc, champion.outfit)
    setCreatureNickname(npc, champion.name)
    -- summon a npc that represents the last champion
end

EliteFour.getChampionPokemonTeam = function()
    local champ = EliteFour.getLastChampion()
    local ret = {}
    for _, pokemon in pairs(champ.pokemon) do
        ret[#ret + 1] = pokemon.name
    end
    return ret
end

EliteFour.getChampionPokemonTeamMovesets = function()
    local champ = EliteFour.getLastChampion()
    local ret = {}
    for i, pokemon in pairs(champ.pokemon) do
        ret[i] = pokemon.moveset
    end
    return ret
end

EliteFour.doRegisterChampion = function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.ELITE_FOUR)
    doPlayerSafeAddItem(cid, ELITE_FOUR_TROPHY_ITEMID, 1, true, true, true, function(uid) doItemSetSpecialDescription(uid, string.format("Pokemon League Champion - %s\n%s", getCreatureName(cid), os.date("%a %b %d %X %Y", os.time()))) end)
    doBroadcastMessage(string.format("NEWEST Pokemon League Champion: %s!", getCreatureName(cid)))

    local outfit = getCreatureOutfit(cid)
    local query = string.concat("INSERT INTO `elite_four_champions` (`player_id`, `date`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`) VALUES('",
        getPlayerGUID(cid), "', '", os.time(), "', '", outfit.lookBody, "', '", outfit.lookFeet, "', '", outfit.lookHead,
        "', '", outfit.lookLegs, "', '", outfit.lookType, "', '", outfit.lookAddons, "');")

    for _, ball in pairs(getPlayerAllBallsWithPokemon(cid)) do
        local pokemonName = getBallPokemonName(ball.uid)
        if (pokemonName == 'Ditto') then -- If the champion holds a Ditto, let's assume to the first transformation option (yeah, isnt very nice)
            local memory = getBallTransformMemory(ball.uid, 1)
            if (memory) then
                pokemonName = memory
            end
        end

        local subQuery = string.concat("INSERT INTO `elite_four_champion_pokemons` (`player_id`, `name`, `level`, `nickname`, `sex`, `extra_points`, `special_ability`, `moveset`) VALUES('",
            getPlayerGUID(cid), "', '", pokemonName, "', '", getBallPokemonLevel(ball.uid), "', '", getBallPokemonNickname(ball.uid), "', '", getBallPokemonSex(ball.uid), "', '", getBallPokemonExtraPoints(ball.uid),
            "', '", getBallPokemonSpecialAbility(ball.uid), "', '", doGeneratePokemonMoveset(ball.uid, pokemonName), "');")

        if (not db.executeQuery(subQuery)) then
            log(LOG_TYPES.ERROR, "doRegisterChampion - Can't query.", getCreatureName(cid), subQuery)
        end
    end

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doRegisterChampion - Can't query.", getCreatureName(cid), query)
        return false
    end

    return true
end

EliteFour.doRemovePlayer = function(cid)
    doTeleportThing(cid, {x = 3115, y = 591, z = 7})
    setPlayerBlockLogout(cid, false)
    EliteFour.setChallengingPlayer(-1)
end

-- [REGION START] Snake Game
EliteFour.SnakeGame = {}

EliteFour.SnakeGame.ARENAS = {
    [1] = {
        startPosition = {x = 5258, y = 600, z = 7},
        candyPositions = {{x = 5255, y = 598, z = 7}, {x = 5258, y = 599, z = 7}, {x = 5261, y = 598, z = 7}, {x = 5256, y = 600, z = 7}, {x = 5259, y = 601, z = 7}, {x = 5255, y = 603, z = 7}, {x = 5260, y = 603, z = 7}},
        exitPosition = {x = 5252, y = 601, z = 7}
    },
    [2] = {
        startPosition = {x = 5250, y = 619, z = 7},
        candyPositions = {{x = 5248, y = 618, z = 7}, {x = 5251, y = 618, z = 7}, {x = 5248, y = 620, z = 7}, {x = 5250, y = 622, z = 7}, {x = 5252, y = 620, z = 7}, {x = 5249, y = 620, z = 7}},
        exitPosition = {x = 5250, y = 624, z = 7}
    },
    [3] = {
        startPosition = {x = 5247, y = 636, z = 7},
        candyPositions = {{x = 5245, y = 634, z = 7}, {x = 5248, y = 634, z = 7}, {x = 5245, y = 636, z = 7}, {x = 5248, y = 636, z = 7}, {x = 5245, y = 638, z = 7}, {x = 5249, y = 638, z = 7}},
        exitPosition = {x = 5247, y = 641, z = 7}
    },
    [4] = {
        startPosition = {x = 5247, y = 658, z = 7},
        candyPositions = {{x = 5243, y = 654, z = 7}, {x = 5246, y = 654, z = 7}, {x = 5250, y = 654, z = 7}, {x = 5244, y = 656, z = 7}, {x = 5247, y = 656, z = 7}, {x = 5250, y = 656, z = 7}, {x = 5244, y = 659, z = 7}, {x = 5247, y = 659, z = 7}, {x = 5250, y = 659, z = 7}, {x = 5244, y = 661, z = 7}, {x = 5249, y = 661, z = 7}},
        exitPosition = {x = 5247, y = 664, z = 7}
    },
    [5] = {
        startPosition = {x = 5264, y = 663, z = 7},
        candyPositions = {{x = 5261, y = 660, z = 7}, {x = 5264, y = 660, z = 7}, {x = 5267, y = 660, z = 7}, {x = 5261, y = 662, z = 7}, {x = 5266, y = 662, z = 7}, {x = 5262, y = 664, z = 7}, {x = 5267, y = 664, z = 7}, {x = 5261, y = 666, z = 7}, {x = 5267, y = 666, z = 7}},
        exitPosition = {x = 5270, y = 664, z = 7}
    },
    [6] = {
        startPosition = {x = 5294, y = 657, z = 7},
        candyPositions = {{x = 5291, y = 655, z = 7}, {x = 5294, y = 655, z = 7}, {x = 5296, y = 655, z = 7}, {x = 5292, y = 657, z = 7}, {x = 5296, y = 657, z = 7}, {x = 5294, y = 659, z = 7}},
        exitPosition = {x = 5289, y = 656, z = 7}
    },
    [7] = {
        startPosition = {x = 5304, y = 644, z = 7},
        candyPositions = {{x = 5300, y = 641, z = 7}, {x = 5304, y = 641, z = 7}, {x = 5307, y = 641, z = 7}, {x = 5300, y = 643, z = 7}, {x = 5306, y = 643, z = 7}, {x = 5301, y = 645, z = 7}, {x = 5305, y = 645, z = 7}, {x = 5307, y = 645, z = 7}, {x = 5300, y = 648, z = 7}, {x = 5304, y = 649, z = 7}, {x = 5308, y = 648, z = 7}},
        exitPosition = {x = 5303, y = 651, z = 7}
    },
    [8] = {
        startPosition = {x = 5302, y = 624, z = 7},
        candyPositions = {{x = 5299, y = 620, z = 7}, {x = 5303, y = 620, z = 7}, {x = 5306, y = 621, z = 7}, {x = 5299, y = 622, z = 7}, {x = 5302, y = 622, z = 7}, {x = 5305, y = 622, z = 7}, {x = 5299, y = 624, z = 7}, {x = 5302, y = 624, z = 7}, {x = 5305, y = 625, z = 7}, {x = 5299, y = 627, z = 7}, {x = 5305, y = 628, z = 7}},
        exitPosition = {x = 5302, y = 630, z = 7}
    },
    [9] = {
        startPosition = {x = 5304, y = 611, z = 7},
        candyPositions = {{x = 5301, y = 608, z = 7}, {x = 5304, y = 609, z = 7}, {x = 5307, y = 608, z = 7}, {x = 5302, y = 612, z = 7}, {x = 5304, y = 614, z = 7}, {x = 5307, y = 612, z = 7}, {x = 5302, y = 611, z = 7}, {x = 5304, y = 609, z = 7}},
        exitPosition = {x = 5304, y = 616, z = 7}
    },
    [10] = {
        startPosition = {x = 5292, y = 599, z = 7},
        candyPositions = {{x = 5290, y = 597, z = 7}, {x = 5292, y = 597, z = 7}, {x = 5295, y = 597, z = 7}, {x = 5290, y = 599, z = 7}, {x = 5295, y = 599, z = 7}, {x = 5289, y = 600, z = 7}, {x = 5292, y = 601, z = 7}, {x = 5295, y = 601, z = 7}, {x = 5290, y = 602, z = 7}},
        exitPosition = {x = 5298, y = 599, z = 7}
    },
}
EliteFour.SnakeGame.CANDY_ITEMID = 5906
EliteFour.SnakeGame.THINK_INTERVAL = 400
EliteFour.SnakeGame.WALL_ITEMID = 13501
EliteFour.SnakeGame.SNAKE_FINISH_SIZE = 10
EliteFour.SnakeGame.SNAKE_PART_NPC_NAME = "Snake Part"
EliteFour.SnakeGame.RESET_POSITION = {x = 5274, y = 602, z = 7}

EliteFour.SnakeGame.OUTFIT = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.SNAKE_GAME)
addOutfitCondition(EliteFour.SnakeGame.OUTFIT, {lookType = 480})

EliteFour.SnakeGame.SPEED_CONDITION = createConditionObject(CONDITION_HASTE, 1000, -1, CONDITION_SUBID.HASTE.SNAKE_GAME)
setConditionParam(EliteFour.SnakeGame.SPEED_CONDITION, CONDITION_PARAM_SPEED, 500)

-- Vars
local SNAKEGAME_THINK_EVENT = nil
local SNAKEGAME_PARTS = {}
local SNAKEGAME_CANDY_POSITION = nil

EliteFour.SnakeGame.doStart = function(cid, arenaId)
    doTeleportThing(cid, EliteFour.SnakeGame.ARENAS[arenaId].startPosition, false)-- teleport player
    doCreatureSetNoMove(cid, true)-- lock player
    doAddCondition(cid, EliteFour.SnakeGame.OUTFIT)-- change player outfit
    doAddCondition(cid, EliteFour.SnakeGame.SPEED_CONDITION)-- speed up the player for better graphic moving
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "The Snake game will begun in 10 seconds.")-- broadcast
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "You MUST use CTRL + ARROW KEYS to turn your character!")-- broadcast
    EliteFour.SnakeGame.doReset()

    local counter = 10
    local prepare
    prepare = function()
        if (isCreature(cid)) then
            doSendAnimatedText(getCreaturePosition(cid), counter, COLOR_RED)
            counter = counter - 1

            if (counter > 0) then
                addEvent(prepare, 1000)
            else
                SNAKEGAME_THINK_EVENT = addEvent(EliteFour.SnakeGame.onThink, EliteFour.SnakeGame.THINK_INTERVAL, cid, getCreaturePosition(cid), arenaId)-- start think
            end
        end
    end
    prepare()
end

EliteFour.SnakeGame.onThink = function(cid, lastPos, arenaId)
    if (isCreature(cid)) then
        local nextPos = EliteFour.SnakeGame.doSnakeWalk(cid, lastPos)
        if (not EliteFour.SnakeGame.doCheckCollision(cid, nextPos)) then-- check collision
            EliteFour.SnakeGame.doCreateCandy(arenaId)-- create candy
            if (EliteFour.SnakeGame.doCheckFinish()) then-- check finish
                EliteFour.SnakeGame.doEnd(cid, true, arenaId)
            else
                SNAKEGAME_THINK_EVENT = addEvent(EliteFour.SnakeGame.onThink, EliteFour.SnakeGame.THINK_INTERVAL, cid, nextPos, arenaId)-- re event think
            end
        else
            EliteFour.SnakeGame.doEnd(cid, false, arenaId)
        end
    else
        --EliteFour.SnakeGame.doReset()
    end
end

EliteFour.SnakeGame.doCheckCollision = function(cid, pos)
    if (isItem(getTileItemById(pos, EliteFour.SnakeGame.WALL_ITEMID))) then
        return true -- Oops, we crash!
    end
    -- check if current pos have two or more snake parts or if there is a wall
    if (#SNAKEGAME_PARTS > 1) then
        for i, part in pairs(SNAKEGAME_PARTS) do
            if (i ~= #SNAKEGAME_PARTS) then
                if (getSamePosition(pos, getCreaturePosition(part))) then
                    return true
                end
            end
        end
    end

    if (SNAKEGAME_CANDY_POSITION and getSamePosition(pos, SNAKEGAME_CANDY_POSITION)) then
        EliteFour.SnakeGame.doEatCandy(cid)-- or check if there is a candy here
    end

    return false
end

EliteFour.SnakeGame.doSnakeWalk = function(cid, lastPos)
    -- move the snake head
    local lastPartPos = table.deepcopy(lastPos)
    local nextPos = getPositionByDirection(lastPos, getCreatureLookDir(cid), 1)
    doSendDistanceShoot(lastPos, nextPos, PROJECTILE_GRAVEL)
    doTeleportThing(cid, nextPos, true)-- do walk

    -- move the parts each other
    for i = 1, #SNAKEGAME_PARTS do
        local tmpLastPartPos = getCreaturePosition(SNAKEGAME_PARTS[i])
        doTeleportThing(SNAKEGAME_PARTS[i], lastPartPos, true)-- do walk
        lastPartPos = tmpLastPartPos
    end
    return nextPos
end

EliteFour.SnakeGame.doCreateCandy = function(arenaId)
    -- check if there is already a candy, if not create one
    if (not SNAKEGAME_CANDY_POSITION) then
        SNAKEGAME_CANDY_POSITION = table.random(EliteFour.SnakeGame.ARENAS[arenaId].candyPositions)
        doCreateItem(EliteFour.SnakeGame.CANDY_ITEMID, 1, SNAKEGAME_CANDY_POSITION)
        doSendMagicEffect(SNAKEGAME_CANDY_POSITION, EFFECT_POISON_GAS)
    end
end

EliteFour.SnakeGame.doCheckFinish = function()
    -- check if the snake is big enough to finish
    return (#SNAKEGAME_PARTS - 1) >= EliteFour.SnakeGame.SNAKE_FINISH_SIZE
end

EliteFour.SnakeGame.doEnd = function(cid, win, arenaId)
    if (win) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "You won the Snake game!")-- broadcast
        doTeleportThing(cid, EliteFour.SnakeGame.ARENAS[arenaId].exitPosition, false)-- teleport player out
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "You loss the Snake game!")-- broadcast
        doTeleportThing(cid, EliteFour.SnakeGame.RESET_POSITION, false)-- teleport player out
    end
    doCreatureSetNoMove(cid, false)-- unlock player
    doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.SNAKE_GAME) -- change outfit
    doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.HASTE.SNAKE_GAME) -- remove the extra speed
    --EliteFour.SnakeGame.doReset()
end

EliteFour.SnakeGame.doReset = function()
    stopEvent(SNAKEGAME_THINK_EVENT)-- stop thinking
    SNAKEGAME_THINK_EVENT = nil
    -- remove the snake parts
    for i, part in pairs(SNAKEGAME_PARTS) do
        doRemoveCreature(part)
    end
    SNAKEGAME_PARTS = {}
    -- remove candy
    if (SNAKEGAME_CANDY_POSITION) then
        doRemoveItem(getTileItemById(SNAKEGAME_CANDY_POSITION, EliteFour.SnakeGame.CANDY_ITEMID).uid)
        SNAKEGAME_CANDY_POSITION = nil
    end
end

EliteFour.SnakeGame.doEatCandy = function(cid)
    doRemoveItem(getTileItemById(SNAKEGAME_CANDY_POSITION, EliteFour.SnakeGame.CANDY_ITEMID).uid)-- remove the candy
    doSendMagicEffect(SNAKEGAME_CANDY_POSITION, EFFECT_PURPLE_BITE)
    if (#SNAKEGAME_PARTS > 0) then
        SNAKEGAME_PARTS[#SNAKEGAME_PARTS + 1] = doCreateNpc(EliteFour.SnakeGame.SNAKE_PART_NPC_NAME, getCreaturePosition(SNAKEGAME_PARTS[#SNAKEGAME_PARTS]), false)-- enlarge the snake
    else
        SNAKEGAME_PARTS[#SNAKEGAME_PARTS + 1] = doCreateNpc(EliteFour.SnakeGame.SNAKE_PART_NPC_NAME, getCreaturePosition(cid), false)-- enlarge the snake
    end
    SNAKEGAME_CANDY_POSITION = nil-- erase the var
end
-- [REGION END] Snake Game
-- [REGION START] Maze Game
local MAZE_VARIATIONS = {
    {
        positions = {
            {x = 3095, y = 441, z = 6, itemId = 10743},
            {x = 3096, y = 441, z = 6, itemId = 10743},
            {x = 3110, y = 438, z = 6, itemId = 10743},
            {x = 3111, y = 438, z = 6, itemId = 10743},
            {x = 3122, y = 435, z = 6, itemId = 10743},
            {x = 3123, y = 435, z = 6, itemId = 10743}
        }
    },
    {
        positions = {
            {x = 3096, y = 436, z = 6, itemId = 10744},
            {x = 3096, y = 437, z = 6, itemId = 10744},
            {x = 3106, y = 435, z = 6, itemId = 10743},
            {x = 3107, y = 435, z = 6, itemId = 10743},
        }
    },
    {
        positions = {
            {x = 3126, y = 435, z = 6, itemId = 10743},
            {x = 3127, y = 435, z = 6, itemId = 10743},
            {x = 3132, y = 435, z = 6, itemId = 10743},
            {x = 3133, y = 435, z = 6, itemId = 10743},
        }
    }
}

local CURRENT_MAZE_VARIATION = nil

EliteFour.MazeGame = {}

EliteFour.MazeGame.doVariate = function()
    if (CURRENT_MAZE_VARIATION) then
        for _, pos in pairs(CURRENT_MAZE_VARIATION.positions) do
            doCreateItem(pos.itemId, 1, pos)
        end
    end

    CURRENT_MAZE_VARIATION = table.random(MAZE_VARIATIONS)

    for _, pos in pairs(CURRENT_MAZE_VARIATION.positions) do
        local item = getTileItemById(pos, pos.itemId)
        if (isItem(item)) then
            doRemoveItem(item.uid)
        end
    end
end

-- [REGION END] Maze Game
-- [REGION START] Puzzle Rock
local CURRENT_PUZZLE_ROCK_VARRIATION_LEFT = nil
local CURRENT_PUZZLE_ROCK_VARRIATION_RIGHT = nil
local PUZZLE_ROCK_VARIATIONS = {
    itemId = 5619,
    positions = {
        left = {
            {
                {x = 5288, y = 415, z = 6},
                {x = 5281, y = 445, z = 6},
                {x = 5294, y = 455, z = 6}
            },
            {
                {x = 5289, y = 449, z = 6},
                {x = 5291, y = 463, z = 6},
                {x = 5285, y = 407, z = 6}
            },
            {
                {x = 5294, y = 447, z = 6},
                {x = 5293, y = 457, z = 6},
                {x = 5309, y = 455, z = 6},
                {x = 5312, y = 455, z = 6},
                {x = 5315, y = 455, z = 6},
                {x = 5282, y = 419, z = 6},
                {x = 5285, y = 423, z = 6}
            }
    },
        right = {
            {
                {x = 5329, y = 457, z = 6},
                {x = 5339, y = 455, z = 6},
                {x = 5341, y = 421, z = 6}
            },
            {
                {x = 5344, y = 425, z = 6},
                {x = 5336, y = 459, z = 6}
            },
            {
                {x = 5318, y = 455, z = 6},
                {x = 5321, y = 455, z = 6},
                {x = 5339, y = 454, z = 6},
                {x = 5348, y = 419, z = 6},
                {x = 5350, y = 421, z = 6}
            }
        }
    }
}

EliteFour.PuzzleRock = {}

EliteFour.PuzzleRock.doVariate = function()
    if (CURRENT_PUZZLE_ROCK_VARRIATION_LEFT) then
        for _, pos in pairs(CURRENT_PUZZLE_ROCK_VARRIATION_LEFT) do
            doCreateItem(PUZZLE_ROCK_VARIATIONS.itemId, 1, pos)
        end
    end

    if (CURRENT_PUZZLE_ROCK_VARRIATION_RIGHT) then
        for _, pos in pairs(CURRENT_PUZZLE_ROCK_VARRIATION_RIGHT) do
            doCreateItem(PUZZLE_ROCK_VARIATIONS.itemId, 1, pos)
        end
    end

    CURRENT_PUZZLE_ROCK_VARRIATION_LEFT = table.random(PUZZLE_ROCK_VARIATIONS.positions.left)
    for _, pos in pairs(CURRENT_PUZZLE_ROCK_VARRIATION_LEFT) do
        local item = getTileItemById(pos, PUZZLE_ROCK_VARIATIONS.itemId)
        if (isItem(item)) then
            doRemoveItem(item.uid)
        end
    end

    CURRENT_PUZZLE_ROCK_VARRIATION_RIGHT = table.random(PUZZLE_ROCK_VARIATIONS.positions.right)
    for _, pos in pairs(CURRENT_PUZZLE_ROCK_VARRIATION_RIGHT) do
        local item = getTileItemById(pos, PUZZLE_ROCK_VARIATIONS.itemId)
        if (isItem(item)) then
            doRemoveItem(item.uid)
        end
    end
end
-- [REGION END] Puzzle Rock
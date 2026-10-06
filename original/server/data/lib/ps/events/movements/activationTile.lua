local kantoMain12Actioning = nil
local kantoMain12FinalActioning = nil

local CP_MACHINE = {}

CP_MACHINE.MACHINE_PHASES = {
    {
        { itemId = 24443, relStart = { x = 0, y = 0 }, startRel = { x = 0, y = 0 } },
        { itemId = 24446, relStart = { x = -1, y = 0 }, startRel = { x = 1, y = 0 } },
        { itemId = 24445, relStart = { x = 0, y = -1 }, startRel = { x = 0, y = 1 } },
        { itemId = 24444, relStart = { x = -1, y = -1 }, startRel = { x = 1, y = 1 } }
    },
    {
        { itemId = 24447, relStart = { x = 0, y = 0 }, startRel = { x = 0, y = 0 } },
        { itemId = 24450, relStart = { x = -1, y = 0 }, startRel = { x = 1, y = 0 } },
        { itemId = 24449, relStart = { x = 0, y = -1 }, startRel = { x = 0, y = 1 } },
        { itemId = 24448, relStart = { x = -1, y = -1 }, startRel = { x = 1, y = 1 } }
    },
    {
        { itemId = 24451, relStart = { x = 0, y = 0 }, startRel = { x = 0, y = 0 } },
        { itemId = 24454, relStart = { x = -1, y = 0 }, startRel = { x = 1, y = 0 } },
        { itemId = 24453, relStart = { x = 0, y = -1 }, startRel = { x = 0, y = 1 } },
        { itemId = 24452, relStart = { x = -1, y = -1 }, startRel = { x = 1, y = 1 } }
    },
    {
        { itemId = 24455, relStart = { x = 0, y = 0 }, startRel = { x = 0, y = 0 } },
        { itemId = 24458, relStart = { x = -1, y = 0 }, startRel = { x = 1, y = 0 } },
        { itemId = 24457, relStart = { x = 0, y = -1 }, startRel = { x = 0, y = 1 } },
        { itemId = 24456, relStart = { x = -1, y = -1 }, startRel = { x = 1, y = 1 } }
    },
}

CP_MACHINE.MACHINE_PHASE_BY_INITIAL_ITEMID = {
    [24443] = CP_MACHINE.MACHINE_PHASES[1],
    [24447] = CP_MACHINE.MACHINE_PHASES[2],
    [24451] = CP_MACHINE.MACHINE_PHASES[3],
    [24455] = CP_MACHINE.MACHINE_PHASES[4]
}

CP_MACHINE.MACHINE_SEQUENCE_ENTERING = {
    [CP_MACHINE.MACHINE_PHASES[1]] = CP_MACHINE.MACHINE_PHASES[2],
    [CP_MACHINE.MACHINE_PHASES[2]] = CP_MACHINE.MACHINE_PHASES[3],
    [CP_MACHINE.MACHINE_PHASES[3]] = CP_MACHINE.MACHINE_PHASES[4],
    --[CP_MACHINE.MACHINE_PHASES[4]] = CP_MACHINE.MACHINE_PHASES[3],
}

CP_MACHINE.MACHINE_SEQUENCE_LEAVING = {
    [CP_MACHINE.MACHINE_PHASES[4]] = CP_MACHINE.MACHINE_PHASES[3],
    [CP_MACHINE.MACHINE_PHASES[3]] = CP_MACHINE.MACHINE_PHASES[2],
    [CP_MACHINE.MACHINE_PHASES[2]] = CP_MACHINE.MACHINE_PHASES[1],
}

CP_MACHINE.machinePositions, CP_MACHINE.events, CP_MACHINE.animating = {}, {}, {}

function CP_MACHINE.findMachine(pos)
    local dirs = { NORTH, EAST, SOUTH, WEST, SOUTHWEST, SOUTHEAST, NORTHWEST, NORTHEAST }
    for k, v in ipairs(dirs) do
        local tmpPos = { x = pos.x, y = pos.y, z = pos.z }
        tmpPos = getPositionByDirection(tmpPos, v, 1)

        for phaseId, phaseItemIds in pairs(CP_MACHINE.MACHINE_PHASES) do
            for ___, phaseConfig in pairs(phaseItemIds) do
                if (isItem(getTileItemById(tmpPos, phaseConfig.itemId))) then
                    CP_MACHINE.machinePositions[posToString(pos)] = doConcatPositions(tmpPos, phaseConfig.relStart)
                    return true
                end
            end
        end
    end
    return false
end

function CP_MACHINE.getMachine(pos)
    for phaseId, phaseItemIds in pairs(CP_MACHINE.MACHINE_PHASES) do
        for ___, phaseConfig in pairs(phaseItemIds) do
            local item = getTileItemById(pos, phaseConfig.itemId)
            if (isItem(item)) then
                return item
            end
        end
    end
    return nil
end

function posToString(pos)
    return pos.x .. "," .. pos.y .. "," .. pos.z
end

function CP_MACHINE.animateMachine(pos, fromContinue, entering)
    local posString = posToString(pos)
    if ((not CP_MACHINE.machinePositions[posString] and not CP_MACHINE.findMachine(pos)) or
            (CP_MACHINE.events[CP_MACHINE.machinePositions[posString]] and not fromContinue)) then
        return
    end

    if (fromContinue) then
        CP_MACHINE.events[CP_MACHINE.machinePositions[posString]] = nil
    end

    local machine = CP_MACHINE.getMachine(CP_MACHINE.machinePositions[posString])
    if (not isItem(machine)) then
        return
    end

    -- Someone still there
    local currentPhase = CP_MACHINE.MACHINE_PHASE_BY_INITIAL_ITEMID[machine.itemid]
    if (not entering) then
        for _, phaseConfig in pairs(currentPhase) do
            local dirs = { NORTH, EAST, SOUTH, WEST, SOUTHWEST, SOUTHEAST, NORTHWEST, NORTHEAST }
            for k, v in ipairs(dirs) do
                local tmpPos = doConcatPositions({
                    x = CP_MACHINE.machinePositions[posString].x,
                    y = CP_MACHINE.machinePositions[posString].y,
                    z = CP_MACHINE.machinePositions[posString].z
                }, phaseConfig.startRel)
                tmpPos = getPositionByDirection(tmpPos, v, 1)

                if (isPlayer(getTopCreature(tmpPos).uid)) then
                    return
                end
            end
        end
    end

    local continue = true
    local nextPhase
    if (entering) then
        nextPhase = CP_MACHINE.MACHINE_SEQUENCE_ENTERING[currentPhase]
    else
        nextPhase = CP_MACHINE.MACHINE_SEQUENCE_LEAVING[currentPhase]
    end
    if (nextPhase) then
        for k, phaseConfig in pairs(nextPhase) do
            local tmpPos = doConcatPositions({
                x = CP_MACHINE.machinePositions[posString].x,
                y = CP_MACHINE.machinePositions[posString].y,
                z = CP_MACHINE.machinePositions[posString].z
            }, phaseConfig.startRel)
            if (not doTransformItem(getTileItemById(tmpPos, currentPhase[k].itemId).uid, phaseConfig.itemId, 1)) then
                continue = false
                break
            end
        end
    else
        continue = false
    end

    if (continue) then
        CP_MACHINE.events[CP_MACHINE.machinePositions[posString]] = addEvent(CP_MACHINE.animateMachine, (entering and 250 or 300), pos, true, entering)
    end
end

local ACTS_ONLY_PLAYER = {
    -- [actionId] = callback
    -- London Hamnet quest #1
    [100] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getCreatureStorage(cid, 8441) == QUEST_STATUS.STARTED and -- Is on quest and doesnt have seen the weezing yet
                getCreatureStorage(cid, 8443) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8443, QUEST_STATUS.FINISHED)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "There is the source of the stench!")
        end

        return true
    end,

    -- Rocket base enter (Cassino)
    [101] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getPlayerDefeatedNPC(cid, 9683)) then -- Rocket Grunt
            -- the base can change if player is doing Kanto Main 10
            local dest = (getCreatureStorage(cid, 8544) == QUEST_STATUS.UNSTARTED and { x = 5031, y = 511, z = 7 } or
                    { x = 5032, y = 601, z = 8 })
            doTeleportThing(cid, dest) -- Laboratory entrance
            -- todo main10 blocked
            doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
        end

        return true
    end,

    -- Brockling Timmy quest (get the toy)
    [102] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getCreatureStorage(cid, 8461) == QUEST_STATUS.STARTED) then
            local AREAS = {
                {
                    { 0, 1, 0 },
                    { 1, 3, 1 },
                    { 0, 1, 0 },
                },
                {
                    { 0, 1, 1, 1, 0 },
                    { 1, 1, 1, 1, 1 },
                    { 1, 1, 3, 1, 1 },
                    { 1, 1, 1, 1, 1 },
                    { 0, 1, 1, 1, 0 }
                },
                {
                    { 0, 0, 1, 1, 1, 0, 0 },
                    { 0, 1, 1, 1, 1, 1, 0 },
                    { 1, 1, 1, 1, 1, 1, 1 },
                    { 1, 1, 1, 3, 1, 1, 1 },
                    { 1, 1, 1, 1, 1, 1, 1 },
                    { 0, 1, 1, 1, 1, 1, 0 },
                    { 0, 0, 1, 1, 1, 0, 0 }
                }
            }

            executeInArea(position, table.random(AREAS), function(pos)
                doSendMagicEffect(pos, EFFECT_PURPLE_SOUND)
                if (isItem(getTileItemById(pos, 23593))) then
                    local toPos = { x = 3271, y = 242, z = 7 }
                    local batPos = { x = 3270, y = 241, z = 7 }
                    local batName = "Brock's Zubat"

                    local spec = getSpectators(batPos, 3, 3, false)
                    if (spec) then
                        local batFound = false
                        for k, v in pairs(spec) do
                            if (isNpc(v) and getCreatureName(v) == batName) then
                                batFound = true
                                break
                            end
                        end

                        if (not batFound) then
                            local npc = doCreateNpc(batName, batPos, false)
                            addEvent(doRemoveCreature, 10 * 1000, npc)
                        end
                    end

                    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The Zubat woke up.")
                    doTeleportThing(cid, toPos)
                    doSendMagicEffect(toPos, EFFECT_TELEPORT_DOWN)
                    doSendMagicEffect(batPos, EFFECT_TELEPORT_DOWN)
                    doSendMagicEffect(batPos, EFFECT_EMOTION_SAD)
                end
            end)
        end

        return true
    end,

    -- Dream World exit
    [105] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        setPlayerBlockLogout(cid, false)
        return true
    end,

    -- S.S Anne
    --[[[103] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
          if (getPlayerItemCount(cid, 23540) <= 0) then -- S.S. Anne Ticket
              doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You can not enter the boat without the ticket.")
              doTeleportThing(cid, lastPosition, true)
          end

          return true
      end,]]

    -- Professor Oak Lab - Checking if player has got starter Pokemon
    [106] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (not getPlayerGotStarterPokemon(cid) or (getCreatureStorage(cid, 8507) ~= QUEST_STATUS.FINISHED and
                getPlayerLevel(cid) <= PLAYER_START_LEVEL)) then
            doTeleportThing(cid, { x = 3337, y = 811, z = 6 })
            doSendMagicEffect({ x = 3337, y = 809, z = 6 }, EFFECT_EMOTION_EXCLAMATION)
            doPlayerPopupFYI(cid, "You must talk with Professor Oak to get your first Pokemon and choose your start city.\nJust say 'hi' at the Default channel next to the Professor Oak!")
        end

        return true
    end,

    -- Kanto Main 2 - Confirm if players pass through 'magnifier dungeon'
    [107] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getCreatureStorage(cid, 8509) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, 8509, QUEST_STATUS.FINISHED)
        end

        return true
    end,

    -- TM Substitute Dungeon Exit
    [108] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        setPlayerBlockLogout(cid, false)
        return true
    end,

    -- Pokemon Center depots
    [109] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        CP_MACHINE.animateMachine(position, nil, true)
        return true
    end,
    -- Elite Four Ice slip
    [111] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        EliteFour.doIceSlip(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        return true
    end,
    -- Elite Four Pokemon Summon (?)
    [112] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getRandom(1, 100) <= 10) then
            local list = { "Charizard", "Ampharos", "Arbok", "Ariados", "Cloyster", "Donphan", "Feraligatr", "Gengar", "Granbull", "Hitmonchan", "Heracross", "Parasect" }
            local m = doCreateMonster(table.random(list), fromPosition)
            if (m) then
                registerCreatureEvent(m, "onPrepareDeath_Remove")
                doSendMagicEffect(position, EFFECT_POISON_GAS_THREE)
                setMonsterLevel(m, 100)
                addEvent(function(m) if (isCreature(m)) then doRemoveCreature(m) end end, 3 * 60 * 1000, m)
            end
        end
        return true
    end,
    -- Elite Four Dream Enter
    [113] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        doTeleportThing(cid, { x = 5274, y = 602, z = 7 })
        return true
    end,
    -- Elite Four Dream Leave
    [114] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        doTeleportThing(cid, { x = 5316, y = 458, z = 5 })
        return true
    end,
    -- Elite Four Member Appearance
    [115] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        EliteFour.doMemberAppear(cid, EliteFour.MEMBER_IDS.LORELEI)
        return true
    end,
    -- Elite Four Member Appearance
    [116] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        EliteFour.doMemberAppear(cid, EliteFour.MEMBER_IDS.BRUNO)
        return true
    end,
    -- Elite Four Member Appearance
    [117] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        EliteFour.doMemberAppear(cid, EliteFour.MEMBER_IDS.AGATHA)
        return true
    end,
    -- Elite Four Member Appearance
    [118] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        EliteFour.doMemberAppear(cid, EliteFour.MEMBER_IDS.LANCE)
        return true
    end,
    -- Elite Four Member Appearance (Champion)
    [119] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        EliteFour.doChampionAppear()
        return true
    end,
    -- 120 main 8 traps
    [120] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getRandom(1, 100) <= 30) then
            local damage = function()
                doCreatureTrueDamage(cid, -250, EFFECT_BIG_FLAMES, TEXTCOLOR_RED, pos)
            end

            local paralyze = function()
                doCreatureAddStatus(cid, CREATURE_STATUS_PARALYSIS)
            end

            local rocketPokemon = function()
                local list = { "Charizard", "Ampharos", "Arbok", "Ariados", "Cloyster", "Donphan", "Feraligatr", "Gengar", "Granbull", "Hitmonchan", "Heracross", "Parasect" }
                local m = doCreateMonster(table.random(list), fromPosition, false)
                if (m) then
                    registerCreatureEvent(m, "onPrepareDeath_Remove")
                    doSendMagicEffect(fromPosition, EFFECT_TELEPORT_DOWN)
                    setMonsterLevel(m, 60)
                    addEvent(function(m) if (isCreature(m)) then doRemoveCreature(m) end end, 3 * 60 * 1000, m)
                end
            end

            local teleport = function()
                local positions = {
                    [2] = {
                        { x = 5211, y = 508, z = 2 },
                        { x = 5191, y = 494, z = 2 },
                        { x = 5217, y = 490, z = 2 },
                        { x = 5203, y = 520, z = 2 },
                        { x = 5222, y = 519, z = 2 }
                    },
                    [3] = {
                        { x = 5193, y = 491, z = 3 },
                        { x = 5220, y = 492, z = 3 },
                        { x = 5222, y = 521, z = 3 },
                        { x = 5203, y = 506, z = 3 },
                        { x = 5218, y = 515, z = 3 }
                    },
                    [4] = {
                        { x = 5217, y = 519, z = 4 },
                        { x = 5212, y = 501, z = 4 },
                        { x = 5189, y = 493, z = 4 },
                        { x = 5210, y = 490, z = 4 },
                        { x = 5223, y = 503, z = 4 }
                    },
                    [5] = {
                        { x = 5224, y = 512, z = 5 },
                        { x = 5204, y = 499, z = 5 },
                        { x = 5188, y = 489, z = 5 },
                        { x = 5188, y = 489, z = 5 },
                        { x = 5216, y = 521, z = 5 }

                        --[[
                                      {x = 5224, y = 512, z = 5}
                                      {x = 5204, y = 499, z = 5}
                                      {x = 5188, y = 489, z = 5}
                                      {x = 5222, y = 488, z = 5}
                                      {x = 5216, y = 521, z = 5}
                                       ]]
                    },
                    [6] = {
                        { x = 5211, y = 521, z = 6 },
                        { x = 5223, y = 507, z = 6 },
                        { x = 5203, y = 502, z = 6 },
                        { x = 5188, y = 487, z = 6 },
                        { x = 5207, y = 502, z = 6 }
                    }
                }
                local newPosition = table.random(positions[position.z])
                doSendMagicEffect(position, EFFECT_TELEPORT_UP)
                doTeleportThing(cid, newPosition, false)
                doSendMagicEffect(newPosition, EFFECT_TELEPORT_DOWN)
            end

            local traps = { damage, paralyze, rocketPokemon, teleport }
            table.random(traps)()
        end

        return true
    end,
    -- 121 main 8 door traps
    [121] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getRandom(1, 100) <= 30) then
            local damage = function()
                doCreatureTrueDamage(cid, -250, EFFECT_BIG_FLAMES, TEXTCOLOR_RED, pos)
            end

            local closingRoom = function()
                local rooms = {
                    --{doorOpenItemId = 0, doorClosedItemId = 0, spawnPositions = {}, teleportPosition = {x = 0, y = 0, z = 0}},
                    [2] = {
                        {
                            doorPosition = { x = 5193, y = 507, z = 2 },
                            doorClosedItemId = 1249,
                            doorOpenItemId = 1251,
                            roomCenterPosition = { x = 5190, y = 507, z = 2 },
                            teleportPosition = { x = 5192, y = 507, z = 2 },
                            roomRangeX = 3,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5193, y = 501, z = 2 },
                            doorClosedItemId = 1249,
                            doorOpenItemId = 1251,
                            roomCenterPosition = { x = 5190, y = 501, z = 2 },
                            teleportPosition = { x = 5192, y = 501, z = 2 },
                            roomRangeX = 2,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5193, y = 494, z = 2 },
                            doorClosedItemId = 1249,
                            doorOpenItemId = 1251,
                            roomCenterPosition = { x = 5190, y = 495, z = 2 },
                            teleportPosition = { x = 5192, y = 494, z = 2 },
                            roomRangeX = 2,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5195, y = 492, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5195, y = 492, z = 2 },
                            teleportPosition = { x = 5195, y = 491, z = 2 },
                            roomRangeX = 5,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5202, y = 492, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5203, y = 489, z = 2 },
                            teleportPosition = { x = 5202, y = 491, z = 2 },
                            roomRangeX = 3,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5211, y = 492, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5210, y = 489, z = 2 },
                            teleportPosition = { x = 5210, y = 490, z = 4 },
                            roomRangeX = 3,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5218, y = 492, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5219, y = 489, z = 2 },
                            teleportPosition = { x = 5218, y = 491, z = 2 },
                            roomRangeX = 5,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5219, y = 494, z = 2 },
                            doorClosedItemId = 1249,
                            doorOpenItemId = 1251,
                            roomCenterPosition = { x = 5222, y = 495, z = 2 },
                            teleportPosition = { x = 5220, y = 494, z = 2 },
                            roomRangeX = 3,
                            roomRangeY = 3
                        },
                        {
                            doorPosition = { x = 5222, y = 495, z = 2 },
                            doorClosedItemId = 1249,
                            doorOpenItemId = 1251,
                            roomCenterPosition = { x = 5222, y = 501, z = 2 },
                            teleportPosition = { x = 5220, y = 501, z = 2 },
                            roomRangeX = 2,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5219, y = 508, z = 2 },
                            doorClosedItemId = 1249,
                            doorOpenItemId = 1251,
                            roomCenterPosition = { x = 5222, y = 507, z = 2 },
                            teleportPosition = { x = 5220, y = 508, z = 2 },
                            roomRangeX = 2,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5219, y = 515, z = 2 },
                            doorClosedItemId = 1249,
                            doorOpenItemId = 1251,
                            roomCenterPosition = { x = 5222, y = 513, z = 2 },
                            teleportPosition = { x = 5220, y = 515, z = 2 },
                            roomRangeX = 2,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5218, y = 516, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5217, y = 519, z = 2 },
                            teleportPosition = { x = 5220, y = 515, z = 2 },
                            roomRangeX = 3,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5211, y = 516, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5211, y = 516, z = 2 },
                            teleportPosition = { x = 5211, y = 517, z = 2 },
                            roomRangeX = 3,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5202, y = 516, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5203, y = 519, z = 2 },
                            teleportPosition = { x = 5202, y = 517, z = 2 },
                            roomRangeX = 4,
                            roomRangeY = 2
                        },
                        {
                            doorPosition = { x = 5199, y = 513, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5201, y = 509, z = 2 },
                            teleportPosition = { x = 5199, y = 512, z = 2 },
                            roomRangeX = 4,
                            roomRangeY = 4
                        },
                        {
                            doorPosition = { x = 5214, y = 513, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5211, y = 509, z = 2 },
                            teleportPosition = { x = 5211, y = 509, z = 2 },
                            roomRangeX = 4,
                            roomRangeY = 4
                        },
                        {
                            doorPosition = { x = 5199, y = 495, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5211, y = 500, z = 2 },
                            teleportPosition = { x = 5211, y = 500, z = 2 },
                            roomRangeX = 4,
                            roomRangeY = 5
                        },
                        {
                            doorPosition = { x = 5214, y = 495, z = 2 },
                            doorClosedItemId = 1252,
                            doorOpenItemId = 1254,
                            roomCenterPosition = { x = 5201, y = 500, z = 2 },
                            teleportPosition = { x = 5199, y = 496, z = 2 },
                            roomRangeX = 4,
                            roomRangeY = 5
                        },
                    }
                }

                -- duplicate for floor 3 to 7
                --for floor, room in pairs(rooms) do
                --for newFloor = 3, 7 do
                --if (not rooms[newFloor]) then
                --rooms[newFloor] = {}
                --end

                --rooms[newFloor][#rooms[newFloor] + 1] = table.deepcopy(room)

                --rooms[newFloor][#rooms[newFloor]].doorPosition.z = newFloor
                --rooms[newFloor][#rooms[newFloor]].roomCenterPosition.z = newFloor
                --rooms[newFloor][#rooms[newFloor]].teleportPosition.z = newFloor
                --end
                --end

                for newFloor = 3, 7 do
                    --rooms[newFloor] = {}
                    --rooms[newFloor][#rooms[newFloor] + 1] = table.deepcopy(rooms[2])
                    --table.print(rooms[newFloor][#rooms[newFloor]]) -- todo remove
                    --rooms[newFloor][#rooms[newFloor]].doorPosition.z = newFloor
                    --rooms[newFloor][#rooms[newFloor]].roomCenterPosition.z = newFloor
                    --rooms[newFloor][#rooms[newFloor]].teleportPosition.z = newFloor]]

                    rooms[newFloor] = table.deepcopy(rooms[2])

                    for k, v in pairs(rooms[newFloor]) do
                        v.doorPosition.z = newFloor
                        v.roomCenterPosition.z = newFloor
                        v.teleportPosition.z = newFloor
                    end
                end

                local roomDoor = nil
                for k, v in pairs(rooms[position.z]) do
                    if (getSamePosition(v.doorPosition, position)) then
                        roomDoor = v
                        break
                    end
                end

                -- close and lock door
                doToggleDoor(position, roomDoor.doorOpenItemId, roomDoor.doorClosedItemId)
                local item = getTileItemById(position, roomDoor.doorClosedItemId)
                if (isItem(item)) then
                    doItemSetAttribute(item.uid, "aid", 9500)
                end

                -- move the player
                doTeleportThing(cid, roomDoor.teleportPosition, false)

                -- spawn monsters
                local summons = getRandom(1, 3)
                for i = 1, summons do
                    local m = doCreateMonster(table.random({ "Weezing", "Arbok", "Golbat", "Electrode" }), roomDoor.teleportPosition, false)
                    if (m) then
                        registerCreatureEvent(m, "onPrepareDeath_Remove")
                        setMonsterLevel(m, 60)
                        addEvent(function(m) if (isCreature(m)) then doRemoveCreature(m) end end, 3 * 60 * 1000, m)
                        doSendMagicEffect(fromPosition, EFFECT_TELEPORT_DOWN)
                    end
                end
            end

            local suckEnergy = function()
                local pokemon = getPlayerPokemon(cid)
                if (isCreature(pokemon)) then
                    doCreatureAddMana(cid, -math.ceil(getCreatureMana(cid) / 10), false)
                end
            end

            local traps = { damage, closingRoom, suckEnergy }
            table.random(traps)()
        end

        return true
    end,
    -- 122 main 8 sound traps
    [122] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        local nearby = getSpectators(position, 30, 30)
        if (nearby) then
            for _, tmpCid in pairs(nearby) do
                if (isPokemonWild(tmpCid) and not isCreature(getCreatureTarget(tmpCid))) then
                    doCreatureWalkToPosition(tmpCid, position)
                end
            end
        end

        local AREAS = {
            {
                { 0, 1, 0 },
                { 1, 3, 1 },
                { 0, 1, 0 },
            },
            {
                { 0, 1, 1, 1, 0 },
                { 1, 1, 1, 1, 1 },
                { 1, 1, 3, 1, 1 },
                { 1, 1, 1, 1, 1 },
                { 0, 1, 1, 1, 0 }
            },
            {
                { 0, 0, 1, 1, 1, 0, 0 },
                { 0, 1, 1, 1, 1, 1, 0 },
                { 1, 1, 1, 1, 1, 1, 1 },
                { 1, 1, 1, 3, 1, 1, 1 },
                { 1, 1, 1, 1, 1, 1, 1 },
                { 0, 1, 1, 1, 1, 1, 0 },
                { 0, 0, 1, 1, 1, 0, 0 }
            }
        }

        executeInArea(position, table.random(AREAS), function(pos)
            doSendMagicEffect(pos, EFFECT_RED_SOUND)
        end)

        return true
    end,
    -- 123 Kanto Main 10 passage
    [123] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (isItem(getTileItemById({ x = 5026, y = 491, z = 7 }, 20230)) or getCreatureStorage(cid, 8542) == QUEST_STATUS.UNSTARTED) then
            doTeleportThing(cid, lastPosition)
            return false
        end

        return true
    end,
    -- ?? Kanto Main 12 Wrench warning
--    [0 --[[todo]]] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
--        -- todo storage check
--        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "I need to destroy this strange machine, my pokemon are in there... Maybe that wrench be useful.")
--
--        return true
--    end,
    -- ?? Kanto Main 12 Mewtwo Arena
--    [0 --[[todo]]] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
--         todo storage check
--         check if its already running
--        local mewtwoPos = { x = 2350, y = 0, z = 0 }
--        local mewtwo = doCreateNpc("Mewtwo", mewtwoPos)

--        doCreatureSay(mewtwo, "You could ... What a surprise, but I also have a surprise for you, I cloned all your Pokemon, I will perfected, they are stronger and more vigorous than any other pokemon that you will find, but let's cut to the chase, is time for you to feel the power of my superiority, let's duel.", TALKTYPE_SAY)

--        return true
--    end,
    -- Kanto Main 10 - Rocket Base accesss (needs card)
    [226] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getPlayerItemCountByUnique(cid, 25263) == 0) then
            doTeleportThing(cid, lastPosition)
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return false
        end

        return true
    end,

    -- Event Halloween 2016 - Ed Blackhood Ship
    [231] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (table.find({ NORTH, NORTHEAST, NORTHWEST }, getDirectionTo(fromPosition, toPosition))) then -- Entering
            if (getCreatureStorage(cid, 8697) == QUEST_STATUS.UNSTARTED) then -- Cold Waters faction quest not started
                doSendDistanceShoot(doConcatPositions(getCreaturePosition(cid), { x = 0, y = -7, z = 0 }), getCreaturePosition(cid), PROJECTILE_METAL_BALL)
                doSendMagicEffect(getCreaturePosition(cid), EFFECT_EXPLOSION)
                doCreatureAddStatus(cid, CREATURE_STATUS_SLEEP)
                doTeleportThing(cid, { x = 4214, y = 331, z = 7 })
            end
        else -- Leaving
            doTeleportThing(cid, { x = 4214, y = 331, z = 7 })
        end

        return true
    end,

    -- Kanto Main 10 Police hidding
    [155] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (not getPlayerDefeatedNPC(cid, 9702)) then
            local AREAS = {
                {
                    { 0, 1, 0 },
                    { 1, 3, 1 },
                    { 0, 1, 0 },
                },
                {
                    { 0, 1, 1, 1, 0 },
                    { 1, 1, 1, 1, 1 },
                    { 1, 1, 3, 1, 1 },
                    { 1, 1, 1, 1, 1 },
                    { 0, 1, 1, 1, 0 }
                },
                {
                    { 0, 0, 1, 1, 1, 0, 0 },
                    { 0, 1, 1, 1, 1, 1, 0 },
                    { 1, 1, 1, 1, 1, 1, 1 },
                    { 1, 1, 1, 3, 1, 1, 1 },
                    { 1, 1, 1, 1, 1, 1, 1 },
                    { 0, 1, 1, 1, 1, 1, 0 },
                    { 0, 0, 1, 1, 1, 0, 0 }
                }
            }

            executeInArea(position, table.random(AREAS), function(pos)
                doSendMagicEffect(pos, EFFECT_PURPLE_SOUND)
                local npc = getNpcAtPosition(pos, "Police Officer")
                if (npc) then
                    local destination = { x = 5032, y = 601, z = 8 }
                    doCreatureSay(npc, "Hey! You!", TALKTYPE_SAY)
                    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You were caught!")
                    doSendMagicEffect(destination, EFFECT_TELEPORT_DOWN)
                    doSendMagicEffect(position, EFFECT_TELEPORT_DOWN)
                    doSendMagicEffect(pos, EFFECT_EMOTION_EXCLAMATION)
                    doTeleportThing(cid, destination)
                end
            end)
        end

        return true
    end,
    -- 156 Kanto Main 11 Dragonite Message at Bill
    [156] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (getCreatureStorage(cid, 8555) == QUEST_STATUS.STARTED and
                getCreatureStorage(cid, 8556) ~= QUEST_STATUS.FINISHED) then

            doCreatureSetNoMove(cid, true)
            local dragonitePos = { x = 4021, y = 151, z = 6 }
            local dragonite = doCreateNpc("Paarthurnax", dragonitePos)
            local dragoniteFollowPos = getPositionAdjacent(dragonite, getCreaturePosition(cid), true)
            doSendMagicEffect(dragonitePos, EFFECT_TELEPORT_DOWN)
            doCreatureWalkToPosition(dragonite, dragoniteFollowPos)

            local doWork
            doWork = function(backing)
                if (not backing) then
                    if (getDistanceBetween(getCreaturePosition(dragonite), dragoniteFollowPos) <= 1) then
                        doPlayerSafeAddItem(cid, 25192, 1, true, true)
                        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received an invitation in your inventory! Read it for more information.")
                        backing = true
                        doCreatureWalkToPosition(dragonite, dragonitePos)
                        doCreatureSetStorage(cid, 8556, QUEST_STATUS.FINISHED)
                        doCreatureSetNoMove(cid, false)
                        doSendDistanceShoot(getCreaturePosition(dragonite), getCreaturePosition(cid), PROJECTILE_GRAVEL)
                    end
                elseif (getDistanceBetween(getCreaturePosition(dragonite), dragonitePos) <= 1) then
                    doSendMagicEffect(dragonitePos, EFFECT_TELEPORT_UP)
                    doRemoveCreature(dragonite)
                    return
                end

                addEvent(doWork, 500, backing)
            end
            doWork(false)

            return false
        end

        return true
    end,
    [159] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        return doTeleportThing(cid, { x = 5523, y = 195, z = 6 })
    end,
    [160] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        return doTeleportThing(cid, table.random({
            { x = 5509, y = 221, z = 5 },
            { x = 5509, y = 221, z = 5 },
            { x = 5550, y = 221, z = 5 },
            { x = 5497, y = 231, z = 5 },
            { x = 5509, y = 231, z = 5 },
            { x = 5538, y = 231, z = 5 },
            { x = 5538, y = 231, z = 5 },
            { x = 5523, y = 236, z = 5 }
        }))
    end,
    [161] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        return doTeleportThing(cid, table.random({
            { x = 5523, y = 197, z = 4 },
            { x = 5519, y = 199, z = 4 },
            { x = 5527, y = 199, z = 4 },
            { x = 5523, y = 204, z = 4 },
            { x = 5519, y = 208, z = 4 },
            { x = 5527, y = 208, z = 4 },
            { x = 5523, y = 211, z = 4 },
            { x = 5503, y = 213, z = 4 },
            { x = 5543, y = 213, z = 4 },
            { x = 5513, y = 216, z = 4 },
            { x = 5533, y = 216, z = 4 },
            { x = 5523, y = 218, z = 4 },
            { x = 5508, y = 221, z = 4 },
            { x = 5508, y = 221, z = 4 },
            { x = 5527, y = 221, z = 4 },
            { x = 5538, y = 221, z = 4 },
            { x = 5494, y = 226, z = 4 },
            { x = 5500, y = 226, z = 4 },
            { x = 5506, y = 226, z = 4 },
            { x = 5512, y = 226, z = 4 },
            { x = 5506, y = 226, z = 4 },
            { x = 5534, y = 226, z = 4 },
            { x = 5546, y = 226, z = 4 },
            { x = 5552, y = 226, z = 4 },
            { x = 5508, y = 231, z = 4 },
            { x = 5519, y = 231, z = 4 },
            { x = 5527, y = 231, z = 4 },
            { x = 5538, y = 231, z = 4 },
            { x = 5513, y = 236, z = 4 },
            { x = 5513, y = 236, z = 4 },
            { x = 5513, y = 236, z = 4 },
            { x = 5533, y = 236, z = 4 },
            { x = 5523, y = 241, z = 4 },
            { x = 5543, y = 239, z = 4 },
            { x = 5519, y = 244, z = 4 },
            { x = 5523, y = 248, z = 4 },
            { x = 5527, y = 244, z = 4 },
            { x = 5527, y = 244, z = 4 },
            { x = 5523, y = 255, z = 4 },
            { x = 5527, y = 253, z = 4 },
            { x = 5520, y = 226, z = 4 }
        }))
    end,
    -- todo Main Kanto 12 - Possessed Joy act start
    [210] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (kantoMain12Actioning or not getPlayerDefeatedNPC(cid, 9703)) then -- Not defeated Giovanni yet
            return true
        end

        if (getCreatureStorage(cid, 8653) == QUEST_STATUS.FINISHED) then -- Already complete this act
            if (getCreatureStorage(cid, 8558) ~= QUEST_STATUS.FINISHED) then -- But not take the key, sometimes slow players make this and so the quest freeze. This also happens if a player defeat Mewtwo and another player start the act (?).
                doPlayerSafeAddItem(cid, 25195, 1, true, true)
                doCreatureSetStorage(cid, 8558, QUEST_STATUS.FINISHED)
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The key was taken!")
            end

            return true
        end

        kantoMain12Actioning = true

        local mewtwoId
        local nurseId = getNpcAtPosition({ x = 5523, y = 230, z = 6 }, "Possessed Joy")
        local actions = {
            {
                action = function()
                    local npcs = {
                        ["Ash Ketchum"] = { originalPosition = { x = 5517, y = 237, z = 6 }, targetPosition = { x = 5517, y = 237, z = 6 } },
                        ["Ash's Pikachu"] = { originalPosition = { x = 5515, y = 239, z = 6 }, targetPosition = { x = 5523, y = 235, z = 6 } },
                        ["Ash's Charizard"] = { originalPosition = { x = 5518, y = 236, z = 6 }, targetPosition = { x = 5522, y = 237, z = 6 } },
                        ["Ash's Muk"] = { originalPosition = { x = 5516, y = 237, z = 6 }, targetPosition = { x = 5518, y = 237, z = 6 } },
                        ["Ash's Kingler"] = { originalPosition = { x = 5518, y = 237, z = 6 }, targetPosition = { x = 5524, y = 237, z = 6 } },
                        ["Ash's Squirtle"] = { originalPosition = { x = 5519, y = 238, z = 6 }, targetPosition = { x = 5521, y = 236, z = 6 } },
                        ["Ash's Bulbasaur"] = { originalPosition = { x = 5517, y = 238, z = 6 }, targetPosition = { x = 5526, y = 235, z = 6 } },
                        ["Fergus"] = { originalPosition = { x = 5526, y = 235, z = 6 }, targetPosition = { x = 5526, y = 234, z = 6 } },
                        ["Fergus's Vaporeon"] = { originalPosition = { x = 5515, y = 242, z = 6 }, targetPosition = { x = 5524, y = 235, z = 6 } },
                        ["Fergus's Golduck"] = { originalPosition = { x = 5517, y = 242, z = 6 }, targetPosition = { x = 5523, y = 236, z = 6 } },
                        ["Fergus's Gyarados"] = { originalPosition = { x = 5516, y = 243, z = 6 }, targetPosition = { x = 5516, y = 243, z = 6 } },
                        ["Fergus's Nidoqueen"] = { originalPosition = { x = 5517, y = 245, z = 6 }, targetPosition = { x = 5526, y = 237, z = 6 } },
                        ["Fergus's Seadra"] = { originalPosition = { x = 5514, y = 244, z = 6 }, targetPosition = { x = 5519, y = 236, z = 6 } },
                        ["Fergus's Tentacruel"] = { originalPosition = { x = 5515, y = 245, z = 6 }, targetPosition = { x = 5525, y = 237, z = 6 } },
                        ["Corey"] = { originalPosition = { x = 5529, y = 237, z = 6 }, targetPosition = { x = 5522, y = 234, z = 6 } },
                        ["Corey's Scyther"] = { originalPosition = { x = 5530, y = 237, z = 6 }, targetPosition = { x = 5530, y = 237, z = 6 } },
                        ["Corey's Rhyhorn"] = { originalPosition = { x = 5525, y = 237, z = 6 }, targetPosition = { x = 5523, y = 237, z = 6 } },
                        ["Corey's Hitmonlee"] = { originalPosition = { x = 5523, y = 237, z = 6 }, targetPosition = { x = 5525, y = 236, z = 6 } },
                        ["Corey's Sandslash"] = { originalPosition = { x = 5528, y = 238, z = 6 }, targetPosition = { x = 5526, y = 236, z = 6 } },
                        ["Corey's Venusaur"] = { originalPosition = { x = 5531, y = 238, z = 6 }, targetPosition = { x = 5521, y = 237, z = 6 } },
                        ["Corey's Pidgeot"] = { originalPosition = { x = 5527, y = 235, z = 6 }, targetPosition = { x = 5527, y = 235, z = 6 } },
                        ["Brock"] = { originalPosition = { x = 5521, y = 247, z = 6 }, targetPosition = { x = 5521, y = 247, z = 6 } },
                        ["Brock's Geodude"] = { originalPosition = { x = 5521, y = 247, z = 6 }, targetPosition = { x = 5522, y = 246, z = 6 } },
                        ["Brock's Zubat"] = { originalPosition = { x = 5519, y = 246, z = 6 }, targetPosition = { x = 5519, y = 246, z = 6 } },
                        ["Brock's Onix"] = { originalPosition = { x = 5520, y = 247, z = 6 }, targetPosition = { x = 5527, y = 237, z = 6 } },
                        ["Brock's Pineco"] = { originalPosition = { x = 5522, y = 248, z = 6 }, targetPosition = { x = 5522, y = 236, z = 6 } },
                        ["Brock's Sudowoodo"] = { originalPosition = { x = 5519, y = 249, z = 6 }, targetPosition = { x = 5528, y = 236, z = 6 } },
                        ["Misty"] = { originalPosition = { x = 5527, y = 249, z = 6 }, targetPosition = { x = 5525, y = 234, z = 6 } },
                        ["Misty's Psyduck"] = { originalPosition = { x = 5528, y = 246, z = 6 }, targetPosition = { x = 5525, y = 235, z = 6 } },
                        ["Misty's Poliwhirl"] = { originalPosition = { x = 5525, y = 235, z = 6 }, targetPosition = { x = 5525, y = 247, z = 6 } },
                        ["Misty's Goldeen"] = { originalPosition = { x = 5525, y = 247, z = 6 }, targetPosition = { x = 5527, y = 248, z = 6 } },
                        ["Misty's Starmie"] = { originalPosition = { x = 5525, y = 247, z = 6 }, targetPosition = { x = 5519, y = 235, z = 6 } },
                        ["Misty's Staryu"] = { originalPosition = { x = 5525, y = 247, z = 6 }, targetPosition = { x = 5518, y = 236, z = 6 } },
                        ["Misty's Togepi"] = { originalPosition = { x = 5529, y = 248, z = 6 }, targetPosition = { x = 5522, y = 238, z = 6 } },
                        ["Neesha"] = { originalPosition = { x = 5532, y = 244, z = 6 }, targetPosition = { x = 5524, y = 234, z = 6 } },
                        ["Neesha's Rapidash"] = { originalPosition = { x = 5529, y = 243, z = 6 }, targetPosition = { x = 5520, y = 235, z = 6 } },
                        ["Neesha's Vileplume"] = { originalPosition = { x = 5531, y = 242, z = 6 }, targetPosition = { x = 5520, y = 235, z = 6 } },
                        ["Neesha's Dewgong"] = { originalPosition = { x = 5531, y = 243, z = 6 }, targetPosition = { x = 5529, y = 237, z = 6 } },
                        ["Neesha's Ninetales"] = { originalPosition = { x = 5530, y = 244, z = 6 }, targetPosition = { x = 5528, y = 237, z = 6 } },
                        ["Neesha's Wigglytuff"] = { originalPosition = { x = 5530, y = 246, z = 6 }, targetPosition = { x = 5525, y = 238, z = 6 } },
                        ["Neesha's Blastoise"] = { originalPosition = { x = 5532, y = 246, z = 6 }, targetPosition = { x = 5532, y = 246, z = 6 } },
                    }

                    for k, v in pairs(getSpectators({ x = 5523, y = 243, z = 6 }, 20, 20)) do
                        if (isNpc(v) and npcs[getCreatureName(v)]) then
                            local dest = npcs[getCreatureName(v)].targetPosition
                            doTeleportThing(v, dest)
                            doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
                            doCreatureSetLookDirection(v, NORTH)
                        end
                    end

                    doCreatureSetNoMove(cid, true)
                    doMutePlayer(cid, 60)
                    setPlayerBlockLogout(cid, true)
                end,
                delay = 0
            },
            {
                action = function()
                    doCreatureSay(nurseId, "You will know my master, the biggest pokemon world trainer.", TALKTYPE_SAY)
                end,
                delay = 1000
            },
            {
                action = function()
                    local mewtwoPos = { x = 5523, y = 231, z = 6 }
                    mewtwoId = doCreateNpc("Mewtwo", mewtwoPos)
                    doSendMagicEffect(mewtwoPos, EFFECT_TELEPORT_FRAME)
                end,
                delay = 4000
            },
            {
                action = function()
                    doCreatureSay(nurseId, "This is the master of New Island and soon will be worldwide, Mewtwo.", TALKTYPE_SAY)
                end,
                delay = 8000
            },
            {
                action = function()
                    doCreatureSay(nurseId, "Humans. You are before your new master.", TALKTYPE_SAY)
                    doCreatureSay(mewtwoId, "Humans. You are before your new master.", TALKTYPE_SAY)
                end,
                delay = 12000
            },
            {
                action = function()
                    doCreatureSetLookDirection(mewtwoId, NORTH)
                    doCreatureSay(mewtwoId, "You usefulness has ended.", TALKTYPE_SAY)
                end,
                delay = 16000
            },
            {
                action = function()
                    local pos = getCreaturePosition(nurseId)
                    doSendDistanceShoot(getCreaturePosition(mewtwoId), pos, PROJECTILE_GRAVEL)
                    doSendMagicEffect(pos, EFFECT_PURPLE_ENERGY_BALL)
                    doRemoveCreature(nurseId)
                    doCreateItem(25194, 1, pos)
                end,
                delay = 20000
            },
            {
                action = function()
                    doCreatureSetLookDirection(mewtwoId, SOUTH)
                    doCreatureSay(mewtwoId, "I am the new master of earth, the master of humans and also of Pokemon.", TALKTYPE_SAY)
                end,
                delay = 24000
            },
            {
                action = function()
                    doCreatureSay(mewtwoId, "You humans are a dangerous species, always looking for destruction and this quest you brought me into this world with the sole purpose of turning me into a slave, but now I have my own goal.", TALKTYPE_SAY)
                end,
                delay = 30000
            },
            {
                action = function()
                    doCreatureSay(mewtwoId, "I will create my own world at the cost of destruction of you, no one will be spared, not even your Pokemon, they fell into disgrace to serve humans. Soon you will see my greatest achievement.", TALKTYPE_SAY)
                end,
                delay = 37000
            },
            {
                action = function()
                    doCreatureSay(mewtwoId, "How about I give a proof of my power for you in the meantime? Come duel with me trainer.", TALKTYPE_SAY)
                    doCreatureSetStorage(cid, 8653, QUEST_STATUS.FINISHED)
                    doCreatureSetNoMove(cid, false)
                    setPlayerBlockLogout(cid, false)
                    kantoMain12Actioning = nil
                end,
                delay = 44000
            },
            {
                action = function()
                    doCreateNpc("Possessed Joy", { x = 5523, y = 230, z = 6 })
                end,
                delay = 10 * 60 * 1000
            }
        }

        for k, v in pairs(actions) do
            addEvent(v.action, v.delay)
        end

        return true
    end,
    --
    -- Main Kanto last part
    [162] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (kantoMain12FinalActioning) then
            return true
        end

        for v = 8659, 8664 do
            if (getCreatureStorage(cid, v) ~= QUEST_STATUS.FINISHED) then
                return true
            end
        end

        if (getAlreadyNpcAround({ x = 5571, y = 222, z = 6 }, "Mewtwo")) then
            return true
        end

        kantoMain12FinalActioning = true
        -- todo check storages

        local mewtwoId
        local actions = {
            {
                action = function()
                    local mewtwoPos = { x = 5571, y = 222, z = 6 }
                    mewtwoId = doCreateNpc("Mewtwo", mewtwoPos)
                    doSendMagicEffect(mewtwoPos, EFFECT_TELEPORT_FRAME)
                end,
                delay = 0
            },
            {
                action = function()
                    doCreatureSay(mewtwoId, "You could... What a surprise, but I also have a suppressed for you, I cloned all your Pokemon, they were perfected, they are stronger and more vigorous than any other Pokemon that you will find, but let's cut to the chase, is time for you to feel the power of my superiority, let's duel.", TALKTYPE_SAY)
                end,
                delay = 4000
            },
            {
                action = function() kantoMain12FinalActioning = false end,
                delay = 60000
            }
        }

        for k, v in pairs(actions) do
            addEvent(v.action, v.delay)
        end

        return true
    end,
    [300] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial #1
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "001-door")
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, __L(cid, "My name is Red and I will be your guide on these first steps in the Pokemon world. Now exit your room and look for the exit of the house."))
        doSendMagicEffect({x = 5007, y = 808, z = 7}, EFFECT_TUTORIAL_ARROW)
        doSendMagicEffect({x = 5007, y = 808, z = 7}, EFFECT_TUTORIAL_SQUARE)
        return true
    end,
    [301] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial #2
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, string.format(__L(cid, "Very well! Now go to the lab of Prof. Oak to acquire your first Pokemon."), getCreatureName(cid)))
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "") -- Hide
        return true
    end,
    [302] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial #3
        if (getCreatureStorage(cid, 8751) ~= QUEST_STATUS.FINISEHD and table.find({ NORTH, NORTHEAST, NORTHWEST }, getDirectionTo(fromPosition, toPosition))) then -- Entering
            local oak = getNpcAtPosition({x = 5020, y = 788, z = 7}, "Professor Oak")
            if (isNpc(oak)) then
                doCreatureSay(oak, string.format(__L(cid, "Hello %s, welcome to my lab! My name is Oak, I'm a researcher fascinated by the Pokemon world... I see that your big day has arrived, are you ready to receive your first Pokemon?"), getCreatureName(cid)), TALKTYPE_SAY)
            end
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, "") -- Hide
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "009-talk")
        end
        return true
    end,
    [305] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial #4
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, __L(cid, "Now pay close attention! You will enter your first Pokemon battle! First you must select your target, according to the image. After that, you must order your Pokemon, making it use his moves against the target you have selected. You can do this by clicking on the Move Window OR using the hotkeys F1, F2, F3, and so on."))
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "005-target")
        return true
    end,
    [303] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial #5
        if (getCreatureStorage(cid, 8753) ~= QUEST_STATUS.FINISHED) then
            doTeleportThing(cid, lastPosition)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You should speak to Professor Oak before proceeding.")
            return false
        end
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, __L(cid, "You've made great progress, congratulations! Now do as Professor said, go to PokeMart to negotiate with the seller."))
        return true
    end,
    [306] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial #6
        --    doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "00?-pokemart")
        return true
    end,
    [304] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial Check
        if (getCreatureStorage(cid, 8755) ~= QUEST_STATUS.FINISHED) then
            doTeleportThing(cid, lastPosition)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You need to negotiate at PokeMart before proceeding.")
            return false
        end
        return true
    end,
    [307] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial
        doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "005-target")
        return true
    end,
    [308] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial
        if (getCreatureStorage(cid, 8755) ~= QUEST_STATUS.FINISHED) then -- Gameplay Tutorial Sell Quest
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "010-trade")
        else
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, __L(cid, "You did it, congratulations! Now go north, I'm waiting for you."))
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "") -- hide
        end
        return true
    end,
    [309] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial
        if (getCreatureStorage(cid, 8753) == QUEST_STATUS.STARTED and getCreatureStorage(cid, 8754) >= 5) then
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_TEXT, "") -- Hide
            doSendPlayerExtendedOpcode(cid, EXTENDED_IDS.GAMEPLAY_TUTORIAL_IMAGE, "") -- hide
        end
        return true
    end,
    [310] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor) -- Gameplay Tutorial
        if (getPlayerLevel(cid) >= 10) then
            doTeleportThing(cid, {x = 5025, y = 785, z = 7})
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Now you must talk to Professor Oak to continue your adventure.")
            return false
        end
        return true
    end,
}

local ACTS = {
    -- London Hamnet quest #03 - Moving the Weezing
    [103] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        if (isNpc(cid)) then -- London Hamnet quest #03
            local spec = getSpectators(position, 2, 2)
            if (spec) then
                for k, v in pairs(spec) do
                    if (isMonster(v)) then
                        return
                    end
                end
            end

            if (getRandom(1, 2) == 1) then
                doSendMagicEffect(position, EFFECT_TELEPORT_DOWN)
                doCreateMonster("Felon Raticate", position)
            end
        end

        return true
    end,
    [104] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        local positions = {
            -- Horizontal
            { fromId = 20228, toId = 20227, delay = 1, increaseX = true },
            { fromId = 20227, toId = 20126, delay = 250, increaseX = true },
            -- Vertical
            { fromId = 20230, toId = 20229, delay = 1 },
            { fromId = 20229, toId = 20133, delay = 250 },
        }

        local positionsRequires = {
            -- Rocket Base - Celadon - Open/Close Door
            { x = 2681, y = 470, z = 7, itemId = 23544 },
            { x = 2682, y = 470, z = 7, itemId = 23544 },
            -- todo kanto main 10 restriction
        }

        if (isPlayer(cid)) then
            for _, pos in pairs(positionsRequires) do
                if (getSamePosition(pos, position)) then
                    if (getPlayerItemCount(cid, pos.itemId) <= 0) then
                        doTeleportThing(cid, lastPosition, true)
                        return true
                    end
                end
            end
        end

        for _, pos in pairs(positions) do
            addEvent(function()
                for i = 1, 2 do
                    local tmpPosition = doConcatPositions(table.copy(position), pos.increaseX and { x = i } or
                            { y = i })
                    local item = getTileItemById(tmpPosition, pos.fromId)
                    if (isItem(item)) then
                        doTransformItem(item.uid, pos.toId)
                        break
                    end
                end
            end, pos.delay)
        end

        return true
    end,

    -- Pokemon Center / PokeMart automatic doors
    [110] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        local positions = {
            -- Horizontal
            { fromId = 24305, toId = 24304, delay = 1, increaseX = true },
            { fromId = 24304, toId = 24303, delay = 250, increaseX = true },
            { fromId = 24303, toId = 24302, delay = 500, increaseX = true },
            --{fromId = 24302, toId = 24303, delay = 750, increaseX = true},
            --{fromId = 24303, toId = 24304, delay = 1000, increaseX = true},
            --{fromId = 24304, toId = 24305, delay = 1250, increaseX = true},

            { fromId = 24589, toId = 24586, delay = 1, increaseX = true },
            { fromId = 24586, toId = 24583, delay = 250, increaseX = true },
            { fromId = 24583, toId = 24578, delay = 500, increaseX = true },
            --{fromId = 24578, toId = 24583, delay = 750, increaseX = true},
            --{fromId = 24583, toId = 24586, delay = 1000, increaseX = true},
            --{fromId = 24586, toId = 24589, delay = 1250, increaseX = true},

            { fromId = 24121, toId = 24120, delay = 1, increaseX = true },
            { fromId = 24120, toId = 24119, delay = 250, increaseX = true },
            { fromId = 24119, toId = 24118, delay = 500, increaseX = true },
            --{fromId = 24118, toId = 24119, delay = 750, increaseX = true},
            --{fromId = 24119, toId = 24120, delay = 1000, increaseX = true},
            --{fromId = 24120, toId = 24121, delay = 1250, increaseX = true},
            -- Vertical
            { fromId = 24588, toId = 24585, delay = 1 },
            { fromId = 24585, toId = 24582, delay = 250 },
            { fromId = 24582, toId = 24577, delay = 500 },
            --{fromId = 24577, toId = 24582, delay = 750},
            --{fromId = 24582, toId = 24585, delay = 1000},
            --{fromId = 24585, toId = 24588, delay = 1250},

            { fromId = 24587, toId = 24584, delay = 1 },
            { fromId = 24584, toId = 24579, delay = 250 },
            { fromId = 24579, toId = 24576, delay = 500 },
            --{fromId = 24576, toId = 24579, delay = 750},
            --{fromId = 24579, toId = 24584, delay = 1000},
            --{fromId = 24584, toId = 24587, delay = 1250},
        }

        for _, pos in pairs(positions) do
            addEvent(function()
                for i = 1, 6 do
                    local tmpPosition = doConcatPositions(table.copy(position), pos.increaseX and { x = i } or
                            { y = i })
                    local item = getTileItemById(tmpPosition, pos.fromId)
                    if (isItem(item)) then
                        doTransformItem(item.uid, pos.toId)
                        break
                    end
                end
            end, pos.delay)
        end

        return true
    end,
}

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (ACTS[item.actionid]) then
        return ACTS[item.actionid](cid, item, position, lastPosition, fromPosition, toPosition, actor)
    end

    if (isPlayer(cid) and ACTS_ONLY_PLAYER[item.actionid]) then
        return ACTS_ONLY_PLAYER[item.actionid](cid, item, position, lastPosition, fromPosition, toPosition, actor)
    end

    return true
end

local ACTS_OUT = {
    -- Rocket Base - Celadon - Open/Close Door
    [104] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        local positions = {
            -- Horizontal
            {
                fromId = 20126,
                toId = 20227,
                delay = 10,
                increaseX = true,
                checkCreatures = { { x = -1 }, { x = -1 } }
            },
            {
                fromId = 20227,
                toId = 20228,
                delay = 350,
                increaseX = true,
                checkCreatures = { { x = -1 }, { x = -1 } }
            },
            -- Vertical
            {
                fromId = 20133,
                toId = 20229,
                delay = 10,
                checkCreatures = { { y = -1 }, { y = -1 } }
            },
            {
                fromId = 20229,
                toId = 20230,
                delay = 350,
                checkCreatures = { { y = -1 }, { y = -1 } }
            },
        }

        for _, pos in pairs(positions) do
            addEvent(function()
                for i = 1, 2 do
                    local tmpPosition = doConcatPositions(table.copy(position), pos.increaseX and { x = i } or
                            { y = i })
                    local item = getTileItemById(tmpPosition, pos.fromId)
                    if (isItem(item)) then
                        for __, posMod in pairs(pos.checkCreatures) do
                            tmpPosition = doConcatPositions(tmpPosition, posMod)

                            if (isCreature(getTopCreature(tmpPosition).uid)) then
                                return
                            end
                        end


                        doTransformItem(item.uid, pos.toId)
                        break
                    end
                end
            end, pos.delay)
        end

        return true
    end,

    -- Pokemon Center depots
    [109] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        CP_MACHINE.animateMachine(position, nil, false)
        return true
    end,

    -- Pokemon Center / PokeMart automatic doors
    [110] = function(cid, item, position, lastPosition, fromPosition, toPosition, actor)
        local positions = {
            -- Horizontal
            { fromId = 24302, toId = 24303, delay = 1, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            { fromId = 24303, toId = 24304, delay = 1, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            { fromId = 24304, toId = 24305, delay = 250, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            --{fromId = 24302, toId = 24303, delay = 750, increaseX = true},
            --{fromId = 24303, toId = 24304, delay = 1000, increaseX = true},
            --{fromId = 24304, toId = 24305, delay = 1250, increaseX = true},

            { fromId = 24578, toId = 24583, delay = 1, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            { fromId = 24583, toId = 24586, delay = 250, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            { fromId = 24586, toId = 24589, delay = 500, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            --{fromId = 24578, toId = 24583, delay = 750, increaseX = true},
            --{fromId = 24583, toId = 24586, delay = 1000, increaseX = true},
            --{fromId = 24586, toId = 24589, delay = 1250, increaseX = true},

            { fromId = 24118, toId = 24119, delay = 1, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            { fromId = 24119, toId = 24120, delay = 250, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            { fromId = 24120, toId = 24121, delay = 500, increaseX = true, checkCreatures = { { x = -1 }, { x = -1 } } },
            --{fromId = 24118, toId = 24119, delay = 750, increaseX = true},
            --{fromId = 24119, toId = 24120, delay = 1000, increaseX = true},
            --{fromId = 24120, toId = 24121, delay = 1250, increaseX = true},
            -- Vertical
            { fromId = 24577, toId = 24582, delay = 1, checkCreatures = { { y = -1 }, { y = -1 } } },
            { fromId = 24582, toId = 24585, delay = 250, checkCreatures = { { y = -1 }, { y = -1 } } },
            { fromId = 24585, toId = 24588, delay = 500, checkCreatures = { { y = -1 }, { y = -1 } } },
            --{fromId = 24577, toId = 24582, delay = 750},
            --{fromId = 24582, toId = 24585, delay = 1000},
            --{fromId = 24585, toId = 24588, delay = 1250},

            { fromId = 24576, toId = 24579, delay = 1, checkCreatures = { { y = -1 }, { y = -1 } } },
            { fromId = 24579, toId = 24584, delay = 250, checkCreatures = { { y = -1 }, { y = -1 } } },
            { fromId = 24584, toId = 24587, delay = 500, checkCreatures = { { y = -1 }, { y = -1 } } },
            --{fromId = 24576, toId = 24579, delay = 750},
            --{fromId = 24579, toId = 24584, delay = 1000},
            --{fromId = 24584, toId = 24587, delay = 1250},
        }

        for _, pos in pairs(positions) do
            addEvent(function()
                for i = 1, 2 do
                    local tmpPosition = doConcatPositions(table.copy(position), pos.increaseX and { x = i } or
                            { y = i })
                    local item = getTileItemById(tmpPosition, pos.fromId)
                    if (isItem(item)) then
                        for __, posMod in pairs(pos.checkCreatures) do
                            tmpPosition = doConcatPositions(tmpPosition, posMod)

                            if (isCreature(getTopCreature(tmpPosition).uid)) then
                                return
                            end
                        end


                        doTransformItem(item.uid, pos.toId)
                        break
                    end
                end
            end, pos.delay)
        end

        return true
    end,
}

local ACTS_OUT_ONLY_PLAYER = {}

function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (ACTS_OUT[item.actionid]) then
        return ACTS_OUT[item.actionid](cid, item, position, lastPosition, fromPosition, toPosition, actor)
    end

    if (isPlayer(cid) and ACTS_OUT_ONLY_PLAYER[item.actionid]) then
        return ACTS_OUT_ONLY_PLAYER[item.actionid](cid, item, position, lastPosition, fromPosition, toPosition, actor)
    end

    return true
end
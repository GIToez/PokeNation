local RED = 14805
local BLUE = 14806

local ROOMS = {
    {x = 3969, y = 475, z = 10},
    {x = 3969, y = 480, z = 10},
    {x = 3978, y = 468, z = 10},
    {x = 3977, y = 474, z = 10},
    {x = 3978, y = 480, z = 10},
    {x = 3978, y = 487, z = 10},
    {x = 3986, y = 468, z = 10},
    {x = 3986, y = 485, z = 10},
    {x = 3995, y = 468, z = 10},
    {x = 3995, y = 486, z = 10},
}
local FINAL_ROOM = {x = 3998, y = 477, z = 10}

local paths = {
    {
        [RED] = {
            [100] = ROOMS[1],
            [102] = ROOMS[4],
            [108] = ROOMS[6],
            [111] = ROOMS[7],
            [113] = FINAL_ROOM,
            rooms = {ROOMS[1], ROOMS[4], ROOMS[6], ROOMS[7]}
        },
    },

    {
        [BLUE] = {
            [100] = ROOMS[2],
            [103] = ROOMS[4],
            [107] = ROOMS[5],
            [109] = ROOMS[8],
            [116] = FINAL_ROOM,
            rooms = {ROOMS[2], ROOMS[4], ROOMS[5], ROOMS[8]}
        }
    },

    {
        [RED] = {
            [100] = ROOMS[3],
            [105] = ROOMS[2],
            [104] = ROOMS[8],
            [116] = ROOMS[9],
            [118] = FINAL_ROOM,
            rooms = {ROOMS[3], ROOMS[2], ROOMS[8], ROOMS[9]}
        },
    },

    {
        [BLUE] = {
            [100] = ROOMS[1],
            [101] = ROOMS[6],
            [112] = ROOMS[4],
            [107] = ROOMS[9],
            [117] = FINAL_ROOM,
            rooms = {ROOMS[1], ROOMS[6], ROOMS[4], ROOMS[9]}
        }
    },
}

local currentPath = {}

local function updatePath()
    currentPath = table.random(paths)
    local index = currentPath[BLUE] and BLUE or RED

    local remaingRooms = table.copy(ROOMS)
    for _, room in pairs(remaingRooms) do
        if (isInArray(currentPath[index].rooms, room)) then
            table.remove(remaingRooms, _)
        end
    end

    for i = 1, 20 do
        if (not currentPath[index][100 + i]) then
            currentPath[index][100 + i] = table.random(remaingRooms)
        end
    end

    if (not currentPath[RED]) then
        currentPath[RED] = {}
        for i = 0, 21 do
            currentPath[RED][100 + i] = table.random(remaingRooms)
        end

    elseif (not currentPath[BLUE]) then
        currentPath[BLUE] = {}
        for i = 0, 21 do
            currentPath[BLUE][100 + i] = table.random(remaingRooms)
        end
    end
end

local npcs = {
    [101] = 9576,--"Jeanie Santangelo",
    [102] = 9576,--"Jeanie Santangelo",
    [105] = 9577,--"Maricela Boyter",
    [106] = 9577,--"Maricela Boyter",
    [109] = 9580,--"Lonnie Lasko",
    [110] = 9580,--"Lonnie Lasko",
    [111] = 9581,--"Jamie Lesperance",
    [112] = 9581,--"Jamie Lesperance",
    [113] = 9578,--"Clinton Gautreaux",
    [114] = 9578,--"Clinton Gautreaux",
    [117] = 9579,--"Lonnie Pretti",
    [118] = 9579,--"Lonnie Pretti",
    [119] = 9652,--"Clinton Dahlke",
    [120] = 9652,--"Clinton Dahlke",
}

updatePath()
function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid)) then
        return true
    end

    if (item.actionid < 100 or
            (npcs[item.actionid] and not getPlayerDefeatedNPC(cid, npcs[item.actionid]))) then
        doTeleportThing(cid, lastPosition)
        return false
    end

    doTeleportThing(cid, currentPath[item.itemid][item.actionid], false)
    if (currentPath[item.itemid][item.actionid] == FINAL_ROOM) then
        updatePath()
    end

    return false
end


-- TODO: Some rooms are teleporting to themselves
local CUSTOM_ACTIONS = {}
-- CUSTOM_ACTIONS[itemId][actionId] = function(cid, item, fromPosition, itemEx, toPosition) end
CUSTOM_ACTIONS[1249] = {}
CUSTOM_ACTIONS[1252] = {}
CUSTOM_ACTIONS[1259] = {}
CUSTOM_ACTIONS[6907] = {}
CUSTOM_ACTIONS[6898] = {}
CUSTOM_ACTIONS[1257] = {}
CUSTOM_ACTIONS[5735] = {}
CUSTOM_ACTIONS[5114] = {}
CUSTOM_ACTIONS[1255] = {}
CUSTOM_ACTIONS[5103] = {}
CUSTOM_ACTIONS[5278] = {}
CUSTOM_ACTIONS[22811] = {}

local function doorEnter(cid, item, toPosition)
    if (isPokemonOnline(cid)) then -- Try to call Pokemon back
        doPlayerUseBallOnSlot(cid)
    end

    doTransformItem(item.uid, item.itemid + 1)
    doTeleportThing(cid, toPosition)
end

-- Jarrod quest, entrance door
CUSTOM_ACTIONS[1259][301] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8310) ~= QUEST_STATUS.STARTED) then
        return false

    elseif (#getPlayerAllBallsWithPokemon(cid) > 0) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You cannot enter this room while carrying Pokemon.")
        return false
    end

    local pos = { x = 2998, y = 2228, z = 8 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

-- Jarrod quest, exit door
CUSTOM_ACTIONS[1259][300] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8310) ~= QUEST_STATUS.STARTED) then
        return false
    end

    for _, itemid in pairs({ 18622, 18297 }) do
        doPlayerRemoveItem(cid, itemid, getPlayerItemCount(cid, itemid))
    end

    if (getCreatureStorage(cid, 8337) >= 10) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You successfully tested the new poke balls, go see Jarrod now.")
    else
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The experiment is not complete. You must catch more Pokemon!")
    end

    local pos = { x = 2994, y = 2228, z = 8 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

-- Ranger Club TM Substitute Quest
CUSTOM_ACTIONS[6907][300] = function(cid, item, fromPosition, itemEx, toPosition)
    if (not getPlayerDefeatedNPC(cid, 9669)) then
        return false
    end

    local pos = { x = 4900, y = 324, z = 9 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

CUSTOM_ACTIONS[6898][301] = function(cid, item, fromPosition, itemEx, toPosition)
    if (not getPlayerDefeatedNPC(cid, 9670)) then
        return false
    end

    local pos = { x = 4897, y = 319, z = 9 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

CUSTOM_ACTIONS[6907][302] = function(cid, item, fromPosition, itemEx, toPosition)
    if (not getPlayerDefeatedNPC(cid, 9671)) then
        return false
    end

    local pos = { x = 4901, y = 317, z = 9 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

CUSTOM_ACTIONS[6907][303] = function(cid, item, fromPosition, itemEx, toPosition)
    if (not getPlayerDefeatedNPC(cid, 9672)) then
        return false
    end

    local pos = { x = 4902, y = 315, z = 9 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

-- Check if there is a Target Npc up
CUSTOM_ACTIONS[6898][304] = function(cid, item, fromPosition, itemEx, toPosition)
    local check = doGenerateAreaCheckParams(4896, 4909, 271, 279, 8, false)
    local spec = getSpectators(check[1], check[2], check[3], check[4])
    if (spec) then
        for _, v in pairs(spec) do
            if (isNpc(v)) then
                return false
            end
        end
    end

    if (not doPlayerRemoveItem(cid, 18885, getPlayerItemCount(cid, 18885))) then -- Remove remaing target markers
        return false
    end

    local pos = { x = 4903, y = 269, z = 8 }
    doTeleportThing(cid, pos)
    doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
    return true
end

-- Main 7 Door
CUSTOM_ACTIONS[1257][153] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8518) == QUEST_STATUS.UNSTARTED) then
        return false
    end

    doTeleportThing(cid, { x = 3753, y = 437, z = 8 })
    return true
end

CUSTOM_ACTIONS[5735][154] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8517) ~= QUEST_STATUS.STARTED or getCreatureStorage(cid, 8522) == QUEST_STATUS.FINISHED) then -- isnt doing the quest or already done this step
        return false
    end

    if (getPlayerItemCount(cid, 25053) <= 0) then
        doPlayerSendCancel(cid, "You must carry the key to open this door.")
        return false
    end

    local spec = getSpectators(getCreaturePosition(cid), 10, 10, false)
    if (spec) then
        for k, v in pairs(spec) do
            if (isPokemonWild(v)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return false
            end
        end
    end

    local dest = { x = 3748, y = 438, z = 9 }
    local storage = 8521
    if (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED) then
        doTeleportThing(cid, dest)
        return true
    end

    doCreateMonster("Rocket's Weezing", getPositionRandomAdjacent(getCreaturePosition(cid)), false)
    doCreatureSetStorage(cid, storage, QUEST_STATUS.FINISHED)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

-- Kanto Main 9 - After Ditto Boss door
CUSTOM_ACTIONS[5114][225] = function(cid, item, fromPosition, itemEx, toPosition)
    local spec = getSpectators(getCreaturePosition(cid), 20, 20, false)
    if (spec) then
        for k, v in pairs(spec) do
            if (isPokemonWild(v)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                return false
            end
        end
    end

    doorEnter(cid, item, toPosition)
    return true
end

-- Kanto Main 8 - Rocket base entrance
CUSTOM_ACTIONS[1255][100] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getPlayerItemCountByUnique(cid, 25056) == 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    local dest = { x = 5189, y = 514, z = 2 }
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

-- Kanto Main 9 - Pokemon Mansion lab entrance
CUSTOM_ACTIONS[5103][224] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getPlayerItemCountByUnique(cid, 25058) == 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    local dest = { x = 3281, y = 1020, z = 8 }
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

-- Event Christmas Grinch - Door that needs first delivery the saw to the prisioned Officer Jenny
CUSTOM_ACTIONS[5278][172] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8641) ~= QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    local dest = table.find({ NORTH, NORTHEAST, NORTHWEST }, getDirectionTo(getCreaturePosition(cid), toPosition)) and { x = 3935, y = 330, z = 10 } or { x = 3935, y = 332, z = 10 }
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

-- Event Christmas Grinch - Door that needs grinch's key
CUSTOM_ACTIONS[5278][173] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getPlayerItemCountByUnique(cid, 25260) == 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    local dest = table.find({ NORTH, NORTHEAST, NORTHWEST }, getDirectionTo(getCreaturePosition(cid), toPosition)) and { x = 3931, y = 383, z = 10 } or { x = 3931, y = 385, z = 10 }
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

-- Kanto Main 12
CUSTOM_ACTIONS[22811][100] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getPlayerItemCountByUnique(cid, 25195) == 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    local dest = { x = 5516, y = 229, z = 6 }
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

-- Kanto Main 12
CUSTOM_ACTIONS[22811][101] = function(cid, item, fromPosition, itemEx, toPosition)
    if (getPlayerItemCountByUnique(cid, 25195) == 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    local dest = { x = 5530, y = 229, z = 6 }
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

-- Kanto Main 12
CUSTOM_ACTIONS[22811][102] = function(cid, item, fromPosition, itemEx, toPosition)
    for v = 8659, 8664 do
        if (getCreatureStorage(cid, v) ~= QUEST_STATUS.FINISHED) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return false
        end
    end

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
    local dest = { x = 5547, y = 226, z = 5 }
    doTeleportThing(cid, dest)
    doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
    return true
end

local function doCheckRocketBaseDoor(cid, item, position, itemEx, toPosition)
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
                roomCenterPosition = { x = 5193, y = 489, z = 2 },
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
                teleportPosition = { x = 5211, y = 491, z = 2 },
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
                doorPosition = { x = 5219, y = 501, z = 2 },
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
                roomCenterPosition = { x = 5210, y = 519, z = 2 },
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
                teleportPosition = { x = 5214, y = 512, z = 2 },
                roomRangeX = 4,
                roomRangeY = 4
            },
            {
                doorPosition = { x = 5199, y = 495, z = 2 },
                doorClosedItemId = 1252,
                doorOpenItemId = 1254,
                roomCenterPosition = { x = 5211, y = 500, z = 2 },
                teleportPosition = { x = 5214, y = 496, z = 2 },
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

    for newFloor = 3, 7 do
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

    if (roomDoor) then
        local spec = getSpectators(roomDoor.roomCenterPosition, roomDoor.roomRangeX, roomDoor.roomRangeY, false)
        if (spec) then
            for k, v in pairs(spec) do
                if (isPokemonWild(v)) then
                    return false
                end
            end
        end
        doToggleDoor(position, roomDoor.doorOpenItemId, roomDoor.doorClosedItemId)
    end

    return true
end

CUSTOM_ACTIONS[1249][9500] = function(cid, item, fromPosition, itemEx, toPosition)
    return doCheckRocketBaseDoor(cid, item, fromPosition, itemEx, toPosition)
end

CUSTOM_ACTIONS[1252][9500] = function(cid, item, fromPosition, itemEx, toPosition)
    return doCheckRocketBaseDoor(cid, item, fromPosition, itemEx, toPosition)
end


local ACTION_ID_TO_POS = {
    -- Mastery Enter
    [200] = { x = 4295, y = 118, z = 7 },
    [201] = { x = 4298, y = 229, z = 7 },
    [202] = { x = 4248, y = 173, z = 7 },
    [203] = { x = 4349, y = 174, z = 7 },
    [204] = { x = 4346, y = 121, z = 7 },
    [205] = { x = 4350, y = 227, z = 7 },
    [206] = { x = 4247, y = 116, z = 7 },
    [207] = { x = 4249, y = 226, z = 7 },
    [208] = { x = 4298, y = 171, z = 7 },
    -- Mastery Exit
    [209] = { x = 4734, y = 147, z = 7 },
    [210] = { x = 4732, y = 147, z = 7 },
    [211] = { x = 4707, y = 147, z = 7 },
    [212] = { x = 4711, y = 147, z = 7 },
    [213] = { x = 4709, y = 147, z = 7 },
    [214] = { x = 4722, y = 147, z = 7 },
    [215] = { x = 4713, y = 147, z = 7 },
    [216] = { x = 4730, y = 147, z = 7 },
    [217] = { x = 4736, y = 147, z = 7 },
    -- Elite Four
    [218] = { x = 5316, y = 402, z = 7 },
}

local function checkStackpos(item, position)
    position.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
    local thing = getThingFromPos(position)

    position.stackpos = STACKPOS_TOP_FIELD
    local field = getThingFromPos(position)

    return (item.uid == thing.uid or thing.itemid < 100 or field.itemid == 0)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (CUSTOM_ACTIONS[item.itemid] and CUSTOM_ACTIONS[item.itemid][item.actionid]) then
        if (not CUSTOM_ACTIONS[item.itemid][item.actionid](cid, item, fromPosition, itemEx, toPosition)) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
        end
        return true
    end

    if (fromPosition.x ~= CONTAINER_POSITION and isPlayerPzLocked(cid) and getTileInfo(fromPosition).protection) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (item.actionid == 1111) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It is locked.")
        return true
    end

    if (getItemLevelDoor(item.itemid) > 0) then
        if (ACTION_ID_TO_POS[item.actionid]) then
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_BLUE_BUFF)
            doTeleportThing(cid, ACTION_ID_TO_POS[item.actionid])
            doSendMagicEffect(ACTION_ID_TO_POS[item.actionid], EFFECT_BLUE_BUFF)
            return true
        end

        if (item.actionid == 189) then
            if (not isPremium(cid)) then
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
                return true
            end

            doorEnter(cid, item, toPosition)
            return true
        end

        local gender = item.actionid - 186
        if (isInArray({ PLAYERSEX_FEMALE, PLAYERSEX_MALE, PLAYERSEX_GAMEMASTER }, gender)) then
            if (gender ~= getPlayerSex(cid)) then
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
                return true
            end

            doorEnter(cid, item, toPosition)
            return true
        end

        local skull = item.actionid - 180
        if (skull >= SKULL_NONE and skull <= SKULL_BLACK) then
            if (skull ~= getCreatureSkullType(cid)) then
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
                return true
            end

            doorEnter(cid, item, toPosition)
            return true
        end

        local group = item.actionid - 150
        if (group >= 0 and group < 30) then
            if (group > getPlayerGroupId(cid)) then
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
                return true
            end

            doorEnter(cid, item, toPosition)
            return true
        end

        local vocation = item.actionid - 100
        if (vocation >= 0 and vocation < 50) then
            local playerVocationInfo = getVocationInfo(getPlayerVocation(cid))
            if (playerVocationInfo.id ~= vocation and playerVocationInfo.fromVocation ~= vocation) then
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
                return true
            end

            doorEnter(cid, item, toPosition)
            return true
        end

        if (item.actionid == 190 or (item.actionid ~= 0 and getPlayerLevel(cid) >= (item.actionid - getItemLevelDoor(item.itemid)))) then
            doorEnter(cid, item, toPosition)
        else
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")
        end

        return true
    end

    if (isInArray(specialDoors, item.itemid)) then
        if (item.actionid == 100 or (item.actionid ~= 0 and (getPlayerStorageValue(cid, item.actionid) > -1 or getPlayerStorageValue(cid, item.actionid) == -2)) or getPlayerGroupId(cid) == 4 or getPlayerGroupId(cid) == 6) then -- -2 is a fix to work with Battle NPCs
            doorEnter(cid, item, toPosition)
        else
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The door seems to be sealed against unwanted intruders.")
        end

        return true
    end

    if (isInArray(keys, item.itemid)) then
        if (itemEx.actionid > 0) then
            if (item.actionid == itemEx.actionid and doors[itemEx.itemid] ~= nil) then
                --doTransformItem(itemEx.uid, doors[itemEx.itemid])
                doorEnter(cid, itemEx, toPosition)
                return true

            elseif (item.itemid == itemEx.actionid and doors[itemEx.itemid] ~= nil) then
                doorEnter(cid, itemEx, toPosition)
                return true
            end

            doPlayerSendCancel(cid, "The key does not match.")
            return true
        end

        return false
    end

    if (isInArray(horizontalOpenDoors, item.itemid) and checkStackpos(item, fromPosition)) then
        local newPosition = toPosition
        newPosition.y = newPosition.y + 1
        local doorPosition = fromPosition
        doorPosition.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
        local doorCreature = getThingfromPos(doorPosition)
        if (doorCreature.itemid ~= 0) then
            local pzDoorPosition = getTileInfo(doorPosition).protection
            local pzNewPosition = getTileInfo(newPosition).protection
            if ((pzDoorPosition and not pzNewPosition and doorCreature.uid ~= cid) or
                    (not pzDoorPosition and pzNewPosition and doorCreature.uid == cid and isPlayerPzLocked(cid))) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            else
                doTeleportThing(doorCreature.uid, newPosition)
                if (not isInArray(closingDoors, item.itemid)) then
                    doTransformItem(item.uid, item.itemid - 1)
                end
            end

            return true
        end

        doTransformItem(item.uid, item.itemid - 1)
        return true
    end

    if (isInArray(verticalOpenDoors, item.itemid) and checkStackpos(item, fromPosition)) then
        local newPosition = toPosition
        newPosition.x = newPosition.x + 1
        local doorPosition = fromPosition
        doorPosition.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
        local doorCreature = getThingfromPos(doorPosition)
        if (doorCreature.itemid ~= 0) then
            if (getTileInfo(doorPosition).protection and not getTileInfo(newPosition).protection and doorCreature.uid ~= cid) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            else
                doTeleportThing(doorCreature.uid, newPosition)
                if (not isInArray(closingDoors, item.itemid)) then
                    doTransformItem(item.uid, item.itemid - 1)
                end
            end

            return true
        end

        doTransformItem(item.uid, item.itemid - 1)
        return true
    end

    if (doors[item.itemid] ~= nil and checkStackpos(item, fromPosition)) then
        if (item.actionid == 0) then
            doTransformItem(item.uid, doors[item.itemid])
        else
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It is locked.")
        end

        return true
    end

    return false
end

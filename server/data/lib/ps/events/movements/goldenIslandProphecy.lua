local bossName = "Darkness Alakazam"
local roomCenterPosition = {x = 3904, y = 3051, z = 7}
local reallocatePosition = {x = 3901, y = 3057, z = 7}
local stoneItemId = 1551
local stonePositions = {
    {x = 3901, y = 3056, z = 7},
    {x = 3902, y = 3056, z = 7}
}

local events = {}
events[1] = {
    interval = 0,
    command = function()
        for i = 1, 120 do
            addEvent(doSendMagicEffect, (i * 100), {x = roomCenterPosition.x + getRandom(10, -10),
                y = roomCenterPosition.y + getRandom(4, -4), z = roomCenterPosition.z}, EFFECT_DARK_PULSE)
        end
    end
}

events[2] = {
    interval = 10000,
    command = function()
        doCreateMonster(bossName, roomCenterPosition)
    end
}

local cancelEventId = 0
local cancelEvent = function()
    local spec = getSpectators(roomCenterPosition, 15, 10, false)
    if (spec) then
        for k, v in pairs(spec) do
            if (isPokemonWild(v)) then
                doRemoveCreature(v)
            else
                doTeleportThing(v, reallocatePosition)
            end
        end
    end

    for k, v in pairs(stonePositions) do
        local item = getTileItemById(v, stoneItemId)
        if (isItem(item)) then
            doRemoveItem(item.uid)
        end
    end
end

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid)) then
        return true
    end

    -- Free room?
    for k, v in pairs(stonePositions) do
        if (isItem(getTileItemById(v, stoneItemId))) then
            return true
        end
    end

    if (cancelEventId > 0) then
        stopEvent(cancelEventId)
    end

    for k, v in pairs(stonePositions) do
        doRelocate(v, reallocatePosition)
        doCreateItem(stoneItemId, 1, v)
    end

    for k, v in pairs(events) do
        if (v.interval > 0) then
            addEvent(v.command, v.interval)
        else
            v.command()
        end
    end

    cancelEventId = addEvent(cancelEvent, 15 * 60 * 1000)

    return true
end
local ACTIONS = {}
ACTIONS[100] = function(cid, item, fromPosition, itemEx, toPosition)
    local TELEPORT_GROUND_POSITION = {x = 3584, y = 553, z = 10}
    local TELEPORT_TO_POSITION = {x = 3624, y = 529, z = 7}

    local topCreature = getTopCreature(TELEPORT_GROUND_POSITION).uid
    if (isCreature(topCreature)) then
        doTeleportThing(topCreature, TELEPORT_TO_POSITION, false)
        doSendMagicEffect(TELEPORT_GROUND_POSITION, EFFECT_TELEPORT_TWO)
        doSendMagicEffect(TELEPORT_TO_POSITION, EFFECT_TELEPORT_TWO)

    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

ACTIONS[101] = function(cid, item, fromPosition, itemEx, toPosition)
    local player1, player2, player3, player4 = getTopCreature({x = 3550, y = 329, z = 6}).uid, getTopCreature({x = 3550, y = 330, z = 6}).uid, getTopCreature({x = 3550, y = 331, z = 6}).uid, getTopCreature({x = 3550, y = 332, z = 6}).uid
    if (not isPlayer(player1) or not isPlayer(player2) or not isPlayer(player3) or not isPlayer(player4)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

    --elseif (getCreatureStorage(player1, 8023) ~= 0 or getCreatureStorage(player2, 8023) ~= 0 or getCreatureStorage(player3, 8023) ~= 0 or getCreatureStorage(player4, 8023) ~= 0) then -- Not doing quest
        --doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Only the worthy may pass.")

    else
        doTeleportThing(player1, {x = 4796, y = 911, z = 7}, false)
        doTeleportThing(player2, {x = 4796, y = 912, z = 7}, false)
        doTeleportThing(player3, {x = 4796, y = 913, z = 7}, false)
        doTeleportThing(player4, {x = 4796, y = 914, z = 7}, false)
    end
end

ACTIONS[102] = function(cid, item, fromPosition, itemEx, toPosition)
    local topCreature = getTopCreature({x = 4800, y = 937, z = 3}).uid
    if (isCreature(topCreature)) then
        doTeleportThing(topCreature, {x = 3551, y = 331, z = 6}, false)
    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
end

-- baby dungeon door
ACTIONS[103] = function(cid, item, fromPosition, itemEx, toPosition)
    doToggleDoor({x = 4958, y = 367, z = 8}, 1250, 1251)
end

--104 baby dungeon start
ACTIONS[104] = function(cid, item, fromPosition, itemEx, toPosition)
    local positions = {{x = 2954, y = 2227, z = 8}, {x = 2953, y = 2229, z = 8}, {x = 2954, y = 2230, z = 8}}
    local players = {}
    local teleport = true

    for _, pos in pairs(positions) do
        local tmpCid = getTopCreature(pos).uid
        if (not isPlayer(tmpCid) or getCreatureStorage(tmpCid, 8339) ~= QUEST_STATUS.STARTED or
                #getPlayerAllBallsWithPokemon(tmpCid) > 0) then
            teleport = false
            break
        end

        players[#players + 1] = tmpCid
    end

    local spec = getSpectators({x = 4915, y = 394, z = 8}, 40, 37, true)
    if (spec) then
        for _, tmpCid in pairs(spec) do
            if (isPlayer(tmpCid)) then
                teleport = false
                break
            end
        end
    end

    if (teleport) then
        -- Shuffle levers
        local levers = {
            {x = 4926, y = 360, z = 8},
            {x = 4929, y = 360, z = 8},
        }

        for _, pos in pairs(levers) do
            local item = getTileItemById(pos, 1946) -- Lever to right
            if (isItem(item)) then
                doTransformItem(item.uid, 1945) -- Lever to left
            end
        end

        -- Close doors
        local doors = {
            {x = 4934, y = 367, z = 8, openId = 1251, closedId = 1250}, -- vertical
            {x = 4936, y = 393, z = 8, openId = 1254, closedId = 1253}, -- horizontal
            {x = 4958, y = 367, z = 8, openId = 1251, closedId = 1250}, -- vertical
            {x = 4976, y = 363, z = 9, openId = 1254, closedId = 1253}, -- horizontal
            {x = 4978, y = 369, z = 9, openId = 1251, closedId = 1250}, -- vertical
        }

        for _, pos in pairs(doors) do
            local item = getTileItemById(pos, pos.openId)
            if (isItem(item)) then
                doTransformItem(item.uid, pos.closedId)
            end
        end

        for _, tmpCid in pairs(players) do
            doSendMagicEffect(getCreaturePosition(tmpCid), EFFECT_BLUE_BUFF)
            doTeleportThing(tmpCid, {x = 4926, y = 425, z = 8})
            doPlayerSendTextMessage(tmpCid, MESSAGE_EVENT_ADVANCE, "Now you and your partners must find the secret ticket. Good luck!")
        end
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "To enter into this challenge you need three players fit in the correct locations and without any pokemon.")
    end
end

-- OL Main
ACTIONS[105] = function(cid, item, fromPosition, itemEx, toPosition)
    local itemPos = {x = 3677, y = 1652, z = 10}
    local itemId = 1353
    local item = getTileItemById(itemPos, itemId)

    if (isItem(item)) then
        doRemoveItem(item.uid)
    else
        doRelocate(itemPos, {x = 3677, y = 1651, z = 10})
        doCreateItem(itemId, 1, itemPos)
    end

    doSendMagicEffect(itemPos, EFFECT_BIG_ROCK_EXPLOSION)
end

ACTIONS[106] = function(cid, item, fromPosition, itemEx, toPosition)
    local itemPos = {x = 3677, y = 1653, z = 10}
    local itemId = 1304
    local item = getTileItemById(itemPos, itemId)

    if (isItem(item)) then
        doRemoveItem(item.uid)
    else
        doRelocate(itemPos, {x = 3677, y = 1651, z = 10})
        doCreateItem(itemId, 1, itemPos)
    end

    doSendMagicEffect(itemPos, EFFECT_BIG_ROCK_EXPLOSION)
end

ACTIONS[107] = function(cid, item, fromPosition, itemEx, toPosition)
    local itemPos = {x = 3677, y = 1654, z = 10}
    local itemId = 1353
    local item = getTileItemById(itemPos, itemId)

    if (isItem(item)) then
        doRemoveItem(item.uid)
    else
        doRelocate(itemPos, {x = 3677, y = 1651, z = 10})
        doCreateItem(itemId, 1, itemPos)
    end

    doSendMagicEffect(itemPos, EFFECT_BIG_ROCK_EXPLOSION)
end

--108 main 5 dungeon start
ACTIONS[108] = function(cid, item, fromPosition, itemEx, toPosition)
    local positions = {
        {from = {x = 3505, y = 1951, z = 11}, to = {x = 4932, y = 538, z = 4}, center = {x = 4937, y = 514, z = 7}},
        {from = {x = 3508, y = 1949, z = 11}, to = {x = 4921, y = 658, z = 4}, center = {x = 4937, y = 683, z = 7}},
        {from = {x = 3511, y = 1951, z = 11}, to = {x = 4930, y = 616, z = 4}, center = {x = 4937, y = 599, z = 7}}
    }

    local teleport = true
    for _, pos in pairs(positions) do
        local tmpCid = getTopCreature(pos.from).uid
        if (not isPlayer(tmpCid) or getCreatureStorage(tmpCid, 8369) ~= QUEST_STATUS.STARTED) then
            teleport = false
            break
        end

        local spec = getSpectators(pos.center, 38, 39, true)
        if (spec) then
            for _, tmpCid in pairs(spec) do
                if (isPlayer(tmpCid)) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "There are players completing the dungeon at the moment, you must try again later.")
                    return
                end
            end
        end
    end

    if (teleport) then
        for _, pos in pairs(positions) do
            local tmpCid = getTopCreature(pos.from).uid
            doSendMagicEffect(pos.from, EFFECT_BLUE_BUFF)
            doTeleportThing(tmpCid, pos.to)
            setPlayerBlockLogout(tmpCid, true)
        end

    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "To enter into this challenge you need three players fit in the correct locations.")
    end
end

ACTIONS[109] = function(cid, item, fromPosition, itemEx, toPosition)
    local itemPos = {x = 5087, y = 283, z = 4}
    local itemId = 6117
    local item = getTileItemById(itemPos, itemId)

    if (isItem(item)) then
        doRemoveItem(item.uid)
        doSendMagicEffect(itemPos, EFFECT_ELECTRIC_SPARK_TWO)
    end
end

-- Aerodactyl Levers
local flames = {
    {x = 3556, y = 2728, z = 14},
    {x = 3556, y = 2734, z = 14},
    {x = 3553, y = 2727, z = 14},
    {x = 3553, y = 2735, z = 14},
    {x = 3550, y = 2728, z = 14},
    {x = 3550, y = 2734, z = 14},
}

local function checkAerodactylFlames(cid)
    for _, pos in pairs(flames) do
        if (isItem(getTileItemById(pos, 18763))) then
            return
        end
    end

    for _, pos in pairs({{x = 3597, y = 2723, z = 15}, {x = 3598, y = 2723, z = 15}}) do -- Remove electric walls
        local item = getTileItemById(pos, 14811)
        if (isItem(item)) then
            doRemoveItem(item.uid)
        end
    end

    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "A secret entrance has been released!")
end

for i = 1, 31 do -- 31 Levers
    local result

    if (i <= #flames) then
        result = function(cid, item, fromPosition, itemEx, toPosition) -- Remove flames
            local item = getTileItemById(flames[i], 18763)
            if (isItem(item)) then
                doRemoveItem(item.uid)
            end

            doSendAnimatedText(toPosition, "Puff", COLOR_GREY)
            checkAerodactylFlames(cid)
        end

    elseif (i < 24) then -- Damage trap levers
        result = function(cid, item, fromPosition, itemEx, toPosition)
            doCreatureTrueDamage(cid, -(math.floor(getCreatureHealth(cid) * 0.9)), table.random({EFFECT_BIG_EXPLOSION,
                EFFECT_BIG_ROCK_EXPLOSION, EFFECT_POISON_GAS_FOUR}), COLOR_BLACK, fromPosition)

            local spec = getSpectators(fromPosition, 10, 10, false)
            if (spec and #spec > 3) then
                return
            end

            for _ = 1, 3 do
                doCreateMonster("Pristine Kabutops", fromPosition, false)
                doSendMagicEffect(fromPosition, EFFECT_BIG_ROCK_EMERGE)
            end

            doSendAnimatedText(toPosition, "Track", COLOR_GREY)
        end

    else
        result = function(cid, item, fromPosition, itemEx, toPosition) -- Add flames
            local pos = table.random(flames)
            local item = getTileItemById(pos, 18763)
            if (not isItem(item)) then
                doCreateItem(18763, 1, pos)
            end

            doSendAnimatedText(toPosition, "Ship!", COLOR_GREY)
        end
    end

    ACTIONS[109 + i] = result
end

-- Last Lever: 140

ACTIONS[141] = function(cid, item, fromPosition, itemEx, toPosition)
    local positions = {
        {x = 3121, y = 519, z = 6},
        {x = 3122, y = 519, z = 6},
        {x = 3123, y = 519, z = 6},
        {x = 3124, y = 519, z = 6},
        {x = 3125, y = 519, z = 6},
        {x = 3126, y = 519, z = 6},
        {x = 3127, y = 519, z = 6}
    }
    for _, pos in pairs(positions) do
        doRemoveItemTemporarily(pos, 1547, 15)
    end
end

ACTIONS[142] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 1)
end

ACTIONS[143] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 2)
end

ACTIONS[144] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 3)
end

ACTIONS[145] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 4)
end

ACTIONS[146] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 5)
end

ACTIONS[147] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 10)
end

ACTIONS[148] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 9)
end

ACTIONS[149] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 8)
end

ACTIONS[150] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 7)
end

ACTIONS[151] = function(cid, item, fromPosition, itemEx, toPosition)
    EliteFour.SnakeGame.doStart(cid, 6)
end

-- Kanto Main 9 - Rocket base elevator up
ACTIONS[152] = function(cid, item, fromPosition, itemEx, toPosition)
    if (fromPosition.z <= 2) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    --[[local ash = nil
    local spec = getSpectators(fromPosition, 5, 5, false)
    if (spec) then
        for _, tmpCid in pairs(spec) do
            if (isNpc(tmpCid) and getCreatureName(tmpCid) == 'Ash Ketchum' and getCreatureFollowCreature(tmpCid) == cid) then
                ash = tmpCid
                break
            end
        end
    end]]

    fromPosition = getCreaturePosition(cid)
    fromPosition.z = fromPosition.z - 1
    doTeleportThing(cid, fromPosition, false)
    doSendMagicEffect(fromPosition, EFFECT_TELEPORT_DOWN)

    --[[if (ash) then
        doCreatureSetStorage(ash, 1000, 1) -- Ash Teleporting Storage/Flag
        local ashDest = doConcatPositions(getCreaturePosition(ash), {x = 0, y = 0, z = -1})
        doTeleportThing(ash, ashDest, false)
        doSendMagicEffect(ashDest, EFFECT_TELEPORT_DOWN)
		doCreatureFollowCreature(ash, cid)
        doCreatureSetStorage(ash, 1000, nil) -- Ash Teleporting Storage/Flag
    end]]
end

-- Kanto Main 9 - Rocket base elevator down
ACTIONS[153] = function(cid, item, fromPosition, itemEx, toPosition)
    if (fromPosition.z >= 7) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false

    elseif (fromPosition.z == 6 and getPlayerItemCount(cid, 25055) <= 0) then
        doPlayerSendCancel(cid, "You must carry the card key to access this floor.")
        return false
    end

    --[[local ash = nil
    local spec = getSpectators(fromPosition, 5, 5, false)
    if (spec) then
        for _, tmpCid in pairs(spec) do
            if (isNpc(tmpCid) and getCreatureName(tmpCid) == 'Ash Ketchum' and getCreatureFollowCreature(tmpCid) == cid) then
                ash = tmpCid
                break
            end
        end
    end]]

    fromPosition = getCreaturePosition(cid)
    fromPosition.z = fromPosition.z + 1
    doTeleportThing(cid, fromPosition, false)
    doSendMagicEffect(fromPosition, EFFECT_TELEPORT_DOWN)

    --[[if (ash) then
        doCreatureSetStorage(ash, 1000, 1) -- Ash Teleporting Storage/Flag
        local ashDest = doConcatPositions(getCreaturePosition(ash), {x = 0, y = 0, z = 1})
        doTeleportThing(ash, ashDest, false)
        doSendMagicEffect(ashDest, EFFECT_TELEPORT_DOWN)
		doCreatureFollowCreature(ash, cid)
        doCreatureSetStorage(ash, 1000, nil) -- Ash Teleporting Storage/Flag
    end]]
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (ACTIONS[itemEx.actionid]) then
        ACTIONS[itemEx.actionid](cid, item, fromPosition, itemEx, toPosition)
        doSendMagicEffect(fromPosition, EFFECT_RED_BUFF)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "The lever has switched on!")
    else
        doSendMagicEffect(fromPosition, EFFECT_POFF)
    end

	doTransformItem(itemEx.uid, item.itemid + 1)
	return true
end

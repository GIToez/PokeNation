local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local LAST_TRAVEl = {}

local BALLOON_OUTFITS = {}
local FLY_OUTFITS = {}

for _, out in pairs({1297}) do
    BALLOON_OUTFITS[#BALLOON_OUTFITS + 1] = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.TRAVEL)
    addOutfitCondition(BALLOON_OUTFITS[#BALLOON_OUTFITS], {lookType = out})
end

for _, out in pairs({597, 598, 599, 1145, 1097, 1098, 1099, 1100, 1101}) do
    FLY_OUTFITS[#FLY_OUTFITS + 1] = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.TRAVEL)
    addOutfitCondition(FLY_OUTFITS[#FLY_OUTFITS], {lookType = out})
end
--[[
["Jed Kaden"] = { -- Trem pewter
    {name = "cerulean", destination = {x = 3891, y = 262, z = 9}, price = 300}
},
["Alec Hudson"] = { -- Trem cerulean
    {name = "pewter", destination = {x = 3344, y = 309, z = 9}, price = 300}
},
]]
local TRAVELS = {
    ["Max Layton"] = { -- Balao viridian
        {name = "saffron", destination = {x = 3886, y = 463, z = 7}, price = 300, outfits = BALLOON_OUTFITS}
    },
    ["Claud Evelyn"] = { -- Balao saffron
        {name = "viridian", destination = {x = 3267, y = 600, z = 7}, price = 300, outfits = BALLOON_OUTFITS}
    },
    ["Raynard Casey"] = { -- taxi saffron
        {name = "celadon", destination = {x = 3659, y = 475, z = 7}, price = 100, outfits = FLY_OUTFITS},
        {name = "cerulean", destination = {x = 3935, y = 267, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "lavender", destination = {x = 4136, y = 550, z = 7}, price = 100, outfits = FLY_OUTFITS},
        {name = "vermilion", destination = {x = 4006, y = 641, z = 7}, price = 100, outfits = FLY_OUTFITS},
    },
    ["Kenton Nickolas"] = { -- taxi celadon
        {name = "saffron", destination = {x = 3897, y = 461, z = 7}, price = 100, outfits = FLY_OUTFITS},
        {name = "cerulean", destination = {x = 3935, y = 267, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "lavender", destination = {x = 4136, y = 550, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "vermilion", destination = {x = 4006, y = 641, z = 7}, price = 150, outfits = FLY_OUTFITS},
    },
    ["Michael Kodey"] = { -- taxi cerulean
        {name = "saffron", destination = {x = 3897, y = 461, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "celadon", destination = {x = 3659, y = 475, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "lavender", destination = {x = 4136, y = 550, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "vermilion", destination = {x = 4006, y = 641, z = 7}, price = 150, outfits = FLY_OUTFITS},
    },
    ["Gerard Aaron"] = { -- taxi lavender
        {name = "saffron", destination = {x = 3897, y = 461, z = 7}, price = 100, outfits = FLY_OUTFITS},
        {name = "celadon", destination = {x = 3659, y = 475, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "cerulean", destination = {x = 3935, y = 267, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "vermilion", destination = {x = 4006, y = 641, z = 7}, price = 150, outfits = FLY_OUTFITS},
    },
    ["Zavier Odell"] = { -- taxi vermilion
        {name = "saffron", destination = {x = 3897, y = 461, z = 7}, price = 100, outfits = FLY_OUTFITS},
        {name = "celadon", destination = {x = 3659, y = 475, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "cerulean", destination = {x = 3935, y = 267, z = 7}, price = 150, outfits = FLY_OUTFITS},
        {name = "lavender", destination = {x = 4136, y = 550, z = 7}, price = 150, outfits = FLY_OUTFITS},
    },
}

local DESTINATIONS_MESSAGE = {}
for npc, destinations in pairs(TRAVELS) do
    if (not DESTINATIONS_MESSAGE[npc]) then
        DESTINATIONS_MESSAGE[npc] = {}
    end

    for _, travel in pairs(destinations) do
        DESTINATIONS_MESSAGE[npc][#DESTINATIONS_MESSAGE[npc] +1] = "{"
        DESTINATIONS_MESSAGE[npc][#DESTINATIONS_MESSAGE[npc] +1] = travel.name
        DESTINATIONS_MESSAGE[npc][#DESTINATIONS_MESSAGE[npc] +1] = "}"
        DESTINATIONS_MESSAGE[npc][#DESTINATIONS_MESSAGE[npc] +1] = ", "
    end
end

for npc, messages in pairs(DESTINATIONS_MESSAGE) do
    DESTINATIONS_MESSAGE[npc][#DESTINATIONS_MESSAGE[npc] - 4] = ", "--" and "
    DESTINATIONS_MESSAGE[npc][#DESTINATIONS_MESSAGE[npc]] = "."
    DESTINATIONS_MESSAGE[npc] = table.concat(DESTINATIONS_MESSAGE[npc])
end

local TRAVEL_BY_NAME = {}
for npc, destinations in pairs (TRAVELS) do
    if (not TRAVEL_BY_NAME[npc]) then
        TRAVEL_BY_NAME[npc] = {}
    end

    for _, v in pairs(destinations) do
        TRAVEL_BY_NAME[npc][v.name] = v
    end
end

local function onTravelStart(cid, outfits)
    -- Lock player
    doCreatureSetNoMove(cid, true)
    setPlayerBackPosition(cid, getCreaturePosition(cid))
    setPlayerBlockLogout(cid, true)
    setPlayerTraveling(cid, true)
    doCreatureSetHideHealth(cid, true)

    -- Change Outfit
    doAddCondition(cid, table.random(outfits))

    -- Go to the last floor
    local upPosition = getCreaturePosition(cid)
    upPosition.z = 0
    for i, unsetTilePosition in ipairs(getUnsetTilesArroundPosition(upPosition)) do
        doCreateTileInPosition(VOID_TILE_ID, unsetTilePosition)
    end
    doTeleportThing(cid, upPosition)
end

local function onTravelEnd(cid, destination)
    -- Go to the destination floor
    doTeleportThing(cid, destination)

    -- Update outfit
    doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.TRAVEL)

    -- Unlock Player
    doCreatureSetHideHealth(cid, false)
    setPlayerTraveling(cid, false)
    setPlayerBlockLogout(cid, false)
    doCreatureSetNoMove(cid, false)
end

local doTravelStep
doTravelStep = function(cid, destination, pos)
    if (not isCreature(cid)) then
        return
    end

    if (pos.x > destination.x) then
        pos.x = pos.x - 1
    elseif (pos.x < destination.x) then
        pos.x = pos.x + 1
    elseif (pos.y > destination.y) then
        pos.y = pos.y - 1
    elseif (pos.y < destination.y) then
        pos.y = pos.y + 1
    else
        onTravelEnd(cid, destination)
        return
    end

    doTeleportThing(cid, pos, true)--doCreatureWalkToPosition(cid, pos)
    addEvent(doTravelStep, 200, cid, destination, pos)
end

local function doPlayerTravel(cid, travel)
    onTravelStart(cid, travel.outfits)
    doTravelStep(cid, travel.destination, getCreaturePosition(cid))
end

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    msg = string.lower(msg)

    if (msgcontains(msg, 'travel') or msgcontains(msg, 'viajar')) then
        selfSay(string.format(__L(cid, "I can leave you to these destinations: %s"), DESTINATIONS_MESSAGE[getNpcName()]), cid)

    elseif (TRAVEL_BY_NAME[getNpcName()][msg]) then
        local travel = TRAVEL_BY_NAME[getNpcName()][msg]
        selfSay(string.format(__L(cid, "Do you really want go to %s? This will cost you %s dollars."), travel.name, travel.price), cid)
        LAST_TRAVEl[cid] = travel

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (LAST_TRAVEl[cid]) then
            if (getPlayerMoney(cid) < LAST_TRAVEl[cid].price) then
                selfSay(string.format(__L(cid, "You need %s dollars to travel there."), LAST_TRAVEl[cid].price), cid)

            elseif (getPlayerMounted(cid) or isPokemonOnline(cid)) then
                selfSay("You can't travel while you are with a Pokemon out of the ball.", cid)

            else
                doPlayerRemoveMoney(cid, LAST_TRAVEl[cid].price)
                selfSay("Here you go!", cid)
                doPlayerTravel(cid, LAST_TRAVEl[cid])
            end

            LAST_TRAVEl[cid] = nil
        end

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Alright.", cid)
        LAST_TRAVEl[cid] = nil

    else
        selfSay("Yep.", cid)
    end
    return true
end)

npcHandler:addModule(FocusModule:new())

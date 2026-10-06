    local MACHINE_FREE_ITEMID = 24114
local MACHINE_PHASES = {
    [MACHINE_FREE_ITEMID] = 24117,
    [24117] = MACHINE_FREE_ITEMID,
}

local NPC_START_PHASE = 560
local NPC_PHASES = {
    [NPC_START_PHASE] = 1149,
    [1149] = 1150,
    [1150] = NPC_START_PHASE
}

local machinePositions, events, animating = {}, {}, {}

local function findMachine(cid)
    local dirs = {NORTH, EAST, SOUTH, WEST, SOUTHWEST, SOUTHEAST, NORTHWEST, NORTHEAST}
    local pos = getCreaturePosition(cid)
    for k, v in ipairs(dirs) do
        local tmpPos = {x = pos.x, y = pos.y, z = pos.z}
        tmpPos = getPositionByDirection(pos, v, 1)

        if (getTileItemById(tmpPos, MACHINE_FREE_ITEMID)) then
            machinePositions[cid] = tmpPos
            return true
        end
    end

    log(LOG_TYPES.WARNING, "Pokemon Center NPC - Can't find machine for animation.", pos.x, pos.y, pos.z)
    return false
end

local function getMachine(pos)
    for k, v in pairs(MACHINE_PHASES) do
        local item = getTileItemById(pos, v)
        if (isItem(item)) then
            return item
        end
    end
    return nil
end

local function animateMachine(cid, tick, maxTick)
    if ((not machinePositions[cid] and not findMachine(cid)) or (events[cid] and tick == 1)) then
        return
    end

    local machine = getMachine(machinePositions[cid])
    if (not isItem(machine)) then
        return
    end

    if (doTransformItem(machine.uid, (tick > maxTick and MACHINE_FREE_ITEMID or MACHINE_PHASES[machine.itemid]), 1)) then
        if (tick < maxTick) then
            events[cid] = addEvent(animateMachine, 1000, cid, tick + 1, maxTick)
        elseif (tick == maxTick) then
            events[cid] = addEvent(animateMachine, 2000, cid, tick + 1, maxTick)
        else
            events[cid] = nil
        end
    end
end

local function animateNpc(cid, starting)
    if (not animating[cid] or not starting) then
        doCreatureChangeOutfit(cid, {lookType = NPC_PHASES[getCreatureOutfit(cid).lookType]})
        if (getCreatureOutfit(cid).lookType ~= NPC_START_PHASE) then
            animating[cid] = true
            addEvent(animateNpc, 300, cid, false)
        else
            animating[cid] = nil
        end
    end
end
--
local REQUIREMENTS = {}
REQUIREMENTS[{x = 3004, y = 2895, z = 5}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end -- Valencia
REQUIREMENTS[{x = 3261, y = 2761, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end -- Pinkan
REQUIREMENTS[{x = 3066, y = 1664, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 2 end -- Pummelo

REQUIREMENTS[{x = 3266, y = 1496, z = 5}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end -- Tarroco
REQUIREMENTS[{x = 3457, y = 1475, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end -- Hamlin
REQUIREMENTS[{x = 3516, y = 1694, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 3 end -- Kumquat

REQUIREMENTS[{x = 2939, y = 2231, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end -- Mandarin North
REQUIREMENTS[{x = 4114, y = 1748, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end -- Butwal
REQUIREMENTS[{x = 4456, y = 2232, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end -- Navel

REQUIREMENTS[{x = 4434, y = 1716, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end -- Ascorbia
REQUIREMENTS[{x = 4375, y = 2676, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end -- Seven Grapefruit
REQUIREMENTS[{x = 4164, y = 2954, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 5 end -- Moro

REQUIREMENTS[{x = 4210, y = 3168, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Murcott
REQUIREMENTS[{x = 3490, y = 3213, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Mandarin South
REQUIREMENTS[{x = 3595, y = 3149, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Mandarin South
REQUIREMENTS[{x = 3605, y = 3290, z = 6}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Mandarin South
REQUIREMENTS[{x = 3524, y = 1922, z = 7}] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 6 end -- Shamouti
--
local cities = {"viridian",	"pewter", "cerulean", "saffron", "celadon", "vermilion", "lavender", "fuchsia",
    "cinnabar", "hamlin", "kumquat", "pummelo", "shamouti", "butwal", "ascorbia", "navel", "seven grapefruit",
    "moro", "murcott", "pinkan", "valencia", "tangelo", "sunburst", "mikan", "mandarin north", "tarroco",
    "trovitopolis", "mandarin south" }
local lastCity = {}

local CITY_BY_POS = {}
CITY_BY_POS[{x = 3296, y = 561, z = 7}] = "Viridian"
CITY_BY_POS[{x = 3307, y = 296, z = 7}] = "Pewter"
CITY_BY_POS[{x = 3513, y = 284, z = 6}] = "Pewter"
CITY_BY_POS[{x = 3884, y = 314, z = 7}] = "Cerulean"
CITY_BY_POS[{x = 3933, y = 474, z = 7}] = "Saffron"
CITY_BY_POS[{x = 3701, y = 436, z = 7}] = "Celadon"
CITY_BY_POS[{x = 4190, y = 552, z = 7}] = "Lavender"
CITY_BY_POS[{x = 3969, y = 641, z = 7}] = "Vermilion"
CITY_BY_POS[{x = 3860, y = 845, z = 7}] = "Fuchsia"
CITY_BY_POS[{x = 3370, y = 1048, z = 7}] = "Cinnabar"

CITY_BY_POS[{x = 2758, y = 2437, z = 7}] = "Mikan"
CITY_BY_POS[{x = 3039, y = 2542, z = 5}] = "Sunburst"
CITY_BY_POS[{x = 2756, y = 2819, z = 5}] = "Tangelo"
CITY_BY_POS[{x = 3004, y = 2895, z = 5}] = "Valencia"
CITY_BY_POS[{x = 3261, y = 2761, z = 6}] = "Pinkan"
CITY_BY_POS[{x = 3066, y = 1664, z = 7}] = "Pummelo"
CITY_BY_POS[{x = 3266, y = 1496, z = 5}] = "Tarroco"
CITY_BY_POS[{x = 3457, y = 1475, z = 7}] = "Hamlin"
CITY_BY_POS[{x = 3516, y = 1694, z = 7}] = "Kumquat"
CITY_BY_POS[{x = 2939, y = 2231, z = 7}] = "Mandarin North"
CITY_BY_POS[{x = 4114, y = 1748, z = 7}] = "Butwal"
CITY_BY_POS[{x = 4456, y = 2232, z = 6}] = "Navel"
CITY_BY_POS[{x = 4434, y = 1716, z = 7}] = "Ascorbia"
CITY_BY_POS[{x = 4375, y = 2676, z = 7}] = "Seven Grapefruit"
CITY_BY_POS[{x = 4164, y = 2954, z = 7}] = "Moro"
CITY_BY_POS[{x = 4210, y = 3168, z = 7}] = "Murcott"
CITY_BY_POS[{x = 3490, y = 3213, z = 6}] = "Trovitopolis"
CITY_BY_POS[{x = 3595, y = 3149, z = 6}] = "Mandarin South 01"
CITY_BY_POS[{x = 3605, y = 3290, z = 6}] = "Mandarin South 02"
CITY_BY_POS[{x = 3524, y = 1922, z = 7}] = "Shamouti"

CITY_BY_POS[{x = 519, y = 1707, z = 7}] = "Oldale"
CITY_BY_POS[{x = 396, y = 1687, z = 6}] = "Petalburg"
CITY_BY_POS[{x = 256, y = 1504, z = 7}] = "Rustboro"
CITY_BY_POS[{x = 408, y = 2003, z = 7}] = "Dewford"
CITY_BY_POS[{x = 728, y = 1785, z = 6}] = "Slateport"
CITY_BY_POS[{x = 777, y = 1449, z = 7}] = "Mauville"
CITY_BY_POS[{x = 544, y = 1508, z = 7}] = "Verdanturf"
CITY_BY_POS[{x = 475, y = 1141, z = 7}] = "Fallarbor"
CITY_BY_POS[{x = 572, y = 1324, z = 5}] = "Lavaridge"
CITY_BY_POS[{x = 996, y = 1149, z = 5}] = "Fortree"
CITY_BY_POS[{x = 1354, y = 1311, z = 6}] = "Lilycove"
CITY_BY_POS[{x = 1732, y = 1427, z = 6}] = "Mosssdeep"
CITY_BY_POS[{x = 1576, y = 1545, z = 5}] = "Sootopolis"
CITY_BY_POS[{x = 1311, y = 1760, z = 7}] = "Pacifidlog"

local function getCity()
    local city
    local pos = getNpcPos()
    for k, v in pairs(CITY_BY_POS) do
        if (getSamePosition(k, pos)) then
            city = v
            break
        end
    end
    return city
end

local function tryHeal(cid)
    if (isPokemonOnline(cid)) then -- Try to call Pokemon back
        doPlayerUseBallOnSlot(cid)
    end

    if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
        selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

    elseif (not getTileInfo(getCreaturePosition(cid)).protection) then
        selfSay("Please enter the Pokemon center to heal your Pokemon.", cid)

    else
        local pos = getNpcPos()
        for k, v in pairs(REQUIREMENTS) do
            if (getSamePosition(k, pos)) then
                if (not v(cid)) then
                    selfSay("You do not have enough access to heal your Pokemon here!", cid)
                    return false
                end
                break
            end
        end

        if (getCity()) then
            selfSay("One second... Alright, it's here. Remember that you can also change your {hometown} here. If you want to restore your pokemon again, just say {heal}.", cid)
        else
            selfSay("One second... Alright, it's here. If you want to restore your pokemon again, just say {heal}.", cid)
        end

        doCreatureAddHealth(cid, (getCreatureMaxHealth(cid) - getCreatureHealth(cid)))
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_GREEN_BUFF)

        local balls = getPlayerAllBallsWithPokemon(cid)
        for i, ball in ipairs(balls) do
            doBallHeal(cid, ball)
        end

        if (#balls > 0) then
            animateMachine(getNpcId(), 1, 2)
            addEvent(animateNpc, #balls * 300, getNpcId(), true)
        end

        return true
    end

    return false
end
--[[ ]]
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onThink() npcHandler:onThink() end
function onCreatureSay(cid, type, msg)
    msg = string.lower(msg)
    if (npcHandler:isFocused(cid) and NpcHandler:isInRange(cid) and msg == 'hi') then
        tryHeal(cid)
    end

    npcHandler:onCreatureSay(cid, type, msg)
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    if (msgcontains(msg, 'heal') or msgcontains(msg, 'restore') or msgcontains(msg, 'health') or msgcontains(msg, 'curar') or
            msgcontains(msg, 'recuperar') or msgcontains(msg, 'vida')) then
        tryHeal(cid)

    elseif (msgcontains(msg, "hometown") or msgcontains(msg, 'cidade')) then
        local city = getCity()
        if (not city) then
            log(LOG_TYPES.ERROR, "NurseJoy::ChangeCity - Unknown Nurse position.", getNpcPos(), getCreatureName(cid))
            selfSay("Please, try again later.", cid)
            return true
        end

        selfSay(string.format(__L(cid, "You really want to live in %s?"), city), cid)
        lastCity[cid] = city

    elseif ((msgcontains(msg, "yes") or msgcontains(msg, 'sim')) and lastCity[cid] ~= nil) then
        if (not doPlayerSetTown(cid, getTownId(lastCity[cid]))) then
            selfSay("Please, try again later.", cid)
            return true
        end

        selfSay("Your hometown has changed!", cid)
    end

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        if (tryHeal(cid)) then
            npcHandler:addFocus(cid)
            return false
        end

        --return true
    end
    return false
end)


npcHandler:addModule(FocusModule:new())

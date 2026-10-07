if (Fishing) then
    return
end

Fishing = {}

-- Constants
local OLD_ROD_ITEMID = 12292
local GOOD_ROD_ITEMID = 12293
local SUPER_ROD_ITEMID = 12294
local CRANE1_ITEMID = 3977
local CRANE2_ITEMID = 3978
local CRANE3_ITEMID = 3979
local CRANE4_ITEMID = 3980

local CRANE_NEXTUSEDATE_ATTR = 2500
local CRANE_USE_DELAY = 20

local RODS = {
    [OLD_ROD_ITEMID] = { delay = 4, requiredSkill = 0, allowMultiple = false, fishingTime = 20 },
    [GOOD_ROD_ITEMID] = { delay = 5, requiredSkill = 30, allowMultiple = false, fishingTime = 30 },
    [SUPER_ROD_ITEMID] = { delay = 5, requiredSkill = 50, allowMultiple = false, fishingTime = 30 },
    [CRANE1_ITEMID] = { delay = 15, requiredSkill = 60, allowMultiple = true, nextUseAttr = CRANE_NEXTUSEDATE_ATTR, nextUseDelay = CRANE_USE_DELAY },
    [CRANE2_ITEMID] = { delay = 15, requiredSkill = 60, allowMultiple = true, nextUseAttr = CRANE_NEXTUSEDATE_ATTR, nextUseDelay = CRANE_USE_DELAY },
    [CRANE3_ITEMID] = { delay = 15, requiredSkill = 60, allowMultiple = true, nextUseAttr = CRANE_NEXTUSEDATE_ATTR, nextUseDelay = CRANE_USE_DELAY },
    [CRANE4_ITEMID] = { delay = 15, requiredSkill = 60, allowMultiple = true, nextUseAttr = CRANE_NEXTUSEDATE_ATTR, nextUseDelay = CRANE_USE_DELAY },
}

--[[
Squirtle, Wartortle, Blastoise
Totodile, Croconaw, Feraligatr
Vaporeon

 ]]

local DROPS = {
    {
        skill = 0,
        minLevel = 1,
        maxLevel = 20,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Magikarp", maxAmount = 4 } },
        orangeArchipelagoPokemon = {},
        hoennPokemon = {}
    },
    {
        skill = 5,
        minLevel = 5,
        maxLevel = 30,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Poliwag", maxAmount = 4 } },
        orangeArchipelagoPokemon = {},
        hoennPokemon = {}
    },
    {
        skill = 10,
        minLevel = 5,
        maxLevel = 30,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Krabby", maxAmount = 4 } },
        orangeArchipelagoPokemon = {},
        hoennPokemon = {}
    },
    {
        skill = 15,
        minLevel = 5,
        maxLevel = 30,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Shellder", maxAmount = 4 } },
        orangeArchipelagoPokemon = {},
        hoennPokemon = {}
    },
    {
        skill = 20,
        minLevel = 5,
        maxLevel = 30,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Horsea", maxAmount = 4 } },
        orangeArchipelagoPokemon = {},
        hoennPokemon = {}
    },
    {
        skill = 25,
        minLevel = 10,
        maxLevel = 35,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Goldeen", maxAmount = 4 } },
        orangeArchipelagoPokemon = {},
        hoennPokemon = {}
    },
    {
        skill = 30,
        minLevel = 15,
        maxLevel = 40,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Tentacool", maxAmount = 4 }, { name = "Psyduck", maxAmount = 4 } },
        orangeArchipelagoPokemon = { { name = "Wooper", maxAmount = 4 } },
        hoennPokemon = { { name = "Surskit", maxAmount = 4 } }
    },
    {
        skill = 35,
        minLevel = 15,
        maxLevel = 40,
        rods = {
            OLD_ROD_ITEMID, GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Slowpoke", maxAmount = 4 }, { name = "Staryu", maxAmount = 4 }, { name = "Seel", maxAmount = 4 } },
        orangeArchipelagoPokemon = { { name = "Chinchou", maxAmount = 4 } },
        hoennPokemon = { { name = "Carvanha", maxAmount = 4 } }
    },
    {
        skill = 40,
        minLevel = 20,
        maxLevel = 45,
        rods = {
            GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Poliwhirl", maxAmount = 3 } },
        orangeArchipelagoPokemon = { { name = "Remoraid", maxAmount = 3 }, { name = "Marill", maxAmount = 3 } },
        hoennPokemon = { { name = "Wailmer", maxAmount = 3 }, { name = "Barboach", maxAmount = 3 } }
    },
    {
        skill = 45,
        minLevel = 25,
        maxLevel = 50,
        rods = {
            GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Seaking", maxAmount = 3 }, { name = "Starmie", maxAmount = 3 } },
        orangeArchipelagoPokemon = { { name = "Corsola", maxAmount = 3 } },
        hoennPokemon = { { name = "Corphish", maxAmount = 3 }, { name = "Clamperl", maxAmount = 3 } }
    },
    {
        skill = 50,
        minLevel = 35,
        maxLevel = 100,
        rods = {
            GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Kingler", maxAmount = 2 } },
        orangeArchipelagoPokemon = { { name = "Mantine", maxAmount = 2 }, { name = "Qwilfish", maxAmount = 2 } },
        hoennPokemon = { { name = "Luvdisc", maxAmount = 2 }, { name = "Crawdaunt", maxAmount = 2 }, { name = "Huntail", maxAmount = 2 } }
    },
    {
        skill = 60,
        minLevel = 45,
        maxLevel = 100,
        rods = {
            GOOD_ROD_ITEMID, SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Seadra", maxAmount = 2 } },
        orangeArchipelagoPokemon = { { name = "Lanturn", maxAmount = 2 }, { name = "Quagsire", maxAmount = 2 } },
        hoennPokemon = { { name = "Sharpedo", maxAmount = 2 }, { name = "Whiscash", maxAmount = 2 }, { name = "Feebas", maxAmount = 2 } }
    },
    {
        skill = 70,
        minLevel = 75,
        maxLevel = 100,
        rods = {
            SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Cloyster", maxAmount = 1 }, { name = "Dewgong", maxAmount = 2 } },
        orangeArchipelagoPokemon = { { name = "Politoed", maxAmount = 1 } },
        hoennPokemon = { { name = "Gorebyss", maxAmount = 1 }, { name = "Relicanth", maxAmount = 1 } }
    },
    {
        skill = 75,
        minLevel = 75,
        maxLevel = 100,
        rods = {
            SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Tentacruel", maxAmount = 1 }, { name = "Lapras", maxAmount = 1 } },
        orangeArchipelagoPokemon = {},
        hoennPokemon = { { name = "Wailord", maxAmount = 1 } }
    },
    {
        skill = 80,
        minLevel = 75,
        maxLevel = 100,
        rods = {
            SUPER_ROD_ITEMID,
            CRANE1_ITEMID, CRANE2_ITEMID, CRANE3_ITEMID, CRANE4_ITEMID
        },
        kantoPokemon = { { name = "Gyarados", maxAmount = 1 } },
        orangeArchipelagoPokemon = { { name = "Octillery", maxAmount = 1 } },
        hoennPokemon = { { name = "Milotic", maxAmount = 1 } }
    },
}

local SHINY_CHANCE = getConfigValue("shinyAppearChance") * 10
local FISHING_FLOAT_ID = 13181

local POKEMON_NUMBER_TO_ACTIVATE_MAX_LEVEL = 7
local MAX_AMOUNT_LEVEL_DIVIDER = 25 -- Prevent a Pokemon with low level summoning more pokemon that he can beat, eg bulba 25 summoning 4 spearows 20

-- Vars

-- Local
local function getPlayerFishinablePokemons(cid, pokemon, rodItemId)
    local r = {}

    local skill = getPlayerSkill(cid, PLAYER_SKILL_FISHING)
    local isInOl = getPlayerInsideOrangeArchipelago(cid)
    local isInHoenn = getPlayerInsideHoenn(cid)
    local level = isCreature(pokemon) and getMonsterLevel(pokemon) or 1

    for _, v in pairs(DROPS) do
        if (v.skill <= skill and level >= v.minLevel and table.find(v.rods, rodItemId)) then
            r[#r + 1] = { maxLevel = v.maxLevel, pokemon = v.kantoPokemon }
            if (isInOl) then
                r[#r + 1] = { maxLevel = v.maxLevel, pokemon = v.orangeArchipelagoPokemon }
            elseif (isInHoenn) then
                r[#r + 1] = { maxLevel = v.maxLevel, pokemon = v.hoennPokemon }
            end
        end
    end

    if (#r >= POKEMON_NUMBER_TO_ACTIVATE_MAX_LEVEL) then
        for i = 1, #r - (POKEMON_NUMBER_TO_ACTIVATE_MAX_LEVEL - 1) do
            if (level > r[i].maxLevel) then
                r[i] = nil
            end
        end
    end

    local ret = {}
    for k, v in pairs(r) do
        ret = table_concat(ret, v.pokemon)
    end
    return ret
end

--[[
local function getPlayerFishablePokemons(cid, rodId)
    local playerFishingSkill = getPlayerSkill(cid, SKILL_FISHING)
    local pokemon_by_skill = getPlayerInsideOrangeArchipelago(cid) and POKEMON_BY_SKILL_ORANGE_ARCHIPELAGO
            or POKEMON_BY_SKILL_KANTO
    for i = #pokemon_by_skill, 1, -1 do
        if (RODS[rodId].maxSkill >= pokemon_by_skill[i].skill and
                pokemon_by_skill[i].skill <= playerFishingSkill) then
            return pokemon_by_skill[i].pokemons
        end
    end
end
]]

local function getPlayerFishingFormula(cid, rodId)
    return getPlayerSkill(cid, SKILL_FISHING) / 200 + 0.85 * math.random()
end

local function doFishing(cid, fromPosition, toPosition, rod, tries, ticksToStart, remaingFishingTicks)
    if (not remaingFishingTicks) then
        remaingFishingTicks = 0
    end

    local removed = false
    if (isPlayer(cid)) then
        local currentPosition = getCreaturePosition(cid)
        if (getDistanceBetween(currentPosition, fromPosition) > 1) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You left your fishing spot and stopped to fish.")
            removed = true

        elseif (ticksToStart <= 0 and (getPlayerFishingFormula(cid, rod) > 1.0 or tries >= 3)) then
            local fishablePokemons = getPlayerFishinablePokemons(cid, getPlayerPokemon(cid), rod)
            local randomFishablePokemon = table.random(fishablePokemons)
            local fishName = randomFishablePokemon.name

            local maxAmount = RODS[rod].allowMultiple and randomFishablePokemon.maxAmount or 1
            if (maxAmount > 1) then
                local pokemon = getPlayerPokemon(cid)
                maxAmount = math.ceil((isCreature(pokemon) and getMonsterLevel(pokemon) or 1) / MAX_AMOUNT_LEVEL_DIVIDER)
            end

            for i = 1, getRandom(1, maxAmount) do
                if (getRandom(0, SHINY_CHANCE) == 0) then
                    local tmp = getMonsterInfo(fishName).shiny
                    if (tmp and isString(tmp) and tmp ~= "") then
                        log(LOG_TYPES.WARNING, "Hooked Shiny", getCreatureName(cid), tmp, SHINY_CHANCE)
                        fishName = tmp
                    end
                    if (isShinyName(fishName)) then
                        log(LOG_TYPES.WARNING, "Hooked Shiny [2]", getCreatureName(cid), tmp, SHINY_CHANCE)
                    end
                end

                local pokemonFished = doSummonCreature(fishName, fromPosition)
                local pos = getClosestFreeTile(pokemonFished, fromPosition)
                if (pos) then
                    doTeleportThing(pokemonFished, pos)
                    doSendMagicEffect(pos, EFFECT_SPLASH)
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You hooked %s!"), getMonsterInfo(fishName).description))
                    doSendMagicEffect(currentPosition, EFFECT_EMOTION_EXCLAMATION)
                    addEvent(doRemoveCreature, 3 * 60 * 1000, pokemonFished, true, false) -- remove creature after 3 min, force remove and don't show error
                    setMonsterUniqueTarget(pokemonFished, cid)

                    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.HOOKED_FISH, 1)
                    doPlayerAddSkillTry(cid, PLAYER_SKILL_FISHING, 1)


                else
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "There is no free space next to you, please move to a different spot!")
                    doRemoveCreature(pokemonFished)
                end
            end

            if (remaingFishingTicks <= 0) then
                removed = true
            else
                ticksToStart = RODS[rod].delay
                tries = 0
            end
        end

        if (not removed) then
            doSendMagicEffect(currentPosition, EFFECT_EMOTION_THREE_POINTS)
            doCreatureSetLookDirection(cid, getDirectionTo(fromPosition, toPosition, true))
            addEvent(doFishing, 2000, cid, fromPosition, toPosition, rod, tries + 1, ticksToStart - 2, remaingFishingTicks - 2)
        end

    else
        removed = true
    end

    if (removed) then
        local item = getTileItemById(toPosition, FISHING_FLOAT_ID)
        if (isItem(item)) then
            doRemoveItem(item.uid)
            doSendMagicEffect(toPosition, EFFECT_WATER_PULSE)
        end
        if (isCreature(cid)) then
            setFishingStatus(cid, false)
            doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.FISHING)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You stopped fishing.")
        end
    end
end

-- Global
Fishing.onFishing = function(cid, item, fromPosition, itemEx, toPosition)
    if (not isInArray(WATER_IDS, itemEx.itemid) or getSafariZone(cid) or getPlayerMounted(cid) or
            isBiking(cid) or getPlayerFrontierIsland(cid) or getPlayerPvpArena(cid) or
            getTileInfo(toPosition).things > 1) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

    elseif (isFishing(cid)) then
        doPlayerSendCancel(cid, "You're already fishing.")

    elseif (getTilePzInfo(getCreaturePosition(cid))) then
        doPlayerSendCancel(cid, "You can't fish while you're in a protection zone.")

    elseif (getPlayerSkill(cid, SKILL_FISHING) < RODS[item.itemid].requiredSkill) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You need at least skill %s to use this fishing rod."), RODS[item.itemid].requiredSkill))

    elseif (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.FISHING)) then
        doPlayerSendCancel(cid, "Your fishing is blocked, please try again in a few seconds.")

    else
        if (RODS[item.itemid].nextUseAttr) then
            local next = getItemAttribute(item.uid, RODS[item.itemid].nextUseAttr)
            if (next and next > getCurrentTimeInSeconds()) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                    string.format(__L(cid, "This rod will be able to use again in %s."), table.concat(string.timediff((next - getCurrentTimeInSeconds()), cid))))
                return true
            end
        end

        local pokemon = getPlayerPokemon(cid)
        if (isCreature(pokemon) and getTilePzInfo(getCreaturePosition(pokemon))) then
            doPlayerSendCancel(cid, "You can't fish while your pokemon is inside a protection zone.")
            return true
        end

        local playerPosition = getCreaturePosition(cid)
        if (getDistanceBetween(playerPosition, toPosition) > 4) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are fishing now.")
            setFishingStatus(cid, true)
            doCreateItem(FISHING_FLOAT_ID, 1, toPosition)
            doSendDistanceShoot(playerPosition, toPosition, PROJECTILE_GRAVEL)
            doSendMagicEffect(toPosition, EFFECT_WATER_PULSE)
            addEvent(doFishing, 1000, cid, playerPosition, toPosition, item.itemid, 0, RODS[item.itemid].delay - 1, RODS[item.itemid].fishingTime)

            local outfit = getCreatureOutfit(cid)
            outfit.lookType = getPlayerSex(cid) == PLAYERSEX_FEMALE and 1227 or 1228
            doSetCreatureOutfit(cid, outfit, -1, CONDITION_SUBID.OUTFITS.FISHING)
            doCreatureSetLookDirection(cid, getDirectionTo(playerPosition, toPosition, true))

            if (RODS[item.itemid].nextUseAttr) then
                doItemSetAttribute(item.uid, RODS[item.itemid].nextUseAttr, getCurrentTimeInSeconds() + RODS[item.itemid].nextUseDelay)
            end
        end
    end
    return true
end
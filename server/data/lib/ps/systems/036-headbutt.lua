 if (Headbutt) then
    return
end

Headbutt = {}

-- Constants
local DROPS = {
    {
        skill = 0, minLevel = 1, maxLevel = 20,
        kantoPokemon = {{name = "Caterpie", maxAmount = 4}, {name = "Weedle", maxAmount = 4}},
        orangeArchipelagoPokemon = {{name = "Sentret", maxAmount = 4}},
        hoennPokemon = {{name = "Wurmple", maxAmount = 4}}
    },
    {
        skill = 10, minLevel = 5, maxLevel = 30,
        kantoPokemon = {{name = "Pidgey", maxAmount = 4}, {name = "Spearow", maxAmount = 4}},
        orangeArchipelagoPokemon = {{name = "Hoothoot", maxAmount = 4}},
        hoennPokemon = {}
    },
    {
        skill = 20, minLevel = 10, maxLevel = 30,
        kantoPokemon = {{name = "Kakuna", maxAmount = 4}, {name = "Metapod", maxAmount = 4}},
        orangeArchipelagoPokemon = {{name = "Ledyba", maxAmount = 4}, {name = "Spinarak", maxAmount = 4}},
        hoennPokemon = {{name = "Zigzagoon", maxAmount = 3}}
    },
    {
        skill = 25, minLevel = 12, maxLevel = 40,
        kantoPokemon = {{name = "Ekans", maxAmount = 4}, {name = "Venonat", maxAmount = 4}},
        orangeArchipelagoPokemon = {{name = "Furret", maxAmount = 4}, {name = "Venonat", maxAmount = 4}},
        hoennPokemon = {{name = "Silcoon", maxAmount = 3}}
    },
    {
        skill = 30, minLevel = 15, maxLevel = 40,
        kantoPokemon = {{name = "Mankey", maxAmount = 4}},
        orangeArchipelagoPokemon = {{name = "Aipom", maxAmount = 4}},
        hoennPokemon = {{name = "Cascoon", maxAmount = 3}}
    },
    {
        skill = 35, minLevel = 8, maxLevel = 50,
        kantoPokemon = {{name = "Exeggcute", maxAmount = 4}},
        orangeArchipelagoPokemon = {{name = "Yanma", maxAmount = 4}},
        hoennPokemon = {{name = "Taillow", maxAmount = 3}}
    },
    {
        skill = 40, minLevel = 20, maxLevel = 60,
        kantoPokemon = {{name = "Pidgeotto", maxAmount = 4}},
        orangeArchipelagoPokemon = {{name = "Pidgeotto", maxAmount = 4}},
        hoennPokemon = {{name = "Slakoth", maxAmount = 3}}
    },
    {
        skill = 45, minLevel = 30, maxLevel = 100,
        kantoPokemon = {{name = "Beedrill", maxAmount = 3}, {name = "Butterfree", maxAmount = 3}},
        orangeArchipelagoPokemon = {{name = "Teddiursa", maxAmount = 2}},
        hoennPokemon = {{name = "Nincada", maxAmount = 3}}
    },
    {
        skill = 50, minLevel = 35, maxLevel = 100,
        kantoPokemon = {{name = "Arbok", maxAmount = 3}, {name = "Golbat", maxAmount = 3}},
        orangeArchipelagoPokemon = {{name = "Noctowl", maxAmount = 3}, {name = "Ledian", maxAmount = 3}},
        hoennPokemon = {{name = "Skitty", maxAmount = 3}}
    },
    {
        skill = 55, minLevel = 50, maxLevel = 100,
        kantoPokemon = {{name = "Venomoth", maxAmount = 3}},
        orangeArchipelagoPokemon = {{name = "Ariados", maxAmount = 3}},
        hoennPokemon = {{name = "Beautifly", maxAmount = 3}}
    },
    {
        skill = 60, minLevel = 45, maxLevel = 100,
        kantoPokemon = {{name = "Pinsir", maxAmount = 1}},
        orangeArchipelagoPokemon = {{name = "Pineco", maxAmount = 3}},
        hoennPokemon = {{name = "Vigoroth", maxAmount = 3}}
    },
    {
        skill = 65, minLevel = 40, maxLevel = 100,
        kantoPokemon = {{name = "Farfetchd", maxAmount = 1}},
        orangeArchipelagoPokemon = {{name = "Heracross", maxAmount = 1}},
        hoennPokemon = {{name = "Linoone", maxAmount = 3}}
    },
    {
        skill = 70, minLevel = 50, maxLevel = 100,
        kantoPokemon = {{name = "Scyther", maxAmount = 1}},
        orangeArchipelagoPokemon = {{name = "Forretress", maxAmount = 1}},
        hoennPokemon = {}
    },
    {
        skill = 75, minLevel = 50, maxLevel = 100,
        kantoPokemon = {{name = "Pidgeot", maxAmount = 1}},
        orangeArchipelagoPokemon = {{name = "Ursaring", maxAmount = 1}},
        hoennPokemon = {}
    },
    {
        skill = 80, minLevel = 50, maxLevel = 100,
        kantoPokemon = {{name = "Fearow", maxAmount = 1}},
        orangeArchipelagoPokemon = {{name = "Scizor", maxAmount = 1}},
        hoennPokemon = {{name = "Slaking", maxAmount = 1}}
    },
}

local SHINY_CHANCE = getConfigValue("shinyAppearChance") * 10
local HEADBUTT_EXHAUST_CONDITION = createConditionObject(CONDITION_EXHAUST, 10 * 1000, false,
    CONDITION_SUBID.EXHAUST.ABILITYHEADBUTT)

local POKEMON_NUMBER_TO_ACTIVATE_MAX_LEVEL = 7
local MAX_AMOUNT_LEVEL_DIVIDER = 25 -- Prevent a Pokemon with low level summoning more pokemon that he can beat, eg bulba 25 summoning 4 spearows 20

-- Vars

-- Local
local function getPlayerHeadbuttablePokemons(cid, pokemon)
    local r = {}

    local skill = getPlayerSkill(cid, PLAYER_SKILL_HEADBUTTING)
    local isInOl = getPlayerInsideOrangeArchipelago(cid)
    local isInHoenn = getPlayerInsideHoenn(cid)
    local level = getMonsterLevel(pokemon)

    for _, v in pairs(DROPS) do
        if (v.skill <= skill and level >= v.minLevel) then
            r[#r + 1] = {maxLevel = v.maxLevel, pokemon = v.kantoPokemon}
            if (isInOl) then
                r[#r + 1] = {maxLevel = v.maxLevel, pokemon = v.orangeArchipelagoPokemon }
            elseif (isInHoenn) then
                r[#r + 1] = {maxLevel = v.maxLevel, pokemon = v.hoennPokemon }
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

local function checkHeadbutt(cid, itemEx, toPosition, ticks)
    if (isCreature(cid)) then
        if (getDistanceBetween(getCreaturePosition(cid), toPosition) == 1) then
            itemEx = getTileItemById(toPosition, itemEx.itemid)
            if (not isItem(itemEx)) then
                return
            end

            local master = getCreatureMaster(cid)
            local cidPos = getCreaturePosition(cid)

            doTransformItem(itemEx.uid, itemEx.itemid + 1)
            doDecayItem(itemEx.uid)
            doCreatureSetLookDirection(cid, getDirectionTo(getCreaturePosition(cid), toPosition))

            doSendMagicEffect(cidPos, EFFECT_CONFUSE_STARS)
            doSendMagicEffect(toPosition, EFFECT_YELLOW_BLOW)
            doSendDistanceShoot(cidPos, toPosition, PROJECTILE_GRAVEL)

            doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE, "You find something!")
            doSendMagicEffect(cidPos, EFFECT_EMOTION_EXCLAMATION)

            local headbuttablePokemons = getPlayerHeadbuttablePokemons(master, cid)
            local randomHeadbuttablePokemon = table.random(headbuttablePokemons)
            local fishName = randomHeadbuttablePokemon.name

            doPlayerAddSkillTry(master, PLAYER_SKILL_HEADBUTTING, 1)

            local maxAmount = randomHeadbuttablePokemon.maxAmount
            if (maxAmount > 1) then
                maxAmount = math.ceil(getMonsterLevel(cid) / MAX_AMOUNT_LEVEL_DIVIDER)
            end

            for i = 1, getRandom(1, maxAmount) do
                local pokemonName = fishName
                if (getRandom(0, SHINY_CHANCE) == 0) then
                    pokemonName = getMonsterInfo(pokemonName).shiny
                    log(LOG_TYPES.WARNING, "Headbutted Shiny", getCreatureName(cid), pokemonName, SHINY_CHANCE)
                end
                if (isShinyName(pokemonName)) then
                    log(LOG_TYPES.WARNING, "Headbutted Shiny [2]", getCreatureName(cid), pokemonName, SHINY_CHANCE)
                end
                local pokemon = doSummonCreature(pokemonName, getCreaturePosition(cid))

                addEvent(doRemoveCreature, 3 * 60 * 1000, pokemon, true, false) -- remove creature after 2 min, force remove and dont show error
                setMonsterUniqueTarget(pokemon, master)
            end

            PokemonAbility.afterHeadbutt(master, cid, toPosition)
            
        elseif (ticks > 1) then
            addEvent(checkHeadbutt, 1000, cid, itemEx, toPosition, ticks - 1)
        end
    end
end

-- Global
Headbutt.onHeadbutt = function(cid, itemEx, toPosition)
    if (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.ABILITYHEADBUTT)) then
        doPlayerSendCancel(cid, "Your Pokemon is exhaust.")
        return false
    end

    local pokemon = getPlayerPokemon(cid)
    local pos = getCreaturePosition(pokemon)
    local targetPos = (getDistanceBetween(pos, toPosition) <= 1 and toPosition or
            getPositionAdjacent(pokemon, toPosition, true))

    if (targetPos and isSightClear(pos, targetPos, true) and getDistanceBetween(targetPos, toPosition) <= 1 and
            getPathToEx(pokemon, targetPos)) then
        doCreatureSay(cid, string.format(__L(cid, "%s, headbutt it!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)
        doCreatureWalkToPosition(pokemon, targetPos)
        checkHeadbutt(pokemon, itemEx, toPosition, 20)
        doAddCondition(cid, HEADBUTT_EXHAUST_CONDITION)
        return true
    end

    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    return false
end
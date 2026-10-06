function getPlayerGuidByNameEx(name)
    local r = db.getResult("SELECT `id` FROM `players` WHERE `name` = " .. db.escapeString(name) .. " LIMIT 1;")
    local guid = nil

    if (r:getID() ~= -1) then
        repeat
            guid = r:getDataInt('id');
        until not r:next()
        r:free()
    end
    return guid
end

function doPlayerInsertStoredItem(cid, item)
    local query = string.concat("INSERT INTO player_stored_items (player_id, item_type, count, attributes) VALUES (",
        getPlayerGUID(cid), ",",
        item.itemid, ",",
        getItemCount(item.uid), ",",
        getItemAttributesBlob(item.uid), ");")

    if (db.executeQuery(query)) then
        doRemoveItem(item.uid)
        doPlayerSave(cid) -- let's save to prevent clone balls
        return true
    else
        log(LOG_TYPES.ERROR, "doPlayerInsertStoredItem - Can't query.", query)
    end

    return false
end

function doPlayerRemoveStoredItems(cid)
    local r = db.getResult("SELECT `item_type`, `attributes` FROM `player_stored_items` WHERE `player_id` = " .. getPlayerGUID(cid) .. ";")
    if (r:getID() ~= -1) then
        repeat
            local ball = doCreatePokemonBall(cid, r:getDataInt('item_type'), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, { column = 'attributes', result = r:getID() }, function(ball) doBallHeal(cid, { uid = ball }) end)

            if (not ball) then
                log(LOG_TYPES.ERROR, "doPlayerRemoveStoredItems - Can't create ball.", getCreatureName(cid), r:getDataInt('item_type'), r:getDataString('attributes'))
                return false
            end
        until not r:next()
        r:free()

        db.executeQuery("DELETE FROM `player_stored_items` WHERE player_id='" .. getPlayerGUID(cid) .. "';")
    end
    return true
end

function getNpcAtPosition(pos, npcName)
    local spec = getSpectators(pos, 1, 1, false)
    if (spec) then
        for k, v in pairs(spec) do
            if (isNpc(v) and getCreatureName(v) == npcName) then
                return v
            end
        end
    end
    return false
end

function getAlreadyNpcAround(pos, npcName)
    local spec = getSpectators(pos, 14, 14, false)
    if (spec) then
        for k, v in pairs(spec) do
            if (isNpc(v) and getCreatureName(v) == npcName) then
                return true
            end
        end
    end
    return false
end

function doRemoveItemTemporarily(pos, itemId, seconds)
    local item = getTileItemById(pos, itemId)
    if (not isItem(item)) then
        return false
    end

    doRemoveItem(item.uid)
    addEvent(doCreateItem, seconds * 1000, itemId, 1, pos)
end

function doGeneratePokemonMoveset(ballUid, pokemonName)
    if (not pokemonName) then
        pokemonName = getBallPokemonName(ballUid)
    end

    local ret = {}
    for _, move in pairs(getPokemonSkills(pokemonName, ballUid)) do
        ret[#ret + 1] = move
        ret[#ret + 1] = ";"
    end
    ret[#ret] = nil
    return table.concat(ret)
end

function doGeneratePokemonMovesetFromString(str)
    return string.explode(str, ";")
end

function getKillerFromList(deathList)
    local killer
    for i = 1, #deathList do
        killer = deathList[i]
        if (isCreature(killer)) then
            return killer
        end
    end
    return nil
end

function getPlateItemIdByName(msg)
    for name, itemId in pairs(PLATE_BY_NAME) do
        if (string.find(msg, name)) then
            return itemId
        end
    end
    return nil
end

function getItemSpecialDescription(uid)
    return getItemAttribute(uid, "description")
end

--[[
-- Maybe useful
 -
        local function getPlayerDuelWinByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_skills` WHERE `player_id` = '".. g .."' AND `skillid`=0;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerDuelLossByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_skills` WHERE `player_id` = '".. g .."' AND `skillid`=1;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerBattleWinByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_skills` WHERE `player_id` = '".. g .."' AND `skillid`=2;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerBattleLossByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_skills` WHERE `player_id` = '".. g .."' AND `skillid`=3;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerTournamentScoreByGuid(g)
            local r = db.getResult("SELECT `tournament_score` FROM `players` WHERE `player_id` = '".. g .."';")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("tournament_score")
            r:free()
            return ret
        end

        local function getPlayerTournamentScoreByGuid(g)
            local r = db.getResult("SELECT `tournament_score` FROM `players` WHERE `id` = '".. g .."';")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("tournament_score")
            r:free()
            return ret
        end

        local function getPlayerFrontierIslandScoreByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_highscores` WHERE `player_id` = '".. g .."' AND `score_id`=0;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerAchievementsScoreByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_highscores` WHERE `player_id` = '".. g .."' AND `score_id`=9;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerRangerClubScoreByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_highscores` WHERE `player_id` = '".. g .."' AND `score_id`=10;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerCaughtSpeciesByGuid(g)
            local r = db.getResult("SELECT `value` FROM `player_storage` WHERE `player_id` = '".. g .."' AND `key`=7059;")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("value")
            r:free()
            return ret
        end

        local function getPlayerLevelByGuid(g)
            local r = db.getResult("SELECT `level` FROM `players` WHERE `id` = '".. g .."';")

            if (r:getID() == -1) then
                return 0
            end

            local ret = r:getDataInt("level")
            r:free()
            return ret
        end
 -
 ]]

function setItemScriptProtected(itemUid, v)
    doItemSetAttribute(itemUid, "scriptprotected", v and true or false)
end

function isShinyName(str)
    return string.find(string.lower(str), "shiny")
end

function doGenerateAreaCheckParams(minX, maxX, minY, maxY, z, multicheck)
    local diffX, diffY = math.ceil((maxX - minX) / 2), math.ceil((maxY - minY) / 2)
    return { { x = minX + diffX, y = minY + diffY, z = z }, diffX, diffY, multicheck }
end

function getPlayerItemCountByUnique(cid, itemid) -- Returns only items unique-ownered by the player
    local ret = 0
    local backpack = getPlayerSlotItem(cid, PLAYER_SLOT_BACKPACK)
    if (isItem(backpack)) then
        local items = getContainerItems(backpack.uid, true)
        local guid = getPlayerGUID(cid)
        for _, item in pairs(items) do
            if (item.itemid == itemid and getItemUniqueOwner(item.uid) == guid) then
                ret = ret + getItemCount(item.uid)
            end
        end
    end
    return ret
end

function doPlayerRemoveItemByUnique(cid, itemid, count) -- Removes only items unique-ownered by the player
    local backpack = getPlayerSlotItem(cid, PLAYER_SLOT_BACKPACK)
    if (isItem(backpack)) then
        local items = getContainerItems(backpack.uid, true)
        local guid = getPlayerGUID(cid)
        for _, item in pairs(items) do
            if (count <= 0) then
                return true
            end

            if (item.itemid == itemid and getItemUniqueOwner(item.uid) == guid) then
                if (item.type > count) then
                    doRemoveItem(item.uid, count)
                    count = 0
                else
                    count = count - getItemCount(item.uid)
                    doRemoveItem(item.uid)
                end
            end
        end
    end
    return count <= 0
end

function math.round(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

--[[function createTextualTable(columns, data)
    local r = {}
    for _, colum in pairs(columns) do
        r[#r +1] = colum
        r[#r +1] = " | "
    end
    r[#r] = "\n"

    for _, item in pairs(data) do
        for k, value in pairs(item) do
            local max = string.len(columns[k])
            local actual = string.len(value)
            if (actual < max) then
                local diff = max - actual
                for i = 1, 2 do
                    for j = 1, math.floor((max - actual) / 2) do
                        if (i == 1) then -- Left add
                            value = " " .. value
                        else
                            value = value .. " "
                        end
                        diff = diff - 1
                    end
                end
                if (diff > 0) then
                    value = value .. " "
                end
            end

            r[#r +1] = value
            r[#r +1] = " | "
        end
        r[#r] = "\n"
    end

    return table.concat(r)
end]]

--[[ function doCreateMoney(money)
    local moneyMap = {
        {itemid = 2160, worth = 10000},
        {itemid = 2152, worth = 100},
        {itemid = 2148, worth = 1},
    }

    local r = {}
    local tmp = 0

    for k, v in pairs(moneyMap) do
        tmp = math.floor(money / v.worth)
        money = money - (tmp * v.worth)
        while (tmp > 0) do
            local item = doCreateItemEx(v.itemid, math.min(100, tmp))
            r[#r + 1] = item

            tmp = tmp - math.min(100, tmp)
        end
    end

    return r
end ]]

function isGamemaster(cid)
    return getCreatureCondition(cid, CONDITION_GAMEMASTER)
end

function isTutor(cid)
    local g = getPlayerGroupId(cid)
    return g == 2 or g == 8
end

function doPlayerSafeAddItem(cid, itemid, count, showMessage, unique, depot, afterCreate)
    if (depot == nil) then
        depot = true
    end

    local item = doCreateItemEx(itemid, count)
    if (not item) then
        return false
    end

    if (afterCreate) then
        afterCreate(item, cid)
    end

    if (unique) then
        setItemUniqueOwner(item, cid)
    end

    if (doPlayerAddItemEx(cid, item, false) ~= RETURNVALUE_NOERROR) then
        if (depot and doPlayerAddDepotItem(cid, 0, item)) then
            if (showMessage) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You received %sx %s into your depot."), count, getItemNameById(itemid)))
            end
            return true
        end

        return false
    end

    if (showMessage) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You received %sx %s."), count, getItemNameById(itemid)))
    end

    return true
end

function getGameTimeString()
    --[[
    local _time = ""
    local varh = (os.date('%M') * 60 + os.date('%S')) / 150
    local tibH = math.floor(varh)
    local tibM = math.floor(60 * (varh - tibH))

    if (tibH < 10) then
        tibH = '0' .. tibH
    end

    if (tibM < 10) then
        tibM = '0' .. tibM
    end

    _time = tibH .. ':' .. tibM
	return _time
	]]
    local worldTime = getWorldTime()
    local hours = 0
    local antiLoop = 0

    while (worldTime > 60) do
        hours = hours + 1
        worldTime = worldTime - 60

        antiLoop = antiLoop + 1
        if (antiLoop > 999) then
            log(LOG_TYPES.ERROR, "getGameTimeString - Anti loop reached", worldTime, hours)
            break
        end
    end

    return string.format("%02d:%02d", hours, worldTime)
end

function isItemUnique(uid)
    return getItemUniqueOwner(uid) > 0
end

function getPlayerInsideOrangeArchipelago(cid) -- Yeah, this is ugly
    return isInRange(getCreaturePosition(cid), {x = 2641, y = 1311, z = 7}, {x = 4647, y = 3486, z = 7}, true)
end

function getPlayerInsideHoenn(cid) -- Yeah, this is ugly
    return isInRange(getCreaturePosition(cid), {x = 48, y = 773, z = 7}, {x = 2224, y = 2304, z = 7}, true)
end

function doCreatureTrueDamage(cid, amount, effect, textColor, position)
    if (amount >= 0) then
        return
    end
    if (not position) then
        position = getCreaturePosition(cid)
    end
    doCreatureChangeHealth(cid, amount)
    doSendAnimatedText(position, tostring(amount), textColor)
    doSendMagicEffect(position, effect)
end

function doToggleDoor(position, openedItemId, closedItemId)
    local item = getTileItemById(position, closedItemId)
    if (isItem(item)) then
        doTransformItem(item.uid, openedItemId)
    else
        doTransformItem(getTileItemById(position, openedItemId).uid, closedItemId)
    end
end

function doCreatureIncreaseStorage(cid, storage, value)
    local v = tonumber(getCreatureStorage(cid, storage)) + (value or 1)
    doCreatureSetStorage(cid, storage, v)
    return v
end

function doPlayerAddUniqueItem(uid, itemid, count, canDropOnMap)
    local item = doPlayerAddItem(uid, itemid, count, canDropOnMap)
    if (item) then
        setItemUniqueOwner(item, uid)
    end
    return item
end

--[[
function periodicalEvent(eventFunc, conditionFunc, delay, autoRepeatDelay)
    delay = delay or 30
    autoRepeatDelay = autoRepeatDelay or delay

    local func
    func = function()
        if (conditionFunc and not conditionFunc()) then
            func = nil
            return
        end
        eventFunc()
        addEvent(func, delay)
    end

    addEvent(function() func() end, autoRepeatDelay)
end
]]
function isTable(v)
    return type(v) == 'table'
end
--[[
function isPosition(v)
    return v and isTable(v) and v.x and v.y and v.z
end

]]

function isBoolean(v)
    return type(v) == 'boolean'
end

function isSummon(cid)
    return getCreatureMaster(cid) ~= cid
end

function doCreateUniqueItemEx(cid, ...) -- doCreateItemEx(itemid, count)
    local item = doCreateItemEx(...)
    if (item) then
        setItemUniqueOwner(item, cid)
    end
    return item
end

function executeInArea(pos, area, cmd, ...) --by Nord and Mock
    local center = {}
    center.y = math.floor(#area / 2) + 1
    for y = 1, #area do
        for x = 1, #area[y] do
            local number = area[y][x]
            if number > 0 then
                center.x = math.floor(table.getn(area[y]) / 2) + 1
                local pos = { x = pos.x + x - center.x, y = pos.y + y - center.y, z = pos.z }
                if type(cmd) == 'string' then
                    local b = _G
                    b.pos = pos
                    local f = assert(loadstring(cmd))
                    setfenv(f, b)
                    f(pos, ...)
                elseif type(cmd) == 'function' then
                    cmd(pos, ...)
                end
            end
        end
    end
end

--[[function doCreatureDie(cid) -- Now source-coded, due to multi-thread bugs
    return doCreatureAddHealth(cid, -(getCreatureHealth(cid)))
end]]

function getSamePosition(pos1, pos2)
    return pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z
end

function getAllPlayersByAccountId(accountId)
    local dbResult, accountPlayers = db.getResult("SELECT `id` FROM `players` WHERE `account_id` = '" .. accountId .. "';"), {}
    if dbResult:getID() == -1 then
        return accountPlayers
    end
    repeat
        table.insert(accountPlayers, dbResult:getDataInt("id"))
    until not dbResult:next()
    dbResult:free()
    return accountPlayers
end

function getLevelByExp(EXP)
    return math.floor((math.sqrt(3) * math.sqrt(243 * (EXP + 1) ^ 2 - 48600 * (EXP + 1) + 3680000) + 27 * (EXP + 1) - 2700) ^ (1 / 3) / 30 ^ (2 / 3) - (5 * 10 ^ (2 / 3)) / (3 ^ (1 / 3) * (math.sqrt(3) * math.sqrt(243 * (EXP + 1) ^ 2 - 48600 * (EXP + 1) + 3680000) + 27 * (EXP + 1) - 2700) ^ (1 / 3)) + 2)
end

function randomize()
    math.randomseed(os.time() + math.random(100000))
    math.random(); math.random(); math.random()
end

function getContainerItems(uid, recursive)
    recursive = recursive ~= nil and recursive or false
    local containerItems = {}
    for i = 0, getContainerSize(uid) - 1 do
        local tmpItem = getContainerItem(uid, i)
        containerItems[#containerItems + 1] = tmpItem
        if (recursive and isContainer(tmpItem.uid)) then
            containerItems = table_concat(containerItems, getContainerItems(tmpItem.uid, recursive))
        end
    end
    return containerItems
end

function getSkyPosition(pos)
    return { x = pos.x - 9, y = pos.y - 7, z = pos.z }
end

function getSexDescription(sex)
    if (sex == POKEMON_SEX_FEMALE) then
        return "female"
    elseif (sex == POKEMON_SEX_MALE) then
        return "male"
    end
    return "sexless"
end

function doCreateTileInPosition(tileId, toPosition)
    doAreaCombatHealth(0, 0, toPosition, 0, 0, 0, 255)
    doCreateItem(tileId, 1, toPosition)
end

function hasTarget(cid)
    return getCreatureTarget(cid) > 0
end

function isItem(item)
    return item and item.uid ~= nil and item.itemid ~= nil and item.uid > 0 and item.itemid > 0
end

function isWalkable(cid, pos)
    return doTileQueryAdd(cid, pos, 0, false) == 1
end

function getTilesArroundPosition(position)
    local tilesArroundPosition = {}
    for y = -1, 1 do
        for x = -1, 1 do
            table.insert(tilesArroundPosition, { x = position.x + x, y = position.y + y, z = position.z, stackpos = STACKPOS_GROUND })
        end
    end
    return tilesArroundPosition
end

function deleteTilesArroundPositionWithId(position, id, checkFunc)
    for y = -1, 1 do
        for x = -1, 1 do
            local tmpPos = {
                x = position.x + x,
                y = position.y + y,
                z = position.z,
                stackpos = STACKPOS_GROUND
            }
            local tileItem = getTileItemById(tmpPos, id)
            if (isItem(tileItem) and (not checkFunc or checkFunc(tmpPos))) then
                doRemoveItem(tileItem.uid)
            end
        end
    end
end

function getUnsetTilesArroundPosition(position)
    local unsetTiles = {}
    for i, tilePosition in ipairs(getTilesArroundPosition(position)) do
        local tileItem = getTileThingByPos(tilePosition)
        if (not isItem(tileItem)) then
            table.insert(unsetTiles, tilePosition)
        end
    end
    return unsetTiles
end

function doSendProjectile(fromPosition, toCid, projectile)
    doSendDistanceShoot(fromPosition, getCreaturePosition(toCid), projectile)
end

local POKEMON_CALL_MESSAGES = {
    "go!",
    "I choose you!",
    "it's time to work!",
    "I need your help!",
    "it's the battle time!"
}

function doPokemonCall(cid, ball)
    if (getPlayerWatchingTV(cid)) then
        doPlayerSendCancel(cid, "You can't call your Pokemon while you're watching TV.")
        return false

    elseif (getPlayerTraveling(cid) or #getCreatureSummons(cid) > 0 or getSafariZone(cid) or getHouseFromPos(getCreaturePosition(cid)) or
            ((getPlayerDueling(cid) or getPlayerBattleing(cid)) and getPlayerDuelPokemonRemaing(cid) == 0)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local masterPosition = getCreaturePosition(cid)
    local destPos = (getPlayerMounted(cid) and masterPosition or getPositionRandomAdjacent(masterPosition, 2,
        function(tmpPos) return isSightClear(masterPosition, tmpPos, false, true) and isWalkable(cid, tmpPos) end))
    if (not destPos) then
        destPos = masterPosition
    end

    local pokemonName = getBallPokemonName(ball.uid)
    if (doSummonMonster(cid, pokemonName, false, destPos) ~= RETURNVALUE_NOERROR) then -- try to summon around the player, otherwise force to summon on player position
        doSummonMonster(cid, pokemonName, true) -- forced
    end

    local pokemon = (getCreatureSummons(cid))[1]
    if (not isMonster(pokemon)) then
        doPlayerSendCancel(cid, "You can't call your Pokemon here.")

    else
        local pokemonPosition = getCreaturePosition(pokemon)
        local pokemonPositionTileId = getThingFromPos({ x = pokemonPosition.x, y = pokemonPosition.y, z = pokemonPosition.z, stackpos = STACKPOS_GROUND }).itemid
        if (isInArray(WATER_IDS, pokemonPositionTileId) or pokemonPositionTileId == VOID_TILE_ID) then
            pokemonPosition = getCreaturePosition(cid)
            doTeleportThing(pokemon, pokemonPosition, false)
        end

        local pokemonLevel = getBallPokemonLevel(ball.uid)
        local pokemonExtraPoints = getBallPokemonExtraPoints(ball.uid)
        if (pokemonExtraPoints - pokemonLevel > POKEMON_MAX_EXTRA_POINTS_DIFF) then
            pokemonExtraPoints = pokemonLevel + POKEMON_MAX_EXTRA_POINTS_DIFF
            setBallPokemonExtraPoints(ball.uid, pokemonExtraPoints)
            doBallUpdateDescription(ball.uid)
            log(LOG_TYPES.WARNING, "Fixing Pokemon Extra Points", getCreatureName(cid), pokemonLevel, pokemonExtraPoints, pokemonName)
        end

        setMonsterExtraPoints(pokemon, pokemonExtraPoints)
        setMonsterLevel(pokemon, pokemonLevel) -- this need be here, to set correctly max hp
        Vitamin.onPokemonCall(pokemon, ball)
        PokemonHeldItem.onPokemonCall(pokemon, ball)
        PokemonAddon.onPokemonCall(pokemon, ball)

        local pokemonMaxHP = getCreatureMaxHealth(pokemon)
        local pokemonLastHP = getBallPokemonLastHp(ball.uid)
        local pokemonCurrentHP = pokemonLastHP - pokemonMaxHP
        local pokemonEnergy = getBallPokemonEnergy(ball.uid)
        local pokemonNickname = getBallPokemonNickname(ball.uid)
        local pokemonSex = getBallPokemonSex(ball.uid)
        local pokemonSpecialAbility = getBallPokemonSpecialAbility(ball.uid)

        if (pokemonSex == nil or pokemonSex < 0) then
            pokemonSex = math.random(POKEMON_SEX_FEMALE, POKEMON_SEX_MALE)
            setBallPokemonSex(ball.uid, pokemonSex)
            doBallUpdateDescription(ball.uid)
        end

        local typeSex = getMonsterInfo(pokemonName).sex
        if (typeSex > -1 and typeSex ~= pokemonSex) then
            log(LOG_TYPES.WARNING, "Fixing Pokemon Sex", getCreatureName(cid), pokemonName, pokemonSex,
                typeSex)
            pokemonSex = typeSex
            setBallPokemonSex(ball.uid, pokemonSex)
            doBallUpdateDescription(ball.uid)
        end

        if (pokemonSpecialAbility == nil or pokemonSpecialAbility < 0 or
                pokemonSpecialAbility == POKEMON_SPECIAL_ABILITY_IDS.NONE or
                not table.find(getPokemonSpecialAbilities(pokemonName), pokemonSpecialAbility)) then
            pokemonSpecialAbility = getPokemonRandomSpecialAbility(pokemonName)
            if (pokemonSpecialAbility ~= POKEMON_SPECIAL_ABILITY_IDS.NONE) then
                setBallPokemonSpecialAbility(ball.uid, pokemonSpecialAbility)
                doBallUpdateDescription(ball.uid)
            end
        end

        setCreatureMaxHealth(pokemon, pokemonMaxHP)
        doCreatureChangeHealth(pokemon, pokemonCurrentHP) --doCreatureAddHealth(pokemon, pokemonCurrentHP)
        doCreatureSetStorage(cid, playersStorages.isPokemonOnline, 1)
        doCreatureSetStorage(cid, playersStorages.pokemonUid, pokemon)
        doCreatureSetStorage(cid, playersStorages.pokemonName, pokemonName)
        registerCreatureEvent(pokemon, "onPokemonDeath")
        setCreatureMaxMana(cid, getBallPokemonMaxEnergy(ball.uid)
                * getMonsterVarPokeStat(pokemon, MONSTER_POKE_STATS.MAXENERGY))
        doCreatureAddMana(cid, pokemonEnergy, false)
        setMonsterSpecialAbility(pokemon, pokemonSpecialAbility)
        doPokemonUpdateStats(pokemon, ball.uid)
        setMonsterSex(pokemon, pokemonSex)
        doAddExhaust(cid)
        doPlayerSendPokemonWindowUpdatePokemonIcon(cid, getFastcallNumber(ball.uid), 3, __L(cid, "USE"))
        setPlayerVulnerable(cid, false)
        addEvent(checkPokemonHungry, 60 * 1000, pokemon)

        if (getPlayerMastery(cid) and not getPlayerTournamentReady(cid)) then
            local mastery = getPlayerMastery(cid)
            for i, j in ipairs(getPokemonTypes(pokemon, pokemonName)) do
                if (isInArray(getMasteryElements(mastery), j)) then
                    setPokemonBonusAttack(pokemon, getMasteryRankBonusAttack(mastery, getPlayerMasteryRank(cid)))
                    -- setPokemonBonusDefense(pokemon, getMasteryRankBonusDefense(mastery, getPlayerMasteryRank(cid)))
                    break
                end
            end
        end

        if (pokemonNickname ~= nil and pokemonNickname ~= -1) then
            if (isPokemonName(pokemonNickname)) then
                setBallPokemonNickname(ball.uid, nil, true)
            else
                setCreatureNickname(pokemon, pokemonNickname)
            end
        end

        if (isFlying(cid)) then
            doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)
            setFlyingStatus(cid, false)
            doCreatureSay(cid, string.format(__L(cid, "%s, I'm tired of flying!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)

            local transform = getBallCurrentTransform(ball.uid)
            if (transform) then
                doAbilitieTransform(cid, pokemon, nil, transform, true)
            end

        elseif (isLevitating(cid)) then
            doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)
            setLevitatingStatus(cid, false)
            doCreatureSay(cid, string.format(__L(cid, "%s, I'm tired of levitating!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)

            local transform = getBallCurrentTransform(ball.uid)
            if (transform) then
                doAbilitieTransform(cid, pokemon, nil, transform, true)
            end

        elseif (isRiding(cid)) then
            doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)
            setRidingStatus(cid, false)
            doCreatureSay(cid, string.format(__L(cid, "%s, I'm tired of riding!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)

            local transform = getBallCurrentTransform(ball.uid)
            if (transform) then
                doAbilitieTransform(cid, pokemon, nil, transform, true)
            end

        elseif (isSurfing(cid)) then
            doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)
            setSurfingStatus(cid, false)
            doCreatureSay(cid, string.format(__L(cid, "%s, I'm tired of surfing!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)

            local transform = getBallCurrentTransform(ball.uid)
            if (transform) then
                doAbilitieTransform(cid, pokemon, nil, transform, true)
            end

        elseif (isDiving(cid)) then
            doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)
            setDivingStatus(cid, false)
            doCreatureSay(cid, string.format(__L(cid, "%s, I'm tired of diving!"), getCreatureNickname(pokemon)), TALKTYPE_MONSTER)

            local transform = getBallCurrentTransform(ball.uid)
            if (transform) then
                doAbilitieTransform(cid, pokemon, nil, transform, true)
            end

        else
            local ballName = ballsNames[ball.itemid]

            doSendDistanceShoot(getCreaturePosition(cid), pokemonPosition, balls[ballName].projectile)
            addEvent(doSendProjectile, 500, pokemonPosition, cid, balls[ballName].projectile)
            doTransformItem(ball.uid, balls[ballName].inUse)
            doSendMagicEffect(pokemonPosition, balls[ballName].effects.use)
            doCreatureSay(cid, getCreatureNickname(pokemon) .. ", " .. __L(cid, POKEMON_CALL_MESSAGES[math.random(1, #POKEMON_CALL_MESSAGES)]))

            addEvent(function()
                if (isCreature(pokemon)) then
                    doSendCreatureEffect(pokemon, CREATURE_EFFECTS.RED_FADE_IN)
                end
            end, 10)

            if (getPlayerDueling(cid) or getPlayerBattleing(cid)) then
                doAddCondition(cid, pokemonCallDelayCondition)
                if (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.DUELRUNAWAY)) then
                    doAddExhaust(cid)
                end
            end

            if (getBallSeal(ball.uid) ~= BALL_SEAL_IDS.NONE) then
                doBallSealAnimationStart(getBallSeal(ball.uid), pokemonPosition)
            end

            doPlayerCheckTms(cid)
        end
    end
    return true
end

function getPositionAdjacent(cid, targetPos, checkPath)
    local dirs = { NORTH, EAST, SOUTH, WEST, SOUTHWEST, SOUTHEAST, NORTHWEST, NORTHEAST }
    for k, v in ipairs(dirs) do
        local pos = { x = targetPos.x, y = targetPos.y, z = targetPos.z }
        pos = getPositionByDirection(pos, v, 1)
        if (isWalkable(cid, pos) and (not checkPath or getPathToEx(cid, pos))) then
            return pos
        end
    end
    return nil
end

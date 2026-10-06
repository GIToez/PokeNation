local config = {
	maxLevel = getConfigInfo('maximumDoorLevel')
}

local increasingItems = {[416] = 417, [426] = 425, [446] = 447, [3216] = 3217, [3202] = 3215, [11059] = 11060}
local decreasingItems = {[417] = 416, [425] = 426, [447] = 446, [3217] = 3216, [3215] = 3202, [11060] = 11059}
local depots = {2589, 2590, 2591, 2592}

local ROCKS = {
	{position = {x = 3600, y = 260, z = 11}, newPosition = {x = 3600, y = 259, z = 11}, itemid = 1353},
}

local checkCreature = {isPlayer, isMonster, isNpc}
local function pushBack(cid, position, fromPosition, displayMessage, customMessage)
	addEvent(doTeleportThing, 1, cid, fromPosition, false) -- Fix a strang bug that occurs if you step in a tile from far and need be pushed back (Look likes the bug occurs when a effects is called and the creature step in a tile from far)
	--doSendMagicEffect(position, CONST_ME_MAGIC_BLUE)
	if(displayMessage) then
		if (customMessage) then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, customMessage)
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The tile seems to be protected against unwanted intruders.")
		end
	end
end

local TILES = {}
local TILES_OUT = {}
-- TILES[itemid][actionid] = callback
TILES[446] = {}
TILES[426] = {}
TILES_OUT[425] = {}

local function checkBattleTower(cid, position, fromPosition, storage)
    if (os.time() - getPlayerLastDefeatedNpc(cid, storage) > 10800) then
        pushBack(cid, position, fromPosition, true)
    end
    return true
end

TILES[446][300] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11007)
end

TILES[446][301] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11025)
end

TILES[446][302] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11016)
end

TILES[446][303] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11032)
end

TILES[446][304] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11013)
end

TILES[446][305] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11002)
end

TILES[446][306] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11026)
end

TILES[446][307] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11021)
end

TILES[446][308] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11044)
end

TILES[446][309] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11024)
end

TILES[446][310] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11040)
end

TILES[446][311] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11012)
end

TILES[446][312] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11010)
end

TILES[446][313] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11033)
end

TILES[446][314] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11014)
end

TILES[446][315] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11031)
end

TILES[446][316] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11046)
end

TILES[446][317] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11022)
end

TILES[446][318] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11023)
end

TILES[446][319] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11003)
end

TILES[446][320] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11038)
end

TILES[446][321] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11037)
end

TILES[446][322] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11005)
end

TILES[446][323] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11034)
end

TILES[446][324] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11029)
end

TILES[446][325] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11042)
end

TILES[446][326] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11006)
end

TILES[446][327] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11019)
end

TILES[446][328] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11028)
end

TILES[446][329] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11009)
end

TILES[446][330] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11036)
end

TILES[446][331] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11011)
end

TILES[446][332] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11015)
end

TILES[446][333] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11008)
end

TILES[446][334] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11018)
end

TILES[446][335] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11027)
end

TILES[446][336] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11000)
end

TILES[446][337] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11004)
end

TILES[446][338] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11035)
end

TILES[446][339] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11043)
end

TILES[446][340] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11047)
end

TILES[446][341] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11020)
end

TILES[446][342] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11030)
end

TILES[446][343] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11001)
end

TILES[446][344] = function(cid, item, position, fromPosition)
    return checkBattleTower(cid, position, fromPosition, 11017)
end

-- Ranger Club TM Substitute Dungeon
TILES[446][345] = function(cid, item, position, fromPosition)
    if (not getPlayerDefeatedNPC(cid, 9673)) then
        return false
    end

    -- Reset robots
    local ROBOT_STORAGE = 1000
    local ROBOT_VALUE = 1
    local CHECK_POSITIONS = {
        doGenerateAreaCheckParams(4896, 4908, 288, 300, 8, false),
        doGenerateAreaCheckParams(4895, 4909, 285, 308, 9, false),
        doGenerateAreaCheckParams(4893, 4911, 301, 317, 10, false),
    }
    local NPC_NAME = "Substitute"
    local QUEST_STEP_STORAGE = 8397

    local robots = {}
    for _, check in pairs(CHECK_POSITIONS) do
        local spec = getSpectators(check[1], check[2], check[3], check[4])
        if (spec) then
            for _, v in pairs(spec) do
                if (isNpc(v) and getCreatureName(v) == NPC_NAME) then
                    doCreatureSetStorage(v, ROBOT_STORAGE, ROBOT_VALUE)
                    robots[#robots + 1] = v
                end
            end
        end
    end
    doCreatureSetStorage(table.random(robots), ROBOT_STORAGE, 0) -- The real

    return doTeleportThing(cid, {x = 4897, y = 300, z = 8})
end

-- Ranger Club TM Substitute Dungeon
TILES[446][346] = function(cid, item, position, fromPosition)
    if (getCreatureStorage(cid, 8397) ~= QUEST_STATUS.FINISHED) then -- check if the last step is done
        return false
    end

    local npcName = "Target"
    local npcPositions = {
        {x = 4897, y = 274, z = 8},
        {x = 4898, y = 276, z = 8},
        {x = 4900, y = 278, z = 8},
        {x = 4903, y = 278, z = 8},
        {x = 4906, y = 278, z = 8},
        {x = 4908, y = 276, z = 8},
        {x = 4909, y = 274, z = 8},
    }

    for _, pos in pairs(npcPositions) do -- Reseting quest
        local c = getTopCreature(pos).uid
        if (not isCreature(c)) then
            doCreateNpc(npcName, pos, false)
        else
            doCreatureRemoveStatus(c, CREATURE_STATUS_SUBSTITUTE)
        end
    end

    if (doPlayerSafeAddItem(cid, 18885, 15 - getPlayerItemCount(cid, 18885), true, true, false)) then -- Target markers
        doTeleportThing(cid, {x = 4903, y = 273, z = 8}) -- Inside room
    end

    return false
end

-- Ranger Club TM Substitute Quest - Entering Dungeon from Ranger Club building
TILES[446][347] = function(cid, item, position, fromPosition)
    if (getCreatureStorage(cid, 8396) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    -- Check if there is people doing the dungeon
    local checkPositions = {
        doGenerateAreaCheckParams(4895, 4907, 267, 326, 8, false),
        doGenerateAreaCheckParams(4895, 4911, 285, 337, 9, false),
        doGenerateAreaCheckParams(4893, 4911, 301, 317, 10, false),
    }

    for _, check in pairs(checkPositions) do
        local spec = getSpectators(check[1], check[2], check[3], check[4])
        if (spec) then
            for _, v in pairs(spec) do
                if (isPlayer(v)) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                        "There are players completing the dungeon at the moment, you must try again later.")
                    return false
                end
            end
        end
    end

    -- Reset battle NPCs storage
    for i = 0, 5 do
        doCreatureSetStorage(cid, 9669 + i, nil) -- levelStorage
        doCreatureSetStorage(cid, 9269 + i, nil) -- lastBattleTimeStorage
    end

    if (doTeleportThing(cid, {x = 4907, y = 335, z = 9})) then
        setPlayerBlockLogout(cid, true)
        doSetStorage(GLOBAL_STORAGES.QUEST_TM_SUBSTITUTE_ROBOT_TRIES, 0)
    end

    return true
end

--
TILES[426][300] = function(cid, item, position, fromPosition)
    doToggleDoor({x = 4936, y = 393, z = 8}, 1253, 1254)
    return true
end
TILES_OUT[425][300] = TILES[426][300]

TILES[426][301] = function(cid, item, position, fromPosition)
    doToggleDoor({x = 4934, y = 367, z = 8}, 1250, 1251)
    return true
end
TILES_OUT[425][301] = TILES[426][301]

TILES[426][302] = function(cid, item, position, fromPosition)
    local spec = getSpectators({x = 4953, y = 393, z = 8}, 40, 37, true)
    if (spec) then
        for _, tmpCid in pairs(spec) do
            doTeleportThing(tmpCid, {x = 4933, y = 425, z = 8})
            doPlayerSendTextMessage(tmpCid, MESSAGE_EVENT_ADVANCE,
                "Good work! Now open the chest and go talk with Harold Sheen.")
        end
    end
    return true
end

function onStepIn(cid, item, position, fromPosition)
	if(increasingItems[item.itemid]) then
		if (not isPlayerGhost(cid, true)) then
            doTransformItem(item.uid, increasingItems[item.itemid])
        end
	end

	if(item.actionid >= 194 and item.actionid <= 196) then
		local f = checkCreature[item.actionid - 193]
		if(f(cid)) then
			pushBack(cid, position, fromPosition, false)
		end

		return true
	end

	if(item.actionid >= 191 and item.actionid <= 193) then
		local f = checkCreature[item.actionid - 190]
		if(not f(cid)) then
			pushBack(cid, position, fromPosition, false)
		end

		return true
	end

	if(not isPlayer(cid)) then
		return true
    end

    if(item.actionid == 188) then
		for i, rock in ipairs(ROCKS) do
			doRemoveItem(getTileItemById(rock.position, rock.itemid).uid)
		end
		return true
	end

	if(item.actionid >= 1000) then
		if(getPlayerLevel(cid) < item.actionid - 1000) then
			pushBack(cid, position, fromPosition, true, string.format(__L(cid, "You need at least level %s to pass here."), item.actionid - 1000))
		end

		return true
	end

	if(item.actionid == 189) then
		if (not isPremium(cid)) then
			pushBack(cid, position, fromPosition, true, __L(cid, "Only premium accounts can pass here."))
		end

		return true
	end

	local gender = item.actionid - 186
	if(isInArray({PLAYERSEX_FEMALE,  PLAYERSEX_MALE, PLAYERSEX_GAMEMASTER}, gender)) then
		if(gender ~= getPlayerSex(cid)) then
			pushBack(cid, position, fromPosition, true)
		end

		return true
	end

	local skull = item.actionid - 180
	if(skull >= SKULL_NONE and skull <= SKULL_BLACK) then
		if(skull ~= getCreatureSkullType(cid)) then
			pushBack(cid, position, fromPosition, true)
		end

		return true
	end

	local group = item.actionid - 150
	if(group >= 0 and group < 30) then
		if(group > getPlayerGroupId(cid)) then
			pushBack(cid, position, fromPosition, true)
		end

		return true
	end

	local vocation = item.actionid - 100
	if(vocation >= 0 and vocation < 50) then
		local playerVocationInfo = getVocationInfo(getPlayerVocation(cid))
		if(playerVocationInfo.id ~= vocation and playerVocationInfo.fromVocation ~= vocation) then
			pushBack(cid, position, fromPosition, true)
		end

		return true
    end

    if (TILES[item.itemid] and TILES[item.itemid][item.actionid]) then
        return TILES[item.itemid][item.actionid](cid, item, position, fromPosition)
    end

	if(item.actionid ~= 0 and getPlayerStorageValue(cid, item.actionid) <= 0) then
		pushBack(cid, position, fromPosition, true)
		return true
	end

	if(getTileInfo(position).protection) then
		local depotPos, depot = getCreatureLookPosition(cid), {}
		depotPos.stackpos = STACKPOS_GROUND
		while(true) do
			if(not getTileInfo(depotPos).depot) then
				break
			end

			depotPos.stackpos = depotPos.stackpos + 1
			depot = getThingFromPos(depotPos)
			if(depot.uid == 0) then
				break
			end

			if(isInArray(depots, depot.itemid)) then
				local depotItems = getPlayerDepotItems(cid, getDepotId(depot.uid))
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, string.format(__L(cid, "Your depot contains %s item%s."), depotItems, (depotItems > 1 and "s" or "")))
				break
			end
		end

		return true
	end

	return false
end

function onStepOut(cid, item, position, fromPosition)
	if(decreasingItems[item.itemid]) then
		if (not isPlayerGhost(cid, true)) then
            doTransformItem(item.uid, decreasingItems[item.itemid])
            --return true
        end
	end

	if(item.actionid == 188 and isPlayer(cid)) then
		for i, rock in ipairs(ROCKS) do
			doCreateItem(rock.itemid, 1, rock.position)
			doRelocate(rock.position, rock.newPosition)
		end
    end

    if (TILES_OUT[item.itemid] and TILES_OUT[item.itemid][item.actionid]) then
        return TILES_OUT[item.itemid][item.actionid](cid, item, position, fromPosition)
    end

	return true
end

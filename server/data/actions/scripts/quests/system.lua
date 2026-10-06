local QUESTS = {} -- Add custom checks
-- QUESTS[uid] = function(cid, item, fromPosition, itemEx, toPosition) return value, message end

QUESTS[60008] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 30, __L(cid, "You must be at least level 30 to open this chest.")
end

QUESTS[60009] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid)>= 40, __L(cid, "You must be at least level 40 to open this chest.")
end

QUESTS[60010] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 50, __L(cid, "You must be at least level 50 to open this chest.")
end

QUESTS[60011] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 20, __L(cid, "You must be at least level 20 to open this chest.")
end

QUESTS[60012] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 25, __L(cid, "You must be at least level 25 to open this chest.")
end

QUESTS[60013] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 30, __L(cid, "You must be at least level 30 to open this chest.")
end

QUESTS[60014] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 15, __L(cid, "You must be at least level 15 to open this chest.")
end

QUESTS[60015] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 30, __L(cid, "You must be at least level 30 to open this chest.")
end

QUESTS[60016] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 25, __L(cid, "You must be at least level 25 to open this chest.")
end

QUESTS[60017] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 25, __L(cid, "You must be at least level 25 to open this chest.")
end

QUESTS[60018] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 50, __L(cid, "You must be at least level 50 to open this chest.")
end

QUESTS[60019] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 30, __L(cid, "You must be at least level 30 to open this chest.")
end

QUESTS[60020] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 30, __L(cid, "You must be at least level 30 to open this chest.")
end

QUESTS[60022] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 35, __L(cid, "You must be at least level 35 to open this chest.")
end

QUESTS[60021] = function(cid, item, fromPosition, itemEx, toPosition)
    return getPlayerLevel(cid) >= 50, __L(cid, "You must be at least level 50 to open this chest.")
end

-- Captain Neil Pace reward chest
QUESTS[60025] = function(cid, item, fromPosition, itemEx, toPosition)
    return getCreatureStorage(cid, 8435) == QUEST_STATUS.FINISHED, __L(cid, "You cannot open this chest.")
end

-- Kanto Main 5 - Rocket Trap Chest
QUESTS[60027] = function(cid, item, fromPosition, itemEx, toPosition)
    setPlayerStorageValue(cid, 60027, 1)
    doSendMagicEffect(fromPosition, EFFECT_BIG_EXPLOSION)

    for i = 1, 5 do
        doCreateMonster("Unstable Voltorb", getPositionRandomAdjacent(toPosition))
    end

    return false, __L(cid, "It's a trap!")
end

-- Tutorial Island - Receiving a Pikachu
QUESTS[60028] = function(cid, item, fromPosition, itemEx, toPosition)
    local ball = doCreatePokemonBall(cid, "poke", "Pikachu", 10, nil, "Tutorial's Pikachu", 0, cid, false, nil, nil, nil, nil,
        nil, nil, nil, nil, false)
    if (ball) then
        setBallFromNpc(ball, true)
        -- We are returning false to stop the script to continue, but the quest has been marked as done by here
        setPlayerStorageValue(cid, 60028, 1)
        return false, __L(cid, "You received a Pikachu.")
    end

    return false, __L(cid, "Please check your backpack.")
end

local ON_COMPLETE = {} -- Execute when player get the chest reward
-- Ranger Club TM Substitute Quest - Backing to Ranger Club building
ON_COMPLETE[60023] = function(cid, item, fromPosition, itemEx, toPosition)
    if (doTeleportThing(cid, {x = 5316, y = 402, z = 7})) then
        setPlayerBlockLogout(cid, false)
    end
end

-- Captain Neil Pace reward chest
ON_COMPLETE[60025] = function(cid, item, fromPosition, itemEx, toPosition)
    doSendMagicEffect(fromPosition, EFFECT_MEW)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Look!")
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.OPEN_NEIL_PACE_CHEST)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(getPlayerCustomFlagValue(cid, PLAYERCUSTOMFLAG_GAMEMASTERPRIVILEGES)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF, cid)
		return true
	end

	local storage = item.uid
	if(storage > 65535) then
        return false
    end

	if(getPlayerStorageValue(cid, storage) > 0) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It is empty.")
		return true
    end

    if (QUESTS[storage]) then
        local result, message = QUESTS[storage](cid, item, fromPosition, itemEx, toPosition)
        if (not result) then
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, message)
            return true
        end
    end

	local items = {}
	local reward = 0

	local size = isContainer(item.uid) and getContainerSize(item.uid) or 0
	if(size == 0) then
		reward = doCopyItem(item, false)
	else
		for i = 0, size do
			local tmp = getContainerItem(item.uid, i)
			if(tmp.itemid > 0) then
				table.insert(items, tmp)
			end
		end
	end

	size = table.maxn(items)
	if(size == 1) then
		reward = doCopyItem(items[1], true)
	end

	local result = ""
	if(reward ~= 0) then
		local ret = getItemDescriptions(reward.uid)
		if(reward.type > 0 and isItemRune(reward.itemid)) then
			result = reward.type .. " charges " .. ret.name
		elseif(reward.type > 0 and isItemStackable(reward.itemid)) then
			result = reward.type .. " " .. ret.plural
		else
			result = ret.article .. " " .. ret.name
		end
	else
		if(size > 20) then
			reward = doCopyItem(item, false)
		elseif(size > 8) then
			reward = getThing(doCreateItemEx(13214, 1)) -- backpack
		else
			reward = getThing(doCreateItemEx(12282, 1)) -- bag
		end

		for i = 1, size do
			local tmp = doCopyItem(items[i], true)
			if(doAddContainerItemEx(reward.uid, tmp.uid) ~= RETURNVALUE_NOERROR) then
				print("[Warning] QuestSystem:", "Could not add quest reward")
			else
				local ret = ", "
				if(i == 2) then
					ret = " and "
				elseif(i == 1) then
					ret = ""
				end

				result = result .. ret
				ret = getItemDescriptions(tmp.uid)
				if(tmp.type > 0 and isItemRune(tmp.itemid)) then
					result = result .. tmp.type .. " charges " .. ret.name
				elseif(tmp.type > 0 and isItemStackable(tmp.itemid)) then
					result = result .. tmp.type .. " " .. ret.plural
				else
					result = result .. ret.article .. " " .. ret.name
				end
			end
		end
	end

	if(doPlayerAddItemEx(cid, reward.uid, false) ~= RETURNVALUE_NOERROR) then
		result = __L(cid, "You have not enough space.")
	else
		result = string.format(__L(cid, "You have found %s."), result)
		setPlayerStorageValue(cid, storage, 1)

        if (ON_COMPLETE[storage]) then
            ON_COMPLETE[storage](cid, item, fromPosition, itemEx, toPosition)
        end
    end

    local tmpItems = {reward}
    if (isContainer(reward.uid)) then
        tmpItems = table_concat(tmpItems, getContainerItems(reward.uid, true))
    end

    for k, v in pairs(tmpItems) do
        if (getItemInfo(v.itemid).worth == 0) then
            setItemUniqueOwner(v.uid, cid)
        end
    end

	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, result)
	return true
end

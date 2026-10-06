if (OxygenMask) then
    return
end

OxygenMask = {}

-- Config
OxygenMask.Equipments = {}
OxygenMask.Equipments[#OxygenMask.Equipments + 1] = {unlockedItemId = 13299, lockedItemId = 13300,
    speedCondition = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.OXYGEN_MASK) }
setConditionParam(OxygenMask.Equipments[1].speedCondition, CONDITION_PARAM_SPEED, 200)

OxygenMask.Equipments[#OxygenMask.Equipments + 1] = {unlockedItemId = 18874, lockedItemId = 18875,
    speedCondition = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.OXYGEN_MASK)}
setConditionParam(OxygenMask.Equipments[2].speedCondition, CONDITION_PARAM_SPEED, 400)

-- Methods
OxygenMask.doPlayerLock = function(cid)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
        if (isItem(item)) then
        for _, equip in pairs(OxygenMask.Equipments) do
            if (item.itemid == equip.unlockedItemId) then
                doTransformItem(item.uid, equip.lockedItemId)
                return true
            end
        end
    end

    return false
end

OxygenMask.doPlayerUnlock = function(cid)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    if (isItem(item)) then
        for _, equip in pairs(OxygenMask.Equipments) do
            if (item.itemid == equip.lockedItemId) then
                doTransformItem(item.uid, equip.unlockedItemId)
                return true
            end
        end
    end

    return false
end

OxygenMask.onEnter = function(cid, item, position, lastPosition, fromPosition, toPosition, actor, secure)
    if (isPlayer(cid)) then
        if (not isRiding(cid) and not isFlying(cid) and not isLevitating(cid) and
                (secure or getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.DIVE, getPlayerPokemonName(cid, true))) and
                OxygenMask.doPlayerLock(cid)) then
            setUnderwaterStatus(cid, true)

            if (not secure) then
                dive(cid)
            end

            --[[if (item.actionid == 2000) then -- Special AID: Remove after first player enters
                doRemoveItem(item.uid)
            end]]

        else
            doTeleportThing(cid, lastPosition, true)
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return true
        end
    else
        doTeleportThing(cid, lastPosition, true)
        return false
    end

    return doTeleportThing(cid, {x = position.x - 1, y = position.y - 1, z = position.z + 1}, true)
end

OxygenMask.onLeave = function(cid, item, position, lastPosition, fromPosition, toPosition, actor, secure)
    if (isPlayer(cid)) then
        if (not secure) then
            if (isDiving(cid)) then
                OxygenMask.doPlayerUnlock(cid)
                setUnderwaterStatus(cid, false)
                deDive(cid)
                surf(cid, toPosition)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
                doTeleportThing(cid, {x = lastPosition.x - 1, y = lastPosition.y, z = lastPosition.z}, true)
            end

        else
            if (isDiving(cid)) then
                doPlayerSendCancel(cid, "You can't leave while you're diving.")
                doTeleportThing(cid, {x = lastPosition.x - 1, y = lastPosition.y, z = lastPosition.z}, true)
            else
                OxygenMask.doPlayerUnlock(cid)
                setUnderwaterStatus(cid, false)
            end
        end

    else
        doTeleportThing(cid, {x = lastPosition.x - 1, y = lastPosition.y, z = lastPosition.z}, true)
    end

    return true
end

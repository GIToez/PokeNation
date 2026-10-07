local currentPresents = nil

function onRaid()
    setGlobalStorageValue(GLOBAL_STORAGES.EVENT_CHRISTMAS_PRESENT_COUNT, 0)

    -- Spawn Presents
    local centerPos = {x = 5419, y = 391, z = 7 }
    local presentsItemIds = {25264, 25265, 25266, 25267, 25268}
    currentPresents = {}
    local deployedPresents = 0
    local removedPresents = 0

    for i = 1, 200 do
        local presentItemId = table.random(presentsItemIds)
        local present = doCreateItemEx(presentItemId, 1)
        local pos = getPositionRandomAdjacent(centerPos, getRandom(1, 10),
            function(tmpPos) return doTileQueryAdd(present, tmpPos) == RETURNVALUE_NOERROR end)
        if (pos and doTileAddItemEx(pos, present)) then
            currentPresents[#currentPresents + 1] = {pos = pos, itemId = presentItemId }
            deployedPresents = deployedPresents + 1
        end
    end

    local doRemovePresent = nil
    doRemovePresent = function()
        local present = table.randomRemove(currentPresents)
        if (present) then
            local presentItem = getTileItemById(present.pos, present.itemId)
            if (isItem(presentItem)) then
                doRemoveItem(presentItem.uid)
                doSendMagicEffect(present.pos, EFFECT_POFF)
                doSendDistanceShoot(present.pos, getSkyPosition(present.pos), PROJECTILE_GRAVEL)
                removedPresents = removedPresents + 1
            end
        end

        local remaing = deployedPresents - (getGlobalStorageValue(GLOBAL_STORAGES.EVENT_CHRISTMAS_PRESENT_COUNT) + removedPresents)
        if (remaing > 0) then
            addEvent(doRemovePresent, getRandom(1, 5) * 1000)
        else
            local count = getGlobalStorageValue(GLOBAL_STORAGES.EVENT_CHRISTMAS_PRESENT_COUNT)
            local rate = 0
            if (count >= 71) then
                rate = 100
            elseif (count >= 51) then
                rate = 70
            elseif (count >= 31) then
                rate = 50
            elseif (count >= 21) then
                rate = 30
            elseif (count >= 1) then
                rate = 20
            end

            doBroadcastMessage(string.format("The Grinch invasion has ended! %s presents were recovered (%s%% exp bonus)! Use the Santa chair to receive your reward.",
                count, rate))
        end
    end

    local doBroadcastEvent = nil
    doBroadcastEvent = function()
        local remaing = deployedPresents - (getGlobalStorageValue(GLOBAL_STORAGES.EVENT_CHRISTMAS_PRESENT_COUNT) + removedPresents)
        if (remaing > 0) then
            doBroadcastMessage(string.format("Grinch Invasion - Remaing %s present%s.", remaing, (remaing > 1 and "s" or "")))
            addEvent(doBroadcastEvent, 60 * 1000)
        end
    end

    addEvent(doRemovePresent, 2 * 60 * 1000)
    addEvent(doBroadcastEvent, 60 * 1000)

    return true
end
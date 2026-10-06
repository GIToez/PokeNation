local stoneStorage = 8241
local flamesPlaces = {
    {x = 3919, y = 3042, z = 6},
    {x = 3920, y = 3044, z = 6},
    {x = 3921, y = 3046, z = 6},
    {x = 3919, y = 3048, z = 6},
    {x = 3915, y = 3048, z = 6},
    {x = 3913, y = 3046, z = 6},
    {x = 3914, y = 3044, z = 6},
    {x = 3915, y = 3042, z = 6},
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8240) ~= QUEST_STATUS.STARTED) then -- Quest Storage
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (getCreatureStorage(cid, stoneStorage) ~= QUEST_STATUS.FINISHED) then
        doCreatureSetStorage(cid, stoneStorage, QUEST_STATUS.FINISHED)
    end

    doShowTextDialog(cid, item.itemid, "In the hidden world will emerge a stranger. The people need help once again. The big three are gone and their legacy has been left behind. The elder will lead your way.")

    local lastPos
    for i, pos in pairs(flamesPlaces) do
        addEvent(function()
            local item = getTileItemById(pos, 9957)
            if (isItem(item)) then
                if (lastPos) then
                    doSendDistanceShoot(lastPos, pos, PROJECTILE_FIRE_BLUE)
                end

                doSendMagicEffect(pos, EFFECT_FIRE_BLUE)

                doTransformItem(item.uid, 18250)
                doDecayItem(item.uid)
            end

            lastPos = pos
        end, i * 200)
    end

	return true
end

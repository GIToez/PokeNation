local stoneItemId = 1551
local stonePositions = {
    {x = 3901, y = 3056, z = 7},
    {x = 3902, y = 3056, z = 7}
}

local magicwallItemId = 1497
local magicwallPositions = {
    {x = 3902, y = 3045, z = 7},
    {x = 3902, y = 3046, z = 7},
    {x = 3902, y = 3047, z = 7},
    {x = 1553, y = 3047, z = 7},
    {x = 3904, y = 3047, z = 7},
    {x = 3905, y = 3047, z = 7},
    {x = 3906, y = 3047, z = 7},
    {x = 3906, y = 3046, z = 7},
    {x = 3906, y = 3045, z = 7}
}


function onPrepareDeath(cid, deathList)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_DARK_PULSE)
    doCreatureSay(cid, "MUAHUAHUAMUAUA", TALKTYPE_ORANGE_1)
    doRemoveCreature(cid)

    -- Remove magicwalls
    for k, v in pairs(magicwallPositions) do
        local item = getTileItemById(v, magicwallItemId)
        if (isItem(item)) then
            doRemoveItem(item.uid)
        end
    end

    -- Schedule stone remove and magciwalls create
    addEvent(function()
        for k, v in pairs(magicwallPositions) do
            doCreateItem(magicwallItemId, v)
        end

        for k, v in pairs(stonePositions) do
            local item = getTileItemById(v, stoneItemId)
            if (isItem(item)) then
                doRemoveItem(item.uid)
            end
        end
    end, 60 * 1000)

    return false
end

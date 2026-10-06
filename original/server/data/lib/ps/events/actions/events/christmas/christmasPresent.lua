local BOXES = {
    [14639] = {
        -- santa claus present #1
        { id = 25239, chance = 2500, count = 1 }, -- cute bear
        { id = 25240, chance = 2500, count = 1 }, -- grinch's santa doll
        { id = 25241, chance = 2500, count = 1 }, -- love backpack
        { id = 25242, chance = 2500, count = 1 }, -- love bag
        { id = 25243, chance = 2500, count = 1 }, -- love bear
        { id = 14642, chance = 5000, count = 1 }, -- Bear Doll
        { id = 6501, chance = 50000, count = 5 }, -- Gingerbread Man
        { id = 6388, chance = 10000, count = 1 }, -- Christmas Card
        { id = 2108, chance = 5000, count = 1 }, -- Wooden Doll
        { id = 2110, chance = 5000, count = 1 }, -- Doll
        { id = 2688, chance = 50000, count = 5 }, -- Candy Cane
        { id = 2111, chance = 50000, count = 10 }, -- Snowball
        { id = 6503, chance = 10000, count = 1 }, -- red christmas garland
        { id = 6504, chance = 10000, count = 1 }, -- red christmas garland
        { id = 6505, chance = 10000, count = 1 }, -- blue christmas garland
        { id = 25270, chance = 50000, count = 1, unique = true }, -- token box
        { id = 25348, chance = 20000, count = 1 }, -- empty christmas ball

        { id = 18639, chance = 100, count = 1 }, -- seal box #1
        { id = 18638, chance = 100, count = 1 }, -- berry seed box
        { id = 27764, chance = 100, count = 1 }, -- common TM box
        { id = 18945, chance = 100, count = 1 }, -- doll box
    },
    [14640] = {
        -- santa claus present #2
        { id = 25239, chance = 2500, count = 1 }, -- cute bear
        { id = 25240, chance = 2500, count = 1 }, -- grinch's santa doll
        { id = 25241, chance = 2500, count = 1 }, -- love backpack
        { id = 25242, chance = 2500, count = 1 }, -- love bag
        { id = 25243, chance = 2500, count = 1 }, -- love bear
        { id = 14642, chance = 5000, count = 1 }, -- Bear Doll
        { id = 14646, chance = 5000, count = 1 }, -- Snowman Doll
        { id = 6501, chance = 50000, count = 5 }, -- Gingerbread Man
        { id = 6388, chance = 10000, count = 1 }, -- Christmas Card
        { id = 2108, chance = 5000, count = 1 }, -- Wooden Doll
        { id = 2110, chance = 5000, count = 1 }, -- Doll
        { id = 2113, chance = 5000, count = 1 }, -- Model Ship
        { id = 5080, chance = 5000, count = 1 }, -- Panda Teddy
        { id = 2688, chance = 50000, count = 5 }, -- Candy Cane
        { id = 2111, chance = 50000, count = 10 }, -- Snowball
        { id = 25270, chance = 50000, count = 1, unique = true }, -- token box
        { id = 25348, chance = 20000, count = 1 }, -- empty christmas ball

        { id = 18639, chance = 100, count = 1 }, -- seal box #1
        { id = 18638, chance = 100, count = 1 }, -- berry seed box
        { id = 27764, chance = 100, count = 1 }, -- common TM box
        { id = 18945, chance = 100, count = 1 }, -- doll box
    },
    [14641] = {
        -- santa claus present #3
        { id = 14644, chance = 100000, count = 1 }, -- Santa Teddy
        { id = 6512, chance = 100000, count = 1 }, -- Santa Doll
        { id = 11257, chance = 100000, count = 1 }, -- Santa Backpack
        { id = 14633, chance = 100000, count = 50, unique = true, maxcount = true }, -- Stone of Knowledge

        { id = 18639, chance = 100, count = 1 }, -- seal box #1
        { id = 18638, chance = 100, count = 1 }, -- berry seed box
        { id = 27764, chance = 100, count = 1 }, -- common TM box
        { id = 18945, chance = 100, count = 1 }, -- doll box
    }
}
local CHANCE_MAX = 100000

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local out = ""
    local tries = 0

    while (out == "" and tries < 100) do
        for i, reward in ipairs(BOXES[item.itemid]) do
            if (getRandom(0, CHANCE_MAX) <= reward.chance) then
                local count = reward.maxcount and reward.count or getRandom(1, reward.count)
                doPlayerSafeAddItem(cid, reward.id, count, true, reward.unique)
                out = out .. "\n" .. getItemNameById(reward.id) .. " [" .. count .. "x]"
                doDatalogChristmasDrops(getPlayerGUID(cid), reward.id, count, os.time())
            end
        end

        tries = tries + 1
    end

    if (out ~= "") then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "This %s contains:%s."), getItemNameById(item.itemid), out))
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
    else
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "This %s is empty."), getItemNameById(item.itemid)))
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
    end
    doRemoveItem(item.uid, 1)
    return true
end

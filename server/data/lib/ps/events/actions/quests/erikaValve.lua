local QUEST_STORAGE = 8472
local BERRY_POSITIONS = {
    {pos = {x = 3671, y = 404, z = 8, stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE}, requiredBerry = 0},
    {pos = {x = 3672, y = 404, z = 8, stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE}, requiredBerry = 0},
    {pos = {x = 3673, y = 404, z = 8, stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE}, requiredBerry = 0},
    {pos = {x = 3674, y = 404, z = 8, stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE}, requiredBerry = 0},
    {pos = {x = 3675, y = 404, z = 8, stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE}, requiredBerry = 0},
}
local BERRIES = {14770, 13184, 13186, 14767, 13183}
local OUT_POS = {x = 3670, y = 403, z = 8 }

local PIPES = {
    {x = 3674, y = 403, z = 8},
    {x = 3674, y = 402, z = 8},
    {x = 3673, y = 402, z = 8},
    {x = 3672, y = 402, z = 8},
    {x = 3671, y = 402, z = 8},
    {x = 3670, y = 402, z = 8},
    {x = 3669, y = 402, z = 8},
    {x = 3669, y = 403, z = 8},
}

local function randomizeRequiredBerries()
    local ids = table.deepcopy(BERRIES)
    for _, berryPos in pairs(BERRY_POSITIONS) do
        berryPos.requiredBerry = table.randomRemove(ids)
    end
end
randomizeRequiredBerries()

local animatePipe
animatePipe = function(tick, resultItem, cid, rightCount)
    if (PIPES[tick]) then
        doSendMagicEffect(PIPES[tick], table.random({EFFECT_POFF, EFFECT_POISON, EFFECT_POISON_GAS,
            EFFECT_POISON_EXPLODE}))
        addEvent(animatePipe, 300, tick + 1, resultItem, cid, rightCount)
    else
        doCreateItem(resultItem, 1, OUT_POS)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "You got right %s spot%s"), rightCount, (rightCount > 1 and "s." or ".")))
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local error = false
    local currentBerries = {}
    for _, berryPos in pairs(BERRY_POSITIONS) do
        local top
        for k, v in pairs(BERRIES) do
            local tmp = getTileItemById(berryPos.pos, v)
            if (isItem(tmp)) then
                top = tmp
                break
            end
        end

        if (not isItem(top) or not table.find(BERRIES, top.itemid)) then
            error = true
            break
        end

        currentBerries[#currentBerries + 1] = {uid = top.uid, pos = berryPos.pos,
            rightBerry = (berryPos.requiredBerry == top.itemid)}
    end

    if (error) then
        doPlayerSendCancel(cid, "The berries aren't at the right spots.")
        return true
    end

    local makeJuice = true
    local rightCount = 0
    for _, berry in pairs(currentBerries) do
        doRemoveItem(berry.uid, 1)
        doSendMagicEffect(berry.pos, EFFECT_POISON_GAS)
        if (not berry.rightBerry) then
            makeJuice = false
        else
            rightCount = rightCount + 1
        end
    end

    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    animatePipe(1, makeJuice and 23597 or 23585, cid, rightCount) -- bucket filled with juice / juice goo
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The machine is working.")

    if (makeJuice) then
        randomizeRequiredBerries()
    end

    return true
end

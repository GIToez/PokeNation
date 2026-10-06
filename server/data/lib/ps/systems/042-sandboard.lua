if (Sandboard) then
    return
end

Sandboard = {}

Sandboard.OUTFIT_YELLOW = 1298
Sandboard.OUTFIT_PURPLE = 1299

Sandboard.UNLOCKED_YELLOW_ITEMID = 23459
Sandboard.LOCKED_YELLOW_ITEMID = 23460

Sandboard.UNLOCKED_PURPLE_ITEMID = 23461
Sandboard.LOCKED_PURPLE_ITEMID = 23462

local UNLOCKED_BOARDS = {
    [Sandboard.UNLOCKED_YELLOW_ITEMID] = Sandboard.LOCKED_YELLOW_ITEMID,
    [Sandboard.UNLOCKED_PURPLE_ITEMID] = Sandboard.LOCKED_PURPLE_ITEMID,
}

local LOCKED_BOARDS = table.inverse(UNLOCKED_BOARDS)

local OUTFITS = {
    [Sandboard.UNLOCKED_YELLOW_ITEMID] = Sandboard.OUTFIT_YELLOW,
    [Sandboard.UNLOCKED_PURPLE_ITEMID] = Sandboard.OUTFIT_PURPLE,
}

Sandboard.SPEED_CONDITION = createConditionObject(CONDITION_HASTE, 1000, -1, CONDITION_SUBID.HASTE.SANDBOARD)
setConditionParam(Sandboard.SPEED_CONDITION, CONDITION_PARAM_SPEED, 120)

function Sandboard.onDeEquip(cid, item)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    if (isItem(item) and LOCKED_BOARDS[item.itemid]) then
        doTransformItem(item.uid, LOCKED_BOARDS[item.itemid])
    end

    doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.SANDBOARD)
end

function Sandboard.onEquip(cid, item)
    if (isItem(item) and UNLOCKED_BOARDS[item.itemid]) then
        doTransformItem(item.uid, UNLOCKED_BOARDS[item.itemid])
    end

    local outfit = getCreatureOutfit(cid)
    outfit.lookType = OUTFITS[item.itemid]
    doSetCreatureOutfit(cid, outfit, -1, CONDITION_SUBID.OUTFITS.SANDBOARD)
end

function Sandboard.onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    doAddCondition(cid, Sandboard.SPEED_CONDITION)
    doSendMagicEffect(lastPosition, EFFECT_SAND_EXPLOSION)
    --doSendDistanceShoot(toPosition, getPositionByDirection(fromPosition, getDirectionTo(toPosition, fromPosition), 2), PROJECTILE_ICE)
end

function Sandboard.onUse(cid, item, fromPosition, itemEx, toPosition)
    local slotItem = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    if (not isItem(slotItem) or slotItem.uid ~= item.uid) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return

    elseif (getPlayerMounted(cid)) then
        doPlayerSendCancel(cid, "You cannot use this equipment while you are mounted.")
        return
    end

    if (UNLOCKED_BOARDS[item.itemid]) then
        Sandboard.onEquip(cid, item)

    elseif (LOCKED_BOARDS[item.itemid]) then
        Sandboard.onDeEquip(cid, item)
    end
end

function Sandboard.isUsing(cid)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    return isItem(item) and LOCKED_BOARDS[item.itemid]
end
if (Ski) then
    return
end

Ski = {}

Ski.OUTFIT_SKI_FEMALE = 1254
Ski.OUTFIT_SKI_MALE = 1255
Ski.UNLOCKED_SKI_ITEMID = 18872
Ski.LOCKED_SKI_ITEMID = 18873

Ski.SPEED_CONDITION = createConditionObject(CONDITION_HASTE, 1000, -1, CONDITION_SUBID.HASTE.SKI)
setConditionParam(Ski.SPEED_CONDITION, CONDITION_PARAM_SPEED, 300)

function Ski.onDeEquip(cid, item)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    if (isItem(item) and item.itemid == Ski.LOCKED_SKI_ITEMID) then
        doTransformItem(item.uid, Ski.UNLOCKED_SKI_ITEMID)
    end

    doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.SKI)
end

function Ski.onEquip(cid, item)
    if (isItem(item) and item.itemid == Ski.UNLOCKED_SKI_ITEMID) then
        doTransformItem(item.uid, Ski.LOCKED_SKI_ITEMID)
    end

    local outfit = getCreatureOutfit(cid)
    outfit.lookType = getPlayerSex(cid) == PLAYERSEX_FEMALE and Ski.OUTFIT_SKI_FEMALE or Ski.OUTFIT_SKI_MALE
    doSetCreatureOutfit(cid, outfit, -1, CONDITION_SUBID.OUTFITS.SKI)
end

function Ski.onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    doAddCondition(cid, Ski.SPEED_CONDITION)
    doSendMagicEffect(lastPosition, EFFECT_ICE)
    --doSendDistanceShoot(toPosition, getPositionByDirection(fromPosition, getDirectionTo(toPosition, fromPosition), 2), PROJECTILE_ICE)
end

function Ski.onUse(cid, item, fromPosition, itemEx, toPosition)
    local slotItem = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    if (not isItem(slotItem) or slotItem.uid ~= item.uid) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return

    elseif (getPlayerMounted(cid)) then
        doPlayerSendCancel(cid, "You cannot use this equipment while you are mounted.")
        return
    end

    if (item.itemid == Ski.UNLOCKED_SKI_ITEMID) then
        Ski.onEquip(cid, item)

    elseif (item.itemid == Ski.LOCKED_SKI_ITEMID) then
        Ski.onDeEquip(cid, item)
    end
end

function Ski.isUsing(cid)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    return isItem(item) and item.itemid == Ski.LOCKED_SKI_ITEMID
end
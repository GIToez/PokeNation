local INVERSE_CONSTRUCTION_KITS = table.inverse(CONSTRUCTION_KITS)

local function findKit(itemid)
    local antiLoop = 0
    while (itemid ~= 0 and antiLoop < 1000) do
        if (INVERSE_CONSTRUCTION_KITS[itemid]) then
            return INVERSE_CONSTRUCTION_KITS[itemid]
        end

        itemid = getItemInfo(itemid).rotateTo
        antiLoop = antiLoop + 1
    end

    return false
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (toPosition.x == CONTAINER_POSITION) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    elseif (not getTileInfo(toPosition).house) then
        doPlayerSendCancel(cid,"You may desconstruct this only inside a house.")
    elseif (findKit(itemEx.itemid)) then
        if (isContainer(itemEx.uid) and isItem(getContainerItem(itemEx.uid, 0))) then
            doPlayerSendCancel(cid, "First you must remove the items from the container.")
            return true
        end

        doRemoveItem(itemEx.uid)
        doCreateItem(findKit(itemEx.itemid), 1, toPosition)
        doSendMagicEffect(toPosition, CONST_ME_POFF)
    else
        return false
    end

    return true
end

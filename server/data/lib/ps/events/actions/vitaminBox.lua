local BOXES = {}
BOXES[23949] = {23450, 23451, 23452, 23453, 23455, 23456, 23457} -- calcium vitamin, carbos vitamin, hp up vitamin, iron vitamin, pp up vitamin, protein vitamin, zinc vitamin

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (doPlayerSafeAddItem(cid, table.random(BOXES[item.itemid]), 1, true)) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
        doRemoveItem(item.uid)
    end

	return true
end

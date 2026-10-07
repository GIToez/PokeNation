local BOXES = {}
BOXES[18639] = {17386, 17393, 17399, 17403, 17407} -- Seal Box #1
BOXES[18640] = {17387, 17394, 17400, 17404, 17408} -- Seal Box #2
BOXES[18641] = {17389, 17395, 17401, 17405, 17409} -- Seal Box #3
BOXES[18766] = {17410, 17411, 17415, 17418, 17423, 17424, 17427} -- Rare Seal Box
BOXES[23947] = {17390, 17391, 17392, 17396, 17397, 17398} -- Lovely Seal Box
BOXES[29125] = {17386, 17387, 17389, 17390, 17391, 17392, 17393, 17394, 17395, 17396, 17397, 17398, 17399, 17400, 17401, 17402} -- Common Seal Box
BOXES[29126] = {17403, 17404, 17405, 17406, 17407, 17408, 17409, 17410, 17411, 17412, 17413, 17414, 17415, 17416, 17417, 17418, 17436, 17437, 17438} -- Rare Seal Box

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (doPlayerSafeAddItem(cid, table.random(BOXES[item.itemid]), 1, true)) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
        doRemoveItem(item.uid, 1)
    end

	return true
end

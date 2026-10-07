local QUEST_STORAGE = 8412
local ITEMEX_ID = 23537

local NPC_ANIMATION = {
    [1358] = 1359,
    [1359] = 1360,
    [1360] = 1361,
    [1361] = 1362,
    [1362] = 1363,
    [1363] = 1364,
    [1364] = 1365
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.STARTED or not isItem(itemEx) or
            itemEx.itemid ~= ITEMEX_ID) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_LEAVES)
    doRemoveItem(itemEx.uid)
    doRemoveItem(item.uid)

    if (doPlayerSafeAddItem(cid, 23532, 1, true, true)) then -- acid foxglove extraction
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "A extraction has been got.")
        addEvent(function(pos)
            doCreateItem(ITEMEX_ID, 1, pos)
        end, 5 * 60 * 1000, toPosition)
    end

    doSendMagicEffect(toPosition, EFFECT_TELEPORT_DOWN)

    local npc = doCreateNpc("Mistery Guy", toPosition, false)
    local doAnim
    doAnim = function(npc)
        local out = getCreatureOutfit(npc)
        if (NPC_ANIMATION[out.lookType]) then
            out.lookType = NPC_ANIMATION[out.lookType]
            doCreatureChangeOutfit(npc, out)
            addEvent(doAnim, 350, npc)
        else
            doSendMagicEffect(getCreaturePosition(npc), EFFECT_TELEPORT_UP)
            doRemoveCreature(npc)
        end
    end
    doAnim(npc)

    return true
end

local USES = {
    [23567] = function(cid, item, fromPosition, itemEx, toPosition) -- Seed
        if (getCreatureStorage(cid, 8447) ~= QUEST_STATUS.STARTED or itemEx.itemid ~= 804 or
                itemEx.actionid ~= 101) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return true
        end

        local count = doCreatureIncreaseStorage(cid, 8448)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You planted %s %s. [%s/8]"), getItemArticleById(item.itemid), getItemNameById(item.itemid), count))
        doSendMagicEffect(toPosition, EFFECT_ROOTS)
        doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
        doRemoveItem(item.uid, 1)
        doDecayItem(doCreateItem(23944, 1, toPosition)) -- berry tree
        return true
    end,
    [23570] = function(cid, item, fromPosition, itemEx, toPosition) -- Hoe
        if (not isItem(itemEx) or itemEx.itemid ~= 23571) then -- dry grass (chewba)
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return true
        end

        doRemoveItem(itemEx.uid)
        doSendMagicEffect(toPosition, EFFECT_POFF)

        if (getRandom(1, 100) <= 60) then
            local POKEMON = {"Angry Cubone", "Angry Diglett", "Angry Sandshrew"}
            doCreateMonster(table.random(POKEMON), getCreaturePosition(cid))
        end
        return true
    end,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    return USES[item.itemid](cid, item, fromPosition, itemEx, toPosition)
end

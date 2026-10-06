local STORAGE = 8524

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, STORAGE) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local turnIntoElectrode = function()
        local m = doCreateMonster("Electrode", fromPosition, false)
        if (m) then
            registerCreatureEvent(m, "onPrepareDeath_Remove")
            doSendMagicEffect(fromPosition, EFFECT_EXPLOSION)
            setMonsterLevel(m, 60)
            addEvent(function(m) if (isCreature(m)) then doRemoveCreature(m) end end, 3 * 60 * 1000, m)
        end
    end

    local damage = function()
        doCreatureTrueDamage(cid, -250, EFFECT_BIG_FLAMES, TEXTCOLOR_RED, pos)
    end

    local turnIntoItem = function()
        doPlayerSafeAddItem(cid, 25055, 1, true, true) -- card key
        doCreatureSetStorage(cid, STORAGE, QUEST_STATUS.FINISHED)
    end

    local traps = {{turnIntoElectrode, 70}, {damage, 40}, {turnIntoItem, 100}} -- {trap, chance}
    for i = 1, #traps do
        local trap = traps[i]
        if (getRandom(1, 100) <= trap[2]) then
            trap[1]()
            break
        end
    end

    doRemoveItem(item.uid)
    addEvent(doCreateItem, 5 * 60 * 1000, item.itemid, 1, fromPosition) -- respawn

	return true
end

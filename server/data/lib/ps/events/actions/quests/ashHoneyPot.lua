local ITEMEX_ACTIONID = 1500
local ITEMEX_IDS = {4037, 4038, 4039, 4040}
local lastSpawn

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or not table.find(ITEMEX_IDS, itemEx.itemid) or itemEx.actionid ~= ITEMEX_ACTIONID) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (lastSpawn) then
        local wait = (lastSpawn + (10 * 60)) - os.time()
        if (wait > 0) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You must wait %s before use the honey pot."), table.concat(string.timediff(wait, cid))))
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            return true
        end
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_GREEN_FLASH)
    lastSpawn = os.time()
    addEvent(function()
        addEvent(function(m) if (isCreature(m)) then doRemoveCreature(m) end end, 15 * 60 * 1000,
            doCreateMonster("Angry Beedrill", toPosition, false))
    end, 7 * 1000)

    return true
end

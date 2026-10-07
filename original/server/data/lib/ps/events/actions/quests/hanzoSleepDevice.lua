local TIME_STORAGE = 8455

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8454) ~= QUEST_STATUS.STARTED or not isNpc(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= "Hanzo Hasashi's Angry Charizard") then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local diff = (getCreatureStorage(cid, TIME_STORAGE) + (5 * 60) - os.time())
    if (diff > 0) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You must wait %s to use it again."), table.concat(string.timediff(diff, cid))))
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doRemoveCreature(itemEx.uid)
    local npc = doCreateNpc("Hanzo Hasashi's Sleeping Charizard", toPosition, false)
    doCreatureAddStatus(npc, CREATURE_STATUS_SLEEP)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Now use the Pokeball before him wakes up!")
    doCreatureSetStorage(cid, TIME_STORAGE, os.time())

    return true
end

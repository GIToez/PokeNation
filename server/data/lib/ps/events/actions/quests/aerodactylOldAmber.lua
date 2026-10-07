local AERODACTYL_OLD_AMBER_UID = 3161
local EXIT_POSITION = {x = 3490, y = 3215, z = 6}
local STORAGE = 8382

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (item.uid == AERODACTYL_OLD_AMBER_UID) then
        if (getCreatureStorage(cid, STORAGE) ~= QUEST_STATUS.FINISHED) then
            doPlayerSafeAddItem(cid, item.itemid, 1, true, true)
            doCreatureSetStorage(cid, STORAGE, QUEST_STATUS.FINISHED)
            doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.OLD_AMBER)
        end

        doTeleportThing(cid, EXIT_POSITION)
        setPlayerBlockLogout(cid, false)
        return true
    end
    return true
end

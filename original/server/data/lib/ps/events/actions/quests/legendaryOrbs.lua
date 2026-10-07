local ZAPDOS_ORB_ITEMID = 18174
local MOLTRES_ORB_ITEMID = 18175
local ARTICUNO_ORB_ITEMID = 18176

local ORBS = {}
ORBS[ZAPDOS_ORB_ITEMID] = {
    statue = 18318,
    teleportPos = {x = 5090, y = 323, z = 4},
    centerPos = {x = 5107, y = 310, z = 7},
    tip = "Tip: Note the path that you're doing!"
}

ORBS[MOLTRES_ORB_ITEMID] = {
    statue = 18317,
    teleportPos = {x = 5040, y = 317, z = 4},
    centerPos = {x = 5029, y = 310, z = 7},
    tip = "Tip: Do not stop running!"
}

ORBS[ARTICUNO_ORB_ITEMID] = {
    statue = 18319,
    teleportPos = {x = 5192, y = 327, z = 4},
    centerPos = {x = 5195, y = 310, z = 7},
    tip = "Tip: Use your pokemon Rock Smash!"
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or itemEx.itemid ~= ORBS[item.itemid].statue or
            getCreatureStorage(cid, 8369) ~= QUEST_STATUS.FINISHED or -- Check if Ancient Times quest is done
            getCreatureStorage(cid, 8370) == QUEST_STATUS.FINISHED) then -- Check if already defeat legendary
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local spec = getSpectators(ORBS[item.itemid].centerPos, 36, 34, true)
    if (spec) then
        for _, tmpCid in pairs(spec) do
            if (isPlayer(tmpCid)) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "There are players completing the dungeon at the moment, you must try again later.")
                return true
            end
        end
    end

    if (item.itemid == ZAPDOS_ORB_ITEMID) then
        Dungeons.Zapdos.doReset()
    elseif (item.itemid == ARTICUNO_ORB_ITEMID) then
        Dungeons.Articuno.doReset()
    elseif (item.itemid == MOLTRES_ORB_ITEMID) then
        Dungeons.Moltres.doReset()
    end

    doTeleportThing(cid, ORBS[item.itemid].teleportPos)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, __L(cid, ORBS[item.itemid].tip))
    setPlayerBlockLogout(cid, true)

	return true
end

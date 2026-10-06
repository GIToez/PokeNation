local NPCS = {}
NPCS["Hugh Morgan"] = 8300
NPCS["Robby Drummond"] = 8301
NPCS["Dusty Cheyenne"] = 8302
NPCS["Darius Linton"] = 8303
NPCS["Giles Shaw"] = 8304
NPCS["Brigham Corwin"] = 8305
NPCS["Irene Jaylyn"] = 8306
NPCS["Karin Sybil"] = 8307
NPCS["Delaney Dinah"] = 8308
NPCS["Aaren Mattie"] = 8309

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8295) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local msg = {}
    msg[1] = __L(cid, "Task Status:\n")
    for npc, storage in pairs(NPCS) do
        msg[#msg + 1] = npc
        msg[#msg + 1] = " - "
        msg[#msg + 1] = (getCreatureStorage(cid, storage) == QUEST_STATUS.FINISHED and "ok" or "undelivered")
        msg[#msg + 1] = "\n"
    end

    doShowTextDialog(cid, item.itemid, table.concat(msg))
	return true
end

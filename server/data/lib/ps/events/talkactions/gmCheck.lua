local USERS = {}
-- USERS[guid] = list

function onSay(cid, words, param)
    local guid = getPlayerGUID(cid)

    if (param == "next") then
        if (not USERS[guid]) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "First type '/gmcheck'!")
            return true
        end

        for k, v in pairs(USERS[guid]) do
            USERS[guid][k] = nil
            if (isPlayer(v)) then
                local pos = getCreaturePosition(v)
                if (doTeleportThing(cid, getClosestFreeTile(cid, pos, true, false), false)) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Done! " .. getCreatureName(v))
                    break
                end
            end
        end

        return true
    end

    if (USERS[guid]) then
        table.clear(USERS[guid])
        USERS[guid] = nil
    end

    USERS[guid] = getPlayersOnline()
    local count = 0

    for k, v in pairs(USERS[guid]) do
        if (v == cid or getPlayerAccess(v) >= getPlayerAccess(cid)) then
            USERS[guid][k] = nil
        else
            count = count + 1
        end
    end

    if (#USERS[guid] <= 0) then
        table.clear(USERS[guid])
        USERS[guid] = nil

        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "There aren't players at the moment.")
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.concat(count,
        " player(s) found. Type '/gmcheck next' to start."))

	return true
end

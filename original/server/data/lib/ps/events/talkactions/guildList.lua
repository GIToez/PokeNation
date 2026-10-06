local CACHE = {}
-- CACHE[guildId] = {last, msgs}

local function doSpellMessages(cid, msgs)
    for k, v in pairs(msgs) do
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, v)
    end
end

function onSay(cid, words, param)
    local guild = getPlayerGuildId(cid)
    if (guild == 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (CACHE[guild] and ((os.time() - CACHE[guild].last) < 10)) then
        doSpellMessages(cid, CACHE[guild].msgs)
        return true
    end

    local players = getPlayersOnline()
    local strings = {""}

    local i, position = 1, 1
    local added = false
    for _, pid in ipairs(players) do
        if (getPlayerGuildId(pid) == guild) then
            if(added) then
                if(i > (position * 7)) then
                    strings[position] = strings[position] .. ","
                    position = position + 1
                    strings[position] = ""
                else
                    strings[position] = i == 1 and "" or strings[position] .. ", "
                end
            end

            strings[position] = strings[position] .. getCreatureName(pid) .. " [" .. getPlayerLevel(pid) .. "]"
            i = i + 1
            added = true
        end
    end

    local messages = {}
    messages[1] = (i - 1) .. __L(cid, " guild member(s) online:")

    for i, str in ipairs(strings) do
        if(str:sub(str:len()) ~= ",") then
            str = str .. "."
        end

        messages[#messages + 1] = str
    end

    doSpellMessages(cid, messages)
    CACHE[guild] = {last = os.time(), msgs = messages}

	return true
end

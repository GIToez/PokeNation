local msgs = {}

local function work()
    -- Get all commands and remove the hidden ones
    local commands = getTalkActionList()
    for k, v in pairs(commands) do
        if (v.hide) then
            commands[k] = nil
        end
    end

    -- Filter command by access
    local commandByAccess = {}
    for k, v in pairs(commands) do
        if (not commandByAccess[v.access]) then
            commandByAccess[v.access] = {}
        end
        commandByAccess[v.access][#commandByAccess[v.access] + 1] = v
    end
    commands = nil

    -- Adjust the possible commands by access
    local msgByAccess = {}
    for k, v in pairs(commandByAccess) do
        if (not msgByAccess[k]) then
            msgByAccess[k] = {}
        end
    end

    for k, v in pairs(msgByAccess) do
        for j, l in pairs(commandByAccess) do
            if (k >= j) then
                msgByAccess[k] = table_concat(msgByAccess[k], l)
            end
        end
    end
    commandByAccess = nil

    -- Compile into a msg string
    for k, v in pairs(msgByAccess) do
        local outI = 1
        local out = {[outI] = {}}
        out[outI][1] = "Commands:\n"
        for j, l in pairs(v) do
            if (#out[outI] > 100) then
                outI = outI + 1
                out[outI] = {}
            end
            out[outI][#out[outI] + 1] = l.words
            out[outI][#out[outI] + 1] = "    "
            out[outI][#out[outI] + 1] = l.description
            out[outI][#out[outI] + 1] = "\n"
        end
        out[outI][#out[outI]] = nil -- Remove last \n

        msgs[k] = {}
        for x, y in ipairs(out) do
            msgs[k] = table_concat(msgs[k], {table.concat(y)})
        end
    end
end

addEvent(work, 10 * 1000) -- Wait server startup to get all talkactions

function onSay(cid, words, param)
    for k, v in ipairs(msgs[getPlayerAccess(cid)]) do
        doPlayerPopupFYI(cid, v)
    end
    return true
end
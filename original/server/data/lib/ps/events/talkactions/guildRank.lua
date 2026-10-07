function onSay(cid, words, param)
    if(param == '') then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires param.")
        return true
    end

    local guild = getPlayerGuildId(cid)
    if (guild == 0) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (getPlayerGuildLevel(cid) == GUILDLEVEL_MEMBER) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Only leaders and vice-leaders can use this command.")
        return true
    end

    param = string.explode(param, ",")
    local target = getPlayerByNameWildcard(param[1])
    if (not target) then
        target = getCreatureByName(param[1])
        if (not target) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Member not found.")
            return true
        end
    end

    if (getPlayerGuildId(target) ~= guild) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "This player isn't member of your guild.")
        return true

    elseif (getPlayerGuildLevel(cid) <= getPlayerGuildLevel(target)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You don't have access to change this member rank.")
        return true
    end

    local rankId = getGuildRankIdByName(guild, param[2])
    if (not rankId) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please type the rank name correctly.")
        return true
    end

    if (not doPlayerSetGuildLevel(target, GUILDLEVEL_MEMBER, rankId)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "An error has ocurred, please check the params.")
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "%s rank successfully changed."), param[1]))
	return true
end

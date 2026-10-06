function onSay(cid, words, param, channel)
    if (param == '') then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires param.")
        return true
    end

    local t = string.explode(param, ",")
    local name = t[1]
    if (not name) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "First param must be a player name.")
        return true
    end

    local itemId = tonumber(t[2])
    if (not itemId) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Second param must be a item id.")
        return true
    end

    local count = tonumber(t[3])
    if (not count) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Third param must be item count.")
        return true
    end

    if (count <= 0 or count > ITEM_STACK_MAX) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Third param must be between 1 and %s."), ITEM_STACK_MAX))
        return true
    end

    local playerGuid = getPlayerGuidByNameEx(name)
    if (not playerGuid) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Player %s not found."), name))
        return true
    end

    local item = doCreateItem(itemId, count, getCreaturePosition(cid))
    if (item) then
        setItemUniqueOwner(item, 0, playerGuid)

        if (not doPlayerAddDepotItemByName(name, item)) then
            doRemoveItem(item)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Can't send item to %s."), name))
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Player '%s' received the unique %s %sx successfully."), name, itemId, count))
        end
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Can't create item with id %s."), itemId))
    end

    return true
end

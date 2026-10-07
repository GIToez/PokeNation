function getAccountStorage(accountId, key)
    local ret, res = 0, db.getResult("SELECT `value` FROM `account_storage` WHERE `account_id`="..
            accountId .." AND `key`=".. key .." LIMIT 1;")
    if (res:getID() ~= -1) then
        ret = res:getDataInt('value')
        res:free()
    end
    return ret
end

function setAccountStorage(accountId, key, value)
    local query = {}
    query[1] = "INSERT INTO `account_storage` (`account_id`, `key`, `value`) VALUES ("
    query[2] = accountId
    query[3] = ","
    query[4] = key
    query[5] = ","
    query[6] = value
    query[7] = ") ON DUPLICATE KEY UPDATE `value`='"
    query[8] = value
    query[9] = "';"

    if (not db.executeQuery(table.concat(query))) then
        log(LOG_TYPES.ERROR, "setAccountStorage - Couldn't execute query", accountId, key, value, table.concat(query))
        return false
    end
    return true
end
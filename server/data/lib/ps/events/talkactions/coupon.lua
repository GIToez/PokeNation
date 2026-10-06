COUPON_TYPE_PREMIUM_DAYS = 0

function onSay(cid, words, param, channel)
    if (param == '') then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    -- verificar se cupom existe
    local r = db.getResult(string.concat("SELECT * FROM `coupons` WHERE `coupons`.`code`=", db.escapeString(param), " LIMIT 1;"))
    if (r:getID() == EMPTY_RESULT) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local coupon = { id = r:getDataInt("id"), type = r:getDataInt("type"), reward = r:getDataInt("reward"), expires = r:getDataInt("expires") }
    r:free()

    -- verificar se cupom já expirou
    if (coupon.expires <= os.time()) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, __L(cid, "This coupon has been expired."))
        return true
    end

    -- verificar se conta já utilizou o cupom
    r = db.getResult(string.concat("SELECT 1 FROM `coupon_uses` WHERE `coupon_id`='", coupon.id, "' AND `account_id`='", getPlayerAccountId(cid), "' LIMIT 1;"))
    if (r:getID() ~= EMPTY_RESULT) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, __L(cid, "Your account already uses this coupon."))
        r:free()
        return true
    end

    -- registrar uso
    local query = string.concat("INSERT INTO `coupon_uses` (`coupon_id`, `account_id`, `date`) VALUES('", coupon.id, "', '", getPlayerAccountId(cid), "', '", os.time(), "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "Coupon::registerUse - Can't query.", coupon, getPlayerAccountId(cid), query)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    -- dar premio
    if (coupon.type == COUPON_TYPE_PREMIUM_DAYS) then
        doPlayerAddPremiumDays(cid, coupon.reward)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Congratulations! Your account received %s premium days."), coupon.reward))
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
    end

    return true
end

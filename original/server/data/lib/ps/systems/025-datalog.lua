function doDatalogCoinUse(date, player_id, use, amount)
    local query = string.concat("INSERT INTO `datalog_coin_uses` (`date`, `player_id`, `use`, `amount`) VALUES('",
        date, "', '", player_id, "', '", use, "', '", amount, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogCoinuse - Can't query.", date, player_id, use, amount, query)
        return false
    end

    return true
end

function doDatalogTokenBought(date, player_id, use, amount)
    local query = string.concat("INSERT INTO `datalog_token_bought` (`date`, `player_id`, `use`, `amount`) VALUES('",
        date, "', '", player_id, "', '", use, "', '", amount, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogTokenBought - Can't query.", date, player_id, use, amount, query)
        return false
    end

    return true
end

function doDatalogPokemonMarket(offertId, buyer, date)
    local query = string.concat("INSERT INTO `datalog_pokemon_market` (`seller`, `buyer`, `date`, `ball_id`, `attributes`, `value`) SELECT P.player_id, '",
        buyer, "', '", date, "' , P.ball_id, P.attributes, P.value FROM pokemon_market P WHERE P.id = ", offertId)

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogPokemonMarket - Can't query.", offertId, buyer, date)
        return false
    end

    return true
end

function doDatalogBossReward(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_boss_rewards` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogBossReward - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end

function doDatalogRangerClubTask(player_id, task_id, date)
    local query = string.concat("INSERT INTO `datalog_rangerclub_task` (`player_id`, `task_id`, `date`) VALUES ('",
        player_id, "', '", task_id, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogRangerClubTask - Can't query.", player_id, task_id, date)
        return false
    end

    return true
end

function doDatalogRangerClubBoss(player_id, boss_id, date)
    local query = string.concat("INSERT INTO `datalog_rangerclub_boss` (`player_id`, `boss_id`, `date`) VALUES ('",
        player_id, "', '", boss_id, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogRangerClubBoss - Can't query.", player_id, boss_id, date)
        return false
    end

    return true
end

function doDatalogRangerClubBossReward(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_rangerclub_boss_rewards` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogRangerClubBossReward - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end

function doDatalogChristmasDrops(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_christmas_drops` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogChristmasDrops - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end

function doDatalogEasterDrops(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_easter_drops` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogEasterDrops - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end

function doDatalogSurpriseBox(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_surprise_box` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogSurpriseBox - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end

function doDatalogReferralExchange(player_id, name, date)
    local query = string.concat("INSERT INTO `datalog_referral_exchange` (`player_id`, `name`, `date`) VALUES ('",
        player_id, "', ", db.escapeString(name), ", '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogReferralExchange - Can't query.", player_id, name, date)
        return false
    end

    return true
end

function doDatalogMasteryTokenBought(date, player_id, item_id, count, tokens)
    local query = string.concat("INSERT INTO `datalog_mastery_token_bought` (`date`, `player_id`, `item_id`, `count`, `tokens`) VALUES('",
        date, "', '", player_id, "', '", item_id, "', '", count, "', '", tokens, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogMasteryTokenBought - Can't query.", date, player_id, item_id, count, tokens, query)
        return false
    end

    return true
end

function doDatalogSlotMachine(date, player_id, gain)
    local query = string.concat("INSERT INTO `datalog_slot_machine` (`date`, `player_id`, `gain`) VALUES('",
        date, "', '", player_id, "', '", gain, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogSlotMachine - Can't query.", date, player_id, gain, query)
        return false
    end

    return true
end

function doDatalogPokeTraderBought(player_id, item_id, count, bid, date)
    local query = string.concat("INSERT INTO `datalog_poketrader_boughts` (`player_id`, `item_id`, `count`, `bid`, `date`) VALUES('",
        player_id, "', '", item_id, "', '", count, "', '", bid, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogPokeTraderBought - Can't query.", player_id, item_id, count, bid, query)
        return false
    end

    return true
end

function doDatalogCasinoTokenBought(date, player_id, item_id, count, tokens)
    local query = string.concat("INSERT INTO `datalog_casino_token_bought` (`date`, `player_id`, `item_id`, `count`, `tokens`) VALUES('",
        date, "', '", player_id, "', '", item_id, "', '", count, "', '", tokens, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogCasinoTokenBought - Can't query.", date, player_id, item_id, count, tokens)
        return false
    end

    return true
end

function doDatalogEggMoveGenerate(date, player_id, pokemon_name, pokemon_level, pokemon_extrapoints, egg_move,
from_egg)
    local query = string.concat("INSERT INTO `datalog_egg_move_generate` (`date`, `player_id`, `pokemon_name`, `pokemon_level`, `pokemon_extrapoints`, `egg_move`, `from_egg`) VALUES('",
        date, "', '", player_id, "', '", pokemon_name, "', '", pokemon_level, "', '", pokemon_extrapoints, "', '",
        egg_move, "', '", (from_egg and 1 or 0), "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogEggMoveGenerate - Can't query.", date, player_id, pokemon_name, pokemon_level, pokemon_extrapoints, egg_move,
            from_egg, query)
        return false
    end

    return true
end

function doDatalogEggMoveRegenerate(date, player_id, pokemon_name, pokemon_level, pokemon_extrapoints, egg_move)
    local query = string.concat("INSERT INTO `datalog_egg_move_regenerate` (`date`, `player_id`, `pokemon_name`, `pokemon_level`, `pokemon_extrapoints`, `egg_move`) VALUES('",
        date, "', '", player_id, "', '", pokemon_name, "', '", pokemon_level, "', '", pokemon_extrapoints, "', '", egg_move, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogEggMoveRegenerate - Can't query.", date, player_id, pokemon_name, pokemon_level, pokemon_extrapoints, egg_move, query)
        return false
    end

    return true
end

function doDatalogColosseumArena(date, account_id)
    local query = string.concat("INSERT INTO `datalog_colosseum_arena` (`date`, `account_id`) VALUES('",
        date, "', '", account_id, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogColosseumArena - Can't query.", date, account_id, query)
        return false
    end

    return true
end

function doDatalogAnniversaryDrops(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_anniversary_drops` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogAnniversaryDrops - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end

function doDatalogBankTransaction(action_id, sender, receiver, amount, date)
    local query = string.concat("INSERT INTO `datalog_bank_transactions` (`action_id`, `sender`, `receiver`, `amount`, `date`) VALUES ('",
        action_id, "', '", sender, "', '", receiver, "', '", amount, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogBankTransaction - Can't query.", action_id, sender, receiver, amount, date)
        return false
    end

    return true
end

function doDatalogHalloweenDrops(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_halloween_drops` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogHalloweenDrops - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end

function doDatalogJulyVacationDrops(player_id, item_id, count, date)
    local query = string.concat("INSERT INTO `datalog_julyvacation_drops` (`player_id`, `item_id`, `count`, `date`) VALUES ('",
        player_id, "', '", item_id, "', '", count, "', '", date, "');")

    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doDatalogJulyVacationDrops - Can't query.", player_id, item_id, count, date)
        return false
    end

    return true
end
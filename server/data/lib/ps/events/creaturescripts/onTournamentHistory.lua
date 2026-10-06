local function doLogPlayerHistory(cid, tournamentHistoryId)
    local guid = getPlayerGUID(cid)
    for _, ball in pairs(getPlayerAllBallsWithPokemon(cid)) do
        local query = string.concat("INSERT INTO `tournament_history_pokemon` (`tournament_history_id`, `player_id`, `pokemon_number`, `description`) VALUES('",
            tournamentHistoryId, "', '", guid, "', '", getPokemonNumberByName(getBallPokemonName(ball.uid)), "', '", getItemSpecialDescription(ball.uid), "');")

        if (not db.executeQuery(query)) then
            log(LOG_TYPES.ERROR, "onTournamentHistory - Can't query.", tournamentHistoryId, guid, query)
        end
    end
end

function onTournamentHistory(tournamentHistoryId, winner, loser)
    doLogPlayerHistory(winner, tournamentHistoryId)
    doLogPlayerHistory(loser, tournamentHistoryId)
end
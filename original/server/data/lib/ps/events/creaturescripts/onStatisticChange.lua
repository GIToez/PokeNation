function onStatisticChange(cid, statisticId, newValue)
    if (statisticId == PLAYER_STATISTIC_IDS.HOOKED_FISH) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.FISH_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.EVOLVE_POKEMON) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.EVOLVE_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.VISIT_KANTO_SAFARI) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.SAFARI_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.CHANGE_POKEMON_NICKNAME) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.POKEMON_NICKNAME_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.SELL_POKEMON) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.SELL_POKEMON_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.GENERATE_POKEMON_EGG) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.POKEMON_EGG_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.CATCH_POKEMON_1ST_GEN) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CATCH_1ST_GEN_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.CATCH_POKEMON_2ND_GEN) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CATCH_2ND_GEN_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.CATCH_SHINY_POKEMON) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CATCH_SHINY_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.EARN_ACHIEVEMENT) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.ACHIEVEMENT_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.DEFEAT_NPC) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.DEFEAT_NPC_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.DEFEAT_PLAYER) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.DEFEAT_PLAYER_1, newValue)
        onPlayerWinDuel(cid)

    elseif (statisticId == PLAYER_STATISTIC_IDS.WIN_FRONTIER_ISLAND) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.FRONTIER_ISLAND_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.PLANT_BERRY) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.PLANT_BERRY_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.COMPLETE_QUEST) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.QUEST_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.COMPLETE_TASK) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.TASKS, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.COMPLETE_DAILY_QUEST) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.DAILY_QUEST_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.WIN_TOURNAMENT) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.WIN_TOURNAMENT_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.COMPLETE_RANGERCLUB_TASK) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.COMPLETE_RANGERCLUB_TASK_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.COMPLETE_RANGERCLUB_BOSS) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.COMPLETE_RANGERCLUB_BOSS_1, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.USE_POKE_TRANSFORMATION) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.USE_POKETRANSFORMATION, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.PLAY_SLOT_MACHINE) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.PLAY_SLOT_MACHINE, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.BID_ON_POKETRADER) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.BID_POKETRADER_I, newValue)

    elseif (statisticId == PLAYER_STATISTIC_IDS.USE_VITAMIN) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.USE_VITAMIN, newValue)
    end
    return true
end
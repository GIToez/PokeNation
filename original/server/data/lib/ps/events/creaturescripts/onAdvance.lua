function onAdvance(cid, skill, oldLevel, newLevel)
	if (skill == SKILL__LEVEL) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.LEVEL_100, newLevel)
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_LEVEL_UP)

    elseif (skill >= PLAYER_SKILL_DUEL_WIN and skill <= PLAYER_SKILL_BATTLE_LOSS) then
        onPlayerEndDuel(cid)
    end
	return true
end

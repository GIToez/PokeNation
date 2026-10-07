function onSay(cid, words, param)
	if (param) then
		local skillDescription, skillName = "", getPokemonSkillByClientIconId(tonumber(param))
		if (skillName ~= nil) then
			skillDescription = string.format(__L(cid, "Move: %s, Power: %s, Energy: %s, Cooldown: %ss, Type: %s,\nCategory: %s, Range: %s sqm.\n%s"), skillName, getPokemonSkillDamageText(skillName), getPokemonSkillRequiredEnergy(skillName), getPokemonSkillCooldownTime(skillName), __L(cid,  ELEMENT_NAMES[getPokemonSkillDamageType(skillName)]), MOVE_CATEGORY_NAMES[getPokemonSkillCategory(skillName)], getPokemonSkillMaxDistance(skillName), __L(cid, getPokemonSkillDescription(skillName)))
		else
			log(LOG_TYPES.ERROR, "skillDescription - Unknown move", cid, words, param)
            skillDescription = __L(cid, "A problem was occurred! Please contact a gamemaster or create a topic in our forum.")
		end
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, skillDescription)
	end
	return true
end

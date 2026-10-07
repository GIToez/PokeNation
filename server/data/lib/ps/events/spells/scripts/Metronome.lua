local RANDOM_SKILLS = {"Earthquake", "Hurricane", "Inferno", "Cross Chop", "Dynamic Punch", "Egg Bomb", "Iron Tail", "Electro Ball", "Future Sight"}

function onCastSpell(cid, var)
	callSkillFunction(cid, table.random(RANDOM_SKILLS))
	return true
end

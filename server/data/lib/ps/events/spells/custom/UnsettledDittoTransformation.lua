function onCastSpell(cid, var)
	local transform = table.random({"Venusaur", "Charizard", "Blastoise", "Ninetales", "Vileplume", "Poliwrath", "Alakazam",
		"Golem", "Cloyster", "Rhydon", "Magmar", "Electabuzz", "Jynx", "Scyther", "Tauros", "Hitmonlee"})
	doCreatureChangeOutfit(cid, getMonsterInfo(transform).outfit)
	setCreatureBaseSpeed(cid, getMonsterInfo(transform).baseSpeed)
	doCreatureSetStorage(cid, pokemonsStorages.transform, transform)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_DITTO_TRANSFORM)
	return true
end

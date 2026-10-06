function onCastSpell(cid)
	if (isPokemonWild(cid) and canWildPokemonEvolve(cid) and
            getCreatureHealth(cid) < (getCreatureMaxHealth(cid) / 10)) then
		local evolutions = {}
		for k, v in ipairs(getPokemonEvolutions(getCreatureName(cid))) do
            if (v.requiredLevel - getMonsterLevel(cid) <= 20) then
                evolutions[#evolutions + 1] = v
            end
        end

        if (#evolutions > 0) then
            doPokemonEvolve(cid, table.random(evolutions).name)
        end
	end
	return true
end

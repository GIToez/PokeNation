function onCastSpell(cid, var)
    callSkillFunction(cid, table.random(getPokemonCurrentMoves(cid)))
    return true
end

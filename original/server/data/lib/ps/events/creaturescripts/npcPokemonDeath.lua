function onPrepareDeath(cid)
    if (getCreatureStatus(cid, CREATURE_STATUS_SUBSTITUTE)) then
        doCreatureChangeHealth(cid, getPokemonHealthBeforeSubstitute(cid))
        doCreatureRemoveStatus(cid, CREATURE_STATUS_SUBSTITUTE)
        return false
    end

	doSendMagicEffect(getCreaturePosition(cid), EFFECT_POKEBALL_USE)
    doCreatureGiveKillersExperience(cid) -- Enable exp give from summon, only previous enabled Summons will work with this
	doRemoveCreature(cid)
	return false
end

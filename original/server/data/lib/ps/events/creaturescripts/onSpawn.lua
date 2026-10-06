function onMonsterSpawn(cid)
    --[[if (EasterEvent.OnSpawn(cid)) then
        return
    end]]
    AnniversaryEvent.onSpawn(cid)
--    ChristmasEvent.onSpawn(cid)
--    HalloweenEvent.onSpawn(cid)

    setMonsterSpecialAbility(cid, getPokemonRandomSpecialAbility(getCreatureName(cid)))
    setWildPokemonEvolvable(cid, getRandom(0, 3) == 1)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_DOWN)
end
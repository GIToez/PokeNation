function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isMonster(cid)) then
        return true
    end

    local name = getCreatureName(cid)
    if (name == "White Gengar") then
        local summon = doCreateMonster("Gengar", position, false)
        doConvinceCreature(cid, summon)

        registerCreatureEvent(summon, "halloween_CursedGengarMinion_beforeDeath")
        setMonsterSex(summon, getMonsterSex(cid))
        setMonsterExtraPoints(summon, getMonsterExtraPoints(cid))
        setMonsterLevel(summon, getMonsterLevel(cid))
        doCreatureChangeHealth(summon, summonHealth)
        setCreatureNickname(summon, getCreatureNickname(cid))
        setPokemonSummon(summon, true)

        local outfit = getMonsterInfo("Gengar", false).outfit
        outfit.lookType = getRandom(1725, 1727)
        doCreatureChangeOutfit(summon, outfit)

        doSendMagicEffect(position, EFFECT_DARK_PULSE)

        doRemoveItem(item.uid)
    end

    return true
end
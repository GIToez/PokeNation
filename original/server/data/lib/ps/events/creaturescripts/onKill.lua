function onKill(cid, target, lastHit)
    local name = getCreatureName(target)
    if (not isSummon(target) and not getPokemonSummon(target)) then
        doQuestDefeat(cid, name)
        if (lastHit) then
            RangerClub.onPlayerKill(cid, name)
--            HalloweenEvent.onPlayerKill(cid, target, lastHit)
            AnniversaryEvent.onPlayerKill(cid, target, lastHit)
            --EasterEvent.ThisIsEaster.onPlayerKill(cid, target, lastHit)
--            ChristmasEvent.onPlayerKill(cid, target, lastHit)
        end
    end
	return true
end

local MONSTERS = {
    ["Mad Big Cake"] = function(cid, killer)
        AnniversaryEvent.onBossKill(cid, killer)
    end,
    ["Minion Cake"] = function(cid)
        AnniversaryEvent.onMinionKill(cid, killer)
    end,
    ["Minion Chocolate Cake"] = function(cid, killer)
        AnniversaryEvent.onMinionKill(cid, killer)
    end,
    ["Minion Cream Cake"] = function(cid, killer)
        AnniversaryEvent.onMinionKill(cid, killer)
    end,
    ["Minion Decorated Cake"] = function(cid, killer)
        AnniversaryEvent.onMinionKill(cid, killer)
    end,
    ["Minion Party Cake"] = function(cid, killer)
        AnniversaryEvent.onMinionKill(cid, killer)
    end,
}

function onDeath(cid, corpse, deathList)
    --[[local killer = getPlayerByGUID(getItemAttribute(corpse.uid, "corpseowner"))
    if (not killer) then
        killer = getCreatureMaster(deathList[1])
    end

    if (isPlayer(killer)) then
        -- todo
    end]]
    MONSTERS[getCreatureName(cid)](cid, getKillerFromList(deathList))
	return true
end

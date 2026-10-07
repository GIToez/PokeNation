function onPrepareDeath(cid, deathList)
    if (getPlayerFrontierIsland(cid)) then
        doTeleportThing(cid, FRONTIER_ISLAND_SAFE_POSITION, false)
        return false
    end
	return true
end

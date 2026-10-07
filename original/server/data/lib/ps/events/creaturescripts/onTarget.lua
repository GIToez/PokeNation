function onTarget(cid, target)
	if (not isPokemonWild(target)) then
		local master = getCreatureMaster(target)
        if (isNpc(master) and getNpcOpponent(master) ~= cid) then
            doPlayerSendCancel(cid, "You aren't battleing with this NPC.")
            return false
        end
    end
	return true
end

local WATCHABLE_DIR = {
	[14360] = {NORTH, NORTHWEST, NORTHEAST},
	[14361] = {NORTH, NORTHWEST, NORTHEAST},
	[14362] = {NORTH, NORTHWEST, NORTHEAST},
	[11925] = {WEST, SOUTHWEST, NORTHWEST},
	[11926] = {NORTH, NORTHWEST, NORTHEAST},
	[11927] = {WEST, SOUTHWEST, NORTHWEST},
	[11928] = {NORTH, NORTHWEST, NORTHEAST},
	[11929] = {WEST, SOUTHWEST, NORTHWEST},
	[11930] = {NORTH, NORTHWEST, NORTHEAST},
	[24216] = {NORTH, NORTHWEST, NORTHEAST},
	[24217] = {NORTH, NORTHWEST, NORTHEAST},
	[24218] = {NORTH, NORTHWEST, NORTHEAST},
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(isExhaust(cid)) then
		doPlayerSendCancel(cid, "You're exhausted.")
	else
		local direction = getDirectionTo(getCreaturePosition(cid), toPosition)
		if (not isInArray((WATCHABLE_DIR[item.itemid] or {NORTH, NORTHWEST, NORTHEAST}), direction)) then
			doPlayerSendCancel(cid, "You need to be in front of the TV to watch it.")
		elseif (getPlayerRecordingTV(cid)) then
			doPlayerSendCancel(cid, "You can't watch TV while you're recording.")
		elseif (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
			doPlayerSendCancel(cid, "You can't watch TV while you have a Pokemon out of the ball.")
		elseif (item.uid < LAST_UNIQUE_ID) then
			doPlayerSendCancel(cid, "You can't watch this TV.")
		else
			doAddExhaust(cid)
            doPlayerSendTVChannelsDialog(cid)
		end
	end
	return true
end

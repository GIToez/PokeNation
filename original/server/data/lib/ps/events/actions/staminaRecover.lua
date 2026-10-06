local RECOVER = 10 * 60 -- 10 hours in minutes
local RECOVER_MAX = 40 * 60 -- 40 hours in minutes

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (itemEx.uid ~= cid) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		if (getPlayerStamina(cid) + RECOVER >= RECOVER_MAX) then
			doPlayerSendCancel(cid, "You can not recover more stamina, the maximum allowed is 40 hours.")

		else
			doPlayerAddStamina(cid, RECOVER)
			doRemoveItem(item.uid, 1)
			doSendMagicEffect(getCreaturePosition(cid), EFFECT_PURPLE_ENERGIZE)
		end
	end

	return true
end

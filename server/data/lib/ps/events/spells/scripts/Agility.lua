-- local SKILL_NAME = "Agility"

local function doSpell(cid, ticks)
	if (isCreature(cid)) then
		local target = getCreatureTarget(cid)
		if (isCreature(target)) then
            local pos = getCreaturePosition(cid)
            local targetPos = getCreaturePosition(target)
			local nextPosition = getPositionAdjacent(cid, targetPos, false)
            if (nextPosition) then
				doTeleportThing(cid, nextPosition, false)
				doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
				doSendMagicEffect(nextPosition, EFFECT_TELEPORT_FRAME)
			end
		end
		if (ticks > 0) then
			addEvent(doSpell, 500, cid, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
    doSpell(cid, 10)
	return true
end

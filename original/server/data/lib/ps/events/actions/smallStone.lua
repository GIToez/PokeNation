local texts = {"Poff", "Taff", "Tuff", "Tak"}
local SPECIAL_SMALL_STONE_ID = 13497

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if(item.itemid ~= SPECIAL_SMALL_STONE_ID and not getSafariZone(cid)) then
		doPlayerSendCancel(cid, "You can only use it while you're in the Safari Zone.")
		return true
	end

	local playerPosition = getCreaturePosition(cid)
	if (getDistanceBetween(playerPosition, toPosition) > 6) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

	else
		local creature = getTopCreature(toPosition).uid

		if(not isSightClear(playerPosition, toPosition, true) or not isCreature(creature) or not isMonster(creature) or getCreatureMaster(creature) ~= creature or getTilePzInfo(playerPosition)) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

		else
			local creaturePosition = getCreaturePosition(creature)
			local creatureOnePercentHealth = getCreatureMaxHealth(creature) / 100
			local stoneDamage = math.floor((8 * creatureOnePercentHealth) + (math.random(creatureOnePercentHealth * 1, creatureOnePercentHealth * 3)))

			doTargetCombatHealth(cid, creature, COMBAT_DEATHDAMAGE, -stoneDamage, -stoneDamage, EFFECT_CONFUSE_STARS)
			doSendAnimatedText(creaturePosition, texts[math.random(1, #texts)], COLOR_ORANGE)
			doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_SMALL_STONE)
			doRemoveItem(item.uid, 1)

			if (not hasTarget(creature)) then
				doMonsterSetTarget(creature, cid)
			end
		end
	end

	if (item.itemid == SPECIAL_SMALL_STONE_ID and getPlayerItemCount(cid, SPECIAL_SMALL_STONE_ID) == 0) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your stones are gone and you did not capture any Pokemon, but no problem. Talk with Professor Tommy about 'journey' he will help you.")
		doTeleportThing(cid, {x = 2503, y = 1200, z = 6}, false) -- POS FIX
	end
	return true
end

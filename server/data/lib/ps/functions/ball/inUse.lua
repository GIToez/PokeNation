local duelRunAwayCondition = createConditionObject(CONDITION_EXHAUST, -1, false, CONDITION_SUBID.EXHAUST.DUELRUNAWAY)

local function doSendProjectile(fromPosition, toCid, projectile)
	doSendDistanceShoot(fromPosition, getCreaturePosition(toCid), projectile)
end

local POKEMON_BACK_MESSAGES = {
	"thanks!",
	"back!",
	"nice work!",
	"that's enough. Come back!",
}

function inUseBall(cid, item)
	local pokemon = getPlayerPokemon(cid)
	local ballName = ballsNames[item.itemid]

	if (not isCreature(pokemon)) then
		if (getPlayerMounted(cid)) then
			doPlayerSendCancel(cid, "You can not do this while you're mounted.")

		elseif (isEvolving(cid)) then
			doPlayerSendCancel(cid, "You can not do this while your Pokemon is evolving.")

		else
			doPlayerSendCancel(cid, "This ball is discharged.")
			doTransformItem(item.uid, balls[ballName].discharged)
        end

	elseif (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.POKEMONCALL)) then
		doPlayerSendCancel(cid, "You're exhausted.")

	else
		local pokemonEnergy = getCreatureMana(cid)
		local fromPosition = getCreaturePosition(cid)
		local toPosition = getCreaturePosition(pokemon)

		if (not balls[ballName]) then
			log(LOG_TYPES.ERROR, "Ball::inUse - Unknown ballName", ballName, getCreatureName(cid))
		end

		doSendDistanceShoot(fromPosition, toPosition, balls[ballName].projectile)
		addEvent(doSendProjectile, 500, toPosition, cid, balls[ballName].projectile)
		doBallSaveStats(pokemon, item.uid)
		doCreatureSay(cid, getCreatureNickname(pokemon) .. ", " .. __L(cid, POKEMON_BACK_MESSAGES[math.random(1, #POKEMON_BACK_MESSAGES)]))
		doTransformItem(item.uid, balls[ballName].charged)
		doSendMagicEffect(getCreaturePosition(pokemon), balls[ballName].effects.use)
		setPlayerVulnerable(cid, true)
		setCreatureMaxMana(cid, 0)
		doPlayerAddMana(cid, -pokemonEnergy, false)
		doAddExhaust(cid)
        doSendCreatureEffect(pokemon, CREATURE_EFFECTS.RED_COPY_FADE_OUT)
		doRemoveCreature(pokemon)
        doCreatureSetStorage(cid, playersStorages.isPokemonOnline, 0)
        doPlayerSendPokemonStatusClear(cid)

        if (getPlayerDueling(cid) or getPlayerBattleing(cid)) then
            doAddCondition(cid, duelRunAwayCondition)

            local duelPokemonRemaing = getPlayerDuelPokemonRemaing(cid)
            if (duelPokemonRemaing) then
                setPlayerDuelPokemonRemaing(cid, duelPokemonRemaing - 1)
                doSendAnimatedText(getCreaturePosition(cid), "OUT!", COLOR_BLACK)
            end
        end
	end
end

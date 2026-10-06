local invulnerableCondition = createConditionObject(CONDITION_INVULNERABLE, 5 * 1000)

function onDeath(cid, corpse, deathList)
	if (isDiving(cid) or isUnderwater(cid)) then
        OxygenMask.doPlayerUnlock(cid)
		setUnderwaterStatus(cid, false)
		setDivingStatus(cid, false)
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)

	elseif (isSurfing(cid)) then
		setSurfingStatus(cid, false)
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)

	elseif (isRiding(cid)) then
		setRidingStatus(cid, false)
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)

	elseif (isFlying(cid)) then
		setFlyingStatus(cid, false)
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)

    elseif (isLevitating(cid)) then
		setLevitatingStatus(cid, false)
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.ABILITIES)
	end

    if (getPlayerMasteryDungeon(cid) > 0) then
        doMasteryDungeonEnd(cid, false)
    end

    doPlayerReset(cid)
    doPlayerRemoveAbilitySpeedCondition(cid)
    doPlayerPopupFYI(cid, "You scurried to a Pokemon Center, protecting the exhausted\nand fainted Pokemon from further harm...")
    doAddCondition(cid, invulnerableCondition) -- Prevent damage from DOT moves. (Yeah, that's ugly)
    setPlayerBlockLogout(cid, false)
    doPlayerSendPokemonStatusClear(cid)
	return true
end

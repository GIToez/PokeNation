local base = 7500

pokemonsStorages = {
	isSleeping = base + 1,
	sleepingTick = base + 2,
	attackTick = base + 3,
	extraDefense = base + 4,
	transform = base + 5,
	accuracy = base + 6,
	isUsingSpecialSkill = base + 7,
	isUsingHealthPotion = base + 8,
	isUsingEnergyPotion = base + 9,
    bonusAtk = base + 10, -- mastery bonus
    bonusDef = base + 11, -- mastery bonus
    lastUsedMove = base + 12,
    safariCatchFactor = base + 13,
    storedDamage = base + 14,
    healthBeforeSubstitute = base + 15,
    canEvolve = base + 16, -- Wild only
    customType1 = base + 17,
    pokemonSummon = base + 18,
    heldMovePowerModifier = base + 19,
    heldMovePowerType = base + 20,
    heldMovePowerType2 = base + 21
    --[[, Isnt used
    customType2 = base + 18,]]
}

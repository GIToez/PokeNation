MOVES["Milk Drink"] = {
    description = "Milk Drink restores up to 50% of the user's current HP.",
    makeHeal = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 16316,
    iconId = 0,
    dType = DAMAGE_TYPE_NORMAL,
    functionName = "MilkDrink",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 100,
    requiredLevel = 40,
    effect = EFFECT_MILK_DRINK,
    damageType = ELEMENT_NORMAL,
    cooldownTime = 120,
    cooldownStorage = 15277,
    damageText = "HHp"
}
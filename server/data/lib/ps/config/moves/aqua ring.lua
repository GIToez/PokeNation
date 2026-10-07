MOVES["Aqua Ring"] = {
    description = "The user surrounds itself with a veil of water, allowing it to restore 1/16 of its max HP at the end of every turn during 16 turns.",
    makeHeal = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 16300,
    iconId = 0,
    dType = DAMAGE_TYPE_WATER,
    functionName = "AquaRing",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 100,
    requiredLevel = 40,
    effect = EFFECT_BUBBLES,
    damageType = ELEMENT_WATER,
    cooldownTime = 120,
    cooldownStorage = 15261,
    damageText = "THp"
}
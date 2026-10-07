MOVES["Wish"] = {
    description = "The turn Wish is used, the user will make a wish. At the end of the next turn, the Pokemon will be healed by half its own maximum HP.",
    makeHeal = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 16334,
    iconId = 0,
    dType = DAMAGE_TYPE_NORMAL,
    functionName = "Wish",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 100,
    requiredLevel = 40,
    effect = EFFECT_FAILING_STARS,
    damageType = ELEMENT_NORMAL,
    cooldownTime = 90,
    cooldownStorage = 15294,
    damageText = "HHp"
}
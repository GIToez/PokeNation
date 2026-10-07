MOVES["Recover"] = {
    description = "User recovers 50% of its max HP.",
    makeHeal = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 11823,
    iconId = 13449,
    dType = DAMAGE_TYPE_NORMAL,
    damageType = ELEMENT_NORMAL,
    functionName = "Recover",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 90,
    requiredLevel = 30,
    effect = EFFECT_GREEN_BUFF,
    cooldownTime = 120,
    cooldownStorage = 15133,
    damageText = "HHp"
}
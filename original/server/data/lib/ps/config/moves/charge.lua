MOVES["Charge"] = {
    description = "If the user's next move is Electric-type, its base power will be doubled. Charge also raises the user's Special Defense by one stat level.",
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 16303,
    iconId = 0,
    dType = DAMAGE_TYPE_ELECTRIC,
    functionName = "Charge",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 100,
    requiredLevel = 40,
    effect = EFFECT_ELECTRIC_SPARK,
    projectile = PROJECTILE_DOUBLE_THUNDER,
    damageType = ELEMENT_ELECTRIC,
    cooldownTime = 90,
    cooldownStorage = 15264
}
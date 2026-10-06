MOVES["Thunder Shock"] = {
    description = "Thunder Shock inflicts damage and has a 10% chance of paralyzing the target.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11773,
    iconId = 13399,
    dType = DAMAGE_TYPE_ELECTRIC,
    functionName = "ThunderShock",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 40,
    requiredLevel = 15,
    damage = 40,
    damageType = ELEMENT_ELECTRIC,
    effect = EFFECT_ELECTRIC_DISCHARGE,
    projectile = PROJECTILE_THUNDER,
    maxDistance = 6,
    cooldownTime = 6,
    cooldownStorage = 15081
}
MOVES["Thunderbolt"] = {
    description = "Thunderbolt does damage and has a 10% chance of paralyzing the target.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11774,
    iconId = 13400,
    dType = DAMAGE_TYPE_ELECTRIC,
    functionName = "Thunderbolt",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 85,
    requiredLevel = 25,
    damage = math.floor(90 / 3),
    damageType = ELEMENT_ELECTRIC,
    effect = EFFECT_ELECTRIC_DISCHARGE_TWO,
    projectile = PROJECTILE_THUNDER,
    maxDistance = 4,
    cooldownTime = 14,
    cooldownStorage = 15082
}
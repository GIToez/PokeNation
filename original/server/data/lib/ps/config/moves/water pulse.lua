MOVES["Water Pulse"] = {
    description = "Water Pulse deals damage and has a 20% chance of confusing the target.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 12055,
    iconId = 0,
    dType = DAMAGE_TYPE_WATER,
    functionName = "WaterPulse",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 65,
    requiredLevel = 30,
    damage = 60,
    damageType = ELEMENT_WATER,
    effect = EFFECT_WATER_BALL,
    projectile = PROJECTILE_BUBBLES,
    maxDistance = 7,
    cooldownTime = 9,
    cooldownStorage = 15149
}
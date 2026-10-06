MOVES["Shock Wave"] = {
    description = "Shock Wave inflicts damage and is unaffected by modifications to the Accuracy stat and Evasion stat.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 16324,
    iconId = 0,
    dType = DAMAGE_TYPE_ELECTRIC,
    functionName = "ShockWave",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 60,
    requiredLevel = 15,
    damage = 60,
    damageType = ELEMENT_ELECTRIC,
    effect = EFFECT_ELECTRIC_CLOUD,
    projectile = PROJECTILE_THUNDER,
    maxDistance = 6,
    cooldownTime = 15,
    cooldownStorage = 15285
}
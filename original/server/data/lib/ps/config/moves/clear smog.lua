MOVES["Clear Smog"] = {
    description = "Clear Smog inflicts damage and resets all stat levels of the target to 0.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 12129,
    iconId = 0,
    dType = DAMAGE_TYPE_POISON,
    functionName = "ClearSmog",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 50,
    requiredLevel = 20,
    damage = 50,
    damageType = ELEMENT_POISON,
    effect = EFFECT_GRAY_SMOKE,
    projectile = PROJECTILE_STRING_SHOT,
    maxDistance = 6,
    cooldownTime = 8,
    cooldownStorage = 15223
}
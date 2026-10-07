MOVES["Shadow Ball"] = {
    description = "Shadow Ball deals damage and has a 20% chance of lowering the target's Special Defense by one stage.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 12116,
    iconId = 0,
    dType = DAMAGE_TYPE_GHOST,
    functionName = "ShadowBall",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 80,
    requiredLevel = 40,
    damage = 80,
    damageType = ELEMENT_GHOST,
    effect = EFFECT_SHADOW_MINICLOUD,
    projectile = PROJECTILE_NIGHT_SHADE,
    maxDistance = 6,
    cooldownTime = 12,
    cooldownStorage = 15297
}
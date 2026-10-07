MOVES["Rock Throw"] = {
    description = "Rock Throw deals damage and has no secondary effect.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 11753,
    iconId = 13379,
    dType = DAMAGE_TYPE_ROCK,
    functionName = "RockThrow",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 50,
    requiredLevel = 15,
    damage = 50,
    damageType = ELEMENT_ROCK,
    effect = EFFECT_FAILING_ROCKS,
    projectile = nil,
    maxDistance = 7,
    cooldownTime = 8,
    cooldownStorage = 15061
}
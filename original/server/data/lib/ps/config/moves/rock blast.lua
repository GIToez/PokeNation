MOVES["Rock Blast"] = {
    description = "Rock Blast inflicts damage, hitting the target 2-5 times per use.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 11752,
    iconId = 13378,
    dType = DAMAGE_TYPE_ROCK,
    functionName = "RockBlast",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 40,
    requiredLevel = 10,
    damage = 25,
    damageType = ELEMENT_ROCK,
    effect = EFFECT_FAILING_ROCKS,
    projectile = PROJECTILE_ROCK,
    maxDistance = 6,
    cooldownTime = 5,
    cooldownStorage = 15060
}
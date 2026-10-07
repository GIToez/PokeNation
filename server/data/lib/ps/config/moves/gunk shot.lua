MOVES["Gunk Shot"] = {
    description = "Gunk Shot deals damage and has a 30% chance of poisoning the target.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 12075,
    iconId = 0,
    dType = DAMAGE_TYPE_POISON,
    functionName = "GunkShot",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 125,
    requiredLevel = 45,
    damage = 120,
    damageType = ELEMENT_POISON,
    effect = EFFECT_POISON_GAS_FOUR,
    projectile = PROJECTILE_POISON_BLAST,
    maxDistance = 6,
    cooldownTime = 18,
    cooldownStorage = 15170
}
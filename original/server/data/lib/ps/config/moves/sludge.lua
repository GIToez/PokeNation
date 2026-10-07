MOVES["Sludge"] = {
    description = "Sludge does damage and has a 30% chance of poisoning the target.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11761,
    iconId = 13387,
    dType = DAMAGE_TYPE_POISON,
    functionName = "Sludge",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 70,
    requiredLevel = 20,
    damage = 65,
    damageType = ELEMENT_POISON,
    effect = EFFECT_POISON_SPLASH,
    projectile = PROJECTILE_POISON_BLAST,
    maxDistance = 6,
    cooldownTime = 10,
    cooldownStorage = 15069
}
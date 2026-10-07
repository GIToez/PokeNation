MOVES["Smog"] = {
    description = "Smog inflicts damage and has a 40% chance of poisoning the target.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11762,
    iconId = 13388,
    dType = DAMAGE_TYPE_POISON,
    functionName = "Smog",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 45,
    requiredLevel = 5,
    damage = 30,
    damageType = ELEMENT_POISON,
    effect = EFFECT_POISON,
    projectile = PROJECTILE_SLUDGE,
    areaEffect = EFFECT_POISON_GAS_FOUR,
    cooldownTime = 10,
    cooldownStorage = 15070
}
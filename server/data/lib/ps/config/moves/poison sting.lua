MOVES["Poison Sting"] = {
    description = "Poison Sting inflicts damage and has a 30% chance of poisoning the target.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 11746,
    iconId = 13372,
    dType = DAMAGE_TYPE_POISON,
    functionName = "PoisonSting",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 20,
    requiredLevel = 7,
    damage = 15,
    damageType = ELEMENT_POISON,
    effect = EFFECT_POISON_BUBBLES,
    projectile = PROJECTILE_SINGLE_THORN,
    maxDistance = 6,
    cooldownTime = 5,
    cooldownStorage = 15054
}
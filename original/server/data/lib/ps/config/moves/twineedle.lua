MOVES["Twineedle"] = {
    description = "Twineedle deals damage and will strike twice (with 25 base power each time). It has a 20% chance of poisoning the target, except for Poison or Steel types which cannot be poisoned.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 12067,
    iconId = 0,
    dType = DAMAGE_TYPE_BUG,
    functionName = "Twineedle",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 55,
    requiredLevel = 20,
    damage = 25,
    damageType = ELEMENT_BUG,
    effect = EFFECT_POISON_CLOUD,
    projectile = PROJECTILE_SINGLE_THORN,
    maxDistance = 4,
    cooldownTime = 8,
    cooldownStorage = 15162
}
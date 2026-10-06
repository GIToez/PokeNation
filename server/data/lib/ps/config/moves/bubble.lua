MOVES["Bubble"] = {
    description = "Bubble deals damage and has a 10% chance of lowering the target's Speed by one stage.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11701,
    iconId = 13327,
    dType = DAMAGE_TYPE_WATER,
    functionName = "Bubble",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 40,
    requiredLevel = 5,
    damage = 10,
    damageType = ELEMENT_WATER,
    effect = EFFECT_BUBBLES,
    projectile = PROJECTILE_BUBBLES_TWO,
    maxDistance = 7,
    cooldownTime = 3,
    cooldownStorage = 15009
}
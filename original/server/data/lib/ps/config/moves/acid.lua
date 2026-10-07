MOVES["Acid"] = {
    description = "Acid deals damage and has a 10% chance of lowering the target's Special Defense by one stage.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11693,
    iconId = 13319,
    dType = DAMAGE_TYPE_POISON,
    functionName = "Acid",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 40,
    requiredLevel = 12,
    damage = 40,
    damageType = ELEMENT_POISON,
    effect = EFFECT_POISON_GAS_THREE,
    projectile = PROJECTILE_POISON_BLAST,
    maxDistance = 6,
    cooldownTime = 6,
    cooldownStorage = 15001
}
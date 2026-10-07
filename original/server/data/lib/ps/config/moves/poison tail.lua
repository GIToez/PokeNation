MOVES["Poison Tail"] = {
    description = "Poison Tail deals damage and has an increased critical hit ratio. It has a 10% chance of poisoning the target.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 27611,
    iconId = 0,
    dType = DAMAGE_TYPE_POISON,
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 55,
    damage = 50,
    damageType = ELEMENT_POISON,
    effect = EFFECT_PURPLE_SCRATCH,
    projectile = PROJECTILE_POISON_BLAST,
    maxDistance = 1,
    cooldownTime = 9,
    cooldownStorage = 15420,
    makeContact = true,
    criticalChance = 20
}
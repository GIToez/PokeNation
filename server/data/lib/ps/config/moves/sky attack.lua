MOVES["Sky Attack"] = {
    description = "Nothing will happen on the first turn. On the second turn, Sky Attack deals damage and has a 30% chance of causing the target to flinch.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 15741,
    iconId = 0,
    dType = DAMAGE_TYPE_FLYING,
    functionName = "SkyAttack",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 140,
    requiredLevel = 15,
    damage = 140,
    damageType = ELEMENT_FLYING,
    effect = EFFECT_MULTIPLE_BLOW_TWO,
    projectile = nil,
    maxDistance = 6,
    cooldownTime = 24,
    cooldownStorage = 15256
}
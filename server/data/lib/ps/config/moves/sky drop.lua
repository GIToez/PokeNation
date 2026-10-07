MOVES["Sky Drop"] = {
    description = "The user takes the target into the sky, then drops it during the next turn. The target cannot attack while in the sky.",
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 26951,
    iconId = 0,
    dType = DAMAGE_TYPE_FLYING,
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 70,
    damage = 60,
    damageType = ELEMENT_FLYING,
    effect = EFFECT_EARTH_EXPLOSION_TWO,
    projectile = nil,
    maxDistance = 1,
    cooldownTime = 20,
    cooldownStorage = 15356,
    makeContact = true
}
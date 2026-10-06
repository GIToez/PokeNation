MOVES["Frenzy Plant"] = {
    description = "Frenzy Plant deals damage but the user can't attack on the next turn.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 16673,
    iconId = 0,
    dType = DAMAGE_TYPE_GRASS,
    functionName = "FrenzyPlant",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 150,
    requiredLevel = 15,
    damage = 150,
    damageType = ELEMENT_GRASS,
    effect = EFFECT_ROOTS_FOUR,
    projectile = nil,
    maxDistance = 6,
    cooldownTime = 25,
    cooldownStorage = 15300
}
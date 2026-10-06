MOVES["Tri Attack"] = {
    description = "Tri Attack deals damage and has a 20% chance of paralyzing, burning or freezing the target - i.e. a 6.67% chance of each status condition.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11776,
    iconId = 13402,
    dType = DAMAGE_TYPE_NORMAL,
    functionName = "TriAttack",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 75,
    requiredLevel = 45,
    damage = 80,
    damageType = ELEMENT_NORMAL,
    effect = EFFECT_COLORED_TRIANGLE,
    projectile = nil,
    maxDistance = 6,
    cooldownTime = 12,
    cooldownStorage = 15084
}
MOVES["Sheer Cold"] = {
    description = "The foe is attacked with a blast of absolute-zero cold dealing damage equal to the opponent's 30% HP. It will fail if the target's level is higher than the user's level. Ice-type Pokemon era immune to Sheer Cold.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 27600,
    iconId = 0,
    dType = DAMAGE_TYPE_ICE,
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 100,
    damage = 0,
    damageType = ELEMENT_ICE,
    effect = EFFECT_ICEBERG_TWO,
    projectile = PROJECTILE_ICE_TWO,
    maxDistance = 6,
    cooldownTime = 30,
    cooldownStorage = 15429,
    makeContact = false
}
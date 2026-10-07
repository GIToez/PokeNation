MOVES["Mud Shot"] = {
    description = "Mud Shot deals damage and lowers the target's Speed by one stage.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 11742,
    iconId = 13368,
    dType = DAMAGE_TYPE_GROUND,
    functionName = "MudShot",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 60,
    requiredLevel = 15,
    damage = 55,
    damageType = ELEMENT_GROUND,
    effect = EFFECT_POISON_TWO,
    projectile = PROJECTILE_SLUDGE,
    maxDistance = 6,
    cooldownTime = 9,
    cooldownStorage = 15050
}
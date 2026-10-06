MOVES["Mud-Slap"] = {
    description = "Mud-Slap deals damage and lowers the target's Accuracy by one stage.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 13112,
    iconId = 0,
    dType = DAMAGE_TYPE_GROUND,
    functionName = "MudSlap",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 30,
    requiredLevel = 15,
    damage = 20,
    damageType = ELEMENT_GROUND,
    effect = EFFECT_BROWN_SPLASH,
    projectile = PROJECTILE_EARTH_SHOT,
    maxDistance = 1,
    cooldownTime = 10,
    cooldownStorage = 15248
}
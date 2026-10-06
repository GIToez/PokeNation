MOVES["Counter"] = {
    description = "When hit by a Physical Attack, user strikes back with 2x power.",
    makeContact = true,
    wildBlock = true,
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 15738,
    iconId = 0,
    dType = DAMAGE_TYPE_FIGHTING,
    functionName = "Counter",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 100,
    requiredLevel = 50,
    effect = EFFECT_RED_ENERGIZE,
    cooldownTime = 90,
    cooldownStorage = 15255
}
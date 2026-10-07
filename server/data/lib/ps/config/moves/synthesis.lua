MOVES["Synthesis"] = {
    description = "Synthesis restores the user's current HP based on the weather conditions. Under normal conditions Synthesis will restore ½ of the user's total HP.",
    makeHeal = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 12043,
    iconId = 0,
    dType = DAMAGE_TYPE_GRASS,
    damageType = ELEMENT_GRASS,
    functionName = "Synthesis",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 150,
    requiredLevel = 50,
    effect = EFFECT_SYNTHESIS,
    cooldownTime = 120,
    cooldownStorage = 15139,
    damageText = "CHp"
}
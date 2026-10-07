MOVES["Moonlight"] = {
    description = "Moonlight restores the user's current HP based on the weather conditions and time of day. Normal conditions will restore ½ of the total HP.",
    makeHeal = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 11821,
    iconId = 13447,
    dType = DAMAGE_TYPE_FAIRY,
    functionName = "Moonlight",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 120,
    requiredLevel = 40,
    effect = EFFECT_PURPLE_EXPLOSION,
    cooldownTime = 120,
    cooldownStorage = 15131,
    damageType = ELEMENT_FAIRY,
    damageText = "CHp"
}
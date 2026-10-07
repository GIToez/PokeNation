MOVES["Roost"] = {
    description = "User recovers half of its max HP. Flying types temporarily lose Ground type immunity.",
    makeHeal = true,
    wildBlock = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 17583,
    iconId = 13449,
    dType = DAMAGE_TYPE_FLYING,
    damageType = ELEMENT_FLYING,
    functionName = "Roost",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 90,
    effect = EFFECT_GREEN_BUFF,
    cooldownTime = 120,
    cooldownStorage = 15305,
    damageText = "HHp"
}
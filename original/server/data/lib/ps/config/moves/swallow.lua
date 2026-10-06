MOVES["Swallow"] = {
    description = "Swallow recovers a varying amount of HP depending on how many times the user has used Stockpile. It recovers 25%, 50% or 100% of the user's maximum HP if the user stockpiled one, two or three times respectively.",
    makeHeal = true,
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 17586,
    iconId = 0,
    dType = DAMAGE_TYPE_NORMAL,
    damageType = ELEMENT_NORMAL,
    functionName = "Swallow",
    type = SKILLS_TYPES.STATS,
    requiredEnergy = 90,
    requiredLevel = 0,
    effect = EFFECT_GREEN_BUFF,
    cooldownTime = 120,
    cooldownStorage = 15309,
    damageText = "CHp"
}
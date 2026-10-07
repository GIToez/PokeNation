MOVES["Yawn"] = {
    description = "In the turn that Yawn is used, the only effect will be the user yawning at the target. At the end of the next turn, the target (if still active) will fall asleep unless it gets affected by a major status condition in the meantime, a status-protecting move is used (like Safeguard or Uproar), or the battle ends.",
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 16336,
    iconId = 0,
    dType = DAMAGE_TYPE_NORMAL,
    functionName = "Yawn",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 100,
    requiredLevel = 15,
    damage = 0,
    damageType = ELEMENT_NORMAL,
    effect = EFFECT_BIG_BUBBLE,
    projectile = PROJECTILE_BUBBLES_TWO,
    maxDistance = 6,
    cooldownTime = 95,
    cooldownStorage = 15296
}
MOVES["Psycho Shift"] = {
    description = "Psycho Shift transfers any non-volatile status ailment from the user to the target, curing the user in the process. It will not transfer volatile status ailments (confusion, etc.).",
    category = MOVE_CATEGORY.STATUS,
    clientIconId = 16321,
    iconId = 0,
    dType = DAMAGE_TYPE_PSYCHIC,
    functionName = "PsychoShift",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 100,
    requiredLevel = 15,
    damage = 0,
    damageType = ELEMENT_PSYCHIC,
    effect = EFFECT_DARK_ENERGY_TWO,
    projectile = PROJECTILE_DARK_SHOT,
    maxDistance = 6,
    cooldownTime = 100,
    cooldownStorage = 15282
}
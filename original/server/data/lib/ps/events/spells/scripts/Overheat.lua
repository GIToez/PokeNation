local SKILL_NAME = "Overheat"
local LOOK_DIRS = {
    [NORTH] = { x = 0, y = -1, effect = EFFECT_FIRE_SPIN_UP },
    [EAST] = { x = 5, y = 0, effect = EFFECT_FIRE_SPIN_RIGHT },
    [SOUTH] = { x = 0, y = 5, effect = EFFECT_FIRE_SPIN_DOWN },
    [WEST] = { x = -1, y = 0, effect = EFFECT_FIRE_SPIN_LEFT }
}
local HALF_POWER = math.floor(getPokemonSkillDamage(SKILL_NAME) / 2)

function onTargetCreature_Overheat(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, cid)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Overheat")
setCombatArea(combat, createCombatArea(AREA_BEAM5))

function onTargetCreature_OverheatHalf(cid, target)
    doSkillDamage(cid, target, SKILL_NAME, HALF_POWER)
end

function onTargetTile_OverheatHalf(cid, pos)
    addEvent(doSendDistanceShoot, getRandom(1, 300), getCreaturePosition(cid), pos, PROJECTILE_FIRE)
end

local combatEffect = createCombatObject()
setCombatArea(combatEffect, createCombatArea(AREA_BEAM5_SIDE))
setCombatCallback(combatEffect, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_OverheatHalf")
setCombatCallback(combatEffect, CALLBACK_PARAM_TARGETTILE, "onTargetTile_OverheatHalf")

function onCastSpell(cid, var)
    local dir, pos = getCreatureLookDirection(cid), getCreaturePosition(cid)
    doSendMagicEffect({ x = pos.x + LOOK_DIRS[dir].x, y = pos.y + LOOK_DIRS[dir].y, z = pos.z }, LOOK_DIRS[dir].effect)
    doCombat(cid, combat, var)
    doCombat(cid, combatEffect, var)
    return true
end
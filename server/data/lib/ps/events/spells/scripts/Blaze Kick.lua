local SKILL_NAME = "Blaze Kick"
local LOOK_DIRS = {
    [NORTH] = {x = 0, y = -2, effect = EFFECT_FLAME_BURST_UP},
    [EAST] =  {x = 2, y = 0, effect = EFFECT_FLAME_BURST_RIGHT},
    [SOUTH] = {x = 0, y = 2, effect = EFFECT_FLAME_BURST_DOWN},
    [WEST] =  {x = -2, y = 0, effect = EFFECT_FLAME_BURST_LEFT}
}

function onTargetCreature_BlazeKick(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
    end
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_BlazeKick")
setCombatArea(combat, createCombatArea(AREA_WAVE3X3))

local function doSpell(cid, var)
    local dir, pos = getCreatureLookDirection(cid), getCreaturePosition(cid)
    doSendMagicEffect({x = pos.x + LOOK_DIRS[dir].x, y = pos.y + LOOK_DIRS[dir].y, z = pos.z}, LOOK_DIRS[dir].effect)
    doCombat(cid, combat, var)
end

function onCastSpell(cid, var)
    doSpell(cid, var)
    return true
end
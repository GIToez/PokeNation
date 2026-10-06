local SKILL_NAME = "Fire Punch"

local LOOK_DIRS = {
    [NORTH] = EFFECT_FLAME_BURST_UP,
    [SOUTH] = EFFECT_FLAME_BURST_DOWN,
    [WEST] = EFFECT_FLAME_BURST_LEFT,
    [EAST] = EFFECT_FLAME_BURST_RIGHT
}

function onTargetCreature_FirePunch(cid, target)
	doSendMagicEffect(getCreaturePosition(target), LOOK_DIRS[getCreatureLookDir(cid)])
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FirePunch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

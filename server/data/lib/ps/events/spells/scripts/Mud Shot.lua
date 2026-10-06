local SKILL_NAME = "Mud Shot"

function onTargetCreature_MudShot(cid, target)
	local cidPos, targetPos, i = getCreaturePosition(cid), getCreaturePosition(target), 0
    for i = 0, 5 do
        addEvent(doSendDistanceShoot, i * 100, cidPos, targetPos, PROJECTILE_EARTH_SHOT)
    end

    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MudShot")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

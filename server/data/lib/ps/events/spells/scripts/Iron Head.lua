local SKILL_NAME = "Iron Head"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_IronHead(cid, target)
	local pos, targetPos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (targetPos) then
        doSendDistanceShoot(pos, targetPos, PROJECTILE)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, targetPos, false)
	    doSendMagicEffect(targetPos, EFFECT_TELEPORT_FRAME)
    end

	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
		doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, nil, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_IronHead")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

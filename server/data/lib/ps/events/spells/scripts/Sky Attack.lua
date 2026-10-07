local SKILL_NAME = "Sky Attack"
local INTERVAL = 2000

local function doAttack(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
        if (getSameFloor(cidPos, targetPos)) then
            local pos =  getPositionAdjacent(cid, targetPos, false)
            if (pos) then
                doSendDistanceShoot(cidPos, pos, PROJECTILE_GRAVEL)
                doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
                doTeleportThing(cid, pos, false)
                doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
                doSendMagicEffect(pos, EFFECT_EARTH_EXPLOSION)
            end

            doSkillDamage(cid, target, SKILL_NAME)
            if (not isCreature(target)) then return end -- Defeated
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                    (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
                doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, nil, cid)
            end
        end
    end
end

function onTargetCreature_SkyAttack(cid, target)
	addEvent(doAttack, INTERVAL, cid, target)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SkyAttack")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
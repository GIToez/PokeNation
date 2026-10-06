local SKILL_NAME = "Supersonic"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)
local SKILL_DISTANCE = getPokemonSkillMaxDistance(SKILL_NAME)

function onTargetCreature_Supersonic(cid, target)
    local cidPos, targetPos, i = getCreaturePosition(cid), getCreaturePosition(target), 0
    for i = 0, SKILL_DISTANCE do
        addEvent(doSendDistanceShoot, 100 * i, cidPos, targetPos, SKILL_PROJECTILE)
    end
    doSendMagicEffect(targetPos, SKILL_EFFECT)
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_CONFUSION, nil, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Supersonic")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
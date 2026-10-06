local SKILL_NAME = "Screech"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_Screech(cid, target)
    local pos = getCreaturePosition(target)
	doSendDistanceShoot(getCreaturePosition(cid), pos, PROJECTILE)
    doSendMagicEffect(pos, EFFECT)
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BADMEDIUM, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Screech")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

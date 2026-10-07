local SKILL_NAME = "Yawn"
local INTERVAL = 2000
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_Yawn(cid, target)
	doSendDistanceShoot(getCreaturePosition(cid), getCreaturePosition(target), PROJECTILE)
    doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Yawn")

local function doSpell(cid)
    if (isCreature(cid) and hasTarget(cid)) then
        doCombat(cid, combat, numberToVariant(getCreatureTarget(cid)))
    end
end

function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT)
    addEvent(doSpell, INTERVAL, cid)
    return true
end

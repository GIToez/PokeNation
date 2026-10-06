local SKILL_NAME = "Psycho Shift"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_PsychoShift(cid, target)
    if (getCreatureStatus(cid, CREATURE_STATUS_BURN)) then
        doCreatureRemoveStatus(cid, CREATURE_STATUS_BURN)
        doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
    end

    if (getCreatureStatus(cid, CREATURE_STATUS_FREEZE)) then
        doCreatureRemoveStatus(cid, CREATURE_STATUS_FREEZE)
        doCreatureAddStatus(target, CREATURE_STATUS_FREEZE, nil, cid)
    end

    if (getCreatureStatus(cid, CREATURE_STATUS_PARALYSIS)) then
        doCreatureRemoveStatus(cid, CREATURE_STATUS_PARALYSIS)
        doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, true, cid)
    end

    if (getCreatureStatus(cid, CREATURE_STATUS_BADPOISON)) then
        doCreatureRemoveStatus(cid, CREATURE_STATUS_BADPOISON)
        doCreatureAddStatus(target, CREATURE_STATUS_BADPOISON, getMonsterLevel(cid), cid)
    end

    if (getCreatureStatus(cid, CREATURE_STATUS_SLEEP)) then
        doCreatureRemoveStatus(cid, CREATURE_STATUS_SLEEP)
        doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
    end

    local targetPos = getCreaturePosition(target)
    doSendDistanceShoot(getCreaturePosition(cid), targetPos, PROJECTILE)
    doSendMagicEffect(targetPos, EFFECT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PsychoShift")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
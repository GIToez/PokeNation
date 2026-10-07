local SKILL_NAME = "Present"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_Present(cid, target)
    doSendDistanceShoot(getCreaturePosition(cid), getCreaturePosition(target), PROJECTILE)
    local r = getRandom(0, 100)
    if (r >= 60) then -- 40%
        doSkillDamage(cid, target, SKILL_NAME, 40)
    elseif (r >= 30) then -- 30%
        doSkillDamage(cid, target, SKILL_NAME, 80)
    elseif (r >= 20) then -- 10%
        doSkillDamage(cid, target, SKILL_NAME, 120)
    else -- 20%
        doCreatureAddHealth(target, (isMonster(target) and getMonsterLevel(target) or 10) * 10)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Present")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

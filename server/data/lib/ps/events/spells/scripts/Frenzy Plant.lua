local SKILL_NAME = "Frenzy Plant"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local CUSTOM_EFFECT = EFFECT_MAGNITUDE --EFFECT_ROOT_EMERGE

local function doSpell(cid, target, pos)
    if (isCreature(cid) and isCreature(target)) then
        local targetPos = getCreaturePosition(target)
        if (isSightClear(pos, targetPos, false)) then
            if (getDistanceBetween(pos, targetPos) <= 1) then
                doSkillDamage(cid, target, SKILL_NAME)
            else
                targetPos = getPositionByDirection(pos, getDirectionTo(pos, targetPos), 1)
                doSendMagicEffect(pos, CUSTOM_EFFECT)
                addEvent(doSpell, 300, cid, target, targetPos)
            end
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, variantToNumber(var), getCreaturePosition(cid))
    doCreatureAddStatus(cid, CREATURE_STATUS_RECHARGE, nil, cid)
	return true
end

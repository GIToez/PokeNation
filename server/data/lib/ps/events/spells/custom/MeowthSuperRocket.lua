local SKILL_NAME = "Meowth Super Rocket"
local CUSTOM_EFFECT = EFFECT_GRAY_SMOKE

local combat = createCombatObject()
function onTargetCreature_MeowthSuperRocket(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MeowthSuperRocket")
setCombatArea(combat, createCombatArea(AREA_SQUARE1X1))

local function doSpell(cid, target, pos)
    if (isCreature(cid) and isCreature(target)) then
        local targetPos = getCreaturePosition(target)
        if (isSightClear(pos, targetPos, false)) then
            if (getDistanceBetween(pos, targetPos) <= 1) then
                doCombat(cid, combat, positionToVariant(targetPos))
            else
                targetPos = getPositionByDirection(pos, getDirectionTo(pos, targetPos), 1)
                doSendMagicEffect(pos, CUSTOM_EFFECT)
                addEvent(doSpell, 1000, cid, target, targetPos)
            end
        end
    end
end

function onCastSpell(cid, var)
    doSpell(cid, variantToNumber(var), getCreaturePosition(cid))
	return true
end

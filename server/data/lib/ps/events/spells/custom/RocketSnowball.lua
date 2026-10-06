-- local SKILL_NAME = "Rocket Snowball"

local OUTFIT = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.CHRISTMAS)
addOutfitCondition(OUTFIT, {lookType = 1222})

function onTargetCreature_RocketSnowball(cid, target)
    doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
    if (isPlayer(target) and not getPlayerMounted(target) and not isBiking(target)) then
        if (getCreatureCondition(target, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)) then
			doRemoveCondition(target, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)
		end
        doAddCondition(target, OUTFIT)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RocketSnowball")
setCombatParam(combat, COMBAT_PARAM_EFFECT, EFFECT_FREEZE)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, PROJECTILE_ICE_BALL)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

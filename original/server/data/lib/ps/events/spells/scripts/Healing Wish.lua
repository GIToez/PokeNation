local SKILL_NAME = "Healing Wish"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3)
}
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_HealingWish = function(cid, target)
        if (target ~= cid and isFriend(cid, target)) then
			doSendMagicEffect(getCreaturePosition(target), SKILL_EFFECT)
			doCreatureAddHealth(target, getCreatureMaxHealth(target))
        end
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HealingWish")
	setCombatArea(combats[i], skillArea)
	setCombatParam(combats[i], COMBAT_PARAM_AGGRESSIVE, false)
end

onTargetTile_HealingWish = function(cid, position) doSendMagicEffect({x = position.x + math.random(-1, 1), y = position.y + math.random(-1, 1), z = position.z}, EFFECT_LOVE_HEARTS_TWO) end
local combatEffect = createCombatObject()
setCombatCallback(combatEffect, CALLBACK_PARAM_TARGETTILE, "onTargetTile_HealingWish")
setCombatArea(combatEffect, createCombatArea(AREA_CROSS4X4))
setCombatParam(combatEffect, COMBAT_PARAM_AGGRESSIVE, false)

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
        doCombat(cid, combat, var)
		local heal = -(getCreatureHealth(cid) - 1)
		doCreatureAddHealth(cid, heal)
		doSendAnimatedText(getCreaturePosition(cid), heal, COLOR_RED)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end

    doCombat(cid, combatEffect, var)
    for i = 1, 3 do
        addEvent(function(cid)
            if (isCreature(cid)) then
                doCombat(cid, combatEffect, var)
            end
        end, (100 * i) + 100, cid)
    end
	return true
end

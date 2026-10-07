local SKILL_NAME = "Inferno"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
}
local EFFECTS = {EFFECT_FIRE_BALL, EFFECT_FLAMES_TWO, EFFECT_BIG_FLAMES, EFFECT_BURNING_MAN_DOWN}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Inferno = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
		doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
    end
    onTargetTile_Inferno = function(cid, position)
        doSendDistanceShoot(getSkyPosition(position), position, PROJECTILE_FIRE)
		addEvent(doSendMagicEffect, 150, position, table.random(EFFECTS))
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Inferno")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Inferno")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
	return true
end

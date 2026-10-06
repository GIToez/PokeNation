local SKILL_NAME = "Psywave"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_CIRCLE2X2_EMPTY),
	createCombatArea(AREA_CIRCLE3X3_EMPTY)
}
local AREA_EFFECTS = {EFFECT_PURPLE_CIRCLE, EFFECT_BLUE_CIRCLE, EFFECT_WHITE_CIRCLE}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Psywave = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME, math.ceil(getRandom(5, 15) * (getMonsterLevel(cid) / 10)))
    end
    onTargetTile_Psywave = function(cid, position)
        doSendMagicEffect(position, table.random(AREA_EFFECTS))
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Psywave")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Psywave")
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

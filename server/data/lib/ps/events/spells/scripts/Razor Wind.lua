local SKILL_NAME = "Razor Wind"
local INTERVAL = 2000

local function doAttack(cid, target)
    if (isCreature(cid) and isCreature(target)) then
        doSkillDamage(cid, target, SKILL_NAME)
    end
end

local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE4X4_EMPTY),
    createCombatArea(AREA_CIRCLE3X3_EMPTY),
    createCombatArea(AREA_CIRCLE2X2_EMPTY),
    createCombatArea(AREA_SQUARE1X1)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_RazorWind(cid, target)
	addEvent(doAttack, INTERVAL, cid, target)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RazorWind")
function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 300 * (i - 1) + 1, cid, combat, numberToVariant(cid))
	end
    return doCombat(cid, combat, var)
end

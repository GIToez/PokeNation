local SKILL_NAME = "Magnet Bomb"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1)
}
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_MagnetBomb = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MagnetBomb")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_MagnetBomb(cid, target)
	local pos, i = getCreaturePosition(target)
    for i = 0, 7 do
        local tmpPos = {x = pos.x + getRandom(-4, 4), y = pos.y + getRandom(-4, 4), z = pos.z}
        doSendDistanceShoot(pos, tmpPos, PROJECTILE_METAL_BALL)
        addEvent(doSendDistanceShoot, 400, tmpPos, pos, PROJECTILE_METAL_BALL)
    end
	--doSkillDamage(cid, target, SKILL_NAME)
	for i = 1, 7 do
		doSendMagicEffect({x = pos.x + math.random(-2, 2), y = pos.y + math.random(-2, 2), z = pos.z}, SKILL_EFFECT)
	end
	local var, i, combat = positionToVariant(pos)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MagnetBomb")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

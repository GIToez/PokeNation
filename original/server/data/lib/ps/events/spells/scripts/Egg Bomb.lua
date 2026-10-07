local SKILL_NAME = "Egg Bomb"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1)
}
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_EggBomb = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_EggBomb")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onTargetCreature_EggBomb(cid, target)
	local pos = getCreaturePosition(target)
    local skyPos, i = getSkyPosition(pos), 0
    for i = 0, 2 do
        addEvent(doSendDistanceShoot, 200 * (i - 1), skyPos, pos, PROJECTILE_EGG)
    end
	for i = 1, 7 do
		doSendMagicEffect({x = pos.x + math.random(-2, 2), y = pos.y + math.random(-2, 2), z = pos.z}, SKILL_EFFECT)
	end
	local var, i, combat = positionToVariant(pos)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_EggBomb")
function onCastSpell(cid, var)
	local pos = getCreaturePosition(cid)
    local skyPos, i = getSkyPosition(pos), 0
    for i = 0, 2 do
        addEvent(doSendDistanceShoot, 200 * (i - 1), pos, skyPos, PROJECTILE_EGG)
    end
    addEvent(doSpell, 300, cid, combat, var)
    return true
end

local SKILL_NAME = "Echoed Voice"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local ROUNDS = 3

function onTargetCreature_EchoedVoice(cid, target)
	doSkillDamage(cid, target, SKILL_NAME, getPokemonSkillDamage(SKILL_NAME) / ROUNDS)
end

function onTargetTile_EchoedVoice(cid, position)
	if (math.random(0, 1) == 1) then
		local pos = getCreaturePosition(cid)
		doSendDistanceShoot(pos, { x = position.x + math.random(-1, 1), y = position.y + math.random(-1, 1), z = position.z }, SKILL_PROJECTILE)
		addEvent(doSendDistanceShoot, 250, pos, { x = position.x + math.random(-1, 1), y = position.y + math.random(-1, 1), z = position.z }, SKILL_PROJECTILE)
		addEvent(doSendDistanceShoot, 500, pos, { x = position.x + math.random(-1, 1), y = position.y + math.random(-1, 1), z = position.z }, SKILL_PROJECTILE)
	end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_EchoedVoice")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_EchoedVoice")
setCombatArea(combat, createCombatArea(AREA_WAVE7))

local function doSpell(cid, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i = 1, 3 do
		addEvent(doSpell, 300 * (i - 1) + 1, cid, var)
	end

	return true
end
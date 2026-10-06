-- local SKILL_NAME = "Conversion2"
local PROJECTILES = {PROJECTILE_RED_SHOT, PROJECTILE_GREEN_SHOT, PROJECTILE_DARK_SHOT}
local EFFECTS = {EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}

function onTargetCreature_Conversion2(cid, target)
    local fail = true
    local move = getPokemonLastUsedMove(target)

    if (move) then
        local moveType = getPokemonSkillDamageType(move)
        local types = {}

        for element = ELEMENT_FIRST, ELEMENT_LAST do
            local elementMultipler = 1 * getElementMultipler(moveType, element)

            if (elementMultipler < 1) then
                types[#types +1] = element
            end
        end

        if (#types > 0) then
            setPokemonCustomType(cid, table.random(types))
            fail = false
        end
    end

    if (fail) then
        doSendAnimatedText(getCreaturePosition(cid), "FAIL", TEXTCOLOR_WHITE)
    end

    local pos = getCreaturePosition(cid)
    local targetPos = getCreaturePosition(target)
    for i = 0, 10 do
        addEvent(function(tmpPos)
            doSendDistanceShoot(tmpPos, pos, table.random(PROJECTILES))
            doSendMagicEffect(tmpPos, table.random(EFFECTS))
        end, (i * 100) + 1, targetPos)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Conversion2")

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

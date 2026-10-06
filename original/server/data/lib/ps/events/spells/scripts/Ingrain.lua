local SKILL_NAME = "Ingrain"
local INTERVAL = 2000
local ROUNDS = 16
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

local function doSpell(cid, heal, ticks)
    if (isCreature(cid)) then
        doCreatureAddHealth(cid, heal)

        local pos = getCreaturePosition(cid)
        executeInArea(pos, CLOCKWISE1, doSendMagicEffect, EFFECT)
        addEvent(executeInArea, 100, pos, CLOCKWISE2, doSendMagicEffect, EFFECT)
        addEvent(executeInArea, 200, pos, CLOCKWISE3, doSendMagicEffect, EFFECT)
        addEvent(executeInArea, 300, pos, CLOCKWISE4, doSendMagicEffect, EFFECT)
        addEvent(executeInArea, 400, pos, CLOCKWISE5, doSendMagicEffect, EFFECT)
        addEvent(executeInArea, 500, pos, CLOCKWISE6, doSendMagicEffect, EFFECT)
        addEvent(executeInArea, 600, pos, CLOCKWISE7, doSendMagicEffect, EFFECT)
        addEvent(executeInArea, 700, pos, CLOCKWISE8, doSendMagicEffect, EFFECT)

        if (ticks > 0) then
            addEvent(doSpell, INTERVAL, cid, heal, ticks - 1)
        else
            doCreatureSetNoMove(cid, false)
        end
    end
end

function onCastSpell(cid, var)
    doCreatureSetNoMove(cid, true)
    doSpell(cid, math.floor(getCreatureMaxHealth(cid) / ROUNDS), ROUNDS)
    return true
end

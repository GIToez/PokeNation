CREATURE_EFFECTS = {}
CREATURE_EFFECTS.RED_COPY_FADE_OUT = 0
CREATURE_EFFECTS.RED_FADE_IN = 1
CREATURE_EFFECTS.BURN = 2
CREATURE_EFFECTS.FREEZE = 3
CREATURE_EFFECTS.POISON = 4
CREATURE_EFFECTS.BADPOISON = 5
CREATURE_EFFECTS.HIGHCRITICALCHANCE = 6
CREATURE_EFFECTS.CHARGE = 6
CREATURE_EFFECTS.GRAY = 7
CREATURE_EFFECTS.PURPLE = 8
CREATURE_EFFECTS.EVOLVE = 9

local STACK_GHOST = 256

local function onCreatureEffect(creature, effectId, var)
    if (not creature:getPosition()) then
        return
    end

    if (effectId == CREATURE_EFFECTS.RED_COPY_FADE_OUT) then
        local copy = creature:create()
        local pos = creature:getPosition()

        copy:setPosition(pos)
        copy:setOutfit(creature:getOutfit())
        copy:setDirection(creature:getDirection())
        copy:setGhost(true)

        g_map.addThing(copy, pos, STACK_GHOST)

        copy:setOutfitColor('#ff0f0096', 700)

        scheduleEvent(function()
            g_map.removeThing(copy)
        end, 700)

    elseif (effectId == CREATURE_EFFECTS.RED_FADE_IN) then
        creature:setOutfitColor('#ff0f0096')
        creature:setOutfitColor('#ffffffff', 700)

    elseif (effectId == CREATURE_EFFECTS.BURN) then
        creature:setOutfitColor('#ff6000')
        creature:setOutfitColor('#ffffffff', var)

    elseif (effectId == CREATURE_EFFECTS.FREEZE) then
        creature:setOutfitColor('#00b4ff')
        creature:setOutfitColor('#ffffffff', var)

    elseif (effectId == CREATURE_EFFECTS.POISON) then
        creature:setOutfitColor('#30e927')
        creature:setOutfitColor('#ffffffff', var)

    elseif (effectId == CREATURE_EFFECTS.BADPOISON) then
        creature:setOutfitColor('#a227e9')
        creature:setOutfitColor('#ffffffff', var)

    elseif (effectId == CREATURE_EFFECTS.HIGHCRITICALCHANCE) then
        creature:setOutfitColor('#e92c27')
        creature:setOutfitColor('#ffffffff', var)

    elseif (effectId == CREATURE_EFFECTS.CHARGE) then
        creature:setOutfitColor('#e7e927')
        creature:setOutfitColor('#ffffffff', var)

    elseif (effectId == CREATURE_EFFECTS.GRAY) then
        creature:setOutfitColor('#969696')
        creature:setOutfitColor('#ffffffff', var)

    elseif (effectId == CREATURE_EFFECTS.PURPLE) then
        creature:setOutfitColor('#9617ba')
        creature:setOutfitColor('#ffffffff', var)
    elseif (effectId == CREATURE_EFFECTS.EVOLVE) then
        local firstCopy = creature:create()
        local firstPos = creature:getPosition()

        firstCopy:setPosition(firstPos)
        firstCopy:setOutfit(creature:getOutfit())
        firstCopy:setDirection(creature:getDirection())
        firstCopy:setGhost(true)

        g_map.addThing(firstCopy, firstPos, STACK_GHOST)

        firstCopy:setOutfitColor('#000000ff', 700)

        scheduleEvent(function()
            local copy = firstCopy:create()
            local pos = firstCopy:getPosition()

            local out = firstCopy:getOutfit()
            out.type = var

            copy:setPosition(pos)
            copy:setOutfit(out)
            copy:setDirection(firstCopy:getDirection())
            copy:setGhost(true)

            g_map.removeThing(firstCopy)
            g_map.addThing(copy, pos, STACK_GHOST)

            copy:setOutfitColor('#000000ff')
            copy:setOutfitColor('#ffffffff', 9500)

            scheduleEvent(function()
                g_map.removeThing(copy)
            end, 4500)
        end, 5000)
    end
end

function onInit()
    connect(Creature, {
        onEffect = onCreatureEffect
    })
end

function onTerminate()
    disconnect(Creature, {
        onEffect = onCreatureEffect
    })
end
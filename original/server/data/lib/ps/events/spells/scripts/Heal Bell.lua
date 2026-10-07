local SKILL_NAME = "Heal Bell"
local SKILL_AREAS = {
    createCombatArea(AREA_CIRCLE3X3)
}
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
    combats[i] = createCombatObject()
    onTargetCreature_HealBell = function(cid, target)
        if (isFriend(cid, target)) then
            doSendMagicEffect(getCreaturePosition(target), SKILL_EFFECT)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_SLEEP)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_POISON)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_PARALYSIS)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_FREEZE)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_BURN)
        end
    end
    onTargetTile_HealBell = function(cid, position)
        addEvent(doSendMagicEffect, getRandom(1, 1000), position, SKILL_EFFECT)
    end
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HealBell")
    setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_HealBell")
    setCombatArea(combats[i], skillArea)
    setCombatParam(combats[i], COMBAT_PARAM_AGGRESSIVE, false)
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

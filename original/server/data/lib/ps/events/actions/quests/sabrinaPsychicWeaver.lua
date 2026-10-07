local NPC_NAMES = {"Dream World Unown M", "Dream World Unown A", "Dream World Unown R", "Dream World Unown S",
    "Dream World Unown H" }

local AREAS = {
    {
        {1, 1, 1},
        {1, 3, 1},
        {1, 1, 1}
    },
    {
        {0, 1, 1, 1, 0},
        {1, 0, 0, 0, 1},
        {1, 0, 3, 0, 1},
        {1, 0, 0, 0, 1},
        {0, 1, 1, 1, 0}
    },
    {
        {0, 0, 1, 1, 1, 0, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 3, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 0, 1, 1, 1, 0, 0}
    },
}
local AREA_EFFECTS = {EFFECT_PURPLE_CIRCLE, EFFECT_BLUE_CIRCLE, EFFECT_WHITE_CIRCLE }
local NPC_END_POSITIONS = {
    {x = 5108, y = 467, z = 7},
    {x = 5085, y = 478, z = 7},
    {x = 5099, y = 486, z = 7},
    {x = 5107, y = 493, z = 7},
    {x = 5079, y = 496, z = 7},
}
local CENTER_POS = {x = 5093, y = 483, z = 7}
local RANGEX = 32
local RANGEY = 31
local EXIT_POS = {x = 3985, y = 477, z = 10}
local QUEST_STORAGE = 8475

local function doCheckQuest()
    for _, pos in pairs(NPC_END_POSITIONS) do
        local npc = getTopCreature(pos).uid
        if (not isNpc(npc)) then
            return
        end
    end

    local spec = getSpectators(CENTER_POS, RANGEX, RANGEY)
    if (spec) then
        for k, v in pairs(spec) do
            if (isPlayer(v)) then
                doTeleportThing(v, EXIT_POS)
                doSendMagicEffect(EXIT_POS, EFFECT_NIGHT_SHADE)
                doCreatureSetStorage(v, QUEST_STORAGE, QUEST_STATUS.FINISHED)
                setPlayerBlockLogout(v, false)
                doPlayerSendTextMessage(v, MESSAGE_EVENT_ADVANCE, "You solved Sabrina's Dream!")
                return
            end
        end
    end
end

local doShoot
doShoot = function(cid, pos, stage, ignoreHit)
    executeInArea(pos, AREAS[stage], function(pos)
        doSendMagicEffect(pos, table.random(AREA_EFFECTS))

        if (not ignoreHit) then
            local npc = getTopCreature(pos)
            if (isNpc(npc.uid)) then
                local toPos = getPositionByDirection(pos, getDirectionTo(getCreaturePosition(cid), pos), 1)
                if (isWalkable(npc.uid, toPos)) then
                    doTeleportThing(npc.uid, toPos, true)
                    ignoreHit = true
                    doCheckQuest()
                end
            end
        end
    end)

    if (stage < #AREAS) then
        addEvent(doShoot, 250, cid, pos, stage + 1, ignoreHit)
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isNpc(itemEx.uid) or not table.find(NPC_NAMES, getCreatureName(itemEx.uid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not isPokemonOnline(cid)) then
        doPlayerSendCancel(cid, "First release your Pokemon.")
        return true
    end

    local pokemon = getPlayerPokemon(cid)
    local pokemonPosition = getCreaturePosition(pokemon)

    if (not getTilePzInfo(pokemonPosition) or not isSightClear(pokemonPosition, toPosition, false)) then
        doPlayerSendCancel(cid, "Your Pokemon can't shoot from there.")
        return true
    end

    doShoot(pokemon, pokemonPosition, 1)

    return true
end

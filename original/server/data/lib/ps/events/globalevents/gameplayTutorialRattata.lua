local RESPAWN_PLACES = {
    { x = 5007, y = 786, z = 8 },
    { x = 5016, y = 778, z = 8 },
    { x = 5021, y = 783, z = 8 },
    { x = 5025, y = 774, z = 8 },
    { x = 5010, y = 771, z = 8 }
}

local CREATURES = {}
for k, v in pairs(RESPAWN_PLACES) do
    CREATURES[k] = doCreateMonster("Tutorial Rattata", v, false, true)
end

function onThink()
    for k, v in pairs(CREATURES) do
        if (not isCreature(v)) then
            CREATURES[k] = doCreateMonster("Tutorial Rattata", RESPAWN_PLACES[k], false, true)
        end
    end

    return true
end

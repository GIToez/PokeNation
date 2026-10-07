local RESPAWN_PLACES = {{3616, 549, 7}, {3662, 513, 7}, {3907, 412, 7}, {3284, 487, 7}, {3187, 558, 7}, {3168, 653, 7}, {4003, 742, 7}, {3989, 570, 7}, {3922, 160, 7}, {4107, 288, 7}}

function onThink()
	local pos = table.random(RESPAWN_PLACES)
    local spec = getSpectators(pos, 50, 50, true)
	if (spec) then
        for _, creature in pairs(spec) do
            if (isPokemonWild(creature) and getCreatureName(creature) == "Eevee") then
                return true
            end
        end
    end

	if (not doCreateMonster("Eevee", {x = pos[1], y = pos[2], z = pos[3]}, false, true)) then
        log(LOG_TYPES.WARNING, "eeveeRespawn - Can't spawn monster at position.", pos[1], pos[2], pos[3])
    end
	return true
end

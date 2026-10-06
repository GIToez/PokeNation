local EVOLVES = {
    ["RC Eevee"] = "RC Vaporeon",
    ["RC Vaporeon"] = "RC Jolteon",
    ["RC Jolteon"] = "RC Flareon",
    ["RC Flareon"] = "RC Espeon",
    ["RC Espeon"] = "RC Umbreon",

    ["RC Dratini"] = "RC Dragonair",
    ["RC Dragonair"] = "RC Dragonite",
}

function onPrepareDeath(cid, deathList)
    doPokemonEvolve(cid, (EVOLVES[getCreatureName(cid)]))
    return false
end

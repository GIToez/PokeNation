local EVOLVES = {
    ["Shiny Pikachu"] = "Dungeon Boss Raichu",

    ["Shiny Machop"] = "Dungeon Boss Machoke",
    ["Shiny Machoke"] = "Dungeon Boss Machamp",

    ["Shiny Charmander"] = "Dungeon Boss Charmeleon",
    ["Shiny Charmeleon"] = "Dungeon Boss Charizard",

    ["Shiny Dratini"] = "Dungeon Boss Dragonair",
    ["Shiny Dragonair"] = "Dungeon Boss Dragonite",

    ["Shiny Bulbasaur"] = "Dungeon Boss Ivysaur",
    ["Shiny Ivysaur"] = "Dungeon Boss Venusaur",

    ["Shiny Sandshrew"] = "Dungeon Boss Sandslash",

    ["Shiny Jigglypuff"] = "Dungeon Boss Wigglytuff",

    ["Shiny Grimer"] = "Dungeon Boss Muk",

    ["Shiny Geodude"] = "Dungeon Boss Graveler",
    ["Shiny Graveler"] = "Dungeon Boss Golem",

    ["Shiny Squirtle"] = "Dungeon Boss Wartortle",
    ["Shiny Wartortle"] = "Dungeon Boss Blastoise"
}

function onPrepareDeath(cid, deathList)
	doPokemonEvolve(cid, (EVOLVES[getCreatureName(cid)]))
    return false
end

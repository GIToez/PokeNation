local RANDOM_SKILLS = {
    "Tri Attack", "Power Gem", "Earth Power", "Hydro Pump", "Ice Beam", "Lava Plume", "Psyshock", "Energy Ball", "Moonblast", "Thunderbolt", "Psychic"
}

function onCastSpell(cid, var)
    callSkillFunction(cid, table.random(RANDOM_SKILLS))
    return true
end

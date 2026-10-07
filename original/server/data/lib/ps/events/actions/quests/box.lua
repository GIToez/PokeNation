local BOXES = {
	[13973] = {level = 15, pokemons = {"Spearow", "Ekans", "Sandshrew", "Nidorana", "Nidorano", "Oddish", "Bellsprout", "Diglett", "Meowth", "Mankey", "Poliwag", "Machop", "Geodude", "Grimer", "Shellder", "Krabby", "Koffing", "Horsea", "Goldeen"}},
	[13974] = {level = 30, pokemons = {"Bulbasaur", "Charmander", "Squirtle", "Pidgeotto", "Raticate", "Pikachu", "Nidorina", "Nidorino", "Vulpix", "Jigglypuff", "Venonat", "Psyduck", "Growlithe", "Abra", "Ponyta", "Seel", "Gastly", "Cubone", "Staryu", "Magnemite"}},
	[13975] = {level = 50, pokemons = {"Ivysaur", "Charmeleon", "Wartortle", "Butterfree", "Beedrill", "Golbat", "Gloom", "Venomoth", "Dugtrio", "Persian", "Poliwhirl", "Machoke", "Graveler", "Slowbro", "Magneton", "Dodrio", "Muk", "Onix", "Drowzee", "Kingler", "Electrode", "Marowak", "Weezing", "Rhyhorn", "Tangela", "Seadra", "Starmie", "Primeape", "Fearow"}},
	[13976] = {level = 80, pokemons = {"Venusaur", "Charizard", "Blastoise", "Pidgeot", "Raichu", "Nidoqueen", "Nidoking", "Ninetales", "Vileplume", "Golduck", "Arcanine", "Poliwrath", "Alakazam", "Machamp", "Victreebel", "Tentacruel", "Golem", "Rapidash", "Cloyster", "Gengar", "Hypno", "Exeggutor", "Rhydon", "Jynx", "Gyarados", "Lapras"}}
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local randomBoxPokemon = BOXES[item.itemid].pokemons[math.random(1, #BOXES[item.itemid].pokemons)]
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Congratulations! Your %s result in %s."), getItemNameById(item.itemid), getMonsterInfo(randomBoxPokemon).description))
	doCreatePokemonBall(cid, "poke", randomBoxPokemon, BOXES[item.itemid].level, nil, nil,
        math.floor(BOXES[item.itemid].level / 2), cid, true)
	doRemoveItem(item.uid)
	return true
end

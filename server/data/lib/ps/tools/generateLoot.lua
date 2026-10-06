local CHANCE_MAX = 100000

local POKEMON = {
    -- 1st Gen
    ["Bulbasaur"] = {
        profit = 8,
        loots = {
            { name = "leaf" },
            { name = "bulb" },
            { name = "bulbasaur doll", countmax = 1, chance = 100 },
            { name = "pear", countmax = 5, chance = 5000 },
            { name = "meadow plate", countmax = 1, chance = 1 },
            { name = "toxic plate", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
        }
    },
    ["Ivysaur"] = {
        profit = 35,
        loots = {
            { name = "leaf" },
            { name = "bulb" },
            { name = "bunch of ripe rice" },
            { name = "pear", countmax = 5, chance = 5000 },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "ivysaur doll", countmax = 1, chance = 100 },
            { name = "TM Solar Beam", countmax = 1, chance = 5 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
        }
    },
    ["Venusaur"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "bulb" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "pear", countmax = 5, chance = 5000 },
            { name = "fancy fabric", countmax = 1, chance = 6000 },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "venusaur doll", countmax = 1, chance = 100 },
            { name = "TM Solar Beam", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
        }
    },
    ["Charmander"] = {
        profit = 8,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "flame orb" },
            { name = "charmander doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 1, chance = 2 },
            { name = "TM Rage", countmax = 1, chance = 1 },
            { name = "TM Dragon Rage", countmax = 1, chance = 1 },
        }
    },
    ["Charmeleon"] = {
        profit = 35,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "charmeleon doll", countmax = 1, chance = 100 },
            { name = "TM Dragon Rage", countmax = 1, chance = 5 },
        }
    },
    ["Charizard"] = {
        profit = 60,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "flame orb" },
            { name = "eternal flames" },
            { name = "burning heart" },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "healing oil", countmax = 1, chance = 4166 },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "charizard doll", countmax = 1, chance = 100 },
            { name = "TM Dragon Rage", countmax = 1, chance = 10 },
            { name = "TM Fire Blast", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Squirtle"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "hull" },
            { name = "blueberry", countmax = 5, chance = 5000 },
            { name = "squirtle doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
        }
    },
    ["Wartortle"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "hull" },
            { name = "pot of water" },
            { name = "blueberry", countmax = 5, chance = 5000 },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "wartortle doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
        }
    },
    ["Blastoise"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "blastoise hull" },
            { name = "pot of water" },
            { name = "blueberry", countmax = 5, chance = 5000 },
            { name = "long silk", countmax = 1, chance = 16666 },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "blastoise doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Caterpie"] = {
        profit = 4,
        loots = {
            { name = "pot of moss mug" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "caterpie doll", countmax = 1, chance = 100 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
        }
    },
    ["Metapod"] = {
        profit = 8,
        loots = {
            { name = "pot of moss mug" },
            { name = "sample of sand wasp honey" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "metapod doll", countmax = 1, chance = 100 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
        }
    },
    ["Butterfree"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "sample of sand wasp honey" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "insect skin", countmax = 1, chance = 8333 },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "butterfree doll", countmax = 1, chance = 100 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Weedle"] = {
        profit = 4,
        loots = {
            { name = "pot of moss mug" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "weedle doll", countmax = 1, chance = 100 },
        }
    },
    ["Kakuna"] = {
        profit = 8,
        loots = {
            { name = "pot of moss mug" },
            { name = "sample of sand wasp honey" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "kakuna doll", countmax = 1, chance = 100 },
        }
    },
    ["Beedrill"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "sample of sand wasp honey" },
            { name = "red apple", countmax = 3, chance = 3000 },
            { name = "orange", countmax = 3, chance = 3000 },
            { name = "insect skin", countmax = 1, chance = 8333 },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "beedrill doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Pidgey"] = {
        profit = 4,
        loots = {
            { name = "feather" },
            { name = "light feather" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "pidgey doll", countmax = 1, chance = 100 },
        }
    },
    ["Pidgeotto"] = {
        profit = 25,
        loots = {
            { name = "feather" },
            { name = "light feather" },
            { name = "bunch of wheat" },
            { name = "downy feather" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "pidgeotto doll", countmax = 1, chance = 100 },
        }
    },
    ["Pidgeot"] = {
        profit = 60,
        loots = {
            { name = "feather" },
            { name = "light feather" },
            { name = "bunch of wheat" },
            { name = "royal feather" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "big feather", countmax = 1, chance = 8333 },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "pidgeot doll", countmax = 1, chance = 100 },
            { name = "TM Steel Wing", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Rattata"] = {
        profit = 4,
        loots = {
            { name = "bitten apple" },
            { name = "mouldy cheese" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "cheese", countmax = 5, chance = 3000 },
            { name = "rattata doll", countmax = 1, chance = 100 },
        }
    },
    ["Raticate"] = {
        profit = 25,
        loots = {
            { name = "bitten apple" },
            { name = "mouldy cheese" },
            { name = "scarab cheese" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "cheese", countmax = 5, chance = 3000 },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "raticate doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
        }
    },
    ["Spearow"] = {
        profit = 8,
        loots = {
            { name = "feather" },
            { name = "bunch of wheat" },
            { name = "downy feather" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "spearow doll", countmax = 1, chance = 100 },
        }
    },
    ["Fearow"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "bunch of wheat" },
            { name = "downy feather" },
            { name = "colourful feather" },
            { name = "sharp beak" },
            { name = "red apple", countmax = 3, chance = 5000 },
            { name = "big feather", countmax = 1, chance = 8333 },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "fearow doll", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Ekans"] = {
        profit = 8,
        loots = {
            { name = "bottle of poison" },
            { name = "tooth" },
            { name = "venon pendant" },
            { name = "ekans doll", countmax = 1, chance = 100 },
        }
    },
    ["Arbok"] = {
        profit = 35,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "tooth" },
            { name = "cutting fang" },
            { name = "insect skin", countmax = 1, chance = 8333 },
            { name = "toxic plate", countmax = 1, chance = 100 },
            { name = "arbok doll", countmax = 1, chance = 100 },
            { name = "held poison barb", countmax = 1, chance = 20 },
        }
    },
    ["Pikachu"] = {
        profit = 8,
        loots = {
            { name = "electrizer" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "red apple", countmax = 3, chance = 3000 },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "pikachu doll", countmax = 1, chance = 100 },
            { name = "zap plate", countmax = 1, chance = 2 },
            { name = "TM Thunderbolt", countmax = 1, chance = 1 },
        }
    },
    ["Raichu"] = {
        profit = 35,
        loots = {
            { name = "electrizer" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "red apple", countmax = 5, chance = 3000 },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "zap plate", countmax = 1, chance = 100 },
            { name = "raichu doll", countmax = 1, chance = 100 },
            { name = "Thunderstone", countmax = 1, chance = 20 },
            { name = "TM Thunderbolt", countmax = 1, chance = 10 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
            { name = "held magnet", countmax = 1, chance = 20 },
        }
    },
    ["Sandshrew"] = {
        profit = 8,
        loots = {
            { name = "thorn" },
            { name = "cutting fang" },
            { name = "rare sandbag" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "orange", countmax = 5, chance = 3000 },
            { name = "sandshrew doll", countmax = 1, chance = 100 },
            { name = "earth plate", countmax = 1, chance = 2 },
            { name = "TM Protect", countmax = 1, chance = 1 },
            { name = "TM Defense Curl", countmax = 1, chance = 1 },
        }
    },
    ["Sandslash"] = {
        profit = 35,
        loots = {
            { name = "thorn" },
            { name = "cutting fang" },
            { name = "rare sandbag" },
            { name = "heavy stone" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "orange", countmax = 5, chance = 3000 },
            { name = "earth plate", countmax = 1, chance = 100 },
            { name = "sandslash doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 20 },
        }
    },
    ["Nidorana"] = {
        profit = 4,
        loots = {
            { name = "razor fang" },
            { name = "bottle of poison" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "lemon", countmax = 5, chance = 3000 },
            { name = "nidorana doll", countmax = 1, chance = 100 },
        }
    },
    ["Nidorina"] = {
        profit = 25,
        loots = {
            { name = "razor fang" },
            { name = "bottle of poison" },
            { name = "cutting fang" },
            { name = "venon pendant" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "lemon", countmax = 5, chance = 3000 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "nidorina doll", countmax = 1, chance = 100 },
        }
    },
    ["Nidoqueen"] = {
        profit = 60,
        loots = {
            { name = "razor fang" },
            { name = "bottle of poison" },
            { name = "cutting fang" },
            { name = "venon pendant" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "lemon", countmax = 5, chance = 3000 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "nidoqueen doll", countmax = 1, chance = 100 },
            { name = "Moon Stone", countmax = 1, chance = 20 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Nidorano"] = {
        profit = 4,
        loots = {
            { name = "razor fang" },
            { name = "bottle of poison" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "lemon", countmax = 5, chance = 3000 },
            { name = "nidorano doll", countmax = 1, chance = 100 },
        }
    },
    ["Nidorino"] = {
        profit = 25,
        loots = {
            { name = "razor fang" },
            { name = "bottle of poison" },
            { name = "cutting fang" },
            { name = "venon pendant" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "lemon", countmax = 5, chance = 3000 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "nidorino doll", countmax = 1, chance = 100 },
        }
    },
    ["Nidoking"] = {
        profit = 60,
        loots = {
            { name = "razor fang" },
            { name = "bottle of poison" },
            { name = "cutting fang" },
            { name = "venon pendant" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "lemon", countmax = 5, chance = 3000 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "nidoking doll", countmax = 1, chance = 100 },
            { name = "Moon Stone", countmax = 1, chance = 20 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Clefairy"] = {
        profit = 8,
        loots = {
            { name = "comb" },
            { name = "black diamond" },
            { name = "white orb", countmax = 1, chance = 6250 },
            { name = "melon", countmax = 1, chance = 5000 },
            { name = "clefairy doll", countmax = 1, chance = 100 },
            { name = "pixie plate", countmax = 1, chance = 2 },
            { name = "TM Metronome", countmax = 1, chance = 1 },
        }
    },
    ["Clefable"] = {
        profit = 35,
        loots = {
            { name = "comb" },
            { name = "black diamond" },
            { name = "coral comb" },
            { name = "melon", countmax = 1, chance = 5000 },
            { name = "white orb", countmax = 1, chance = 6250 },
            { name = "pixie plate", countmax = 1, chance = 100 },
            { name = "clefable doll", countmax = 1, chance = 100 },
            { name = "Moon Stone", countmax = 1, chance = 20 },
            { name = "TM Metronome", countmax = 1, chance = 10 },
            { name = "held pink bow", countmax = 1, chance = 20 },
        }
    },
    ["Vulpix"] = {
        profit = 8,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "fire pendant" },
            { name = "orange", countmax = 3, chance = 5000 },
            { name = "vulpix doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 1, chance = 2 },
        }
    },
    ["Ninetales"] = {
        profit = 35,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "fire pendant" },
            { name = "flame orb" },
            { name = "burning heart" },
            { name = "orange", countmax = 3, chance = 5000 },
            { name = "flame plate", countmax = 1, chance = 100 },
            { name = "ninetales doll", countmax = 1, chance = 100 },
            { name = "Fire Stone", countmax = 1, chance = 20 },
            { name = "TM Fire Blast", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 20 },
        }
    },
    ["Jigglypuff"] = {
        profit = 8,
        loots = {
            { name = "microphone" },
            { name = "comb" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "white orb", countmax = 1, chance = 6250 },
            { name = "jigglypuff doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 1 },
            { name = "pixie plate", countmax = 1, chance = 1 },
            { name = "TM Defense Curl", countmax = 1, chance = 5 },
        }
    },
    ["Wigglytuff"] = {
        profit = 35,
        loots = {
            { name = "microphone" },
            { name = "comb" },
            { name = "coral comb" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "pixie plate", countmax = 1, chance = 50 },
            { name = "white orb", countmax = 1, chance = 6250 },
            { name = "wigglytuff doll", countmax = 1, chance = 100 },
            { name = "Moon Stone", countmax = 1, chance = 20 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held pink bow", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Zubat"] = {
        profit = 4,
        loots = {
            { name = "bottle of poison" },
            { name = "tooth" },
            { name = "bat wing" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "zubat doll", countmax = 1, chance = 100 },
        }
    },
    ["Golbat"] = {
        profit = 25,
        loots = {
            { name = "bottle of poison" },
            { name = "tooth" },
            { name = "bat wing" },
            { name = "venon pendant" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "golbat doll", countmax = 1, chance = 100 },
        }
    },
    ["Oddish"] = {
        profit = 4,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "strawberry", countmax = 3, chance = 5000 },
            { name = "oddish doll", countmax = 1, chance = 100 },
        }
    },
    ["Gloom"] = {
        profit = 25,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "strawberry", countmax = 3, chance = 5000 },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "gloom doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 5 },
        }
    },
    ["Vileplume"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bunch of ripe rice" },
            { name = "strawberry", countmax = 3, chance = 5000 },
            { name = "fancy fabric", countmax = 1, chance = 16666 },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "vileplume doll", countmax = 1, chance = 100 },
            { name = "Leaf Stone", countmax = 1, chance = 20 },
            { name = "TM Solar Beam", countmax = 1, chance = 10 },
            { name = "TM Giga Drain", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
        }
    },
    ["Paras"] = {
        profit = 4,
        loots = {
            { name = "bottle of poison" },
            { name = "mushroom" },
            { name = "venon pendant" },
            { name = "strawberry", countmax = 3, chance = 5000 },
            { name = "paras doll", countmax = 1, chance = 100 },
        }
    },
    ["Parasect"] = {
        profit = 35,
        loots = {
            { name = "bottle of poison" },
            { name = "mushroom" },
            { name = "venon pendant" },
            { name = "big mushroom" },
            { name = "strawberry", countmax = 3, chance = 5000 },
            { name = "insect skin", countmax = 1, chance = 8333 },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "parasect doll", countmax = 1, chance = 100 },
            { name = "TM Giga Drain", countmax = 1, chance = 10 },
            { name = "TM Fury Cutter", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Venonat"] = {
        profit = 8,
        loots = {
            { name = "insect antenna" },
            { name = "venon pendant" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "venonat doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 2 },
            { name = "toxic plate", countmax = 1, chance = 2 },
        }
    },
    ["Venomoth"] = {
        profit = 35,
        loots = {
            { name = "insect antenna" },
            { name = "venon pendant" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "insect skin", countmax = 1, chance = 8333 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "venomoth doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Diglett"] = {
        profit = 4,
        loots = {
            { name = "stone orb" },
            { name = "rare sandbag" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "diglett doll", countmax = 1, chance = 100 },
        }
    },
    ["Dugtrio"] = {
        profit = 25,
        loots = {
            { name = "stone orb" },
            { name = "rare sandbag" },
            { name = "shadow rock" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "lightweight fabric", countmax = 1, chance = 83333 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "dugtrio doll", countmax = 1, chance = 100 },
            { name = "TM Fissure", countmax = 1, chance = 10 },
            { name = "TM Tri Attack", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 20 },
        }
    },
    ["Meowth"] = {
        profit = 4,
        loots = {
            { name = "razor fang" },
            { name = "ball of wool" },
            { name = "comb" },
            { name = "coral comb" },
            { name = "spool of yarn" },
            { name = "amulet coin" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "meowth doll", countmax = 1, chance = 100 },
            { name = "TM Iron Tail", countmax = 1, chance = 5 },
        }
    },
    ["Persian"] = {
        profit = 25,
        loots = {
            { name = "razor fang" },
            { name = "ball of wool" },
            { name = "comb" },
            { name = "coral comb" },
            { name = "spool of yarn" },
            { name = "exquisite silk" },
            { name = "amulet coin" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "persian doll", countmax = 1, chance = 100 },
            { name = "TM Iron Tail", countmax = 1, chance = 5 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Psyduck"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "psyduck mug" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "psyduck doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Golduck"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "psyduck mug" },
            { name = "pot of water" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "golduck doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Mankey"] = {
        profit = 8,
        loots = {
            { name = "fur" },
            { name = "bamboo leaves" },
            { name = "cookie", countmax = 3, chance = 3000 },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "mankey doll", countmax = 1, chance = 100 },
            { name = "fist plate", countmax = 1, chance = 2 },
        }
    },
    ["Primeape"] = {
        profit = 35,
        loots = {
            { name = "fur" },
            { name = "ape hair" },
            { name = "bamboo leaves" },
            { name = "bunch of sugar cane" },
            { name = "cookie", countmax = 3, chance = 3000 },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "fist plate", countmax = 1, chance = 100 },
            { name = "primeape doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 10 },
            { name = "held black belt", countmax = 1, chance = 20 }
        }
    },
    ["Growlithe"] = {
        profit = 8,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "fire pendant" },
            { name = "growlithe doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 1, chance = 2 },
        }
    },
    ["Arcanine"] = {
        profit = 35,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "healing oil", countmax = 1, chance = 4166 },
            { name = "flame plate", countmax = 1, chance = 100 },
            { name = "arcanine doll", countmax = 1, chance = 100 },
            { name = "Fire Stone", countmax = 1, chance = 20 },
            { name = "held charcoal", countmax = 1, chance = 20 },
        }
    },
    ["Poliwag"] = {
        profit = 4,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "poliwag doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
        }
    },
    ["Poliwhirl"] = {
        profit = 25,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "poliwhirl doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 5 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
        }
    },
    ["Poliwrath"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "long silk", countmax = 1, chance = 16666 },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "fist plate", countmax = 1, chance = 50 },
            { name = "poliwrath doll", countmax = 1, chance = 100 },
            { name = "Water Stone", countmax = 1, chance = 20 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "TM Submission", countmax = 1, chance = 10 },
            { name = "TM Dynamic Punch", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "held black belt", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
        }
    },
    ["Abra"] = {
        profit = 8,
        loots = {
            { name = "twisted spoon" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "abra doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 1, chance = 2 },
        }
    },
    ["Kadabra"] = {
        profit = 35,
        loots = {
            { name = "twisted spoon" },
            { name = "night orb" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "kadabra doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 5 },
        }
    },
    ["Alakazam"] = {
        profit = 60,
        loots = {
            { name = "twisted spoon" },
            { name = "night orb" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "resistant fabric", countmax = 1, chance = 4166 },
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "alakazam doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 20 },
        }
    },
    ["Machop"] = {
        profit = 4,
        loots = {
            { name = "stone orb" },
            { name = "machop doll", countmax = 1, chance = 100 },
            { name = "fist plate", countmax = 1, chance = 2 },
        }
    },
    ["Machoke"] = {
        profit = 25,
        loots = {
            { name = "stone orb" },
            { name = "box gloves" },
            { name = "fist plate", countmax = 1, chance = 50 },
            { name = "machoke doll", countmax = 1, chance = 100 },
            { name = "TM Dynamic Punch", countmax = 1, chance = 5 },
        }
    },
    ["Machamp"] = {
        profit = 60,
        loots = {
            { name = "stone orb" },
            { name = "box gloves" },
            { name = "fist plate", countmax = 1, chance = 100 },
            { name = "machamp doll", countmax = 1, chance = 100 },
            { name = "TM Submission", countmax = 1, chance = 10 },
            { name = "TM Dynamic Punch", countmax = 1, chance = 10 },
            { name = "held black belt", countmax = 1, chance = 20 }
        }
    },
    ["Bellsprout"] = {
        profit = 4,
        loots = {
            { name = "seed" },
            { name = "leaf" },
            { name = "gracidea" },
            { name = "bellsprout doll", countmax = 1, chance = 100 },
        }
    },
    ["Weepinbell"] = {
        profit = 25,
        loots = {
            { name = "seed" },
            { name = "leaf" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "weepinbell doll", countmax = 1, chance = 100 },
        }
    },
    ["Victreebel"] = {
        profit = 60,
        loots = {
            { name = "seed" },
            { name = "leaf" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "frostbite herb" },
            { name = "fancy fabric", countmax = 1, chance = 16666 },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "victreebel doll", countmax = 1, chance = 100 },
            { name = "Leaf Stone", countmax = 1, chance = 20 },
            { name = "TM Giga Drain", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
        }
    },
    ["Tentacool"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "ruby" },
            { name = "venon pendant" },
            { name = "tentacool doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "toxic plate", countmax = 1, chance = 1 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
        }
    },
    ["Tentacruel"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "ruby" },
            { name = "venon pendant" },
            { name = "pot of water" },
            { name = "long silk", countmax = 1, chance = 16666 },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "tentacruel doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
        }
    },
    ["Geodude"] = {
        profit = 4,
        loots = {
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "geodude doll", countmax = 1, chance = 50 },
            { name = "stone plate", countmax = 1, chance = 1 },
            { name = "earth plate", countmax = 1, chance = 1 },
            { name = "TM Defense Curl", countmax = 1, chance = 1 },
        }
    },
    ["Graveler"] = {
        profit = 25,
        loots = {
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "graveler doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "TM Defense Curl", countmax = 1, chance = 5 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
        }
    },
    ["Golem"] = {
        profit = 60,
        loots = {
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "huge chunk of crude iron" },
            { name = "lightweight fabric", countmax = 1, chance = 83333 },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "golem doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Ponyta"] = {
        profit = 8,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "fire pendant" },
            { name = "ponyta doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 1, chance = 2 },
        }
    },
    ["Rapidash"] = {
        profit = 35,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "fire pendant" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "healing oil", countmax = 1, chance = 4166 },
            { name = "flame plate", countmax = 1, chance = 100 },
            { name = "rapidash doll", countmax = 1, chance = 100 },
            { name = "TM Fire Blast", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 20 },
        }
    },
    ["Slowpoke"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "slowpoke tail" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "slowpoke doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "mind plate", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
        }
    },
    ["Slowbro"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "slowpoke tail" },
            { name = "pot of water" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "slowbro doll", countmax = 1, chance = 100 },
            { name = "Water Stone", countmax = 1, chance = 20 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Magnemite"] = {
        profit = 8,
        loots = {
            { name = "electrizer" },
            { name = "screw" },
            { name = "metal spike" },
            { name = "hard nail" },
            { name = "magnemite doll", countmax = 1, chance = 100 },
            { name = "zap plate", countmax = 1, chance = 1 },
            { name = "iron plate", countmax = 1, chance = 1 },
            { name = "TM Thunder Wave", countmax = 1, chance = 1 },
            { name = "TM Thunderbolt", countmax = 1, chance = 10 },
        }
    },
    ["Magneton"] = {
        profit = 35,
        loots = {
            { name = "screw" },
            { name = "electrizer" },
            { name = "metal spike" },
            { name = "hard nail" },
            { name = "gear wheel" },
            { name = "piece of royal steel" },
            { name = "magnet" },
            { name = "zap plate", countmax = 1, chance = 50 },
            { name = "iron plate", countmax = 1, chance = 50 },
            { name = "magneton doll", countmax = 1, chance = 100 },
            { name = "TM Thunder Wave", countmax = 1, chance = 10 },
            { name = "TM Zap Cannon", countmax = 1, chance = 10 },
            { name = "TM Thunderbolt", countmax = 1, chance = 10 },
            { name = "held magnet", countmax = 1, chance = 10 },
            { name = "held metal coat", countmax = 1, chance = 10 },
        }
    },
    ["Farfetchd"] = {
        profit = 25,
        loots = {
            { name = "feather" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "royal feather" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "farfetchd doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Doduo"] = {
        profit = 8,
        loots = {
            { name = "feather" },
            { name = "light feather" },
            { name = "bunch of wheat" },
            { name = "doduo doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 1 },
            { name = "sky plate", countmax = 1, chance = 1 },
            { name = "TM Rage", countmax = 1, chance = 1 },
        }
    },
    ["Dodrio"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "light feather" },
            { name = "bunch of wheat" },
            { name = "downy feather" },
            { name = "colourful feather" },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "dodrio doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 5 },
            { name = "TM Tri Attack", countmax = 1, chance = 5 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Seel"] = {
        profit = 8,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "icicle" },
            { name = "seel doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
            { name = "TM Icy Wind", countmax = 1, chance = 1 },
        }
    },
    ["Dewgong"] = {
        profit = 35,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "icicle" },
            { name = "giant ice cube" },
            { name = "frozen tear" },
            { name = "icicle plate", countmax = 1, chance = 25 },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "dewgong doll", countmax = 1, chance = 100 },
            { name = "TM Ice Beam", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Icy Wind", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held never melt ice", countmax = 1, chance = 10 },
        }
    },
    ["Grimer"] = {
        profit = 8,
        loots = {
            { name = "bottle of poison" },
            { name = "black sludge" },
            { name = "venon pendant" },
            { name = "grimer doll", countmax = 1, chance = 100 },
            { name = "toxic plate", countmax = 1, chance = 2 },
            { name = "TM Sludge Bomb", countmax = 1, chance = 1 },
        }
    },
    ["Muk"] = {
        profit = 35,
        loots = {
            { name = "bottle of poison" },
            { name = "black sludge" },
            { name = "venon pendant" },
            { name = "toxic plate", countmax = 1, chance = 100 },
            { name = "muk doll", countmax = 1, chance = 100 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
            { name = "TM Sludge Bomb", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 20 },
        }
    },
    ["Shellder"] = {
        profit = 4,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "shell bell" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "harden shell" },
            { name = "shellder doll", countmax = 1, chance = 100 },
            { name = "TM Ice Beam", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
        }
    },
    ["Cloyster"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "shell bell" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "harden shell" },
            { name = "ice crystal" },
            { name = "shard" },
            { name = "ice cream cone (crispy chocolate chips)", countmax = 1, chance = 2000 },
            { name = "ice cream cone (blue-barian)", countmax = 1, chance = 2000 },
            { name = "ice cream cone (chilly cherry)", countmax = 1, chance = 2000 },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "icicle plate", countmax = 1, chance = 50 },
            { name = "cloyster doll", countmax = 1, chance = 100 },
            { name = "Water Stone", countmax = 1, chance = 20 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held never melt ice", countmax = 1, chance = 10 },
        }
    },
    ["Gastly"] = {
        profit = 8,
        loots = {
            { name = "reaper cloth" },
            { name = "essence of a bad dream" },
            { name = "gastly doll", countmax = 1, chance = 100 },
            { name = "toxic plate", countmax = 1, chance = 1 },
            { name = "spooky plate", countmax = 1, chance = 1 },
            { name = "TM Dream Eater", countmax = 1, chance = 1 },
            { name = "TM Curse", countmax = 1, chance = 1 },
            { name = "TM Shadow Ball", countmax = 1, chance = 1 },
        }
    },
    ["Haunter"] = {
        profit = 35,
        loots = {
            { name = "reaper cloth" },
            { name = "essence of a bad dream" },
            { name = "cursed hand" },
            { name = "petrified scream" },
            { name = "spooky plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "haunter doll", countmax = 1, chance = 100 },
            { name = "TM Dream Eater", countmax = 1, chance = 5 },
            { name = "TM Curse", countmax = 1, chance = 5 },
            { name = "TM Shadow Ball", countmax = 1, chance = 5 },
        }
    },
    ["Gengar"] = {
        profit = 60,
        loots = {
            { name = "reaper cloth" },
            { name = "essence of a bad dream" },
            { name = "cursed hand" },
            { name = "petrified scream" },
            { name = "night orb" },
            { name = "old bandage", countmax = 1, chance = 4166 },
            { name = "spooky plate", countmax = 1, chance = 50 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "gengar doll", countmax = 1, chance = 100 },
            { name = "TM Dream Eater", countmax = 1, chance = 10 },
            { name = "TM Curse", countmax = 1, chance = 10 },
            { name = "TM Shadow Ball", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held spell tag", countmax = 1, chance = 10 },
        }
    },
    ["Onix"] = {
        profit = 35,
        loots = {
            { name = "piece of onix" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "lightweight fabric", countmax = 1, chance = 83333 },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "onix doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 5 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "TM Iron Tail", countmax = 1, chance = 5 },
            { name = "held hard stone", countmax = 1, chance = 20 },
        }
    },
    ["Drowzee"] = {
        profit = 25,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "black sludge" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "drowzee doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 1, chance = 2 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
        }
    },
    ["Hypno"] = {
        profit = 60,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "linearly guided hypnose pendant" },
            { name = "essence of a bad dream" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "resistant fabric", countmax = 1, chance = 4166 },
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "hypno doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Dream Eater", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 20 },
        }
    },
    ["Krabby"] = {
        profit = 4,
        loots = {
            { name = "water gem" },
            { name = "crab claw" },
            { name = "crab pincer" },
            { name = "pincer" },
            { name = "blueberry", countmax = 3, chance = 5000 },
            { name = "krabby doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
        }
    },
    ["Kingler"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "crab claw" },
            { name = "crab pincer" },
            { name = "pincer" },
            { name = "elemental spike" },
            { name = "giant pincer" },
            { name = "strong pincers" },
            { name = "blueberry", countmax = 3, chance = 5000 },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "kingler doll", countmax = 1, chance = 100 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Voltorb"] = {
        profit = 8,
        loots = {
            { name = "electrizer" },
            { name = "metal spike" },
            { name = "gear wheel" },
            { name = "hard nail" },
            { name = "voltorb doll", countmax = 1, chance = 100 },
            { name = "zap plate", countmax = 1, chance = 2 },
            { name = "TM Swift", countmax = 1, chance = 1 },
        }
    },
    ["Electrode"] = {
        profit = 60,
        loots = {
            { name = "electrizer" },
            { name = "metal spike" },
            { name = "gear wheel" },
            { name = "hard nail" },
            { name = "piece of royal steel" },
            { name = "magnet" },
            { name = "zap plate", countmax = 1, chance = 50 },
            { name = "electrode doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 5 },
            { name = "TM Thunderbolt", countmax = 1, chance = 10 },
            { name = "held magnet", countmax = 1, chance = 20 },
        }
    },
    ["Exeggcute"] = {
        profit = 8,
        loots = {
            { name = "seed" },
            { name = "egg" },
            { name = "leaf pendant" },
            { name = "strawberry", countmax = 3, chance = 5000 },
            { name = "exeggcute doll", countmax = 1, chance = 100 },
            { name = "meadow plate", countmax = 1, chance = 1 },
            { name = "mind plate", countmax = 1, chance = 1 },
            { name = "TM Egg Bomb", countmax = 1, chance = 1 },
        }
    },
    ["Exeggutor"] = {
        profit = 35,
        loots = {
            { name = "seed" },
            { name = "egg" },
            { name = "leaf pendant" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "strawberry", countmax = 3, chance = 5000 },
            { name = "fancy fabric", countmax = 1, chance = 16666 },
            { name = "meadow plate", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "exeggutor doll", countmax = 1, chance = 100 },
            { name = "Leaf Stone", countmax = 1, chance = 20 },
            { name = "TM Egg Bomb", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Cubone"] = {
        profit = 8,
        loots = {
            { name = "thick club" },
            { name = "rare sandbag" },
            { name = "shadow rock" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "cubone doll", countmax = 1, chance = 100 },
            { name = "earth plate", countmax = 1, chance = 2 },
            { name = "TM Rage", countmax = 1, chance = 5 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
        }
    },
    ["Marowak"] = {
        profit = 35,
        loots = {
            { name = "thick club" },
            { name = "rare sandbag" },
            { name = "shadow rock" },
            { name = "heavy stone" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "lightweight fabric", countmax = 1, chance = 83333 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "marowak doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 10 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 20 },
        }
    },
    ["Hitmonlee"] = {
        profit = 0,
        loots = {
            { name = "fist plate", countmax = 1, chance = 50 },
            { name = "hitmonlee doll", countmax = 1, chance = 100 },
            { name = "Kick Machine", countmax = 1, chance = 200 },
            { name = "held black belt", countmax = 1, chance = 20 }
        }
    },
    ["Hitmonchan"] = {
        profit = 0,
        loots = {
            { name = "fist plate", countmax = 1, chance = 50 },
            { name = "hitmonchan doll", countmax = 1, chance = 100 },
            { name = "Punch Machine", countmax = 1, chance = 200 },
            { name = "TM Dynamic Punch", countmax = 1, chance = 10 },
            { name = "TM Ice Punch", countmax = 1, chance = 10 },
            { name = "TM Thunder Punch", countmax = 1, chance = 10 },
            { name = "TM Fire Punch", countmax = 1, chance = 10 },
            { name = "held black belt", countmax = 1, chance = 20 }
        }
    },
    ["Lickitung"] = {
        profit = 35,
        loots = {
            { name = "tongue" },
            { name = "comb" },
            { name = "energy soil" },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "strawberry", countmax = 5, chance = 5000 },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "lickitung doll", countmax = 1, chance = 100 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Koffing"] = {
        profit = 8,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "black sludge" },
            { name = "koffing doll", countmax = 1, chance = 100 },
            { name = "toxic plate", countmax = 1, chance = 2 },
        }
    },
    ["Weezing"] = {
        profit = 35,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "black sludge" },
            { name = "shadow rock" },
            { name = "toxic plate", countmax = 1, chance = 100 },
            { name = "weezing doll", countmax = 1, chance = 100 },
            { name = "TM Sludge Bomb", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 20 },
        }
    },
    ["Rhyhorn"] = {
        profit = 35,
        loots = {
            { name = "stone orb" },
            { name = "horn" },
            { name = "cutting fang" },
            { name = "heavy stone" },
            { name = "rhyhorn doll", countmax = 1, chance = 100 },
            { name = "earth plate", countmax = 1, chance = 10 },
            { name = "stone plate", countmax = 1, chance = 10 },
        }
    },
    ["Rhydon"] = {
        profit = 60,
        loots = {
            { name = "stone orb" },
            { name = "horn" },
            { name = "cutting fang" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "lightweight fabric", countmax = 1, chance = 83333 },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "rhydon doll", countmax = 1, chance = 100 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Chansey"] = {
        profit = 0,
        loots = {
            { name = "egg" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "chansey doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Egg Bomb", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
        }
    },
    ["Tangela"] = {
        profit = 35,
        loots = {
            { name = "seed" },
            { name = "leaf" },
            { name = "tangela hair" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "meadow plate", countmax = 1, chance = 100 },
            { name = "tangela doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 20 },
        }
    },
    ["Kangaskhan"] = {
        profit = 60,
        loots = {
            { name = "bunch of wheat" },
            { name = "bunch of sugar cane" },
            { name = "bamboo leaves" },
            { name = "cutting fang" },
            { name = "horn" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "melon", countmax = 3, chance = 3000 },
            { name = "orange", countmax = 3, chance = 3000 },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "kangaskhan doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Horsea"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "black sludge" },
            { name = "horsea doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Seadra"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "black sludge" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "seadra doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 5 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
        }
    },
    ["Goldeen"] = {
        profit = 4,
        loots = {
            { name = "water gem" },
            { name = "horn" },
            { name = "water pendant" },
            { name = "goldeen doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
        }
    },
    ["Seaking"] = {
        profit = 25,
        loots = {
            { name = "water gem" },
            { name = "horn" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "cutting fang" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "seaking doll", countmax = 1, chance = 100 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Staryu"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "staryu doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Swift", countmax = 1, chance = 1 },
        }
    },
    ["Starmie"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "ruby" },
            { name = "energy soil" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "starmie doll", countmax = 1, chance = 100 },
            { name = "Water Stone", countmax = 1, chance = 20 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Mr. Mime"] = {
        profit = 0,
        loots = {
            -- {name = "mr. mime cloth"},
            { name = "mr. mime doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "pixie plate", countmax = 1, chance = 50 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Psywave", countmax = 1, chance = 10 },
            { name = "held pink bow", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Scyther"] = {
        profit = 60,
        loots = {
            { name = "scyther razor" },
            { name = "bunch of wheat" },
            { name = "bunch of sugar cane" },
            { name = "bamboo leaves" },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "scyther doll", countmax = 1, chance = 100 },
        }
    },
    ["Jynx"] = {
        profit = 60,
        loots = {
            { name = "jynx clothes" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "frozen heart" },
            { name = "frozen tear" },
            { name = "ice crystal" },
            { name = "icicle" },
            { name = "shard" },
            { name = "ice cream cone (crispy chocolate chips)", countmax = 1, chance = 2000 },
            { name = "ice cream cone (blue-barian)", countmax = 1, chance = 2000 },
            { name = "ice cream cone (chilly cherry)", countmax = 1, chance = 2000 },
            { name = "icicle plate", countmax = 1, chance = 50 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "jynx doll", countmax = 1, chance = 100 },
            { name = "TM Ice Punch", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held never melt ice", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Electabuzz"] = {
        profit = 60,
        loots = {
            { name = "electrizer" },
            { name = "yellow tail" },
            { name = "magnet" },
            { name = "zap plate", countmax = 1, chance = 100 },
            { name = "electabuzz doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "TM Thunderbolt", countmax = 1, chance = 10 },
            { name = "TM Thunder Punch", countmax = 1, chance = 10 },
            { name = "held magnet", countmax = 1, chance = 20 },
        }
    },
    ["Magmar"] = {
        profit = 60,
        loots = {
            { name = "flame orb" },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "magma stone" },
            { name = "magmarizer" },
            { name = "eternal flames" },
            { name = "fire orb" },
            { name = "healing oil", countmax = 1, chance = 4166 },
            { name = "flame plate", countmax = 1, chance = 100 },
            { name = "magmar doll", countmax = 1, chance = 100 },
            { name = "TM Fire Blast", countmax = 1, chance = 10 },
            { name = "TM Fire Punch", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 20 },
        }
    },
    ["Pinsir"] = {
        profit = 25,
        loots = {
            { name = "pincer horn" },
            { name = "cutting fang" },
            { name = "sample of sand wasp honey" },
            { name = "bunch of wheat" },
            { name = "insect plate", countmax = 1, chance = 100 },
            { name = "pinsir doll", countmax = 1, chance = 100 },
            { name = "TM Submission", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 20 },
        }
    },
    ["Tauros"] = {
        profit = 25,
        loots = {
            { name = "horn" },
            { name = "bunch of wheat" },
            { name = "bunch of sugar cane" },
            { name = "bamboo leaves" },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "tauros doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Magikarp"] = {
        profit = 4,
        loots = {
            { name = "water gem" },
            { name = "magikarp doll", countmax = 1, chance = 100 },
        }
    },
    ["Gyarados"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "gyarados tail" },
            { name = "water pendant" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "elemental spike" },
            { name = "long silk", countmax = 1, chance = 16666 },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "gyarados doll", countmax = 1, chance = 100 },
            { name = "TM Dragon Rage", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Lapras"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "elemental spike" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "frozen heart" },
            { name = "frost charm" },
            { name = "frozen tear" },
            { name = "ice crystal" },
            { name = "ice cream cone (crispy chocolate chips)", countmax = 1, chance = 2000 },
            { name = "ice cream cone (blue-barian)", countmax = 1, chance = 2000 },
            { name = "ice cream cone (chilly cherry)", countmax = 1, chance = 2000 },
            { name = "long silk", countmax = 1, chance = 16666 },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "icicle plate", countmax = 1, chance = 50 },
            { name = "lapras doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Ice Beam", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 20 },
            { name = "held never melt ice", countmax = 1, chance = 10 },
        }
    },
    ["Ditto"] = {
        profit = 0,
        loots = {
            { name = "ditto doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 100 },
        }
    },
    ["Eevee"] = {
        profit = 4,
        loots = {
            { name = "tooth" },
            { name = "cutting fang" },
            { name = "onigiri", countmax = 3, chance = 3000 },
            { name = "eevee doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
        }
    },
    ["Vaporeon"] = {
        profit = 0,
        loots = {
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "vaporeon doll", countmax = 1, chance = 100 },
            { name = "Water Stone", countmax = 1, chance = 20 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Jolteon"] = {
        profit = 0,
        loots = {
            { name = "zap plate", countmax = 1, chance = 50 },
            { name = "jolteon doll", countmax = 1, chance = 100 },
            { name = "Thunderstone", countmax = 1, chance = 20 },
            { name = "held magnet", countmax = 1, chance = 20 },
        }
    },
    ["Flareon"] = {
        profit = 0,
        loots = {
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "flareon doll", countmax = 1, chance = 100 },
            { name = "Fire Stone", countmax = 1, chance = 20 },
            { name = "TM Fire Blast", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 20 },
        }
    },
    ["Porygon"] = {
        profit = 0,
        loots = {
            { name = "porygon doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "TM Tri Attack", countmax = 1, chance = 5 },
            { name = "TM Zap Cannon", countmax = 1, chance = 5 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
        }
    },
    ["Omanyte"] = {
        profit = 0,
        loots = {
            { name = "omanyte doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "stone plate", countmax = 1, chance = 2 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
        }
    },
    ["Omastar"] = {
        profit = 0,
        loots = {
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "omastar doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
        }
    },
    ["Kabuto"] = {
        profit = 0,
        loots = {
            { name = "kabuto doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "stone plate", countmax = 1, chance = 2 },
            { name = "TM Mega Drain", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
        }
    },
    ["Kabutops"] = {
        profit = 0,
        loots = {
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "kabutops doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
        }
    },
    ["Aerodactyl"] = {
        profit = 0,
        loots = {
            { name = "stone plate", countmax = 1, chance = 100 },
            { name = "sky plate", countmax = 1, chance = 100 },
            { name = "aerodactyl doll", countmax = 1, chance = 100 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Snorlax"] = {
        profit = 60,
        loots = {
            { name = "bunch of wheat" },
            { name = "bunch of sugar cane" },
            { name = "bamboo leaves" },
            { name = "cookie", countmax = 3, chance = 2000 },
            { name = "mango", countmax = 1, chance = 2000 },
            { name = "lemon", countmax = 3, chance = 2000 },
            { name = "onigiri", countmax = 3, chance = 2000 },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "snorlax doll", countmax = 1, chance = 100 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Snore", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
        }
    },
    ["Articuno"] = {
        profit = 0,
        loots = {
            -- {name = "articuno feather", countmax = 1, chance = 100000},
            { name = "icicle plate", countmax = 5, chance = 100000 },
            { name = "sky plate", countmax = 5, chance = 100000 },
            { name = "articuno doll", countmax = 1, chance = 100 },
            { name = "TM Ice Beam", countmax = 1, chance = 10 },
            { name = "TM Icy Wind", countmax = 1, chance = 10 },
        }
    },
    ["Zapdos"] = {
        profit = 0,
        loots = {
            -- {name = "zapdos feather", countmax = 1, chance = 100000},
            { name = "zap plate", countmax = 5, chance = 100000 },
            { name = "sky plate", countmax = 5, chance = 100000 },
            { name = "zapdos doll", countmax = 1, chance = 100 },
            { name = "TM Thunder Wave", countmax = 1, chance = 10 },
            { name = "TM Zap Cannon", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
        }
    },
    ["Moltres"] = {
        profit = 0,
        loots = {
            -- {name = "moltres feather", countmax = 1, chance = 100000},
            { name = "flame plate", countmax = 5, chance = 100000 },
            { name = "sky plate", countmax = 5, chance = 100000 },
            { name = "moltres doll", countmax = 1, chance = 100 },
            { name = "TM Solar Beam", countmax = 1, chance = 10 },
            { name = "TM Sky Attack", countmax = 1, chance = 10 },
            { name = "TM Steel Wing", countmax = 1, chance = 10 },
        }
    },
    ["Dratini"] = {
        profit = 4,
        loots = {
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "dratini doll", countmax = 1, chance = 100 },
            { name = "draco plate", countmax = 1, chance = 2 },
            { name = "TM Dragon Rage", countmax = 1, chance = 1 },
            { name = "TM Thunder Wave", countmax = 1, chance = 1 },
        }
    },
    ["Dragonair"] = {
        profit = 25,
        loots = {
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "draco plate", countmax = 1, chance = 50 },
            { name = "dragonair doll", countmax = 1, chance = 100 },
            { name = "TM Dragon Rage", countmax = 1, chance = 5 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
        }
    },
    ["Dragonite"] = {
        profit = 0,
        loots = {
            { name = "draco plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "dragonite doll", countmax = 1, chance = 100 },
            { name = "TM Dragon Rage", countmax = 1, chance = 10 },
            { name = "TM Thunder Wave", countmax = 1, chance = 10 },
            { name = "TM Thunder Punch", countmax = 1, chance = 10 },
            { name = "TM Fire Punch", countmax = 1, chance = 10 },
            { name = "held dragon fang", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Mewtwo"] = {
        profit = 0,
        loots = {
            { name = "mewtwo doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 10, chance = 100000 },
            { name = "TM Swift", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Metronome", countmax = 1, chance = 10 },
        }
    },
    ["Mew"] = {
        profit = 0,
        loots = {
            { name = "mew doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 10, chance = 100000 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Metronome", countmax = 1, chance = 10 },
        }
    },
    -- 2nd Gen
    ["Chikorita"] = {
        profit = 8,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "chikorita doll", countmax = 1, chance = 100 },
            { name = "meadow plate", countmax = 1, chance = 2 },
        }
    },
    ["Bayleef"] = {
        profit = 35,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "bamboo stick" },
            { name = "cure herb" },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "bayleef doll", countmax = 1, chance = 100 },
        }
    },
    ["Meganium"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "bamboo stick" },
            { name = "cure herb" },
            { name = "meadow plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "meganium doll", countmax = 1, chance = 100 },
            { name = "held miracle seed", countmax = 1, chance = 20 },
        }
    },
    ["Cyndaquil"] = {
        profit = 8,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "fire pendant" },
            { name = "coal" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "cyndaquil doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 1, chance = 2 },
            { name = "TM Swift", countmax = 1, chance = 1 },
        }
    },
    ["Quilava"] = {
        profit = 35,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "flame orb" },
            { name = "burning heart" },
            { name = "fire pendant" },
            { name = "blazing bone" },
            { name = "coal" },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "quilava doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 5 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "TM Defense Curl", countmax = 1, chance = 5 },
        }
    },
    ["Typhlosion"] = {
        profit = 60,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "burning heart" },
            { name = "eternal flames" },
            { name = "fire pendant" },
            { name = "fire orb" },
            { name = "blazing bone" },
            { name = "coal" },
            { name = "pot of flames" },
            { name = "flame plate", countmax = 1, chance = 100 },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "typhlosion doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 20 },
        }
    },
    ["Totodile"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "totodile doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Croconaw"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "croconaw doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Rage", countmax = 1, chance = 5 },
        }
    },
    ["Feraligatr"] = {
        profit = 60,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "hard nail" },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "feraligatr doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Rage", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Sentret"] = {
        profit = 4,
        loots = {
            { name = "bitten apple" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "sentret doll", countmax = 1, chance = 100 },
            { name = "TM Defense Curl", countmax = 1, chance = 1 },
        }
    },
    ["Furret"] = {
        profit = 25,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "furret doll", countmax = 1, chance = 100 },
            { name = "TM Iron Tail", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
        }
    },
    ["Hoothoot"] = {
        profit = 8,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "downy feather" },
            { name = "light feather" },
            { name = "acorn" },
            { name = "hoothoot doll", countmax = 1, chance = 100 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
        }
    },
    ["Noctowl"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "light feather" },
            { name = "royal feather" },
            { name = "acorn" },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "noctowl doll", countmax = 1, chance = 100 },
            { name = "TM Dream Eater", countmax = 1, chance = 10 },
            { name = "TM Sky Attack", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Ledyba"] = {
        profit = 8,
        loots = {
            { name = "bag of polen" },
            { name = "pot of moss mug" },
            { name = "insect antenna" },
            { name = "sample of sand wasp honey" },
            { name = "acorn" },
            { name = "ledyba doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 1 },
        }
    },
    ["Ledian"] = {
        profit = 25,
        loots = {
            { name = "bag of polen" },
            { name = "pot of moss mug" },
            { name = "insect antenna" },
            { name = "sample of sand wasp honey" },
            { name = "acorn" },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "ledian doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 5 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Spinarak"] = {
        profit = 8,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "acorn" },
            { name = "poisonous slime" },
            { name = "spider fangs" },
            { name = "spider silk" },
            { name = "spiderwebs" },
            { name = "spinarak doll", countmax = 1, chance = 100 },
        }
    },
    ["Ariados"] = {
        profit = 25,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "acorn" },
            { name = "poisonous slime" },
            { name = "spider fangs" },
            { name = "spider silk" },
            { name = "spiderwebs" },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "ariados doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Crobat"] = {
        profit = 60,
        loots = {
            { name = "bottle of poison" },
            { name = "bat wing" },
            { name = "tooth" },
            { name = "cutting fang" },
            { name = "venon pendant" },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "crobat doll", countmax = 1, chance = 100 },
            { name = "Soothe Bell", countmax = 1, chance = 20 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Chinchou"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "electrizer" },
            { name = "pot of water" },
            { name = "water pendant" },
            { name = "chinchou doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "zap plate", countmax = 1, chance = 1 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Thunder Wave", countmax = 1, chance = 1 },
        }
    },
    ["Lanturn"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "electrizer" },
            { name = "pot of water" },
            { name = "water pendant" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "zap plate", countmax = 1, chance = 50 },
            { name = "lanturn doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
            { name = "held magnet", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
        }
    },
    ["Pichu"] = {
        profit = 4,
        loots = {
            { name = "bitten apple" },
            { name = "electrizer" },
            { name = "comb" },
            { name = "acorn" },
            { name = "bag of candies" },
            { name = "decorative ribbon" },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "pichu doll", countmax = 1, chance = 100 },
        }
    },
    ["Cleffa"] = {
        profit = 4,
        loots = {
            { name = "bitten apple" },
            { name = "comb" },
            { name = "acorn" },
            { name = "bag of candies" },
            { name = "decorative ribbon" },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "cleffa doll", countmax = 1, chance = 100 },
        }
    },
    ["Igglybuff"] = {
        profit = 4,
        loots = {
            { name = "bitten apple" },
            { name = "comb" },
            { name = "acorn" },
            { name = "bag of candies" },
            { name = "decorative ribbon" },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "igglybuff doll", countmax = 1, chance = 100 },
            { name = "TM Defense Curl", countmax = 1, chance = 1 },
        }
    },
    ["Togepi"] = {
        profit = 8,
        loots = {
            { name = "bitten apple" },
            { name = "bag of candies" },
            { name = "decorative ribbon" },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "togepi doll", countmax = 1, chance = 100 },
            { name = "TM Metronome", countmax = 1, chance = 1 },
        }
    },
    ["Togetic"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "royal feather" },
            { name = "pixie plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "togetic doll", countmax = 1, chance = 100 },
            { name = "Soothe Bell", countmax = 1, chance = 20 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Metronome", countmax = 1, chance = 10 },
            { name = "held pink bow", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Natu"] = {
        profit = 8,
        loots = {
            { name = "feather" },
            { name = "bunch of wheat" },
            { name = "downy feather" },
            { name = "night orb" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "natu doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 1, chance = 1 },
            { name = "sky plate", countmax = 1, chance = 1 },
            { name = "TM Psychic", countmax = 1, chance = 1 },
        }
    },
    ["Xatu"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "bunch of wheat" },
            { name = "downy feather" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark crystal" },
            { name = "luminous orb" },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "xatu doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Mareep"] = {
        profit = 8,
        loots = {
            { name = "electrizer" },
            { name = "bamboo leaves" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "bamboo stick" },
            { name = "wool" },
            { name = "blueberry", countmax = 5, chance = 5000 },
            { name = "mareep doll", countmax = 1, chance = 100 },
            { name = "zap plate", countmax = 1, chance = 2 },
            { name = "TM Thunder Wave", countmax = 1, chance = 1 },
        }
    },
    ["Flaaffy"] = {
        profit = 25,
        loots = {
            { name = "electrizer" },
            { name = "bamboo leaves" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "bamboo stick" },
            { name = "wool" },
            { name = "zap plate", countmax = 1, chance = 50 },
            { name = "blueberry", countmax = 5, chance = 5000 },
            { name = "flaaffy doll", countmax = 1, chance = 100 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
        }
    },
    ["Ampharos"] = {
        profit = 60,
        loots = {
            { name = "electrizer" },
            { name = "bamboo leaves" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "bamboo stick" },
            { name = "wool" },
            { name = "zap plate", countmax = 1, chance = 100 },
            { name = "blueberry", countmax = 5, chance = 5000 },
            { name = "ampharos doll", countmax = 1, chance = 100 },
            { name = "TM Thunder Wave", countmax = 1, chance = 10 },
            { name = "TM Iron Tail", countmax = 1, chance = 10 },
            { name = "TM Thunder Punch", countmax = 1, chance = 10 },
            { name = "held magnet", countmax = 1, chance = 20 },
        }
    },
    ["Bellossom"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "meadow plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "bellossom doll", countmax = 1, chance = 100 },
            { name = "Sun Stone", countmax = 1, chance = 20 },
            { name = "TM Mega Drain", countmax = 1, chance = 10 },
            { name = "TM Giga Drain", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 20 },
        }
    },
    ["Marill"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "marill doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "pixie plate", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Defense Curl", countmax = 1, chance = 1 },
        }
    },
    ["Azumarill"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "frozen tear" },
            { name = "coral comb" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "pixie plate", countmax = 1, chance = 25 },
            { name = "azumarill doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held pink bow", countmax = 1, chance = 10 },
        }
    },
    ["Sudowoodo"] = {
        profit = 35,
        loots = {
            { name = "stone orb" },
            { name = "big mushroom" },
            { name = "bamboo leaves" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "bamboo stick" },
            { name = "battle stone" },
            { name = "stone plate", countmax = 1, chance = 100 },
            { name = "sudowoodo doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 20 },
        }
    },
    ["Politoed"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "politoed doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "King's Rock", countmax = 1, chance = 20 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Hoppip"] = {
        profit = 8,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "hoppip doll", countmax = 1, chance = 100 },
            { name = "meadow plate", countmax = 1, chance = 1 },
            { name = "sky plate", countmax = 1, chance = 1 },
            { name = "TM Mega Drain", countmax = 1, chance = 1 },
        }
    },
    ["Skiploom"] = {
        profit = 25,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "skiploom doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 5 },
            { name = "TM Giga Drain", countmax = 1, chance = 5 },
        }
    },
    ["Jumpluff"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "jumpluff doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 10 },
            { name = "TM Giga Drain", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Aipom"] = {
        profit = 8,
        loots = {
            { name = "fur" },
            { name = "ape hair" },
            { name = "bamboo leaves" },
            { name = "bamboo leaves" },
            { name = "bunch of sugar cane" },
            { name = "acorn" },
            { name = "bag of candies" },
            { name = "bamboo stick" },
            { name = "banana sash" },
            { name = "banana skin" },
            { name = "banana", countmax = 5, chance = 5000 },
            { name = "aipom doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "TM Swift", countmax = 1, chance = 1 },
        }
    },
    ["Sunkern"] = {
        profit = 4,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "sunkern doll", countmax = 1, chance = 100 },
        }
    },
    ["Sunflora"] = {
        profit = 25,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "sunflora doll", countmax = 1, chance = 100 },
            { name = "Sun Stone", countmax = 1, chance = 20 },
            { name = "TM Mega Drain", countmax = 1, chance = 10 },
            { name = "TM Solar Beam", countmax = 1, chance = 10 },
            { name = "TM Giga Drain", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 20 },
        }
    },
    ["Yanma"] = {
        profit = 25,
        loots = {
            { name = "pot of moss mug" },
            { name = "insect antenna" },
            { name = "bamboo leaves" },
            { name = "sample of sand wasp honey" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "yanma doll", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Wooper"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "wooper doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "earth plate", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Quagsire"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "quagsire doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Espeon"] = {
        profit = 60,
        loots = {
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "linearly guided hypnose pendant" },
            { name = "cutting fang" },
            { name = "luminous orb" },
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "espeon doll", countmax = 1, chance = 100 },
            { name = "Soothe Bell", countmax = 1, chance = 20 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 20 },
        }
    },
    ["Umbreon"] = {
        profit = 60,
        loots = {
            { name = "shadow orb" },
            { name = "cutting fang" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "luminous orb" },
            { name = "dread plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "umbreon doll", countmax = 1, chance = 100 },
            { name = "Soothe Bell", countmax = 1, chance = 20 },
            { name = "TM Curse", countmax = 1, chance = 10 },
            { name = "TM Iron Tail", countmax = 1, chance = 10 },
        }
    },
    ["Murkrow"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "sharp beak" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "royal feather" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "dread plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "murkrow doll", countmax = 1, chance = 100 },
            { name = "held black glasses", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Slowking"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "harden shell" },
            { name = "luminous orb" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "melon", countmax = 5, chance = 5000 },
            { name = "slowking doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "King's Rock", countmax = 1, chance = 20 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Curse", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Misdreavus"] = {
        profit = 35,
        loots = {
            { name = "shadow orb" },
            { name = "reaper cloth" },
            { name = "cursed hand" },
            { name = "energy soil" },
            { name = "essence of a bad dream" },
            { name = "petrified scream" },
            { name = "black orb" },
            { name = "luminous orb" },
            { name = "spooky plate", countmax = 1, chance = 50 },
            { name = "misdreavus doll", countmax = 1, chance = 100 },
            { name = "TM Psywave", countmax = 1, chance = 10 },
            { name = "TM Curse", countmax = 1, chance = 10 },
            { name = "TM Shadow Ball", countmax = 1, chance = 5 },
            { name = "held spell tag", countmax = 1, chance = 20 },
        }
    },
    ["Unown"] = {
        profit = 25,
        loots = {
            { name = "shadow orb" },
            { name = "luminous orb" },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "held twisted spoon", countmax = 1, chance = 20 },
        }
    },
    ["Wobbuffet"] = {
        profit = 35,
        loots = {
            { name = "shadow orb" },
            { name = "twisted spoon" },
            { name = "luminous orb" },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "wobbuffet doll", countmax = 1, chance = 100 },
            { name = "held twisted spoon", countmax = 1, chance = 20 },
        }
    },
    ["Girafarig"] = {
        profit = 35,
        loots = {
            { name = "twisted spoon" },
            { name = "syrup" },
            { name = "bamboo leaves" },
            { name = "bunch of sugar cane" },
            { name = "bamboo stick" },
            { name = "iron loadstone" },
            { name = "luminous orb" },
            { name = "mind plate", countmax = 1, chance = 25 },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "girafarig doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
        }
    },
    ["Pineco"] = {
        profit = 8,
        loots = {
            { name = "pot of moss mug" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "pineco doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 2 },
            { name = "TM Protect", countmax = 1, chance = 5 },
        }
    },
    ["Forretress"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "metal spike" },
            { name = "big mushroom" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "iron plate", countmax = 1, chance = 50 },
            { name = "forretress doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Zap Cannon", countmax = 1, chance = 10 },
            { name = "held metal coat", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Dunsparce"] = {
        profit = 25,
        loots = {
            { name = "water gem" },
            { name = "pot of water" },
            { name = "water pendant" },
            { name = "dunsparce doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "TM Defense Curl", countmax = 1, chance = 5 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Gligar"] = {
        profit = 25,
        loots = {
            { name = "bottle of poison" },
            { name = "razor fang" },
            { name = "cutting fang" },
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "gligar doll", countmax = 1, chance = 100 },
            { name = "earth plate", countmax = 1, chance = 10 },
            { name = "sky plate", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Steelix"] = {
        profit = 60,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "piece of onix" },
            { name = "metal spike" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "iron plate", countmax = 1, chance = 50 },
            { name = "steelix doll", countmax = 1, chance = 100 },
            { name = "Metal Coat", countmax = 1, chance = 200 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "TM Curse", countmax = 1, chance = 10 },
            { name = "TM Iron Tail", countmax = 1, chance = 10 },
            { name = "held metal coat", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Snubbull"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "ruby" },
            { name = "thick club" },
            { name = "comb" },
            { name = "coral comb" },
            { name = "decorative ribbon" },
            { name = "snubbull doll", countmax = 1, chance = 100 },
            { name = "pixie plate", countmax = 1, chance = 2 },
        }
    },
    ["Granbull"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "ruby" },
            { name = "thick club" },
            { name = "comb" },
            { name = "coral comb" },
            { name = "pixie plate", countmax = 1, chance = 50 },
            { name = "granbull doll", countmax = 1, chance = 100 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
            { name = "held pink bow", countmax = 1, chance = 20 },
        }
    },
    ["Qwilfish"] = {
        profit = 35,
        loots = {
            { name = "water gem" },
            { name = "bottle of poison" },
            { name = "thorn" },
            { name = "venon pendant" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "qwilfish doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "held mystic water", countmax = 1, chance = 20 },
            { name = "held poison barb", countmax = 1, chance = 10 },
        }
    },
    ["Scizor"] = {
        profit = 60,
        loots = {
            { name = "scyther razor" },
            { name = "pot of moss mug" },
            { name = "metal spike" },
            { name = "bunch of sugar cane" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "sample of sand wasp honey" },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "iron plate", countmax = 1, chance = 50 },
            { name = "scizor doll", countmax = 1, chance = 100 },
            { name = "Metal Coat", countmax = 1, chance = 200 },
            { name = "held metal coat", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Shuckle"] = {
        profit = 60,
        loots = {
            { name = "pot of moss mug" },
            { name = "sandbag" },
            { name = "heavy stone" },
            { name = "sample of sand wasp honey" },
            { name = "shadow rock" },
            { name = "battle stone" },
            { name = "insect plate", countmax = 1, chance = 50 },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "shuckle doll", countmax = 1, chance = 100 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Heracross"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "bamboo leaves" },
            { name = "sample of sand wasp honey" },
            { name = "bamboo stick" },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "fist plate", countmax = 1, chance = 25 },
            { name = "heracross doll", countmax = 1, chance = 100 },
            { name = "held black belt", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Sneasel"] = {
        profit = 25,
        loots = {
            { name = "ball of wool" },
            { name = "razor fang" },
            { name = "cutting fang" },
            { name = "exquisite silk" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "frozen tear" },
            { name = "icicle" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "icicle plate", countmax = 1, chance = 25 },
            { name = "dread plate", countmax = 1, chance = 25 },
            { name = "sneasel doll", countmax = 1, chance = 100 },
            { name = "TM Icy Wind", countmax = 1, chance = 5 },
        }
    },
    ["Teddiursa"] = {
        profit = 25,
        loots = {
            { name = "razor fang" },
            { name = "bitten apple" },
            { name = "comb" },
            { name = "ball of wool" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "coral comb" },
            { name = "exquisite silk" },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "teddiursa doll", countmax = 1, chance = 100 },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "TM Snore", countmax = 1, chance = 5 },
        }
    },
    ["Ursaring"] = {
        profit = 60,
        loots = {
            { name = "razor fang" },
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "cutting fang" },
            { name = "exquisite silk" },
            { name = "bamboo stick" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "ursaring doll", countmax = 1, chance = 100 },
            { name = "TM Snore", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Slugma"] = {
        profit = 8,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "stone orb" },
            { name = "fire pendant" },
            { name = "coal" },
            { name = "slugma doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 1, chance = 2 },
        }
    },
    ["Magcargo"] = {
        profit = 35,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "stone orb" },
            { name = "flame orb" },
            { name = "magma stone" },
            { name = "magmarizer" },
            { name = "burning heart" },
            { name = "eternal flames" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "fire pendant" },
            { name = "fire orb" },
            { name = "battle stone" },
            { name = "coal" },
            { name = "pot of flames" },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "magcargo doll", countmax = 1, chance = 100 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 20 },
            { name = "held hard stone", countmax = 1, chance = 20 },
        }
    },
    ["Swinub"] = {
        profit = 8,
        loots = {
            { name = "sandbag" },
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "frozen tear" },
            { name = "ice crystal" },
            { name = "icicle" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "swinub doll", countmax = 1, chance = 100 },
            { name = "icicle plate", countmax = 1, chance = 1 },
            { name = "earth plate", countmax = 1, chance = 1 },
            { name = "TM Icy Wind", countmax = 1, chance = 5 },
            { name = "TM Mud-Slap", countmax = 1, chance = 5 },
        }
    },
    ["Piloswine"] = {
        profit = 35,
        loots = {
            { name = "sandbag" },
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "frozen heart" },
            { name = "frozen tear" },
            { name = "ice crystal" },
            { name = "giant ice cube" },
            { name = "icicle" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "icicle plate", countmax = 1, chance = 50 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "piloswine doll", countmax = 1, chance = 100 },
            { name = "TM Icy Wind", countmax = 1, chance = 10 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
            { name = "held never melt ice", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Corsola"] = {
        profit = 25,
        loots = {
            { name = "water gem" },
            { name = "stone orb" },
            { name = "elemental spike" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "battle stone" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "corsola doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 5 },
        }
    },
    ["Remoraid"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "remoraid doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Octillery"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "black sludge" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "octillery doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Ice Beam", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Delibird"] = {
        profit = 25,
        loots = {
            { name = "ice cub" },
            { name = "feather" },
            { name = "colourful feather" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "icicle plate", countmax = 1, chance = 25 },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "ice cream cone (crispy chocolate chips)", countmax = 5, chance = 5000 },
            { name = "ice cream cone (blue-barian)", countmax = 5, chance = 5000 },
            { name = "ice cream cone (chilly cherry)", countmax = 5, chance = 5000 },
            { name = "delibird doll", countmax = 1, chance = 100 },
            { name = "held never melt ice", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Mantine"] = {
        profit = 25,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "mantine doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 5 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Skarmory"] = {
        profit = 35,
        loots = {
            { name = "magnet" },
            { name = "metal spike" },
            { name = "gear wheel" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "iron plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "skarmory doll", countmax = 1, chance = 100 },
            { name = "TM Steel Wing", countmax = 1, chance = 10 },
            { name = "held metal coat", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Houndour"] = {
        profit = 25,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "cutting fang" },
            { name = "night orb" },
            { name = "fire pendant" },
            { name = "blazing bone" },
            { name = "coal" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "houndour doll", countmax = 1, chance = 100 },
            { name = "dread plate", countmax = 1, chance = 1 },
            { name = "flame plate", countmax = 1, chance = 1 },
        }
    },
    ["Houndoom"] = {
        profit = 60,
        loots = {
            { name = "fire element" },
            { name = "pot of lava" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "burning heart" },
            { name = "cutting fang" },
            { name = "eternal flames" },
            { name = "night orb" },
            { name = "fire pendant" },
            { name = "fire orb" },
            { name = "blazing bone" },
            { name = "coal" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "pot of flames" },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "dread plate", countmax = 1, chance = 50 },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "houndoom doll", countmax = 1, chance = 100 },
            { name = "TM Iron Tail", countmax = 1, chance = 10 },
            { name = "held black glasses", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 10 },
        }
    },
    ["Kingdra"] = {
        profit = 60,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "black sludge" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "draco plate", countmax = 1, chance = 50 },
            { name = "kingdra doll", countmax = 1, chance = 100 },
            { name = "Dragon Scale", countmax = 1, chance = 20 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "held dragon fang", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
        }
    },
    ["Phanpy"] = {
        profit = 8,
        loots = {
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "phanpy doll", countmax = 1, chance = 100 },
            { name = "earth plate", countmax = 1, chance = 2 },
            { name = "TM Double-Edge", countmax = 1, chance = 1 },
            { name = "TM Defense Curl", countmax = 1, chance = 1 },
        }
    },
    ["Donphan"] = {
        profit = 60,
        loots = {
            { name = "sandbag" },
            { name = "cutting fang" },
            { name = "horn" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "donphan doll", countmax = 1, chance = 100 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Porygon2"] = {
        profit = 60,
        loots = {
            { name = "piece of royal steel" },
            { name = "white orb" },
            { name = "black orb" },
            { name = "luminous orb" },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "porygon2 doll", countmax = 1, chance = 100 },
            { name = "Up-Grade", countmax = 1, chance = 20 },
            { name = "TM Tri Attack", countmax = 1, chance = 10 },
            { name = "TM Zap Cannon", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Stantler"] = {
        profit = 35,
        loots = {
            { name = "bunch of wheat" },
            { name = "bunch of sugar cane" },
            { name = "bamboo leaves" },
            { name = "antlers" },
            { name = "bamboo stick" },
            { name = "iron loadstone" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "stantler doll", countmax = 1, chance = 100 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Smeargle"] = {
        profit = 35,
        loots = {
            { name = "artist canvas" },
            { name = "artist brush with ink" },
            { name = "artist brush" },
            { name = "artist palette" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "smeargle doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Tyrogue"] = {
        profit = 8,
        loots = {
            { name = "bitten apple" },
            { name = "banana sash" },
            { name = "banana skin" },
            { name = "banana", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "tyrogue doll", countmax = 1, chance = 100 },
            { name = "fist plate", countmax = 1, chance = 2 },
        }
    },
    ["Hitmontop"] = {
        profit = 60,
        loots = {
            { name = "box gloves" },
            { name = "bandage" },
            { name = "fist plate", countmax = 1, chance = 50 },
            { name = "hitmontop doll", countmax = 1, chance = 100 },
            { name = "Spin Machine", countmax = 1, chance = 200 },
            { name = "held black belt", countmax = 1, chance = 20 }
        }
    },
    ["Smoochum"] = {
        profit = 8,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "frost charm" },
            { name = "frozen tear" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "smoochum doll", countmax = 1, chance = 100 },
        }
    },
    ["Elekid"] = {
        profit = 8,
        loots = {
            { name = "electrizer" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "elekid doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 1 },
            { name = "TM Thunder Wave", countmax = 1, chance = 1 },
        }
    },
    ["Magby"] = {
        profit = 8,
        loots = {
            { name = "fire element" },
            { name = "fire pendant" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "magby doll", countmax = 1, chance = 100 },
        }
    },
    ["Miltank"] = {
        profit = 60,
        loots = {
            { name = "horn" },
            { name = "decorative ribbon" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "miltank doll", countmax = 1, chance = 100 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "TM Fire Punch", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Blissey"] = {
        profit = 60,
        loots = {
            { name = "egg" },
            { name = "decorative ribbon" },
            { name = "white orb" },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "blissey doll", countmax = 1, chance = 100 },
            { name = "Soothe Bell", countmax = 1, chance = 20 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Egg Bomb", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Raikou"] = {
        profit = 0,
        loots = {
            { name = "raikou doll", countmax = 1, chance = 100 },
            { name = "zap plate", countmax = 5, chance = 100000 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
        }
    },
    ["Entei"] = {
        profit = 0,
        loots = {
            { name = "entei doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 5, chance = 100000 },
            { name = "TM Fire Blast", countmax = 1, chance = 10 },
        }
    },
    ["Suicune"] = {
        profit = 0,
        loots = {
            { name = "suicune doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 5, chance = 100000 },
            { name = "TM Bubblebeam", countmax = 1, chance = 100 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
        }
    },
    ["Larvitar"] = {
        profit = 8,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "shadow rock" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "larvitar doll", countmax = 1, chance = 100 },
            { name = "stone plate", countmax = 1, chance = 1 },
            { name = "earth plate", countmax = 1, chance = 1 },
            { name = "TM Rock Slide", countmax = 1, chance = 1 },
        }
    },
    ["Pupitar"] = {
        profit = 35,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "pupitar doll", countmax = 1, chance = 100 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
        }
    },
    ["Tyranitar"] = {
        profit = 60,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "night orb" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "dread plate", countmax = 1, chance = 50 },
            { name = "tyranitar doll", countmax = 1, chance = 100 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "held black glasses", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 10 },
        }
    },
    ["Lugia"] = {
        profit = 0,
        loots = {
            { name = "lugia doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 10, chance = 100000 },
            { name = "sky plate", countmax = 10, chance = 100000 },
            { name = "TM Swift", countmax = 1, chance = 100 },
            { name = "TM Sky Attack", countmax = 1, chance = 10 },
            { name = "TM Rain Dance", countmax = 1, chance = 10 },
        }
    },
    ["Ho-Oh"] = {
        profit = 0,
        loots = {
            { name = "ho-oh doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 5, chance = 100000 },
            { name = "sky plate", countmax = 5, chance = 100000 },
            { name = "TM Swift", countmax = 1, chance = 100 },
            { name = "TM Fire Blast", countmax = 1, chance = 10 },
            { name = "TM Sky Attack", countmax = 1, chance = 10 },
        }
    },
    ["Celebi"] = {
        profit = 0,
        loots = {
            { name = "celebi doll", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 5, chance = 100000 },
            { name = "meadow plate", countmax = 5, chance = 100000 },
        }
    },
    -- 3rd Gen
    ["Treecko"] = {
        profit = 8,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "treecko doll", countmax = 1, chance = 100 },
            { name = "meadow plate", countmax = 1, chance = 2 },
            { name = "TM Mega Drain", countmax = 1, chance = 1 },
            { name = "TM Giga Drain", countmax = 1, chance = 1 },
        }
    },
    ["Grovyle"] = {
        profit = 35,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "lion's mane flower" },
            { name = "sharp razor" },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "grovyle doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 5 },
            { name = "TM Fury Cutter", countmax = 1, chance = 5 },
        }
    },
    ["Sceptile"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "bamboo stick" },
            { name = "cure herb" },
            { name = "tropical leaf" },
            { name = "lion's mane flower" },
            { name = "sharp razor" },
            { name = "meadow plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "sceptile doll", countmax = 1, chance = 100 },
            { name = "held miracle seed", countmax = 1, chance = 20 },
            { name = "TM Mega Drain", countmax = 1, chance = 10 },
            { name = "TM Fury Cutter", countmax = 1, chance = 10 },
        }
    },
    ["Torchic"] = {
        profit = 8,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "fire pendant" },
            { name = "coal" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "torchic doll", countmax = 1, chance = 100 },
            { name = "flame plate", countmax = 1, chance = 2 },
        }
    },
    ["Combusken"] = {
        profit = 35,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "flame orb" },
            { name = "burning heart" },
            { name = "fire pendant" },
            { name = "blazing bone" },
            { name = "coal" },
            { name = "flame plate", countmax = 1, chance = 25 },
            { name = "fist plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "combusken doll", countmax = 1, chance = 100 },
        }
    },
    ["Blaziken"] = {
        profit = 60,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "burning heart" },
            { name = "eternal flames" },
            { name = "fire pendant" },
            { name = "fire orb" },
            { name = "blazing bone" },
            { name = "coal" },
            { name = "pot of flames" },
            { name = "box gloves" },
            { name = "bandage" },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "fist plate", countmax = 1, chance = 50 },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "blaziken doll", countmax = 1, chance = 100 },
            { name = "held black belt", countmax = 1, chance = 10 },
            { name = "held charcoal", countmax = 1, chance = 10 },
            { name = "TM Fire Punch", countmax = 1, chance = 10 },
        }
    },
    ["Mudkip"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "mudkip doll", countmax = 1, chance = 100 },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
            { name = "TM Mud-Slap", countmax = 1, chance = 1 },
        }
    },
    ["Marshtomp"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "marshtomp doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
            { name = "TM Mud-Slap", countmax = 1, chance = 5 },
        }
    },
    ["Swampert"] = {
        profit = 60,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "hard nail" },
            { name = "rare sandbag" },
            { name = "shadow rock" },
            { name = "blue sphere" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "swampert doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Poochyena"] = {
        profit = 8,
        loots = {
            { name = "cutting fang" },
            { name = "dark claws" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "dread plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "poochyena doll", countmax = 1, chance = 100 },
        }
    },
    ["Mightyena"] = {
        profit = 35,
        loots = {
            { name = "cutting fang" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "astral source" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "dread plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "mightyena doll", countmax = 1, chance = 100 },
            { name = "held black glasses", countmax = 1, chance = 20 },
        }
    },
    ["Zigzagoon"] = {
        profit = 8,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "zigzagoon doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
        }
    },
    ["Linoone"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "forbidden fruit" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "linoone doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
        }
    },
    ["Wurmple"] = {
        profit = 8,
        loots = {
            { name = "pot of moss mug" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "petrified goo" },
            { name = "wurmple doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 2 },
        }
    },
    ["Silcoon"] = {
        profit = 20,
        loots = {
            { name = "pot of moss mug" },
            { name = "insect antenna" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "beetle carapace" },
            { name = "petrified goo" },
            { name = "silcoon doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 25 },
        }
    },
    ["Beautifly"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "insect antenna" },
            { name = "bamboo leaves" },
            { name = "sample of sand wasp honey" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "petrified goo" },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "beautifly doll", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
            { name = "TM Rage", countmax = 1, chance = 5 },
            { name = "TM Mega Drain", countmax = 1, chance = 5 },
            { name = "TM Giga Drain", countmax = 1, chance = 5 },
        }
    },
    ["Cascoon"] = {
        profit = 20,
        loots = {
            { name = "pot of moss mug" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "beetle carapace" },
            { name = "petrified goo" },
            { name = "cascoon doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 25 },
        }
    },
    ["Dustox"] = {
        profit = 35,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "acorn" },
            { name = "poisonous slime" },
            { name = "spider fangs" },
            { name = "spider silk" },
            { name = "spiderwebs" },
            { name = "petrified goo" },
            { name = "grey-blue powder" },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "dustox doll", countmax = 1, chance = 100 },
            { name = "held poison barb", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
        }
    },
    ["Lotad"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "leaf" },
            { name = "seed" },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "meadow plate", countmax = 1, chance = 1 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "lotad doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
            { name = "TM Mega Drain", countmax = 1, chance = 1 },
            { name = "TM Rain Dance", countmax = 1, chance = 1 },
            { name = "TM Giga Drain", countmax = 1, chance = 1 },
        }
    },
    ["Lombre"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "lombre doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 5 },
        }
    },
    ["Ludicolo"] = {
        profit = 60,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "lion's mane flower" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "ludicolo doll", countmax = 1, chance = 100 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "Water Stone", countmax = 1, chance = 20 },
            { name = "TM Mega Drain", countmax = 1, chance = 10 },
        }
    },
    ["Seedot"] = {
        profit = 8,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "meadow plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "seedot doll", countmax = 1, chance = 100 },
        }
    },
    ["Nuzleaf"] = {
        profit = 35,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "tropical leaf" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "forbidden fruit" },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "dread plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "nuzleaf doll", countmax = 1, chance = 100 },
        }
    },
    ["Shiftry"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "tropical leaf" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "astral source" },
            { name = "forbidden fruit" },
            { name = "grey-blue powder" },
            { name = "exotic feather" },
            { name = "sharp razor" },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "dread plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "shiftry doll", countmax = 1, chance = 100 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held black glasses", countmax = 1, chance = 10 },
            { name = "Leaf Stone", countmax = 1, chance = 20 },
        }
    },
    ["Taillow"] = {
        profit = 8,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 1 },
            { name = "sky plate", countmax = 1, chance = 1 },
            { name = "taillow doll", countmax = 1, chance = 100 },
            { name = "TM Steel Wing", countmax = 1, chance = 1 },
        }
    },
    ["Swellow"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "light feather" },
            { name = "royal feather" },
            { name = "acorn" },
            { name = "exotic feather" },
            { name = "dark feather" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "swellow doll", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Wingull"] = {
        profit = 8,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "water gem" },
            { name = "water pendant" },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "sky plate", countmax = 1, chance = 1 },
            { name = "wingull doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Pelipper"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "light feather" },
            { name = "royal feather" },
            { name = "acorn" },
            { name = "water gem" },
            { name = "water pendant" },
            { name = "blue sphere" },
            { name = "exotic feather" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "pelipper doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
        }
    },
    ["Ralts"] = {
        profit = 8,
        loots = {
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "mind plate", countmax = 1, chance = 1 },
            { name = "pixie plate", countmax = 1, chance = 1 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "ralts doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 1 },
            { name = "TM Psychic", countmax = 1, chance = 1 },
            { name = "TM Dream Eater", countmax = 1, chance = 1 },
        }
    },
    ["Kirlia"] = {
        profit = 35,
        loots = {
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "linearly guided hypnose pendant" },
            { name = "cutting fang" },
            { name = "mind plate", countmax = 1, chance = 25 },
            { name = "pixie plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "kirlia doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 5 },
            { name = "TM Psychic", countmax = 1, chance = 5 },
            { name = "TM Dream Eater", countmax = 1, chance = 5 },
        }
    },
    ["Gardevoir"] = {
        profit = 60,
        loots = {
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "linearly guided hypnose pendant" },
            { name = "cutting fang" },
            { name = "luminous orb" },
            { name = "black diamond" },
            { name = "astral glyph" },
            { name = "grey-blue powder" },
            { name = "plasmatic lightning" },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "pixie plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "gardevoir doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Dream Eater", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
            { name = "held pink bow", countmax = 1, chance = 10 },
        }
    },
    ["Surskit"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "water pendant" },
            { name = "pot of water" },
            { name = "pot of moss mug" },
            { name = "sample of sand wasp honey" },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "insect plate", countmax = 1, chance = 1 },
            { name = "surskit doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
        }
    },
    ["Masquerain"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "insect antenna" },
            { name = "bamboo leaves" },
            { name = "sample of sand wasp honey" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "light feather" },
            { name = "royal feather" },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "masquerain doll", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Shroomish"] = {
        profit = 8,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "meadow plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "shroomish doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
            { name = "TM Giga Drain", countmax = 1, chance = 1 },
        }
    },
    ["Breloom"] = {
        profit = 35,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "box gloves" },
            { name = "bandage" },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "fist plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "breloom doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 5 },
            { name = "TM Dynamic Punch", countmax = 1, chance = 5 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held black belt", countmax = 1, chance = 10 },
        }
    },
    ["Slakoth"] = {
        profit = 8,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "thorn seed" },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "slakoth doll", countmax = 1, chance = 100 },
        }
    },
    ["Vigoroth"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "forbidden fruit" },
            { name = "bright hair" },
            { name = "thorn seed" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "vigoroth doll", countmax = 1, chance = 100 },
        }
    },
    ["Slaking"] = {
        profit = 60,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "fur" },
            { name = "ape hair" },
            { name = "forbidden fruit" },
            { name = "bright hair" },
            { name = "thorn seed" },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "slaking doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
        }
    },
    ["Nincada"] = {
        profit = 8,
        loots = {
            { name = "pot of moss mug" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "stone orb" },
            { name = "rare sandbag" },
            { name = "beetle carapace" },
            { name = "nincada doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 1 },
            { name = "earth plate", countmax = 1, chance = 1 },
            { name = "TM Mud-Slap", countmax = 1, chance = 1 },
        }
    },
    ["Ninjask"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "insect antenna" },
            { name = "bamboo leaves" },
            { name = "sample of sand wasp honey" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "sky plate", countmax = 1, chance = 25 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "ninjask doll", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
            { name = "TM Fury Cutter", countmax = 1, chance = 10 },
        }
    },
    ["Shedinja"] = {
        profit = 35,
        loots = {
            { name = "pot of moss mug" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "reaper cloth" },
            { name = "essence of a bad dream" },
            { name = "grey-blue powder" },
            { name = "shedinja doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "spooky plate", countmax = 1, chance = 25 },
            { name = "held silver powder", countmax = 1, chance = 10 },
            { name = "held spell tag", countmax = 1, chance = 10 },
            { name = "TM Shadow Ball", countmax = 1, chance = 10 },
        }
    },
    ["Whismur"] = {
        profit = 8,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "whismur doll", countmax = 1, chance = 100 },
        }
    },
    ["Loudred"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "forbidden fruit" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "loudred doll", countmax = 1, chance = 100 },
        }
    },
    ["Exploud"] = {
        profit = 60,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "cutting fang" },
            { name = "forbidden fruit" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 100 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "exploud doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
        }
    },
    ["Makuhita"] = {
        profit = 8,
        loots = {
            { name = "box gloves" },
            { name = "bandage" },
            { name = "fist plate", countmax = 1, chance = 2 },
            { name = "makuhita doll", countmax = 1, chance = 100 },
        }
    },
    ["Hariyama"] = {
        profit = 35,
        loots = {
            { name = "box gloves" },
            { name = "bandage" },
            { name = "fist plate", countmax = 1, chance = 50 },
            { name = "hariyama doll", countmax = 1, chance = 100 },
            { name = "held black belt", countmax = 1, chance = 20 }
        }
    },
    ["Azurill"] = {
        profit = 4,
        loots = {
            { name = "bitten apple" },
            { name = "mouldy cheese" },
            { name = "cookie", countmax = 5, chance = 3000 },
            { name = "cheese", countmax = 5, chance = 3000 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "azurill doll", countmax = 1, chance = 100 },
        }
    },
    ["Nosepass"] = {
        profit = 25,
        loots = {
            { name = "stone orb" },
            { name = "bamboo leaves" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "battle stone" },
            { name = "bone toothpick" },
            { name = "golden gear wheel" },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "nosepass doll", countmax = 1, chance = 100 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
            { name = "TM Zap Cannon", countmax = 1, chance = 5 },
        }
    },
    ["Skitty"] = {
        profit = 8,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "skitty doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 1 },
        }
    },
    ["Delcatty"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "ball of wool" },
            { name = "comb" },
            { name = "coral comb" },
            { name = "spool of yarn" },
            { name = "forbidden fruit" },
            { name = "bright hair" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "delcatty doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 20 },
            { name = "Moon Stone", countmax = 1, chance = 20 },
        }
    },
    ["Sableye"] = {
        profit = 35,
        loots = {
            { name = "shadow orb" },
            { name = "cutting fang" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "luminous orb" },
            { name = "reaper cloth" },
            { name = "essence of a bad dream" },
            { name = "cursed hand" },
            { name = "astral source" },
            { name = "forbidden fruit" },
            { name = "grey-blue powder" },
            { name = "dread plate", countmax = 1, chance = 25 },
            { name = "spooky plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "sableye doll", countmax = 1, chance = 100 },
            { name = "held black glasses", countmax = 1, chance = 10 },
            { name = "held spell tag", countmax = 1, chance = 10 },
            { name = "TM Shadow Ball", countmax = 1, chance = 10 },
        }
    },
    ["Mawile"] = {
        profit = 35,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "metal spike" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "black diamond" },
            { name = "grey-blue powder" },
            { name = "pixie plate", countmax = 1, chance = 25 },
            { name = "iron plate", countmax = 1, chance = 25 },
            { name = "mawile doll", countmax = 1, chance = 100 },
            { name = "held metal coat", countmax = 1, chance = 10 },
            { name = "held pink bow", countmax = 1, chance = 10 },
        }
    },
    ["Aron"] = {
        profit = 8,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "metal spike" },
            { name = "hard claws" },
            { name = "stone plate", countmax = 1, chance = 2 },
            { name = "iron plate", countmax = 1, chance = 2 },
            { name = "aron doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 1 },
            { name = "TM Rock Slide", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
            { name = "TM Iron Tail", countmax = 1, chance = 1 },
            { name = "TM Mud-Slap", countmax = 1, chance = 1 },
        }
    },
    ["Lairon"] = {
        profit = 35,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "metal spike" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "rare sandbag" },
            { name = "bone toothpick" },
            { name = "golden gear wheel" },
            { name = "hard claws" },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "iron plate", countmax = 1, chance = 25 },
            { name = "lairon doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
            { name = "TM Iron Tail", countmax = 1, chance = 5 },
            { name = "TM Mud-Slap", countmax = 1, chance = 5 },
        }
    },
    ["Aggron"] = {
        profit = 60,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "metal spike" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "bone toothpick" },
            { name = "golden gear wheel" },
            { name = "hard claws" },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "iron plate", countmax = 1, chance = 50 },
            { name = "aggron doll", countmax = 1, chance = 100 },
            { name = "held metal coat", countmax = 1, chance = 10 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "TM Iron Tail", countmax = 1, chance = 10 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
        }
    },
    ["Meditite"] = {
        profit = 8,
        loots = {
            { name = "box gloves" },
            { name = "bandage" },
            { name = "twisted spoon" },
            { name = "night orb" },
            { name = "fist plate", countmax = 1, chance = 2 },
            { name = "mind plate", countmax = 1, chance = 2 },
            { name = "meditite doll", countmax = 1, chance = 100 },
        }
    },
    ["Medicham"] = {
        profit = 35,
        loots = {
            { name = "box gloves" },
            { name = "bandage" },
            { name = "twisted spoon" },
            { name = "night orb" },
            { name = "astral glyph" },
            { name = "forbidden fruit" },
            { name = "grey-blue powder" },
            { name = "plasmatic lightning" },
            { name = "fist plate", countmax = 1, chance = 25 },
            { name = "mind plate", countmax = 1, chance = 25 },
            { name = "medicham doll", countmax = 1, chance = 100 },
            { name = "held black belt", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
            { name = "TM Ice Punch", countmax = 1, chance = 10 },
            { name = "TM Thunder Punch", countmax = 1, chance = 10 },
            { name = "TM Fire Punch", countmax = 1, chance = 10 },
        }
    },
    ["Electrike"] = {
        profit = 8,
        loots = {
            { name = "electrizer" },
            { name = "metal spike" },
            { name = "gear wheel" },
            { name = "hard nail" },
            { name = "golden gear wheel" },
            { name = "frozen lightning" },
            { name = "zap plate", countmax = 1, chance = 2 },
            { name = "electrike doll", countmax = 1, chance = 100 },
            { name = "TM Thunder Wave", countmax = 1, chance = 1 },
        }
    },
    ["Manectric"] = {
        profit = 35,
        loots = {
            { name = "electrizer" },
            { name = "metal spike" },
            { name = "gear wheel" },
            { name = "hard nail" },
            { name = "piece of royal steel" },
            { name = "magnet" },
            { name = "golden gear wheel" },
            { name = "frozen lightning" },
            { name = "zap plate", countmax = 1, chance = 50 },
            { name = "manectric doll", countmax = 1, chance = 100 },
            { name = "held magnet", countmax = 1, chance = 20 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
        }
    },
    ["Plusle"] = {
        profit = 25,
        loots = {
            { name = "electrizer" },
            { name = "metal spike" },
            { name = "gear wheel" },
            { name = "hard nail" },
            { name = "piece of royal steel" },
            { name = "magnet" },
            { name = "frozen lightning" },
            { name = "zap plate", countmax = 1, chance = 25 },
            { name = "plusle doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 5 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
            { name = "held magnet", countmax = 1, chance = 10 },
        }
    },
    ["Minun"] = {
        profit = 25,
        loots = {
            { name = "electrizer" },
            { name = "metal spike" },
            { name = "gear wheel" },
            { name = "hard nail" },
            { name = "piece of royal steel" },
            { name = "magnet" },
            { name = "frozen lightning" },
            { name = "zap plate", countmax = 1, chance = 25 },
            { name = "minun doll", countmax = 1, chance = 100 },
            { name = "TM Swift", countmax = 1, chance = 5 },
            { name = "TM Thunder Wave", countmax = 1, chance = 5 },
            { name = "held magnet", countmax = 1, chance = 10 },
        }
    },
    ["Volbeat"] = {
        profit = 25,
        loots = {
            { name = "pot of moss mug" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "volbeat doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Illumise"] = {
        profit = 25,
        loots = {
            { name = "pot of moss mug" },
            { name = "big mushroom" },
            { name = "acorn" },
            { name = "illumise doll", countmax = 1, chance = 100 },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Roselia"] = {
        profit = 35,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "forbidden fruit" },
            { name = "lion's mane flower" },
            { name = "sharp razor" },
            { name = "thorn seed" },
            { name = "meadow plate", countmax = 1, chance = 25 },
            { name = "toxic plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "roselia doll", countmax = 1, chance = 100 },
            { name = "TM Mega Drain", countmax = 1, chance = 5 },
            { name = "TM Giga Drain", countmax = 1, chance = 5 },
            { name = "held miracle seed", countmax = 1, chance = 20 },
            { name = "held poison barb", countmax = 1, chance = 20 },
        }
    },
    ["Gulpin"] = {
        profit = 8,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "petrified goo" },
            { name = "toxic plate", countmax = 1, chance = 2 },
            { name = "gulpin doll", countmax = 1, chance = 100 },
            { name = "TM Sludge Bomb", countmax = 1, chance = 1 },
        }
    },
    ["Swalot"] = {
        profit = 35,
        loots = {
            { name = "bottle of poison" },
            { name = "venon pendant" },
            { name = "black sludge" },
            { name = "shadow rock" },
            { name = "petrified goo" },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "swalot doll", countmax = 1, chance = 100 },
            { name = "held poison barb", countmax = 1, chance = 20 },
            { name = "TM Sludge Bomb", countmax = 1, chance = 10 },
        }
    },
    ["Carvanha"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "dread plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "carvanha doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 1 },
        }
    },
    ["Sharpedo"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "astral source" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "dread plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "sharpedo doll", countmax = 1, chance = 100 },
            { name = "TM Rage", countmax = 1, chance = 5 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held black glasses", countmax = 1, chance = 10 },
        }
    },
    ["Wailmer"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "wailmer doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Wailord"] = {
        profit = 60,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "wailord doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "held mystic water", countmax = 1, chance = 20 },
        }
    },
    ["Numel"] = {
        profit = 8,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "stone orb" },
            { name = "rare sandbag" },
            { name = "flame plate", countmax = 1, chance = 2 },
            { name = "earth plate", countmax = 1, chance = 2 },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "numel doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 1 },
            { name = "TM Curse", countmax = 1, chance = 1 },
        }
    },
    ["Camerupt"] = {
        profit = 35,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "burning heart" },
            { name = "eternal flames" },
            { name = "fire pendant" },
            { name = "fire orb" },
            { name = "stone orb" },
            { name = "rare sandbag" },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "camerupt doll", countmax = 1, chance = 100 },
            { name = "held charcoal", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
            { name = "TM Fissure", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "TM Curse", countmax = 1, chance = 10 },
        }
    },
    ["Torkoal"] = {
        profit = 35,
        loots = {
            { name = "pot of lava" },
            { name = "fire element" },
            { name = "flame orb" },
            { name = "magmarizer" },
            { name = "burning heart" },
            { name = "eternal flames" },
            { name = "fire pendant" },
            { name = "fire orb" },
            { name = "blazing bone" },
            { name = "coal" },
            { name = "pot of flames" },
            { name = "flame plate", countmax = 1, chance = 50 },
            { name = "lava cookie", countmax = 5, chance = 5000 },
            { name = "torkoal doll", countmax = 1, chance = 100 },
            { name = "held charcoal", countmax = 1, chance = 10 },
            { name = "TM Curse", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
        }
    },
    ["Spoink"] = {
        profit = 8,
        loots = {
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "mind plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "spoink doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 1 },
            { name = "TM Psywave", countmax = 1, chance = 1 },
            { name = "TM Snore", countmax = 1, chance = 1 },
        }
    },
    ["Grumpig"] = {
        profit = 35,
        loots = {
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "linearly guided hypnose pendant" },
            { name = "cutting fang" },
            { name = "luminous orb" },
            { name = "astral glyph" },
            { name = "plasmatic lightning" },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "grumpig doll", countmax = 1, chance = 100 },
            { name = "held twisted spoon", countmax = 1, chance = 20 },
            { name = "TM Psychic", countmax = 1, chance = 5 },
            { name = "TM Psywave", countmax = 1, chance = 5 },
            { name = "TM Snore", countmax = 1, chance = 5 },
        }
    },
    ["Spinda"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "love plate", countmax = 1, chance = 25 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "spinda doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Trapinch"] = {
        profit = 8,
        loots = {
            { name = "sandbag" },
            { name = "cutting fang" },
            { name = "horn" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "earth plate", countmax = 1, chance = 2 },
            { name = "trapinch doll", countmax = 1, chance = 100 },
            { name = "TM Fissure", countmax = 1, chance = 1 },
            { name = "TM Rock Slide", countmax = 1, chance = 1 },
            { name = "TM Mud-Slap", countmax = 1, chance = 1 },
        }
    },
    ["Vibrava"] = {
        profit = 35,
        loots = {
            { name = "horn" },
            { name = "cutting fang" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "draco plate", countmax = 1, chance = 25 },
            { name = "vibrava doll", countmax = 1, chance = 100 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
            { name = "TM Mud-Slap", countmax = 1, chance = 5 },
        }
    },
    ["Flygon"] = {
        profit = 60,
        loots = {
            { name = "horn" },
            { name = "cutting fang" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "exotic feather" },
            { name = "sharp razor" },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "draco plate", countmax = 1, chance = 50 },
            { name = "flygon doll", countmax = 1, chance = 100 },
            { name = "held soft sand", countmax = 1, chance = 10 },
            { name = "held dragon fang", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
        }
    },
    ["Cacnea"] = {
        profit = 8,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "thorn seed" },
            { name = "meadow plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "cacnea doll", countmax = 1, chance = 100 },
        }
    },
    ["Cacturne"] = {
        profit = 35,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "tropical leaf" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "astral source" },
            { name = "forbidden fruit" },
            { name = "lion's mane flower" },
            { name = "sharp razor" },
            { name = "thorn seed" },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "dread plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "cacturne doll", countmax = 1, chance = 100 },
            { name = "held miracle seed", countmax = 1, chance = 20 },
            { name = "held black glasses", countmax = 1, chance = 20 },
        }
    },
    ["Swablu"] = {
        profit = 8,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "love plate", countmax = 1, chance = 2 },
            { name = "sky plate", countmax = 1, chance = 2 },
            { name = "swablu doll", countmax = 1, chance = 100 },
            { name = "TM Steel Wing", countmax = 1, chance = 1 },
        }
    },
    ["Altaria"] = {
        profit = 35,
        loots = {
            { name = "feather" },
            { name = "bunch of sugar cane" },
            { name = "bunch of wheat" },
            { name = "colourful feather" },
            { name = "downy feather" },
            { name = "light feather" },
            { name = "royal feather" },
            { name = "acorn" },
            { name = "exotic feather" },
            { name = "draco plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "altaria doll", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "held dragon fang", countmax = 1, chance = 10 },
            { name = "TM Sky Attack", countmax = 1, chance = 10 },
        }
    },
    ["Zangoose"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "forbidden fruit" },
            { name = "hard claws" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "zangoose doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
            { name = "TM Fury Cutter", countmax = 1, chance = 10 },
        }
    },
    ["Seviper"] = {
        profit = 35,
        loots = {
            { name = "bottle of poison" },
            { name = "tooth" },
            { name = "venon pendant" },
            { name = "cutting fang" },
            { name = "insect skin", countmax = 1, chance = 8333 },
            { name = "toxic plate", countmax = 1, chance = 50 },
            { name = "seviper doll", countmax = 1, chance = 100 },
            { name = "held poison barb", countmax = 1, chance = 10 },
        }
    },
    ["Lunatone"] = {
        profit = 35,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "night orb" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "twisted spoon" },
            { name = "night orb" },
            { name = "astral glyph" },
            { name = "grey-blue powder" },
            { name = "plasmatic lightning" },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "mind plate", countmax = 1, chance = 25 },
            { name = "lunatone doll", countmax = 1, chance = 100 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 5 },
            { name = "TM Psywave", countmax = 1, chance = 5 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
        }
    },
    ["Solrock"] = {
        profit = 35,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "night orb" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "twisted spoon" },
            { name = "night orb" },
            { name = "astral glyph" },
            { name = "grey-blue powder" },
            { name = "plasmatic lightning" },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "mind plate", countmax = 1, chance = 25 },
            { name = "solrock doll", countmax = 1, chance = 100 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
            { name = "TM Solar Beam", countmax = 1, chance = 5 },
            { name = "TM Psychic", countmax = 1, chance = 5 },
            { name = "TM Psywave", countmax = 1, chance = 5 },
            { name = "TM Rock Slide", countmax = 1, chance = 5 },
        }
    },
    ["Barboach"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "earth plate", countmax = 1, chance = 1 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "barboach doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Fissure", countmax = 1, chance = 1 },
            { name = "TM Snore", countmax = 1, chance = 1 },
            { name = "TM Mud-Slap", countmax = 1, chance = 1 },
        }
    },
    ["Whiscash"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "earth plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "whiscash doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Fissure", countmax = 1, chance = 5 },
            { name = "TM Snore", countmax = 1, chance = 5 },
            { name = "TM Mud-Slap", countmax = 1, chance = 5 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held soft sand", countmax = 1, chance = 10 },
        }
    },
    ["Corphish"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "corphish doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
        }
    },
    ["Crawdaunt"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "astral source" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "dread plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "crawdaunt doll", countmax = 1, chance = 100 },
            { name = "TM Bubblebeam", countmax = 1, chance = 10 },
            { name = "TM Swift", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
            { name = "held black glasses", countmax = 1, chance = 10 },
        }
    },
    ["Baltoy"] = {
        profit = 8,
        loots = {
            { name = "horn" },
            { name = "cutting fang" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "earth plate", countmax = 1, chance = 1 },
            { name = "mind plate", countmax = 1, chance = 1 },
            { name = "baltoy doll", countmax = 1, chance = 100 },
            { name = "TM Mud-Slap", countmax = 1, chance = 1 },
        }
    },
    ["Claydol"] = {
        profit = 35,
        loots = {
            { name = "horn" },
            { name = "cutting fang" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "sandbag" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "astral glyph" },
            { name = "grey-blue powder" },
            { name = "plasmatic lightning" },
            { name = "earth plate", countmax = 1, chance = 50 },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "claydol doll", countmax = 1, chance = 100 },
            { name = "held soft sand", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
            { name = "TM Mud-Slap", countmax = 1, chance = 10 },
        }
    },
    ["Lileep"] = {
        profit = 8,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "night orb" },
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "thorn seed" },
            { name = "stone plate", countmax = 1, chance = 1 },
            { name = "meadow plate", countmax = 1, chance = 1 },
            { name = "lileep doll", countmax = 1, chance = 100 },
            { name = "TM Giga Drain", countmax = 1, chance = 1 },
        }
    },
    ["Cradily"] = {
        profit = 35,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "night orb" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "leaf" },
            { name = "seed" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "lion's mane flower" },
            { name = "sharp razor" },
            { name = "thorn seed" },
            { name = "stone plate", countmax = 1, chance = 50 },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "cradily doll", countmax = 1, chance = 100 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "TM Giga Drain", countmax = 1, chance = 10 },
        }
    },
    ["Anorith"] = {
        profit = 8,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "night orb" },
            { name = "rare sandbag" },
            { name = "pot of moss mug" },
            { name = "sample of sand wasp honey" },
            { name = "hard claws" },
            { name = "stone plate", countmax = 1, chance = 1 },
            { name = "insect plate", countmax = 1, chance = 1 },
            { name = "anorith doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
            { name = "TM Fury Cutter", countmax = 1, chance = 1 },
        }
    },
    ["Armaldo"] = {
        profit = 35,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "shadow rock" },
            { name = "night orb" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "pot of moss mug" },
            { name = "sample of sand wasp honey" },
            { name = "hard claws" },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "insect plate", countmax = 1, chance = 25 },
            { name = "armaldo doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
            { name = "TM Fury Cutter", countmax = 1, chance = 5 },
            { name = "held hard stone", countmax = 1, chance = 10 },
            { name = "held silver powder", countmax = 1, chance = 10 },
        }
    },
    ["Feebas"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "feebas doll", countmax = 1, chance = 100 },
        }
    },
    ["Milotic"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "milotic doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Rain Dance", countmax = 1, chance = 5 },
            { name = "held mystic water", countmax = 1, chance = 20 },
            { name = "Prism Scale", countmax = 1, chance = 20 },
        }
    },
    ["Castform"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "castform doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Fire Blast", countmax = 1, chance = 5 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
            { name = "TM Rain Dance", countmax = 1, chance = 5 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Kecleon"] = {
        profit = 35,
        loots = {
            { name = "bitten apple" },
            { name = "bamboo leaves" },
            { name = "bunch of wheat" },
            { name = "acorn" },
            { name = "bamboo stick" },
            { name = "love plate", countmax = 1, chance = 50 },
            { name = "cookie", countmax = 5, chance = 5000 },
            { name = "red apple", countmax = 5, chance = 5000 },
            { name = "kecleon doll", countmax = 1, chance = 100 },
            { name = "held silk scarf", countmax = 1, chance = 10 },
        }
    },
    ["Shuppet"] = {
        profit = 8,
        loots = {
            { name = "shadow orb" },
            { name = "reaper cloth" },
            { name = "cursed hand" },
            { name = "energy soil" },
            { name = "essence of a bad dream" },
            { name = "petrified scream" },
            { name = "spooky plate", countmax = 1, chance = 2 },
            { name = "shuppet doll", countmax = 1, chance = 100 },
            { name = "TM Curse", countmax = 1, chance = 1 },
            { name = "TM Shadow Ball", countmax = 1, chance = 1 },
        }
    },
    ["Banette"] = {
        profit = 35,
        loots = {
            { name = "shadow orb" },
            { name = "reaper cloth" },
            { name = "cursed hand" },
            { name = "energy soil" },
            { name = "essence of a bad dream" },
            { name = "petrified scream" },
            { name = "black orb" },
            { name = "luminous orb" },
            { name = "astral source" },
            { name = "grey-blue powder" },
            { name = "spooky plate", countmax = 1, chance = 50 },
            { name = "banette doll", countmax = 1, chance = 100 },
            { name = "held spell tag", countmax = 1, chance = 20 },
            { name = "TM Curse", countmax = 1, chance = 5 },
            { name = "TM Shadow Ball", countmax = 1, chance = 5 },
        }
    },
    ["Duskull"] = {
        profit = 8,
        loots = {
            { name = "shadow orb" },
            { name = "reaper cloth" },
            { name = "spooky plate", countmax = 1, chance = 2 },
            { name = "duskull doll", countmax = 1, chance = 100 },
            { name = "TM Curse", countmax = 1, chance = 1 },
            { name = "TM Shadow Ball", countmax = 1, chance = 1 },
        }
    },
    ["Dusclops"] = {
        profit = 35,
        loots = {
            { name = "shadow orb" },
            { name = "reaper cloth" },
            { name = "cursed hand" },
            { name = "energy soil" },
            { name = "essence of a bad dream" },
            { name = "petrified scream" },
            { name = "black orb" },
            { name = "luminous orb" },
            { name = "astral source" },
            { name = "grey-blue powder" },
            { name = "spooky plate", countmax = 1, chance = 50 },
            { name = "dusclops doll", countmax = 1, chance = 100 },
            { name = "held spell tag", countmax = 1, chance = 20 },
            { name = "TM Curse", countmax = 1, chance = 5 },
            { name = "TM Shadow Ball", countmax = 1, chance = 5 },
            { name = "TM Ice Punch", countmax = 1, chance = 5 },
            { name = "TM Thunder Punch", countmax = 1, chance = 5 },
            { name = "TM Fire Punch", countmax = 1, chance = 5 },
        }
    },
    ["Tropius"] = {
        profit = 60,
        loots = {
            { name = "leaf" },
            { name = "seed" },
            { name = "gracidea" },
            { name = "revival herb" },
            { name = "bamboo leaves" },
            { name = "bunch of ripe rice" },
            { name = "frostbite herb" },
            { name = "leaf pendant" },
            { name = "cure herb" },
            { name = "forbidden fruit" },
            { name = "lion's mane flower" },
            { name = "sharp razor" },
            { name = "thorn seed" },
            { name = "hard claws" },
            { name = "meadow plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "tropius doll", countmax = 1, chance = 100 },
            { name = "held miracle seed", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
            { name = "TM Solar Beam", countmax = 1, chance = 10 },
        }
    },
    ["Chimecho"] = {
        profit = 60,
        loots = {
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "linearly guided hypnose pendant" },
            { name = "cutting fang" },
            { name = "luminous orb" },
            { name = "plasmatic lightning" },
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "chimecho doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
            { name = "TM Psywave", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 20 },
        }
    },
    ["Absol"] = {
        profit = 60,
        loots = {
            { name = "shadow orb" },
            { name = "cutting fang" },
            { name = "night orb" },
            { name = "black orb" },
            { name = "dark claws" },
            { name = "dark crystal" },
            { name = "luminous orb" },
            { name = "astral source" },
            { name = "forbidden fruit" },
            { name = "grey-blue powder" },
            { name = "dark feather" },
            { name = "hard claws" },
            { name = "dread plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "absol doll", countmax = 1, chance = 100 },
            { name = "held black glasses", countmax = 1, chance = 20 },
        }
    },
    ["Wynaut"] = {
        profit = 4,
        loots = {
            { name = "twisted spoon" },
            { name = "mind plate", countmax = 1, chance = 1 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "wynaut doll", countmax = 1, chance = 100 },
        }
    },
    ["Snorunt"] = {
        profit = 8,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "icicle" },
            { name = "galatic scale" },
            { name = "icicle plate", countmax = 1, chance = 2 },
            { name = "snorunt doll", countmax = 1, chance = 100 },
            { name = "TM Ice Beam", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
            { name = "TM Icy Wind", countmax = 1, chance = 1 },
            { name = "TM Protect", countmax = 1, chance = 1 },
        }
    },
    ["Glalie"] = {
        profit = 35,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "icicle" },
            { name = "giant ice cube" },
            { name = "frozen tear" },
            { name = "galatic scale" },
            { name = "icicle plate", countmax = 1, chance = 50 },
            { name = "glalie doll", countmax = 1, chance = 100 },
            { name = "TM Ice Beam", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Icy Wind", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "held never melt ice", countmax = 1, chance = 20 },
        }
    },
    ["Spheal"] = {
        profit = 8,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "icicle" },
            { name = "icicle plate", countmax = 1, chance = 1 },
            { name = "splash plate", countmax = 1, chance = 1 },
            { name = "spheal doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
            { name = "TM Snore", countmax = 1, chance = 1 },
            { name = "TM Defense Curl", countmax = 1, chance = 1 },
        }
    },
    ["Sealeo"] = {
        profit = 35,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "icicle" },
            { name = "giant ice cube" },
            { name = "icicle plate", countmax = 1, chance = 25 },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "sealeo doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Snore", countmax = 1, chance = 5 },
            { name = "TM Defense Curl", countmax = 1, chance = 5 },
        }
    },
    ["Walrein"] = {
        profit = 60,
        loots = {
            { name = "ice cub" },
            { name = "flawless ice crystal" },
            { name = "icicle" },
            { name = "giant ice cube" },
            { name = "frozen tear" },
            { name = "galatic scale" },
            { name = "icicle plate", countmax = 1, chance = 50 },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "walrein doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 10 },
            { name = "TM Snore", countmax = 1, chance = 10 },
            { name = "TM Defense Curl", countmax = 1, chance = 10 },
            { name = "held never melt ice", countmax = 1, chance = 10 },
            { name = "held mystic water", countmax = 1, chance = 10 },
        }
    },
    ["Clamperl"] = {
        profit = 8,
        loots = {
            { name = "water gem" },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "clamperl doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 1 },
        }
    },
    ["Huntail"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "huntail doll", countmax = 1, chance = 100 },
            { name = "held mystic water", countmax = 1, chance = 20 },
            { name = "Deepseatooth", countmax = 1, chance = 20 },
        }
    },
    ["Gorebyss"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "blue sphere" },
            { name = "splash plate", countmax = 1, chance = 50 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "gorebyss doll", countmax = 1, chance = 100 },
            { name = "held mystic water", countmax = 1, chance = 20 },
            { name = "Deepseascale", countmax = 1, chance = 20 },
            { name = "TM Psychic", countmax = 1, chance = 5 },
        }
    },
    ["Relicanth"] = {
        profit = 35,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "stone orb" },
            { name = "heavy stone" },
            { name = "splash plate", countmax = 1, chance = 25 },
            { name = "stone plate", countmax = 1, chance = 25 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "relicanth doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "held mystic water", countmax = 1, chance = 20 },
            { name = "held hard stone", countmax = 1, chance = 20 },
        }
    },
    ["Luvdisc"] = {
        profit = 8,
        loots = {
            { name = "razor fang" },
            { name = "water gem" },
            { name = "cutting fang" },
            { name = "pot of water" },
            { name = "splash plate", countmax = 1, chance = 2 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "luvdisc doll", countmax = 1, chance = 100 },
            { name = "TM Water Gun", countmax = 1, chance = 5 },
        }
    },
    ["Bagon"] = {
        profit = 8,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "bagon doll", countmax = 1, chance = 100 },
            { name = "draco plate", countmax = 1, chance = 2 },
            { name = "TM Rage", countmax = 1, chance = 1 },
            { name = "TM Double-Edge", countmax = 1, chance = 1 },
            { name = "TM Headbutt", countmax = 1, chance = 1 },
        }
    },
    ["Shelgon"] = {
        profit = 35,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "shadow rock" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "shelgon doll", countmax = 1, chance = 100 },
            { name = "draco plate", countmax = 1, chance = 25 },
            { name = "TM Rage", countmax = 1, chance = 5 },
            { name = "TM Double-Edge", countmax = 1, chance = 5 },
            { name = "TM Headbutt", countmax = 1, chance = 5 },
            { name = "TM Protect", countmax = 1, chance = 5 },
        }
    },
    ["Salamence"] = {
        profit = 60,
        loots = {
            { name = "sandbag" },
            { name = "stone orb" },
            { name = "shadow rock" },
            { name = "rare sandbag" },
            { name = "battle stone" },
            { name = "clay lump" },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "salamence doll", countmax = 1, chance = 100 },
            { name = "draco plate", countmax = 1, chance = 50 },
            { name = "sky plate", countmax = 1, chance = 50 },
            { name = "TM Rage", countmax = 1, chance = 10 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Headbutt", countmax = 1, chance = 10 },
            { name = "TM Protect", countmax = 1, chance = 10 },
            { name = "held dragon fang", countmax = 1, chance = 10 },
            { name = "held sharp beak", countmax = 1, chance = 10 },
        }
    },
    ["Beldum"] = {
        profit = 8,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "metal spike" },
            { name = "prismatic quartz" },
            { name = "mind plate", countmax = 1, chance = 1 },
            { name = "iron plate", countmax = 1, chance = 1 },
            { name = "beldum doll", countmax = 1, chance = 100 },
        }
    },
    ["Metang"] = {
        profit = 35,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "metal spike" },
            { name = "huge chunk of crude iron" },
            { name = "golden gear wheel" },
            { name = "prismatic quartz" },
            { name = "spark sphere" },
            { name = "mind plate", countmax = 1, chance = 25 },
            { name = "iron plate", countmax = 1, chance = 25 },
            { name = "metang doll", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 5 },
        }
    },
    ["Metagross"] = {
        profit = 60,
        loots = {
            { name = "stone orb" },
            { name = "magnet" },
            { name = "metal spike" },
            { name = "huge chunk of crude iron" },
            { name = "piece of royal steel" },
            { name = "rare sandbag" },
            { name = "clay lump" },
            { name = "twisted spoon" },
            { name = "shadow orb" },
            { name = "golden gear wheel" },
            { name = "linearly guided hypnose pendant" },
            { name = "prismatic quartz" },
            { name = "spark sphere" },
            { name = "mind plate", countmax = 1, chance = 50 },
            { name = "iron plate", countmax = 1, chance = 50 },
            { name = "metagross doll", countmax = 1, chance = 100 },
            { name = "held metal coat", countmax = 1, chance = 10 },
            { name = "held twisted spoon", countmax = 1, chance = 10 },
            { name = "TM Psychic", countmax = 1, chance = 10 },
        }
    },
    ["Regirock"] = {
        profit = 100,
        loots = {
            { name = "stone plate", countmax = 1, chance = 100 },
            { name = "regirock doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 10 },
            { name = "TM Rock Slide", countmax = 1, chance = 10 },
            { name = "TM Curse", countmax = 1, chance = 100 },
            { name = "TM Zap Cannon", countmax = 1, chance = 100 },
            { name = "held hard stone", countmax = 1, chance = 100 },
        }
    },
    ["Regice"] = {
        profit = 100,
        loots = {
            { name = "icicle plate", countmax = 1, chance = 100 },
            { name = "regice doll", countmax = 1, chance = 100 },
            { name = "TM Ice Beam", countmax = 1, chance = 100 },
            { name = "TM Curse", countmax = 1, chance = 100 },
            { name = "TM Zap Cannon", countmax = 1, chance = 100 },
            { name = "TM Icy Wind", countmax = 1, chance = 100 },
            { name = "held never melt ice", countmax = 1, chance = 100 },
        }
    },
    ["Registeel"] = {
        profit = 100,
        loots = {
            { name = "iron plate", countmax = 1, chance = 100 },
            { name = "registeel doll", countmax = 1, chance = 100 },
            { name = "held metal coat", countmax = 1, chance = 100 },
            { name = "TM Curse", countmax = 1, chance = 100 },
            { name = "TM Zap Cannon", countmax = 1, chance = 100 },
        }
    },
    ["Latias"] = {
        profit = 100,
        loots = {
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "latias doll", countmax = 1, chance = 100 },
            { name = "draco plate", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "held dragon fang", countmax = 1, chance = 100 },
            { name = "held twisted spoon", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 100 },
            { name = "TM Psywave", countmax = 1, chance = 100 },
        }
    },
    ["Latios"] = {
        profit = 100,
        loots = {
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "latios doll", countmax = 1, chance = 100 },
            { name = "draco plate", countmax = 1, chance = 100 },
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "held dragon fang", countmax = 1, chance = 100 },
            { name = "held twisted spoon", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 100 },
            { name = "TM Psywave", countmax = 1, chance = 100 },
            { name = "TM Protect", countmax = 1, chance = 100 },
        }
    },
    ["Kyogre"] = {
        profit = 100,
        loots = {
            { name = "splash plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "kyogre doll", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 100 },
            { name = "TM Ice Beam", countmax = 1, chance = 100 },
            { name = "held mystic water", countmax = 1, chance = 100 },
        }
    },
    ["Groudon"] = {
        profit = 100,
        loots = {
            { name = "earth plate", countmax = 1, chance = 100 },
            { name = "groudon doll", countmax = 1, chance = 100 },
            { name = "held soft sand", countmax = 1, chance = 100 },
            { name = "TM Solar Beam", countmax = 1, chance = 100 },
            { name = "TM Fissure", countmax = 1, chance = 100 },
            { name = "TM Fire Blast", countmax = 1, chance = 100 },
        }
    },
    ["Rayquaza"] = {
        profit = 100,
        loots = {
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "rayquaza doll", countmax = 1, chance = 100 },
            { name = "draco plate", countmax = 1, chance = 100 },
            { name = "sky plate", countmax = 1, chance = 100 },
            { name = "held dragon fang", countmax = 1, chance = 100 },
            { name = "held sharp beak", countmax = 1, chance = 100 },
        }
    },
    ["Jirachi"] = {
        profit = 100,
        loots = {
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "iron plate", countmax = 1, chance = 100 },
            { name = "jirachi doll", countmax = 1, chance = 100 },
            { name = "Metal Coat", countmax = 1, chance = 200 },
            { name = "TM Swift", countmax = 1, chance = 100 },
            { name = "TM Double-Edge", countmax = 1, chance = 100 },
            { name = "held metal coat", countmax = 1, chance = 100 },
            { name = "held twisted spoon", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 100 },
        }
    },
    ["Deoxys"] = {
        profit = 100,
        loots = {
            { name = "mind plate", countmax = 1, chance = 100 },
            { name = "onigiri", countmax = 5, chance = 5000 },
            { name = "deoxys doll", countmax = 1, chance = 100 },
            { name = "Soothe Bell", countmax = 1, chance = 20 },
            { name = "TM Swift", countmax = 1, chance = 100 },
            { name = "TM Psychic", countmax = 1, chance = 100 },
            { name = "TM Zap Cannon", countmax = 1, chance = 100 },
            { name = "held twisted spoon", countmax = 1, chance = 100 },
        }
    },
    --[[["Shiny Bulbasaur"] = {
           profit = 0,
           loots = {
               {name = "leaf", countmax = 2, chance = 10000},
               {name = "bulb", countmax = 1, chance = 5000},
          }
      },
      ["Shiny Ivysaur"] = {
           profit = 0,
           loots = {
               {name = "leaf", countmax = 3, chance = 13000},
               {name = "bulb", countmax = 1, chance = 10000},
               {name = "meadow plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Venusaur"] = {
           profit = 0,
           loots = {
               {name = "leaf", countmax = 3, chance = 15000},
               {name = "bulb", countmax = 1, chance = 13000},
               {name = "meadow plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Charmander"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 10, chance = 10000},
               {name = "pot of lava", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Charmeleon"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 15, chance = 13000},
               {name = "pot of lava", countmax = 1, chance = 10000},
               {name = "flame orb", countmax = 1, chance = 8000},
               {name = "flame plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Charizard"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 15, chance = 15000},
               {name = "pot of lava", countmax = 1, chance = 13000},
               {name = "flame orb", countmax = 1, chance = 13000},
               {name = "lava cookie", countmax = 5, chance = 15000},
               {name = "magmarizer", countmax = 1, chance = 9000},
               {name = "flame plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Squirtle"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 5, chance = 10000},
               {name = "hull", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Wartortle"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 8, chance = 15000},
               {name = "hull", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Blastoise"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 10, chance = 20000},
               {name = "hull", countmax = 1, chance = 15000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Caterpie"] = {
           profit = 0,
           loots = {
               {name = "pot of moss mug", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Metapod"] = {
           profit = 0,
           loots = {
               {name = "pot of moss mug", countmax = 1, chance = 13000},
               {name = "insect plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Butterfree"] = {
           profit = 0,
           loots = {
               {name = "pot of moss mug", countmax = 1, chance = 15000},
               {name = "insect plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Weedle"] = {
           profit = 0,
           loots = {
               {name = "pot of moss mug", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Kakuna"] = {
           profit = 0,
           loots = {
               {name = "pot of moss mug", countmax = 1, chance = 13000},
               {name = "insect plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Beedrill"] = {
           profit = 0,
           loots = {
               {name = "pot of moss mug", countmax = 1, chance = 15000},
               {name = "insect plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Pidgey"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 2, chance = 15000},
          }
      },
      ["Shiny Pidgeotto"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 3, chance = 18000},
               {name = "love plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Pidgeot"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 3, chance = 18000},
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Rattata"] = {
           profit = 0,
           loots = {
               {name = "bitten apple", countmax = 1, chance = 10000},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Raticate"] = {
           profit = 0,
           loots = {
               {name = "bitten apple", countmax = 1, chance = 15000},
               {name = "love plate", countmax = 1, chance = 50},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Spearow"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 3, chance = 18000},
          }
      },
      ["Shiny Fearow"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 3, chance = 18000},
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Ekans"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 5, chance = 15000},
               {name = "tooth", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Arbok"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 10, chance = 15000},
               {name = "tooth", countmax = 2, chance = 10000},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Pikachu"] = {
           profit = 0,
           loots = {
               {name = "electrizer", countmax = 1, chance = 15000},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Raichu"] = {
           profit = 0,
           loots = {
               {name = "electrizer", countmax = 2, chance = 15000},
               {name = "zap plate", countmax = 1, chance = 100},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Sandshrew"] = {
           profit = 0,
           loots = {
               {name = "thorn", countmax = 5, chance = 15000},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Sandslash"] = {
           profit = 0,
           loots = {
               {name = "thorn", countmax = 5, chance = 15000},
               {name = "earth plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Nidorana"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 10000},
               {name = "bottle of poison", countmax = 5, chance = 13000},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Nidorina"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 13000},
               {name = "bottle of poison", countmax = 8, chance = 15000},
               {name = "toxic plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Nidoqueen"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 15000},
               {name = "bottle of poison", countmax = 8, chance = 18000},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Nidorano"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 10000},
               {name = "bottle of poison", countmax = 5, chance = 13000},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Nidorino"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 13000},
               {name = "bottle of poison", countmax = 8, chance = 15000},
               {name = "toxic plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Nidoking"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 15000},
               {name = "bottle of poison", countmax = 8, chance = 18000},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Clefairy"] = {
           profit = 0,
           loots = {
          }
      },
      ["Shiny Clefable"] = {
           profit = 0,
           loots = {
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Vulpix"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 7, chance = 11000},
               {name = "pot of lava", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Ninetales"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 7, chance = 11000},
               {name = "pot of lava", countmax = 1, chance = 10000},
               {name = "flame orb", countmax = 1, chance = 11000},
               {name = "flame plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Jigglypuff"] = {
           profit = 0,
           loots = {
               {name = "microphone", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Wigglytuff"] = {
           profit = 0,
           loots = {
               {name = "microphone", countmax = 1, chance = 10000},
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Zubat"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 5, chance = 15000},
               {name = "tooth", countmax = 1, chance = 13000},
               {name = "bat wing", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Golbat"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 5, chance = 15000},
               {name = "tooth", countmax = 1, chance = 13000},
               {name = "bat wing", countmax = 1, chance = 10000},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Oddish"] = {
           profit = 0,
           loots = {
               {name = "leaf", countmax = 1, chance = 10000},
               {name = "seed", countmax = 8, chance = 11000},
               {name = "gracidea", countmax = 1, chance = 5000},
          }
      },
      ["Shiny Gloom"] = {
           profit = 0,
           loots = {
               {name = "leaf", countmax = 1, chance = 13000},
               {name = "seed", countmax = 13, chance = 15000},
               {name = "gracidea", countmax = 1, chance = 10000},
               {name = "revival herb", countmax = 1, chance = 10000},
               {name = "meadow plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Vileplume"] = {
           profit = 0,
           loots = {
               {name = "leaf", countmax = 2, chance = 13000},
               {name = "seed", countmax = 16, chance = 15000},
               {name = "gracidea", countmax = 1, chance = 13000},
               {name = "revival herb", countmax = 2, chance = 10000},
               {name = "meadow plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Paras"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 5, chance = 13000},
               {name = "mushroom", countmax = 1, chance = 10000},
               {name = "big mushroom", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Parasect"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 1, chance = 10000},
               {name = "mushroom", countmax = 1, chance = 10000},
               {name = "big mushroom", countmax = 3, chance = 8000},
               {name = "meadow plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Venonat"] = {
           profit = 0,
           loots = {
               {name = "insect antenna", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Venomoth"] = {
           profit = 0,
           loots = {
               {name = "insect antenna", countmax = 1, chance = 10000},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Diglett"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Dugtrio"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 8000},
               {name = "earth plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Meowth"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 10000},
               {name = "ball of wool", countmax = 2, chance = 10000},
          }
      },
      ["Shiny Persian"] = {
           profit = 0,
           loots = {
               {name = "razor fang", countmax = 1, chance = 12000},
               {name = "ball of wool", countmax = 2, chance = 12000},
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Psyduck"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "psyduck mug", countmax = 1, chance = 5000},
          }
      },
      ["Shiny Golduck"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "psyduck mug", countmax = 1, chance = 5000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Mankey"] = {
           profit = 0,
           loots = {
               {name = "fur", countmax = 1, chance = 10000},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Primeape"] = {
           profit = 0,
           loots = {
               {name = "fur", countmax = 1, chance = 13000},
               {name = "fist plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Growlithe"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 10, chance = 10000},
               {name = "pot of lava", countmax = 1, chance = 9000},
          }
      },
      ["Shiny Arcanine"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 10, chance = 10000},
               {name = "pot of lava", countmax = 1, chance = 9000},
               {name = "flame orb", countmax = 1, chance = 11000},
               {name = "magmarizer", countmax = 1, chance = 9000},
               {name = "flame plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Poliwag"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 5, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Poliwhirl"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 5, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Poliwrath"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 10, chance = 15000},
               {name = "water pendant", countmax = 1, chance = 13000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Abra"] = {
           profit = 0,
           loots = {
               {name = "twisted spoon", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Kadabra"] = {
           profit = 0,
           loots = {
               {name = "twisted spoon", countmax = 1, chance = 10000},
               {name = "mind plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Alakazam"] = {
           profit = 0,
           loots = {
               {name = "twisted spoon", countmax = 1, chance = 13000},
               {name = "mind plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Machop"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Machoke"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 10000},
               {name = "fist plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Machamp"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 10000},
               {name = "fist plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Bellsprout"] = {
           profit = 0,
           loots = {
               {name = "seed", countmax = 7, chance = 100000},
               {name = "leaf", countmax = 2, chance = 13000},
               {name = "gracidea", countmax = 1, chance = 7000},
          }
      },
      ["Shiny Weepinbell"] = {
           profit = 0,
           loots = {
               {name = "seed", countmax = 10, chance = 100000},
               {name = "leaf", countmax = 2, chance = 13000},
               {name = "gracidea", countmax = 1, chance = 10000},
               {name = "revival herb", countmax = 1, chance = 10000},
               {name = "meadow plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Victreebel"] = {
           profit = 0,
           loots = {
               {name = "seed", countmax = 15, chance = 100000},
               {name = "leaf", countmax = 3, chance = 13000},
               {name = "gracidea", countmax = 1, chance = 13000},
               {name = "revival herb", countmax = 2, chance = 10000},
               {name = "meadow plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Tentacool"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 10, chance = 11000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "ruby", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Tentacruel"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 15, chance = 15000},
               {name = "water pendant", countmax = 1, chance = 13000},
               {name = "ruby", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 100},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Geodude"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 11000},
          }
      },
      ["Shiny Graveler"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 13000},
               {name = "stone plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Golem"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 15000},
               {name = "stone plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Ponyta"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 10, chance = 13000},
               {name = "pot of lava", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Rapidash"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 15, chance = 15000},
               {name = "pot of lava", countmax = 1, chance = 13000},
               {name = "flame orb", countmax = 1, chance = 11000},
               {name = "magmarizer", countmax = 1, chance = 9000},
               {name = "flame plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Slowpoke"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 8, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 11000},
               {name = "slowpoke tail", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Slowbro"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 8, chance = 15000},
               {name = "water pendant", countmax = 1, chance = 13000},
               {name = "slowpoke tail", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Magnemite"] = {
           profit = 0,
           loots = {
               {name = "electrizer", countmax = 1, chance = 10000},
               {name = "screw", countmax = 10, chance = 13000},
               {name = "metal spike", countmax = 1, chance = 13000},
          }
      },
      ["Shiny Magneton"] = {
           profit = 0,
           loots = {
               {name = "screw", countmax = 15, chance = 15000},
               {name = "electrizer", countmax = 1, chance = 13000},
               {name = "metal spike", countmax = 2, chance = 13000},
               {name = "zap plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Farfetchd"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 5, chance = 10000},
          }
      },
      ["Shiny Doduo"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 3, chance = 10000},
          }
      },
      ["Shiny Dodrio"] = {
           profit = 0,
           loots = {
               {name = "feather", countmax = 5, chance = 13000},
               {name = "love plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Seel"] = {
           profit = 0,
           loots = {
               {name = "ice cub", countmax = 1, chance = 13000},
          }
      },
      ["Shiny Dewgong"] = {
           profit = 0,
           loots = {
               {name = "ice cub", countmax = 1, chance = 15000},
               {name = "icicle plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Grimer"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 10, chance = 13000},
               {name = "black sludge", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Muk"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 15, chance = 15000},
               {name = "black sludge", countmax = 1, chance = 13000},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Shellder"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 5, chance = 11000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "shell bell", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Cloyster"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 5, chance = 11000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "shell bell", countmax = 2, chance = 8000},
               {name = "splash plate", countmax = 1, chance = 100},
               {name = "icicle plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Gastly"] = {
           profit = 0,
           loots = {
               {name = "reaper cloth", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Haunter"] = {
           profit = 0,
           loots = {
               {name = "reaper cloth", countmax = 1, chance = 10000},
               {name = "dread plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Gengar"] = {
           profit = 0,
           loots = {
               {name = "reaper cloth", countmax = 1, chance = 13000},
               {name = "dread plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Onix"] = {
           profit = 0,
           loots = {
               {name = "piece of onix", countmax = 1, chance = 10000},
               {name = "stone orb", countmax = 1, chance = 13000},
               {name = "stone plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Drowzee"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 15, chance = 13000},
          }
      },
      ["Shiny Hypno"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 15, chance = 15000},
               {name = "mind plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Krabby"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "crab claw", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Kingler"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "crab claw", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Voltorb"] = {
           profit = 0,
           loots = {
               {name = "electrizer", countmax = 1, chance = 13000},
               {name = "metal spike", countmax = 1, chance = 13000},
          }
      },
      ["Shiny Electrode"] = {
           profit = 0,
           loots = {
               {name = "electrizer", countmax = 1, chance = 13000},
               {name = "metal spike", countmax = 2, chance = 13000},
               {name = "zap plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Exeggcute"] = {
           profit = 0,
           loots = {
               {name = "seed", countmax = 10, chance = 13000},
               {name = "egg", countmax = 1, chance = 8000},
          }
      },
      ["Shiny Exeggutor"] = {
           profit = 0,
           loots = {
               {name = "seed", countmax = 15, chance = 15000},
               {name = "egg", countmax = 1, chance = 10000},
               {name = "meadow plate", countmax = 1, chance = 100},
               {name = "mind plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Cubone"] = {
           profit = 0,
           loots = {
               {name = "thick club", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Marowak"] = {
           profit = 0,
           loots = {
               {name = "thick club", countmax = 1, chance = 13000},
               {name = "earth plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Hitmonlee"] = {
           profit = 0,
           loots = {
               {name = "fist plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Hitmonchan"] = {
           profit = 0,
           loots = {
               {name = "fist plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Lickitung"] = {
           profit = 0,
           loots = {
               {name = "tongue", countmax = 1, chance = 10000},
               {name = "love plate", countmax = 1, chance = 50},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Koffing"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 7, chance = 13000},
          }
      },
      ["Shiny Weezing"] = {
           profit = 0,
           loots = {
               {name = "bottle of poison", countmax = 10, chance = 15000},
               {name = "toxic plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Rhyhorn"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 15000},
               {name = "horn", countmax = 1, chance = 13000},
          }
      },
      ["Shiny Rhydon"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 18000},
               {name = "horn", countmax = 1, chance = 15000},
               {name = "stone plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Chansey"] = {
           profit = 0,
           loots = {
               {name = "egg", countmax = 1, chance = 18000},
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Tangela"] = {
           profit = 0,
           loots = {
               {name = "seed", countmax = 15, chance = 18000},
               {name = "leaf", countmax = 5, chance = 13000},
               {name = "tangela hair", countmax = 1, chance = 10000},
               {name = "meadow plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Kangaskhan"] = {
           profit = 0,
           loots = {
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Horsea"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Seadra"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Goldeen"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "horn", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Seaking"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "horn", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Staryu"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Starmie"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 7, chance = 13000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Mr. Mime"] = {
           profit = 0,
           loots = {
               {name = "mr. mime cloth", countmax = 1, chance = 13000},
               {name = "marsh badge", countmax = 1, chance = 100},
          }
      },
      ["Shiny Scyther"] = {
           profit = 0,
           loots = {
               {name = "scyther razor", countmax = 1, chance = 13000},
               {name = "insect plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Jynx"] = {
           profit = 0,
           loots = {
               {name = "jynx clothes", countmax = 1, chance = 10000},
               {name = "icicle plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Electabuzz"] = {
           profit = 0,
           loots = {
               {name = "electrizer", countmax = 1, chance = 13000},
               {name = "yellow tail", countmax = 1, chance = 10000},
               {name = "zap plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Magmar"] = {
           profit = 0,
           loots = {
               {name = "flame orb", countmax = 1, chance = 13000},
               {name = "lava cookie", countmax = 5, chance = 15000},
               {name = "magma stone", countmax = 3, chance = 9000},
               {name = "magmarizer", countmax = 1, chance = 9000},
               {name = "flame plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Pinsir"] = {
           profit = 0,
           loots = {
               {name = "pincer horn", countmax = 1, chance = 10000},
               {name = "insect plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Tauros"] = {
           profit = 0,
           loots = {
               {name = "horn", countmax = 1, chance = 13000},
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Magikarp"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 5, chance = 10000},
          }
      },
      ["Shiny Gyarados"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 15, chance = 15000},
               {name = "gyarados tail", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 100},
               {name = "draco plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Lapras"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 15, chance = 15000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Ditto"] = {
           profit = 0,
           loots = {
          }
      },
      ["Shiny Eevee"] = {
           profit = 0,
           loots = {
               {name = "tooth", countmax = 1, chance = 13000},
          }
      },
      ["Shiny Vaporeon"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 15, chance = 15000},
               {name = "water pendant", countmax = 1, chance = 10000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Jolteon"] = {
           profit = 0,
           loots = {
               {name = "electrizer", countmax = 1, chance = 10000},
               {name = "zap plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Flareon"] = {
           profit = 0,
           loots = {
               {name = "fire element", countmax = 15, chance = 15000},
               {name = "pot of lava", countmax = 1, chance = 10000},
               {name = "flame plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Porygon"] = {
           profit = 0,
           loots = {
          }
      },
      ["Shiny Omanyte"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 15, chance = 15000},
               {name = "water pendant", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Omastar"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 20, chance = 18000},
               {name = "water pendant", countmax = 1, chance = 13000},
               {name = "splash plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Kabuto"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 15, chance = 15000},
               {name = "water pendant", countmax = 1, chance = 10000},
          }
      },
      ["Shiny Kabutops"] = {
           profit = 0,
           loots = {
               {name = "water gem", countmax = 20, chance = 18000},
               {name = "stone orb", countmax = 1, chance = 13000},
               {name = "splash plate", countmax = 1, chance = 100},
               {name = "stone plate", countmax = 1, chance = 100},
               {name = "draco plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Aerodactyl"] = {
           profit = 0,
           loots = {
               {name = "stone orb", countmax = 1, chance = 18000},
               {name = "stone plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Snorlax"] = {
           profit = 0,
           loots = {
               {name = "love plate", countmax = 1, chance = 100},
               {name = "cookie", countmax = 5, chance = 20000},
          }
      },
      ["Shiny Articuno"] = {
           profit = 0,
           loots = {
               {name = "articuno feather", countmax = 1, chance = 100000},
               {name = "icicle plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Zapdos"] = {
           profit = 0,
           loots = {
               {name = "zapdos feather", countmax = 1, chance = 100000},
               {name = "zap plate", countmax = 1, chance = 200},
          }
      },
      ["Shiny Moltres"] = {
           profit = 0,
           loots = {
               {name = "moltres feather", countmax = 1, chance = 100000},
               {name = "flame plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Dratini"] = {
           profit = 0,
           loots = {
          }
      },
      ["Shiny Dragonair"] = {
           profit = 0,
           loots = {
               {name = "draco plate", countmax = 1, chance = 50},
          }
      },
      ["Shiny Dragonite"] = {
           profit = 0,
           loots = {
               {name = "draco plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Mewtwo"] = {
           profit = 0,
           loots = {
               {name = "love plate", countmax = 1, chance = 100},
          }
      },
      ["Shiny Mew"] = {
           profit = 0,
           loots = {
               {name = "love plate", countmax = 1, chance = 100},
          }
      },]]
}

local LOOTS = {
    ["leaf"] = { id = 12091, price = 18 },
    ["water gem"] = { id = 12100, price = 1 },
    ["fire element"] = { id = 12101, price = 1 },
    ["seed"] = { id = 12102, price = 1 },
    ["screw"] = { id = 12103, price = 1 },
    ["bottle of poison"] = { id = 12104, price = 1 },
    ["water pendant"] = { id = 12112, price = 16 },
    ["pot of moss mug"] = { id = 12113, price = 14 },
    ["bitten apple"] = { id = 12115, price = 9 },
    ["tooth"] = { id = 12117, price = 9 },
    ["bat wing"] = { id = 12124, price = 15 },
    ["crab claw"] = { id = 12149, price = 7 },
    ["feather"] = { id = 12142, price = 9 },
    ["horn"] = { id = 12120, price = 15 },
    ["pincer horn"] = { id = 12084, price = 70 },
    ["harden shell"] = { id = 12085, price = 30 },
    ["gyarados tail"] = { id = 12086, price = 100 },
    ["pot of lava"] = { id = 12087, price = 18 },
    ["bag of polen"] = { id = 12089, price = 22 },
    ["bulb"] = { id = 12090, price = 35 },
    ["razor fang"] = { id = 12096, price = 7 },
    ["hull"] = { id = 12097, price = 25 },
    ["hard nail"] = { id = 12098, price = 12 },
    ["microphone"] = { id = 12099, price = 22 },
    ["scyther razor"] = { id = 12108, price = 100 },
    ["yellow tail"] = { id = 12110, price = 100 },
    ["sharp beak"] = { id = 12114, price = 35 },
    ["syrup"] = { id = 12116, price = 100 },
    ["electrizer"] = { id = 12118, price = 18 },
    ["sandbag"] = { id = 12119, price = 12 },
    ["horn"] = { id = 12120, price = 15 },
    ["comb"] = { id = 12121, price = 22 },
    ["tail"] = { id = 12122, price = 40 },
    ["fur"] = { id = 12123, price = 12 },
    ["mushroom"] = { id = 12125, price = 7 },
    ["insect antenna"] = { id = 12126, price = 30 },
    ["amulet coin"] = { id = 12128, price = 30 },
    ["ball of wool"] = { id = 12129, price = 25 },
    ["ruby"] = { id = 12130, price = 25 },
    ["psyduck mug"] = { id = 12131, price = 30 },
    ["box gloves"] = { id = 12133, price = 100 },
    ["twisted spoon"] = { id = 12135, price = 20 },
    ["shadow orb"] = { id = 12136, price = 50 },
    ["magnet"] = { id = 12140, price = 15 },
    ["ice cub"] = { id = 12143, price = 30 },
    ["black sludge"] = { id = 12144, price = 15 },
    ["shell bell"] = { id = 12145, price = 20 },
    ["piece of onix"] = { id = 12147, price = 50 },
    ["crab claw"] = { id = 12149, price = 7 },
    ["thick club"] = { id = 12150, price = 22 },
    ["bandage"] = { id = 12151, price = 100 },
    ["tongue"] = { id = 12152, price = 60 },
    ["egg"] = { id = 12154, price = 25 },
    ["thorn"] = { id = 12155, price = 9 },
    ["big mushroom"] = { id = 13302, price = 20 },
    ["flame orb"] = { id = 13303, price = 38 },
    ["gracidea"] = { id = 13304, price = 27 },
    ["magma stone"] = { id = 13306, price = 80 },
    ["magmarizer"] = { id = 13307, price = 40 },
    ["metal spike"] = { id = 13308, price = 26 },
    ["revival herb"] = { id = 13309, price = 27 },
    ["stone orb"] = { id = 12138, price = 25 },
    ["tangela hair"] = { id = 12106, price = 33 },
    ["reaper cloth"] = { id = 12146, price = 45 },
    ["slowpoke tail"] = { id = 12139, price = 35 },
    ["jynx clothes"] = { id = 12109, price = 50 },
    ["stick"] = { id = 12141, price = 50 },
    ["linearly guided hypnose pendant"] = { id = 12148, price = 40 },
    ["ape hair"] = { id = 14465, price = 80 },
    ["bamboo leaves"] = { id = 14466, price = 5 },
    ["bunch of ripe rice"] = { id = 14467, price = 25 },
    ["bunch of sugar cane"] = { id = 14468, price = 5 },
    ["bunch of wheat"] = { id = 14469, price = 2 },
    ["burning heart"] = { id = 14471, price = 200 },
    ["colourful feather"] = { id = 14472, price = 50 },
    ["coral comb"] = { id = 14474, price = 80 },
    ["crab pincer"] = { id = 14475, price = 30 },
    ["cursed hand"] = { id = 14476, price = 40 },
    ["cutting fang"] = { id = 14477, price = 50 },
    ["downy feather"] = { id = 14478, price = 20 },
    ["elemental spike"] = { id = 14479, price = 35 },
    ["energy soil"] = { id = 14480, price = 15 },
    ["essence of a bad dream"] = { id = 14481, price = 50 },
    ["eternal flames"] = { id = 14482, price = 100 },
    ["exquisite silk"] = { id = 14483, price = 50 },
    ["light feather"] = { id = 14484, price = 5 },
    ["flawless ice crystal"] = { id = 14485, price = 20 },
    ["frost charm"] = { id = 14486, price = 25 },
    ["frostbite herb"] = { id = 14487, price = 5 },
    ["frozen heart"] = { id = 14488, price = 300 },
    ["frozen tear"] = { id = 14489, price = 50 },
    ["gear wheel"] = { id = 14490, price = 5 },
    ["giant pincer"] = { id = 14491, price = 60 },
    ["heavy stone"] = { id = 14492, price = 50 },
    ["huge chunk of crude iron"] = { id = 14493, price = 35 },
    ["ice crystal"] = { id = 14494, price = 20 },
    ["giant ice cube"] = { id = 14495, price = 60 },
    ["icicle"] = { id = 14496, price = 25 },
    ["mouldy cheese"] = { id = 14497, price = 10 },
    ["hard nail"] = { id = 14498, price = 30 },
    ["petrified scream"] = { id = 14499, price = 70 },
    ["piece of royal steel"] = { id = 14500, price = 20 },
    ["pincer"] = { id = 14501, price = 5 },
    ["royal feather"] = { id = 14502, price = 150 },
    ["sample of sand wasp honey"] = { id = 14503, price = 40 },
    ["scarab cheese"] = { id = 14504, price = 35 },
    ["shadow rock"] = { id = 14505, price = 28 },
    ["shard"] = { id = 14506, price = 28 },
    ["spool of yarn"] = { id = 14507, price = 15 },
    ["strong pincers"] = { id = 14508, price = 40 },
    ["blastoise hull"] = { id = 14509, price = 100 },
    ["leaf pendant"] = { id = 14510, price = 10 },
    ["venon pendant"] = { id = 14511, price = 10 },
    ["night orb"] = { id = 14512, price = 30 },
    ["fire pendant"] = { id = 14513, price = 10 },
    ["fire orb"] = { id = 14514, price = 50 },
    ["pot of water"] = { id = 14515, price = 25 },
    ["white orb"] = { id = 14516, price = 50 },
    ["black diamond"] = { id = 14517, price = 60 },
    ["black orb"] = { id = 14518, price = 10 },
    ["rare sandbag"] = { id = 14519, price = 70 },
    ["green orb"] = { id = 14520, price = 15 },
    ["resistant fabric"] = { id = 14626, price = 0 },
    ["acorn"] = { id = 17786, price = 15 },
    ["antlers"] = { id = 17787, price = 50 },
    ["artist canvas"] = { id = 17788, price = 300 },
    ["artist brush with ink"] = { id = 17789, price = 200 },
    ["artist brush"] = { id = 17790, price = 50 },
    ["artist palette"] = { id = 17791, price = 500 },
    ["bag of candies"] = { id = 17792, price = 80 },
    ["bamboo stick"] = { id = 17793, price = 5 },
    ["banana sash"] = { id = 17794, price = 5 },
    ["banana skin"] = { id = 17795, price = 5 },
    ["battle stone"] = { id = 17796, price = 30 },
    ["blazing bone"] = { id = 17797, price = 80 },
    ["bony tail"] = { id = 17798, price = 90 },
    ["clay lump"] = { id = 17799, price = 70 },
    ["coal"] = { id = 17800, price = 10 },
    ["crystaline spikes"] = { id = 17801, price = 25 },
    ["cure herb"] = { id = 17802, price = 20 },
    ["dark claws"] = { id = 17803, price = 60 },
    ["dark crystal"] = { id = 17804, price = 100 },
    ["decorative ribbon"] = { id = 17805, price = 50 },
    ["iron loadstone"] = { id = 17806, price = 25 },
    ["luminous orb"] = { id = 17807, price = 100 },
    ["poisonous slime"] = { id = 17808, price = 15 },
    ["pot of flames"] = { id = 17809, price = 100 },
    ["spider fangs"] = { id = 17810, price = 10 },
    ["spider silk"] = { id = 17811, price = 20 },
    ["spiderwebs"] = { id = 17812, price = 50 },
    ["wool"] = { id = 17813, price = 30 },
    ["astral glyph"] = { id = 28870, price = 100 },
    ["astral source"] = { id = 28871, price = 100 },
    ["beetle carapace"] = { id = 28872, price = 30 },
    ["blue sphere"] = { id = 28873, price = 30 },
    ["bone toothpick"] = { id = 28874, price = 30 },
    ["tropical leaf"] = { id = 28875, price = 30 },
    ["forbidden fruit"] = { id = 28876, price = 50 },
    ["golden gear wheel"] = { id = 28877, price = 80 },
    ["petrified goo"] = { id = 28878, price = 40 },
    ["grey-blue powder"] = { id = 28879, price = 80 },
    ["lion's mane flower"] = { id = 28880, price = 200 },
    ["exotic feather"] = { id = 28881, price = 300 },
    ["plasmatic lightning"] = { id = 28882, price = 100 },
    ["dark feather"] = { id = 28883, price = 30 },
    ["galatic scale"] = { id = 28884, price = 40 },
    ["bright hair"] = { id = 28885, price = 50 },
    ["sharp razor"] = { id = 28886, price = 25 },
    ["thorn seed"] = { id = 28887, price = 20 },
    ["hard claws"] = { id = 28888, price = 40 },
    ["prismatic quartz"] = { id = 28889, price = 10 },
    ["spark sphere"] = { id = 28890, price = 100 },
    ["frozen lightning"] = { id = 28891, price = 90 },
    --[[
    ["shiny harden shell"] = {id = 14521, price = 0},
    ["shiny gyarados tail"] = {id = 14522, price = 0},
    ["shiny pot of lava"] = {id = 14523, price = 0},
    ["shiny bulb"] = {id = 14524, price = 0},
    ["shiny leaf"] = {id = 14525, price = 0},
    ["shiny razor fang"] = {id = 14526, price = 0},
    ["shiny hull"] = {id = 14527, price = 0},
    ["shiny microphone"] = {id = 14528, price = 0},
    ["shiny water gem"] = {id = 14529, price = 0},
    ["shiny fire element"] = {id = 14530, price = 0},
    ["shiny seed"] = {id = 14531, price = 0},
    ["shiny screw"] = {id = 14532, price = 0},
    ["shiny bottle of poison"] = {id = 14533, price = 0},
    ["shiny tangela hair"] = {id = 14534, price = 0},
    ["shiny mr. mime cloth"] = {id = 14535, price = 0},
    ["shiny scyther razor"] = {id = 14536, price = 0},
    ["shiny jynx clothes"] = {id = 14537, price = 0},
    ["shiny yellow tail"] = {id = 14538, price = 0},
    ["shiny water pendant"] = {id = 14539, price = 0},
    ["shiny pot of moss mug"] = {id = 14540, price = 0},
    ["shiny sharp beak"] = {id = 14541, price = 0},
    ["shiny bitten apple"] = {id = 14542, price = 0},
    ["shiny syrup"] = {id = 14543, price = 0},
    ["shiny tooth"] = {id = 14544, price = 0},
    ["shiny electrizer"] = {id = 14545, price = 0},
    ["shiny rare sandbag"] = {id = 14546, price = 0},
    ["shiny horn"] = {id = 14547, price = 0},
    ["shiny tail"] = {id = 14548, price = 0},
    ["shiny fur"] = {id = 14549, price = 0},
    ["shiny bat wing"] = {id = 14550, price = 0},
    ["shiny insect antenna"] = {id = 14551, price = 0},
    --["shiny bug venom"] = {id = 14552, price = 0},
    ["shiny amulet coin"] = {id = 14553, price = 0},
    ["shiny ball of wool"] = {id = 14554, price = 0},
    ["shiny ruby"] = {id = 14555, price = 0},
    ["shiny psyduck mug"] = {id = 14556, price = 0},
    --["shiny blue scarf"] = {id = 14557, price = 0},
    ["shiny box gloves"] = {id = 14558, price = 0},
    --["shiny iron bracelets"] = {id = 14559, price = 0},
    ["shiny twisted spoon"] = {id = 14560, price = 0},
    --["shiny shadow orb"] = {id = 14561, price = 0},
    --["shiny tiara"] = {id = 14562, price = 0},
    ["shiny stone orb"] = {id = 14563, price = 0},
    ["shiny slowpoke tail"] = {id = 14564, price = 0},
    ["shiny magnet"] = {id = 14565, price = 0},
    ["shiny stick"] = {id = 14566, price = 0},
    ["shiny light feather"] = {id = 14567, price = 0},
    ["shiny ice cub"] = {id = 14568, price = 0},
    ["shiny black sludge"] = {id = 14569, price = 0},
    ["shiny shell bell"] = {id = 14570, price = 0},
    ["shiny reaper cloth"] = {id = 14571, price = 0},
    ["shiny piece of onix"] = {id = 14572, price = 0},
    ["shiny linearly guided hypnose pendant"] = {id = 14573, price = 0},
    ["shiny crab claw"] = {id = 14574, price = 0},
    ["shiny thick club"] = {id = 14575, price = 0},
    ["shiny bandage"] = {id = 14576, price = 0},
    ["shiny tongue"] = {id = 14577, price = 0},
    --["shiny azure flute"] = {id = 14578, price = 0},
    ["shiny thorn"] = {id = 14579, price = 0},
    ["shiny ape hair"] = {id = 14580, price = 0},
    ["shiny bamboo leaves"] = {id = 14581, price = 0},
    ["shiny bunch of ripe rice"] = {id = 14582, price = 0},
    ["shiny bunch of sugar cane"] = {id = 14583, price = 0},
    ["shiny bunch of wheat"] = {id = 14584, price = 0},
    ["shiny bunch of winterberries"] = {id = 14585, price = 0},
    ["shiny burning heart"] = {id = 14586, price = 0},
    ["shiny colourful feather"] = {id = 14587, price = 0},
    ["shiny comb"] = {id = 14588, price = 0},
    ["shiny coral comb"] = {id = 14589, price = 0},
    ["shiny crab pincer"] = {id = 14590, price = 0},
    ["shiny crab pincer"] = {id = 14591, price = 0},
    ["shiny cutting fang"] = {id = 14592, price = 0},
    ["shiny downy feather"] = {id = 14593, price = 0},
    ["shiny elemental spike"] = {id = 14594, price = 0},
    ["shiny energy soil"] = {id = 14595, price = 0},
    ["shiny essence of a bad dream"] = {id = 14596, price = 0},
    ["shiny eternal flames"] = {id = 14597, price = 0},
    ["shiny exquisite silk"] = {id = 14598, price = 0},
    ["shiny light feather"] = {id = 14599, price = 0},
    ["shiny flawless ice crystal"] = {id = 14600, price = 0},
    ["shiny frost charm"] = {id = 14601, price = 0},
    ["shiny frostbite herb"] = {id = 14602, price = 0},
    ["shiny frozen heart"] = {id = 14603, price = 0},
    ["shiny frozen tear"] = {id = 14604, price = 0},
    ["shiny gear wheel"] = {id = 14605, price = 0},
    ["shiny giant pincer"] = {id = 14606, price = 0},
    ["shiny heavy stone"] = {id = 14607, price = 0},
    ["shiny huge chunk of crude iron"] = {id = 14608, price = 0},
    ["shiny ice crystal"] = {id = 14609, price = 0},
    ["shiny ice cube"] = {id = 14610, price = 0},
    ["shiny icicle"] = {id = 14611, price = 0},
    ["shiny mouldy cheese"] = {id = 14612, price = 0},
    ["shiny nail"] = {id = 14613, price = 0},
    ["shiny petrified scream"] = {id = 14614, price = 0},
    ["shiny piece of royal steel"] = {id = 14615, price = 0},
    ["shiny pincer"] = {id = 14616, price = 0},
    ["shiny royal feather"] = {id = 14617, price = 0},
    ["shiny sample of sand wasp honey"] = {id = 14618, price = 0},
    ["shiny scarab cheese"] = {id = 14619, price = 0},
    ["shiny shadow rock"] = {id = 14620, price = 0},
    ["shiny shard"] = {id = 14621, price = 0},
    ["shiny spool of yarn"] = {id = 14622, price = 0},
    ]]
    --Plates
    ["flame plate"] = { id = 12229, price = 7000 },
    ["splash plate"] = { id = 12230, price = 6000 },
    ["meadow plate"] = { id = 12231, price = 3000 },
    ["love plate"] = { id = 12232, price = 5000 },
    ["mind plate"] = { id = 12233, price = 10000 },
    ["stone plate"] = { id = 12234, price = 4000 },
    ["toxic plate"] = { id = 12235, price = 3000 },
    ["icicle plate"] = { id = 12236, price = 5000 },
    ["zap plate"] = { id = 12237, price = 5000 },
    ["draco plate"] = { id = 12240, price = 15000 },
    ["insect plate"] = { id = 12241, price = 2000 },
    ["dread plate"] = { id = 12242, price = 10000 },
    ["fist plate"] = { id = 12243, price = 10000 },
    ["earth plate"] = { id = 13807, price = 5000 },
    ["iron plate"] = { id = 17814, price = 10000 },
    ["sky plate"] = { id = 18081, price = 5000 },
    ["spooky plate"] = { id = 18082, price = 10000 },
    ["pixie plate"] = { id = 23946, price = 8000 },
    --Foods
    ["lava cookie"] = { id = 13305, price = 0 },
    ["cookie"] = { id = 2687, price = 0 },
    ["onigiri"] = { id = 14464, price = 0 },
    ["bunch of winterberries"] = { id = 14470, price = 0 },
    ["ice cream cone (crispy chocolate chips)"] = { id = 7372, price = 0 },
    ["ice cream cone (blue-barian)"] = { id = 7377, price = 0 },
    ["ice cream cone (chilly cherry)"] = { id = 7375, price = 0 },
    ["melon"] = { id = 2682, price = 0 },
    ["cheese"] = { id = 2696, price = 0 },
    ["mango"] = { id = 5097, price = 0 },
    ["pear"] = { id = 2673, price = 0 },
    ["red apple"] = { id = 2674, price = 0 },
    ["banana"] = { id = 2676, price = 0 },
    ["blueberry"] = { id = 2677, price = 0 },
    ["lemon"] = { id = 8841, price = 0 },
    ["strawberry"] = { id = 2680, price = 0 },
    ["orange"] = { id = 2675, price = 0 },
    --Dolls
    ["bulbasaur doll"] = { id = 12271, price = 80 },
    ["ivysaur doll"] = { id = 17820, price = 100 },
    ["venusaur doll"] = { id = 17821, price = 150 },
    ["charmander doll"] = { id = 17822, price = 80 },
    ["charmeleon doll"] = { id = 17823, price = 100 },
    ["charizard doll"] = { id = 17824, price = 150 },
    ["squirtle doll"] = { id = 17825, price = 80 },
    ["wartortle doll"] = { id = 17826, price = 100 },
    ["blastoise doll"] = { id = 17827, price = 150 },
    ["caterpie doll"] = { id = 17828, price = 50 },
    ["metapod doll"] = { id = 17829, price = 70 },
    ["butterfree doll"] = { id = 17830, price = 100 },
    ["weedle doll"] = { id = 17831, price = 50 },
    ["kakuna doll"] = { id = 17832, price = 70 },
    ["beedrill doll"] = { id = 17833, price = 100 },
    ["pidgey doll"] = { id = 17834, price = 60 },
    ["pidgeotto doll"] = { id = 17835, price = 80 },
    ["pidgeot doll"] = { id = 12253, price = 120 },
    ["rattata doll"] = { id = 17836, price = 60 },
    ["raticate doll"] = { id = 17837, price = 100 },
    ["spearow doll"] = { id = 17838, price = 70 },
    ["fearow doll"] = { id = 17839, price = 120 },
    ["ekans doll"] = { id = 17840, price = 80 },
    ["arbok doll"] = { id = 17841, price = 120 },
    ["pikachu doll"] = { id = 12256, price = 100 },
    ["raichu doll"] = { id = 12272, price = 80 },
    ["sandshrew doll"] = { id = 17842, price = 80 },
    ["sandslash doll"] = { id = 17843, price = 130 },
    ["nidorana doll"] = { id = 17844, price = 60 },
    ["nidorina doll"] = { id = 17845, price = 90 },
    ["nidoqueen doll"] = { id = 17846, price = 140 },
    ["nidorano doll"] = { id = 17847, price = 60 },
    ["nidorino doll"] = { id = 17848, price = 90 },
    ["nidoking doll"] = { id = 17849, price = 140 },
    ["clefairy doll"] = { id = 17850, price = 100 },
    ["clefable doll"] = { id = 17851, price = 150 },
    ["vulpix doll"] = { id = 17852, price = 80 },
    ["ninetales doll"] = { id = 17853, price = 130 },
    ["jigglypuff doll"] = { id = 12270, price = 80 },
    ["wigglytuff doll"] = { id = 17854, price = 150 },
    ["zubat doll"] = { id = 17855, price = 60 },
    ["golbat doll"] = { id = 17856, price = 120 },
    ["oddish doll"] = { id = 17857, price = 60 },
    ["gloom doll"] = { id = 17858, price = 90 },
    ["vileplume doll"] = { id = 17859, price = 140 },
    ["paras doll"] = { id = 17860, price = 50 },
    ["parasect doll"] = { id = 17861, price = 120 },
    ["venonat doll"] = { id = 17862, price = 60 },
    ["venomoth doll"] = { id = 17863, price = 110 },
    ["diglett doll"] = { id = 17864, price = 60 },
    ["dugtrio doll"] = { id = 17865, price = 120 },
    ["meowth doll"] = { id = 17866, price = 80 },
    ["persian doll"] = { id = 17867, price = 110 },
    ["psyduck doll"] = { id = 12263, price = 100 },
    ["golduck doll"] = { id = 17868, price = 140 },
    ["mankey doll"] = { id = 17869, price = 70 },
    ["primeape doll"] = { id = 17870, price = 130 },
    ["growlithe doll"] = { id = 17871, price = 80 },
    ["arcanine doll"] = { id = 17872, price = 140 },
    ["poliwag doll"] = { id = 17873, price = 60 },
    ["poliwhirl doll"] = { id = 17874, price = 100 },
    ["poliwrath doll"] = { id = 12255, price = 150 },
    ["abra doll"] = { id = 17875, price = 100 },
    ["kadabra doll"] = { id = 17876, price = 120 },
    ["alakazam doll"] = { id = 17877, price = 150 },
    ["machop doll"] = { id = 17878, price = 80 },
    ["machoke doll"] = { id = 17879, price = 110 },
    ["machamp doll"] = { id = 17880, price = 140 },
    ["bellsprout doll"] = { id = 17881, price = 80 },
    ["weepinbell doll"] = { id = 17882, price = 110 },
    ["victreebel doll"] = { id = 17883, price = 140 },
    ["tentacool doll"] = { id = 17884, price = 100 },
    ["tentacruel doll"] = { id = 17885, price = 150 },
    ["geodude doll"] = { id = 17886, price = 80 },
    ["graveler doll"] = { id = 17887, price = 110 },
    ["golem doll"] = { id = 17888, price = 140 },
    ["ponyta doll"] = { id = 17889, price = 90 },
    ["rapidash doll"] = { id = 17890, price = 130 },
    ["slowpoke doll"] = { id = 17891, price = 90 },
    ["slowbro doll"] = { id = 12266, price = 140 },
    ["magnemite doll"] = { id = 17892, price = 80 },
    ["magneton doll"] = { id = 17893, price = 130 },
    ["farfetchd doll"] = { id = 17894, price = 200 },
    ["doduo doll"] = { id = 17895, price = 90 },
    ["dodrio doll"] = { id = 17896, price = 120 },
    ["seel doll"] = { id = 12257, price = 90 },
    ["dewgong doll"] = { id = 17897, price = 130 },
    ["grimer doll"] = { id = 17898, price = 70 },
    ["muk doll"] = { id = 17899, price = 130 },
    ["shellder doll"] = { id = 17900, price = 100 },
    ["cloyster doll"] = { id = 17901, price = 150 },
    ["gastly doll"] = { id = 17902, price = 80 },
    ["haunter doll"] = { id = 17903, price = 120 },
    ["gengar doll"] = { id = 17904, price = 150 },
    ["onix doll"] = { id = 17905, price = 130 },
    ["drowzee doll"] = { id = 17906, price = 100 },
    ["hypno doll"] = { id = 17907, price = 140 },
    ["krabby doll"] = { id = 17908, price = 70 },
    ["kingler doll"] = { id = 17909, price = 130 },
    ["voltorb doll"] = { id = 17910, price = 80 },
    ["electrode doll"] = { id = 17911, price = 140 },
    ["exeggcute doll"] = { id = 17912, price = 70 },
    ["exeggutor doll"] = { id = 17913, price = 150 },
    ["cubone doll"] = { id = 12269, price = 80 },
    ["marowak doll"] = { id = 17914, price = 130 },
    ["hitmonlee doll"] = { id = 17915, price = 200 },
    ["hitmonchan doll"] = { id = 17916, price = 200 },
    ["lickitung doll"] = { id = 17917, price = 150 },
    ["koffing doll"] = { id = 17918, price = 90 },
    ["weezing doll"] = { id = 17919, price = 140 },
    ["rhyhorn doll"] = { id = 17920, price = 100 },
    ["rhydon doll"] = { id = 17921, price = 150 },
    ["chansey doll"] = { id = 12268, price = 200 },
    ["tangela doll"] = { id = 17922, price = 120 },
    ["kangaskhan doll"] = { id = 17923, price = 150 },
    ["horsea doll"] = { id = 17924, price = 70 },
    ["seadra doll"] = { id = 17925, price = 120 },
    ["goldeen doll"] = { id = 17926, price = 70 },
    ["seaking doll"] = { id = 17927, price = 120 },
    ["staryu doll"] = { id = 17928, price = 90 },
    ["starmie doll"] = { id = 17929, price = 140 },
    ["mr. mime doll"] = { id = 17930, price = 200 },
    ["scyther doll"] = { id = 17931, price = 200 },
    ["jynx doll"] = { id = 17932, price = 150 },
    ["electabuzz doll"] = { id = 17933, price = 150 },
    ["magmar doll"] = { id = 17934, price = 150 },
    ["pinsir doll"] = { id = 17935, price = 130 },
    ["tauros doll"] = { id = 17936, price = 130 },
    ["magikarp doll"] = { id = 17937, price = 30 },
    ["gyarados doll"] = { id = 17938, price = 150 },
    ["lapras doll"] = { id = 12258, price = 150 },
    ["ditto doll"] = { id = 17939, price = 200 },
    ["eevee doll"] = { id = 17940, price = 200 },
    ["vaporeon doll"] = { id = 17941, price = 200 },
    ["jolteon doll"] = { id = 17942, price = 200 },
    ["flareon doll"] = { id = 17943, price = 200 },
    ["porygon doll"] = { id = 17944, price = 200 },
    ["omanyte doll"] = { id = 12267, price = 500 },
    ["omastar doll"] = { id = 17945, price = 1000 },
    ["kabuto doll"] = { id = 12265, price = 500 },
    ["kabutops doll"] = { id = 17946, price = 1000 },
    ["aerodactyl doll"] = { id = 17947, price = 10000 },
    ["snorlax doll"] = { id = 17948, price = 200 },
    ["articuno doll"] = { id = 12260, price = 10000 },
    ["zapdos doll"] = { id = 12261, price = 10000 },
    ["moltres doll"] = { id = 12262, price = 10000 },
    ["dratini doll"] = { id = 17949, price = 100 },
    ["dragonair doll"] = { id = 17950, price = 150 },
    ["dragonite doll"] = { id = 17951, price = 200 },
    ["mewtwo doll"] = { id = 12264, price = 1000 },
    ["mew doll"] = { id = 12254, price = 1000 },
    ["chikorita doll"] = { id = 17952, price = 80 },
    ["bayleef doll"] = { id = 17953, price = 100 },
    ["meganium doll"] = { id = 17954, price = 150 },
    ["cyndaquil doll"] = { id = 17955, price = 80 },
    ["quilava doll"] = { id = 17956, price = 100 },
    ["typhlosion doll"] = { id = 17957, price = 150 },
    ["totodile doll"] = { id = 17958, price = 80 },
    ["croconaw doll"] = { id = 17959, price = 100 },
    ["feraligatr doll"] = { id = 17960, price = 150 },
    ["sentret doll"] = { id = 17961, price = 60 },
    ["furret doll"] = { id = 17962, price = 120 },
    ["hoothoot doll"] = { id = 17963, price = 70 },
    ["noctowl doll"] = { id = 17964, price = 140 },
    ["ledyba doll"] = { id = 17965, price = 60 },
    ["ledian doll"] = { id = 17966, price = 130 },
    ["spinarak doll"] = { id = 17967, price = 70 },
    ["ariados doll"] = { id = 17968, price = 140 },
    ["crobat doll"] = { id = 17969, price = 200 },
    ["chinchou doll"] = { id = 17970, price = 70 },
    ["lanturn doll"] = { id = 17971, price = 130 },
    ["pichu doll"] = { id = 17972, price = 50 },
    ["cleffa doll"] = { id = 17973, price = 50 },
    ["igglybuff doll"] = { id = 17974, price = 50 },
    ["togepi doll"] = { id = 17975, price = 50 },
    ["togetic doll"] = { id = 17976, price = 100 },
    ["natu doll"] = { id = 17977, price = 70 },
    ["xatu doll"] = { id = 17978, price = 130 },
    ["mareep doll"] = { id = 17979, price = 80 },
    ["flaaffy doll"] = { id = 17980, price = 100 },
    ["ampharos doll"] = { id = 17981, price = 150 },
    ["bellossom doll"] = { id = 17982, price = 150 },
    ["marill doll"] = { id = 17983, price = 90 },
    ["azumarill doll"] = { id = 17984, price = 140 },
    ["sudowoodo doll"] = { id = 17985, price = 150 },
    ["politoed doll"] = { id = 17986, price = 150 },
    ["hoppip doll"] = { id = 17987, price = 80 },
    ["skiploom doll"] = { id = 17988, price = 100 },
    ["jumpluff doll"] = { id = 17989, price = 150 },
    ["aipom doll"] = { id = 17990, price = 90 },
    ["sunkern doll"] = { id = 17991, price = 50 },
    ["sunflora doll"] = { id = 17992, price = 120 },
    ["yanma doll"] = { id = 17993, price = 110 },
    ["wooper doll"] = { id = 17994, price = 70 },
    ["quagsire doll"] = { id = 17995, price = 130 },
    ["espeon doll"] = { id = 17996, price = 200 },
    ["umbreon doll"] = { id = 17997, price = 200 },
    ["murkrow doll"] = { id = 17998, price = 130 },
    ["slowking doll"] = { id = 17999, price = 150 },
    ["misdreavus doll"] = { id = 18000, price = 130 },
    ["wobbuffet doll"] = { id = 18001, price = 200 },
    ["girafarig doll"] = { id = 18002, price = 130 },
    ["pineco doll"] = { id = 18003, price = 70 },
    ["forretress doll"] = { id = 18004, price = 140 },
    ["dunsparce doll"] = { id = 18005, price = 100 },
    ["gligar doll"] = { id = 18006, price = 110 },
    ["steelix doll"] = { id = 18007, price = 200 },
    ["snubbull doll"] = { id = 18008, price = 80 },
    ["granbull doll"] = { id = 18009, price = 140 },
    ["qwilfish doll"] = { id = 18010, price = 90 },
    ["scizor doll"] = { id = 18011, price = 200 },
    ["shuckle doll"] = { id = 18012, price = 150 },
    ["heracross doll"] = { id = 18013, price = 130 },
    ["sneasel doll"] = { id = 18014, price = 100 },
    ["teddiursa doll"] = { id = 18015, price = 90 },
    ["ursaring doll"] = { id = 18016, price = 150 },
    ["slugma doll"] = { id = 18017, price = 80 },
    ["magcargo doll"] = { id = 18018, price = 140 },
    ["swinub doll"] = { id = 18019, price = 70 },
    ["piloswine doll"] = { id = 18020, price = 140 },
    ["corsola doll"] = { id = 18021, price = 110 },
    ["remoraid doll"] = { id = 18022, price = 80 },
    ["octillery doll"] = { id = 18023, price = 140 },
    ["delibird doll"] = { id = 18024, price = 200 },
    ["mantine doll"] = { id = 18025, price = 100 },
    ["skarmory doll"] = { id = 18026, price = 140 },
    ["houndour doll"] = { id = 18027, price = 90 },
    ["houndoom doll"] = { id = 18028, price = 150 },
    ["kingdra doll"] = { id = 18029, price = 150 },
    ["phanpy doll"] = { id = 18030, price = 80 },
    ["donphan doll"] = { id = 18031, price = 140 },
    ["porygon2 doll"] = { id = 18032, price = 200 },
    ["stantler doll"] = { id = 18033, price = 200 },
    ["smeargle doll"] = { id = 18034, price = 200 },
    ["tyrogue doll"] = { id = 18035, price = 50 },
    ["hitmontop doll"] = { id = 18036, price = 200 },
    ["smoochum doll"] = { id = 18037, price = 50 },
    ["elekid doll"] = { id = 18038, price = 50 },
    ["magby doll"] = { id = 18039, price = 50 },
    ["miltank doll"] = { id = 18040, price = 200 },
    ["blissey doll"] = { id = 18041, price = 200 },
    ["raikou doll"] = { id = 18042, price = 10000 },
    ["entei doll"] = { id = 18043, price = 10000 },
    ["suicune doll"] = { id = 18044, price = 10000 },
    ["larvitar doll"] = { id = 18045, price = 10 },
    ["pupitar doll"] = { id = 18046, price = 150 },
    ["tyranitar doll"] = { id = 18047, price = 200 },
    ["lugia doll"] = { id = 12259, price = 10000 },
    ["ho-oh doll"] = { id = 18048, price = 10000 },
    ["celebi doll"] = { id = 18049, price = 10000 },

    --Addons
    ["big feather"] = { id = 14624, price = 0 },
    ["insect skin"] = { id = 14625, price = 0 },
    ["resistante fabric"] = { id = 14626, price = 0 },
    ["fancy fabric"] = { id = 14627, price = 0 },
    ["healing oil"] = { id = 14628, price = 0 },
    ["lightweight fabric"] = { id = 14629, price = 0 },
    ["long silk"] = { id = 14630, price = 0 },
    ["old bandage"] = { id = 14631, price = 0 },

    --Evolution Items
    ["Fire Stone"] = { id = 18083, price = 22500 },
    ["Leaf Stone"] = { id = 18086, price = 22000 },
    ["Moon Stone"] = { id = 18084, price = 25500 },
    ["Sun Stone"] = { id = 18085, price = 24500 },
    ["Thunderstone"] = { id = 18087, price = 22000 },
    ["Water Stone"] = { id = 18088, price = 22500 },
    ["Up-Grade"] = { id = 18089, price = 30000 },
    ["Dragon Scale"] = { id = 18090, price = 30000 },
    ["King's Rock"] = { id = 18091, price = 30500 },
    ["Metal Coat"] = { id = 18092, price = 27500 },
    ["Soothe Bell"] = { id = 18093, price = 25500 },
    ["Punch Machine"] = { id = 18094, price = 30000 },
    ["Kick Machine"] = { id = 18095, price = 30000 },
    ["Spin Machine"] = { id = 18096, price = 30000 },
    ["Deepseascale"] = { id = 28892, price = 30000 },
    ["Deepseatooth"] = { id = 28893, price = 30000 },
    ["Prism Scale"] = { id = 28914, price = 30000 },

    --TMs Chances 1 - 5 - 10
    ["TM Bubblebeam"] = { id = 17347, price = 1000 },
    ["TM Water Gun"] = { id = 17348, price = 1000 },
    ["TM Rage"] = { id = 17355, price = 1000 },
    ["TM Mega Drain"] = { id = 17356, price = 1000 },
    ["TM Swift"] = { id = 17372, price = 1000 },
    ["TM Double-Edge"] = { id = 17346, price = 10000 },
    ["TM Ice Beam"] = { id = 17349, price = 10000 },
    ["TM Submission"] = { id = 17352, price = 5000 },
    ["TM Solar Beam"] = { id = 17357, price = 10000 },
    ["TM Dragon Rage"] = { id = 17358, price = 1000 },
    ["TM Thunderbolt"] = { id = 17359, price = 5000 },
    ["TM Fissure"] = { id = 17362, price = 10000 },
    ["TM Psychic"] = { id = 17363, price = 5000 },
    ["TM Metronome"] = { id = 17368, price = 10000 },
    ["TM Egg Bomb"] = { id = 17370, price = 10000 },
    ["TM Fire Blast"] = { id = 17371, price = 10000 },
    ["TM Dream Eater"] = { id = 17375, price = 5000 },
    ["TM Sky Attack"] = { id = 17376, price = 10000 },
    ["TM Thunder Wave"] = { id = 17378, price = 5000 },
    ["TM Psywave"] = { id = 17379, price = 10000 },
    ["TM Rock Slide"] = { id = 17381, price = 5000 },
    ["TM Tri Attack"] = { id = 17382, price = 5000 },
    ["TM Dynamic Punch"] = { id = 18912, price = 10000 },
    ["TM Headbutt"] = { id = 18913, price = 5000 },
    ["TM Curse"] = { id = 18914, price = 5000 },
    ["TM Zap Cannon"] = { id = 18915, price = 10000 },
    ["TM Snore"] = { id = 18916, price = 1000 },
    ["TM Icy Wind"] = { id = 18917, price = 5000 },
    ["TM Protect"] = { id = 18918, price = 5000 },
    ["TM Rain Dance"] = { id = 18919, price = 10000 },
    ["TM Giga Drain"] = { id = 18920, price = 10000 },
    ["TM Iron Tail"] = { id = 18921, price = 5000 },
    ["TM Shadow Ball"] = { id = 18922, price = 5000 },
    ["TM Mud-Slap"] = { id = 18923, price = 1000 },
    ["TM Ice Punch"] = { id = 18924, price = 5000 },
    ["TM Sludge Bomb"] = { id = 18925, price = 5000 },
    ["TM Defense Curl"] = { id = 18926, price = 1000 },
    ["TM Thunder Punch"] = { id = 18927, price = 5000 },
    ["TM Steel Wing"] = { id = 18928, price = 5000 },
    ["TM Fire Punch"] = { id = 18929, price = 5000 },
    ["TM Fury Cutter"] = { id = 18930, price = 5000 },
    ["held black belt"] = { id = 23513, price = 0 },
    ["held black glasses"] = { id = 23514, price = 0 },
    ["held charcoal"] = { id = 23515, price = 0 },
    ["held dragon fang"] = { id = 23516, price = 0 },
    ["held hard stone"] = { id = 23517, price = 0 },
    ["held magnet"] = { id = 23518, price = 0 },
    ["held metal coat"] = { id = 23519, price = 0 },
    ["held miracle seed"] = { id = 23520, price = 0 },
    ["held mystic water"] = { id = 23521, price = 0 },
    ["held never melt ice"] = { id = 23522, price = 0 },
    ["held pink bow"] = { id = 23523, price = 0 },
    ["held poison barb"] = { id = 23524, price = 0 },
    ["held polkadot bow"] = { id = 23525, price = 0 },
    ["held sharp beak"] = { id = 23526, price = 0 },
    ["held silk scarf"] = { id = 23527, price = 0 },
    ["held silver powder"] = { id = 23528, price = 0 },
    ["held soft sand"] = { id = 23529, price = 0 },
    ["held spell tag"] = { id = 23530, price = 0 },
    ["held twisted spoon"] = { id = 23531, price = 0 },
}

local OUT_DIR = PS_LIB_DIR .. "out/"

for _, loot in pairs(LOOTS) do
    if (getItemSellPrice(loot.id) > 0) then
        loot.price = getItemSellPrice(loot.id)
    end
end

for k, v in pairs(POKEMON) do
    for _, loot in pairs(v.loots) do
        local lootConfig = LOOTS[loot.name]
        if (not lootConfig) then
            local id = getItemIdByName(loot.name, false)
            if (id) then
                LOOTS[loot.name] = { id = id, price = getItemSellPrice(id) }
            end
        end
    end
end

--

local function generateLootConfig(name, id, chance, countmax)
    --return "<item id=\"" .. id .. "\" countmax=\"" .. countmax .. "\" chance=\"" .. chance .. "\"/> <!-- " .. name .. " -->"
    return { id = id, countmax = countmax, chance = chance }
end

local function getProfitRate(lootList)
    local x = 0
    for _, loot in ipairs(lootList) do
        if (not LOOTS[loot.name]) then
            print("Error: " .. loot.name)
            return
        end
        if (not loot.chance and LOOTS[loot.name].price > 0) then
            x = x + 1
        end
    end
    return 1 / x
end

local function getLootChance(profit, profitRate, lootPrice, lootCount)
    return math.floor(((profit * profitRate) / (lootPrice * lootCount)) * CHANCE_MAX)
end

--[[
local function generateMonsterLootList(monster, toFile)
    if (toFile == nil) then
        toFile = false
    end

    local loots, out, i, loot = getMonsterInfo(monster).loot, ""
    for i, loot in ipairs(loots) do
        out = out .. generateLootConfig(getItemNameById(loot.id), loot.id, loot.chance, loot.count) .. "\n"
    end

    if (toFile) then
        local file = io.open(OUT_DIR..monster..".loot.table", "w+")
        if (file) then
            file:write(out)
            file:close()
            return true
        else
            print("ERROR: generateMonsterLootListTable -  Can't open/create " .. OUT_DIR..monster..".loot")
            return false
        end
    end
    return out
end

local function generateMonsterLootListTable(monster, toFile)
    if (toFile == nil) then
        toFile = false
    end

    local loots, out, i, loot = getMonsterInfo(monster).loot, ""
    out = out .. "[\"" .. monster .. "\"] = {\n     profit = 0,\n     loots = {\n"
    for i, loot in ipairs(loots) do
        out = out .. "         {name = \"" .. getItemNameById(loot.id) .. "\", countmax = " .. loot.count .. ", chance = " .. loot.chance .. "},\n"
    end
    out = out .. "    }\n}"

    if (toFile) then
        local file = io.open(OUT_DIR..monster..".loot.table", "w+")
        if (file) then
            file:write(out)
            file:close()
            return true
        else
            print("ERROR: generateMonsterLootListTable -  Can't open/create " .. OUT_DIR..monster..".loot")
            return false
        end
    end
    return out
end

--old items local itemsids = {12091,12100,12101,12102,12103,12104,12112,12113,12115,12117,12124,12149,12142,12120,12113,12084,12085,12086,12087,12089,12090,12096,12097,12098,12099,12108,12110,12114,12116,12118,12119,12120,12121,12122,12123,12125,12126,12128,12129,12130,12131,12133,12135,12140,12143,12144,12145,12147,12149,12150,12151,12152,12154,12155,13302,13303,13304,13306,13307,13308,13309,12138,12106,12146,12139 }
local itemsids = {14464,14465,14466,14467,14468,14469,14470,14471,14472,14473,14474,14475,14476,14477,14478,14479,14480,14481,14482,14483,14484,14485,14486,14487,14488,14489,14490,14491,14492,14493,14494,14495,14496,14497,14498,14499,14500,14501,14502,14503,14504,14505,14506,14507,14508,14509,14510,14511,14512,14513,14514,14515,14516,14517,14518,14519,14520,14521,14522,14523,14524,14525,14526,14527,14528,14529,14530,14531,14532,14533,14534,14535,14536,14537,14538,14539,14540,14541,14542,14543,14544,14545,14546,14547,14548,14549,14550,14551,14552,14553,14554,14555,14556,14557,14558,14559,14560,14561,14562,14563,14564,14565,14566,14567,14568,14569,14570,14571,14572,14573,14574,14575,14576,14577,14578,14579,14580,14581,14582,14583,14584,14585,14586,14587,14588,14589,14590,14591,14592,14593,14594,14595,14596,14597,14598,14599,14600,14601,14602,14603,14604,14605,14606,14607,14608,14609,14610,14611,14612,14613,14614,14615,14616,14617,14618,14619,14620,14621,14622}
local function generateItemsListTable()
    local out, i, items = ""
    for i, item in ipairs(itemsids) do
        out = out .. "[\"" .. getItemNameById(item) .. "\"] = {id = " .. item .. ", price = 0},\n"
    end
    local file = io.open(OUT_DIR.."items.table", "w+")
    if (file) then
        file:write(out)
        file:close()
        return true
    else
        return false
    end
    return out
end
]]
--

function onSay(cid, words, param, channel)
    --[[local pokemon  = POKEMON[param]
    if (not pokemon) then
        return false
    end

    local profit, profitRate, out, i, loot = pokemon.profit, getProfitRate(pokemon.loots), ""
    for i, loot in ipairs(pokemon.loots) do
        local lootConfig = LOOTS[loot.name]
        if (not lootConfig) then
            print("ERROR: GenerateLoot - \"".. loot.name .."\" loot config can't be found!")
            return true
        end

        local countmax = loot.countmax or 1
        local lootChance = loot.chance or getLootChance(profit, profitRate, lootConfig.price, countmax) --math.floor(((profit * profitRate) / lootConfig.price) * CHANCE_MAX)

        while (lootChance > CHANCE_MAX) do -- The item price isn't enough, let's raise countmax
            countmax = countmax + 1
            lootChance = getLootChance(profit, profitRate, lootConfig.price, countmax)
            if (lootChance <= CHANCE_MAX) then
                countmax = countmax * 1.5 -- The countmax should be 1.5x since this is the average
            end
        end

        out = out .. generateLootConfig(loot.name, lootConfig.id, lootChance, countmax) .. "\n"
    end
    local file = io.open(OUT_DIR..param..".loot", "w+")
    if (file) then
        file:write(out)
        file:close()
    else
        print("ERROR: generateLoot -  Can't open/create " .. OUT_DIR..monster..".loot")
        return false
    end]]
    --[[]]
    --[[
    local out, i, pokemon = ""
    for i, pokemon in ipairs(pokemonsNames) do
        out = out .. generateMonsterLootListTable(pokemon) .. ",\n"
    end
    local file = io.open(OUT_DIR.."LOOTS.table", "w+")
    file:write(out)
    file:close()
    ]]
    --[[
    local out, i, pokemon = ""
    for i, pokemon in ipairs(pokemonsNames) do
        out = out .. "elseif (channel == CHANNEL_" .. string.upper(pokemon) .. ") then\n    doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_ID_CAUGHT" .. string.upper(pokemon) .. "))\n"
    end
    local file = io.open(OUT_DIR.."FILE", "w+")
    file:write(out)
    file:close()
    ]]
    local shiny = param == "shiny"

    for i, pokemonName in ipairs(pokemonNamesWithoutShiny) do --pokemonsNames) do
        print("\n\nCurrent pokemon: " .. pokemonName)
        local pokemon = POKEMON[pokemonName]
        if (not pokemon) then
            print("Error: " .. pokemonName)
        else
            local profit, profitRate, out = pokemon.profit, getProfitRate(pokemon.loots), {}
            for i, loot in ipairs(pokemon.loots) do
                if (shiny and getItemIdByName(string.concat("shiny ", loot.name), false)) then
                    loot.name = string.concat("shiny ", loot.name)
                end

                print("Current loot: " .. loot.name)
                local lootConfig = LOOTS[loot.name]
                if (shiny and not lootConfig) then
                    LOOTS[loot.name] = { id = getItemIdByName(loot.name), price = getItemSellPrice(getItemIdByName(loot.name)) }
                    lootConfig = LOOTS[loot.name]
                end

                if (not lootConfig) then
                    print("ERROR: GenerateLoot - \"" .. loot.name .. "\" loot config can't be found!")
                    return true
                end

                local countmax = loot.countmax or 1
                local lootChance = loot.chance or getLootChance(profit, profitRate, lootConfig.price, countmax) --math.floor(((profit * profitRate) / lootConfig.price) * CHANCE_MAX)

                --print("Countmax: " .. countmax)
                --print("Lootchance: " .. lootChance)

                while (lootChance > CHANCE_MAX) do -- The item price isn't enough, let's raise countmax
                    if (countmax >= 100) then
                        print("Error: countmax > 100")
                        return true
                    end

                    countmax = countmax + 1
                    lootChance = getLootChance(profit, profitRate, lootConfig.price, countmax)
                    if (lootChance <= CHANCE_MAX) then
                        countmax = countmax * 1.5 -- The countmax should be 1.5x since this is the average
                    end
                    countmax = math.floor(countmax)
                end
                out[#out + 1] = generateLootConfig(loot.name, lootConfig.id, lootChance, countmax)
            end
            local path = "Pokemons/update/" .. (shiny and "shiny " or "") .. pokemonName .. ".xml"
            if (not doUpdateMonsterLoot(out, path)) then
                print("ERROR: generateLoot -  Can't open/create " .. path)
            end
        end
        --[[local file = io.open(OUT_DIR..pokemonName..".loot", "w+")
        if (file) then
            file:write(out)
            file:close()
        else
            print("ERROR: generateLoot -  Can't open/create " .. OUT_DIR..pokemonName..".loot")
            return false
        end]]
    end
    return true
end
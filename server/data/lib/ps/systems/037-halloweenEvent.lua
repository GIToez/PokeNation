if (HalloweenEvent) then
    return
end

HalloweenEvent = {}

-- Constants
local INGREDIENTS = {
    {itemId = 12124, count = 750 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_BAT_WING, name = "bat wing"},
    {itemId = 12086, count = 350 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_GYARADOS_TAIL, name = "gyarados tail"},
    {itemId = 12087, count = 800 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_POT_OF_LAVA, name = "pot of lava"},
    {itemId = 12090, count = 500 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_BULB, name = "bulb"},
    {itemId = 12091, count = 1000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_LEAF, name = "leaf"},
    {itemId = 12096, count = 400 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_RAZOR_FANG, name = "razor fang"},
    {itemId = 12097, count = 500 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_HULL, name = "hull"},
    {itemId = 12099, count = 350 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_MICROPHONE, name = "microphone"},
    {itemId = 12100, count = 3000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_WATER_GEM, name = "water gem"},
    {itemId = 12101, count = 3000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_FIRE_ELEMENT, name = "fire element"},
    {itemId = 12102, count = 3000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_SEED, name = "seed"},
    {itemId = 12103, count = 1500 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_SCREW, name = "screw"},
    {itemId = 12104, count = 3000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_BOTTLE_OF_POISON, name = "bottle of poison"},
    {itemId = 12106, count = 300 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_TANGELA_HAIR, name = "tangela hair"},
    {itemId = 12109, count = 100 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_JYNX_CLOTHES, name = "jynx clothes"},
    {itemId = 12110, count = 100 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_YELLOW_TAIL, name = "yellow tail"},
    {itemId = 12112, count = 1000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_WATER_PENDANT, name = "water pendant"},
    {itemId = 14513, count = 800 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_FIRE_PENDANT, name = "fire pendant"},
    {itemId = 14510, count = 600 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_LEAF_PENDANT, name = "leaf pendant"},
    {itemId = 14511, count = 800 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_VENOM_PENDANT, name = "venom pendant"},
    {itemId = 14515, count = 750 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_POT_OF_WATER, name = "pot of water"},
    {itemId = 12113, count = 1000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_POT_OF_MOSS_MUG, name = "pot of moss mug"},
    {itemId = 14514, count = 450 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_FIRE_ORB, name = "fire orb"},
    {itemId = 14516, count = 500 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_WHITE_ORB, name = "white orb"},
    {itemId = 12123, count = 1000 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_CAULDRON_FUR, name = "fur"},
    {itemId = 12138, count = 1500 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_STONE_ORB, name = "stone orb"},
    {itemId = 12142, count = 1300 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_FEATHER, name = "feather"},
    {itemId = 12146, count = 666 - 1, globalStorage = GLOBAL_STORAGES.EVENT_HALLOWEEN_REAPER_CLOTH, name = "reaper cloth"},
}

local SPECIAL_POKEMON = {
  ["Pikachu"] = "Darkchu",
  ["Squirtle"] = "Squirsaur",
  ["Charmander"] = "Chartle",
  ["Bulbasaur"] = "Bulmander",
}
local SPECIAL_POKEMON_CHANCE = 10

--[[
--105 gyarados tail: 12086
300 pot of lava: 12087
75 bag of polen: 12089
120 bulb: 12090
200 leaf: 12091
130 razor fang: 12096
120 hull: 12097
80 microphone: 12099
1000 water gem: 12100
1000 fire element: 12101
1000 seed: 12102
500 screw: 12103
1000 bottle of poison: 12104
80 tangela hair: 12106
30 jynx clothes: 12109
30 yellow tail: 12110
140 water pendant: 12112
140 fire pendant: 14513
140 leaf pendant: 14510
140 venom pendant: 14511
300 pot of water: 14515
300 pot of moss mug: 12113
75 sharp beak: 12114
40 fire orb: 14514
40 white orb: 14516
400 fur: 12123
100 shadow orb: 12136
100 stone orb: 12138
110 feather: 12142
100 reaper cloth 12146
 ]]

HalloweenEvent.HALLOWEEN_BOX_REWARDS = {
    [28071] = {
        {itemid = 14461, count = 1, chance = 20000, unique = true}, -- halloween token

        {itemid = 27998, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28002, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28006, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28010, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28018, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28022, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28026, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28030, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28034, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28038, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28144, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28145, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28146, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28147, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28148, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28149, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28150, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28151, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28152, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28153, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28154, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28155, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 28070, count = 1, chance = 500, unique = nil}, -- empty enchanted ball

        {itemid = 18734, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18735, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18736, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19083, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19084, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19085, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25179, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25180, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25181, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25182, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25183, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25184, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 27938, count = 1, chance = 400, unique = nil}, -- ghost pillow backpack
        {itemid = 27939, count = 1, chance = 400, unique = nil}, -- haunted backpack
        {itemid = 27940, count = 1, chance = 400, unique = nil}, -- werewolf backpack

        {itemid = 27951, count = 1, chance = 500, unique = nil}, -- black treasure chest
        {itemid = 27952, count = 1, chance = 500, unique = nil}, -- blue treasure chest
        {itemid = 27953, count = 1, chance = 500, unique = nil}, -- green treasure chest
        {itemid = 27954, count = 1, chance = 500, unique = nil}, -- ocean treasure chest
        {itemid = 27955, count = 1, chance = 500, unique = nil}, -- orange treasure chest
        {itemid = 27956, count = 1, chance = 500, unique = nil}, -- pink treasure chest
        {itemid = 27957, count = 1, chance = 500, unique = nil}, -- purple treasure chest
        {itemid = 27958, count = 1, chance = 500, unique = nil}, -- red treasure chest
        {itemid = 27960, count = 1, chance = 500, unique = nil}, -- white treasure chest
        {itemid = 27961, count = 1, chance = 500, unique = nil}, -- yellow treasure chest

--        {itemid = 28156, count = 1, chance = 500, unique = nil}, -- imperial boat decoration kit
--        {itemid = 28157, count = 1, chance = 500, unique = nil}, -- kraken decoration kit
--        {itemid = 28158, count = 1, chance = 500, unique = nil}, -- pirate boat decoration kit
--        {itemid = 28159, count = 1, chance = 500, unique = nil}, -- elder god statue kit

        {itemid = 28076, count = 1, chance = 300, unique = nil}, -- asteca tribal doll
        {itemid = 28077, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28078, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28079, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28080, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28081, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28082, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28083, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28084, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28085, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28086, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28087, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28088, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28089, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll

        {itemid = 27970, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27972, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27974, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27976, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27978, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27980, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27982, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
    },
    [28072] = {
        {itemid = 14461, count = 1, chance = 20000, unique = true}, -- halloween token

        {itemid = 27998, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28002, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28006, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28010, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28018, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28022, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28026, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28030, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28034, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28038, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28144, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28145, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28146, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28147, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28148, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28149, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28150, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28151, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28152, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28153, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28154, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28155, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 28070, count = 1, chance = 500, unique = nil}, -- empty enchanted ball

        {itemid = 18734, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18735, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18736, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19083, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19084, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19085, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25179, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25180, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25181, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25182, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25183, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25184, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 27938, count = 1, chance = 400, unique = nil}, -- ghost pillow backpack
        {itemid = 27939, count = 1, chance = 400, unique = nil}, -- haunted backpack
        {itemid = 27940, count = 1, chance = 400, unique = nil}, -- werewolf backpack

        {itemid = 27951, count = 1, chance = 500, unique = nil}, -- black treasure chest
        {itemid = 27952, count = 1, chance = 500, unique = nil}, -- blue treasure chest
        {itemid = 27953, count = 1, chance = 500, unique = nil}, -- green treasure chest
        {itemid = 27954, count = 1, chance = 500, unique = nil}, -- ocean treasure chest
        {itemid = 27955, count = 1, chance = 500, unique = nil}, -- orange treasure chest
        {itemid = 27956, count = 1, chance = 500, unique = nil}, -- pink treasure chest
        {itemid = 27957, count = 1, chance = 500, unique = nil}, -- purple treasure chest
        {itemid = 27958, count = 1, chance = 500, unique = nil}, -- red treasure chest
        {itemid = 27960, count = 1, chance = 500, unique = nil}, -- white treasure chest
        {itemid = 27961, count = 1, chance = 500, unique = nil}, -- yellow treasure chest

        --        {itemid = 28156, count = 1, chance = 500, unique = nil}, -- imperial boat decoration kit
        --        {itemid = 28157, count = 1, chance = 500, unique = nil}, -- kraken decoration kit
        --        {itemid = 28158, count = 1, chance = 500, unique = nil}, -- pirate boat decoration kit
        --        {itemid = 28159, count = 1, chance = 500, unique = nil}, -- elder god statue kit

        {itemid = 28076, count = 1, chance = 300, unique = nil}, -- asteca tribal doll
        {itemid = 28077, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28078, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28079, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28080, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28081, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28082, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28083, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28084, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28085, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28086, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28087, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28088, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28089, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll

        {itemid = 27970, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27972, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27974, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27976, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27978, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27980, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27982, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
    },
    [28073] = {
        {itemid = 14461, count = 1, chance = 20000, unique = true}, -- halloween token

        {itemid = 27998, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28002, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28006, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28010, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28018, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28022, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28026, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28030, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28034, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28038, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28144, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28145, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28146, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28147, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28148, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28149, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28150, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28151, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28152, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28153, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28154, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28155, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 28070, count = 1, chance = 500, unique = nil}, -- empty enchanted ball

        {itemid = 18734, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18735, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18736, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19083, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19084, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19085, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25179, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25180, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25181, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25182, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25183, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25184, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 27938, count = 1, chance = 400, unique = nil}, -- ghost pillow backpack
        {itemid = 27939, count = 1, chance = 400, unique = nil}, -- haunted backpack
        {itemid = 27940, count = 1, chance = 400, unique = nil}, -- werewolf backpack

        {itemid = 27951, count = 1, chance = 500, unique = nil}, -- black treasure chest
        {itemid = 27952, count = 1, chance = 500, unique = nil}, -- blue treasure chest
        {itemid = 27953, count = 1, chance = 500, unique = nil}, -- green treasure chest
        {itemid = 27954, count = 1, chance = 500, unique = nil}, -- ocean treasure chest
        {itemid = 27955, count = 1, chance = 500, unique = nil}, -- orange treasure chest
        {itemid = 27956, count = 1, chance = 500, unique = nil}, -- pink treasure chest
        {itemid = 27957, count = 1, chance = 500, unique = nil}, -- purple treasure chest
        {itemid = 27958, count = 1, chance = 500, unique = nil}, -- red treasure chest
        {itemid = 27960, count = 1, chance = 500, unique = nil}, -- white treasure chest
        {itemid = 27961, count = 1, chance = 500, unique = nil}, -- yellow treasure chest

        --        {itemid = 28156, count = 1, chance = 500, unique = nil}, -- imperial boat decoration kit
        --        {itemid = 28157, count = 1, chance = 500, unique = nil}, -- kraken decoration kit
        --        {itemid = 28158, count = 1, chance = 500, unique = nil}, -- pirate boat decoration kit
        --        {itemid = 28159, count = 1, chance = 500, unique = nil}, -- elder god statue kit

        {itemid = 28076, count = 1, chance = 300, unique = nil}, -- asteca tribal doll
        {itemid = 28077, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28078, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28079, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28080, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28081, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28082, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28083, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28084, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28085, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28086, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28087, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28088, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28089, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll

        {itemid = 27970, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27972, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27974, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27976, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27978, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27980, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27982, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
    },
    [28074] = {
        {itemid = 14461, count = 1, chance = 20000, unique = true}, -- halloween token

        {itemid = 27998, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28002, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28006, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28010, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28018, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28022, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28026, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28030, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28034, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28038, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28144, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28145, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28146, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28147, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28148, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28149, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28150, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28151, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28152, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28153, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28154, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28155, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 28070, count = 1, chance = 500, unique = nil}, -- empty enchanted ball

        {itemid = 18734, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18735, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18736, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19083, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19084, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19085, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25179, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25180, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25181, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25182, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25183, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25184, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 27938, count = 1, chance = 400, unique = nil}, -- ghost pillow backpack
        {itemid = 27939, count = 1, chance = 400, unique = nil}, -- haunted backpack
        {itemid = 27940, count = 1, chance = 400, unique = nil}, -- werewolf backpack

        {itemid = 27951, count = 1, chance = 500, unique = nil}, -- black treasure chest
        {itemid = 27952, count = 1, chance = 500, unique = nil}, -- blue treasure chest
        {itemid = 27953, count = 1, chance = 500, unique = nil}, -- green treasure chest
        {itemid = 27954, count = 1, chance = 500, unique = nil}, -- ocean treasure chest
        {itemid = 27955, count = 1, chance = 500, unique = nil}, -- orange treasure chest
        {itemid = 27956, count = 1, chance = 500, unique = nil}, -- pink treasure chest
        {itemid = 27957, count = 1, chance = 500, unique = nil}, -- purple treasure chest
        {itemid = 27958, count = 1, chance = 500, unique = nil}, -- red treasure chest
        {itemid = 27960, count = 1, chance = 500, unique = nil}, -- white treasure chest
        {itemid = 27961, count = 1, chance = 500, unique = nil}, -- yellow treasure chest

        --        {itemid = 28156, count = 1, chance = 500, unique = nil}, -- imperial boat decoration kit
        --        {itemid = 28157, count = 1, chance = 500, unique = nil}, -- kraken decoration kit
        --        {itemid = 28158, count = 1, chance = 500, unique = nil}, -- pirate boat decoration kit
        --        {itemid = 28159, count = 1, chance = 500, unique = nil}, -- elder god statue kit

        {itemid = 28076, count = 1, chance = 300, unique = nil}, -- asteca tribal doll
        {itemid = 28077, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28078, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28079, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28080, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28081, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28082, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28083, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28084, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28085, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28086, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28087, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28088, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28089, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll

        {itemid = 27970, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27972, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27974, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27976, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27978, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27980, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27982, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
    },
    [28075] = {
        {itemid = 14461, count = 1, chance = 20000, unique = true}, -- halloween token

        {itemid = 27998, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28002, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28006, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28010, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28018, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28022, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28026, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28030, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28034, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28038, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28144, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28145, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28146, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28147, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28148, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28149, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28150, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28151, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28152, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28153, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28154, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 28155, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 28070, count = 1, chance = 500, unique = nil}, -- empty enchanted ball

        {itemid = 18734, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18735, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 18736, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19083, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19084, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 19085, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25179, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25180, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25181, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25182, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25183, count = 1, chance = 500, unique = nil}, -- black cat paint ticket
        {itemid = 25184, count = 1, chance = 500, unique = nil}, -- black cat paint ticket

        {itemid = 27938, count = 1, chance = 400, unique = nil}, -- ghost pillow backpack
        {itemid = 27939, count = 1, chance = 400, unique = nil}, -- haunted backpack
        {itemid = 27940, count = 1, chance = 400, unique = nil}, -- werewolf backpack

        {itemid = 27951, count = 1, chance = 500, unique = nil}, -- black treasure chest
        {itemid = 27952, count = 1, chance = 500, unique = nil}, -- blue treasure chest
        {itemid = 27953, count = 1, chance = 500, unique = nil}, -- green treasure chest
        {itemid = 27954, count = 1, chance = 500, unique = nil}, -- ocean treasure chest
        {itemid = 27955, count = 1, chance = 500, unique = nil}, -- orange treasure chest
        {itemid = 27956, count = 1, chance = 500, unique = nil}, -- pink treasure chest
        {itemid = 27957, count = 1, chance = 500, unique = nil}, -- purple treasure chest
        {itemid = 27958, count = 1, chance = 500, unique = nil}, -- red treasure chest
        {itemid = 27960, count = 1, chance = 500, unique = nil}, -- white treasure chest
        {itemid = 27961, count = 1, chance = 500, unique = nil}, -- yellow treasure chest

        --        {itemid = 28156, count = 1, chance = 500, unique = nil}, -- imperial boat decoration kit
        --        {itemid = 28157, count = 1, chance = 500, unique = nil}, -- kraken decoration kit
        --        {itemid = 28158, count = 1, chance = 500, unique = nil}, -- pirate boat decoration kit
        --        {itemid = 28159, count = 1, chance = 500, unique = nil}, -- elder god statue kit

        {itemid = 28076, count = 1, chance = 300, unique = nil}, -- asteca tribal doll
        {itemid = 28077, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28078, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28079, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28080, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28081, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28082, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28083, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28084, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28085, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28086, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28087, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28088, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll
        {itemid = 28089, count = 1, chance = 300, unique = nil}, -- darth giant pikachu doll

        {itemid = 27970, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27972, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27974, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27976, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27978, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27980, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
        {itemid = 27982, count = 1, chance = 300, unique = nil}, -- blue ghost lantern
    },
}

-- Methods
HalloweenEvent.getRemaingIngredientsMessage = function()
    local r = {}
    for _, ing in pairs(INGREDIENTS) do
        local current = tonumber(getStorage(ing.globalStorage))
        local remaing = ing.count - current
        if (remaing > 0) then
            r[#r + 1] = remaing
            r[#r + 1] = "x "
            r[#r + 1] = ing.name
            r[#r + 1] = ", "
        end
    end

    if (#r > 4) then
        r[#r - 4] = " and "
        r[#r] = "."
    elseif (#r == 0) then
        r[1] = "nothing! Now Hermitwo have the necessary to build the potion."
    else
        r[#r] = "."
    end

    return table.concat(r)
end

HalloweenEvent.isCauldronItemRequired = function(itemId)
    for _, ing in pairs(INGREDIENTS) do
        if (ing.itemId == itemId) then
            return tonumber(getStorage(ing.globalStorage)) < ing.count
        end
    end
    return false
end

HalloweenEvent.onDropIngredient = function(itemId, count)
    for _, ing in pairs(INGREDIENTS) do
        if (ing.itemId == itemId) then
            local current = tonumber(getStorage(ing.globalStorage))
            local req = ing.count - current
            doSetStorage(ing.globalStorage, current + count)
            if (count <= req) then
                return count
            else
                return req
            end
        end
    end
end

HalloweenEvent.onSpawn = function(cid)
  local name = getCreatureName(cid)
  if (SPECIAL_POKEMON[name] and getRandom(1, SPECIAL_POKEMON_CHANCE) <= 1) then
    local r = doCreateMonster(SPECIAL_POKEMON[name], getCreaturePosition(cid), false)
    if (not isBoolean(r)) then
      addEvent(doRemoveCreature, 1000, cid)
      setMonsterSpecialAbility(r, getPokemonRandomSpecialAbility(getCreatureName(r)))
      doSendMagicEffect(getCreaturePosition(r), EFFECT_TELEPORT_DOWN)
      return true
    end
  end

  return false
end

HalloweenEvent.onPlayerUseHalloweenBox = function(cid, item)
--    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.ANNIVERSARY_PRESENT)

    doRemoveItem(item.uid, 1)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Halloween Box contains: ")

    local nothing = true
    while (nothing) do
        for _, item in pairs(HalloweenEvent.HALLOWEEN_BOX_REWARDS[item.itemid]) do
            if (not item.chance or getRandom(RANDOM_CHANCE_MIN, RANDOM_CHANCE_MAX) <= item.chance) then
                local count = ((item.mincount and item.maxcount) and getRandom(item.mincount, item.maxcount) or
                        item.count)
                nothing = false
                doPlayerSafeAddItem(cid, item.itemid, count, true, item.unique)
                doDatalogHalloweenDrops(getPlayerGUID(cid), item.itemid, count, os.time())
                if (item.onReceive) then
                    item.onReceive(cid)
                end
            end
        end
    end

    if (nothing) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nothing.")
    end
end

HalloweenEvent.DAMAGE_MINIMUM_RATIO = 0.5
HalloweenEvent.DROP_CHANCE = 30000 -- 40%
HalloweenEvent.HALLOWEEN_BOX_ITEMIDS = {28071, 28072, 28073, 28074, 28075}

HalloweenEvent.onPlayerKill = function(cid, target, lastHit)
    if (not isPokemonName(getCreatureName(target)) or
            getCreatureDamageRatioByMaster(target, cid) < HalloweenEvent.DAMAGE_MINIMUM_RATIO) then
        return
    end

    if (getRandom(RANDOM_CHANCE_MIN, RANDOM_CHANCE_MAX) <= HalloweenEvent.DROP_CHANCE * (getMonsterLevel(target) / 100)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have found a halloween box.")
        doPlayerSafeAddItem(cid, table.random(HalloweenEvent.HALLOWEEN_BOX_ITEMIDS), 1, true, true)
    end
end
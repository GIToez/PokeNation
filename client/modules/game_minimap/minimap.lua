minimapWidget = nil
minimapButton = nil
minimapWindow = nil
otmm = true
preloaded = false
fullmapView = false
oldZoom = nil
oldPos = nil

local MAP_COMPOSITIONS, COMPOSITIONS = {}, {}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Viridian", position = {x = 3296, y = 560, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Pallet", position = {x = 3292, y = 799, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Pewter", position = {x = 3305, y = 296, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Cerulean", position = {x = 3888, y = 305, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Saffron", position = {x = 3938, y = 478, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Celadon", position = {x = 3700, y = 437, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Lavender", position = {x = 4191, y = 557, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Vermilion", position = {x = 3952, y = 637, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Fuchsia", position = {x = 3863, y = 845, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Cinnabar", position = {x = 3357, y = 1035, z = 7}}

--[[MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Grassland", position = {x = 3025, y = 887, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Waterland", position = {x = 2899, y = 715, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Fireland", position = {x = 2975, y = 413, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Frontier Island", position = {x = 3769, y = 117, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Psyland", position = {x = 4008, y = 127, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Flyland", position = {x = 3731, y = 389, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Iceland", position = {x = 3799, y = 713, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Ghostland", position = {x = 3582, y = 915, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Normaland", position = {x = 3367, y = 946, z = 7} }]]

MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Hamlin", position = {x = 3473, y = 1493, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Tarroco", position = {x = 3235, y = 1490, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Kumquat", position = {x = 3516, y = 1674, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Pummelo", position = {x = 3062, y = 1658, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Millsweet", position = {x = 3071, y = 1905, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Desert Island", position = {x = 2823, y = 1819, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Mandarin Island North", position = {x = 2966, y = 2197, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Mikan", position = {x = 2719, y = 2408, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Sunburst", position = {x = 3025, y = 2551, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Tangelo", position = {x = 2726, y = 2780, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Valencia", position = {x = 2985, y = 2949, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Pinkan", position = {x = 3265, y = 2784, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Fairchild", position = {x = 3473, y = 2496, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Mandarin Island South", position = {x = 3542, y = 3234, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Trovita", position = {x = 3339, y = 3191, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Shamouti", position = {x = 3524, y = 1937, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Cleopatra", position = {x = 3923, y = 1945, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Butwal", position = {x = 4102, y = 1777, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Ascorbia", position = {x = 4430, y = 1705, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Navel", position = {x = 4402, y = 2249, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Desert Island", position = {x = 4145, y = 2351, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Seven Grapefruit", position = {x = 4332, y = 2630, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Moro", position = {x = 4178, y = 2934, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Golden", position = {x = 3904, y = 3030, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Murcott", position = {x = 4121, y = 3233, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Desert Island", position = {x = 4001, y = 3458, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Kinow", position = {x = 3827, y = 2633, z = 7} }

MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Littleroot", position = {x = 513, y = 1832, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Oldale", position = {x = 519, y = 1709, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Petalburg", position = {x = 396, y = 1689, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Rustboro", position = {x = 256, y = 1506, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Dewford", position = {x = 408, y = 2005, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Slateport", position = {x = 728, y = 1787, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Mauville", position = {x = 777, y = 1451, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Verdanturf", position = {x = 544, y = 1510, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Fallarbor", position = {x = 475, y = 1143, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Lavaridge", position = {x = 572, y = 1326, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Fortree", position = {x = 996, y = 1151, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Lilycove", position = {x = 1354, y = 1313, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Mossdeep", position = {x = 1732, y = 1429, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Sootopolis", position = {x = 1576, y = 1547, z = 7}}
MAP_COMPOSITIONS[#MAP_COMPOSITIONS + 1] = {text = "Pacifidlog", position = {x = 1311, y = 1762, z = 7}}

MAPMARK_TICK = 0
MAPMARK_QUESTION = 1
MAPMARK_EXCLAMATION = 2
MAPMARK_STAR = 3
MAPMARK_CROSS = 4
MAPMARK_TEMPLE = 5
MAPMARK_KISS = 6
MAPMARK_SHOVEL = 7
MAPMARK_SWORD = 8
MAPMARK_FLAG = 9
MAPMARK_LOCK = 10
MAPMARK_BAG = 11
MAPMARK_SKULL = 12
MAPMARK_DOLLAR = 13
MAPMARK_REDNORTH = 14
MAPMARK_REDSOUTH = 15
MAPMARK_REDEAST = 16
MAPMARK_REDWEST = 17
MAPMARK_GREENNORTH = 18
MAPMARK_GREENSOUTH = 19

local GUIDES = {}
GUIDES["Tangelo"] = { -- Guide Cary
    {position = {x = 2745, y = 2829, z = 6}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 2756, y = 2819, z = 5}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 2764, y = 2831, z = 6}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 2724, y = 2857, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Mandarin North"] = { -- Guide Ross
    {position = {x = 2985, y = 2251, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 2939, y = 2231, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 2956, y = 2253, z = 5}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 2967, y = 2294, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Kumquat"] = { -- Guide Jay
    {position = {x = 3527, y = 1667, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 3516, y = 1694, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3490, y = 1717, z = 6}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3466, y = 1762, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Mikan"] = { -- Guide Everitt
    {position = {x = 2710, y = 2451, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 2758, y = 2437, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 2678, y = 2502, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Pummelo"] = { -- Guide Jocelyn
    {position = {x = 3050, y = 1697, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 3066, y = 1664, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3087, y = 1666, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3083, y = 1744, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Ascorbia"] = { -- Guide David
    {position = {x = 4410, y = 1745, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 4434, y = 1716, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 4420, y = 1728, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 4427, y = 1783, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Trovitopolis"] = { -- Guide Emmerson
    {position = {x = 3494, y = 3244, z = 6}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 3490, y = 3213, z = 6}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3468, y = 3221, z = 6}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3425, y = 3228, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Moro"] = { -- Guide Thurstan
    {position = {x = 4159, y = 2970, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 4164, y = 2955, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 4221, y = 2933, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 4261, y = 2927, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Sunburst"] = { -- Guide Brendan
    {position = {x = 3039, y = 2542, z = 5}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3037, y = 2641, z = 6}, type = MAPMARK_FLAG, description = "Travel Ship"},
}

GUIDES["Viridian"] = { -- Guide Chesley
    {position = {x = 3309, y = 538, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart and Bank"},
    {position = {x = 3295, y = 564, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3332, y = 550, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3267, y = 571, z = 7}, type = MAPMARK_BAG, description = "Berries Shop and Furniture Shop"},
    {position = {x = 3254, y = 565, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3270, y = 528, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
    {position = {x = 3265, y = 600, z = 7}, type = MAPMARK_STAR, description = "Travel Balloon"},
    {position = {x = 3299, y = 551, z = 7}, type = MAPMARK_STAR, description = "Ranger Club"},
}

GUIDES["Pewter"] = { -- Guide Emil
    {position = {x = 3336, y = 276, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart an Bank"},
    {position = {x = 3307, y = 296, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3257, y = 293, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3276, y = 254, z = 7}, type = MAPMARK_BAG, description = "Berries Shop"},
    {position = {x = 3292, y = 253, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3263, y = 281, z = 7}, type = MAPMARK_STAR, description = "Museum"},
    {position = {x = 3272, y = 316, z = 7}, type = MAPMARK_BAG, description = "Furniture Shop"},
    {position = {x = 3326, y = 246, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
    {position = {x = 3290, y = 291, z = 7}, type = MAPMARK_STAR, description = "Ranger Club"},
    {position = {x = 3336, y = 310, z = 7}, type = MAPMARK_STAR, description = "Travel Train"},
}

GUIDES["Cerulean"] = { -- Guide Maddox
    {position = {x = 3859, y = 295, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart and Bank"},
    {position = {x = 3884, y = 314, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3872, y = 331, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3919, y = 303, z = 7}, type = MAPMARK_BAG, description = "Bike Shop"},
    {position = {x = 3866, y = 339, z = 7}, type = MAPMARK_BAG, description = "Furniture Shop"},
    {position = {x = 3919, y = 265, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3864, y = 261, z = 7}, type = MAPMARK_STAR, description = "Daycare"},
    {position = {x = 3883, y = 249, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
    {position = {x = 3874, y = 308, z = 7}, type = MAPMARK_STAR, description = "Ranger Club"},
    {position = {x = 3939, y = 268, z = 7}, type = MAPMARK_STAR, description = "Travel Fly"},
    {position = {x = 3884, y = 273, z = 7}, type = MAPMARK_STAR, description = "Travel Train"},
    {position = {x = 3868, y = 271, z = 7}, type = MAPMARK_BAG, description = "Berry Shop"},
}

GUIDES["Saffron"] = { -- Guide Andie
    {position = {x = 3955, y = 482, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart and Bank"},
    {position = {x = 3942, y = 471, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3964, y = 448, z = 7}, type = MAPMARK_BAG, description = "Food Shop and Furniture Shop"},
    {position = {x = 3969, y = 462, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3876, y = 487, z = 7}, type = MAPMARK_STAR, description = "Silph Co."},
    {position = {x = 4006, y = 464, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
    {position = {x = 3895, y = 464, z = 7}, type = MAPMARK_STAR, description = "Travel Fly"},
    {position = {x = 3886, y = 464, z = 7}, type = MAPMARK_STAR, description = "Travel Balloon"},
    {position = {x = 3945, y = 454, z = 7}, type = MAPMARK_BAG, description = "Berry Shop"},
}

GUIDES["Celadon"] = { -- Guide Augustine
    {position = {x = 3677, y = 423, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart, Bank and Berries Shop"},
    {position = {x = 3701, y = 436, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3672, y = 415, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3662, y = 405, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3688, y = 405, z = 7}, type = MAPMARK_STAR, description = "Shopping"},
    {position = {x = 3729, y = 466, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
    {position = {x = 3689, y = 450, z = 7}, type = MAPMARK_STAR, description = "Ranger Club"},
    {position = {x = 3657, y = 476, z = 7}, type = MAPMARK_STAR, description = "Travel Fly"},
    {position = {x = 3630, y = 443, z = 7}, type = MAPMARK_STAR, description = "Casino"},
}

GUIDES["Vermilion"] = { -- Guide Ron
    {position = {x = 3925, y = 636, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 3968, y = 640, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3902, y = 643, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3965, y = 660, z = 7}, type = MAPMARK_BAG, description = "Berries Shop"},
    {position = {x = 3965, y = 627, z = 7}, type = MAPMARK_BAG, description = "Furnitures Shop"},
    {position = {x = 3929, y = 661, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3865, y = 637, z = 7}, type = MAPMARK_STAR, description = "S. S. Anne"},
    {position = {x = 4007, y = 639, z = 7}, type = MAPMARK_STAR, description = "Travel Fly"},
    {position = {x = 3902, y = 593, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
    {position = {x = 3941, y = 591, z = 7}, type = MAPMARK_STAR, description = "Ranger Club"},
}

GUIDES["Fuchsia"] = { -- Guide Weldon
    {position = {x = 3893, y = 842, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart and Bank"},
    {position = {x = 3860, y = 844, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3847, y = 841, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3828, y = 846, z = 7}, type = MAPMARK_BAG, description = "Berries Shop"},
    {position = {x = 3922, y = 794, z = 7}, type = MAPMARK_STAR, description = "Safari Zone Center"},
    {position = {x = 3857, y = 808, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3824, y = 802, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
    {position = {x = 3879, y = 854, z = 7}, type = MAPMARK_STAR, description = "Ranger Club"},
    {position = {x = 3841, y = 873, z = 7}, type = MAPMARK_BAG, description = "Furniture Shop"},
}

GUIDES["Cinnabar"] = { -- Guide Fran
    {position = {x = 3348, y = 1049, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart and Bank"},
    {position = {x = 3370, y = 1048, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 3336, y = 1015, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 3384, y = 1030, z = 7}, type = MAPMARK_BAG, description = "Berries Shop"},
    {position = {x = 3366, y = 1006, z = 7}, type = MAPMARK_SWORD, description = "GYM"},
    {position = {x = 3373, y = 1075, z = 7}, type = MAPMARK_STAR, description = "S. S. Anne"},
    {position = {x = 3398, y = 1000, z = 7}, type = MAPMARK_STAR, description = "Guild House"},
}

GUIDES["Lavender"] = { -- Guide Darby
    {position = {x = 4170, y = 572, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart and Bank"},
    {position = {x = 4188, y = 554, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 4215, y = 574, z = 7}, type = MAPMARK_BAG, description = "Food Shop"},
    {position = {x = 4136, y = 553, z = 7}, type = MAPMARK_STAR, description = "Travel Fly"},
    {position = {x = 4179, y = 552, z = 7}, type = MAPMARK_STAR, description = "Ranger Club"},
    {position = {x = 4210, y = 551, z = 7}, type = MAPMARK_BAG, description = "Berries Shop"},
}

GUIDES["Tutorial"] = {
    {position = {x = 5018, y = 758, z = 7}, type = MAPMARK_DOLLAR, description = "Poke Mart"},
    {position = {x = 5033, y = 741, z = 7}, type = MAPMARK_TEMPLE, description = "Pokemon Center"},
    {position = {x = 5020, y = 788, z = 7}, type = MAPMARK_STAR, description = "Professor Oak Lab"},
}

local guideEnabled = true
local guideMarks = {}

local function removeGuides()
    for k, v in pairs(guideMarks) do
        v:destroy()
    end
    guideMarks = {}
end

local function addGuides()
    for k, city in pairs(GUIDES) do
        for _, mark in pairs(city) do
            guideMarks[#guideMarks + 1] = minimapWidget:addFlag(mark.position, mark.type, tr(mark.description))
        end
    end
end

function setGuidesDisplay(v)
    guideEnabled = v
    if (not guideEnabled) then
        removeGuides()
    end
end

function init()
  minimapButton = modules.client_topmenu.addRightGameToggleButton('minimapButton', tr('Minimap') .. ' (Ctrl+M)', '/images/topbuttons/minimap', toggle)
  minimapButton:setOn(true)

  minimapWindow = g_ui.loadUI('minimap', modules.game_interface.getRightPanel())
  minimapWindow:setContentMinimumHeight(64)

  minimapWidget = minimapWindow:recursiveGetChildById('minimap')

  local gameRootPanel = modules.game_interface.getRootPanel()
  g_keyboard.bindKeyPress('Alt+Left', function() minimapWidget:move(1,0) end, gameRootPanel)
  g_keyboard.bindKeyPress('Alt+Right', function() minimapWidget:move(-1,0) end, gameRootPanel)
  g_keyboard.bindKeyPress('Alt+Up', function() minimapWidget:move(0,1) end, gameRootPanel)
  g_keyboard.bindKeyPress('Alt+Down', function() minimapWidget:move(0,-1) end, gameRootPanel)
  g_keyboard.bindKeyDown('Ctrl+M', toggle)
  g_keyboard.bindKeyDown('Ctrl+Shift+M', toggleFullMap)
  g_keyboard.bindKeyDown('Escape', toggleFullMapVisible)

  minimapWindow:setup()

  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  connect(LocalPlayer, {
    onPositionChange = updateCameraPosition
  })

  if g_game.isOnline() then
    online()
  end
end

function terminate()
  if g_game.isOnline() then
    saveMap()
  end

  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  disconnect(LocalPlayer, {
    onPositionChange = updateCameraPosition
  })

  local gameRootPanel = modules.game_interface.getRootPanel()
  g_keyboard.unbindKeyPress('Alt+Left', gameRootPanel)
  g_keyboard.unbindKeyPress('Alt+Right', gameRootPanel)
  g_keyboard.unbindKeyPress('Alt+Up', gameRootPanel)
  g_keyboard.unbindKeyPress('Alt+Down', gameRootPanel)
  g_keyboard.unbindKeyDown('Ctrl+M')
  g_keyboard.unbindKeyDown('Ctrl+Shift+M')

  minimapWindow:destroy()
  minimapButton:destroy()
end

function toggle()
  if minimapButton:isOn() then
    minimapWindow:close()
    minimapButton:setOn(false)
  else
    minimapWindow:open()
    minimapButton:setOn(true)
  end
end

function onMiniWindowClose()
  minimapButton:setOn(false)
end

function preload()
  loadMap(false)
  preloaded = true
end

function online()
  loadMap(not preloaded)
  updateCameraPosition()
end

function offline()
  saveMap()
end

local function loadCompositions()
    g_minimap.loadImage('/images/map', {x = 0, y = 0, z = 7}, 0.5)

    for _, composition in pairs(MAP_COMPOSITIONS) do
        local flag = g_ui.createWidget('MinimapFlag')
        minimapWidget:insertChild(1, flag)
        flag.pos = composition.position
        flag:setText(composition.text)
        flag:setFont("sans-bold-16px")
        flag:setTextAutoResize(true)
        flag:setVisible(false)
        minimapWidget:centerInPosition(flag, flag.pos)
        COMPOSITIONS[#COMPOSITIONS + 1] = flag
    end
end

local function toggleCompositions()
    for _, composition in pairs(COMPOSITIONS) do
        composition:setVisible(fullmapView)
    end
end

function loadMap(clean, ignoreConfig)
  local protocolVersion = g_game.getProtocolVersion()

  if clean then
    g_minimap.clean()
  end

  if (not ignoreConfig) then
      if otmm then
        local minimapFile = '/minimap.otmm'
        if g_resources.fileExists(minimapFile) then
          g_minimap.loadOtmm(minimapFile)
        end
      else
        local minimapFile = '/minimap_' .. protocolVersion .. '.otcm'
        if g_resources.fileExists(minimapFile) then
          g_map.loadOtcm(minimapFile)
        end
      end
  end
  loadCompositions()
  removeGuides()
  if (guideEnabled) then
    addGuides()
  end
  minimapWidget:load()
end

function saveMap()
  local protocolVersion = g_game.getProtocolVersion()
  if otmm then
    local minimapFile = '/minimap.otmm'
    g_minimap.saveOtmm(minimapFile)
  else
    local minimapFile = '/minimap_' .. protocolVersion .. '.otcm'
    g_map.saveOtcm(minimapFile)
  end
  minimapWidget:save()
end

function updateCameraPosition()
  local player = g_game.getLocalPlayer()
  if not player then return end
  local pos = player:getPosition()
  if not pos then return end
  if not minimapWidget:isDragging() then
    if not fullmapView then
      minimapWidget:setCameraPosition(player:getPosition())
    end
    minimapWidget:setCrossPosition(player:getPosition())
  end
end

function toggleFullMap()
  if not fullmapView then
    fullmapView = true
    minimapWindow:hide()
    minimapWidget:setParent(modules.game_interface.getRootPanel())
    minimapWidget:fill('parent')
    minimapWidget:setAlternativeWidgetsVisible(true)
    minimapWidget:setOpacity(0.7)
  else
    fullmapView = false
    minimapWidget:setParent(minimapWindow:getChildById('contentsPanel'))
    minimapWidget:fill('parent')
    minimapWindow:show()
    minimapWidget:setAlternativeWidgetsVisible(false)
    minimapWidget:setOpacity(1.0)
  end

  local zoom = oldZoom or 0
  local pos = oldPos or minimapWidget:getCameraPosition()
  oldZoom = minimapWidget:getZoom()
  oldPos = minimapWidget:getCameraPosition()
  minimapWidget:setZoom(zoom)
  minimapWidget:setCameraPosition(pos)
  toggleCompositions()
end

function toggleFullMapVisible()
    if (fullmapView) then
        toggleFullMap()
    end
end

function reset()
    local messageBox
    local defaultCallback = function() messageBox:ok() end
    messageBox = UIMessageBox.display(tr("Map reset"), tr("You really want to reset the map?"),
        {
            {text=tr('Yes'), callback=function()
                minimapWidget:removeFlags()
                saveMap()
                loadMap(true, true)
                displayInfoBox(tr('Map reset'), tr('The map has been reseted!'))
                defaultCallback()
            end},
            {text=tr('No'), callback=defaultCallback}
        }, defaultCallback, defaultCallback)
end
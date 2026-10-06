MASTERY_REQUIRED_PLATE_POINTS = 100

MASTERYID_BLAZE = 1
MASTERYID_HURRICANE = 2
MASTERYID_VOLTAGIC = 3
MASTERYID_SPECTRUM = 4
MASTERYID_VITAL = 5
MASTERYID_GAIA = 6
MASTERYID_AVALANCHE = 7
MASTERYID_HEREMIT = 8
MASTERYID_ZEN = 9

VOCATIONID_TRAINER = 1
VOCATIONID_BLAZESTARTER = 10
VOCATIONID_BLAZEEMBER = 11
VOCATIONID_BLAZEBURST = 12
VOCATIONID_BLAZEFLARE = 13
VOCATIONID_BLAZESTORM = 14
VOCATIONID_BLAZEINFERNO = 15
VOCATIONID_HURRICANESTARTER = 20
VOCATIONID_HURRICANEWIND = 21
VOCATIONID_HURRICANEGALE = 22
VOCATIONID_HURRICANEACE = 23
VOCATIONID_HURRICANETWISTER = 24
VOCATIONID_HURRICANETORNADO = 25
VOCATIONID_VOLTAGICSTARTER = 30
VOCATIONID_VOLTAGICSPARK = 31
VOCATIONID_VOLTAGICCHARGE = 32
VOCATIONID_VOLTAGICSTRIKE = 33
VOCATIONID_VOLTAGICBOLT = 34
VOCATIONID_VOLTAGICRISE = 35
VOCATIONID_SPECTRUMSTARTER = 40
VOCATIONID_SPECTRUMVIPER = 41
VOCATIONID_SPECTRUMGAS = 42
VOCATIONID_SPECTRUMASSASSIN = 43
VOCATIONID_SPECTRUMVENOM = 44
VOCATIONID_SPECTRUMVIRUS = 45
VOCATIONID_VITALSTARTER = 50
VOCATIONID_VITALPACIFIC = 51
VOCATIONID_VITALADEPT = 52
VOCATIONID_VITALCOMBAT = 53
VOCATIONID_VITALSMASHER = 54
VOCATIONID_VITALRAGE = 55
VOCATIONID_GAIASTARTER = 60
VOCATIONID_GAIAFOREST = 61
VOCATIONID_GAIAJUNGLE = 62
VOCATIONID_GAIACATCHER = 63
VOCATIONID_GAIAEXOARMOR = 64
VOCATIONID_GAIANATURAL = 65
VOCATIONID_AVALANCHESTARTER = 70
VOCATIONID_AVALANCHECOLDHEART = 71
VOCATIONID_AVALANCHEREEF = 72
VOCATIONID_AVALANCHEOCEANBORN = 73
VOCATIONID_AVALANCHECRUSTACEA = 74
VOCATIONID_AVALANCHELEAVIATHAN = 75
VOCATIONID_HEREMITSTARTER = 80
VOCATIONID_HEREMITMINER = 81
VOCATIONID_HEREMITGUARD = 82
VOCATIONID_HEREMITTOMB = 83
VOCATIONID_HEREMITEARTHQUAKE = 84
VOCATIONID_HEREMITEDGE = 85
VOCATIONID_ZENSTARTER = 90
VOCATIONID_ZENAMNESIA = 91
VOCATIONID_ZENTELEPATIC = 92
VOCATIONID_ZENKINESIS = 93
VOCATIONID_ZENINTELLECT = 94
VOCATIONID_ZENLUNAR = 95

MASTERYDUNGEONID_FIGHT = 1
MASTERYDUNGEONID_FIRE = 2
MASTERYDUNGEONID_FLYING = 3
MASTERYDUNGEONID_GRASS = 4
MASTERYDUNGEONID_GROUND = 5
MASTERYDUNGEONID_ICE = 6
MASTERYDUNGEONID_NORMAL = 7
MASTERYDUNGEONID_POISON = 8
MASTERYDUNGEONID_ROCK = 9
MASTERYDUNGEONID_WATER = 10
MASTERYDUNGEONID_ELECTRICSTEEL = 11

MASTERY_ADVANTAGES = {
    BURN_DAMAGE = 0,
    FLY_SPEED = 1,
    FIND_WITHOUT_ENERGY = 2,
    EVASION_CHANCE = 3,
    PASSIVE_ENERGY_REGENERATION = 4,
    PARALYZE_DURATION = 5,
    POISON_DAMAGE = 6,
    RIDE_SPEED = 7,
    BUFF_DURATION = 7,
    FOOD_REGENERATION = 8,
    SURF_SPEED = 9,
    DIVE_SPEED = 10,
    FREEZE_CHANCE = 11,
    LOW_ACCURACY_DURATION = 12,
    BLINK_COOLDOWN = 13,
    TELEPORT_COOLDOWN = 14,
    LEVITATE_SPEED = 15
}

local storages = { -- The same storages to all masterys
    requiredStones = 8053,
    requiredTokens = 8054,
    requiredDungeon = 8055
}

local MASTERYS = {
    [MASTERYID_BLAZE] = {
        requiredLevel = 85,
        basePosition = {x = 4710, y = 295, z = 7},
        id = MASTERYID_BLAZE,
        requiredStones = {
            {itemid = 12229, count = 12} -- Flame Plate
        },
        token = 14740,
        elements = {ELEMENT_FIRE},
        dungeons = {MASTERYDUNGEONID_WATER, MASTERYDUNGEONID_FIRE, MASTERYDUNGEONID_ROCK},
        ranks = {
            [VOCATIONID_BLAZESTARTER] = {vocationId = VOCATIONID_BLAZESTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_BLAZEEMBER, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_BLAZEEMBER] = {vocationId = VOCATIONID_BLAZEEMBER, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_BLAZEBURST, dungeonLevel = 70, requiredTokens = 9, outfits = {906, 907}},
            [VOCATIONID_BLAZEBURST] = {vocationId = VOCATIONID_BLAZEBURST, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_BLAZEFLARE, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_BLAZEFLARE] = {vocationId = VOCATIONID_BLAZEFLARE, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_BLAZESTORM, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_BLAZESTORM] = {vocationId = VOCATIONID_BLAZESTORM, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_BLAZEINFERNO, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_BLAZEINFERNO] = {vocationId = VOCATIONID_BLAZEINFERNO, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {924, 925}},
        },
        advantages = {MASTERY_ADVANTAGES.BURN_DAMAGE},
        advantagesRank = VOCATIONID_BLAZESTORM
    },
    [MASTERYID_HURRICANE] = {
        requiredLevel = 85,
        basePosition = {x = 4760, y = 293, z = 7},
        id = MASTERYID_HURRICANE,
        requiredStones = {
            {itemid = 18081, count = 10}, -- Sky Plate
            {itemid = 12240, count = 1} -- Draco Plate
        },
        token = 14741,
        elements = {ELEMENT_FLYING, ELEMENT_DRAGON},
        dungeons = {MASTERYDUNGEONID_ELECTRICSTEEL},
        ranks = {
            [VOCATIONID_HURRICANESTARTER] = {vocationId = VOCATIONID_HURRICANESTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_HURRICANEWIND, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_HURRICANEWIND] = {vocationId = VOCATIONID_HURRICANEWIND, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_HURRICANEGALE, dungeonLevel = 70, requiredTokens = 9, outfits = {908, 909}},
            [VOCATIONID_HURRICANEGALE] = {vocationId = VOCATIONID_HURRICANEGALE, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_HURRICANEACE, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_HURRICANEACE] = {vocationId = VOCATIONID_HURRICANEACE, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_HURRICANETWISTER, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_HURRICANETWISTER] = {vocationId = VOCATIONID_HURRICANETWISTER, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_HURRICANETORNADO, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_HURRICANETORNADO] = {vocationId = VOCATIONID_HURRICANETORNADO, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {926, 927}},
        },
        advantages = {MASTERY_ADVANTAGES.FLY_SPEED, MASTERY_ADVANTAGES.FIND_WITHOUT_ENERGY, MASTERY_ADVANTAGES.EVASION_CHANCE},
        advantagesRank = VOCATIONID_HURRICANETWISTER
    },
    [MASTERYID_VOLTAGIC] = {
        requiredLevel = 85,
        basePosition = {x = 4711, y = 348, z = 7},
        id = MASTERYID_VOLTAGIC,
        requiredStones = {
            {itemid = 12237, count = 10}, -- Zap Plate
            {itemid = 17814, count = 1}, -- Iron Plate
        },
        token = 14742,
        elements = {ELEMENT_ELECTRIC, ELEMENT_STEEL},
        dungeons = {MASTERYDUNGEONID_GROUND, MASTERYDUNGEONID_GRASS, MASTERYDUNGEONID_ELECTRICSTEEL},
        ranks = {
            [VOCATIONID_VOLTAGICSTARTER] = {vocationId = VOCATIONID_VOLTAGICSTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_VOLTAGICSPARK, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_VOLTAGICSPARK] = {vocationId = VOCATIONID_VOLTAGICSPARK, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_VOLTAGICCHARGE, dungeonLevel = 70, requiredTokens = 9, outfits = {910, 911}},
            [VOCATIONID_VOLTAGICCHARGE] = {vocationId = VOCATIONID_VOLTAGICCHARGE, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_VOLTAGICSTRIKE, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_VOLTAGICSTRIKE] = {vocationId = VOCATIONID_VOLTAGICSTRIKE, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_VOLTAGICBOLT, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_VOLTAGICBOLT] = {vocationId = VOCATIONID_VOLTAGICBOLT, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_VOLTAGICRISE, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_VOLTAGICRISE] = {vocationId = VOCATIONID_VOLTAGICRISE, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {928, 929}},
        },
        advantages = {MASTERY_ADVANTAGES.PASSIVE_ENERGY_REGENERATION, MASTERY_ADVANTAGES.PARALYZE_DURATION},
        advantagesRank = VOCATIONID_VOLTAGICBOLT
    },
    [MASTERYID_SPECTRUM] = {
        requiredLevel = 85,
        basePosition = {x = 4760, y = 351, z = 7},
        id = MASTERYID_SPECTRUM,
        requiredStones = {
            {itemid = 12235, count = 6}, -- Toxic Plate
            {itemid = 18082, count = 4} -- Spooky Plate
        },
        token = 14743,
        elements = {ELEMENT_GHOST, ELEMENT_POISON},
        dungeons = {MASTERYDUNGEONID_POISON, MASTERYDUNGEONID_GROUND, MASTERYDUNGEONID_ROCK, MASTERYDUNGEONID_ELECTRICSTEEL},
        ranks = {
            [VOCATIONID_SPECTRUMSTARTER] = {vocationId = VOCATIONID_SPECTRUMSTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_SPECTRUMVIPER, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_SPECTRUMVIPER] = {vocationId = VOCATIONID_SPECTRUMVIPER, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_SPECTRUMGAS, dungeonLevel = 80, requiredTokens = 9, outfits = {912, 913}},
            [VOCATIONID_SPECTRUMGAS] = {vocationId = VOCATIONID_SPECTRUMGAS, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_SPECTRUMASSASSIN, dungeonLevel = 85, requiredTokens = 18},
            [VOCATIONID_SPECTRUMASSASSIN] = {vocationId = VOCATIONID_SPECTRUMASSASSIN, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_SPECTRUMVENOM, dungeonLevel = 90, requiredTokens = 24},
            [VOCATIONID_SPECTRUMVENOM] = {vocationId = VOCATIONID_SPECTRUMVENOM, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_SPECTRUMVIRUS, dungeonLevel = 95, requiredTokens = 30},
            [VOCATIONID_SPECTRUMVIRUS] = {vocationId = VOCATIONID_SPECTRUMVIRUS, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 100, requiredTokens = 42, outfits = {930, 931}},
        },
        advantages = {MASTERY_ADVANTAGES.POISON_DAMAGE, MASTERY_ADVANTAGES.LEVITATE_SPEED},
        advantagesRank = VOCATIONID_SPECTRUMVENOM
    },
    [MASTERYID_VITAL] = {
        requiredLevel = 85,
        basePosition = {x = 4757, y = 240, z = 7},
        id = MASTERYID_VITAL,
        requiredStones = {
            {itemid = 12232, count = 10}, -- Love Plate
            {itemid = 12243, count = 4} -- Fist Plate
        },
        token = 14744,
        elements = {ELEMENT_FIGHT, ELEMENT_NORMAL, ELEMENT_FAIRY},
        dungeons = {MASTERYDUNGEONID_FLYING, MASTERYDUNGEONID_POISON},
        ranks = {
            [VOCATIONID_VITALSTARTER] = {vocationId = VOCATIONID_VITALSTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_VITALPACIFIC, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_VITALPACIFIC] = {vocationId = VOCATIONID_VITALPACIFIC, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_VITALADEPT, dungeonLevel = 70, requiredTokens = 9, outfits = {914, 915}},
            [VOCATIONID_VITALADEPT] = {vocationId = VOCATIONID_VITALADEPT, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_VITALCOMBAT, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_VITALCOMBAT] = {vocationId = VOCATIONID_VITALCOMBAT, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_VITALSMASHER, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_VITALSMASHER] = {vocationId = VOCATIONID_VITALSMASHER, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_VITALRAGE, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_VITALRAGE] = {vocationId = VOCATIONID_VITALRAGE, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {932, 933}},
        },
        advantages = {MASTERY_ADVANTAGES.RIDE_SPEED, MASTERY_ADVANTAGES.BUFF_DURATION},
        advantagesRank = VOCATIONID_VITALSMASHER
    },
    [MASTERYID_GAIA] = {
        requiredLevel = 85,
        basePosition = {x = 4808, y = 243, z = 7},
        id = MASTERYID_GAIA,
        requiredStones = {
            {itemid = 12231, count = 7}, -- Meadow Plate
            {itemid = 12241, count = 4} -- Insect Plate
        },
        token = 14745,
        elements = {ELEMENT_GRASS, ELEMENT_BUG},
        dungeons = {MASTERYDUNGEONID_FIGHT, MASTERYDUNGEONID_FLYING, MASTERYDUNGEONID_POISON, MASTERYDUNGEONID_ELECTRICSTEEL, MASTERYDUNGEONID_FIRE},
        ranks = {
            [VOCATIONID_GAIASTARTER] = {vocationId = VOCATIONID_GAIASTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_GAIAFOREST, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_GAIAFOREST] = {vocationId = VOCATIONID_GAIAFOREST, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_GAIAJUNGLE, dungeonLevel = 70, requiredTokens = 9, outfits = {916, 917}},
            [VOCATIONID_GAIAJUNGLE] = {vocationId = VOCATIONID_GAIAJUNGLE, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_GAIACATCHER, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_GAIACATCHER] = {vocationId = VOCATIONID_GAIACATCHER, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_GAIAEXOARMOR, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_GAIAEXOARMOR] = {vocationId = VOCATIONID_GAIAEXOARMOR, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_GAIANATURAL, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_GAIANATURAL] = {vocationId = VOCATIONID_GAIANATURAL, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {934, 935}},
        },
        advantages = {MASTERY_ADVANTAGES.FOOD_REGENERATION},
        advantagesRank = VOCATIONID_GAIAEXOARMOR
    },
    [MASTERYID_AVALANCHE] = {
        requiredLevel = 85,
        basePosition = {x = 4811, y = 296, z = 7},
        id = MASTERYID_AVALANCHE,
        requiredStones = {
            {itemid = 12236, count = 6}, -- Icicle Plate
            {itemid = 12230, count = 6} -- Splash Plate
        },
        token = 14746,
        elements = {ELEMENT_ICE, ELEMENT_WATER},
        dungeons = {MASTERYDUNGEONID_WATER, MASTERYDUNGEONID_GRASS},
        ranks = {
            [VOCATIONID_AVALANCHESTARTER] = {vocationId = VOCATIONID_AVALANCHESTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_AVALANCHECOLDHEART, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_AVALANCHECOLDHEART] = {vocationId = VOCATIONID_AVALANCHECOLDHEART, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_AVALANCHEREEF, dungeonLevel = 70, requiredTokens = 9, outfits = {918, 919}},
            [VOCATIONID_AVALANCHEREEF] = {vocationId = VOCATIONID_AVALANCHEREEF, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_AVALANCHEOCEANBORN, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_AVALANCHEOCEANBORN] = {vocationId = VOCATIONID_AVALANCHEOCEANBORN, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_AVALANCHECRUSTACEA, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_AVALANCHECRUSTACEA] = {vocationId = VOCATIONID_AVALANCHECRUSTACEA, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_AVALANCHELEAVIATHAN, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_AVALANCHELEAVIATHAN] = {vocationId = VOCATIONID_AVALANCHELEAVIATHAN, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {936, 937}},
        },
        advantages = {MASTERY_ADVANTAGES.SURF_SPEED, MASTERY_ADVANTAGES.DIVE_SPEED, MASTERY_ADVANTAGES.FREEZE_CHANCE},
        advantagesRank = VOCATIONID_AVALANCHECRUSTACEA
    },
    [MASTERYID_HEREMIT] = {
        requiredLevel = 85,
        basePosition = {x = 4812, y = 349, z = 7},
        id = MASTERYID_HEREMIT,
        requiredStones = {
            {itemid = 13807, count = 6}, -- Earth Plate
            {itemid = 12234, count = 6} -- Stone Plate
        },
        token = 14747,
        elements = {ELEMENT_GROUND, ELEMENT_ROCK},
        dungeons = {MASTERYDUNGEONID_FIGHT, MASTERYDUNGEONID_GROUND},
        ranks = {
            [VOCATIONID_HEREMITSTARTER] = {vocationId = VOCATIONID_HEREMITSTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_HEREMITMINER, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_HEREMITMINER] = {vocationId = VOCATIONID_HEREMITMINER, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_HEREMITGUARD, dungeonLevel = 70, requiredTokens = 9, outfits = {920, 921}},
            [VOCATIONID_HEREMITGUARD] = {vocationId = VOCATIONID_HEREMITGUARD, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_HEREMITTOMB, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_HEREMITTOMB] = {vocationId = VOCATIONID_HEREMITTOMB, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_HEREMITEARTHQUAKE, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_HEREMITEARTHQUAKE] = {vocationId = VOCATIONID_HEREMITEARTHQUAKE, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_HEREMITEDGE, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_HEREMITEDGE] = {vocationId = VOCATIONID_HEREMITEDGE, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {938, 939}},
        },
        advantages = {MASTERY_ADVANTAGES.LOW_ACCURACY_DURATION},
        advantagesRank = VOCATIONID_HEREMITEARTHQUAKE
    },
    [MASTERYID_ZEN] = {
        requiredLevel = 85,
        basePosition = {x = 4709, y = 238, z = 7},
        id = MASTERYID_ZEN,
        requiredStones = {
            {itemid = 12233, count = 8}, -- Mind Plate
            {itemid = 12242, count = 8}, -- Dread Plate
        },
        token = 14748,
        elements = {ELEMENT_PSYCHIC, ELEMENT_DARK},
        dungeons = {MASTERYDUNGEONID_ELECTRICSTEEL},
        ranks = {
            [VOCATIONID_ZENSTARTER] = {vocationId = VOCATIONID_ZENSTARTER, bonusAtk = 0, bonusDef = 0, requiredLevel = 85, next = VOCATIONID_ZENAMNESIA, dungeonLevel = 0, requiredTokens = 0},
            [VOCATIONID_ZENAMNESIA] = {vocationId = VOCATIONID_ZENAMNESIA, bonusAtk = 1, bonusDef = 1, requiredLevel = 85, next = VOCATIONID_ZENTELEPATIC, dungeonLevel = 70, requiredTokens = 9, outfits = {922, 923}},
            [VOCATIONID_ZENTELEPATIC] = {vocationId = VOCATIONID_ZENTELEPATIC, bonusAtk = 3, bonusDef = 3, requiredLevel = 100, next = VOCATIONID_ZENKINESIS, dungeonLevel = 75, requiredTokens = 18},
            [VOCATIONID_ZENKINESIS] = {vocationId = VOCATIONID_ZENKINESIS, bonusAtk = 6, bonusDef = 6, requiredLevel = 110, next = VOCATIONID_ZENINTELLECT, dungeonLevel = 80, requiredTokens = 24},
            [VOCATIONID_ZENINTELLECT] = {vocationId = VOCATIONID_ZENINTELLECT, bonusAtk = 12, bonusDef = 12, requiredLevel = 120, next = VOCATIONID_ZENLUNAR, dungeonLevel = 85, requiredTokens = 30},
            [VOCATIONID_ZENLUNAR] = {vocationId = VOCATIONID_ZENLUNAR, bonusAtk = 20, bonusDef = 20, requiredLevel = 130, next = nil, dungeonLevel = 90, requiredTokens = 42, outfits = {940, 941}},
        },
        advantages = {MASTERY_ADVANTAGES.BLINK_COOLDOWN, MASTERY_ADVANTAGES.TELEPORT_COOLDOWN},
        advantagesRank = VOCATIONID_ZENINTELLECT
    },
}

local POINTS_PER_PLATE = {}
POINTS_PER_PLATE[12231] = 5 -- "meadow plate"
POINTS_PER_PLATE[13807]= 5 -- "earth plate"
POINTS_PER_PLATE[12235] = 8 -- "toxic plate"
POINTS_PER_PLATE[12230] = 10 -- "splash plate"
POINTS_PER_PLATE[12237] = 10 -- "zap plate"
POINTS_PER_PLATE[12229] =10 -- "flame plate"
POINTS_PER_PLATE[12234] = 10 -- "stone plate"
POINTS_PER_PLATE[12232] = 10 -- "love plate"
POINTS_PER_PLATE[12241] = 12 -- "insect plate"
POINTS_PER_PLATE[18081] = 12 -- "sky plate"
POINTS_PER_PLATE[12243] = 15 -- "fist plate"
POINTS_PER_PLATE[17814] = 15 -- "iron plate"
POINTS_PER_PLATE[12242] = 15 -- "dread plate"
POINTS_PER_PLATE[12233] = 15 -- "mind plate"
POINTS_PER_PLATE[12236] = 20 -- "icicle plate"
POINTS_PER_PLATE[18082] = 40 -- "spooky plate"
POINTS_PER_PLATE[12240] = 100 -- "draco plate"

-- Methods
function getPlayerMastery(cid)
    local v = getPlayerVocation(cid)
    if (v >= VOCATIONID_BLAZESTARTER) then
        for i, mastery in ipairs(MASTERYS) do
            if (mastery.ranks[v]) then
                return mastery.id
            end
        end
    end
    return nil
end

function getPlayerMasteryRank(cid)
    local r = getPlayerVocation(cid)
    return (r >= VOCATIONID_BLAZESTARTER and r or nil)
end

function getMasteryRankBonusAttack(mastery, masteryRank)
    return MASTERYS[mastery].ranks[masteryRank].bonusAtk / 100
end

function getMasteryRankBonusDefense(mastery, masteryRank)
    return MASTERYS[mastery].ranks[masteryRank].bonusDef / 100
end

function getMasteryRankNext(mastery, masteryRank)
    return MASTERYS[mastery].ranks[masteryRank].next
end

function getMasteryRankRequiredTokens(mastery, masteryRank)
    return MASTERYS[mastery].ranks[masteryRank].requiredTokens
end

function getMasteryToken(mastery)
    return MASTERYS[mastery].token
end

function getMasteryRequiredStones(mastery)
    return MASTERYS[mastery].requiredStones
end

function getMasteryRankRequiredLevel(mastery, masteryRank)
    return MASTERYS[mastery].ranks[masteryRank].requiredLevel
end

function getMasteryRequiredLevel(mastery)
    return MASTERYS[mastery].requiredLevel
end

local function getMasteryBasePosition(mastery)
    return MASTERYS[mastery].basePosition
end

function getMasteryElements(mastery)
    return MASTERYS[mastery].elements
end

local function getMasteryOutfits(mastery)
    local outfits = {}
    for i, rank in pairs(MASTERYS[mastery].ranks) do
        if (rank.outfits) then
            outfits = table_concat(outfits, rank.outfits)
        end
    end
    return outfits
end

local function getMasteryRankOutfits(mastery, masteryRank)
    return MASTERYS[mastery].ranks[masteryRank].outfits
end

function getPlayerMasteryStonesPayed(cid, mastery)
    return getCreatureStorage(cid, storages.requiredStones) == mastery
end

function setPlayerMasteryStonesPayed(cid, mastery, reset)
    doCreatureSetStorage(cid, storages.requiredStones, (reset and 0 or mastery))
end

function getPlayerMasteryRankTokensPayed(cid, mastery, masteryRank)
    return getCreatureStorage(cid, storages.requiredTokens) >= masteryRank
end

function setPlayerMasteryRankTokensPayed(cid, mastery, masteryRank, reset)
    doCreatureSetStorage(cid, storages.requiredTokens, (reset and 0 or masteryRank))
end

function getPlayerMasteryRankDungeonDone(cid, mastery, masteryRank)
    return getCreatureStorage(cid, storages.requiredDungeon) >= masteryRank
end

function setPlayerMasteryRankDungeonDone(cid, mastery, masteryRank, reset)
    doCreatureSetStorage(cid, storages.requiredDungeon, (reset and 0 or masteryRank))
end

local function getMasteryByVocation(vocationId)
    for _, mastery in pairs(MASTERYS) do
        if (mastery.ranks[vocationId]) then
            return mastery.id
        end
    end
    return nil
end

function setPlayerMasteryRank(cid, mastery, masteryRank, reset)
    if (reset) then
        doPlayerSetVocation(cid, VOCATIONID_TRAINER)
        for i, outfit in ipairs(getMasteryOutfits(mastery)) do
            doPlayerRemoveOutfit(cid, outfit)
        end
    else
        doPlayerSetVocation(cid, masteryRank)
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_RED)
        if (getMasteryRankOutfits(mastery, masteryRank)) then
            for i, outfit in ipairs(getMasteryRankOutfits(mastery, masteryRank)) do
                doPlayerAddOutfit(cid, outfit, 0)
            end
        end

        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.JOIN_MASTERY)
        if (not getMasteryRankNext(getMasteryByVocation(masteryRank), masteryRank)) then
            doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.MASTERY_RANK_MAX)
        end
    end
end

function getMasteryDungeons(mastery)
    return MASTERYS[mastery].dungeons
end

function getMasteryRankDungeonLevel(mastery, masteryRank)
    return MASTERYS[mastery].ranks[masteryRank].dungeonLevel
end

function getMasteryDungeons(mastery)
    return MASTERYS[mastery].dungeons
end

function doPlayerMasteryReset(cid, mastery)
    setPlayerMasteryRank(cid, mastery, 0, true)
    setPlayerMasteryStonesPayed(cid, 0, true)
    setPlayerMasteryRankTokensPayed(cid, 0, 0, true)
    setPlayerMasteryRankDungeonDone(cid, 0, 0, true)
end

function doMasteryAdvantageCheck(cid, advantage)
    if (not isPlayer(cid) or getPlayerTournamentReady(cid)) then
        return false
    end

    local mastery = getPlayerMastery(cid)
    if (mastery and isInArray(MASTERYS[mastery].advantages, advantage) and
            getPlayerMasteryRank(cid) >= MASTERYS[mastery].advantagesRank) then
        return true
    end
    return false
end

-- Mastery Dungeons  x + 762 | y - 833 ~~~~~ On DNA 151 +426 +141
MASTERY_DUNGEONS = {
    [MASTERYDUNGEONID_FIGHT] = {startPosition = {x = 4671, y = 430, z = 7}, globalStorages = {user = 6000, cleanEvent = 6001}},
    [MASTERYDUNGEONID_FIRE] = {startPosition = {x = 4887, y = 651, z = 6}, globalStorages = {user = 6002, cleanEvent = 6003}},
    [MASTERYDUNGEONID_FLYING] = {startPosition = {x = 4781, y = 653, z = 7}, globalStorages = {user = 6004, cleanEvent = 6005}},
    [MASTERYDUNGEONID_GRASS] = {startPosition = {x = 4811, y = 443, z = 4}, globalStorages = {user = 6006, cleanEvent = 6007}},
    [MASTERYDUNGEONID_GROUND] = {startPosition = {x = 4885, y = 446, z = 4}, globalStorages = {user = 6008, cleanEvent = 6009}},
    [MASTERYDUNGEONID_ICE] = {startPosition = {x = 4684, y = 493, z = 7}, globalStorages = {user = 6010, cleanEvent = 6011}},
    [MASTERYDUNGEONID_NORMAL] = {startPosition = {x = 4864, y = 482, z = 5}, globalStorages = {user = 6012, cleanEvent = 6013}},
    [MASTERYDUNGEONID_POISON] = {startPosition = {x = 4788, y = 534, z = 4}, globalStorages = {user = 6014, cleanEvent = 6015}},
    [MASTERYDUNGEONID_ROCK] = {startPosition = {x = 4679, y = 642, z = 7}, globalStorages = {user = 6016, cleanEvent = 6017}},
    [MASTERYDUNGEONID_WATER] = {startPosition = {x = 4758, y = 567, z = 4}, globalStorages = {user = 6018, cleanEvent = 6019}},
    [MASTERYDUNGEONID_ELECTRICSTEEL] = {startPosition = {x = 4841, y = 618, z = 4}, globalStorages = {user = 6020, cleanEvent = 6021}},
}

MASTERY_DUNGEON_IDS = {
    MASTERYDUNGEONID_FIGHT,
    MASTERYDUNGEONID_FIRE,
    MASTERYDUNGEONID_FLYING,
    MASTERYDUNGEONID_GRASS,
    MASTERYDUNGEONID_GROUND,
    MASTERYDUNGEONID_ICE,
    MASTERYDUNGEONID_NORMAL,
    MASTERYDUNGEONID_POISON,
    MASTERYDUNGEONID_ROCK,
    MASTERYDUNGEONID_WATER,
    MASTERYDUNGEONID_ELECTRICSTEEL
}

local DUNGEON_RESPAWNS = { -- ON DNA 151 +431 +141 +0
    [MASTERYDUNGEONID_ELECTRICSTEEL] = {
        pokemons = {"Dungeon Electrode", "Dungeon Magneton", "Dungeon Raichu"},
        spawns = {
            {x = 4856, y = 618, z = 4},
            {x = 4865, y = 618, z = 4},
            {x = 4878, y = 617, z = 4},
            {x = 4874, y = 611, z = 4},
            {x = 4876, y = 607, z = 5},
            {x = 4876, y = 594, z = 5},
            {x = 4876, y = 584, z = 5},
            {x = 4869, y = 579, z = 5},
            {x = 4859, y = 579, z = 5},
            {x = 4852, y = 580, z = 5},
            {x = 4840, y = 579, z = 5},
            {x = 4843, y = 588, z = 5},
            {x = 4840, y = 598, z = 5},
            {x = 4842, y = 608, z = 5},
            {x = 4838, y = 607, z = 6},
            {x = 4839, y = 599, z = 6},
            {x = 4842, y = 587, z = 6},
            {x = 4850, y = 581, z = 6},
            {x = 4855, y = 577, z = 6},
            {x = 4863, y = 578, z = 7},
            {x = 4875, y = 582, z = 7},
            {x = 4874, y = 596, z = 7},
            {x = 4874, y = 606, z = 7},
            {x = 4857, y = 599, z = 7},
            {x = 4844, y = 588, z = 7},
            {x = 4844, y = 601, z = 7},
            {x = 4843, y = 610, z = 7},
		},
		boss = {name = "Dungeon Boss Pikachu", position = {x = 4860, y = 602, z = 7}}
    },
    [MASTERYDUNGEONID_FIGHT] = {
        pokemons = {"Dungeon Hitmonchan", "Dungeon Hitmonlee", "Dungeon Machamp",  "Dungeon Poliwrath", "Dungeon Primeape"},
        spawns = {
            {x = 4681, y = 439, z = 7},
            {x = 4688, y = 445, z = 7},
            {x = 4678, y = 453, z = 7},
            {x = 4691, y = 454, z = 7},
            {x = 4703, y = 453, z = 7},
            {x = 4710, y = 456, z = 7},
            {x = 4707, y = 443, z = 7},
            {x = 4703, y = 434, z = 7},
            {x = 4701, y = 423, z = 7},
            {x = 4689, y = 423, z = 7},
            {x = 4718, y = 421, z = 7},
            {x = 4728, y = 414, z = 7},
            {x = 4721, y = 401, z = 7},
            {x = 4714, y = 410, z = 7},
            {x = 4704, y = 404, z = 7},
            {x = 4686, y = 402, z = 6},
            {x = 4678, y = 410, z = 6},
            {x = 4685, y = 417, z = 6},
            {x = 4703, y = 413, z = 6},
            {x = 4718, y = 414, z = 6},
            {x = 4726, y = 425, z = 6},
            {x = 4718, y = 436, z = 6},
            {x = 4728, y = 437, z = 6},
            {x = 4729, y = 431, z = 5},
            {x = 4729, y = 436, z = 5},
            {x = 4722, y = 444, z = 4},
            {x = 4718, y = 432, z = 4},
            {x = 4716, y = 426, z = 4},
            {x = 4721, y = 421, z = 5},
            {x = 4715, y = 417, z = 5},
            {x = 4713, y = 406, z = 5},
		},
		boss = {name = "Dungeon Boss Machop", position = {x = 4726, y = 401, z = 5}}
    },
    [MASTERYDUNGEONID_FIRE] = {
        pokemons = {"Dungeon Arcanine", "Dungeon Magmar", "Dungeon Ninetales"},
        spawns = {
            {x = 4869, y = 660, z = 7},
            {x = 4856, y = 657, z = 7},
            {x = 4849, y = 662, z = 7},
            {x = 4836, y = 663, z = 7},
            {x = 4833, y = 674, z = 7},
            {x = 4833, y = 689, z = 7},
            {x = 4842, y = 699, z = 7},
            {x = 4849, y = 689, z = 7},
            {x = 4852, y = 711, z = 7},
            {x = 4859, y = 702, z = 7},
            {x = 4869, y = 703, z = 7},
            {x = 4877, y = 695, z = 7},
            {x = 4876, y = 687, z = 7},
            {x = 4881, y = 681, z = 7},
            {x = 4878, y = 675, z = 7},
            {x = 4886, y = 687, z = 6},
            {x = 4884, y = 700, z = 6},
            {x = 4884, y = 705, z = 6},
            {x = 4876, y = 711, z = 5},
            {x = 4872, y = 714, z = 5},
            {x = 4866, y = 704, z = 6},
            {x = 4867, y = 687, z = 6},
            {x = 4863, y = 684, z = 6},
            {x = 4859, y = 682, z = 6},
            {x = 4797, y = 610, z = 5},
            {x = 4858, y = 662, z = 5},
            {x = 4859, y = 654, z = 5},
            {x = 4869, y = 656, z = 5},
            {x = 4881, y = 654, z = 5},
            {x = 4878, y = 657, z = 4},
            {x = 4862, y = 672, z = 4},
            {x = 4877, y = 700, z = 4},
            {x = 4831, y = 687, z = 4},
		},
		boss = {name = "Dungeon Boss Charmander", position = {x = 4852, y = 705, z = 4}}
    },
    [MASTERYDUNGEONID_FLYING] = {
        pokemons = {"Dungeon Fearow", "Dungeon Golbat", "Dungeon Pidgeot"},
        spawns = {
            {x = 4777, y = 686, z = 7},
            {x = 4766, y = 687, z = 7},
            {x = 4774, y = 695, z = 7},
            {x = 4778, y = 699, z = 7},
            {x = 4789, y = 693, z = 7},
            {x = 4775, y = 708, z = 7},
            {x = 4785, y = 627, z = 6},
            {x = 4761, y = 703, z = 6},
            {x = 4758, y = 698, z = 6},
            {x = 4752, y = 679, z = 6},
            {x = 4754, y = 675, z = 6},
            {x = 4771, y = 676, z = 6},
            {x = 4778, y = 678, z = 6},
            {x = 4798, y = 682, z = 6},
            {x = 4798, y = 688, z = 6},
            {x = 4794, y = 708, z = 6},
            {x = 4793, y = 711, z = 6},
            {x = 4805, y = 706, z = 5},
            {x = 4806, y = 699, z = 5},
            {x = 4805, y = 681, z = 5},
            {x = 4801, y = 674, z = 5},
            {x = 4801, y = 658, z = 5},
            {x = 4799, y = 656, z = 5},
            {x = 4771, y = 668, z = 5},
            {x = 4767, y = 666, z = 5},
            {x = 4755, y = 670, z = 5},
            {x = 4758, y = 677, z = 5},
            {x = 4762, y = 658, z = 4},
            {x = 4770, y = 656, z = 4},
		},
		boss = {name = "Dungeon Boss Dratini", position = {x = 4795, y = 660, z = 4}}
    },
    [MASTERYDUNGEONID_GRASS] = {
        pokemons = {"Dungeon Exeggutor", "Dungeon Parasect", "Dungeon Tangela", "Dungeon Vileplume"},
        spawns = {
            {x = 4788, y = 444, z = 4},
            {x = 4782, y = 459, z = 4},
            {x = 4776, y = 455, z = 4},
            {x = 4767, y = 438, z = 4},
            {x = 4767, y = 431, z = 4},
            {x = 4758, y = 418, z = 4},
            {x = 4761, y = 417, z = 4},
            {x = 4755, y = 413, z = 4},
            {x = 4759, y = 441, z = 5},
            {x = 4756, y = 452, z = 5},
            {x = 4765, y = 455, z = 5},
            {x = 4782, y = 454, z = 5},
            {x = 4794, y = 451, z = 6},
            {x = 4795, y = 450, z = 6},
            {x = 4799, y = 427, z = 6},
            {x = 4794, y = 425, z = 6},
            {x = 4798, y = 413, z = 6},
            {x = 4795, y = 406, z = 6},
            {x = 4779, y = 409, z = 6},
            {x = 4777, y = 412, z = 6},
            {x = 4761, y = 405, z = 6},
            {x = 4760, y = 412, z = 7},
            {x = 4768, y = 413, z = 7},
            {x = 4785, y = 427, z = 7},
            {x = 4767, y = 439, z = 7},
            {x = 4791, y = 446, z = 7},
		},
		boss = {name = "Dungeon Boss Bulbasaur", position = {x = 4766, y = 456, z = 7}}
    },
    [MASTERYDUNGEONID_GROUND] = {
        pokemons = {"Dungeon Dugtrio", "Dungeon Marowak", "Dungeon Onix", "Dungeon Rhydon", "Dungeon Sandslash"},
        spawns = {
            {x = 4867, y = 456, z = 5},
            {x = 4858, y = 452, z = 5},
            {x = 4847, y = 446, z = 5},
            {x = 4839, y = 444, z = 5},
            {x = 4847, y = 434, z = 5},
            {x = 4837, y = 428, z = 5},
            {x = 4838, y = 415, z = 5},
            {x = 4848, y = 414, z = 5},
            {x = 4853, y = 417, z = 5},
            {x = 4863, y = 410, z = 5},
            {x = 4873, y = 409, z = 5},
            {x = 4884, y = 416, z = 5},
            {x = 4870, y = 428, z = 5},
            {x = 4863, y = 436, z = 5},
            {x = 4874, y = 441, z = 6},
            {x = 4856, y = 432, z = 6},
            {x = 4848, y = 442, z = 6},
            {x = 4844, y = 454, z = 6},
            {x = 4838, y = 436, z = 6},
            {x = 4834, y = 425, z = 6},
            {x = 4865, y = 420, z = 6},
            {x = 4864, y = 409, z = 6},
            {x = 4871, y = 406, z = 6},
            {x = 4880, y = 417, z = 6},
            {x = 4849, y = 422, z = 7},
            {x = 4859, y = 427, z = 7},
            {x = 4863, y = 436, z = 7},
		},
		boss = {name = "Dungeon Boss Sandshrew", position = {x = 4859, y = 451, z = 7}}
    },
    [MASTERYDUNGEONID_ICE] = {
        pokemons = {"Dungeon Jynx", "Dungeon Dewgong", "Dungeon Cloyster", "Dungeon Lapras"},
        spawns = {
            {x = 4677, y = 525, z = 7},
            {x = 4679, y = 535, z = 7},
            {x = 4690, y = 537, z = 7},
            {x = 4704, y = 534, z = 7},
            {x = 4711, y = 539, z = 7},
            {x = 4710, y = 532, z = 7},
            {x = 4714, y = 518, z = 7},
            {x = 4719, y = 515, z = 7},
            {x = 4716, y = 490, z = 6},
            {x = 4699, y = 490, z = 6},
            {x = 4688, y = 488, z = 6},
            {x = 4704, y = 487, z = 5},
            {x = 4693, y = 493, z = 5},
            {x = 4684, y = 496, z = 5},
            {x = 4678, y = 507, z = 5},
            {x = 4681, y = 515, z = 5},
            {x = 4703, y = 504, z = 5},
            {x = 4700, y = 504, z = 6},
            {x = 4690, y = 506, z = 6},
            {x = 4690, y = 521, z = 6},
            {x = 4712, y = 492, z = 4},
            {x = 4698, y = 486, z = 4},
            {x = 4685, y = 487, z = 4},
            {x = 4680, y = 496, z = 4},
            {x = 4710, y = 499, z = 4},
		},
		boss = {name = "Dungeon Boss Lapras", position = {x = 4693, y = 519, z = 4}}
    },
    [MASTERYDUNGEONID_NORMAL] = {
        pokemons = {"Dungeon Clefable", "Dungeon Dodrio", "Dungeon Farfetchd", "Dungeon Kangaskhan", "Dungeon Lickitung", "Dungeon Persian", "Dungeon Tauros", "Dungeon Wigglytuff"},
        spawns = {
            {x = 4872, y = 499, z = 4},
            {x = 4876, y = 506, z = 4},
            {x = 4842, y = 514, z = 4},
            {x = 4838, y = 509, z = 4},
            {x = 4850, y = 504, z = 4},
            {x = 4842, y = 489, z = 4},
            {x = 4877, y = 524, z = 5},
            {x = 4884, y = 521, z = 5},
            {x = 4883, y = 530, z = 5},
            {x = 4838, y = 531, z = 5},
            {x = 4833, y = 525, z = 5},
            {x = 4833, y = 515, z = 5},
            {x = 4865, y = 488, z = 6},
            {x = 4869, y = 495, z = 6},
            {x = 4879, y = 510, z = 6},
            {x = 4884, y = 525, z = 6},
            {x = 4885, y = 535, z = 6},
            {x = 4847, y = 535, z = 6},
            {x = 4835, y = 524, z = 6},
            {x = 4838, y = 513, z = 6},
            {x = 4847, y = 497, z = 6},
            {x = 4849, y = 491, z = 6},
            {x = 4865, y = 506, z = 7},
            {x = 4875, y = 500, z = 7},
            {x = 4886, y = 514, z = 7},
            {x = 4875, y = 521, z = 7},
            {x = 4845, y = 515, z = 7},
            {x = 4853, y = 505, z = 7},
            {x = 4834, y = 500, z = 7},
            {x = 4854, y = 495, z = 7},
		},
		boss = {name = "Dungeon Boss Jigglypuff", position = {x = 4862, y = 533, z = 7}}
    },
    [MASTERYDUNGEONID_POISON] = {
        pokemons = {"Dungeon Arbok", "Dungeon Golbat", "Dungeon Muk", "Dungeon Nidoking", "Dungeon Nidoqueen", "Dungeon Venomoth", "Dungeon Victreebel", "Dungeon Weezing"},
        spawns = {
            {x = 4796, y = 523, z = 4},
            {x = 4782, y = 519, z = 4},
            {x = 4867, y = 515, z = 4},
            {x = 4764, y = 512, z = 4},
            {x = 4769, y = 501, z = 4},
            {x = 4777, y = 496, z = 4},
            {x = 4789, y = 495, z = 4},
            {x = 4760, y = 487, z = 4},
            {x = 4763, y = 489, z = 5},
            {x = 4769, y = 493, z = 5},
            {x = 4789, y = 501, z = 5},
            {x = 4790, y = 512, z = 5},
            {x = 4802, y = 523, z = 5},
            {x = 4795, y = 538, z = 5},
            {x = 4786, y = 533, z = 5},
            {x = 4776, y = 530, z = 5},
            {x = 4774, y = 514, z = 5},
            {x = 4785, y = 538, z = 6},
            {x = 4778, y = 535, z = 6},
            {x = 4769, y = 525, z = 6},
            {x = 4781, y = 520, z = 6},
            {x = 4788, y = 512, z = 6},
            {x = 4763, y = 511, z = 6},
            {x = 4774, y = 497, z = 6},
            {x = 4764, y = 500, z = 7},
            {x = 4767, y = 509, z = 7},
            {x = 4763, y = 513, z = 7},
		},
		boss = {name = "Dungeon Boss Grimer", position = {x = 4774, y = 528, z = 7}}
    },
    [MASTERYDUNGEONID_ROCK] = {
        pokemons = {"Dungeon Golem", "Dungeon Onix", "Dungeon Rhydon"},
        spawns = {
            {x = 4690, y = 627, z = 7},
            {x = 4695, y = 624, z = 7},
            {x = 4709, y = 612, z = 6},
            {x = 4714, y = 615, z = 6},
            {x = 4718, y = 630, z = 6},
            {x = 4726, y = 615, z = 6},
            {x = 4722, y = 594, z = 7},
            {x = 4717, y = 582, z = 7},
            {x = 4704, y = 582, z = 7},
            {x = 4700, y = 573, z = 7},
            {x = 4692, y = 573, z = 7},
            {x = 4678, y = 584, z = 7},
            {x = 4680, y = 598, z = 7},
            {x = 4691, y = 606, z = 7},
            {x = 4699, y = 596, z = 7},
            {x = 4691, y = 591, z = 7},
            {x = 4688, y = 580, z = 6},
            {x = 4695, y = 589, z = 6},
            {x = 4691, y = 594, z = 5},
            {x = 4698, y = 603, z = 5},
            {x = 4708, y = 603, z = 5},
            {x = 4718, y = 597, z = 5},
            {x = 4725, y = 616, z = 5},
            {x = 4711, y = 623, z = 5},
            {x = 4707, y = 621, z = 5},
            {x = 4699, y = 621, z = 5},
		},
		boss = {name = "Dungeon Boss Geodude", position = {x = 4682, y = 599, z = 4}}
    },
    [MASTERYDUNGEONID_WATER] = {
        pokemons = {"Dungeon Blastoise", "Dungeon Cloyster", "Dungeon Dewgong", "Dungeon Golduck", "Dungeon Gyarados", "Dungeon Kingler", "Dungeon Lapras", "Dungeon Poliwrath", "Dungeon Seadra", "Dungeon Seaking", "Dungeon Slowbro", "Dungeon Starmie", "Dungeon Tentacruel"},
        spawns = {
            {x = 4759, y = 593, z = 4},
            {x = 4756, y = 603, z = 4},
            {x = 4756, y = 612, z = 4},
            {x = 4755, y = 622, z = 4},
            {x = 4764, y = 622, z = 4},
            {x = 4773, y = 627, z = 4},
            {x = 4785, y = 627, z = 4},
            {x = 4793, y = 625, z = 4},
            {x = 4803, y = 613, z = 4},
            {x = 4806, y = 604, z = 4},
            {x = 4807, y = 596, z = 4},
            {x = 4801, y = 578, z = 5},
            {x = 4793, y = 576, z = 5},
            {x = 4787, y = 574, z = 5},
            {x = 4778, y = 578, z = 5},
            {x = 4780, y = 583, z = 5},
            {x = 4783, y = 595, z = 5},
            {x = 4769, y = 590, z = 5},
            {x = 4775, y = 600, z = 5},
            {x = 4765, y = 600, z = 5},
            {x = 4772, y = 613, z = 6},
            {x = 4767, y = 615, z = 6},
            {x = 4780, y = 619, z = 6},
            {x = 4794, y = 617, z = 6},
            {x = 4798, y = 611, z = 6},
            {x = 4798, y = 598, z = 6},
            {x = 4795, y = 586, z = 6},
            {x = 4793, y = 579, z = 6},
            {x = 4784, y = 579, z = 7},
            {x = 4778, y = 577, z = 7},
            {x = 4774, y = 578, z = 7},
            {x = 4766, y = 574, z = 7},
		},
		boss = {name = "Dungeon Boss Squirtle", position = {x = 4757, y = 587, z = 7}}
    }
}

function getMasteryDungeonGlobalStorageUser(masteryDungeon)
    return MASTERY_DUNGEONS[masteryDungeon].globalStorages.user
end

function getMasteryDungeonGlobalStorageCleanEvent(masteryDungeon)
    return MASTERY_DUNGEONS[masteryDungeon].globalStorages.cleanEvent
end

function getMasteryDungeonUser(masteryDungeon)
    return getGlobalStorageValue(getMasteryDungeonGlobalStorageUser(masteryDungeon))
end

function setMasteryDungeonUser(masteryDungeon, user)
    setGlobalStorageValue(getMasteryDungeonGlobalStorageUser(masteryDungeon), user)
end

function getMasteryDungeonCleanEvent(masteryDungeon)
    return getGlobalStorageValue(getMasteryDungeonGlobalStorageCleanEvent(masteryDungeon))
end

function setMasteryDungeonCleanEvent(masteryDungeon, event)
    setGlobalStorageValue(getMasteryDungeonGlobalStorageCleanEvent(masteryDungeon), event)
end

function getMasteryDungeonStartPosition(masteryDungeon)
    return MASTERY_DUNGEONS[masteryDungeon].startPosition
end

function getMasteryDungeonsFree(mastery)
    local dungeons = {}
    for i, dungeon in ipairs(getMasteryDungeons(mastery)) do
        if (getMasteryDungeonUser(dungeon) == 0) then
            table.insert(dungeons, dungeon)
        end
    end
    return dungeons
end

local function doMasteryDungeonStopEvent(masteryDungeon)
    local event = getMasteryDungeonCleanEvent(masteryDungeon)
    if (event > 0) then
        stopEvent(event)
        setMasteryDungeonCleanEvent(masteryDungeon, 0)
    end
end

local function doMasteryDungeonSpawnClear(masteryDungeon)
    for i, pokemon in ipairs(DUNGEON_RESPAWNS[masteryDungeon].pokemons) do
        local cid, tries = getCreatureByNickname(pokemon), 0
        while (cid and isCreature(cid) and tries < 5) do
            if (doRemoveCreature(cid)) then
                cid = getCreatureByNickname(pokemon)
                tries = 0
            else
                tries = tries + 1
            end
        end
    end
end

local function doMasteryDungeonSpawns(masteryDungeon, level)
    for i, spawn in ipairs(DUNGEON_RESPAWNS[masteryDungeon].spawns) do
        local cid = doSummonCreature(table.random(DUNGEON_RESPAWNS[masteryDungeon].pokemons), spawn, false)
        if (cid and type(cid) ~= 'boolean') then
            setMonsterLevel(cid, level)
        end
    end
    setMonsterLevel(doSummonCreature(DUNGEON_RESPAWNS[masteryDungeon].boss.name, DUNGEON_RESPAWNS[masteryDungeon].boss.position), level)
end

function doMasteryDungeonClean(dungeon, user, teleport)
    if (teleport == nil) then
        teleport = true
    end

    doMasteryDungeonStopEvent(dungeon)
    local currentUser = getMasteryDungeonUser(dungeon)
    if (user and isPlayer(user) and user == currentUser) then
        if (teleport) then
            doTeleportThing(user, TRADE_ROOM_POSITION)
        end
        setPlayerMasteryDungeon(user, 0)
    end
    setMasteryDungeonUser(dungeon, 0)
    doMasteryDungeonSpawnClear(dungeon)
end

function doMasteryDungeonStart(mastery, masteryRank, user)
    local freeDungeons = getMasteryDungeonsFree(mastery)
    if (#freeDungeons == 0) then
        return false
    end

    local dungeon = table.random(freeDungeons)
    if (doTeleportThing(user, getMasteryDungeonStartPosition(dungeon))) then
        doMasteryDungeonClean(dungeon)
        doMasteryDungeonSpawns(dungeon, getMasteryRankDungeonLevel(mastery, masteryRank))

        setMasteryDungeonUser(dungeon, user)
        setPlayerMasteryDungeon(user, dungeon)
        setMasteryDungeonCleanEvent(dungeon, addEvent(doMasteryDungeonClean, 60 * 60 * 1000, dungeon, user))
        setPlayerLastDungeonDate(user, os.time())
        doPlayerSendTextMessage(user, MESSAGE_STATUS_CONSOLE_ORANGE, "The dungeon will automatically end on 60 minutes, be fast!")
        setPlayerDisconnectAtExit(user, false)
        return true
    end
    return false
end

function doMasteryDungeonEnd(user, completed)
    local dungeon = getPlayerMasteryDungeon(user)
    if (dungeon < 0) then
        return
    end

    if (completed) then
        local mastery = getPlayerMastery(user)
        doTeleportThing(user, getMasteryBasePosition(mastery))
        setPlayerMasteryRankDungeonDone(user, mastery, getMasteryRankNext(mastery, getPlayerMasteryRank(user)))
        doPlayerSendTextMessage(user, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations, you won the dungeon!")
        setPlayerDisconnectAtExit(user, true)
    end

    doMasteryDungeonClean(dungeon, user, not completed)
end

function getMasteryPlatePoints(itemid)
    return POINTS_PER_PLATE[itemid]
end
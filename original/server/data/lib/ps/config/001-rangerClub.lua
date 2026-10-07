-- lastUsedStorage = 20349

RangerClub.RANK_IDS = {}
RangerClub.RANK_IDS.NONE = 0
RangerClub.RANK_IDS.ROOKIE = 1
RangerClub.RANK_IDS.MENTOR = 2
RangerClub.RANK_IDS.COORDINATOR = 3
RangerClub.RANK_IDS.COACH = 4
--
RangerClub.RANKS = {}
RangerClub.RANKS[RangerClub.RANK_IDS.NONE] = {
    id = RangerClub.RANK_IDS.NONE,
    name = "None",
    requiredPoints = 0,
    requiredLevel = 0,
    next = RangerClub.RANK_IDS.ROOKIE,
    tasks = nil
}

RangerClub.RANKS[RangerClub.RANK_IDS.ROOKIE] = {
    id = RangerClub.RANK_IDS.ROOKIE,
    name = "Rookie",
    requiredPoints = 0,
    requiredLevel = 10,
    next = RangerClub.RANK_IDS.MENTOR,
    tasks = {}
}

RangerClub.RANKS[RangerClub.RANK_IDS.MENTOR] = {
    id = RangerClub.RANK_IDS.ROOKIE,
    name = "Mentor",
    requiredPoints = 15,
    requiredLevel = 25,
    next = RangerClub.RANK_IDS.COORDINATOR,
    tasks = {}
}

RangerClub.RANKS[RangerClub.RANK_IDS.COORDINATOR] = {
    id = RangerClub.RANK_IDS.ROOKIE,
    name = "Coordinator",
    requiredPoints = 180,
    requiredLevel = 50,
    next = RangerClub.RANK_IDS.COACH,
    tasks = {}
}

RangerClub.RANKS[RangerClub.RANK_IDS.COACH] = {
    id = RangerClub.RANK_IDS.ROOKIE,
    name = "Coach",
    requiredPoints = 580,
    requiredLevel = 75,
    next = nil,
    tasks = {}
}
--
RangerClub.MAX_POINTS = RangerClub.RANKS[#RangerClub.RANKS].requiredPoints
RangerClub.BOSS_LOOT_EXTRA_CHANCE = 10
--
RangerClub.BOSS_STATUS = {}
RangerClub.BOSS_STATUS.UNAVAILABLE = -1
RangerClub.BOSS_STATUS.AVAILABLE = 0
--
RangerClub.BOSS_ARENAS = {}
RangerClub.BOSS_ARENAS[#RangerClub.BOSS_ARENAS + 1] = {
    centerPos = {x = 4772, y = 102, z = 6},
    rangeX = 8,
    rangeY = 9
}

RangerClub.BOSS_ARENAS[#RangerClub.BOSS_ARENAS + 1] = {
    centerPos = {x = 4798, y = 102, z = 6},
    rangeX = 9,
    rangeY = 9
}

RangerClub.BOSS_ARENAS[#RangerClub.BOSS_ARENAS + 1] = {
    centerPos = {x = 4828, y = 104, z = 6},
    rangeX = 9,
    rangeY = 10
}
--
RangerClub.BOSS_IDS = {}
RangerClub.BOSS_IDS.SQUIRTLE = 1
RangerClub.BOSS_IDS.BULBASAUR = 2
RangerClub.BOSS_IDS.CHARMANDER = 3
RangerClub.BOSS_IDS.BEEDRILL = 4
RangerClub.BOSS_IDS.CLEFABLE = 5
RangerClub.BOSS_IDS.GRAVELER = 6
RangerClub.BOSS_IDS.MAGNETON = 7
RangerClub.BOSS_IDS.WEEZING = 8
RangerClub.BOSS_IDS.SEADRA = 9
RangerClub.BOSS_IDS.PIDGEOT = 10
RangerClub.BOSS_IDS.RAICHU = 11
RangerClub.BOSS_IDS.MAROWAK = 12
RangerClub.BOSS_IDS.VILEPLUME = 13
RangerClub.BOSS_IDS.VENOMOTH = 14
RangerClub.BOSS_IDS.MACHAMP = 15
RangerClub.BOSS_IDS.HYPNO = 16
RangerClub.BOSS_IDS.RHYDON = 17
RangerClub.BOSS_IDS.DEWGONG = 18
RangerClub.BOSS_IDS.POLIWRATH = 19
RangerClub.BOSS_IDS.VENUSAUR = 20
RangerClub.BOSS_IDS.CHARIZARD = 21
RangerClub.BOSS_IDS.BLASTOISE = 22
RangerClub.BOSS_IDS.ALAKAZAM = 23
RangerClub.BOSS_IDS.TENTACRUEL = 24
RangerClub.BOSS_IDS.GENGAR = 25
RangerClub.BOSS_IDS.MAGMAR = 26
RangerClub.BOSS_IDS.ELECTABUZZ = 27
RangerClub.BOSS_IDS.NIDOKING = 28
RangerClub.BOSS_IDS.NIDOQUEEN = 29
RangerClub.BOSS_IDS.TAUROS = 30
RangerClub.BOSS_IDS.SCIZOR = 31
RangerClub.BOSS_IDS.KANGASKHAN = 32
RangerClub.BOSS_IDS.DRATINI = 33
RangerClub.BOSS_IDS.EEVEE = 34
RangerClub.BOSS_IDS.CATERPIE = 35
RangerClub.BOSS_IDS.RATTATA = 36
RangerClub.BOSS_IDS.EKANS = 37
RangerClub.BOSS_IDS.PIDGEY = 38
RangerClub.BOSS_IDS.SANDSHREW = 39
RangerClub.BOSS_IDS.CLEFAIRY = 40
RangerClub.BOSS_IDS.MEOWTH = 41
RangerClub.BOSS_IDS.ABRA = 42
RangerClub.BOSS_IDS.PONYTA = 43
RangerClub.BOSS_IDS.CUBONE = 44
RangerClub.BOSS_IDS.SEEL = 45
RangerClub.BOSS_IDS.PIDGEOTTO = 46
RangerClub.BOSS_IDS.GROWLITHE = 47
RangerClub.BOSS_IDS.BUTTERFREE = 48
RangerClub.BOSS_IDS.ARBOK = 49
RangerClub.BOSS_IDS.CLEFABLE = 50
RangerClub.BOSS_IDS.GOLBAT = 51
RangerClub.BOSS_IDS.WEEPINBELL = 52
RangerClub.BOSS_IDS.HAUNTER = 53
RangerClub.BOSS_IDS.TANGELA = 54
RangerClub.BOSS_IDS.RHYHORN = 55
RangerClub.BOSS_IDS.WIGGLYTUFF = 56
RangerClub.BOSS_IDS.FEAROW = 57
RangerClub.BOSS_IDS.SANDSLASH = 58
RangerClub.BOSS_IDS.GOLDUCK = 59
RangerClub.BOSS_IDS.GOLEM = 60
RangerClub.BOSS_IDS.RAPIDASH = 61
RangerClub.BOSS_IDS.GYARADOS = 62
RangerClub.BOSS_IDS.ARCANINE = 63
RangerClub.BOSS_IDS.VICTREEBEL = 64
RangerClub.BOSS_IDS.MUK = 65
RangerClub.BOSS_IDS.CLOYSTER = 66
RangerClub.BOSS_IDS.JYNX = 67
RangerClub.BOSS_IDS.PINECO = 68
RangerClub.BOSS_IDS.CYNDAQUIL = 69
RangerClub.BOSS_IDS.TOTODILE = 70
RangerClub.BOSS_IDS.HOPPIP = 71
RangerClub.BOSS_IDS.CHIKORITA = 72
RangerClub.BOSS_IDS.DUNSPARCE = 73
RangerClub.BOSS_IDS.AIPOM = 74
RangerClub.BOSS_IDS.SPINARAK = 75
RangerClub.BOSS_IDS.YANMA = 76

-- Test
local aux = {}
for k, v in pairs(RangerClub.BOSS_IDS) do
    if (table.find(aux, v)) then
        log(LOG_TYPES.ERROR, "RangerClub - Duplicated boss id.", k, v)
    else
        aux[k] = v
    end
end
aux = nil

--
RangerClub.BOSSES = {}
RangerClub.BOSSES[RangerClub.BOSS_IDS.SQUIRTLE] = {
    id = RangerClub.BOSS_IDS.SQUIRTLE,
    name = "Squirtle",
    monster = "RC Squirtle",
    statusStorage = 20214,
    requiredItem = {itemid = 17825, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.BULBASAUR] = {
    id = RangerClub.BOSS_IDS.BULBASAUR,
    name = "Bulbasaur",
    monster = "RC Bulbasaur",
    statusStorage = 20215,
    requiredItem = {itemid = 12271, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CHARMANDER] = {
    id = RangerClub.BOSS_IDS.CHARMANDER,
    name = "Charmander",
    monster = "RC Charmander",
    statusStorage = 20216,
    requiredItem = {itemid = 17822, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.BEEDRILL] = {
    id = RangerClub.BOSS_IDS.BEEDRILL,
    name = "Beedrill",
    monster = "RC Beedrill",
    statusStorage = 20264,
    requiredItem = {itemid = 17833, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CLEFABLE] = {
    id = RangerClub.BOSS_IDS.CLEFABLE,
    name = "Clefable",
    monster = "RC Clefable",
    statusStorage = 20265,
    requiredItem = {itemid = 17851, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.GRAVELER] = {
    id = RangerClub.BOSS_IDS.GRAVELER,
    name = "Graveler",
    monster = "RC Graveler",
    statusStorage = 20266,
    requiredItem = {itemid = 17887, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.MAGNETON] = {
    id = RangerClub.BOSS_IDS.MAGNETON,
    name = "Magneton",
    monster = "RC Magneton",
    statusStorage = 20267,
    requiredItem = {itemid = 17893, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.WEEZING] = {
    id = RangerClub.BOSS_IDS.WEEZING,
    name = "Weezing",
    monster = "RC Weezing",
    statusStorage = 20268,
    requiredItem = {itemid = 17919, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.SEADRA] = {
    id = RangerClub.BOSS_IDS.SEADRA,
    name = "Seadra",
    monster = "RC Seadra",
    statusStorage = 20269,
    requiredItem = {itemid = 17925, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.PIDGEOT] = {
    id = RangerClub.BOSS_IDS.PIDGEOT,
    name = "Pidgeot",
    monster = "RC Pidgeot",
    statusStorage = 20270,
    requiredItem = {itemid = 12253, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.RAICHU] = {
    id = RangerClub.BOSS_IDS.RAICHU,
    name = "Raichu",
    monster = "RC Raichu",
    statusStorage = 20271,
    requiredItem = {itemid = 12272, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.MAROWAK] = {
    id = RangerClub.BOSS_IDS.MAROWAK,
    name = "Marowak",
    monster = "RC Marowak",
    statusStorage = 20295,
    requiredItem = {itemid = 17914, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.VILEPLUME] = {
    id = RangerClub.BOSS_IDS.VILEPLUME,
    name = "Vileplume",
    monster = "RC Vileplume",
    statusStorage = 20272,
    requiredItem = {itemid = 17859, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.VENOMOTH] = {
    id = RangerClub.BOSS_IDS.VENOMOTH,
    name = "Venomoth",
    monster = "RC Venomoth",
    statusStorage = 20273,
    requiredItem = {itemid = 17863, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.MACHAMP] = {
    id = RangerClub.BOSS_IDS.MACHAMP,
    name = "Machamp",
    monster = "RC Machamp",
    statusStorage = 20274,
    requiredItem = {itemid = 17880, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.HYPNO] = {
    id = RangerClub.BOSS_IDS.HYPNO,
    name = "Hypno",
    monster = "RC Hypno",
    statusStorage = 20275,
    requiredItem = {itemid = 17907, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.RHYDON] = {
    id = RangerClub.BOSS_IDS.RHYDON,
    name = "Rhydon",
    monster = "RC Rhydon",
    statusStorage = 20276,
    requiredItem = {itemid = 17921, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.DEWGONG] = {
    id = RangerClub.BOSS_IDS.DEWGONG,
    name = "Dewgong",
    monster = "RC Dewgong",
    statusStorage = 20277,
    requiredItem = {itemid = 17897, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.POLIWRATH] = {
    id = RangerClub.BOSS_IDS.POLIWRATH,
    name = "Poliwrath",
    monster = "RC Poliwrath",
    statusStorage = 20278,
    requiredItem = {itemid = 12255, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.VENUSAUR] = {
    id = RangerClub.BOSS_IDS.VENUSAUR,
    name = "Venusaur",
    monster = "RC Venusaur",
    statusStorage = 20279,
    requiredItem = {itemid = 17821, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CHARIZARD] = {
    id = RangerClub.BOSS_IDS.CHARIZARD,
    name = "Charizard",
    monster = "RC Charizard",
    statusStorage = 20280,
    requiredItem = {itemid = 17824, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.BLASTOISE] = {
    id = RangerClub.BOSS_IDS.BLASTOISE,
    name = "Blastoise",
    monster = "RC Blastoise",
    statusStorage = 20281,
    requiredItem = {itemid = 17827, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.ALAKAZAM] = {
    id = RangerClub.BOSS_IDS.ALAKAZAM,
    name = "Alakazam",
    monster = "RC Alakazam",
    statusStorage = 20282,
    requiredItem = {itemid = 17877, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.TENTACRUEL] = {
    id = RangerClub.BOSS_IDS.TENTACRUEL,
    name = "Tentacruel",
    monster = "RC Tentacruel",
    statusStorage = 20283,
    requiredItem = {itemid = 17885, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.GENGAR] = {
    id = RangerClub.BOSS_IDS.GENGAR,
    name = "Gengar",
    monster = "RC Gengar",
    statusStorage = 20284,
    requiredItem = {itemid = 17904, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.MAGMAR] = {
    id = RangerClub.BOSS_IDS.MAGMAR,
    name = "Magmar",
    monster = "RC Magmar",
    statusStorage = 20285,
    requiredItem = {itemid = 17934, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.ELECTABUZZ] = {
    id = RangerClub.BOSS_IDS.ELECTABUZZ,
    name = "Electabuzz",
    monster = "RC Electabuzz",
    statusStorage = 20286,
    requiredItem = {itemid = 17933, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.NIDOKING] = {
    id = RangerClub.BOSS_IDS.NIDOKING,
    name = "Nidoking",
    monster = "RC Nidoking",
    statusStorage = 20287,
    requiredItem = {itemid = 12235, count = 3}, -- Toxic Plate
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 17849, count = 1, chance = 20000, unique = nil}, -- nidoking doll
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.NIDOQUEEN] = {
    id = RangerClub.BOSS_IDS.NIDOQUEEN,
    name = "Nidoqueen",
    monster = "RC Nidoqueen",
    statusStorage = 20288,
    requiredItem = {itemid = 12235, count = 3}, -- Toxic Plate
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 17846, count = 1, chance = 20000, unique = nil}, -- nidoqueen doll
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.TAUROS] = {
    id = RangerClub.BOSS_IDS.TAUROS,
    name = "Tauros",
    monster = "RC Tauros",
    statusStorage = 20289,
    requiredItem = {itemid = 12232, count = 3}, -- Love Plate
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 17936, count = 1, chance = 20000, unique = nil}, -- tauros doll
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.SCIZOR] = {
    id = RangerClub.BOSS_IDS.SCIZOR,
    name = "Scizor",
    monster = "RC Scizor",
    statusStorage = 20290,
    requiredItem = {itemid = 12241, count = 5}, -- Insect Plate
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 17931, count = 1, chance = 20000, unique = nil}, -- scyther doll
            {itemid = 18011, count = 1, chance = 20000, unique = nil}, -- scizor doll
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.KANGASKHAN] = {
    id = RangerClub.BOSS_IDS.KANGASKHAN,
    name = "Kangaskhan",
    monster = "RC Kangaskhan",
    statusStorage = 20291,
    requiredItem = {itemid = 12232, count = 3}, -- Love Plate
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 17923, count = 1, chance = 20000, unique = nil}, -- kangaskhan doll
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.DRATINI] = {
    id = RangerClub.BOSS_IDS.DRATINI,
    name = "Dratini",
    monster = "RC Dratini",
    auxName = "Dragonite", -- Reference, this is the last evolution
    statusStorage = 20292,
    requiredItem = {itemid = 18081, count = 2}, -- Sky Plate
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 15000, unique = true}, -- rare candy
            {itemid = 17949, count = 1, chance = 20000, unique = nil}, -- dratini doll
            {itemid = 17950, count = 1, chance = 20000, unique = nil}, -- dragonair doll
            {itemid = 17951, count = 1, chance = 20000, unique = nil}, -- dragonite doll
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box

            {itemid = 12240, count = 1, chance = 50 * RangerClub.BOSS_LOOT_EXTRA_CHANCE, unique = nil}, -- draco plate
            {itemid = 18081, count = 1, chance = 50 * RangerClub.BOSS_LOOT_EXTRA_CHANCE, unique = nil}, -- sky plate
            {itemid = 17358, count = 1, chance = 10 * RangerClub.BOSS_LOOT_EXTRA_CHANCE, unique = nil}, -- TM Dragon Rage
            {itemid = 17378, count = 1, chance = 10 * RangerClub.BOSS_LOOT_EXTRA_CHANCE, unique = nil}, -- TM Thunder Wave
        }
    },
    onKill = function(cid) doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.COMPLETE_RANGERCLUB_BOSS_DRATINI) end
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.EEVEE] = {
    id = RangerClub.BOSS_IDS.EEVEE,
    name = "Eevee",
    monster = "RC Eevee",
    auxName = "Umbreon", -- Reference, this is the last evolution
    statusStorage = 20293,
    requiredItem = {itemid = 12232, count = 3}, -- Love Plate
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 15000, unique = true}, -- rare candy
            {itemid = 17940, count = 1, chance = 20000, unique = nil}, -- eevee doll
            {itemid = 17941, count = 1, chance = 20000, unique = nil}, -- vaporeon doll
            {itemid = 17942, count = 1, chance = 20000, unique = nil}, -- jolteon doll
            {itemid = 17943, count = 1, chance = 20000, unique = nil}, -- flareon doll
            {itemid = 17996, count = 1, chance = 20000, unique = nil}, -- espeon doll
            {itemid = 17997, count = 1, chance = 20000, unique = nil}, -- umbreon doll
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box

            {itemid = 12233, count = 1, chance = 1000, unique = nil}, -- mind plate
            {itemid = 12242, count = 1, chance = 1000, unique = nil}, -- dread plate
            {itemid = 12230, count = 1, chance = 1000, unique = nil}, -- splash plate
            {itemid = 12229, count = 1, chance = 1000, unique = nil}, -- flame plate
            {itemid = 12232, count = 1, chance = 1000, unique = nil}, -- love plate
            {itemid = 12237, count = 1, chance = 1000, unique = nil}, -- zap plate
            {itemid = 18093, count = 1, chance = 1000, unique = nil}, -- Soothe Bell
            {itemid = 18088, count = 1, chance = 1000, unique = nil}, -- Water Stone
            {itemid = 18083, count = 1, chance = 1000, unique = nil}, -- Fire Stone
            {itemid = 18087, count = 1, chance = 1000, unique = nil}, -- Thunderstone
            {itemid = 17372, count = 1, chance = 1000, unique = nil}, -- TM Swift
            {itemid = 17363, count = 1, chance = 1000, unique = nil}, -- TM Psychic
            {itemid = 17348, count = 1, chance = 1000, unique = nil}, -- TM Water Gun
            {itemid = 17346, count = 1, chance = 1000, unique = nil}, -- TM Double-Edge
            {itemid = 17355, count = 1, chance = 1000, unique = nil}, -- TM Rage
            {itemid = 17371, count = 1, chance = 1000, unique = nil}, -- TM Fire Blast
            {itemid = 17378, count = 1, chance = 1000, unique = nil}, -- TM Thunder Wave
        }
    },
    onKill = function(cid) doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.COMPLETE_RANGERCLUB_BOSS_EEVEE) end
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CATERPIE] = {
    id = RangerClub.BOSS_IDS.CATERPIE,
    name = "Caterpie",
    monster = "RC Caterpie",
    statusStorage = 20294,
    requiredItem = {itemid = 17828, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.RATTATA] = {
    id = RangerClub.BOSS_IDS.RATTATA,
    name = "Rattata",
    monster = "RC Rattata",
    statusStorage = 20296,
    requiredItem = {itemid = 17836, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.EKANS] = {
    id = RangerClub.BOSS_IDS.EKANS,
    name = "Ekans",
    monster = "RC Ekans",
    statusStorage = 20297,
    requiredItem = {itemid = 17840, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.PIDGEY] = {
    id = RangerClub.BOSS_IDS.PIDGEY,
    name = "Pidgey",
    monster = "RC Pidgey",
    statusStorage = 20298,
    requiredItem = {itemid = 17834, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.SANDSHREW] = {
    id = RangerClub.BOSS_IDS.SANDSHREW,
    name = "Sandshrew",
    monster = "RC Sandshrew",
    statusStorage = 20299,
    requiredItem = {itemid = 17842, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CLEFAIRY] = {
    id = RangerClub.BOSS_IDS.CLEFAIRY,
    name = "Clefairy",
    monster = "RC Clefairy",
    statusStorage = 20300,
    requiredItem = {itemid = 17850, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.MEOWTH] = {
    id = RangerClub.BOSS_IDS.MEOWTH,
    name = "Meowth",
    monster = "RC Meowth",
    statusStorage = 20301,
    requiredItem = {itemid = 17866, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.ABRA] = {
    id = RangerClub.BOSS_IDS.ABRA,
    name = "Abra",
    monster = "RC Abra",
    statusStorage = 20302,
    requiredItem = {itemid = 17875, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.PONYTA] = {
    id = RangerClub.BOSS_IDS.PONYTA,
    name = "Ponyta",
    monster = "RC Ponyta",
    statusStorage = 20303,
    requiredItem = {itemid = 17889, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CUBONE] = {
    id = RangerClub.BOSS_IDS.CUBONE,
    name = "Cubone",
    monster = "RC Cubone",
    statusStorage = 20304,
    requiredItem = {itemid = 12269, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.SEEL] = {
    id = RangerClub.BOSS_IDS.SEEL,
    name = "Seel",
    monster = "RC Seel",
    statusStorage = 20305,
    requiredItem = {itemid = 12257, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.PIDGEOTTO] = {
    id = RangerClub.BOSS_IDS.PIDGEOTTO,
    name = "Pidgeotto",
    monster = "RC Pidgeotto",
    statusStorage = 20306,
    requiredItem = {itemid = 17835, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.GROWLITHE] = {
    id = RangerClub.BOSS_IDS.GROWLITHE,
    name = "Growlithe",
    monster = "RC Growlithe",
    statusStorage = 20307,
    requiredItem = {itemid = 17871, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.BUTTERFREE] = {
    id = RangerClub.BOSS_IDS.BUTTERFREE,
    name = "Butterfree",
    monster = "RC Butterfree",
    statusStorage = 20308,
    requiredItem = {itemid = 17830, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.ARBOK] = {
    id = RangerClub.BOSS_IDS.ARBOK,
    name = "Arbok",
    monster = "RC Arbok",
    statusStorage = 20309,
    requiredItem = {itemid = 17841, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.GOLBAT] = {
    id = RangerClub.BOSS_IDS.GOLBAT,
    name = "Golbat",
    monster = "RC Golbat",
    statusStorage = 20310,
    requiredItem = {itemid = 17856, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.WEEPINBELL] = {
    id = RangerClub.BOSS_IDS.WEEPINBELL,
    name = "Weepinbell",
    monster = "RC Weepinbell",
    statusStorage = 20311,
    requiredItem = {itemid = 17882, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.HAUNTER] = {
    id = RangerClub.BOSS_IDS.HAUNTER,
    name = "Haunter",
    monster = "RC Haunter",
    statusStorage = 20312,
    requiredItem = {itemid = 17903, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.TANGELA] = {
    id = RangerClub.BOSS_IDS.TANGELA,
    name = "Tangela",
    monster = "RC Tangela",
    statusStorage = 20313,
    requiredItem = {itemid = 17922, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.RHYHORN] = {
    id = RangerClub.BOSS_IDS.RHYHORN,
    name = "Rhyhorn",
    monster = "RC Rhyhorn",
    statusStorage = 20314,
    requiredItem = {itemid = 17920, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.WIGGLYTUFF] = {
    id = RangerClub.BOSS_IDS.WIGGLYTUFF,
    name = "Wigglytuff",
    monster = "RC Wigglytuff",
    statusStorage = 20315,
    requiredItem = {itemid = 17854, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 10, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.FEAROW] = {
    id = RangerClub.BOSS_IDS.FEAROW,
    name = "Fearow",
    monster = "RC Fearow",
    statusStorage = 20316,
    requiredItem = {itemid = 17839, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.SANDSLASH] = {
    id = RangerClub.BOSS_IDS.SANDSLASH,
    name = "Sandslash",
    monster = "RC Sandslash",
    statusStorage = 20317,
    requiredItem = {itemid = 17843, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.GOLDUCK] = {
    id = RangerClub.BOSS_IDS.GOLDUCK,
    name = "Golduck",
    monster = "RC Golduck",
    statusStorage = 20318,
    requiredItem = {itemid = 17868, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.GOLEM] = {
    id = RangerClub.BOSS_IDS.GOLEM,
    name = "Golem",
    monster = "RC Golem",
    statusStorage = 20319,
    requiredItem = {itemid = 17888, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.RAPIDASH] = {
    id = RangerClub.BOSS_IDS.RAPIDASH,
    name = "Rapidash",
    monster = "RC Rapidash",
    statusStorage = 20320,
    requiredItem = {itemid = 17890, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 30, maxcount = 50, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 3500, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.GYARADOS] = {
    id = RangerClub.BOSS_IDS.GYARADOS,
    name = "Gyarados",
    monster = "RC Gyarados",
    statusStorage = 20326,
    requiredItem = {itemid = 17938, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.ARCANINE] = {
    id = RangerClub.BOSS_IDS.ARCANINE,
    name = "Arcanine",
    monster = "RC Arcanine",
    statusStorage = 20327,
    requiredItem = {itemid = 17872, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.VICTREEBEL] = {
    id = RangerClub.BOSS_IDS.VICTREEBEL,
    name = "Victreebel",
    monster = "RC Victreebel",
    statusStorage = 20328,
    requiredItem = {itemid = 17883, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.MUK] = {
    id = RangerClub.BOSS_IDS.MUK,
    name = "Muk",
    monster = "RC Muk",
    statusStorage = 20329,
    requiredItem = {itemid = 17899, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CLOYSTER] = {
    id = RangerClub.BOSS_IDS.CLOYSTER,
    name = "Cloyster",
    monster = "RC Cloyster",
    statusStorage = 20330,
    requiredItem = {itemid = 17901, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.JYNX] = {
    id = RangerClub.BOSS_IDS.JYNX,
    name = "Jynx",
    monster = "RC Jynx",
    statusStorage = 20331,
    requiredItem = {itemid = 17932, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 50, maxcount = 80, unique = nil}, -- note of hundred dollars
            {itemid = 14463, count = 1, chance = 10000, unique = true}, -- rare candy
            {itemid = 23949, count = 1, chance = 10000}, -- Vitamin box
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.PINECO] = {
    id = RangerClub.BOSS_IDS.PINECO,
    name = "Pineco",
    monster = "RC Pineco",
    statusStorage = 20341,
    requiredItem = {itemid = 18003, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CYNDAQUIL] = {
    id = RangerClub.BOSS_IDS.CYNDAQUIL,
    name = "Cyndaquil",
    monster = "RC Cyndaquil",
    statusStorage = 20342,
    requiredItem = {itemid = 17955, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.TOTODILE] = {
    id = RangerClub.BOSS_IDS.TOTODILE,
    name = "Totodile",
    monster = "RC Totodile",
    statusStorage = 20343,
    requiredItem = {itemid = 17958, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.HOPPIP] = {
    id = RangerClub.BOSS_IDS.HOPPIP,
    name = "Hoppip",
    monster = "RC Hoppip",
    statusStorage = 20344,
    requiredItem = {itemid = 17987, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.CHIKORITA] = {
    id = RangerClub.BOSS_IDS.CHIKORITA,
    name = "Chikorita",
    monster = "RC Chikorita",
    statusStorage = 20345,
    requiredItem = {itemid = 17952, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.DUNSPARCE] = {
    id = RangerClub.BOSS_IDS.DUNSPARCE,
    name = "Dunsparce",
    monster = "RC Dunsparce",
    statusStorage = 20346,
    requiredItem = {itemid = 18005, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.AIPOM] = {
    id = RangerClub.BOSS_IDS.AIPOM,
    name = "Aipom",
    monster = "RC Aipom",
    statusStorage = 20347,
    requiredItem = {itemid = 17990, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 20, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.SPINARAK] = {
    id = RangerClub.BOSS_IDS.SPINARAK,
    name = "Spinarak",
    monster = "RC Spinarak",
    statusStorage = 20348,
    requiredItem = {itemid = 17967, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 10, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.BOSSES[RangerClub.BOSS_IDS.YANMA] = {
    id = RangerClub.BOSS_IDS.YANMA,
    name = "Yanma",
    monster = "RC Yanma",
    statusStorage = 20349,
    requiredItem = {itemid = 17993, count = 1},
    rewards = {
        experience = 0,
        points = 0,
        items = {
            {itemid = 2152, mincount = 1, maxcount = 30, unique = nil} -- note of hundred dollars
        }
    }
}


-- Test
local aux = {}
if (getMonsterInfo(GET_MONSTER_INFO_TEST, false)) then
    for k, v in pairs(RangerClub.BOSSES) do
        if (not getMonsterInfo(v.monster, false)) then
            log(LOG_TYPES.ERROR, "RangerClub - Boss with unknown monster.", k, v)
        end

        if (table.find(aux, v.statusStorage)) then
            log(LOG_TYPES.ERROR, "RangerClub - Boss duplicated statusStorage.", k, v)
        else
            aux[k] = v.statusStorage
        end
    end
end
--
RangerClub.TASK_IDS = {}
RangerClub.TASK_IDS.NONE = 0
RangerClub.TASK_IDS.CATERPIE = 1
RangerClub.TASK_IDS.RATTATA = 2
RangerClub.TASK_IDS.EKANS = 3
RangerClub.TASK_IDS.PIDGEY = 4
RangerClub.TASK_IDS.SANDSHREW = 5
RangerClub.TASK_IDS.CLEFAIRY = 6
RangerClub.TASK_IDS.MEOWTH = 7
RangerClub.TASK_IDS.ABRA = 8
RangerClub.TASK_IDS.PONYTA = 9
RangerClub.TASK_IDS.CUBONE = 10
RangerClub.TASK_IDS.SQUIRTLE = 11
RangerClub.TASK_IDS.BULBASAUR = 12
RangerClub.TASK_IDS.CHARMANDER = 13
RangerClub.TASK_IDS.SEEL = 14
RangerClub.TASK_IDS.PIDGEOTTO = 15
RangerClub.TASK_IDS.GROWLITHE = 16
RangerClub.TASK_IDS.BEEDRILL = 17
RangerClub.TASK_IDS.BUTTERFREE = 18
RangerClub.TASK_IDS.ARBOK = 19
RangerClub.TASK_IDS.CLEFABLE = 20
RangerClub.TASK_IDS.GOLBAT = 21
RangerClub.TASK_IDS.WEEPINBELL = 22
RangerClub.TASK_IDS.GRAVELER = 23
RangerClub.TASK_IDS.MAGNETON = 24
RangerClub.TASK_IDS.HAUNTER = 25
RangerClub.TASK_IDS.WEEZING = 26
RangerClub.TASK_IDS.TANGELA = 27
RangerClub.TASK_IDS.RHYHORN = 28
RangerClub.TASK_IDS.SEADRA = 29
RangerClub.TASK_IDS.WIGGLYTUFF = 30
RangerClub.TASK_IDS.PIDGEOT = 31
RangerClub.TASK_IDS.FEAROW = 32
RangerClub.TASK_IDS.RAICHU = 33
RangerClub.TASK_IDS.SANDSLASH = 34
RangerClub.TASK_IDS.MAROWAK = 35
RangerClub.TASK_IDS.VILEPLUME = 36
RangerClub.TASK_IDS.VENOMOTH = 37
RangerClub.TASK_IDS.GOLDUCK = 38
RangerClub.TASK_IDS.MACHAMP = 39
RangerClub.TASK_IDS.GOLEM = 40
RangerClub.TASK_IDS.HYPNO = 41
RangerClub.TASK_IDS.RHYDON = 42
RangerClub.TASK_IDS.DEWGONG = 43
RangerClub.TASK_IDS.RAPIDASH = 44
RangerClub.TASK_IDS.POLIWRATH = 45
RangerClub.TASK_IDS.VENUSAUR = 46
RangerClub.TASK_IDS.CHARIZARD = 47
RangerClub.TASK_IDS.BLASTOISE = 48
RangerClub.TASK_IDS.ALAKAZAM = 49
RangerClub.TASK_IDS.TENTACRUEL = 50
RangerClub.TASK_IDS.GENGAR = 51
RangerClub.TASK_IDS.MAGMAR = 52
RangerClub.TASK_IDS.ELECTABUZZ = 53
RangerClub.TASK_IDS.NIDOKING = 54
RangerClub.TASK_IDS.NIDOQUEEN = 55
RangerClub.TASK_IDS.TAUROS = 56
RangerClub.TASK_IDS.SCYTHER = 57
RangerClub.TASK_IDS.KANGASKHAN = 58
RangerClub.TASK_IDS.DRATINI = 59
RangerClub.TASK_IDS.EEVEE = 60
RangerClub.TASK_IDS.GYARADOS = 61
RangerClub.TASK_IDS.ARCANINE = 62
RangerClub.TASK_IDS.VICTREEBEL = 63
RangerClub.TASK_IDS.MUK = 64
RangerClub.TASK_IDS.CLOYSTER = 65
RangerClub.TASK_IDS.JYNX = 66
RangerClub.TASK_IDS.PINECO = 67
RangerClub.TASK_IDS.CYNDAQUIL = 68
RangerClub.TASK_IDS.TOTODILE = 69
RangerClub.TASK_IDS.HOPPIP = 70
RangerClub.TASK_IDS.CHIKORITA = 71
RangerClub.TASK_IDS.DUNSPARCE = 72
RangerClub.TASK_IDS.AIPOM = 73
RangerClub.TASK_IDS.SPINARAK = 74
RangerClub.TASK_IDS.YANMA = 75

-- Test
local aux = {}
for k, v in pairs(RangerClub.TASK_IDS) do
    if (table.find(aux, v)) then
        log(LOG_TYPES.ERROR, "RangerClub - Duplicated task id.", k, v)
    else
        aux[k] = v
    end
end
aux = nil
--
RangerClub.TASKS = {}
RangerClub.TASKS[RangerClub.TASK_IDS.CATERPIE] = {
    id = RangerClub.TASK_IDS.CATERPIE,
    name = "Caterpie",
    monster = "Caterpie",
    defeats = 10,
    boss = RangerClub.BOSS_IDS.CATERPIE,
    defeatsStorage = 20200,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 1,
        items = {
            {itemid = 12244, count = 10, unique = true} -- pokemon health potion
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.RATTATA] = {
    id = RangerClub.TASK_IDS.RATTATA,
    name = "Rattata",
    monster = "Rattata",
    defeats = 15,
    boss = RangerClub.BOSS_IDS.RATTATA,
    defeatsStorage = 20201,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 1,
        items = {
            {itemid = 12157, count = 15, unique = true} -- empty poke ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.EKANS] = {
    id = RangerClub.TASK_IDS.EKANS,
    name = "Ekans",
    monster = "Ekans",
    defeats = 20,
    boss = RangerClub.BOSS_IDS.EKANS,
    defeatsStorage = 20202,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 2,
        items = {
            {itemid = 12161, count = 15, unique = true} -- empty great ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.PIDGEY] = {
    id = RangerClub.TASK_IDS.PIDGEY,
    name = "Pidgey",
    monster = "Pidgey",
    defeats = 25,
    boss = RangerClub.BOSS_IDS.PIDGEY,
    defeatsStorage = 20203,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 2,
        items = {
            {itemid = 12244, count = 15, unique = true} -- pokemon health potion
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.SANDSHREW] = {
    id = RangerClub.TASK_IDS.SANDSHREW,
    name = "Sandshrew",
    monster = "Sandshrew",
    defeats = 35,
    boss = RangerClub.BOSS_IDS.SANDSHREW,
    defeatsStorage = 20204,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 2,
        items = {
            {itemid = 2687, count = 30, unique = true}, -- cookie
            {itemid = 12249, count = 5, unique = true}, -- pokemon antidote
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CLEFAIRY] = {
    id = RangerClub.TASK_IDS.CLEFAIRY,
    name = "Clefairy",
    monster = "Clefairy",
    defeats = 50,
    boss = RangerClub.BOSS_IDS.CLEFAIRY,
    defeatsStorage = 20205,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 3,
        items = {
            {itemid = 12157, count = 20, unique = true} -- empty poke ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.MEOWTH] = {
    id = RangerClub.TASK_IDS.MEOWTH,
    name = "Meowth",
    monster = "Meowth",
    defeats = 40,
    boss = RangerClub.BOSS_IDS.MEOWTH,
    defeatsStorage = 20206,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 3,
        items = {
            {itemid = 12161, count = 10, unique = true} -- empty great ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.ABRA] = {
    id = RangerClub.TASK_IDS.ABRA,
    name = "Abra",
    monster = "Abra",
    defeats = 40,
    boss = RangerClub.BOSS_IDS.ABRA,
    defeatsStorage = 20207,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 3,
        items = {
            {itemid = 2152, count = 2, unique = nil} -- note of hundred dollars
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.PONYTA] = {
    id = RangerClub.TASK_IDS.PONYTA,
    name = "Ponyta",
    monster = "Ponyta",
    defeats = 50,
    boss = RangerClub.BOSS_IDS.PONYTA,
    defeatsStorage = 20208,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 3,
        items = {
            {itemid = 12244, count = 10, unique = true} -- pokemon health potion
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CUBONE] = {
    id = RangerClub.TASK_IDS.CUBONE,
    name = "Cubone",
    monster = "Cubone",
    defeats = 60,
    boss = RangerClub.BOSS_IDS.CUBONE,
    defeatsStorage = 20209,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
            {itemid = 2152, count = 3, unique = nil}, -- note of hundred dollars
            {itemid = 2687, count = 20, unique = true}, -- cookie
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.SQUIRTLE] = {
    id = RangerClub.TASK_IDS.SQUIRTLE,
    name = "Squirtle",
    monster = "Squirtle",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.SQUIRTLE,
    defeatsStorage = 20211,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
            {itemid = 2152, count = 4, unique = nil}, -- note of hundred dollars
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.BULBASAUR] = {
    id = RangerClub.TASK_IDS.BULBASAUR,
    name = "Bulbasaur",
    monster = "Bulbasaur",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.BULBASAUR,
    defeatsStorage = 20212,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
            {itemid = 2152, count = 4, unique = nil}, -- note of hundred dollars
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CHARMANDER] = {
    id = RangerClub.TASK_IDS.CHARMANDER,
    name = "Charmander",
    monster = "Charmander",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.CHARMANDER,
    defeatsStorage = 20213,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
            {itemid = 2152, count = 4, unique = nil}, -- note of hundred dollars
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.SEEL] = {
    id = RangerClub.TASK_IDS.SEEL,
    name = "Seel",
    monster = "Seel",
    defeats = 40,
    boss = RangerClub.BOSS_IDS.SEEL,
    defeatsStorage = 20217,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 5,
        items = {
            {itemid = 12161, count = 10, unique = true} -- empty great ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.PIDGEOTTO] = {
    id = RangerClub.TASK_IDS.PIDGEOTTO,
    name = "Pidgeotto",
    monster = "Pidgeotto",
    defeats = 50,
    boss = RangerClub.BOSS_IDS.PIDGEOTTO,
    defeatsStorage = 20218,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
            {itemid = 2152, count = 3, unique = nil}, -- note of hundred dollars
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.GROWLITHE] = {
    id = RangerClub.TASK_IDS.GROWLITHE,
    name = "Growlithe",
    monster = "Growlithe",
    defeats = 100,
    boss = RangerClub.BOSS_IDS.GROWLITHE,
    defeatsStorage = 20219,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 15,
        items = {
            {itemid = 12161, count = 20, unique = true}, -- empty great ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.BEEDRILL] = {
    id = RangerClub.TASK_IDS.BEEDRILL,
    name = "Beedrill",
    monster = "Beedrill",
    defeats = 110,
    boss = RangerClub.BOSS_IDS.BEEDRILL,
    defeatsStorage = 20220,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 15,
        items = {
            {itemid = 13653, count = 10, unique = true}, -- energy potion
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.BUTTERFREE] = {
    id = RangerClub.TASK_IDS.BUTTERFREE,
    name = "Butterfree",
    monster = "Butterfree",
    defeats = 70,
    boss = RangerClub.BOSS_IDS.BUTTERFREE,
    defeatsStorage = 20221,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 15,
        items = {
            {itemid = 13182, count = 5, unique = true}, -- cheri berry
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.ARBOK] = {
    id = RangerClub.TASK_IDS.ARBOK,
    name = "Arbok",
    monster = "Arbok",
    defeats = 100,
    boss = RangerClub.BOSS_IDS.ARBOK,
    defeatsStorage = 20222,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 16,
        items = {
            {itemid = 12165, count = 10, unique = true}, -- empty ultra ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CLEFABLE] = {
    id = RangerClub.TASK_IDS.CLEFABLE,
    name = "Clefable",
    monster = "Clefable",
    defeats = 130,
    boss = RangerClub.BOSS_IDS.CLEFABLE,
    defeatsStorage = 20223,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 16,
        items = {
            {itemid = 12165, count = 10, unique = true}, -- empty ultra ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.GOLBAT] = {
    id = RangerClub.TASK_IDS.GOLBAT,
    name = "Golbat",
    monster = "Golbat",
    defeats = 105,
    boss = RangerClub.BOSS_IDS.GOLBAT,
    defeatsStorage = 20224,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 16,
        items = {
            {itemid = 2675, count = 10, unique = true}, -- orange
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.WEEPINBELL] = {
    id = RangerClub.TASK_IDS.WEEPINBELL,
    name = "Weepinbell",
    monster = "Weepinbell",
    defeats = 135,
    boss = RangerClub.BOSS_IDS.WEEPINBELL,
    defeatsStorage = 20225,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 16,
        items = {
            {itemid = 13183, count = 5, unique = true}, -- chesto berry
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.GRAVELER] = {
    id = RangerClub.TASK_IDS.GRAVELER,
    name = "Graveler",
    monster = "Graveler",
    defeats = 150,
    boss = RangerClub.BOSS_IDS.GRAVELER,
    defeatsStorage = 20226,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 17,
        items = {
            {itemid = 12248, count = 5, unique = true}, -- pokemon revive
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.MAGNETON] = {
    id = RangerClub.TASK_IDS.MAGNETON,
    name = "Magneton",
    monster = "Magneton",
    defeats = 170,
    boss = RangerClub.BOSS_IDS.MAGNETON,
    defeatsStorage = 20227,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 17,
        items = {
            {itemid = 12161, count = 30, unique = true}, -- empty great ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.HAUNTER] = {
    id = RangerClub.TASK_IDS.HAUNTER,
    name = "Haunter",
    monster = "Haunter",
    defeats = 105,
    boss = RangerClub.BOSS_IDS.HAUNTER,
    defeatsStorage = 20228,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 17,
        items = {
            {itemid = 13184, count = 10, unique = true}, -- pecha berry
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.WEEZING] = {
    id = RangerClub.TASK_IDS.WEEZING,
    name = "Weezing",
    monster = "Weezing",
    defeats = 150,
    boss = RangerClub.BOSS_IDS.WEEZING,
    defeatsStorage = 20229,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 17,
        items = {
            {itemid = 13653, count = 10, unique = true}, -- energy potion
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.TANGELA] = {
    id = RangerClub.TASK_IDS.TANGELA,
    name = "Tangela",
    monster = "Tangela",
    defeats = 110,
    boss = RangerClub.BOSS_IDS.TANGELA,
    defeatsStorage = 20230,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 18,
        items = {
            {itemid = 13186, count = 5, unique = true}, -- leppa berry
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.RHYHORN] = {
    id = RangerClub.TASK_IDS.RHYHORN,
    name = "Rhyhorn",
    monster = "Rhyhorn",
    defeats = 50,
    boss = RangerClub.BOSS_IDS.RHYHORN,
    defeatsStorage = 20231,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 18,
        items = {
            {itemid = 12165, count = 10, unique = true}, -- empty ultra ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.SEADRA] = {
    id = RangerClub.TASK_IDS.SEADRA,
    name = "Seadra",
    monster = "Seadra",
    defeats = 140,
    boss = RangerClub.BOSS_IDS.SEADRA,
    defeatsStorage = 20232,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 18,
        items = {
            {itemid = 14766, count = 5, unique = true}, -- aspear berry
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.WIGGLYTUFF] = {
    id = RangerClub.TASK_IDS.WIGGLYTUFF,
    name = "Wigglytuff",
    monster = "Wigglytuff",
    defeats = 105,
    boss = RangerClub.BOSS_IDS.WIGGLYTUFF,
    defeatsStorage = 20233,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 18,
        items = {
            {itemid = 14767, count = 5, unique = true}, -- oran berry
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.PIDGEOT] = {
    id = RangerClub.TASK_IDS.PIDGEOT,
    name = "Pidgeot",
    monster = "Pidgeot",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.PIDGEOT,
    defeatsStorage = 20234,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.FEAROW] = {
    id = RangerClub.TASK_IDS.FEAROW,
    name = "Fearow",
    monster = "Fearow",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.FEAROW,
    defeatsStorage = 20235,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
            {itemid = 12165, count = 20, unique = true}, -- empty ultra ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.RAICHU] = {
    id = RangerClub.TASK_IDS.RAICHU,
    name = "Raichu",
    monster = "Raichu",
    defeats = 300,
    boss = RangerClub.BOSS_IDS.RAICHU,
    defeatsStorage = 20236,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.SANDSLASH] = {
    id = RangerClub.TASK_IDS.SANDSLASH,
    name = "Sandslash",
    monster = "Sandslash",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.SANDSLASH,
    defeatsStorage = 20237,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
            {itemid = 2675, count = 20, unique = true}, -- orange
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.MAROWAK] = {
    id = RangerClub.TASK_IDS.MAROWAK,
    name = "Marowak",
    monster = "Marowak",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.MAROWAK,
    defeatsStorage = 20238,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.VILEPLUME] = {
    id = RangerClub.TASK_IDS.VILEPLUME,
    name = "Vileplume",
    monster = "Vileplume",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.VILEPLUME,
    defeatsStorage = 20239,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.VENOMOTH] = {
    id = RangerClub.TASK_IDS.VENOMOTH,
    name = "Venomoth",
    monster = "Venomoth",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.VENOMOTH,
    defeatsStorage = 20240,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.GOLDUCK] = {
    id = RangerClub.TASK_IDS.GOLDUCK,
    name = "Golduck",
    monster = "Golduck",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.GOLDUCK,
    defeatsStorage = 20241,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
            {itemid = 12248, count = 5, unique = true}, -- pokemon revive
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.MACHAMP] = {
    id = RangerClub.TASK_IDS.MACHAMP,
    name = "Machamp",
    monster = "Machamp",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.MACHAMP,
    defeatsStorage = 20242,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.GOLEM] = {
    id = RangerClub.TASK_IDS.GOLEM,
    name = "Golem",
    monster = "Golem",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.GOLEM,
    defeatsStorage = 20243,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
            {itemid = 18628, count = 10, unique = true}, -- empty coloured ball
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.HYPNO] = {
    id = RangerClub.TASK_IDS.HYPNO,
    name = "Hypno",
    monster = "Hypno",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.HYPNO,
    defeatsStorage = 20244,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.RHYDON] = {
    id = RangerClub.TASK_IDS.RHYDON,
    name = "Rhydon",
    monster = "Rhydon",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.RHYDON,
    defeatsStorage = 20245,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.DEWGONG] = {
    id = RangerClub.TASK_IDS.DEWGONG,
    name = "Dewgong",
    monster = "Dewgong",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.DEWGONG,
    defeatsStorage = 20246,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.RAPIDASH] = {
    id = RangerClub.TASK_IDS.RAPIDASH,
    name = "Rapidash",
    monster = "Rapidash",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.RAPIDASH,
    defeatsStorage = 20247,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
            {itemid = 13305, count = 15, unique = true}, -- lava cookie
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.POLIWRATH] = {
    id = RangerClub.TASK_IDS.POLIWRATH,
    name = "Poliwrath",
    monster = "Poliwrath",
    defeats = 250,
    boss = RangerClub.BOSS_IDS.POLIWRATH,
    defeatsStorage = 20248,
    requiredRank = RangerClub.RANK_IDS.COORDINATOR,
    rewards = {
        experience = 0,
        points = 30,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.VENUSAUR] = {
    id = RangerClub.TASK_IDS.VENUSAUR,
    name = "Venusaur",
    monster = "Venusaur",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.VENUSAUR,
    defeatsStorage = 20249,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CHARIZARD] = {
    id = RangerClub.TASK_IDS.CHARIZARD,
    name = "Charizard",
    monster = "Charizard",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.CHARIZARD,
    defeatsStorage = 20250,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.BLASTOISE] = {
    id = RangerClub.TASK_IDS.BLASTOISE,
    name = "Blastoise",
    monster = "Blastoise",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.BLASTOISE,
    defeatsStorage = 20251,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.ALAKAZAM] = {
    id = RangerClub.TASK_IDS.ALAKAZAM,
    name = "Alakazam",
    monster = "Alakazam",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.ALAKAZAM,
    defeatsStorage = 20252,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.TENTACRUEL] = {
    id = RangerClub.TASK_IDS.TENTACRUEL,
    name = "Tentacruel",
    monster = "Tentacruel",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.TENTACRUEL,
    defeatsStorage = 20253,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.GENGAR] = {
    id = RangerClub.TASK_IDS.GENGAR,
    name = "Gengar",
    monster = "Gengar",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.GENGAR,
    defeatsStorage = 20254,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.MAGMAR] = {
    id = RangerClub.TASK_IDS.MAGMAR,
    name = "Magmar",
    monster = "Magmar",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.MAGMAR,
    defeatsStorage = 20255,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.ELECTABUZZ] = {
    id = RangerClub.TASK_IDS.ELECTABUZZ,
    name = "Electabuzz",
    monster = "Electabuzz",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.ELECTABUZZ,
    defeatsStorage = 20256,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.NIDOKING] = {
    id = RangerClub.TASK_IDS.NIDOKING,
    name = "Nidoking",
    monster = "Nidoking",
    defeats = 400,
    boss = RangerClub.BOSS_IDS.NIDOKING,
    defeatsStorage = 20257,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.NIDOQUEEN] = {
    id = RangerClub.TASK_IDS.NIDOQUEEN,
    name = "Nidoqueen",
    monster = "Nidoqueen",
    defeats = 400,
    boss = RangerClub.BOSS_IDS.NIDOQUEEN,
    defeatsStorage = 20258,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.TAUROS] = {
    id = RangerClub.TASK_IDS.TAUROS,
    name = "Tauros",
    monster = "Tauros",
    defeats = 25,
    boss = RangerClub.BOSS_IDS.TAUROS,
    defeatsStorage = 20259,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.SCYTHER] = {
    id = RangerClub.TASK_IDS.SCYTHER,
    name = "Scyther",
    monster = "Scyther",
    defeats = 25,
    boss = RangerClub.BOSS_IDS.SCIZOR,
    defeatsStorage = 20260,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.KANGASKHAN] = {
    id = RangerClub.TASK_IDS.KANGASKHAN,
    name = "Kangaskhan",
    monster = "Kangaskhan",
    defeats = 25,
    boss = RangerClub.BOSS_IDS.KANGASKHAN,
    defeatsStorage = 20261,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.DRATINI] = {
    id = RangerClub.TASK_IDS.DRATINI,
    name = "Dratini",
    monster = "Dratini",
    defeats = 100,
    boss = RangerClub.BOSS_IDS.DRATINI,
    defeatsStorage = 20262,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.EEVEE] = {
    id = RangerClub.TASK_IDS.EEVEE,
    name = "Eevee",
    monster = "Eevee",
    defeats = 10,
    boss = RangerClub.BOSS_IDS.EEVEE,
    defeatsStorage = 20263,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.GYARADOS] = {
    id = RangerClub.TASK_IDS.GYARADOS,
    name = "Gyarados",
    monster = "Gyarados",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.GYARADOS,
    defeatsStorage = 20320,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.ARCANINE] = {
    id = RangerClub.TASK_IDS.ARCANINE,
    name = "Arcanine",
    monster = "Arcanine",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.ARCANINE,
    defeatsStorage = 20321,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.VICTREEBEL] = {
    id = RangerClub.TASK_IDS.VICTREEBEL,
    name = "Victreebel",
    monster = "Victreebel",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.VICTREEBEL,
    defeatsStorage = 20322,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.MUK] = {
    id = RangerClub.TASK_IDS.MUK,
    name = "Muk",
    monster = "Muk",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.MUK,
    defeatsStorage = 20323,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CLOYSTER] = {
    id = RangerClub.TASK_IDS.CLOYSTER,
    name = "Cloyster",
    monster = "Cloyster",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.CLOYSTER,
    defeatsStorage = 20324,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.JYNX] = {
    id = RangerClub.TASK_IDS.JYNX,
    name = "Jynx",
    monster = "Jynx",
    defeats = 500,
    boss = RangerClub.BOSS_IDS.JYNX,
    defeatsStorage = 20325,
    requiredRank = RangerClub.RANK_IDS.COACH,
    rewards = {
        experience = 0,
        points = 50,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.PINECO] = {
    id = RangerClub.TASK_IDS.PINECO,
    name = "Pineco",
    monster = "Pineco",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.PINECO,
    defeatsStorage = 20332,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CYNDAQUIL] = {
    id = RangerClub.TASK_IDS.CYNDAQUIL,
    name = "Cyndaquil",
    monster = "Cyndaquil",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.CYNDAQUIL,
    defeatsStorage = 20333,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.TOTODILE] = {
    id = RangerClub.TASK_IDS.TOTODILE,
    name = "Totodile",
    monster = "Totodile",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.TOTODILE,
    defeatsStorage = 20334,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.HOPPIP] = {
    id = RangerClub.TASK_IDS.HOPPIP,
    name = "Hoppip",
    monster = "Hoppip",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.HOPPIP,
    defeatsStorage = 20335,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.CHIKORITA] = {
    id = RangerClub.TASK_IDS.CHIKORITA,
    name = "Chikorita",
    monster = "Chikorita",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.CHIKORITA,
    defeatsStorage = 20336,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.DUNSPARCE] = {
    id = RangerClub.TASK_IDS.DUNSPARCE,
    name = "Dunsparce",
    monster = "Dunsparce",
    defeats = 70,
    boss = RangerClub.BOSS_IDS.DUNSPARCE,
    defeatsStorage = 20337,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 15,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.AIPOM] = {
    id = RangerClub.TASK_IDS.AIPOM,
    name = "Aipom",
    monster = "Aipom",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.AIPOM,
    defeatsStorage = 20338,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.SPINARAK] = {
    id = RangerClub.TASK_IDS.SPINARAK,
    name = "Spinarak",
    monster = "Spinarak",
    defeats = 90,
    boss = RangerClub.BOSS_IDS.SPINARAK,
    defeatsStorage = 20339,
    requiredRank = RangerClub.RANK_IDS.ROOKIE,
    rewards = {
        experience = 0,
        points = 4,
        items = {
        }
    }
}

RangerClub.TASKS[RangerClub.TASK_IDS.YANMA] = {
    id = RangerClub.TASK_IDS.YANMA,
    name = "Yanma",
    monster = "Yanma",
    defeats = 70,
    boss = RangerClub.BOSS_IDS.YANMA,
    defeatsStorage = 20340,
    requiredRank = RangerClub.RANK_IDS.MENTOR,
    rewards = {
        experience = 0,
        points = 15,
        items = {
        }
    }
}

for _, task in pairs(RangerClub.TASKS) do
    table.insert(RangerClub.RANKS[task.requiredRank].tasks, task)

    --[[if (task.boss) then -- Unused
        RangerClub.BOSSES[task.boss].requiredRank = task.requiredRank
    end]]
end

--[[
local _test = {}
for _, task in pairs(RangerClub.TASKS) do
    if (table.find(_test, task.defeatsStorage)) then
        print("RangerClub: Duplicated defeated storage: ")
        table.print(task)
    end
    table.insert(_test, task.defeatsStorage)
end

local _testBoss = {}
for _, task in pairs(RangerClub.TASKS) do
    if (task.boss) then
        if (table.find(_testBoss, task.boss)) then
            print("RangerClub: Duplicated boss: ")
            table.print(task)
        end
        table.insert(_testBoss, task.boss)
    end
end
]]
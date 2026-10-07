-- PokeNation constants shared by the Pokemon UI modules. Values come from the legacy client
-- (client/modules/gamelib/const.lua, game_statusbar, game_pokedex) and the server scripts named
-- next to each table; they must match the server, not be redefined here.

-- Trainer "skills" (server/data/lib/ps/others/constants.lua, legacy gamelib/const.lua:2-8).
PLAYER_SKILL_DUEL_WIN = 0
PLAYER_SKILL_DUEL_LOSS = 1
PLAYER_SKILL_BATTLE_WIN = 2
PLAYER_SKILL_BATTLE_LOSS = 3
PLAYER_SKILL_HEADBUTTING = 4
PLAYER_SKILL_CATCHING = 5
PLAYER_SKILL_FISHING = 6

PokeNation = PokeNation or {}

-- Legacy PSoul images staged by tools/stage_pokenation_assets.py (client/data/images/<dir>).
PokeNation.IMAGES = '/images/psoul/'

-- Pokemon bar label colours sent by the server (006-fastcall.lua, balls.lua, onPokemonDeath.lua).
PokeNation.BarTextColor = {
    Healthy = 0, -- >= 80 %
    Hurt = 1,    -- >= 40 %
    Critical = 2, -- < 40 % or fainted ("FNT")
    InUse = 3    -- "USE": this Pokemon is the summoned one
}

-- 0xFF 0x0E status icons (server lib/ps/systems/008-conditions.lua; legacy game_statusbar).
PokeNation.STATUS_BY_ITEMID = {
    [16715] = 'Burn',
    [16716] = 'Freeze',
    [16717] = 'Paralyze',
    [16718] = 'Poison',
    [16719] = 'Sleep',
    [16720] = 'Confusion',
    [16721] = 'Low Accuracy',
    [16722] = 'Extra Speed',
    [16723] = 'Lower Attack',
    [16724] = 'Extra Attack',
    [16725] = 'Lower Defense',
    [16726] = 'Extra Defense',
    [16727] = 'Insomnia',
    [16728] = 'Reflect',
    [16729] = 'Prevent Status',
    [16730] = 'Flinch',
    [16731] = 'Bad Poison',
    [16732] = 'High Critical Chance',
    [16733] = 'Recharge',
    [16734] = 'Infatuate',
    [16735] = 'Store Damage',
    [16736] = 'Counter',
    [16737] = 'Substitute',
    [16738] = 'Charge',
    [11205] = 'Health +1',
    [11206] = 'Health +2',
    [11207] = 'Health +3',
    [11208] = 'Health +4',
    [17393] = 'Blink',
    [17587] = 'Stockpile Charge 1',
    [17588] = 'Stockpile Charge 2',
    [17589] = 'Stockpile Charge 3'
}

-- 0xFF 0x0A / 0x0C Pokedex entry status (server lib/ps/systems/010-pokedex.lua; legacy game_pokedex).
PokeNation.DexStatus = {
    UNKNOWN = 0,
    DEXED = 1,
    CATCHED = 2,
    SHINYCATCHED = 3,
    DEXED_CATCHED = 4,
    DEXED_SHINYCATCHED = 5,
    DEXED_CATCHED_SHINYCATCHED = 6,
    CATCHED_SHINYCATCHED = 7
}

-- Highest move slot the server accepts ("m1".."m16", server/data/talkactions/talkactions.xml).
PokeNation.MAX_MOVES = 16

local TM_GROUP_IDS = {
    OFFENSIVE = 0,
    SUPPORT = 1,
    HEAL = 2
}

local TMS = {
    [TM_IDS.MEGA_PUNCH] = {
        move = "Mega Punch",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17337,
        requiredLevel = 40
    },
    [TM_IDS.RAZOR_WIND] = {
        move = "Razor Wind",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17338,
        requiredLevel = 40
    },
    [TM_IDS.SWORDS_DANCE] = {
        move = "Swords Dance",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 17339,
        requiredLevel = 20
    },
    --[[ [TM_IDS.WHIRLWIND] = {
        move = "Whirlwind",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17340,
        requiredLevel = 20
    }, ]]
    [TM_IDS.MEGA_KICK] = {
        move = "Mega Kick",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17341,
        requiredLevel = 60
    },
    [TM_IDS.TOXIC] = {
        move = "Toxic",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17342,
        requiredLevel = 20
    },
    [TM_IDS.HORN_DRILL] = {
        move = "Horn Drill",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17343,
        requiredLevel = 40
    },
    [TM_IDS.BODY_SLAM] = {
        move = "Body Slam",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17344,
        requiredLevel = 40
    },
    [TM_IDS.TAKE_DOWN] = {
        move = "Take Down",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17345,
        requiredLevel = 40
    },
    [TM_IDS.DOUBLE_EDGE] = {
        move = "Double-Edge",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17346,
        requiredLevel = 40
    },
    [TM_IDS.BUBBLEBEAM] = {
        move = "Bubblebeam",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17347,
        requiredLevel = 20
    },
    [TM_IDS.WATER_GUN] = {
        move = "Water Gun",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17348,
        requiredLevel = 20
    },
    [TM_IDS.ICE_BEAM] = {
        move = "Ice Beam",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17349,
        requiredLevel = 40
    },
    [TM_IDS.BLIZZARD] = {
        move = "Blizzard",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17350,
        requiredLevel = 60
    },
    [TM_IDS.HYPER_BEAM] = {
        move = "Hyper Beam",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17351,
        requiredLevel = 60
    },
    --[[[TM_IDS.PAY_DAY] = {
        move = "Pay Day",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17352,
        requiredLevel = 20
    },]]
    [TM_IDS.SUBMISSION] = {
        move = "Submission",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17352,
        requiredLevel = 40
    },
    [TM_IDS.COUNTER] = {
        move = "Counter",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 17353,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.SEISMIC_TOSS] = {
        move = "Seismic Toss",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17354,
        requiredLevel = 40
    },
    [TM_IDS.RAGE] = {
        move = "Rage",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17355,
        requiredLevel = 20
    },
    [TM_IDS.MEGA_DRAIN] = {
        move = "Mega Drain",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17356,
        requiredLevel = 20
    },
    [TM_IDS.SOLAR_BEAM] = {
        move = "Solar Beam",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17357,
        requiredLevel = 60
    },
    [TM_IDS.DRAGON_RAGE] = {
        move = "Dragon Rage",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17358,
        requiredLevel = 20
    },
    [TM_IDS.THUNDERBOLT] = {
        move = "Thunderbolt",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17359,
        requiredLevel = 20
    },
    [TM_IDS.THUNDER] = {
        move = "Thunder",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17360,
        requiredLevel = 60
    },
    [TM_IDS.EARTHQUAKE] = {
        move = "Earthquake",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17361,
        requiredLevel = 60
    },
    [TM_IDS.FISSURE] = {
        move = "Fissure",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17362,
        requiredLevel = 60
    },
    --[[[TM_IDS.DIG] = {
        move = ""
    },]]
    [TM_IDS.PSYCHIC] = {
        move = "Psychic",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17363,
        requiredLevel = 40
    },
    --[[[TM_IDS.TELEPORT] = {
        move = ""
    },]]
    [TM_IDS.MIMIC] = {
        move = "Mimic",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17364,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.DOUBLE_TEAM] = {
        move = "Double Team",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 17365,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.REFLECT] = {
        move = "Reflect",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 17366,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.BIDE] = {
        move = "Bide",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17367,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.METRONOME] = {
        move = "Metronome",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17368,
        requiredLevel = 40
    },
    [TM_IDS.SELFDESTRUCT] = {
        move = "Selfdestruct",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17369,
        requiredLevel = 40,
        unique = true
    },
    [TM_IDS.EGG_BOMB] = {
        move = "Egg Bomb",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17370,
        requiredLevel = 40
    },
    [TM_IDS.FIRE_BLAST] = {
        move = "Fire Blast",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17371,
        requiredLevel = 60
    },
    [TM_IDS.SWIFT] = {
        move = "Swift",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17372,
        requiredLevel = 20
    },
    [TM_IDS.SKULL_BASH] = {
        move = "Skull Bash",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17373,
        requiredLevel = 40
    },
    [TM_IDS.SOFTBOILED] = {
        move = "Softboiled",
        group = TM_GROUP_IDS.HEAL,
        itemid = 17374,
        requiredLevel = 40,
        unique = true,
        allLearn = true
    },
    [TM_IDS.DREAM_EATER] = {
        move = "Dream Eater",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17375,
        requiredLevel = 40
    },
    [TM_IDS.SKY_ATTACK] = {
        move = "Sky Attack",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17376,
        requiredLevel = 40
    },
    [TM_IDS.REST] = {
        move = "Rest",
        group = TM_GROUP_IDS.HEAL,
        itemid = 17377,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.THUNDER_WAVE] = {
        move = "Thunder Wave",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 17378,
        requiredLevel = 20
    },
    [TM_IDS.PSYWAVE] = {
        move = "Psywave",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17379,
        requiredLevel = 60
    },
    [TM_IDS.EXPLOSION] = {
        move = "Explosion",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17380,
        requiredLevel = 60
    },
    [TM_IDS.ROCK_SLIDE] = {
        move = "Rock Slide",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17381,
        requiredLevel = 40
    },
    [TM_IDS.TRI_ATTACK] = {
        move = "Tri Attack",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 17382,
        requiredLevel = 40
    },
    [TM_IDS.SUBSTITUTE] = {
        move = "Substitute",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 17383,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.DYNAMIC_PUNCH] = {
        move = "Dynamic Punch",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18912,
        requiredLevel = 60
    },
    [TM_IDS.HEADBUTT] = {
        move = "Headbutt",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18913,
        requiredLevel = 20
    },
    [TM_IDS.CURSE] = {
        move = "Curse",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 18914,
        requiredLevel = 20,
        allLearn = true
    },
    [TM_IDS.ZAP_CANNON] = {
        move = "Zap Cannon",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18915,
        requiredLevel = 60
    },
    [TM_IDS.SNORE] = {
        move = "Snore",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18916,
        requiredLevel = 20,
        allLearn = true
    },
    [TM_IDS.ICY_WIND] = {
        move = "Icy Wind",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18917,
        requiredLevel = 40
    },
    [TM_IDS.PROTECT] = {
        move = "Protect",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 18918,
        requiredLevel = 20,
        allLearn = true
    },
    [TM_IDS.RAIN_DANCE] = {
        move = "Rain Dance",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 18919,
        requiredLevel = 20
    },
    [TM_IDS.GIGA_DRAIN] = {
        move = "Giga Drain",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18920,
        requiredLevel = 40
    },
    [TM_IDS.IRON_TAIL] = {
        move = "Iron Tail",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18921,
        requiredLevel = 40
    },
    [TM_IDS.SHADOW_BALL] = {
        move = "Shadow Ball",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18922,
        requiredLevel = 40
    },
    [TM_IDS.MUD_SLAP] = {
        move = "Mud-Slap",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18923,
        requiredLevel = 20
    },
    [TM_IDS.ICE_PUNCH] = {
        move = "Ice Punch",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18924,
        requiredLevel = 40
    },
    [TM_IDS.SLUDGE_BOMB] = {
        move = "Sludge Bomb",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18925,
        requiredLevel = 40
    },
    [TM_IDS.DEFENSE_CURL] = {
        move = "Defense Curl",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 18926,
        requiredLevel = 20
    },
    [TM_IDS.THUNDER_PUNCH] = {
        move = "Thunder Punch",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18927,
        requiredLevel = 40
    },
    [TM_IDS.STEEL_WING] = {
        move = "Steel Wing",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18928,
        requiredLevel = 40
    },
    [TM_IDS.FIRE_PUNCH] = {
        move = "Fire Punch",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18929,
        requiredLevel = 40
    },
    [TM_IDS.FURY_CUTTER] = {
        move = "Fury Cutter",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18930,
        requiredLevel = 20
    },
    [TM_IDS.NIGHTMARE] = {
        move = "Nightmare",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 18931,
        requiredLevel = 60,
        unique = true
    },
    [TM_IDS.WATER_PULSE] = {
        move = "Water Pulse",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24716,
        requiredLevel = 40
    },
    [TM_IDS.ROCK_TOMB] = {
        move = "Rock Tomb",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24717,
        requiredLevel = 40
    },
    [TM_IDS.AERIAL_ACE] = {
        move = "Aerial Ace",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24718,
        requiredLevel = 40
    },
    [TM_IDS.FLAMETHROWER] = {
        move = "Flamethrower",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24719,
        requiredLevel = 40
    },
    [TM_IDS.ENERGY_BALL] = {
        move = "Energy Ball",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24720,
        requiredLevel = 40
    },
    [TM_IDS.DRAIN_PUNCH] = {
        move = "Drain Punch",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24721,
        requiredLevel = 40
    },
    [TM_IDS.POISON_JAB] = {
        move = "Poison Jab",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24722,
        requiredLevel = 40
    },
    [TM_IDS.AVALANCHE] = {
        move = "Avalanche",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 24723,
        requiredLevel = 40
    },
    [TM_IDS.FOCUS_PUNCH] = {
        move = "Focus Punch",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29157,
        requiredLevel = 60
    },
    [TM_IDS.DRAGON_CLAW] = {
        move = "Dragon Claw",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29158,
        requiredLevel = 40
    },
    [TM_IDS.CALM_MIND] = {
        move = "Calm Mind",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 29159,
        requiredLevel = 20
    },
    [TM_IDS.ROAR] = {
        move = "Roar",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29160,
        requiredLevel = 20
    },
    [TM_IDS.HAIL] = {
        move = "Hail",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29161,
        requiredLevel = 40
    },
    [TM_IDS.BULK_UP] = {
        move = "Bulk Up",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 29162,
        requiredLevel = 40
    },
    [TM_IDS.BULLET_SEED] = {
        move = "Bullet Seed",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29163,
        requiredLevel = 40
    },
    [TM_IDS.HIDDEN_POWER] = {
        move = "Hidden Power",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29164,
        requiredLevel = 40,
        allLearn = true
    },
    [TM_IDS.LIGHT_SCREEN] = {
        move = "Light Screen",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 29165,
        requiredLevel = 20
    },
    [TM_IDS.SAFEGUARD] = {
        move = "Safeguard",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 29166,
        requiredLevel = 40
    },
    [TM_IDS.BRICK_BREAK] = {
        move = "Brick Break",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29167,
        requiredLevel = 40
    },
    [TM_IDS.SHOCK_WAVE] = {
        move = "Shock Wave",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29168,
        requiredLevel = 40
    },
    [TM_IDS.SANDSTORM] = {
        move = "Sandstorm",
        group = TM_GROUP_IDS.SUPPORT,
        itemid = 29169,
        requiredLevel = 40
    },
    [TM_IDS.FACADE] = {
        move = "Facade",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29170,
        requiredLevel = 40,
        allLearn = true
    },
    [TM_IDS.SECRET_POWER] = {
        move = "Secret Power",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29171,
        requiredLevel = 40,
        allLearn = true
    },
    [TM_IDS.OVERHEAT] = {
        move = "Overheat",
        group = TM_GROUP_IDS.OFFENSIVE,
        itemid = 29172,
        requiredLevel = 60
    },
}

-- Auto generate TMs by itemid
local TM_BY_ITEMID = {}
for id, content in pairs(TMS) do
    TM_BY_ITEMID[content.itemid] = id
end

function getTmMove(tm)
    return TMS[tm].move
end

function getTmItemId(tm) -- TODO: This function can be removed after TS
    return TMS[tm].itemid
end

function getTmUnique(tm)
    return TMS[tm].unique or false
end

function getTmByItemId(itemId)
    return TM_BY_ITEMID[itemId]
end

function getTmAllLearn(tmId)
    return TMS[tmId].allLearn
end

function getTmByMove(move)
    for tmId, tm in pairs(TMS) do
        if (tm.move == move) then
            return tmId
        end
    end
end

local function canLearn(cid, tm, ball, tmId)
    if (not isItem(tm) or not isItem(ball) or not isBallWithPokemon(ball.uid)) then
        return __L(cid, "Sorry, not possible.")

    elseif (isPokemonOnline(cid)) then
        return __L(cid, "You can not do it while you have a Pokemon out of the ball.")

    elseif (not getPokemonTmLearnable(getBallPokemonName(ball.uid), tmId)) then
        return __L(cid, "Your Pokemon can't learn this Technical Machine.")

    elseif (table.find(getPokemonSkills(getBallPokemonName(ball.uid), ball.uid), TMS[tmId].move)) then
        return __L(cid, "Your Pokemon already know this move.")

    elseif (getBallTm(ball.uid, 1) ~= TM_IDS.NONE and getBallTm(ball.uid, 2) ~= TM_IDS.NONE) then
        return __L(cid, "Your Pokemon can't learn more moves by Technical Machine.")

    elseif (getItemUniqueOwner(ball.uid) > 0 and getItemUniqueOwner(ball.uid) ~= getPlayerGUID(cid)) then
        return __L(cid, "You can't teach to unique Pokemon of other player.")

    elseif (getBallPokemonLevel(ball.uid) < TMS[tmId].requiredLevel) then
        return string.format(__L(cid, "Your Pokemon level isn't enough to learn this Move, its required at least level %s."),TMS[tmId].requiredLevel)

    elseif (getBallFromNpc(ball.uid)) then
        return __L(cid, "You cannot teach a Technical Machine to a NPC Pokemon.")
    end

    return true
end

function onCreatureUseTm(cid, item, fromPosition, itemEx, toPosition)
    if (getPlayerFrontierIsland(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local tm = TM_BY_ITEMID[item.itemid]
    if (not tm) then
        log(LOG_TYPES.ERROR, "onCreatureUseTm - Unknown item.itemid", cid, item, fromPosition, itemEx, toPosition)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local learnable = canLearn(cid, item, itemEx, tm)
    if (type(learnable) == "string") then
        doPlayerSendCancel(cid, learnable)
        return false
    end

    local movesClientId = {}
    for i, move in ipairs(getPokemonSkills(getBallPokemonName(itemEx.uid), itemEx.uid)) do
        if (move ~= "Tackle") then
            movesClientId[i] = getPokemonSkillClientIconId(move)
        end
    end

    setPlayerLastUsedTm(cid, item.uid)
    setPlayerLastUsedTmBall(cid, itemEx.uid)

    if (PokemonEgg.isChoosingEggMove(cid)) then
        PokemonEgg.removeChooseCondition(cid) -- We need to to this cuz both systems use the same window. If a player starts choosing an egg move and close the window, an error can occurr when the player tries to choose a TM.
    end

    doPlayerSendTmWindow(cid, getPokemonSkillClientIconId(TMS[tm].move), movesClientId)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Select the move that will be replaced by %s. (Shift + Click on move icon to details)"), TMS[tm].move))
    return true
end

function canTmReplaceMove(replacingMove, tmId, ball)
    if (replacingMove == "Tackle") then
        return false
    end

    local currentMoves = getPokemonSkills(getBallPokemonName(ball.uid), ball.uid)
    if (TMS[tmId].group == TM_GROUP_IDS.HEAL and not getPokemonSkillMakeHeal(replacingMove)) then
        for _, move in pairs(currentMoves) do
            if (getPokemonSkillMakeHeal(move)) then
                return false
            end
        end
    end

    local tm1, tm2 = getBallTm(ball.uid, 1), getBallTm(ball.uid, 2)
    if ((tm1 ~= TM_IDS.NONE and getTmMove(tm1) == replacingMove) or
            (tm2 ~= TM_IDS.NONE and getTmMove(tm2) == replacingMove)) then
        return false
    end

    local eggMoveSlot = getBallEggMoveSlot(ball.uid)
    if (eggMoveSlot and currentMoves[eggMoveSlot] == replacingMove) then
        return false -- replacing egg move by tm
    end

    return true
end

function onTmChoose(cid, replacedMoveClientItemId)
    if (PokemonEgg.isChoosingEggMove(cid)) then
        PokemonEgg.onMoveChoose(cid, replacedMoveClientItemId)
        return true
    end

    local tm, ball = getPlayerLastUsedTm(cid), getPlayerLastUsedTmBall(cid)
    if (not isItem(ball) or not isItem(tm) or (isItemUnique(ball.uid) and getBallUniqueFromTournament(ball.uid)) or
            getPlayerTournamentReady(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local tmId = TM_BY_ITEMID[tm.itemid]
    if (not tmId) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local learnable = canLearn(cid, tm, ball, tmId)
    if (isString(learnable)) then
        doPlayerSendCancel(cid, learnable)
        return false
    end

    local replacingMove = getPokemonSkillByClientIconId(replacedMoveClientItemId)
    if (replacingMove == "Tackle") then
        doPlayerSendCancel(cid, "You can't replace the move Tackle.")
        return false
    end

    local currentMoves = getPokemonSkills(getBallPokemonName(ball.uid), ball.uid)

    local eggMoveSlot = getBallEggMoveSlot(ball.uid)
    if (eggMoveSlot and currentMoves[eggMoveSlot] == replacingMove) then
        doPlayerSendCancel(cid, "You can't replace an egg move.")
        return false -- replacing egg move by tm
    end

    if (TMS[tmId].group == TM_GROUP_IDS.HEAL and not getPokemonSkillMakeHeal(replacingMove)) then
        for _, move in pairs(currentMoves) do
            if (getPokemonSkillMakeHeal(move)) then
                doPlayerSendCancel(cid, "Your Pokemon can't learn more heal moves.")
                return false
            end
        end
    end

    local tm1, tm2, tmSlot = getBallTm(ball.uid, 1), getBallTm(ball.uid, 2), 0
    if (tm1 ~= TM_IDS.NONE and tm2 ~= TM_IDS.NONE) then
        doPlayerSendCancel(cid, "Your Pokemon already learned two moves by Techinical Machine.")
        return false

    elseif (tm1 == TM_IDS.NONE) then
        if (tm2 ~= TM_IDS.NONE and TMS[tmId].group == TMS[tm2].group) then
            doPlayerSendCancel(cid, "You can't teach two moves that remains to the same Techinical Machine group.")
            return false
        end

        tmSlot = 1

    elseif (tm2 == TM_IDS.NONE) then
        if (tm1 ~= TM_IDS.NONE and TMS[tmId].group == TMS[tm1].group) then
            doPlayerSendCancel(cid, "You can't teach two moves that remains to the same Techinical Machine group.")
            return false
        end

        tmSlot = 2
    end

    if ((tm1 ~= TM_IDS.NONE and getTmMove(tm1) == replacingMove) or
            (tm2 ~= TM_IDS.NONE and getTmMove(tm2) == replacingMove)) then
        doPlayerSendCancel(cid, "You can't replace a move learned through Techinical Machine, first remove it.")
        return false
    end

    local slot = table.find(currentMoves, getPokemonSkillByClientIconId(replacedMoveClientItemId))
    if (not slot) then
        log(LOG_TYPES.ERROR, "onTmChoose - nil slot, replacingMove can't be found on currentMoves",
            getCreatureName(cid), tm, ball, learnable, replacedMoveClientItemId)
        return false
    end

    local pokemonName = getBallPokemonName(ball.uid)

    if ((TMS[tmId].unique or getItemUniqueOwner(tm.uid) ~= ITEM_UNIQUE_OWNER_NONE)) then
        if (not isItemUnique(ball.uid)) then
            setItemUniqueOwner(ball.uid, cid)
            setBallUniqueFromTm(ball.uid, true)
        end
        setBallUniqueFromTmSlot(ball.uid, tmSlot, true)
    end

    setBallTm(ball.uid, tmSlot, slot, tmId)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "1, 2, and ... ... ... Poof! %s forgot %s. And... Machine Set! %s learned %s!"), pokemonName, replacingMove, pokemonName, TMS[tmId].move))
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_BLUE)
    doPlayerUpdatePokemonMoves(cid, ball.uid, nil, pokemonName)
    doBallUpdateDescription(ball.uid)
    doRemoveItem(tm.uid, 1)
    return true
end

--[[ ]]
local function checkTm(cid, ballUid, number, balls)
    local tmId = getBallTm(ballUid, number)
    if (tmId ~= TM_IDS.NONE) then
        if (TMS[tmId].unique) then
            for _, ball in pairs(balls) do
                if (ballUid ~= ball.uid) then
		            local tmpNumber = 1
                    local tmpTm = getBallTm(ball.uid, 1)
                    if (tmpTm ~= tmId) then
                        tmpTm = getBallTm(ball.uid, 2)
			            tmpNumber = 2
                    end

                    if (tmpTm == tmId) then
                        setBallTm(ball.uid, tmpNumber, nil, TM_IDS.NONE)
                        setBallUniqueFromTmSlot(ball.uid, tmpNumber, false)
                        doBallUpdateDescription(ball.uid)
                        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your %s loses TM %s due to bug abuse (duplicated unique TM)."), getBallPokemonName(ball.uid), getTmMove(tmId)))
                        log(LOG_TYPES.WARNING, "Duplicated unique TM removed.", getPlayerName(cid), tmId)

                        if (getBallUniqueFromTm(ball.uid)) then
                            local tmpSlot = (tmpNumber == 1 and 2 or 1)
                            local tmpTm = getBallTm(ball.uid, tmpSlot)
                            if (tmpTm == TM_IDS.NONE or not (getBallUniqueFromTmSlot(ball.uid, tmpSlot) or
                                    getTmUnique(tmpTm))) then -- We can't remove the unique if the other TM is unique too
                                doItemEraseUniqueOwner(ball.uid)
                            end
                        end
                    end
                end
            end
        end

        if (TMS[tmId].group == TM_GROUP_IDS.HEAL) then
            local defaultMoves, hasHeal = getPokemonDefaultSkills(getBallPokemonName(ballUid)), false
            for _, move in pairs(defaultMoves) do
                if (getPokemonSkillMakeHeal(move)) then
                    hasHeal = true
                    break
                end
            end

            if (hasHeal and not getPokemonSkillMakeHeal(defaultMoves[getBallTmSlot(ballUid, number)])) then
                setBallTm(ballUid, number, nil, TM_IDS.NONE)
                setBallUniqueFromTmSlot(ballUid, number, false)
                doBallUpdateDescription(ballUid)
                if (TMS[tmId].unique) then
                    setItemUniqueOwner(doPlayerAddItem(cid, TMS[tmId].itemid, 1, false), cid)
                end

                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your %s loses TM %s due to bug abuse (excessive heal moves)."), getBallPokemonName(ballUid), getTmMove(tmId)))
                log(LOG_TYPES.WARNING, "Excessive heal TM removed.", getPlayerName(cid), tmId)

                if (getBallUniqueFromTm(ballUid)) then
                    local tmpSlot = (number == 1 and 2 or 1)
                    local tmpTm = getBallTm(ballUid, tmpSlot)
                    if (tmpTm == TM_IDS.NONE or not (getBallUniqueFromTmSlot(ballUid, tmpSlot) or
                            getTmUnique(tmpTm))) then -- We can't remove the unique if the other TM is unique too
                        doItemEraseUniqueOwner(ballUid)
                    end
                end
            end
        end
    end
end

function doPlayerCheckTms(cid)
    local balls = getPlayerAllBallsWithPokemon(cid)
    for _, ball in pairs(balls) do
        checkTm(cid, ball.uid, 1, balls)
        checkTm(cid, ball.uid, 2, balls)
    end
end
-- Local vars
local OUTFIT_BIKE_MALE = createConditionObject(CONDITION_OUTFIT)
setConditionParam(OUTFIT_BIKE_MALE, CONDITION_PARAM_TICKS, -1)
addOutfitCondition(OUTFIT_BIKE_MALE, { lookType = 1744 })

local OUTFIT_BIKE_FEMALE = createConditionObject(CONDITION_OUTFIT)
setConditionParam(OUTFIT_BIKE_FEMALE, CONDITION_PARAM_TICKS, -1)
addOutfitCondition(OUTFIT_BIKE_FEMALE, { lookType = 1743 })

local UNLOCKED_MACH_BIKE_ID = 13218
local LOCKED_MACH_BIKE_ID = 13480

local EMPTY_PORTRAIT_ID = 12853
local EVOLVE_ICON_OFF_ID = 13205
local ORDER_ICON_OFF_ID = 13206
local DUEL_ICON_OFF_ID = 13207
local EVOLVE_ICON_ID = 13204
local ORDER_ICON_ID = 7730
local DUEL_ICON_ID = 13016
local PORTRAIT_CONTAINER_SIZE = 9
local EMPTY_SKILL_ID = 13442
--[[local UNLOCKED_OXYGEN_MASK_ID = 13299
local LOCKED_OXYGEN_MASK_ID = 13300]]

-- Get
function getPlayerPokemon(cid)
    return getCreatureStorage(cid, playersStorages.pokemonUid)
end

function getPlayerPokemonName(cid, referenceName)
    local pokemon = getPlayerPokemon(cid)
    if (isCreature(pokemon)) then
        if (referenceName and isPokemonTransformed(pokemon)) then
            return getPokemonCurrentTransformation(pokemon)
        end
        return getCreatureName(pokemon)
    end

    if (referenceName) then
        local ball = getPlayerBall(cid)
        if (isItem(ball)) then
            local transform = getBallCurrentTransform(ball.uid)
            if (transform) then
                return transform
            end
        end
    end

    return getCreatureStorage(cid, playersStorages.pokemonName)
end

function getPlayerPokemonNickname(cid)
    local pokemon = getPlayerPokemon(cid)
    if (isCreature(pokemon)) then
        return getCreatureNickname(pokemon)
    end

    local ball = getPlayerBall(cid)
    if (isItem(ball)) then
        local nick = getBallPokemonNickname(ball.uid)
        if (nick and nick ~= -1) then
            return nick
        end
    end

    return getCreatureStorage(cid, playersStorages.pokemonName)
end

function getPlayerBall(cid)
    return getPlayerSlotItem(cid, CONST_SLOT_FEET)
end

function getPlayerPokemonLevel(cid)
    return getBallPokemonLevel(getPlayerBall(cid).uid)
end

function getPlayerPokemonExperience(cid)
    return getBallPokemonExp(getPlayerBall(cid).uid)
end

function getPlayerPokemonNickname(cid)
    return getBallPokemonNickname(getPlayerBall(cid).uid) or getBallPokemonName(getPlayerBall(cid).uid)
end

function getPlayerTotalBattleWin(cid)
    return getPlayerSkillLevel(cid, PLAYER_SKILL_BATTLE_WIN)
end

function getPlayerTotalBattleLoss(cid)
    return getPlayerSkillLevel(cid, PLAYER_SKILL_BATTLE_LOSS)
end

function getPlayerRespect(cid)
    return getPlayerSoul(cid)
end

function getPlayerBackPosition(cid)
    local t = string.explode(getCreatureStorage(cid, playersStorages.tradeBackPosition), ";")
    if (t) then
        local pos = { x = t[2], y = t[3], z = t[4] }
        if (isWalkable(cid, pos)) then
            return pos
        end
    end

    return getTownTemplePosition(getPlayerTown(cid))
end

--[[
function getPlayerPvpArenaBackPosition(cid)
	local pvpArenaBackPositionTable = string.explode(getCreatureStorage(cid, playersStorages.pvpArenaBackPosition), ";")
	return {x = pvpArenaBackPositionTable[2], y = pvpArenaBackPositionTable[3], z = pvpArenaBackPositionTable[4]}
end
]]
function getPlayerAllBallsWithPokemon(cid)
    local ballsWithPokemon = {}

    local ballSlotItem = getPlayerSlotItem(cid, PLAYER_SLOT_BALL)
    if (isItem(ballSlotItem) and isBallWithPokemon(ballSlotItem.uid)) then
        table.insert(ballsWithPokemon, ballSlotItem)
    end

    local playerBackpack = getPlayerSlotItem(cid, PLAYER_SLOT_BACKPACK)
    if (isItem(playerBackpack) and isContainer(playerBackpack.uid)) then
        local items = getContainerItems(playerBackpack.uid)
        local i = #items
        local currentItem

        while (i > 0) do
            currentItem = items[i]

            if (isContainer(currentItem.uid)) then
                items = table_concat(items, getContainerItems(currentItem.uid))
            elseif (isBallWithPokemon(currentItem.uid)) then
                table.insert(ballsWithPokemon, currentItem)
            end

            table.remove(items, i)
            i = #items
        end
    end

    return ballsWithPokemon
end

-- Is
function isPlayerOnPvpArena(cid)
    return getPlayerPvpArena(cid)
end

function isExhaust(cid)
    return hasCondition(cid, CONDITION_EXHAUST)
end

function isPokemonOnline(cid)
    return isCreature(getPlayerPokemon(cid))
end

function isSurfing(cid)
    return getCreatureStorage(cid, playersStorages.isSurfing) > -1
end

function isRiding(cid)
    return getCreatureStorage(cid, playersStorages.isRiding) > -1
end

function isFlying(cid)
    return getCreatureStorage(cid, playersStorages.isFlying) > -1
end

function isLevitating(cid)
    return getCreatureStorage(cid, playersStorages.isLevitating) > -1
end

function isFishing(cid)
    return getCreatureStorage(cid, playersStorages.isFishing) > -1
end

function isDueling(cid)
    return getPlayerDueling(cid) --getCreatureStorage(cid, playersStorages.canDuel) > -1
end

function isEvolving(cid)
    return getCreatureStorage(cid, playersStorages.isEvolving) > -1
end

function isBiking(cid)
    return getCreatureStorage(cid, playersStorages.isBiking) > -1
end

function isDiving(cid)
    return getCreatureStorage(cid, playersStorages.isDiving) > -1
end

function isUnderwater(cid)
    return getCreatureStorage(cid, playersStorages.isUnderwater) > -1
end

function isPlayerWithBackpackFull(playerUid)
    local playerBackpackUid = getPlayerSlotItem(playerUid, PLAYER_SLOT_BACKPACK).uid
    return getContainerCap(playerBackpackUid) == getContainerSize(playerBackpackUid)
end

function getSafariZone(cid)
    return getCreatureStorage(cid, playersStorages.safariZone) > -1
end

-- Set
function setSafariZone(cid, status)
    doCreatureSetStorage(cid, playersStorages.safariZone, (status and 1 or -1))
end

--[[
function setPlayerPvpArena(cid, status, team, backPosition)
	if (status) then
		doCreatureSetStorage(cid, playersStorages.isOnPvpArena, 1)
	else
		doCreatureSetStorage(cid, playersStorages.isOnPvpArena, -1)
	end
	doCreatureSetStorage(cid, playersStorages.pvpArenaTeam, team)
	doCreatureSetStorage(cid, playersStorages.pvpArenaBackPosition, ";" .. backPosition.x .. ";" .. backPosition.y .. ";" .. backPosition.z)
	doPlayerSetPvpArena(cid, status, team)
end
]]

function setFishingStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isFishing, (status and 1 or -1))
end

function setSurfingStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isSurfing, (status and 1 or -1))
end

function setRidingStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isRiding, (status and 1 or -1))
end

function setFlyingStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isFlying, (status and 1 or -1))
end

function setLevitatingStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isLevitating, (status and 1 or -1))
end

function setDivingStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isDiving, (status and 1 or -1))
end

function setBikingStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isBiking, (status and 1 or -1))
end

function setUnderwaterStatus(cid, status)
    doCreatureSetStorage(cid, playersStorages.isUnderwater, (status and 1 or -1))
end

function setPlayerVulnerable(cid, vulnerable)
    local playerGroupId = getPlayerGroupId(cid)

    if (playerGroupId == 1 and not vulnerable) then -- Player vulnerable coming unvulnerable
        setPlayerGroupId(cid, 7)

    elseif (playerGroupId == 7 and vulnerable) then -- Player unvulnerable coming vulnerable
        setPlayerGroupId(cid, 1)

    elseif (playerGroupId == 2 and not vulnerable) then -- Tutor vulnerable coming unvulnerable
        setPlayerGroupId(cid, 8)

    elseif (playerGroupId == 8 and vulnerable) then -- Tutor unvulnerable coming vulnerable
        setPlayerGroupId(cid, 2)

    elseif (playerGroupId == 3 and not vulnerable) then -- Tutor vulnerable coming unvulnerable
        setPlayerGroupId(cid, 9)

    elseif (playerGroupId == 9 and vulnerable) then -- Tutor unvulnerable coming vulnerable
        setPlayerGroupId(cid, 3)
    end
end

function setPlayerPokemonNickname(cid, newNickname, removing)
    local ball = getPlayerBall(cid)

    setBallPokemonNickname(ball.uid, newNickname, removing)
    doBallUpdateDescription(ball.uid)

    if (isPokemonOnline(cid)) then
        setCreatureNickname(getPlayerPokemon(cid), newNickname)
    end
end

function setPlayerBackPosition(cid, newPos)
    doCreatureSetStorage(cid, playersStorages.tradeBackPosition, string.concat(";", newPos.x, ";",
        newPos.y, ";", newPos.z))
end

-- Can
function canBlink(cid)
    local time = doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.BLINK_COOLDOWN) and 7 or 10
    return getCreatureStorage(cid, playersStorages.blink) == -1 or
            (os.time() - getCreatureStorage(cid, playersStorages.blink)) >= time
end

function canLove(cid)
    return getCreatureStorage(cid, playersStorages.love) == -1 or
            (os.time() - getCreatureStorage(cid, playersStorages.love)) >= 5 * 60
end

-- Do
function doPlayerUseBallOnSlot(cid)
    if (isPlayer(cid)) then
        local item = getPlayerSlotItem(cid, PLAYER_SLOT_BALL)
        if (isItem(item)) then
            doPlayerUseItem(cid, item.uid)
        end
    end
end

function doPlayerRemoveAbilitySpeedCondition(cid)
    return doRemoveCondition(cid, CONDITION_HASTE, CONDITION_SUBID.HASTE.ABILITIES)
end

function doPlayerUpdateOutfit(cid)
    doUpdateAbilityOutfitCondition(cid)
    doPlayerRemoveAbilitySpeedCondition(cid)
    local speedCondition = getAbilitySpeedCondition(cid)
    if (speedCondition) then
        doAddCondition(cid, speedCondition)
    end
end

function doAddExhaust(cid)
    doAddCondition(cid, delayCondition)
end

function doPlayerAddBattleWin(cid)
    doPlayerAddSkill(cid, PLAYER_SKILL_BATTLE_WIN, 1, true)
end

function doPlayerAddBattleLoss(cid)
    doPlayerAddSkill(cid, PLAYER_SKILL_BATTLE_LOSS, 1, true)
end

function doPlayerAddRespect(cid, amount)
    local current = getPlayerSoul(cid)
    if (amount > 0) then
        if (current < PLAYER_RESPECT_MAX) then
            if ((current + amount) < PLAYER_RESPECT_MAX) then
                return doPlayerAddSoul(cid, amount)
            else
                return doPlayerAddSoul(cid, PLAYER_RESPECT_MAX - current)
            end
        end
    else
        return doPlayerAddSoul(cid, amount)
    end
    return false
end

function doPlayerUpdatePokemonLevelPercent(cid, currentExp, currentLevel)
    local TotalExpToNextLevel = getExperienceForLevel(currentLevel + 1)
    local TotalExpToCurrentLevel = getExperienceForLevel(currentLevel)
    local ExpBetweenLevels = TotalExpToNextLevel - TotalExpToCurrentLevel
    local onePercent = math.ceil(ExpBetweenLevels / 100)

    setPlayerMagicLevelPercent(cid, math.ceil((currentExp - TotalExpToCurrentLevel) / onePercent))
end

local function doPlayerSendPokemonSkillWindowData(cid, ballUid, moves, pokemonName, showAllMoves)
    if (ballUid == 0) then
        return -- This occur when a never used ball is put on the slot. getPlayerBall() is called before a ball exists there. Dont worry, this gonna be called again after the fail try. Yes, this is an ungly hack.
    end

    if (not pokemonName) then
        pokemonName = getBallPokemonName(ballUid)
    end

    if (not moves) then
        moves = getPokemonSkills(pokemonName, ballUid)
    end

    if (not showAllMoves) then -- Eg.: When use Transform ability
        local pokemonLevel = getBallPokemonLevel(ballUid)
        local eggMoveSlot = getBallEggMoveSlot(ballUid)
        local tm1Slot = getBallTmSlot(ballUid, 1)
        local tm2Slot = getBallTmSlot(ballUid, 2)
        for k, move in ipairs(moves) do
            if (getPokemonSkillRequiredLevel(pokemonName, move) > pokemonLevel and
                    ((not eggMoveSlot or k > eggMoveSlot) and
                            (not tm1Slot or k > tm1Slot) and
                            (not tm2Slot or k > tm2Slot))) then
                moves[k] = nil
            end
        end
    end

    local icons = {}
    for _, move in pairs(moves) do
        icons[#icons + 1] = getPokemonSkillClientIconId(move)
    end

    doPlayerSendPokemonSkills(cid, getPokemonFastcallPortraitId(pokemonName), icons)
end

local function doSendPlayerPokemonCooldowns(cid, ball, moves)
    for _, move in pairs(moves) do
        local cooldown = getBallSkillCooldown(ball.uid, move)
        if (cooldown > 0) then
            doPlayerSendPokemonSkillCooldown(cid, getPokemonSkillClientIconId(move), cooldown)
        end
    end
end

function doPlayerPokemonAddExperience(player, pokemon, expAmount, multiplier, referenceItem) -- When receive referenceItem(ball), pokemon is ignored
    if (expAmount > 0) then
        if (multiplier == nil) then
            multiplier = true
        end

        local ball = isItem(referenceItem) and referenceItem or getPlayerBall(player)
        if (getBallFromNpc(ball.uid)) then
            return false
        end

        local currentLevel = getBallPokemonLevel(ball.uid)
        local currentExtraPoints = getBallPokemonExtraPoints(ball.uid)

        local pokemonName = getBallPokemonName(ball.uid)
        local maxExtraPoints = isShinyName(pokemonName) and (POKEMON_EXTRA_POINT_MAX - 10) or POKEMON_EXTRA_POINT_MAX

        PokemonHeldItem.onGainExperience(player, pokemon, ball, expAmount)

        if (currentLevel < POKEMON_LEVEL_MAX or currentExtraPoints < maxExtraPoints) then
            if (multiplier) then -- Pokemon Exp Stage
                if (currentLevel <= 10) then
                    expAmount = expAmount * 42
                elseif (currentLevel <= 15) then
                    expAmount = expAmount * 30
                elseif (currentLevel <= 20) then
                    expAmount = expAmount * 16
                elseif (currentLevel <= 25) then
                    expAmount = expAmount * 9
                elseif (currentLevel <= 30) then
                    expAmount = expAmount * 5
                elseif (currentLevel <= 50) then
                    expAmount = expAmount * 3
                elseif (currentLevel <= 70) then
                    expAmount = expAmount * 2
                else
                    expAmount = expAmount * 1.5
                end

                expAmount = expAmount * 1.25
                expAmount = expAmount + math.floor(expAmount * getPlayerExtraExpRate(player))
                -- server-wide EXP event, applied once on top of every other Pokemon modifier
                expAmount = expAmount * getServerExpEventMultiplier()
            end

            local oldExperience = getBallPokemonExp(ball.uid)
            local newExperience = oldExperience + expAmount
            local nextLevelExp = ((50 * (currentLevel) * (currentLevel) * (currentLevel)) - (150 * (currentLevel) * (currentLevel)) + (400 * (currentLevel))) / 3
            local gainLevel = 0

            if (newExperience >= nextLevelExp and currentLevel - getPlayerLevel(player) >= MAX_LEVEL_DIFF_BETWEEN_PLAYER_POKEMON) then
                doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(player, "Your Pokemon is %s levels higher than you and is no longer receiving experience as this difference exists."), MAX_LEVEL_DIFF_BETWEEN_PLAYER_POKEMON))
                return false
            end

            setBallPokemonExp(ball.uid, newExperience)
            doSendAnimatedText(getCreaturePosition(pokemon and pokemon or player), string.concat("+", expAmount, " EXP"), COLOR_GREEN)
            doPlayerSendTextMessage(player, MESSAGE_EVENT_DEFAULT, string.format(__L(player, "Your %s received %s experience point%s."), pokemonName, expAmount, (expAmount > 0 and "s" or "")))

            while (newExperience >= nextLevelExp) do
                gainLevel = gainLevel + 1
                nextLevelExp = ((50 * (currentLevel + gainLevel) * (currentLevel + gainLevel) * (currentLevel + gainLevel)) - (150 * (currentLevel + gainLevel) * (currentLevel + gainLevel)) + (400 * (currentLevel + gainLevel))) / 3
            end

            if (gainLevel > 0) then
                if (currentLevel < POKEMON_LEVEL_MAX) then
                    local pokemonPosition = getCreaturePosition(pokemon and pokemon or player)
                    local maxEnergy = getCreatureMaxMana(player)
                    local energy = getCreatureMana(player)
                    local pokemonNickname = getBallPokemonNickname(ball.uid)
                    local pokemonExtraPoints = getBallPokemonExtraPoints(ball.uid) + gainLevel
                    local newLevel = currentLevel + gainLevel
                    local messageClass = getPlayerUsingOtClient(player) and MESSAGE_EVENT_DEFAULT or MESSAGE_EVENT_ADVANCE

                    if (pokemonNickname ~= nil and pokemonNickname ~= -1) then
                        doBallUpdateDescription(ball.uid, getBallPokemonSex(ball.uid), pokemonName, pokemonNickname, newLevel, pokemonExtraPoints)
                        doPlayerSendTextMessage(player, messageClass,
                            string.format(__L(player, "Congratulations! Your %s advanced from level %s to level %s."), pokemonNickname, currentLevel, newLevel))
                    else
                        doBallUpdateDescription(ball.uid, getBallPokemonSex(ball.uid), pokemonName, nil, newLevel, pokemonExtraPoints)
                        doPlayerSendTextMessage(player, messageClass,
                            string.format(__L(player, "Congratulations! Your %s advanced from level %s to level %s."), pokemonName, currentLevel, newLevel))
                    end

                    if (pokemon) then
                        setMonsterExtraPoints(pokemon, pokemonExtraPoints)
                        setMonsterLevel(pokemon, newLevel)
                        doCreatureAddHealth(pokemon, (getCreatureMaxHealth(pokemon) - getCreatureHealth(pokemon)))
                        setCreatureMaxMana(player, maxEnergy + POKEMON_GAIN_ENERGY * gainLevel)
                        doCreatureAddMana(player, (maxEnergy - energy) + POKEMON_GAIN_ENERGY * gainLevel)
                        setPlayerMagicLevel(player, newLevel)
                    else
                        doBallHeal(player, ball)
                    end

                    doSendMagicEffect(pokemonPosition, EFFECT_GREEN_BUFF)
                    doSendMagicEffect(pokemonPosition, EFFECT_LEVEL_UP)

                    setBallPokemonLevel(ball.uid, newLevel)
                    setBallPokemonMaxEnergy(ball.uid, maxEnergy + POKEMON_GAIN_ENERGY * gainLevel)
                    setBallPokemonExtraPoints(ball.uid, pokemonExtraPoints)

                    doDatalogPokemonLevelUp(player, getPokemonNumberByName(pokemonName), currentLevel,
                        newLevel, os.time(), pokemonPosition)

                    local moves = getPokemonSkills(pokemonName, ball.uid)
                    local sendCooldowns = nil
                    local newMoves = {}
                    for _, move in pairs(moves) do
                        if (getPokemonSkillRequiredLevel(pokemonName, move) <= newLevel and
                                getPokemonSkillRequiredLevel(pokemonName, move) > currentLevel) then
                            doPlayerSendTextMessage(player, messageClass, string.format(__L(player, "Your %s learned a new move: %s."), pokemonName, move))
                            if (pokemon) then
                                doPlayerSendPokemonSkillWindowData(player, ball.uid) -- Show the new move
                                sendCooldowns = true
                            end
                            newMoves[#newMoves + 1] = getPokemonSkillClientIconId(move)
                        end
                    end

                    if (sendCooldowns) then
                        doSendPlayerPokemonCooldowns(player, ball, moves)
                    end

                    for _, evolution in ipairs(getPokemonEvolutions(pokemonName)) do
                        if (evolution.requiredLevel <= newLevel and evolution.requiredLevel > currentLevel) then
                            doPlayerSendTextMessage(player, messageClass, string.format(__L(player, "Your %s reached the required level to evolve! Check your Pokedex."), pokemonName))
                            break
                        end
                    end

                    currentLevel = currentLevel + gainLevel
                    doPlayerSendPokemonLevelUp(player, getPokemonNumberByName(pokemonName), currentLevel, newMoves)

                else -- We are at Extra Point up mode
                    local pokemonPosition = getCreaturePosition(pokemon and pokemon or player)
                    local maxEnergy = getCreatureMaxMana(player)
                    local energy = getCreatureMana(player)
                    local pokemonNickname = getBallPokemonNickname(ball.uid)
                    local pokemonExtraPoints = getBallPokemonExtraPoints(ball.uid) + gainLevel

                    if (pokemonNickname ~= nil and pokemonNickname ~= -1) then
                        doBallUpdateDescription(ball.uid, getBallPokemonSex(ball.uid), pokemonName,
                            pokemonNickname, currentLevel, pokemonExtraPoints)
                        doPlayerSendTextMessage(player, MESSAGE_EVENT_ADVANCE,
                            string.format(__L(player, "Congratulations! Your %s upgraded his extra points from level %s to level %s."), pokemonNickname, pokemonExtraPoints - gainLevel, pokemonExtraPoints))
                    else
                        doBallUpdateDescription(ball.uid, getBallPokemonSex(ball.uid), pokemonName, nil,
                            currentLevel, pokemonExtraPoints)
                        doPlayerSendTextMessage(player, MESSAGE_EVENT_ADVANCE,
                            string.format(__L(player, "Congratulations! Your %s upgraded his extra points from level %s to level %s."), pokemonName, pokemonExtraPoints - gainLevel, pokemonExtraPoints))
                    end

                    if (pokemon) then
                        setMonsterExtraPoints(pokemon, pokemonExtraPoints)
                        setMonsterLevel(pokemon, currentLevel)
                        doCreatureAddHealth(pokemon, (getCreatureMaxHealth(pokemon) - getCreatureHealth(pokemon)))
                        setCreatureMaxMana(player, maxEnergy + POKEMON_GAIN_ENERGY * gainLevel)
                        doCreatureAddMana(player, (maxEnergy - energy) + POKEMON_GAIN_ENERGY * gainLevel)
                        setPlayerMagicLevel(player, currentLevel)
                    end

                    doSendMagicEffect(pokemonPosition, EFFECT_GREEN_BUFF)
                    doSendMagicEffect(pokemonPosition, EFFECT_LEVEL_UP)

                    if (not isBallPokemonFromEgg(ball.uid)) then
                        setBallIsNotPokemonFromEgg(ball.uid, true)
                    end

                    setBallPokemonExp(ball.uid, getExperienceForLevel(currentLevel))
                    setBallPokemonExtraPoints(ball.uid, pokemonExtraPoints)
                end

                doPlayerAchievementCheck(player, ACHIEVEMENT_IDS.POKEMON_LEVEL_100, currentLevel)
            end

            if (pokemon) then
                doPlayerUpdatePokemonLevelPercent(player, newExperience, currentLevel)
            end
        end
    end
    return true
end

function doPlayerUpdatePokemonMoves(cid, ballUid, moves, pokemonName, showAllMoves)
    doPlayerSendPokemonSkillWindowData(cid, ballUid, moves, pokemonName, showAllMoves)
    doPlayerSendPokemonSkillContainerOpen(cid)
end

function doPlayerUpdatePokemonIcons(cid, pokemonName, showAllMoves)
    if (isItem(getPlayerSlotItem(cid, PLAYER_SLOT_PORTRAIT))) then
        doRemoveItem(getPlayerSlotItem(cid, PLAYER_SLOT_PORTRAIT).uid)
    end

    local portraitContainer, ball = doPlayerAddItem(cid, getPokemonPortraitId(pokemonName)), getPlayerBall(cid)
    local pokemonSkills = (isItem(ball) and getPokemonSkills(pokemonName, ball.uid) or getPokemonDefaultSkills(pokemonName))

    doPlayerUpdatePokemonMoves(cid, ball.uid, pokemonSkills, pokemonName, showAllMoves)

    if (isItem(ball)) then -- Sometimes this is called but the ball doesn't exist
        doSendPlayerPokemonCooldowns(cid, ball, pokemonSkills)
    end
end

function setPlayerIcons(cid, ball, status)
    if (status) then
        local pokemonLevel = getBallPokemonLevel(ball.uid)

        setPlayerMagicLevel(cid, pokemonLevel)
        doPlayerUpdatePokemonLevelPercent(cid, getBallPokemonExp(ball.uid), pokemonLevel)

        --doTransformItem(getPlayerSlotItem(cid, PLAYER_SLOT_EVOLVE).uid, EVOLVE_ICON_ID)
        doTransformItem(getPlayerSlotItem(cid, PLAYER_SLOT_ORDER).uid, ORDER_ICON_ID)
        doPlayerUpdatePokemonIcons(cid, getBallPokemonName(ball.uid))

        if (not isDueling(cid)) then
            --doTransformItem(getPlayerSlotItem(cid, PLAYER_SLOT_DUEL).uid, DUEL_ICON_ID)
        end

    else
        setPlayerMagicLevel(cid, 0)
        setPlayerMagicLevelPercent(cid, 0)
        doRemoveItem(getPlayerSlotItem(cid, PLAYER_SLOT_PORTRAIT).uid)
        --doTransformItem(getPlayerSlotItem(cid, PLAYER_SLOT_EVOLVE).uid, EVOLVE_ICON_OFF_ID)
        doTransformItem(getPlayerSlotItem(cid, PLAYER_SLOT_ORDER).uid, ORDER_ICON_OFF_ID)
        --doTransformItem(getPlayerSlotItem(cid, PLAYER_SLOT_DUEL).uid, DUEL_ICON_OFF_ID)
        --New
        doPlayerSendPokemonSkillContainerClose(cid)
    end
end

local BIKE_SPEED_CONDITION = createConditionObject(CONDITION_HASTE, -1, -1, CONDITION_SUBID.HASTE.BIKE)
setConditionParam(BIKE_SPEED_CONDITION, CONDITION_PARAM_SPEED, 120)

function doPlayerRideBike(cid, item)
    doTransformItem(item.uid, LOCKED_MACH_BIKE_ID)
    doAddCondition(cid, BIKE_SPEED_CONDITION)
    setBikingStatus(cid, true)

    local outfit = getCreatureOutfit(cid)
    if (getPlayerSex(cid) == PLAYERSEX_FEMALE) then
        outfit.lookType = 1743
        doSetCreatureOutfit(cid, outfit, -1, CONDITION_SUBID.OUTFITS.BIKE)
    else
        outfit.lookType = 1744
        doSetCreatureOutfit(cid, outfit, -1, CONDITION_SUBID.OUTFITS.BIKE)
    end
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
end

function doPlayerDeRideBike(cid, item)
    doRemoveCondition(cid, CONDITION_HASTE, CONDITION_SUBID.HASTE.BIKE)
    setBikingStatus(cid, false)
    doTransformItem(item.uid, UNLOCKED_MACH_BIKE_ID)
    doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.BIKE)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
end

--[[ Is not used anymore
-- function doPlayerResetSpeed(cid)
	for i = 0, 15 do -- try to remove all haste conditions
		if (hasCondition(cid, CONDITION_HASTE)) then
			doRemoveCondition(cid, CONDITION_HASTE)
		else
			break
		end
	end

	for i = 0, 15 do -- try to remove all paralyze conditions
		if (hasCondition(cid, CONDITION_PARALYZE)) then
			doRemoveCondition(cid, CONDITION_PARALYZE)
		else
			break
		end
	end

	doChangeSpeed(cid, -(getCreatureSpeed(cid) - getCreatureBaseSpeed(cid)))
end]]

-- Others
function getPlayerLastOpponent(cid)
    return getCreatureStorage(cid, playersStorages.lastOpponent)
end

function setPlayerLastOpponent(cid, _lastOpponent)
    doCreatureSetStorage(cid, playersStorages.lastOpponent, _lastOpponent)
end

function getPlayerLastMaxPokemon(cid)
    return getCreatureStorage(cid, playersStorages.lastMaxPokemon)
end

function setPlayerLastMaxPokemon(cid, _lastMaxPokemon)
    doCreatureSetStorage(cid, playersStorages.lastMaxPokemon, _lastMaxPokemon)
end

function getPlayerLastMaxMembers(cid)
    return getCreatureStorage(cid, playersStorages.lastMaxMembers)
end

function setPlayerLastMaxMembers(cid, _lastMaxMembers)
    doCreatureSetStorage(cid, playersStorages.lastMaxMembers, _lastMaxMembers)
end

-- Main items related
function doPlayerAddMainItems(cid)
    setItemUniqueOwner(doPlayerAddItem(cid, 12157, 100, false), cid) -- 100x Empty poke ball
    setItemUniqueOwner(doPlayerAddItem(cid, 2687, 100, false), cid) -- 100x Cookie
    setItemUniqueOwner(doPlayerAddItem(cid, 12244, 20, false), cid) -- 20x Pokemon health potion
    setItemUniqueOwner(doPlayerAddItem(cid, 2120, 1, false), cid) -- 1x Rope
    setItemUniqueOwner(doPlayerAddItem(cid, 12292, 1, false), cid) -- 1x Old Fishing Rood
end

function getPlayerFirstPokemon(cid)
    local dbResult = db.getResult("SELECT `firstpokemon`  FROM `players` WHERE `id` = '" .. getPlayerGUID(cid) .. " LIMIT 1';")
    local firstPokemonId = dbResult:getDataInt('firstpokemon')
    if (firstPokemonId == 0) then
        return "Bulbasaur"
    elseif (firstPokemonId == 1) then
        return "Charmander"
    elseif (firstPokemonId == 2) then
        return "Squirtle"
    elseif (firstPokemonId == 3) then
        return "Chikorita"
    elseif (firstPokemonId == 4) then
        return "Cyndaquil"
    elseif (firstPokemonId == 5) then
        return "Totodile"
    end
    return "Bulbasaur"
end

--function getPlayerFirstPokemonSex(cid)
--	local dbResult = db.getResult("SELECT `pokemon_sex`  FROM `player_first_pokemon` WHERE `id` = '".. getPlayerGUID(cid) .." LIMIT 1';")
--  if (dbResult == -1) then
--    return table.random({POKEMON_SEX_FEMALE, POKEMON_SEX_MALE})
--  end
--	local pokemonSex = dbResult:getDataInt('pokemon_sex')
--  if (not pokemonSex or (pokemonSex ~= POKEMON_SEX_FEMALE and pokemonSex ~= POKEMON_SEX_MALE)) then
--    return table.random({POKEMON_SEX_FEMALE, POKEMON_SEX_MALE})
--  end
--  return pokemonSex
--end

function getPlayerPokemonCaughts(cid, pokemonName)
    local r = getCreatureStorage(cid, getPokemonCatchStorage(pokemonName))
    return r > -1 and r or 0
end

function setPlayerPokemonCaughts(cid, pokemonName, caughts)
    doCreatureSetStorage(cid, getPokemonCatchStorage(pokemonName), caughts)

    if (caughts == 1) then -- First
        setPlayerIndividualCaughts(cid, getPlayerIndividualCaughts(cid) + 1)
    end
end

function getPlayerCaughts(cid)
    local r = tonumber(getCreatureStorage(cid, playersStorages.caughts))
    return r > -1 and r or 0
end

function setPlayerCaughts(cid, caughts)
    doCreatureSetStorage(cid, playersStorages.caughts, caughts)
end

function setPlayerIndividualCaughts(cid, v)
    doCreatureSetStorage(cid, playersStorages.individualCaughts, v)
end

function getPlayerIndividualCaughts(cid)
    local r = getCreatureStorage(cid, playersStorages.individualCaughts)
    if (r == EMPTY_STORAGE) then
        r = 0
        if (getPlayerCaughts(cid) > 0) then -- Otherwise this is a new player
            for i = 1, POKEMON_NUMBER do
                if (getPlayerPokemonCaughts(cid, getPokemonNameByNumber(i)) > 0) then
                    r = r + 1
                end
            end
        end

        setPlayerIndividualCaughts(cid, r)
    end

    return r
end

function getPlayerExtraExpRateTime(cid)
    local r = getCreatureStorage(cid, playersStorages.extraExpRateTime)
    return r > -1 and r or 0
end

function setPlayerExtraExpRateTime(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraExpRateTime, value)
end

function getPlayerExtraExpRateValue(cid)
    local r = tonumber(getCreatureStorage(cid, playersStorages.extraExpRateValue))
    return r > -1 and r or 0
end

function setPlayerExtraExpRateValue(cid, value)
    doCreatureSetStorage(cid, playersStorages.extraExpRateValue, value)
end

function getPlayerMasteryDungeon(cid)
    return getCreatureStorage(cid, playersStorages.masteryDungeon)
end

function setPlayerMasteryDungeon(cid, masteryDungeon)
    doCreatureSetStorage(cid, playersStorages.masteryDungeon, masteryDungeon)
end

function getPlayerLastDungeonDate(cid)
    return getCreatureStorage(cid, playersStorages.lastDungeonDate)
end

function setPlayerLastDungeonDate(cid, value)
    doCreatureSetStorage(cid, playersStorages.lastDungeonDate, value)
end

function getPlayerLastSafariZoneDate(cid)
    return getCreatureStorage(cid, playersStorages.lastSafariZoneDate)
end

function setPlayerLastSafariZoneDate(cid, value)
    doCreatureSetStorage(cid, playersStorages.lastSafariZoneDate, value)
end

function getPlayerSafariZonePass(cid)
    local r = getCreatureStorage(cid, playersStorages.safariZonePass)
    return r > -1 and r or 0
end

function setPlayerSafariZonePass(cid, value)
    doCreatureSetStorage(cid, playersStorages.safariZonePass, value)
end

--
function getPlayerLastUsedTm(cid)
    return getPlayerItemByAttribute(cid, true, ITEM_ATTRIBUTES.LAST_USED_TM_MARK,
        getCreatureStorage(cid, playersStorages.lastUsedTmMark))
end

function setPlayerLastUsedTm(cid, itemUid)
    local v = getCurrentTimeInSeconds()
    doItemSetAttribute(itemUid, ITEM_ATTRIBUTES.LAST_USED_TM_MARK, v)
    doCreatureSetStorage(cid, playersStorages.lastUsedTmMark, v)
end

function getPlayerLastUsedTmBall(cid)
    return getPlayerItemByAttribute(cid, true, ITEM_ATTRIBUTES.LAST_USED_TM_BALL_MARK,
        getCreatureStorage(cid, playersStorages.lastUsedTmBallMark))
end

function setPlayerLastUsedTmBall(cid, itemUid)
    local v = getCurrentTimeInSeconds()
    doItemSetAttribute(itemUid, ITEM_ATTRIBUTES.LAST_USED_TM_BALL_MARK, v)
    doCreatureSetStorage(cid, playersStorages.lastUsedTmBallMark, v)
end

function isPlayerAutoWalking(cid)
    return getCreatureStorage(cid, playersStorages.isAutoWalking) > 0
end

function setPlayerAutoWalking(cid, value)
    doCreatureSetStorage(cid, playersStorages.isAutoWalking, value and 1 or 0)
end

function getPlayerFrontierIsland(cid)
    return getCreatureStorage(cid, playersStorages.frontierIsland) > 0
end

function setPlayerFrontierIsland(cid, value)
    doCreatureSetStorage(cid, playersStorages.frontierIsland, value and 1 or 0)
end

function getPlayerLastBattleTowerTwenty(cid)
    return getCreatureStorage(cid, playersStorages.lastBattleTowerTwenty)
end

function setPlayerLastBattleTowerTwenty(cid, value)
    doCreatureSetStorage(cid, playersStorages.lastBattleTowerTwenty, value)
end

function getPlayerLastBattleTowerFifteen(cid)
    return getCreatureStorage(cid, playersStorages.lastBattleTowerFifteen)
end

function setPlayerLastBattleTowerFifteen(cid, value)
    doCreatureSetStorage(cid, playersStorages.lastBattleTowerFifteen, value)
end

function getPlayerLastBattleTowerTen(cid)
    return getCreatureStorage(cid, playersStorages.lastBattleTowerTen)
end

function setPlayerLastBattleTowerTen(cid, value)
    doCreatureSetStorage(cid, playersStorages.lastBattleTowerTen, value)
end

function getPlayerOrangeArchipelagoAccess(cid)
    local v = getCreatureStorage(cid, playersStorages.orangeArchipelagoAccess)
    return v > 0 and v or 1
end

local ORANGE_ARCHIPELAGO_ISLANDS_PER_ACCESS = {
    [2] = "Valencia, Pinkan and Pummelo",
    [3] = "Tarroco, Hamlin and Kumquat",
    [4] = "Mandarin North, Butwal and Navel",
    [5] = "Ascorbia, The Seven Grapefruit and Moro",
    [6] = "Shamouti, Murcott and Mandarin South"
}

function setPlayerOrangeArchipelagoAccess(cid, value)
    local old = getPlayerOrangeArchipelagoAccess(cid)
    doCreatureSetStorage(cid, playersStorages.orangeArchipelagoAccess, value)

    if (value > old) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE,
            string.format(__L(cid, "Your Orange Archipelago access has increased! Your new unlocked islands: %s."), __L(cid, ORANGE_ARCHIPELAGO_ISLANDS_PER_ACCESS[value])))
    end
end

function getPlayerBoughtRareCandy(cid)
    local v = getAccountStorage(getPlayerAccountId(cid), ACCOUNT_STORAGES.BOUGHT_RARE_CANDY) --getCreatureStorage(cid, playersStorages.boughtRareCandy)
    return v > -1 and v or 0
end

function setPlayerBoughtRareCandy(cid, value)
    --doCreatureSetStorage(cid, playersStorages.boughtRareCandy, value)
    setAccountStorage(getPlayerAccountId(cid), ACCOUNT_STORAGES.BOUGHT_RARE_CANDY, value)
end

function getPlayerLastDexedTmItemId(cid)
    local v = getCreatureStorage(cid, playersStorages.lastDexedTmItemId)
    return v > -1 and v or 0
end

function setPlayerLastDexedTmItemId(cid, value)
    doCreatureSetStorage(cid, playersStorages.lastDexedTmItemId, value)
end

--
--[[
function doPlayerOxygenMaskLock(cid)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    if (isItem(item) and item.itemid == UNLOCKED_OXYGEN_MASK_ID) then
        doTransformItem(item.uid, LOCKED_OXYGEN_MASK_ID)
        return true
    end
    return false
end

function doPlayerOxygenMaskUnlock(cid)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
    if (isItem(item) and item.itemid == LOCKED_OXYGEN_MASK_ID) then
        doTransformItem(item.uid, UNLOCKED_OXYGEN_MASK_ID)
        return true
    end
    return false
end
]]

function doPlayerRemoveFrontierBalls(cid)
    for _, item in pairs(getPlayerAllBallsWithPokemon(cid)) do
        if (ballsNames[item.itemid] == "frontier") then
            doRemoveItem(item.uid)
        end
    end
end

function doPlayerRemoveEpicBalls(cid)
    for _, item in pairs(getPlayerAllBallsWithPokemon(cid)) do
        if (ballsNames[item.itemid] == "epic") then
            doRemoveItem(item.uid)
        end
    end
end

function doPlayerReset(cid) -- Called by onLogin and onDeath
    setPlayerVulnerable(cid, true)
    setFishingStatus(cid, false)
    doCreatureSetStorage(cid, playersStorages.isEvolving, -1)
    setCreatureMaxMana(cid, 0)
    doPlayerAddMana(cid, -getPlayerMana(cid), false)

    setPokemonBadPoison(cid, false)
    setPokemonPoison(cid, false)
    setPokemonBurn(cid, false)

    doPlayerRemoveSafariZoneItems(cid)
    setSafariZone(cid, false)

    setIsPokemonUsingHealthPotion(cid, false)
    setPlayerAutoWalking(cid, false)
    setPlayerFrontierIsland(cid, false)
    setPlayerTraveling(cid, false)

    if (isBiking(cid)) then
        doPlayerDeRideBike(cid, getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM))
    end
end

function doPlayerSendWindowsData(cid, sendMoves)
    doPlayerSendPokemonWindowClose(cid) -- reset window icons
    local balls = getPlayerAllBallsWithPokemon(cid)
    for _, ball in ipairs(balls) do
        doFastcallLink(cid, ball.uid)
    end

    if (sendMoves) then -- We didn't need to send it if this is called by onLogin, cuz this will be send when onEquip gets called
        local ball = getPlayerBall(cid)
        if (isItem(ball)) then
            doPlayerSendPokemonSkillWindowData(cid, ball.uid)
        end
    end

    doPokedexStatusSend(cid)

    if (#balls > 0) then
        doPlayerSendPokemonSkillContainerOpen(cid)
        doPlayerSendPokemonWindowOpen(cid)
    end
end

function getPlayerKeyItem(cid)
    return getPlayerSlotItem(cid, PLAYER_SLOT_KEY_ITEM)
end

function getPlayerMounted(cid)
    return isSurfing(cid) or isFlying(cid) or isRiding(cid) or isDiving(cid) or isLevitating(cid)
end

function getPlayerBlockLogout(cid)
    return getCreatureStorage(cid, playersStorages.blockLogout) > 0
end

function setPlayerBlockLogout(cid, value) -- This will prevent the player logout. If the player forces exit, he will be teleported to Trade Room and this will be setted to false. This will be setted to false also if the player dies or use ability teleport.
    doCreatureSetStorage(cid, playersStorages.blockLogout, (value and 1 or 0))
end

function getPlayerGotStarterPokemon(cid)
    return getCreatureStorage(cid, playersStorages.gotStarterPokemon) > 0
end

function setPlayerGotStarterPokemon(cid, value)
    doCreatureSetStorage(cid, playersStorages.gotStarterPokemon, (value and 1 or 0))
end

function onPlayerWinDuel(cid)
    if (getPlayerTournamentReady(cid)) then
        doPlayerResetBerryCooldown(cid)
    end
end

function onPlayerEndDuel(cid) -- Called when win/lose, its duels and battles too
    doRemoveCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.POKEMONCALL)
end

function getPlayerTraveling(cid)
    return getCreatureStorage(cid, playersStorages.traveling) > -1
end

function setPlayerTraveling(cid, value)
    doCreatureSetStorage(cid, playersStorages.traveling, (value and 1 or -1))
end

function getPlayerTotalCasedDolls(cid)
    local r = getCreatureStorage(cid, playersStorages.casedDolls)
    return r > -1 and r or 0
end

function setPlayerTotalCasedDolls(cid, value)
    doCreatureSetStorage(cid, playersStorages.casedDolls, value)
end

function getPlayerLastUsedIncubator(cid)
    return getPlayerItemByAttribute(cid, true, ITEM_ATTRIBUTES.LAST_USED_INCUBATOR_MARK,
        getCreatureStorage(cid, playersStorages.lastUsedIncubatorMark))
end

function setPlayerLastUsedIncubator(cid, itemUid)
    local v = getCurrentTimeInSeconds()
    doItemSetAttribute(itemUid, ITEM_ATTRIBUTES.LAST_USED_INCUBATOR_MARK, v)
    doCreatureSetStorage(cid, playersStorages.lastUsedIncubatorMark, v)
end

function getPlayerAutoLootSave(cid)
    local r = getCreatureStorage(cid, playersStorages.autoLootSave)
    return r == 1
end

function setPlayerAutoLootSave(cid, value)
    doCreatureSetStorage(cid, playersStorages.autoLootSave, value and 1 or 0)
end

function getPlayerDeliveredEasterEggs(cid)
    local r = getCreatureStorage(cid, playersStorages.deliveredEasterEggs)
    return r ~= EMPTY_STORAGE and r or 0
end

function setPlayerDeliveredEasterEggs(cid, value)
    doCreatureSetStorage(cid, playersStorages.deliveredEasterEggs, value)
end

function getPlayerColosseumArenaPaid(cid)
    local r = getCreatureStorage(cid, playersStorages.colosseumnArenaPaid)
    return r ~= EMPTY_STORAGE and r or false
end

function setPlayerColosseumArenaPaid(cid, value)
    doCreatureSetStorage(cid, playersStorages.colosseumnArenaPaid, value)
end

function getPlayerLastEliteFourTry(cid)
    local r = getCreatureStorage(cid, playersStorages.lastEliteFourTry)
    return r ~= EMPTY_STORAGE and r or -1
end

function setPlayerLastEliteFourTry(cid, value)
    doCreatureSetStorage(cid, playersStorages.lastEliteFourTry, value)
end

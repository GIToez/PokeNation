if (RocketBattle == nil) then
    local CUSTOM_ON_END = {
        ["Suramoon"] = function(cid)
            local pos = getCreaturePosition(cid)
            doSendMagicEffect(pos, EFFECT_BLUE_BUFF)
            doDecayItem(doCreateItem(25186, 1, pos))
        end
    }

    local NPC_BATTLE_TIMEOUT = 60 -- one minute
    local NPC_TIME_BETWEEN_BATTLES = 23 * 60 * 60 -- 24 hours
    local NPC_TIME_BETWEEN_BATTLES_FOREVER = -2
    local NPC_DIFFICULTY_DYNAMIC = 0 -- Depends on player level
    local NPC_POKEMON_EXPERIENCE_RATE = 2.0

    --local NPC_LEVEL_STORAGE_BASE = 9500 -- Just to remind
    local NPC_LEVEL_MAX = 100
    local NPC_GROW_PER_LEVEL = 3 -- How much the NPC Pokemon will grow with each NPC level

    local STORAGE_BASE = 9000
    local NPC_STORAGES = {
        CURRENT_BATTLE_STATUS = STORAGE_BASE + 1,
        OPPONENT = STORAGE_BASE + 2,
        POKEMON1_STATUS = STORAGE_BASE + 3,
        POKEMON2_STATUS = STORAGE_BASE + 4,
        POKEMON3_STATUS = STORAGE_BASE + 5,
        POKEMON4_STATUS = STORAGE_BASE + 6,
        POKEMON5_STATUS = STORAGE_BASE + 7,
        POKEMON6_STATUS = STORAGE_BASE + 8,
        BATTLE_TIMEOUT = STORAGE_BASE + 9,
        POKEMON1 = STORAGE_BASE + 10,
        POKEMON2 = STORAGE_BASE + 11,
        POKEMON3 = STORAGE_BASE + 12,
        POKEMON4 = STORAGE_BASE + 13,
        POKEMON5 = STORAGE_BASE + 14,
        POKEMON6 = STORAGE_BASE + 15,
        DIFFICULTY = STORAGE_BASE + 16
    }

    local POKEMONNUMBER_TO_VAR = {
        [1] = NPC_STORAGES.POKEMON1_STATUS,
        [2] = NPC_STORAGES.POKEMON2_STATUS,
        [3] = NPC_STORAGES.POKEMON3_STATUS,
        [4] = NPC_STORAGES.POKEMON4_STATUS,
        [5] = NPC_STORAGES.POKEMON5_STATUS,
        [6] = NPC_STORAGES.POKEMON6_STATUS
    }

    local NPC_BATTLE_STATUS = {
        ISNT_BATTLEING = -1,
        IS_BATTLEING = 0
    }

    local NPC_POKEMON_STATUS = {
        CANNOT_USE = -1,
        CAN_USE = 0
    }

    local NPC_DIALOGS = {
        POKEMON_DOWN = {
            "Grr...",
            "I guess I underestimated you...",
            "So you aren't so weak.",
            "Let's see if you can beat this"
        },
        BATTLE_START = {
            "Alright, prepare yourself!",
            "Yep! Let's battle!",
            "Let's see if you can do."
        },
        PLAYER_WITHOUT_POKEMON = {
            "Where is your Pokemon?",
            "Where is your Pokemon? Afraid?",
            "First call your Pokemon!"
        },
        NPC_LOSS = {
            "Grr...",
            "You're very lucky...",
            "Congratulations!"
        },
        NPC_WIN = {
            "Haha! Where is the Pokemon trainer?",
            "Yes! I'm the best! No chance for you.",
            "More luck next time."
        }
    }
    --[[ // ]]
    local NpcsByName = {}
    RocketBattle = {
        name = "",
        uid = 0,
        pokemons = {},
        currentPokemons = {},
        rewardBaseExp = 0,
        rewardItems = {},
        rewardUniqueItems = {},
        rewardRespect = 0,
        rewardBadge = nil,
        lastBattleTimeStorage = 0,
        requiredRespect = 0,
        oneWin = false,
        difficulty = 10,
        required = nil,
        onWin = nil,
        cooldowns = {},
        levelStorage = 0,
        baseBet = 0,
        currentBet = 0,
        npcHandler = nil,
        requiredLevel = 0,
        changes = {}, -- new pokemon that the NPC will carry when the player win x times structure = changes{{level = 1, pokemon = "Pikachu"}, {level = 2, pokemon = Charmander}, ...}
        payRespect = 0,
        evolve = true,
        lastDefeatTimeStorage = nil,
        lastOrder = 0,
        pokemonMaxLevel = NPC_LEVEL_MAX,
        specialMove = nil, -- A move that all Pokemon from this NPC will use
        pokemonDefeatExperienced = false,
        onEnd = nil,
        requiredMessage = nil,
        pokemonMovesets = nil,
        currentPokemonId = -1,
        pokemonTeamEvolvable = true,
        extraStats = nil
    }

    -- local REGISTERED_STORAGES = {}

    function RocketBattle:new(name, lastBattleTimeStorage, levelStorage, npcHandler, lastDefeatTimeStorage)
        if (not npcHandler) then
            log(LOG_TYPES.ERROR, "RocketBattle:new missing npcHandler", name, lastBattleTimeStorage, levelStorage)
            return
        end

        if (not levelStorage) then
            log(LOG_TYPES.ERROR, "RocketBattle:new missing levelStorage", name, lastBattleTimeStorage)
            return
        end

        if (not lastBattleTimeStorage) then
            log(LOG_TYPES.ERROR, "RocketBattle:new missing lastBattleTimeStorage", name)
            return
        end

        if (not name or type(name) ~= "string") then
            log(LOG_TYPES.ERROR, "RocketBattle:new missing name")
            return
        end

        --[[if (table.find(REGISTERED_STORAGES, lastBattleTimeStorage)) then  This is buggy, cuz if we put more then one NPC at the map (same NPC) the warning will show up
            log(LOG_TYPES.ERROR, "RocketBattle:new duplicated last battle time storage", name, lastBattleTimeStorage)
        else
            REGISTERED_STORAGES[#REGISTERED_STORAGES + 1] = lastBattleTimeStorage
        end

        if (table.find(REGISTERED_STORAGES, levelStorage)) then
            log(LOG_TYPES.ERROR, "RocketBattle:new duplicated level storage", name, levelStorage)
        else
            REGISTERED_STORAGES[#REGISTERED_STORAGES + 1] = levelStorage
        end]]

        local obj = {}
        obj.name = name
        obj.lastBattleTimeStorage = lastBattleTimeStorage
        obj.levelStorage = levelStorage
        obj.npcHandler = npcHandler
        obj.lastDefeatTimeStorage = lastDefeatTimeStorage

        setmetatable(obj, self)
        self.__index = self

        NpcsByName[name] = obj
        if (getCreatureIcon(getNpcId()) == CREATURE_ICONS.NONE) then
            setCreatureIcon(getNpcId(), CREATURE_ICONS.BATTLE)
        end

        return obj
    end

    function RocketBattle:setPokemonMovesets(movesets)
        self.pokemonMovesets = movesets
    end

    function RocketBattle:setPokemons(pokemons)
        self.pokemons = pokemons
    end

    function RocketBattle:setRewardBaseExp(rewardBaseExp)
        self.rewardBaseExp = rewardBaseExp
    end

    function RocketBattle:setRewardItems(rewardItems)
        self.rewardItems = rewardItems
    end

    function RocketBattle:setRewardUniqueItems(rewardUniqueItems)
        self.rewardUniqueItems = rewardUniqueItems
    end

    function RocketBattle:setRewardRespect(rewardRespect)
        self.rewardRespect = rewardRespect
    end

    function RocketBattle:setRewardBadge(rewardBadge)
        self.rewardBadge = rewardBadge
    end

    function RocketBattle:setRequiredRespect(requiredRespect)
        self.requiredRespect = requiredRespect
    end

    function RocketBattle:setOneWin(oneWin)
        self.oneWin = oneWin
    end

    function RocketBattle:setDifficulty(difficulty)
        self.difficulty = difficulty
    end

    function RocketBattle:setRequired(required)
        self.required = required
    end

    function RocketBattle:setRequiredMessage(msg)
        self.requiredMessage = msg
    end

    function RocketBattle:setOnWin(onWin)
        self.onWin = onWin
    end

    function RocketBattle:setOnEnd(v)
        self.onEnd = v
    end

    function RocketBattle:setBaseBet(baseBet)
        self.baseBet = baseBet
    end

    function RocketBattle:setRequiredLevel(requiredLevel)
        self.requiredLevel = requiredLevel
    end

    function RocketBattle:addChange(level, pokemon)
        table.insert(self.changes, {level = level, pokemon = pokemon})
    end

    function RocketBattle:setPayRespect(payRespect)
        self.payRespect = payRespect
    end

    function RocketBattle:setEvolve(evolve)
        self.evolve = evolve
    end

    function RocketBattle:setPokemonMaxLevel(v)
        self.pokemonMaxLevel = v
    end

    function RocketBattle:setSpecialMove(v)
        self.specialMove = v
    end

    function RocketBattle:setPokemonDefeatExperienced(v)
        self.pokemonDefeatExperienced = v
    end

    function RocketBattle:setRequiredStorage(v)
        self.requiredStorage = v
    end

    function RocketBattle:setPokemonTeamEvolvable(v)
        self.pokemonTeamEvolvable = v
    end

    function RocketBattle:setPokemonExtraStats(v)
        self.extraStats = v
    end

    --[[ // ]]
    -- IS
    function RocketBattle:isBattleing()
        return getCreatureStorage(self.uid, NPC_STORAGES.CURRENT_BATTLE_STATUS) == NPC_BATTLE_STATUS.IS_BATTLEING
    end

    function RocketBattle.isPokemonOnline(cid)
        return #getCreatureSummons(cid) > 0
    end

    -- GET
    function RocketBattle:getPokemons()
        return self.pokemons
    end

    function RocketBattle.getPokemon(cid)
        return getCreatureSummons(cid)[1]
    end

    function RocketBattle:getBattleTimeoutRemaing()
        return getCreatureStorage(self.uid, NPC_STORAGES.BATTLE_TIMEOUT)
    end

    function RocketBattle:getRequiredRespect()
        return self.requiredRespect
    end

    function RocketBattle.getMoveCooldown(cid, move)
        return (getCreatureStorage(cid, getPokemonSkillCooldownStorage(move)) or 0) - getCurrentTimeInSeconds()
    end

    function RocketBattle.getPokemonMove(cid, pokemonUid, targetUid)
        local moves = getPokemonDefaultSkills(getPokemonReferenceName(pokemonUid))

        -- First try a random move, if cant use it, try from the strongest to down
        local move = table.random(moves)
        if (not RocketBattle.canPokemonUseMove(cid, move, pokemonUid, targetUid)) then
            move = nil
            for i = #moves, #moves, -1 do
                if (RocketBattle.canPokemonUseMove(cid, moves[i], pokemonUid, targetUid)) then
                    move = moves[i]
                    break
                end
            end
        end

        return move
    end

    -- SET
    function RocketBattle.setPokemonStatus(cid, pokemonNumber, status)
        doCreatureSetStorage(cid, POKEMONNUMBER_TO_VAR[pokemonNumber], status)
    end

    function RocketBattle.setMoveCooldown(cid, move, cooldown)
        if (not cooldown) then
            cooldown = getPokemonSkillCooldownTime(move)
        end
        doCreatureSetStorage(cid, getPokemonSkillCooldownStorage(move), cooldown + getCurrentTimeInSeconds())
    end

    -- CAN
    function RocketBattle.canPokemonUseMove(cid, move, pokemonUid, targetUid)
        if (RocketBattle.getMoveCooldown(cid, move) > 0 or getPokemonSkillWildBlock(move) or
                getMonsterLevel(pokemonUid) < getPokemonSkillRequiredLevel(getCreatureName(pokemonUid), move) or
                (getPokemonSkillMakeHeal(move) and getCreatureHealth(pokemonUid) / getCreatureMaxHealth(pokemonUid) > 0.5)) then
            return false
        end

        if (getInstantSpellInfo(SKILL_FUNCTION_PREFIX .. move).needdirection == 1) then
            local pokemonPos, targetPos = getCreaturePosition(pokemonUid), getCreaturePosition(targetUid)
            if (pokemonPos.x ~= targetPos.x and pokemonPos.y ~= targetPos.y) then
                return false
            end
            doCreatureSetLookDirection(pokemonUid, getDirectionTo(pokemonPos, targetPos))
        end
        return true
    end

    -- DO
    function RocketBattle.doCallPokemon(cid, pokemonName, pid)
        doAddExhaust(cid)

        local spawnPosition = getCreaturePosition(cid)
        local pokemon = doSummonCreature(pokemonName, spawnPosition, false)

        local pos = getPositionAdjacent(pokemon, spawnPosition)
        if (pos) then
            doTeleportThing(pokemon, pos)
        end

        doConvinceCreature(cid, pokemon)
        doSendMagicEffect(spawnPosition, balls["poke"].effects.use)
        registerCreatureEvent(pokemon, "npcPokemonDeath")
        doCreatureSay(cid, string.format(__L(pid, "Go, %s!"), pokemonName), TALKTYPE_MONSTER)

        setCreatureSkillLoss(pokemon, true) -- Enable exp
        setMonsterExperienceRate(pokemon, NPC_POKEMON_EXPERIENCE_RATE)

        addEvent(function()
            if (isCreature(pokemon)) then
                doSendCreatureEffect(pokemon, CREATURE_EFFECTS.RED_FADE_IN)
            end
        end, 10)

        local level = getCreatureStorage(cid, NPC_STORAGES.DIFFICULTY)

        setMonsterExtraPoints(pokemon, level + 10)
        setMonsterLevel(pokemon, level)
    end

    local function getElementMultiplerBetweenPokemons(pokemon1, pokemon2)
        if (not pokemon1 or not pokemon2) then
            return 0
        end

        local result = 0
        local pokemon1elements = getPokemonTypes(nil, pokemon1)
        local pokemon2elements = getPokemonTypes(nil, pokemon2)

        for i = 1, #pokemon1elements do
            for j = 1, #pokemon2elements do
                result = result + getElementMultipler(pokemon1elements[i], pokemon2elements[j])
            end
        end

        return result
    end

    local function findMaxInTable(inTable)
        if (#inTable < 1) then
            return nil
        end

        local resultKey, resultValue, tableKey, tableValue = -1, -1, nil, nil

        for tableKey = 1, #inTable do
            tableValue = inTable[tableKey]

            if (tableValue > -1 and tableValue > resultValue) then
                resultKey = tableKey
                resultValue = tableValue
            end
        end

        if (resultValue > -1) then
            return resultKey
        end

        return nil
    end

    function RocketBattle.doCallNextPokemon(cid)
        local npcPokemonsMultiplers = {}
        local pid = getCreatureMaster(getCreatureTarget(cid))
        local npcOpponentPokemonName = getPlayerPokemonName(pid)
        local isTargetPokemon = isPokemon(getCreatureTarget(cid))

        if (getCreatureStorage(cid, NPC_STORAGES.POKEMON1_STATUS) == NPC_POKEMON_STATUS.CAN_USE) then
            if (isTargetPokemon) then
                table.insert(npcPokemonsMultiplers, 1, getElementMultiplerBetweenPokemons(getCreatureStorage(cid, NPC_STORAGES.POKEMON1), npcOpponentPokemonName))
            else
                table.insert(npcPokemonsMultiplers, 1, 1)
            end
        else
            table.insert(npcPokemonsMultiplers, 1, -1)
        end

        if (getCreatureStorage(cid, NPC_STORAGES.POKEMON2_STATUS) == NPC_POKEMON_STATUS.CAN_USE) then
            if (isTargetPokemon) then
                table.insert(npcPokemonsMultiplers, 2, getElementMultiplerBetweenPokemons(getCreatureStorage(cid, NPC_STORAGES.POKEMON2), npcOpponentPokemonName))
            else
                table.insert(npcPokemonsMultiplers, 2, 1)
            end
        else
            table.insert(npcPokemonsMultiplers, 2, -1)
        end

        if (getCreatureStorage(cid, NPC_STORAGES.POKEMON3_STATUS) == NPC_POKEMON_STATUS.CAN_USE) then
            if (isTargetPokemon) then
                table.insert(npcPokemonsMultiplers, 3, getElementMultiplerBetweenPokemons(getCreatureStorage(cid, NPC_STORAGES.POKEMON3), npcOpponentPokemonName))
            else
                table.insert(npcPokemonsMultiplers, 3, 1)
            end
        else
            table.insert(npcPokemonsMultiplers, 3, -1)
        end

        if (getCreatureStorage(cid, NPC_STORAGES.POKEMON4_STATUS) == NPC_POKEMON_STATUS.CAN_USE) then
            if (isTargetPokemon) then
                table.insert(npcPokemonsMultiplers, 4, getElementMultiplerBetweenPokemons(getCreatureStorage(cid, NPC_STORAGES.POKEMON4), npcOpponentPokemonName))
            else
                table.insert(npcPokemonsMultiplers, 4, 1)
            end
        else
            table.insert(npcPokemonsMultiplers, 4, -1)
        end

        if (getCreatureStorage(cid, NPC_STORAGES.POKEMON5_STATUS) == NPC_POKEMON_STATUS.CAN_USE) then
            if (isTargetPokemon) then
                table.insert(npcPokemonsMultiplers, 5, getElementMultiplerBetweenPokemons(getCreatureStorage(cid, NPC_STORAGES.POKEMON5), npcOpponentPokemonName))
            else
                table.insert(npcPokemonsMultiplers, 5, 1)
            end
        else
            table.insert(npcPokemonsMultiplers, 5, -1)
        end

        if (getCreatureStorage(cid, NPC_STORAGES.POKEMON6_STATUS) == NPC_POKEMON_STATUS.CAN_USE) then
            if (isTargetPokemon) then
                table.insert(npcPokemonsMultiplers, 6, getElementMultiplerBetweenPokemons(getCreatureStorage(cid, NPC_STORAGES.POKEMON6), npcOpponentPokemonName))
            else
                table.insert(npcPokemonsMultiplers, 6, 1)
            end
        else
            table.insert(npcPokemonsMultiplers, 6, -1)
        end

        local bestPokemonToUseNow = findMaxInTable(npcPokemonsMultiplers)
        if (bestPokemonToUseNow) then
            local numberToStorage = {[1] = NPC_STORAGES.POKEMON1, [2] = NPC_STORAGES.POKEMON2, [3] = NPC_STORAGES.POKEMON3, [4] = NPC_STORAGES.POKEMON4, [5] = NPC_STORAGES.POKEMON5, [6] = NPC_STORAGES.POKEMON6 }

            RocketBattle.doCallPokemon(cid, getCreatureStorage(cid, numberToStorage[bestPokemonToUseNow]), pid)
            RocketBattle.setPokemonStatus(cid, bestPokemonToUseNow, NPC_POKEMON_STATUS.CANNOT_USE)
            return true
        end

        return false
    end

    --[[function RocketBattle.doBattleEnd(cid, pid, battleEndMode)
        if (battleEndMode == BATTLE_END_MODES.PLAYER_WIN) then
            doCreatureSay(self.uid, __L(pid, table.random(NPC_DIALOGS.NPC_LOSS)), TALKTYPE_MONSTER)

            if (self.rewardBaseExp > 0 or self.rewardBadge ~= nil or #self.rewardItems > 0 or
                    #self.rewardUniqueItems > 0 or self.currentBet > 0) then
                doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "You won %s and received your reward."), self.name))
            else
                doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "You won %s."), self.name))
            end

            doPlayerAddBattleWin(pid)
            doPlayerAddRespect(pid, (self.rewardRespect * 2))
            doPlayerAddStatistic(pid, PLAYER_STATISTIC_IDS.DEFEAT_NPC, 1)

            local previousLevel = self:getLevel(pid)
            self:setLevel(pid, previousLevel + 1)

            if (self.rewardBaseExp > 0) then
                doPlayerAddExperience(pid, self.rewardBaseExp * previousLevel)
                doSendAnimatedText(getCreaturePosition(pid), "+EXP!", COLOR_LIGHTGREEN)
            end

            if (self.rewardBadge ~= nil) then
                self:doPlayerGiveBadge(pid, self.rewardBadge)
                doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "Congratulations! You received the %s from %s."), getItemNameById(self.rewardBadge.newItemId), self.name))
                doPlayerAchievementCheck(pid, ACHIEVEMENT_IDS.KANTO_BADGES)
            end

            for i = 1, #self.rewardItems, 2 do
                doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "You received: %s [%sx]."), getItemNameById(self.rewardItems[i]), self.rewardItems[i + 1]))
                doPlayerAddItem(pid, self.rewardItems[i], self.rewardItems[i + 1], true)
            end

            for i = 1, #self.rewardUniqueItems, 2 do
                local item = doCreateUniqueItemEx(pid, self.rewardUniqueItems[i], self.rewardUniqueItems[i + 1])
                if (item) then
                    if (doPlayerAddItemEx(pid, item, false) == RETURNVALUE_NOERROR) then
                        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "You received: %s [%sx]."), getItemNameById(self.rewardUniqueItems[i]), self.rewardUniqueItems[i + 1]))
                    else
                        doPlayerAddDepotItem(pid, 0, item)
                        doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "You received: %s [%x] directly into your depot."), getItemNameById(self.rewardUniqueItems[i]), self.rewardUniqueItems[i + 1]))
                    end
                else
                    log(LOG_TYPES.ERROR, "RocketBattle:doBattleEnd - Can't create reward unique item.",
                        getCreatureName(pid), self.rewardUniqueItems[i], self.rewardUniqueItems[i + 1])
                end
            end

            if (self.currentBet > 0) then
                doPlayerAddMoney(pid, math.floor(self.currentBet * 2))
            end

            if (self.oneWin) then
                self:setPlayerLastBattleTimeWithNpc(pid, true)
            end

            if (self.lastDefeatTimeStorage) then
                doCreatureSetStorage(pid, self.lastDefeatTimeStorage, os.time())
            end

            if (self.onWin) then
                self.onWin(pid)
            end

        elseif (battleEndMode == BATTLE_END_MODES.PLAYER_LOSS) then
            doCreatureSay(self.uid, __L(pid, table.random(NPC_DIALOGS.NPC_WIN)), TALKTYPE_SAY)
            doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(pid, "You have been defeated by %s!"), self.name))
            doPlayerAddBattleLoss(pid)

        elseif (battleEndMode == BATTLE_END_MODES.PLAYER_AWAY) then
            doCreatureSay(self.uid, table.random(NPC_DIALOGS.NPC_WIN), TALKTYPE_SAY)
            doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "You and your opponent were too far from each other and the battle was canceled.")
            doPlayerAddBattleLoss(pid)
        end

        if (self:isPokemonOnline()) then
            local npcPokemon = self:getPokemon()

            doCreatureSay(self.uid, string.format(__L(pid, "Back, %s!"), getCreatureName(npcPokemon)), TALKTYPE_SAY)
            doSendMagicEffect(getCreaturePosition(npcPokemon), balls["poke"].effects.use)
            doRemoveCreature(npcPokemon)
        end

        self:setBattleStatus(NPC_BATTLE_STATUS.ISNT_BATTLEING)
        self.npcHandler:releaseFocus(pid)

        if (isPlayer(pid)) then
            setPlayerBattleing(pid, false)
            setPlayerDisconnectAtExit(pid, true)
            doCreatureSetNoMove(pid, false)

            if (self.onEnd) then
                self.onEnd(pid, battleEndMode == BATTLE_END_MODES.PLAYER_WIN, self.uid)
            end
        end
    end]]

    function RocketBattle.onEnd(cid)
        if (CUSTOM_ON_END[getCreatureName(cid)]) then
            CUSTOM_ON_END[getCreatureName(cid)](cid)
        end

        if (getCreatureNoMove(cid)) then -- Already animating
            return
        end

        local NPC_ANIMATION = {
            -- Rocket Male
            [533] = 1330,
            [1330] = 1331,
            [1331] = 1332,
            [1332] = 1333,
            [1333] = 1334,
            [1334] = 1335,
            [1335] = 1336,
            [1336] = 1337,
            [1337] = 1338,

            -- Rocket Female
            [534] = 1339,
            [1339] = 1340,
            [1340] = 1341,
            [1341] = 1342,
            [1342] = 1343,
            [1344] = 1345,
            [1345] = 1346,
            [1346] = 1347
        }

        local outfit = getCreatureOutfit(cid)

        local doAnim
        doAnim = function(cid, currentLookType, starting)
            if ((starting and getRandom(1, 100) <= 50) or not starting) then
                if (NPC_ANIMATION[currentLookType]) then
                    doCreatureSetNoMove(cid, true)
                    currentLookType = NPC_ANIMATION[currentLookType]
                    doCreatureChangeOutfit(cid, {lookType = currentLookType})
                    if (currentLookType) then
                        addEvent(doAnim, 300, cid, currentLookType, false)
                        return
                    end
                end
            end

            doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_UP)
            doRemoveCreature(cid)
        end

        doAnim(cid, outfit.lookType, true)
    end

    function RocketBattle.onThink(cid)
        local pid = getCreatureTarget(cid)
        if (not isCreature(pid)) then
            return
        end

        local playerPosition = getCreaturePosition(pid)
        local npcPosition = getCreaturePosition(cid)

        if (RocketBattle.isPokemonOnline(cid)) then
            local npcPokemon = RocketBattle.getPokemon(cid)
            if (not hasTarget(npcPokemon)) then
                doCreatureSetTarget(npcPokemon, pid)
            end

            if (not isExhaust(cid)) then
                local move = RocketBattle.getPokemonMove(cid, npcPokemon, pid)
                if (move) then
                    RocketBattle.doPokemonUseMove(cid, npcPokemon, move)
                end
            end

            if (getRandom(0, 100) <= 25 or getDistanceBetween(getCreaturePosition(npcPokemon),
                getCreaturePosition(pid)) > 3) then
            end
        else
            if (RocketBattle.doCallNextPokemon(cid)) then
                doCreatureSay(cid, __L(getCreatureMaster(pid), table.random(NPC_DIALOGS.POKEMON_DOWN)), TALKTYPE_SAY)
            else
                RocketBattle.onEnd(cid)
            end
        end
    end

    function RocketBattle.doPokemonUseMove(cid, pokemonUid, move)
        if (doPokemonUseSkill(pokemonUid, move)) then
            RocketBattle.setMoveCooldown(cid, move)
            doAddExhaust(cid)
        end
    end

    function RocketBattle.onSpawn(cid, config)
        local numberToStorage = {[1] = NPC_STORAGES.POKEMON1, [2] = NPC_STORAGES.POKEMON2, [3] = NPC_STORAGES.POKEMON3, [4] = NPC_STORAGES.POKEMON4, [5] = NPC_STORAGES.POKEMON5, [6] = NPC_STORAGES.POKEMON6}
        for i, pokemon in pairs(config.pokemonTeam) do
            doCreatureSetStorage(cid, numberToStorage[i], pokemon)
            doCreatureSetStorage(cid, POKEMONNUMBER_TO_VAR[i], NPC_POKEMON_STATUS.CAN_USE)
        end

        doCreatureSetStorage(cid, NPC_STORAGES.DIFFICULTY, config.difficulty)
    end
end
local DEXES = {}
DEXES[DEX_IDS.KANTO] = {itemId = 12281, pokemonIdMax = POKEMON_NUMBER, effect = EFFECT_EMOTION_POKEDEX,
  upgrade = DEX_IDS.JOHTO, showTime = false}
DEXES[DEX_IDS.JOHTO] = {itemId = 18161, pokemonIdMax = POKEMON_NUMBER, effect = EFFECT_EMOTION_JOHTO_POKEDEX,
  showTime = true}

local DEX_BY_ITEMID = {}
for k, v in pairs(DEXES) do
  DEX_BY_ITEMID[v.itemId] = v
end

POKEDEXSTATUS_UNKNOWN = 0
POKEDEXSTATUS_DEXED = 1
POKEDEXSTATUS_CATCHED = 2
POKEDEXSTATUS_SHINYCATCHED = 3
POKEDEXSTATUS_DEXED_CATCHED = 4
POKEDEXSTATUS_DEXED_SHINYCATCHED = 5
POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED = 6
POKEDEXSTATUS_CATCHED_SHINYCATCHED = 7

local POKEDEXSTATUS_CHANGE = {
  [POKEDEXSTATUS_UNKNOWN] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_CATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_SHINYCATCHED
  },
  [POKEDEXSTATUS_DEXED] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_DEXED_CATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_DEXED_SHINYCATCHED
  },
  [POKEDEXSTATUS_CATCHED] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED_CATCHED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_CATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_CATCHED_SHINYCATCHED
  },
  [POKEDEXSTATUS_SHINYCATCHED] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED_SHINYCATCHED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_CATCHED_SHINYCATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_SHINYCATCHED
  },
  [POKEDEXSTATUS_DEXED_CATCHED] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED_CATCHED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_DEXED_CATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED
  },
  [POKEDEXSTATUS_DEXED_SHINYCATCHED] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED_SHINYCATCHED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_DEXED_SHINYCATCHED
  },
  [POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED
  },
  [POKEDEXSTATUS_CATCHED_SHINYCATCHED] = {
    [POKEDEXSTATUS_DEXED] = POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED,
    [POKEDEXSTATUS_CATCHED] = POKEDEXSTATUS_CATCHED_SHINYCATCHED,
    [POKEDEXSTATUS_SHINYCATCHED] = POKEDEXSTATUS_CATCHED_SHINYCATCHED
  }
}

local TRAINER_CARD_ITEMID = 18753

function getDexByItemId(itemId)
  return DEX_BY_ITEMID[itemId]
end

local function getPlayerPokedex(cid)
  return getPlayerSlotItem(cid, PLAYER_SLOT_POKEDEX)
end

local function getPokedexItemStatus(pid, pokemonName)
  if (type(pokemonName) == "number") then
    pokemonName = getPokemonNameByNumber(pokemonName)
  end
  local s = getCreatureStorage(pid, getPokemonDexStorage(pokemonName))
  return s > -1 and s or POKEDEXSTATUS_UNKNOWN
end

local function setPokedexItemStatus(pid, pokemonName, status)
  doCreatureSetStorage(pid, getPokemonDexStorage(pokemonName), status)
  doPlayerSendPokedexItemUpdate(pid, getPokemonNumberByName(pokemonName), status)
end

function updatePokedexItemStatus(pid, pokemonName, newStatus)
  local currentStatus = getPokedexItemStatus(pid, pokemonName)
  if (POKEDEXSTATUS_CHANGE[currentStatus][newStatus] ~= currentStatus) then
    setPokedexItemStatus(pid, pokemonName, POKEDEXSTATUS_CHANGE[currentStatus][newStatus])
  end
end

function getPlayerTotalDexedPokemons(cid)
  local total = getCreatureStorage(cid, playersStorages.pokemonsDexeds)
  if (total == -1) then
    return 0
  end
  return total
end

function hasPlayerDexedPokemon(cid, pokemonName)
  local s = getPokedexItemStatus(cid, pokemonName)
  return s == POKEDEXSTATUS_DEXED or s == POKEDEXSTATUS_DEXED_CATCHED or s == POKEDEXSTATUS_DEXED_SHINYCATCHED
  or s == POKEDEXSTATUS_DEXED_CATCHED_SHINYCATCHED
end

local function canRegister(cid, pokemonName)
  return getPokemonNumberByName(pokemonName) <= DEX_BY_ITEMID[getPlayerPokedex(cid).itemid].pokemonIdMax
end

function doPokedexTryRegister(cid, pokemonName)
  if (not canRegister(cid, pokemonName)) then
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your Pokedex can not register this Pokemon! Please, upgrade your Pokedex.")
    return
  end

  if (not hasPlayerDexedPokemon(cid, pokemonName)) then
    local dexExperience = getMonsterInfo(pokemonName).experience * 20
    local numberOfPokemonsDexeds = getPlayerTotalDexedPokemons(cid) + 1

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You earned %s experience points by discovering %s!"), dexExperience, pokemonName))
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You discovered a total of %s different Pokemon until now."), numberOfPokemonsDexeds))
    doPlayerAddExperience(cid, dexExperience)
    doCreatureSetStorage(cid, playersStorages.pokemonsDexeds, numberOfPokemonsDexeds)
    updatePokedexItemStatus(cid, pokemonName, POKEDEXSTATUS_DEXED)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.DEX_1, getPlayerTotalDexedPokemons(cid))
  end
end

local function getTypesText(pokemonName, pokemon, pid)
  local types = {}
  for i, type in ipairs(getPokemonTypes(pokemon, pokemonName)) do
    if (i > 1) then
      types[#types + 1] = __L(pid, " and ")
    end
    types[#types + 1] = __L(pid, ELEMENT_NAMES[type])
  end
  return (#types == 0 and __L(pid, "Unknown\n") or table.concat(types))
end

local function getMovesText(pokemonName, pid, detailed, newClient)
  local skills = {}

  if (newClient) then
    for i, skill in ipairs(detailed and getPokemonSkills(pokemonName, getPlayerBall(pid).uid) or
      getPokemonDefaultSkills(pokemonName)) do
      skills[#skills + 1] = i
      skills[#skills + 1] = ","
      skills[#skills + 1] = getPokemonSkillDamageType(skill)
      skills[#skills + 1] = ","
      skills[#skills + 1] = skill
      skills[#skills + 1] = ","
      skills[#skills + 1] = getPokemonSkillCategory(skill)
      skills[#skills + 1] = ","
      skills[#skills + 1] = getPokemonSkillDamage(skill)
      skills[#skills + 1] = ","
      skills[#skills + 1] = getPokemonSkillRequiredEnergy(skill)
      skills[#skills + 1] = ","
      skills[#skills + 1] = getPokemonSkillRequiredLevel(pokemonName, skill)
      skills[#skills + 1] = ","
      skills[#skills + 1] = getPokemonSkillCooldownTime(skill)
      skills[#skills + 1] = ","
      skills[#skills + 1] = getPokemonSkillMaxDistance(skill)
      skills[#skills + 1] = ";"
    end
    skills[#skills] = ";"
  else
    for i, skill in ipairs(detailed and getPokemonSkills(pokemonName, getPlayerBall(pid).uid) or
      getPokemonDefaultSkills(pokemonName)) do
      skills[#skills + 1] = i
      skills[#skills + 1] = ". "
      skills[#skills + 1] = skill
      skills[#skills + 1] = " - T: "
      skills[#skills + 1] = __L(pid, ELEMENT_NAMES[getPokemonSkillDamageType(skill)])
      skills[#skills + 1] = " - C: "
      skills[#skills + 1] = MOVE_CATEGORY_NAMES[getPokemonSkillCategory(skill)]
      skills[#skills + 1] = "\nPo: "
      skills[#skills + 1] = getPokemonSkillDamage(skill)
      skills[#skills + 1] = " - En: "
      skills[#skills + 1] = getPokemonSkillRequiredEnergy(skill)
      skills[#skills + 1] = " - Lv: "
      skills[#skills + 1] = getPokemonSkillRequiredLevel(pokemonName, skill)
      skills[#skills + 1] = " - Cd: "
      skills[#skills + 1] = getPokemonSkillCooldownTime(skill)
      skills[#skills + 1] = "\n\n"
    end
  end
  return (#skills == 0 and __L(pid, "None.\n") or table.concat(skills))
end

local function getAbilitiesText(pokemonName, pid)
  local abilities = {}
  for i, abilitie in ipairs(getPokemonAbilities(pokemonName)) do
    if (i > 1) then
      abilities[#abilities + 1] = (i < #getPokemonAbilities(pokemonName) and ", " or __L(pid, " and "))
    end
    abilities[#abilities + 1] = abilitie
  end
  if (#abilities == 0) then
    return __L(pid, "None.")
  else
    abilities[#abilities + 1] = "."
    return table.concat(abilities)
  end
end

local function getEggGroupsText(pokemonName, pid)
  local eggGroups = {}
  for i, eggGroup in ipairs(getPokemonEggGroups(pokemonName)) do
    if (i > 1) then
      eggGroups[#eggGroups + 1] = __L(pid, " and ")
    end
    eggGroups[#eggGroups + 1] = POKEMON_EGG_GROUP_NAMES[eggGroup]
  end
  if (#eggGroups == 0) then
    return __L(pid, "None.")
  else
    eggGroups[#eggGroups + 1] = "."
    return table.concat(eggGroups)
  end
end

local function getEvolutionsText(pokemonName, pid)
  local evolution = {}
  if (havePokemonEvolution(pokemonName)) then
    for k, v in ipairs(getPokemonEvolutions(pokemonName)) do
      evolution[#evolution + 1] = v.name
      evolution[#evolution + 1] = " - L: "
      evolution[#evolution + 1] = v.requiredLevel

      if (v.requiredTime) then
        evolution[#evolution + 1] = __L(pid, " - On ")
        evolution[#evolution + 1] = __L(pid, WORLD_LIGHT_STATE_NAMES[v.requiredTime])
      end

      if (v.requiredItems) then
        evolution[#evolution + 1] = __L(pid, " - Required Item")
        evolution[#evolution + 1] = (#v.requiredItems > 1 and "s: " or ": ")
        for j = 1, #v.requiredItems do
          evolution[#evolution + 1] = getItemNameById(v.requiredItems[j])
          if (j + 1 < #v.requiredItems) then
            evolution[#evolution + 1] = ", "
          end
        end
      end

      evolution[#evolution + 1] = "\n\n"
    end

    if (#evolution > 0) then
      evolution[#evolution] = "\n" -- Extra \n fix
      return table.concat(evolution)
    else
      return __L(pid, "None.\n")
    end

  else
    return __L(pid, "None.\n")
  end
end

local function getSpecialAbilitiesText(pokemonName, pid, detailed)
  local specialAbilities = {}
  if (detailed) then
    local abilitie = getMonsterSpecialAbility(getPlayerPokemon(pid))
    return getPokemonSpecialAbilityName(abilitie).. ":\n" ..__L(pid, getPokemonSpecialAbilityDescription(abilitie))
  else
    for i, specialAbility in ipairs(getPokemonSpecialAbilities(pokemonName)) do
      if (i > 1) then
        specialAbilities[#specialAbilities + 1] = __L(pid, " and ")
      end
      specialAbilities[#specialAbilities + 1] = getPokemonSpecialAbilityName(specialAbility)
    end
    specialAbilities[#specialAbilities + 1] = "."
    return table.concat(specialAbilities)
  end
end

local function getTypeEffectivenessText(pokemonName, pokemon, newClient, pid)
  local typesEffect = {normal = {}, weak = {}, immune = {}, resistant = {}}

  for element = ELEMENT_FIRST, ELEMENT_LAST do
    local elementMultipler = 1
    for _, type in pairs(getPokemonTypes(pokemon, pokemonName)) do
      elementMultipler = elementMultipler * getElementMultipler(element, type)
    end

    if (elementMultipler == 1) then
      typesEffect.normal[#typesEffect.normal + 1] = element
    elseif (elementMultipler == 0) then
      typesEffect.immune[#typesEffect.immune + 1] = element
    elseif (elementMultipler < 1) then
      typesEffect.resistant[#typesEffect.resistant + 1] = element
    else
      typesEffect.weak[#typesEffect.weak + 1] = element
    end
  end

  local typeEffectiveness = {}

  if (newClient) then
    if (#typesEffect.normal > 0) then
      for _, tmp in pairs(typesEffect.normal) do
        typeEffectiveness[#typeEffectiveness + 1] = tmp
        typeEffectiveness[#typeEffectiveness + 1] = ","
      end
      typeEffectiveness[#typeEffectiveness] = ";"
    else
      typeEffectiveness[#typeEffectiveness + 1] = ";"
    end

    if (#typesEffect.immune > 0) then
      for _, tmp in pairs(typesEffect.immune) do
        typeEffectiveness[#typeEffectiveness + 1] = tmp
        typeEffectiveness[#typeEffectiveness + 1] = ","
      end
      typeEffectiveness[#typeEffectiveness] = ";"
    else
      typeEffectiveness[#typeEffectiveness + 1] = ";"
    end

    if (#typesEffect.resistant > 0) then
      for _, tmp in pairs(typesEffect.resistant) do
        typeEffectiveness[#typeEffectiveness + 1] = tmp
        typeEffectiveness[#typeEffectiveness + 1] = ","
      end
      typeEffectiveness[#typeEffectiveness] = ";"
    else
      typeEffectiveness[#typeEffectiveness + 1] = ";"
    end

    if (#typesEffect.weak > 0) then
      for _, tmp in pairs(typesEffect.weak) do
        typeEffectiveness[#typeEffectiveness + 1] = tmp
        typeEffectiveness[#typeEffectiveness + 1] = ","
      end
      typeEffectiveness[#typeEffectiveness] = ";"
    else
      typeEffectiveness[#typeEffectiveness + 1] = ";"
    end

  else
    typeEffectiveness[#typeEffectiveness + 1] = "Normal: "
    for _, tmp in pairs(typesEffect.normal) do
      typeEffectiveness[#typeEffectiveness + 1] = __L(pid, ELEMENT_NAMES[tmp])
      typeEffectiveness[#typeEffectiveness + 1] = ", "
    end
    if (typeEffectiveness[#typeEffectiveness] == ", ") then
      typeEffectiveness[#typeEffectiveness] = ".\n"
    else
      typeEffectiveness[#typeEffectiveness + 1] = __L(pid, "None.\n")
    end

    typeEffectiveness[#typeEffectiveness + 1] = __L(pid, "Immune: ")
    for _, tmp in pairs(typesEffect.immune) do
      typeEffectiveness[#typeEffectiveness + 1] = __L(pid, ELEMENT_NAMES[tmp])
      typeEffectiveness[#typeEffectiveness + 1] = ", "
    end
    if (typeEffectiveness[#typeEffectiveness] == ", ") then
      typeEffectiveness[#typeEffectiveness] = ".\n"
    else
      typeEffectiveness[#typeEffectiveness + 1] =  __L(pid, "None.\n")
    end

    typeEffectiveness[#typeEffectiveness + 1] =  __L(pid, "Resistant: ")
    for _, tmp in pairs(typesEffect.resistant) do
      typeEffectiveness[#typeEffectiveness + 1] = __L(pid, ELEMENT_NAMES[tmp])
      typeEffectiveness[#typeEffectiveness + 1] = ", "
    end
    if (typeEffectiveness[#typeEffectiveness] == ", ") then
      typeEffectiveness[#typeEffectiveness] = ".\n"
    else
      typeEffectiveness[#typeEffectiveness + 1] = __L(pid, "None.\n")
    end

    typeEffectiveness[#typeEffectiveness + 1] = __L(pid, "Weak: ")
    for _, tmp in pairs(typesEffect.weak) do
      typeEffectiveness[#typeEffectiveness + 1] = __L(pid, ELEMENT_NAMES[tmp])
      typeEffectiveness[#typeEffectiveness + 1] = ", "
    end
    if (typeEffectiveness[#typeEffectiveness] == ", ") then
      typeEffectiveness[#typeEffectiveness] = ".\n"
    else
      typeEffectiveness[#typeEffectiveness + 1] = __L(pid, "None.\n")
    end
  end

  return table.concat(typeEffectiveness)
end

local function getTransformatMemory(ballUid, pokemonName, pid)
  if (not table.find(getPokemonAbilities(pokemonName), "Transform")) then
    return nil
  end

  local transformMemory = {}
  for i = 1, POKEMON_TRANSFORM_MEMORY_MAX do
    local t = getBallTransformMemory(ballUid, i)
    if (not t) then
      break
    end

    if (i > 1) then
      transformMemory[#transformMemory + 1] = " , "
    end
    transformMemory[#transformMemory + 1] = t
  end

  if (#transformMemory == 0) then
    return __L(pid, "Empty.\n")
  else
    transformMemory[#transformMemory - 1] = __L(pid, " and ")
    transformMemory[#transformMemory + 1] = ".\n"
  end

  return table.concat(transformMemory)
end

local function getEggMovesText(pokemonName, pid)
  local ret = {}
  for i, eggMove in ipairs(getPokemonEggMoves(pokemonName)) do
    if (i > 1) then
      ret[#ret + 1] = (i < #getPokemonEggMoves(pokemonName) and ", " or __L(pid, " and "))
    end
    ret[#ret + 1] = eggMove
    ret[#ret + 1] = " ("
    ret[#ret + 1] = __L(pid, ELEMENT_NAMES[getPokemonSkillDamageType(eggMove)])
    ret[#ret + 1] = ")"
  end
  if (#ret == 0) then
    return __L(pid, "None.")
  else
    ret[#ret + 1] = "."
    return table.concat(ret)
  end
end

local function doSendDexInfo(pid, pokemonName, detailed, info, pokemonBall)
  local details = {}
  local moves = {}
  local effectiveness = {}

  local lines = {}
  if (detailed) then
    local ball = getPlayerBall(pid)
    local pokemon = getPlayerPokemon(pid)
    local pokemonLevel = getPlayerPokemonLevel(pid)
    local pokemonExperience = getPlayerPokemonExperience(pid)
    local nextLevelExp = getExperienceForLevel(pokemonLevel + 1)
    local pokemonHealth = getCreatureHealth(pokemon)
    local pokemonMaxHealth = getCreatureMaxHealth(pokemon)
    local pokemonEnergy = getCreatureMana(pid)
    local pokemonMaxEnergy = getCreatureMaxMana(pid)

    local transformMemory = getTransformatMemory(ball.uid, pokemonName, pid)

    lines[#lines + 1] = string.format(__L(pid, "Pokemon: %s\nType: %s\n\nLevel: %s\nExperience: %s\nExperience for next level: %s\nHealth: %s / %s\nEnergy: %s / %s\nAttack: %s\nDefense: %s\nSp. Attack: %s\nSp. Defense: %s\n\nEvolution:\n%s\nAbilities:\n%s\n\nEgg Groups:\n%s\n\nSpecial Ability - %s\n\nEgg Moves - %s\n\nVitamins:\n%s\n\nHeld:\n%s"), pokemonName, info.types, pokemonLevel, pokemonExperience, nextLevelExp - pokemonExperience, pokemonHealth, pokemonMaxHealth, pokemonEnergy, pokemonMaxEnergy, math.round(getPokemonAtk(pokemon, pokemonLevel), 2), math.round(getPokemonDef(pokemon, pokemonLevel), 2), math.round(getPokemonSpAtk(pokemon, pokemonLevel), 2), math.round(getPokemonSpDef(pokemon, pokemonLevel), 2), info.evolution, info.abilities, info.eggGroups, info.specialAbilities, info.eggMoves, Vitamin.getBallDescription(ball.uid), PokemonHeldItem.getBallDescription(ball.uid))
    if (transformMemory) then
      lines[#lines + 1] = string.format(__L(pid, "\nTransform Memory:\n%s"), transformMemory)
    end

  else
    local min = getMonsterInfo(pokemonName).minLevel
    local max = getMonsterInfo(pokemonName).maxLevel

    lines[#lines + 1] = string.format(__L(pid, "Pokemon: %s\nType: %s\nCommon Wild Level: %s\nCaughts: %s\n%s currently.\nDescription:\n%s\n\nEvolution:\n%s\nAbilities:\n%s\n\nEgg Groups:\n%s\n\nSpecial Abilities:\n%s\n\nEgg Moves - %s"), pokemonName, info.types, (min ~= max and (min .. " - " .. max) or (min)), getPlayerPokemonCaughts(pid, pokemonName), getPlayerWastedBallsMessage(pid, getPokemonNumberByName(pokemonName)), __L(pid, getPokemonDescription(pokemonName)), info.evolution, info.abilities, info.eggGroups, info.specialAbilities, info.eggMoves)

    if (pokemonBall) then
      lines[#lines + 1] = string.format(__L(pid, "\n\nVitamins:\n%s\n\nHeld:\n%s"), Vitamin.getBallDescription(pokemonBall.uid), PokemonHeldItem.getBallDescription(pokemonBall.uid))
    end
  end

  doPlayerSendPokedexInfo(pid, getPokemonNumberByName(pokemonName), table.concat(lines), info.skills,
    info.typeEffectiveness, getPokemonFamiliesString(pokemonName))
end

local function doSendOldDexInfo(pid, pokemonName, detailed, info, pokemonBall)
  -- DEX TEXT LINES
  local lines = {}
  if (detailed) then
    local ball = getPlayerBall(pid)
    local pokemon = getPlayerPokemon(pid)
    local pokemonLevel = getPlayerPokemonLevel(pid)
    local pokemonExperience = getPlayerPokemonExperience(pid)
    local nextLevelExp = getExperienceForLevel(pokemonLevel + 1)
    local pokemonHealth = getCreatureHealth(pokemon)
    local pokemonMaxHealth = getCreatureMaxHealth(pokemon)
    local pokemonEnergy = getCreatureMana(pid)
    local pokemonMaxEnergy = getCreatureMaxMana(pid)

    local transformMemory = getTransformatMemory(ball.uid, pokemonName)

    lines[#lines + 1] = string.format(__L(pid, "Pokemon: %s\nType: %s\n\nLevel: %s\nExperience: %s\nExperience for next level: %s\nHealth: %s / %s\nEnergy: %s / %s\nAttack: %s\nDefense: %s\nSp. Attack: %s\nSp. Defense: %s\n\nEvolution:\n%s\nMoves:\n%s\nAbilities:\n%s\n\nEgg Groups:\n%s\n\nSpecial Ability - %s\n\nType Effectiveness:\n%s\nEgg Moves - %s\n\nVitamins:\n%s\n\nHeld:\n%s"), pokemonName, info.types, pokemonLevel, pokemonExperience, nextLevelExp - pokemonExperience, pokemonHealth, pokemonMaxHealth, pokemonEnergy, pokemonMaxEnergy, math.round(getPokemonAtk(pokemon, pokemonLevel), 2), math.round(getPokemonDef(pokemon, pokemonLevel), 2), math.round(getPokemonSpAtk(pokemon, pokemonLevel), 2), math.round(getPokemonSpDef(pokemon, pokemonLevel), 2), info.evolution, info.skills, info.abilities, info.eggGroups, info.specialAbilities, info.typeEffectiveness, info.eggMoves, Vitamin.getBallDescription(ball.uid), PokemonHeldItem.getBallDescription(ball.uid))
    if (transformMemory) then
      lines[#lines + 1] = string.format(__L(pid, "\nTransform Memory:\n%s"), transformMemory)
    end
    lines[#lines + 1] = __L(pid, "\nPo = Power, En = Energy, Lv = Level\nCd = Cooldown, G = Group, T = Type")

  else
    local min = getMonsterInfo(pokemonName).minLevel
    local max = getMonsterInfo(pokemonName).maxLevel
    lines[#lines + 1] = string.format(__L(pid, "Pokemon: %s\nType: %s\nCommon Wild Level: %s\nCaughts: %s\n%s currently.\n\nDescription:\n%s\n\nEvolution:\n%s\nMoves:\n%s\nAbilities:\n%s\n\nEgg Groups:\n%s\n\nSpecial Abilities:\n%s\n\nType Effectiveness:\n%s\nEgg Moves - %s"), pokemonName, info.types, (min ~= max and (min .. " - " .. max) or (min)), getPlayerPokemonCaughts(pid, pokemonName), getPlayerWastedBallsMessage(pid, getPokemonNumberByName(pokemonName)), __L(pid, getPokemonDescription(pokemonName)), info.evolution, info.skills, info.abilities, info.eggGroups, info.specialAbilities, info.typeEffectiveness, info.eggMoves)

    if (pokemonBall) then
      lines[#lines + 1] = string.format(__L(pid, "\n\nVitamins:\n%s\n\nHeld:\n%s"), Vitamin.getBallDescription(pokemonBall.uid), PokemonHeldItem.getBallDescription(pokemonBall.uid))
    end
    lines[#lines + 1] = __L(pid, "\nPo = Power, En = Energy, Lv = Level\nCd = Cooldown, G = Group, T = Type")
  end

  doShowTextDialog(pid, getPokemonPortraitId(pokemonName), table.concat(lines))
end

function doPokedexItemView(pid, pokemonName, detailed--[[ = false]], itemId, pokemon, pokemonBall)
  local dex = DEX_BY_ITEMID[itemId or getPlayerPokedex(pid).itemid]
  if (type(pokemonName) == "number") then
    pokemonName = getPokemonNameByNumber(pokemonName)
  end

  if (not isPlayerGhost(pid, true)) then
    doSendMagicEffect(getCreaturePosition(pid), dex.effect)
  end

  local info = {}
  info.types = getTypesText(pokemonName, pokemon, pid)
  info.abilities = getAbilitiesText(pokemonName, pid)
  info.eggGroups = getEggGroupsText(pokemonName, pid)
  info.evolution = getEvolutionsText(pokemonName, pid)
  info.specialAbilities = getSpecialAbilitiesText(pokemonName, pid, detailed)
  info.eggMoves = getEggMovesText(pokemonName, pid)

  if (getPlayerUsingOtClient(pid)) then
    info.skills = getMovesText(pokemonName, pid, detailed, true)
    info.typeEffectiveness = getTypeEffectivenessText(pokemonName, pokemon, true, pid)
    doSendDexInfo(pid, pokemonName, detailed, info, pokemonBall)
  else
    info.skills = getMovesText(pokemonName, pid, detailed, false)
    info.typeEffectiveness = getTypeEffectivenessText(pokemonName, pokemon, false, pid)
    doSendOldDexInfo(pid, pokemonName, detailed, info, pokemonBall)
  end

  doPokedexTryRegister(pid, pokemonName)
end

function doPokedexStatusSend(pid)
  local pokemonMax = DEX_BY_ITEMID[getPlayerPokedex(pid).itemid].pokemonIdMax

  local status = {}
  for i, pokemonName in pairs(pokemonNamesWithoutShiny) do
    local pn = getPokemonNumberByName(pokemonName)
    if (pn > pokemonMax) then
      break
    end
    status[pn] = getPokedexItemStatus(pid, pokemonName)
  end
  doPlayerSendPokedexStatus(pid, status)
end

function doPlayerUpgradePokedex(cid, oldDex)
  local item = getPlayerSlotItem(cid, PLAYER_SLOT_POKEDEX)
  if (not isItem(item)) then
    return
  end

  if (not DEXES[oldDex].upgrade) then
    return
  end

  if (doTransformItem(item.uid, DEXES[DEXES[oldDex].upgrade].itemId)) then
    doPokedexStatusSend(cid)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your pokedex has been upgraded!")
  end
end

local function doPokedexPlayerView(cid, target, itemId)
  local dex = DEX_BY_ITEMID[itemId]

  local badgeText = {}
  for _, badge in pairs(BADGES) do
    if (getPlayerItemCount(target, badge.newItemId) > 0) then
      badgeText[#badgeText + 1] = badge.name
      badgeText[#badgeText + 1] = ", "
    end
  end
  if (badgeText[#badgeText] == ", ") then
    badgeText[#badgeText] = "."
  else
    badgeText[#badgeText + 1] = __L(cid, "None.")
  end

  doShowTextDialog(cid, TRAINER_CARD_ITEMID, string.format(__L(cid, "Trainer: %s\nLevel: %s\nClass: %s\nTown: %s\nGuild: %s\n\nDuel Win: %s\nDuel Loss: %s\nBattle Win: %s\nBattle Loss: %s\n\nDiscovered Pokemon: %s\nTotal Caughts: %s\nHeadbutting: %s\nCatching: %s\nFishing: %s\n\nBadges: %s\nAchievement Score: %s"), getPlayerName(target), getPlayerLevel(target), getVocationInfo(getPlayerVocation(target)).name, getTownName(getPlayerTown(target)), (getPlayerGuildName(target) ~= "" and getPlayerGuildName(target) or __L(cid, "None")), getPlayerSkillLevel(target, PLAYER_SKILL_DUEL_WIN), getPlayerSkillLevel(target, PLAYER_SKILL_DUEL_LOSS), getPlayerSkillLevel(target, PLAYER_SKILL_BATTLE_WIN), getPlayerSkillLevel(target, PLAYER_SKILL_BATTLE_LOSS), getPlayerTotalDexedPokemons(target), getPlayerCaughts(target), getPlayerSkillLevel(target, PLAYER_SKILL_HEADBUTTING), getPlayerSkillLevel(target, PLAYER_SKILL_CATCHING), getPlayerSkillLevel(target, PLAYER_SKILL_FISHING), table.concat(badgeText), getPlayerHighscoreValue(target, HIGHSCORE_IDS.ACHIEVEMENTS)))
  if (not isPlayerGhost(cid, true)) then
    doSendMagicEffect(getCreaturePosition(cid), dex.effect)
  end
end

function onCreatureUsePokedex(cid, item, fromPosition, itemEx, toPosition)
  if (isItem(itemEx)) then
    if (getTmByItemId(itemEx.itemid)) then
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please, type the Pokemon name that you want to check.")
      setPlayerLastDexedTmItemId(cid, itemEx.itemid)
      doPlayerWriteItem(cid, item.uid)
      return true

    elseif (isBallWithPokemonByBallId(itemEx.itemid)) then
      if (fromPosition.x ~= CONTAINER_POSITION or toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return true
      end

      doPokedexItemView(cid, getBallPokemonName(itemEx.uid), nil, item.itemid, nil, itemEx)
      return true
    end
  end

  local playerPosition = getCreaturePosition(cid)
  if (getSamePosition(playerPosition, toPosition)) then
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "Pokedex status: [%s/%s]."), getPlayerTotalDexedPokemons(cid), POKEMON_NUMBER))
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "You've already caught %s Pokemon species, totaling %s caughts."), getPlayerIndividualCaughts(cid), getPlayerCaughts(cid)))
    doPlayerSendPokedexOpen(cid)

    if (DEX_BY_ITEMID[item.itemid or getPlayerPokedex(cid).itemid].showTime) then
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
        string.format(__L(cid, "The time now is %s (%s)."), getGameTimeString(), __L(cid, WORLD_LIGHT_STATE_NAMES[getWorldLightState()])))
    end

  else
    local topCreature = getTopCreature(toPosition).uid
    if (not isCreature(topCreature)) then
      local corpse = getTileItemByType(toPosition, ITEM_TYPE_CONTAINER)
      if (isItem(corpse) and isCorpse(corpse.uid)) then
        local pokemonName = getItemAttribute(corpse.uid, "pokemon")
        if (pokemonName and isPokemonName(pokemonName)) then
          doPokedexItemView(cid, pokemonName, nil, item.itemid)
          return true
        end
      end

      doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

    elseif (isPlayer(topCreature) and not isPlayerGhost(topCreature, true)) then
      doPokedexPlayerView(cid, topCreature, item.itemid)

    elseif (getDistanceBetween(getCreaturePosition(cid), getCreaturePosition(topCreature)) > 5) then
      doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

    else
      local topCreatureName = getCreatureName(topCreature)
      if (not isInArray(pokemonsNames, topCreatureName)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

      else
        if (isPokemonWild(topCreature)) then
          doPokedexItemView(cid, topCreatureName, nil, item.itemid, topCreature)
        else
          doPokedexItemView(cid, topCreatureName, getCreatureMaster(topCreature) == cid, item.itemid, topCreature)
        end
      end
    end
  end
  return true
end
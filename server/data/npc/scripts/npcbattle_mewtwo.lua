local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local function doMewtwoSavePlayerPokemon(cid)
  local trainers = {
    ["Ash Ketchum"] = {originalPosition = {x = 5517, y = 237, z = 6}, targetPosition = {x = 5523, y = 234, z = 6}},
    ["Fergus"] = {originalPosition = {x = 5515, y = 243, z = 6}, targetPosition = {x = 5526, y = 234, z = 6}},
    ["Corey"] = {originalPosition = {x = 5529, y = 237, z = 6}, targetPosition = {x = 5522, y = 234, z = 6}},
    ["Brock"] = {originalPosition = {x = 5521, y = 247, z = 6}, targetPosition = {x = 5521, y = 234, z = 6}},
    ["Misty"] = {originalPosition = {x = 5527, y = 249, z = 6}, targetPosition = {x = 5525, y = 234, z = 6}},
    ["Neesha"] = {originalPosition = {x = 5532, y = 244, z = 6}, targetPosition = {x = 5524, y = 234, z = 6}},
  }

  local pokemon = {
    ["Ash's Pikachu"] = {originalPosition = {x = 5515, y = 239, z = 6}, targetPosition = {x = 5523, y = 235, z = 6}},
    ["Ash's Charizard"] = {originalPosition = {x = 5518, y = 236, z = 6}, targetPosition = {x = 5522, y = 237, z = 6}},
    ["Ash's Muk"] = {originalPosition = {x = 5516, y = 237, z = 6}, targetPosition = {x = 5518, y = 237, z = 6}},
    ["Ash's Kingler"] = {originalPosition = {x = 5520, y = 237, z = 6}, targetPosition = {x = 5524, y = 237, z = 6}},
    ["Ash's Squirtle"] = {originalPosition = {x = 5519, y = 238, z = 6}, targetPosition = {x = 5521, y = 236, z = 6}},
    ["Ash's Bulbasaur"] = {originalPosition = {x = 5517, y = 238, z = 6}, targetPosition = {x = 5526, y = 235, z = 6}},

    ["Fergus's Vaporeon"] = {originalPosition = {x = 5515, y = 242, z = 6}, targetPosition = {x = 5524, y = 235, z = 6}},
    ["Fergus's Golduck"] = {originalPosition = {x = 5517, y = 242, z = 6}, targetPosition = {x = 5523, y = 236, z = 6}},
    ["Fergus's Gyarados"] = {originalPosition = {x = 5516, y = 243, z = 6}, targetPosition = {x = 5520, y = 237, z = 6}},
    ["Fergus's Nidoqueen"] = {originalPosition = {x = 5517, y = 245, z = 6}, targetPosition = {x = 5526, y = 237, z = 6}},
    ["Fergus's Seadra"] = {originalPosition = {x = 5514, y = 244, z = 6}, targetPosition = {x = 5519, y = 236, z = 6}},
    ["Fergus's Tentacruel"] = {originalPosition = {x = 5515, y = 245, z = 6}, targetPosition = {x = 5525, y = 237, z = 6}},

    ["Corey's Scyther"] = {originalPosition = {x = 5530, y = 237, z = 6}, targetPosition = {x = 5522, y = 235, z = 6}},
    ["Corey's Rhyhorn"] = {originalPosition = {x = 5525, y = 237, z = 6}, targetPosition = {x = 5523, y = 237, z = 6}},
    ["Corey's Hitmonlee"] = {originalPosition = {x = 5527, y = 237, z = 6}, targetPosition = {x = 5525, y = 236, z = 6}},
    ["Corey's Sandslash"] = {originalPosition = {x = 5528, y = 238, z = 6}, targetPosition = {x = 5526, y = 236, z = 6}},
    ["Corey's Venusaur"] = {originalPosition = {x = 5531, y = 238, z = 6}, targetPosition = {x = 5521, y = 237, z = 6}},
    ["Corey's Pidgeot"] = {originalPosition = {x = 5527, y = 235, z = 6}, targetPosition = {x = 5527, y = 235, z = 6}},

    ["Brock's Geodude"] = {originalPosition = {x = 5522, y = 246, z = 6}, targetPosition = {x = 5521, y = 235, z = 6}},
    ["Brock's Zubat"] = {originalPosition = {x = 5519, y = 246, z = 6}, targetPosition = {x = 5520, y = 236, z = 6}},
    ["Brock's Onix"] = {originalPosition = {x = 5520, y = 247, z = 6}, targetPosition = {x = 5527, y = 237, z = 6}},
    ["Brock's Pineco"] = {originalPosition = {x = 5522, y = 248, z = 6}, targetPosition = {x = 5522, y = 236, z = 6}},
    ["Brock's Sudowoodo"] = {originalPosition = {x = 5519, y = 249, z = 6}, targetPosition = {x = 5528, y = 236, z = 6}},

    ["Misty's Psyduck"] = {originalPosition = {x = 5528, y = 246, z = 6}, targetPosition = {x = 5525, y = 235, z = 6}},
    ["Misty's Poliwhirl"] = {originalPosition = {x = 5525, y = 247, z = 6}, targetPosition = {x = 5525, y = 247, z = 6}},
    ["Misty's Goldeen"] = {originalPosition = {x = 5525, y = 247, z = 6}, targetPosition = {x = 5527, y = 248, z = 6}},
    ["Misty's Starmie"] = {originalPosition = {x = 5525, y = 247, z = 6}, targetPosition = {x = 5519, y = 235, z = 6}},
    ["Misty's Staryu"] = {originalPosition = {x = 5525, y = 247, z = 6}, targetPosition = {x = 5518, y = 236, z = 6}},
    ["Misty's Togepi"] = {originalPosition = {x = 5529, y = 248, z = 6}, targetPosition = {x = 5522, y = 238, z = 6}},

    ["Neesha's Rapidash"] = {originalPosition = {x = 5529, y = 243, z = 6}, targetPosition = {x = 5520, y = 235, z = 6}},
    ["Neesha's Vileplume"] = {originalPosition = {x = 5531, y = 242, z = 6}, targetPosition = {x = 5519, y = 237, z = 6}},
    ["Neesha's Dewgong"] = {originalPosition = {x = 5531, y = 243, z = 6}, targetPosition = {x = 5529, y = 237, z = 6}},
    ["Neesha's Ninetales"] = {originalPosition = {x = 5530, y = 244, z = 6}, targetPosition = {x = 5528, y = 237, z = 6}},
    ["Neesha's Wigglytuff"] = {originalPosition = {x = 5530, y = 246, z = 6}, targetPosition = {x = 5525, y = 238, z = 6}},
    ["Neesha's Blastoise"] = {originalPosition = {x = 5532, y = 246, z = 6}, targetPosition = {x = 5517, y = 237, z = 6}},
  }

  -- First remove Pokemon
  for k, v in pairs(getSpectators({x = 5523, y = 243, z = 6}, 20, 20)) do
    if (isNpc(v)) then
      local name = getCreatureName(v)
      if (pokemon[name]) then
        doSendDistanceShoot({x = 5523, y = 231, z = 6}, getCreaturePosition(v), PROJECTILE_DARKBALL)
        doRemoveCreature(v)
        addEvent(function(name, pos) doCreateNpc(name, pos) end, 180 * 1000, name, pokemon[name].originalPosition)
      end
    end
  end

  -- Then throw the trainers away
  for k, v in pairs(getSpectators({x = 5523, y = 243, z = 6}, 20, 20)) do
    if (isNpc(v)) then
      local name = getCreatureName(v)
      if (trainers[name]) then
        local dest = trainers[name].originalPosition
        doTeleportThing(v, dest)
        doSendMagicEffect(dest, EFFECT_TELEPORT_DOWN)
      end
    end
  end

  return true
end

local npcBattle = NpcBattle:new(getNpcName(), 9307, 9707, npcHandler)
npcBattle:setPokemons({"Cloned Venusaur", "Cloned Blastoise", "Cloned Charizard"--[[, "Cloned Pidgeot"]]})
npcBattle:setRewardBaseExp(111)
npcBattle:setRewardRespect(1)
npcBattle:setDifficulty(100)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setOneWin(true)
npcBattle:setRequired(function(cid)
    -- todo
    return true
  end
)
npcBattle:setLossSpeech("I'm bored! What about your Pokemon, they are mine from now!")
npcBattle:setOnEnd(function(cid, playerWin, npc)
    if (playerWin) then
      doSendDistanceShoot(getCreaturePosition(npc), getCreaturePosition(cid), PROJECTILE_DARK_SHOT)

      local pokemon = getPlayerPokemon(cid)
      if (isCreature(pokemon)) then
        doCreatureDie(pokemon)
      end      

      --doCreatureSay(npc, "Well, well, these clone should be defective, I have to destroy them. What about your Pokemon, they are mine from now!", TALKTYPE_SAY)
      doSendMagicEffect(getCreaturePosition(npc), EFFECT_TELEPORT_FRAME)
      doRemoveCreature(npc)
      doMewtwoSavePlayerPokemon(cid)
    end
  end
)
--[[npcBattle:setOnDefeatNpcPokemon(function(cid, count)
    if (count >= 3) then
      
    end
  end
)]]


--
local MAIN12_FINAL_POSITION = {x = 5571, y = 222, z = 6}
local npcBattleFinal = NpcBattle:new(getNpcName(), 9308, 9708, npcHandler)
npcBattleFinal:setPokemons({"Venusaur", "Charizard", "Blastoise", "Butterfree", "Beedrill", "Pidgeot", "Raticate", "Fearow", "Arbok", "Raichu", "Sandslash", "Nidoqueen", "Nidoking", "Clefable", "Ninetales", "Wigglytuff", "Crobat", "Vileplume", "Parasect", "Venomoth", "Dugtrio", "Persian", "Golduck", "Primeape", "Arcanine", "Poliwrath", "Alakazam", "Machamp", "Victreebel", "Tentacruel", "Golem", "Rapidash", "Slowbro", "Magneton", "Farfetchd", "Dodrio", "Dewgong", "Muk", "Cloyster", "Gengar", "Steelix", "Hypno", "Kingler", "Electrode", "Exeggutor", "Marowak", "Hitmonlee", "Hitmonchan", "Lickitung", "Weezing", "Rhydon", "Blissey", "Tangela", "Kangaskhan", "Kingdra", "Seaking", "Starmie", "Mr. Mime", "Scizor", "Jynx", "Electabuzz", "Magmar", "Pinsir", "Tauros", "Gyarados", "Lapras", "Vaporeon", "Jolteon", "Flareon", "Porygon2", "Omastar", "Kabutops", "Aerodactyl", "Snorlax", "Dragonite", "Meganium", "Typhlosion", "Feraligatr", "Furret", "Noctowl", "Ledian", "Ariados", "Lanturn", "Togetic", "Xatu", "Ampharos", "Bellossom", "Azumarill", "Sudowoodo", "Politoed", "Jumpluff", "Aipom", "Sunflora", "Yanma", "Quagsire", "Espeon", "Umbreon", "Murkrow", "Slowking", "Misdreavus", "Girafarig", "Forretress", "Dunsparce", "Gligar", "Granbull", "Qwilfish", "Shuckle", "Heracross", "Sneasel", "Ursaring", "Magcargo", "Piloswine", "Corsola", "Octillery", "Mantine", "Skarmory", "Houndoom", "Donphan", "Stantler", "Hitmontop", "Miltank", "Tyranitar"})
npcBattleFinal:setRewardBaseExp(111)
npcBattleFinal:setRewardRespect(1)
npcBattleFinal:setDifficulty(100)
npcBattleFinal:setPokemonExtraStats(0.6)
npcBattleFinal:setPokemonDefeatExperienced(true)
npcBattleFinal:setOneWin(true)
npcBattleFinal:setRequired(function(cid)
    for v = 8659, 8664 do
      if (getCreatureStorage(cid, v) ~= QUEST_STATUS.FINISHED) then
        return false
      end
    end
    return getCreatureStorage(cid, 8555) == QUEST_STATUS.STARTED
  end
)

local BattleEffects = {}
BattleEffects.doFlashTeleport = function(mew, mewtwo)
  local positions = {
    {
      mew = {{x = 5565, y = 220, z = 6}, EAST},
      mewtwo = {{x = 5566, y = 220, z = 6}, WEST}
    },
    {
      mew = {{x = 5569, y = 224, z = 6}, NORTH},
      mewtwo = {{x = 5569, y = 223, z = 6}, SOUTH}
    },
    {
      mew = {{x = 5564, y = 229, z = 6}, WEST},
      mewtwo = {{x = 5563, y = 229, z = 6}, EAST}
    },
    {
      mew = {{x = 5574, y = 228, z = 6}, SOUTH},
      mewtwo = {{x = 5574, y = 229, z = 6}, NORTH}
    },
    {
      mew = {{x = 5578, y = 223, z = 6}, EAST},
      mewtwo = {{x = 5579, y = 223, z = 6}, WEST}
    },
    {
      mew = {{x = 5567, y = 225, z = 6}, NORTH},
      mewtwo = {{x = 5567, y = 224, z = 6}, SOUTH}
    },
    {
      mew = {{x = 5563, y = 228, z = 6}, WEST},
      mewtwo = {{x = 5562, y = 228, z = 6}, EAST}
    },
    {
      mew = {{x = 5573, y = 229, z = 6}, SOUTH},
      mewtwo = {{x = 5573, y = 230, z = 6}, NORTH}
    },
    {
      mew = {{x = 5571, y = 226, z = 6}, NORTH},
      mewtwo = {{x = 5571, y = 225, z = 6}, SOUTH}
    },
  }

  local rand = table.random(positions)  

  doSendMagicEffect(getCreaturePosition(mew),  EFFECT_TELEPORT_FRAME)
  doTeleportThing(mew, rand.mew[1])
  doSendMagicEffect(rand.mew[1],  EFFECT_TELEPORT_FRAME)
  doCreatureSetLookDirection(mew, rand.mew[2])

  doSendMagicEffect(getCreaturePosition(mewtwo),  EFFECT_TELEPORT_FRAME)
  doTeleportThing(mewtwo, rand.mewtwo[1])
  doSendMagicEffect(rand.mewtwo[1],  EFFECT_TELEPORT_FRAME)
  doCreatureSetLookDirection(mewtwo, rand.mewtwo[2])
end

BattleEffects.doExplosions = function(mew, mewtwo)
  local rand = {mew, mewtwo}
  local attacker, deffender = table.randomRemove(rand), table.randomRemove(rand)

  -- 40
  local actions = {
    {
      action = function()
        doSendMagicEffect(getCreaturePosition(attacker), EFFECT_PURPLE_CIRCLE)
        doSendMagicEffect(getCreaturePosition(deffender), EFFECT_PURPLE_CIRCLE)
      end,
      delay = 50,
      times = 10
    },
    {
      action = function()
        local targetPos = getPositionAdjacent(deffender, getCreaturePosition(deffender), false)
        doSendDistanceShoot(getCreaturePosition(attacker), targetPos, PROJECTILE_ENERGY)
        doSendMagicEffect(targetPos, EFFECT_EARTH_EXPLOSION)
      end,
      delay = 100,
      times = 5
    },
  }

  for k, v in pairs(actions) do
    for i = 0, v.times do
      addEvent(v.action, v.delay * i)
    end
  end
end

BattleEffects.doHealing = function(mew, mewtwo)
  local cid = table.randomRemove({mew, mewtwo})

  local actions = {
    {
      action = function()
        local pos = getCreaturePosition(cid)
        doSendDistanceShoot(getPositionRandomAdjacent(pos, 6), pos, table.random({PROJECTILE_FIRE, PROJECTILE_ENERGY, PROJECTILE_EARTH_SHOT, PROJECTILE_THUNDER, PROJECTILE_FIRE_BLUE, PROJECTILE_NIGHT_SHADE, PROJECTILE_RED_SHOT, PROJECTILE_RAIN, PROJECTILE_GREEN_SHOT, PROJECTILE_DARK_SHOT}))
        doSendMagicEffect(pos, EFFECT_GREEN_BUFF)
      end,
      delay = 75,
      times = 10
    },
  }

  for k, v in pairs(actions) do
    for i = 0, v.times do
      addEvent(v.action, v.delay * i)
    end
  end
end

BattleEffects.doFacing = function(mew, mewtwo)
  -- 40
  local actions = {
    {
      action = function()
        doSendMagicEffect(getCreaturePosition(mew), EFFECT_PURPLE_CIRCLE)
        doSendMagicEffect(getCreaturePosition(mewtwo), EFFECT_PURPLE_CIRCLE)
      end,
      delay = 50,
      times = 10
    },
  }

  for k, v in pairs(actions) do
    for i = 0, v.times do
      addEvent(v.action, v.delay * i)
    end
  end
end

BattleEffects.doAttacking = function(mew, mewtwo)
  local rand = {mew, mewtwo}
  local attacker, deffender = table.randomRemove(rand), table.randomRemove(rand)

  local attackerPos = getCreaturePosition(attacker)
  local deffenderPos = getCreaturePosition(deffender)

  doSendDistanceShoot(attackerPos, deffenderPos, table.random({PROJECTILE_FIRE, PROJECTILE_ENERGY, PROJECTILE_EARTH_SHOT, PROJECTILE_THUNDER, PROJECTILE_FIRE_BLUE, PROJECTILE_NIGHT_SHADE, PROJECTILE_RED_SHOT, PROJECTILE_RAIN, PROJECTILE_GREEN_SHOT, PROJECTILE_DARK_SHOT}))
  doSendMagicEffect(deffenderPos, table.random({EFFECT_EARTH_EXPLOSION, EFFECT_WATER_EXPLOSION, EFFECT_ELECTRIC_CLOUD, EFFECT_BIG_EXPLOSION, EFFECT_ROCK_EMERGE, EFFECT_POISON_SPLASH, EFFECT_BIG_ENIGMA_BALL, EFFECT_BIG_ELECTRIC_BALL, EFFECT_DARK_PULSE, EFFECT_BIG_FLAMES, EFFECT_PURPLE_ELECTRIC_CLOUD}))
end

BattleEffects.doEnergizedBallHits = function(mew, mewtwo)
  local rand = {mew, mewtwo}
  local attacker, deffender = table.randomRemove(rand), table.randomRemove(rand)

  for i = 1, 10 do
    addEvent(function()
        local attackerPos = getCreaturePosition(attacker)
        local deffenderPos = getCreaturePosition(deffender)
        doSendDistanceShoot(attackerPos, deffenderPos, table.random({PROJECTILE_FIRE, PROJECTILE_ENERGY, PROJECTILE_EARTH_SHOT, PROJECTILE_THUNDER, PROJECTILE_FIRE_BLUE, PROJECTILE_NIGHT_SHADE, PROJECTILE_RED_SHOT, PROJECTILE_RAIN, PROJECTILE_GREEN_SHOT, PROJECTILE_DARK_SHOT}))
        doSendMagicEffect(deffenderPos, table.random({EFFECT_EARTH_EXPLOSION, EFFECT_WATER_EXPLOSION, EFFECT_ELECTRIC_CLOUD, EFFECT_BIG_EXPLOSION, EFFECT_ROCK_EMERGE, EFFECT_POISON_SPLASH, EFFECT_BIG_ENIGMA_BALL, EFFECT_BIG_ELECTRIC_BALL, EFFECT_DARK_PULSE, EFFECT_BIG_FLAMES, EFFECT_PURPLE_ELECTRIC_CLOUD}))
      end, i * 50)
  end
end

BattleEffects.doResetPositions = function(mew, mewtwo)
  local mewPos = {x = 5571, y = 226, z = 6}
  doTeleportThing(mew, mewPos)
  doSendMagicEffect(mewPos, EFFECT_TELEPORT_FRAME)
  doCreatureSetLookDirection(mew, NORTH)

  local mewtwoPos = {x = 5571, y = 222, z = 6}
  doTeleportThing(mewtwo, mewtwoPos)
  doSendMagicEffect(mewtwoPos, EFFECT_TELEPORT_FRAME)
  doCreatureSetLookDirection(mewtwo, SOUTH)
end

BattleEffects.doDistanceFacing = function(mew, mewtwo)
  local mewPos = {x = 5567, y = 226, z = 6}
  doTeleportThing(mew, mewPos)
  doSendMagicEffect(mewPos, EFFECT_TELEPORT_FRAME)
  doCreatureSetLookDirection(mew, EAST)

  local mewtwoPos = {x = 5575, y = 226, z = 6}
  doTeleportThing(mewtwo, mewtwoPos)
  doSendMagicEffect(mewtwoPos, EFFECT_TELEPORT_FRAME)
  doCreatureSetLookDirection(mewtwo, WEST)

  local beams = {"Ice Beam", "Solar Beam", "Aurora Beam", "Charge Beam", "Hyper Beam", "Signal Beam"}
  doCreatureCastSpell(mew, SKILL_FUNCTION_PREFIX .. table.random(beams))
  doCreatureCastSpell(mewtwo, SKILL_FUNCTION_PREFIX .. table.random(beams))

  local pos = {x = 5571, y = 226, z = 6}
  local spec = getSpectators(pos, 1, 1)
  if (spec) then
    for k,v in pairs(spec) do
      if (isPlayer(v) and not getPlayerMounted(v) and not isBiking(v)) then        
        doSendMagicEffect(pos, EFFECT_FREEZE)
        doAddCondition(v, MEWTWO_FREEZE_OUTFIT)
        doPlayerAchievementCheck(v, ACHIEVEMENT_IDS.MEWTWO_FINAL_FREEZE)
      end
    end
  end
end

BattleEffects.WORKING = false

BattleEffects.doWork = function(mew, mewtwo)
  if (BattleEffects.WORKING) then
    return
  end

  BattleEffects.WORKING = true

  local actions = {BattleEffects.doFlashTeleport, BattleEffects.doExplosions, BattleEffects.doHealing, BattleEffects.doFacing, BattleEffects.doAttacking, BattleEffects.doEnergizedBallHits, BattleEffects.doDistanceFacing}

  for i = 1, 290 do
    addEvent(table.random(actions), i * 200, mew, mewtwo)
  end

  --[[for i = 0, 30 do
    addEvent(BattleEffects.doFlashTeleport, i * 200, mew, mewtwo)
  end
  
  for i = 0, 30 do
    addEvent(BattleEffects.doExplosions, (i * 250) + 5000, mew, mewtwo)
  end
  
  for i = 0, 10 do
    addEvent(BattleEffects.doHealing, (i * 200) + 10000, mew, mewtwo)
  end
  
  for i = 0, 5 do
    addEvent(BattleEffects.doFacing, (i * 200) + 20000, mew, mewtwo)
  end
  
  for i = 0, 5 do
    addEvent(BattleEffects.doAttacking, (i * 300) + 25000, mew, mewtwo)
  end
  
  for i = 0, 5 do
    addEvent(BattleEffects.doFollowing, (i * 200) + 35000, mew, mewtwo)
  end
  
  for i = 0, 5 do
    addEvent(BattleEffects.doEnergizedBallHits, (i * 400) + 45000, mew, mewtwo)
  end]]

addEvent(function() doCreatureSay(mew, "Mew... Mew, Mew...", TALKTYPE_SAY) end, 2000)
addEvent(function() doCreatureSay(mew, "Mew!", TALKTYPE_SAY) end, 5000)
addEvent(function() doCreatureSay(mew, "Mew! Mew!", TALKTYPE_SAY) end, 10000)
addEvent(function() doCreatureSay(mew, "Mew...", TALKTYPE_SAY) end, 18000)
addEvent(function() doCreatureSay(mew, "Mew... Mew... Mew...", TALKTYPE_SAY) end, 24000)

addEvent(function() doCreatureSay(mewtwo, "Come on!", TALKTYPE_SAY) end, 2000)
addEvent(function() doCreatureSay(mewtwo, "Grrrr", TALKTYPE_SAY) end, 6000)
addEvent(function() doCreatureSay(mewtwo, "Take this!", TALKTYPE_SAY) end, 11000)
addEvent(function() doCreatureSay(mewtwo, "You can't.", TALKTYPE_SAY) end, 16000)
addEvent(function() doCreatureSay(mewtwo, "...", TALKTYPE_SAY) end, 23000)

--addEvent(function() BattleEffects.doResetPositions(mew, mewtwo) end, 77 * 1000)

addEvent(function() BattleEffects.WORKING = false end, 70 * 1000)
end

npcBattleFinal:setOnEnd(function(cid, playerWin, npc)
    if (playerWin) then      
      local mewId = nil

      local actions = {
        {
          action = function() doCreatureSay(npc, "Impossible... My Pokemon are superior, I am superior!", TALKTYPE_SAY) end,
          delay = 0
        },
        {
          action = function()
            local npcPos = {x = 5571, y = 226, z = 6}
            mewId = doCreateNpc("Mew", npcPos)
            doCreatureSetLookDirection(mewId, NORTH)
            doCreatureSetLookDirection(npc, SOUTH)
            doSendMagicEffect(npcPos, EFFECT_TELEPORT_FRAME)
          end,
          delay = 4000
        },
        {
          action = function() doCreatureSay(npc, "Mew... Finally we meet, so you have come to witness the birth of a new era? I may have been cloned from you, but I will prove to you that Mewtwo is better than Mew.", TALKTYPE_SAY) end,
          delay = 8000
        },
        {
          action = function() doCreatureSay(mewId, "Mew... Mew, Mew...", TALKTYPE_SAY) end,
          delay = 12000
        },
        {
          action = function() doCreatureSay(npc, "How can you insinuate that my clones are weak because they have no heart?", TALKTYPE_SAY) end,
          delay = 16000
        },
        {
          action = function()
            BattleEffects.doWork(mewId, npc)
          end,
          delay = 20000
        },
        {
          action = function()
            doSendMagicEffect(getCreaturePosition(npc), EFFECT_DARK_ENERGY_TWO)
            doCreateItem(25197, 1, getCreaturePosition(npc))
            doRemoveCreature(npc)
            doSendMagicEffect(getCreaturePosition(mewId), EFFECT_TELEPORT_FRAME)
            doRemoveCreature(mewId)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Use the master ball now!")
            -- todo Quando o Mewtwo cair o quest log do jogador será atualizado: É agora, eu tenho que usar o protótipo da Master Ball no Mewtwo.
          end,
          delay = 80000
        },
      }

      for k, v in pairs(actions) do
        addEvent(v.action, v.delay)
      end
    end
  end
)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
  if(not npcHandler:isFocused(cid)) then
    return false
  end

  local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

  if (getSamePosition(getNpcPos(), MAIN12_FINAL_POSITION)) then
    if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
      talkState[talkUser] =  npcBattleFinal:doTalkStart(getNpcId(), cid)

    elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
      talkState[talkUser] =  npcBattleFinal:doTalkEnd(getNpcId(), cid, talkState[talkUser])

    else
      selfSay("Ok..", cid)
    end

    return true
  end

  if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
    talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

  elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
    talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

  else
    selfSay("Ok..", cid)
  end
  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

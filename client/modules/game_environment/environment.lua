-- Constants
local SOUND_FILES_FOLDER = "/sounds/environment/"
local SOUND_CHANNEL = SoundChannels.Ambient
local SOUND_FADE_DURATION = 1.5

local EFFECT_FILES_FOLDER = "/shaders/environment/"

local MESSAGE_LABEL_FADE_DURATION = 1500
local MESSAGE_LABEL_DURATION = 7000

local SHADER_FADE = 0.5

local DATA_INDEX = {}
DATA_INDEX.X = 1
DATA_INDEX.Y = 2
DATA_INDEX.Z = 3
DATA_INDEX.RADIUS = 4
DATA_INDEX.NAME = 5
DATA_INDEX.PRIORITY = 6
DATA_INDEX.TYPE = 7
DATA_INDEX.MESSAGE = 8

local DATA_TYPES = {}
DATA_TYPES.SOUND = 0
DATA_TYPES.EFFECT = 1

-- Files
-- Sounds
local SOUND_FILES = {}
SOUND_FILES["pvp_center_01"] = "pvp_center_01"
SOUND_FILES["lava_01"] = "lava_01"
SOUND_FILES["forest_02"] = "forest_02"
SOUND_FILES["forest_01"] = "forest_01"
SOUND_FILES["cave_01"] = "cave_01"
SOUND_FILES["cave_02"] = "cave_02"
SOUND_FILES["cave_03"] = "cave_03"
SOUND_FILES["cave_04"] = "cave_04"
SOUND_FILES["cave_05"] = "cave_05"
SOUND_FILES["battle_01"] = "battle_01"
SOUND_FILES["battle_02"] = "battle_02"
SOUND_FILES["battle_03"] = "battle_03"
SOUND_FILES["battle_04"] = "battle_04"
SOUND_FILES["battle_05"] = "battle_05"
SOUND_FILES["battle_06"] = "battle_06"
SOUND_FILES["battle_07"] = "battle_07"
SOUND_FILES["battle_08"] = "battle_08"
SOUND_FILES["battle_09"] = "battle_09"
SOUND_FILES["battle_10"] = "battle_10"
SOUND_FILES["random_battle_01_05"] = {"battle_01", "battle_02", "battle_03", "battle_04", "battle_05"}
SOUND_FILES["random_battle_06_10"] = {"battle_06", "battle_07", "battle_08", "battle_09", "battle_10"}
SOUND_FILES["city_01"] = "city_01"
SOUND_FILES["city_02"] = "city_02"
SOUND_FILES["city_03"] = "city_03"
SOUND_FILES["city_04"] = "city_04"
SOUND_FILES["city_05"] = "city_05"
SOUND_FILES["city_06"] = "city_06"
SOUND_FILES["city_07"] = "city_07"
SOUND_FILES["city_08"] = "city_08"
SOUND_FILES["city_09"] = "city_09"
SOUND_FILES["city_10"] = "city_10"
SOUND_FILES["city_11"] = "city_11"
SOUND_FILES["city_12"] = "city_12"
SOUND_FILES["city_13"] = "city_13"
SOUND_FILES["city_14"] = "city_14"
SOUND_FILES["city_15"] = "city_15"
SOUND_FILES["city_16"] = "city_16"
SOUND_FILES["city_17"] = "city_17"
SOUND_FILES["city_18"] = "city_18"
SOUND_FILES["city_19"] = "city_19"
SOUND_FILES["city_20"] = "city_20"
SOUND_FILES["city_21"] = "city_21"
SOUND_FILES["city_22"] = "city_22"
SOUND_FILES["city_23"] = "city_23"
SOUND_FILES["city_24"] = "city_24"
SOUND_FILES["city_25"] = "city_25"
SOUND_FILES["city_26"] = "city_26"
SOUND_FILES["city_27"] = "city_27"
SOUND_FILES["random_city_01_05"] = {"city_01", "city_02", "city_03", "city_04", "city_05"}
SOUND_FILES["random_city_05_10"] = {"city_06", "city_07", "city_08", "city_09", "city_10"}
SOUND_FILES["random_city_11_15"] = {"city_11", "city_12", "city_13", "city_14", "city_15"}
SOUND_FILES["random_city_16_20"] = {"city_16", "city_17", "city_18", "city_19", "city_20"}
SOUND_FILES["random_city_21_27"] = {"city_21", "city_22", "city_23", "city_24", "city_25", "city_26", "city_27"}
SOUND_FILES["danger_01"] = "danger_01"
SOUND_FILES["danger_02"] = "danger_02"
SOUND_FILES["danger_03"] = "danger_03"
SOUND_FILES["danger_04"] = "danger_04"
SOUND_FILES["danger_05"] = "danger_05"
SOUND_FILES["fire_01"] = "fire_01"
SOUND_FILES["jigglypuff_01"] = "jigglypuff_01"
SOUND_FILES["jungle_01"] = "jungle_01"
SOUND_FILES["jungle_02"] = "jungle_02"
SOUND_FILES["pokemon_center_01"] = "pokemon_center_01"
SOUND_FILES["pokemon_center_02"] = "pokemon_center_02"
SOUND_FILES["quest_01"] = "quest_01"
SOUND_FILES["quest_02"] = "quest_02"
SOUND_FILES["quest_03"] = "quest_03"
SOUND_FILES["rain_01"] = "rain_01"
SOUND_FILES["swamp_01"] = "swamp_01"
SOUND_FILES["swamp_02"] = "swamp_02"
SOUND_FILES["swamp_03"] = "swamp_03"
SOUND_FILES["team_rocket_01"] = "team_rocket_01"
SOUND_FILES["team_rocket_02"] = "team_rocket_02"
SOUND_FILES["team_rocket_03"] = "team_rocket_03"
SOUND_FILES["terror_01"] = "terror_01"
SOUND_FILES["terror_02"] = "terror_02"
SOUND_FILES["thunder_low_01"] = "thunder_low_01"
SOUND_FILES["underwater_01"] = "underwater_01"
SOUND_FILES["victory_01"] = "victory_01"
SOUND_FILES["water_01"] = "water_01"
SOUND_FILES["water_02"] = "water_02"
SOUND_FILES["water_03"] = "water_03"
SOUND_FILES["waterfall_01"] = "waterfall_01"
SOUND_FILES["wind_high_01"] = "wind_high_01"
SOUND_FILES["wind_low_01"] = "wind_low_01"

for k, file in pairs(SOUND_FILES) do
    if (isTable(file)) then
        for kChild, fileChild in pairs(file) do
            SOUND_FILES[k][kChild] = SOUND_FILES_FOLDER .. fileChild
        end

    else
        SOUND_FILES[k] = SOUND_FILES_FOLDER .. file
    end
end

-- Effects
local EFFECT_FILES = {}
EFFECT_FILES["Zomg"] = {frag = "zomg.frag", textures = {}}
EFFECT_FILES["Wind"] = {frag = "wind.frag", textures = {"wind"}}
EFFECT_FILES["Underwater"] = {frag = "underwater.frag", textures = {"bubbles"}}
EFFECT_FILES["Soil"] = {frag = "soil.frag", textures = {"clouds"}}
EFFECT_FILES["Snow"] = {frag = "snow.frag", textures = {"snow", "clouds"}}
EFFECT_FILES["Sepia"] = {frag = "sepia.frag", textures = {}}
EFFECT_FILES["Rain"] = {frag = "rain.frag", textures = {"rain"}}
EFFECT_FILES["Radialblur"] = {frag = "radialblur.frag", textures = {}}
EFFECT_FILES["Pyramid"] = {frag = "pyramid.frag", textures = {}}
EFFECT_FILES["Pulse"] = {frag = "pulse.frag", textures = {}}
EFFECT_FILES["Party"] = {frag = "party.frag", textures = {}}
EFFECT_FILES["Oldtv"] = {frag = "oldtv.frag", textures = {}}
EFFECT_FILES["Noise"] = {frag = "noise.frag", textures = {}}
EFFECT_FILES["Jungle"] = {frag = "jungle.frag", textures = {}}
EFFECT_FILES["Grayscale"] = {frag = "grayscale.frag", textures = {}}
EFFECT_FILES["Fog"] = {frag = "fog.frag", textures = {"clouds"}}
EFFECT_FILES["Fire"] = {frag = "fire.frag", textures = {}}
EFFECT_FILES["Dream"] = {frag = "dream.frag", textures = {}}
EFFECT_FILES["Desert"] = {frag = "desert.frag", textures = {"clouds"}}
EFFECT_FILES["Cave"] = {frag = "cave.frag", textures = {}}
EFFECT_FILES["Heat"] = {frag = "heat.frag", textures = {}}

for k, file in pairs(EFFECT_FILES) do
    file.frag = EFFECT_FILES_FOLDER .. file.frag
    for textureK, tmpTexture in pairs(file.textures) do
        file.textures[textureK] = EFFECT_FILES_FOLDER .. tmpTexture
    end
    file.name = k
end

-- Load Config
--dofile("data.lua")

dofile("sounds1.lua")
dofile("sounds2.lua")

local SOUNDS = {}
table.merge(SOUNDS, SOUNDS1)
table.merge(SOUNDS, SOUNDS2)

--local SOUNDS = loadstring("/modules/game_environment/new_sounds.lua")()--table.load("/modules/game_environment/sounds.lua")
local EFFECTS = table.load("/modules/game_environment/effects.lua")

-- Vars
local rcSoundChannel, playingSound, playingEffect, effectsEnabled, labelWindow, labelEvent, locationLabel
local environmentEnabled = true

-- Methods
local isInPos = Position.isIn

local function checkMessage(data)
    if (data[DATA_INDEX.MESSAGE]) then
        if (labelEvent) then
            removeEvent(labelEvent)
        end

        local text = tr(data[DATA_INDEX.MESSAGE])
        labelWindow:recursiveGetChildById('message'):setText(text)
        addEvent(function()
            labelWindow:show()
            g_effects.fadeIn(labelWindow, MESSAGE_LABEL_FADE_DURATION)
        end)

        labelEvent = scheduleEvent(function()
            g_effects.fadeOut(labelWindow, MESSAGE_LABEL_FADE_DURATION)
            labelEvent = scheduleEvent(function()
                labelWindow:hide()
            end, MESSAGE_LABEL_FADE_DURATION + 1)
        end, MESSAGE_LABEL_DURATION)

        modules.game_time.setLocation(text)
    end
end

local function stopSound()
    rcSoundChannel:stop(SOUND_FADE_DURATION)
    playingSound = nil
end

local function playSound(sound)
    if (playingSound ~= sound) then
        stopSound()
        playingSound = sound

        local file = SOUND_FILES[sound[DATA_INDEX.NAME]]
        if (isTable(file)) then
            for k, v in pairs(file) do
                rcSoundChannel:enqueue(v, SOUND_FADE_DURATION)
            end

        else
            rcSoundChannel:enqueue(file, SOUND_FADE_DURATION)
        end
    end
end

local function playEffect(effect)
    if (playingEffect ~= effect) then
        local map = modules.game_interface.getMapPanel()
        map:setMapShader(g_shaders.getShader(effect[DATA_INDEX.NAME]), SHADER_FADE, SHADER_FADE)
        playingEffect = effect
    end
end

local function resetEffect()
    local map = modules.game_interface.getMapPanel()
    map:setMapShader(nil, SHADER_FADE, SHADER_FADE)
    playingEffect = nil
end

local function checkSound(newPos)
    local checkList, stop
    if (playingSound and isInPos(newPos, playingSound.fromPos, playingSound.toPos)) then
        if (playingSound.closePriorities) then
            checkList = playingSound.closePriorities
        else
            return
        end

    else
        stop = true
        checkList = SOUNDS
    end

    for i = 1, #checkList do
        local sound = checkList[i]
        if (isInPos(newPos, sound.fromPos, sound.toPos)) then
            if (not playingSound or sound[DATA_INDEX.NAME] ~= playingSound[DATA_INDEX.NAME]) then
                playSound(sound)
                checkMessage(sound)

            elseif (sound[DATA_INDEX.MESSAGE] ~= playingSound[DATA_INDEX.MESSAGE]) then
                checkMessage(sound)
            end

            playingSound = sound
            return
        end
    end

    if (stop) then
        stopSound() -- There is no sound to play here
    end
end

local function checkEffect(newPos)
    local checkList, stop
    if (playingEffect and isInPos(newPos, playingEffect.fromPos, playingEffect.toPos)) then
        if (playingEffect.closePriorities) then
            checkList = playingEffect.closePriorities
        else
            return
        end

    else
        stop = true
        checkList = EFFECTS
    end

    for i = 1, #checkList do
        local effect = checkList[i]
        if (isInPos(newPos, effect.fromPos, effect.toPos)) then
            if (not playingEffect or effect[DATA_INDEX.NAME] ~= playingEffect[DATA_INDEX.NAME]) then
                playEffect(effect)
                checkMessage(effect)

            elseif (effect[DATA_INDEX.MESSAGE] ~= playingEffect[DATA_INDEX.MESSAGE]) then
                checkMessage(effect)
            end

            playingEffect = effect
            return
        end
    end

    if (stop) then
        resetEffect()
    end
end

function setDisplay(v)
    environmentEnabled = v
    if (environmentEnabled) then
        if (g_game.isOnline()) then
            onPositionChange(cid, g_game.getLocalPlayer():getPosition(), nil)
        end

    else
        stopSound()
        resetEffect()
    end
end

-- Hooks
function onOnline()
    stopSound()
end

function onOffline()
    stopSound()
    resetEffect()
    labelWindow:hide()
end

function onPositionChange(cid, newPos, oldPos)
    if (not environmentEnabled) then
        return
    end

    checkSound(newPos)

    if (effectsEnabled) then
        checkEffect(newPos)
    end
end

function onInit()
    rcSoundChannel = g_sounds.getChannel(SOUND_CHANNEL)

    if (g_graphics.canUseShaders()) then
        for k, v in pairs(EFFECT_FILES) do
            local shader = g_shaders.createMapShader(k, v.frag)

            if (shader) then
                for _, texture in pairs(v.textures) do
                    shader:addMultiTexture(texture)
                end
            end
        end
        effectsEnabled = true

    else
        effectsEnabled = false
    end

    labelWindow = g_ui.loadUI('environment', modules.game_interface.getRootPanel())
    labelWindow:hide()

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    connect(LocalPlayer, {
        onPositionChange = onPositionChange
    })

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    disconnect(LocalPlayer, {
        onPositionChange = onPositionChange
    })

    labelWindow:destroy()
end
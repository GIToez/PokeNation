local ITEM_STATUS = {}
ITEM_STATUS.UNKNOWN = 0
ITEM_STATUS.DEXED = 1
ITEM_STATUS.CATCHED = 2
ITEM_STATUS.SHINYCATCHED = 3
ITEM_STATUS.DEXED_CATCHED = 4
ITEM_STATUS.DEXED_SHINYCATCHED = 5
ITEM_STATUS.DEXED_CATCHED_SHINYCATCHED = 6
ITEM_STATUS.CATCHED_SHINYCATCHED = 7

local ITEMID_BY_STATUS = {}
ITEMID_BY_STATUS[ITEM_STATUS.CATCHED] = 12854
ITEMID_BY_STATUS[ITEM_STATUS.DEXED_CATCHED] = 12854

ITEMID_BY_STATUS[ITEM_STATUS.DEXED_SHINYCATCHED] = 12855
ITEMID_BY_STATUS[ITEM_STATUS.SHINYCATCHED] = 12855

ITEMID_BY_STATUS[ITEM_STATUS.DEXED_CATCHED_SHINYCATCHED] = 12856
ITEMID_BY_STATUS[ITEM_STATUS.CATCHED_SHINYCATCHED] = 12856

local UNKNOWN_ITEMID = 16410

local SOUND_FILES_FOLDER = "/sounds/cries/"
local SOUND_CHANNEL = SoundChannels.Effect
local SOUND_FADE_DURATION = 0

pokedexWindow = nil
panel = nil
local optionsTabBar, detailsPanel, movesPanel, effectivenessPanel, pokePicture, pokeName, pokeId,
    lastSelectedItem, type1, type2, rcSoundChannel, playingSound, family

local itemStatus = {}
--

local function hide()
    pokedexWindow:hide()
end

local function show()
    pokedexWindow:show()
end

local function reset()
    panel:destroyChildren()
    itemStatus = {}
end

local function updateItem(item, status)
    local id = tonumber(item:getId())

    local itemId = 0
    if (id <= 151) then
        itemId = 11873 + id
    elseif (id <= 251) then
        itemId = (15798 - 151) + id
    else
        itemId = (27108 - 251) + id
    end

    item:setItemId(((status ~= ITEM_STATUS.UNKNOWN and status ~= ITEM_STATUS.CATCHED and
            status ~= ITEM_STATUS.SHINYCATCHED and status ~= ITEM_STATUS.CATCHED_SHINYCATCHED) and
            itemId) or UNKNOWN_ITEMID)

    if (status ~= ITEM_STATUS.UNKNOWN) then
        item.onMouseRelease = function(self, mousePosition, mouseButton)
            g_game.talkChannel(MessageModes.Say, 0 , '/dv ' .. id)
            return true
        end

    else
        item.onMouseRelease = function(self, mousePosition, mouseButton)
            onPokedexInfoUnknown()
            return true
        end
    end

    id = item:getId()
    if (itemStatus[id]) then
        item:destroyChildren() --itemStatus[id]:destroy()
        itemStatus[id] = nil
    end

    local statusItem
    if (ITEMID_BY_STATUS[status]) then
        statusItem = g_ui.createWidget('DexStatusItem', item)
        statusItem:setItemId(ITEMID_BY_STATUS[status])
        statusItem:fill('parent')
    end

    itemStatus[id] = statusItem
end

--

function onPokedexUpdate(pokemonNumber, status)
    for k, v in pairs(panel:getChildren()) do
        if (tonumber(v:getId()) == pokemonNumber) then
            updateItem(v, status)
            break
        end
    end
end

function onPokedexStatus(status)
    for k, v in pairs(status) do
        local item = g_ui.createWidget('Item', panel)
        item:setId(k)
        item:setMargin(0)
        item:setVirtual(true)

        updateItem(item, v)
    end

    if (#status <= 151) then
        pokedexWindow:getChildById('dexItem'):setItemId(11242)
    else
        pokedexWindow:getChildById('dexItem'):setItemId(16808)
    end
end

local function extractTypes(msg)
    msg = string.stripAccents(msg)
    local type1, type2 = string.match(msg, tr("Type: (%%a+) and (%%a+)"))
    if (not type1) then -- Unique type pokemon
        type1 = string.match(msg, tr("Type: (%%a+)"))
    end

    return type1, type2
end

local function stopSound()
    rcSoundChannel:stop(SOUND_FADE_DURATION)
    playingSound = nil
end

local function playSound(sound)
    stopSound()
    rcSoundChannel:play(sound, SOUND_FADE_DURATION, g_sounds.getChannel(SOUND_CHANNEL):getGain())
    playingSound = sound
end

local function updateMovesSection(moves)
    local movesContent = movesPanel:recursiveGetChildById('content')
    movesContent:destroyChildren()

    local section = g_ui.createWidget('PokedexMoveSection', movesContent)
    section:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    section:addAnchor(AnchorRight, 'parent', AnchorRight)
    section:addAnchor(AnchorTop, 'parent', AnchorTop)
    section:setBorderColor('#c2c2c2cc')
    section:setBackgroundColor('#898989cc')

    local categories = {
        {name = '#', first = true, width = 32},
        {name = 'Type', width = 32},
        {name = 'Name', width = 120},
        {name = 'Ctgry', width = 32},
        {name = 'Pwr', width = 42},
        {name = 'Energy', width = 42},
        {name = 'Level', width = 42},
        {name = 'Cdwn', width = 42},
        {name = 'Range', last = true, width = 42},
    }

    for _, category in pairs(categories) do
        local widget = g_ui.createWidget('UIWidget', section)

        if (not category.first) then
            widget:addAnchor(AnchorLeft, 'prev', AnchorRight)
        else
            widget:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        end

        if (category.last) then
            widget:addAnchor(AnchorRight, 'parent', AnchorRight)
        else
            widget:setWidth(category.width)
        end

        widget:addAnchor(AnchorTop, 'parent', AnchorTop)
        widget:addAnchor(AnchorBottom, 'parent', AnchorBottom)
        widget:setText(category.name)
    end

    moves = moves:split(";")

    for __, moveInfos in pairs(moves) do
        local moveLine = g_ui.createWidget('PokedexMoveSection', movesContent)
        moveLine:addAnchor(AnchorTop, 'prev', AnchorBottom)
        moveLine:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        moveLine:addAnchor(AnchorRight, 'parent', AnchorRight)
        moveLine:setHeight(32)

        for j, info in pairs(moveInfos:split(",")) do
            local widget = g_ui.createWidget('UIWidget', moveLine)

            if (j ~= 1) then
                widget:addAnchor(AnchorLeft, 'prev', AnchorRight)
            else
                widget:addAnchor(AnchorLeft, 'parent', AnchorLeft)
            end

            if (j == #moveInfos) then
                widget:addAnchor(AnchorRight, 'parent', AnchorRight)
            else
                widget:setWidth(categories[j].width)
            end

            widget:addAnchor(AnchorTop, 'parent', AnchorTop)
            widget:addAnchor(AnchorBottom, 'parent', AnchorBottom)

            if (j == 2) then -- Type
                widget:setImageSource("/images/types/" .. info)
                widget:setTooltip(getTypeNameById(info))
            elseif (j == 3) then -- Name
                widget:setText(info)
                widget:setTooltip(getMoveDescriptionByName(info))
            elseif (j == 4) then -- Category
                widget:setImageSource("/images/moveCategories/" .. info)
                widget:setTooltip(getMoveCategoryNameById(info))
            else
                widget:setText(info)
            end
        end
    end
end

function onPokedexInfo(pokemonId, details, moves, effectiveness, families)
    pokePicture:setImageSource("/images/pictures/" .. pokemonId)
    pokeName:setText(getPokemonNameByNumber(pokemonId))
    pokeId:setText(string.format("#%03d", pokemonId))

    local type1Name, type2Name = extractTypes(details)
    if (type1Name) then
        type1:setImageSource("/images/types/" .. getTypeIdByName(type1Name))
        type1:setTooltip(type1Name)
    else
        type1:setImageSource("")
        type1:setTooltip("")
    end

    if (type2Name) then
        type2:setImageSource("/images/types/" .. getTypeIdByName(type2Name))
        type2:setTooltip(type2Name)
    else
        type2:setImageSource("")
        type2:setTooltip("")
    end

    family:destroyChildren()
    families = families:split(",") or families
    for k, v in pairs(families) do
        local widget = g_ui.createWidget('UIWidget', family)
        widget:setImageSource("/images/pokeicons/" .. string.format("%03d", v))
        widget:setBorderWidth(1)
        widget:setBorderColor('#5b5b5bcc')
        widget:setBackgroundColor('#4b4b4bcc')
        widget:setTooltip(getPokemonNameByNumber(v))
        widget.onMouseRelease = function(self, mousePosition, mouseButton)
            g_game.talkChannel(MessageModes.Say, 0 , '/dv ' .. v)
            return true
        end
    end

    local text = detailsPanel:recursiveGetChildById('aaaText')
    if (text) then
        text:setText(details)
    end
    text = nil

    --[[text = movesPanel:recursiveGetChildById('aaaText')
    if (text) then
        text:setText(moves)
    end
    text = nil]]
    updateMovesSection(moves)

    --[[
    text = effectivenessPanel:recursiveGetChildById('aaaText')
    if (text) then
        text:setText(effectiveness)
    end
    text = nil

    text = effectivenessPanel:recursiveGetChildById('aaaText')
    if (text) then
        text:setText(effectiveness)
    end
    text = nil
    ]]
    local content = effectivenessPanel:recursiveGetChildById('content')
    content:destroyChildren()
    effectiveness = effectiveness:explode(";")

    local first = true
    for k, sectionName in pairs({'Normal', 'Immune', 'Resistant', 'Weak'}) do
        local section = g_ui.createWidget('PokedexEffectSection', content)
        section:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        section:addAnchor(AnchorRight, 'parent', AnchorRight)
        if (first) then
            section:addAnchor(AnchorTop, 'parent', AnchorTop)
            first = nil
        else
            section:addAnchor(AnchorTop, 'prev', AnchorBottom)
        end

        local header = g_ui.createWidget('UIWidget', section)
        header:setWidth(80)
        header:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        header:addAnchor(AnchorTop, 'parent', AnchorTop)
        header:addAnchor(AnchorBottom, 'parent', AnchorBottom)
        header:setText(sectionName)

        local typeBox = g_ui.createWidget('PokedexTypeBox', section)
        typeBox:addAnchor(AnchorLeft, 'prev', AnchorRight)
        typeBox:addAnchor(AnchorRight, 'parent', AnchorRight)
        typeBox:addAnchor(AnchorTop, 'parent', AnchorTop)
        typeBox:addAnchor(AnchorBottom, 'parent', AnchorBottom)

        if (effectiveness[k] and effectiveness[k] ~= "") then
            local types = effectiveness[k]:split(",")
            for _, type in pairs(types) do
                local widget = g_ui.createWidget('UIWidget', typeBox)
                widget:setImageSource("/images/types/square/" .. type)
            end
            section:setHeight(4 + (math.ceil(#types / 6) * 22)) -- (margin + padding) + #types/5 per line * image height
        else
            section:setHeight(24)
        end
    end
    content = nil

    if (lastSelectedItem) then
        lastSelectedItem:setBorderWidth(0)
    end

    for k, v in pairs(panel:getChildren()) do
        if (tonumber(v:getId()) == pokemonId) then
            v:setBorderColor('white')
            v:setBorderWidth(1)
            lastSelectedItem = v
            break
        end
    end

    playSound(SOUND_FILES_FOLDER .. pokemonId)
    show()
end

function onPokedexInfoUnknown()
    pokePicture:setImageSource("/images/pictures/0")
    pokeName:setText(tr("Unknown"))
    pokeId:setText("#000")
    family:destroyChildren()

    local text = detailsPanel:recursiveGetChildById('aaaText')
    if (text) then
        text:setText("???")
    end
    text = nil

    text = movesPanel:recursiveGetChildById('aaaText')
    if (text) then
        text:setText("???")
    end
    text = nil

    text = effectivenessPanel:recursiveGetChildById('content')
    if (text) then
        text:destroyChildren()
    end
    text = nil

    type1:setImageSource("")
    type1:setTooltip("")

    type2:setImageSource("")
    type2:setTooltip("")
end

function onPokedexOpen()
    show()
end

function onOnline()
    reset()
end

function onOffline()
    hide()
    reset()
end

function onInit()
    g_ui.importStyle('pokedex')
    rcSoundChannel = g_sounds.getChannel(SOUND_CHANNEL)

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPokedexUpdate = onPokedexUpdate,
        onPokedexStatus = onPokedexStatus,
        onPokedexOpen = onPokedexOpen,
        onPokedexInfo = onPokedexInfo})

    pokedexWindow = g_ui.createWidget('DexWindow', modules.game_interface.getRootPanel())
    pokedexWindow:setup()
    pokedexWindow:setPosition({
        x = (g_window.getDisplaySize().width - pokedexWindow:getWidth()) / 2,
        y = (g_window.getDisplaySize().height - pokedexWindow:getHeight()) / 2})
    pokedexWindow:setVisible(false)
    pokedexWindow:getChildById('dexItem'):setItemId(11242)
    pokedexWindow:setDroppable(false)

    panel = pokedexWindow:recursiveGetChildById('ownDexContainer')

    pokePicture = pokedexWindow:recursiveGetChildById('pokePicture')
    family = pokedexWindow:recursiveGetChildById('family')
    pokeName = pokedexWindow:recursiveGetChildById('pokeName')
    pokeId = pokedexWindow:recursiveGetChildById('pokeId')
    type1 = pokedexWindow:recursiveGetChildById('pokeType1')
    type2 = pokedexWindow:recursiveGetChildById('pokeType2')

    optionsTabBar = pokedexWindow:recursiveGetChildById('optionsTabBar')
    optionsTabBar:setContentWidget(pokedexWindow:recursiveGetChildById('optionsTabContent'))
    optionsTabBar:recursiveGetChildById('buttonsPanel'):setImageSource("")

    detailsPanel = g_ui.loadUI('details')
    optionsTabBar:addTab(tr('Details'), detailsPanel, '/images/optionstab/details')

    movesPanel = g_ui.loadUI('moves')
    optionsTabBar:addTab(tr('Moves'), movesPanel, '/images/optionstab/moves')

    effectivenessPanel = g_ui.loadUI('effectiveness')
    optionsTabBar:addTab(tr('Types'), effectivenessPanel, '/images/optionstab/effectiveness')

    onPokedexInfoUnknown()

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPokedexUpdate = onPokedexUpdate,
        onPokedexStatus = onPokedexStatus,
        onPokedexOpen = onPokedexOpen,
        onPokedexInfo = onPokedexInfo})

    reset()
    pokedexWindow:destroyChildren()
    pokedexWindow:destroy()
end
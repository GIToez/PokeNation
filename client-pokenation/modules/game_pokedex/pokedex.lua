-- PokeNation Pokedex. Port of the legacy PSoul game_pokedex: same packets (0xFF 0x0A status list,
-- 0x0B open, 0x0C single update, 0x11 entry info) and the same request ("/dv N"). The entry info
-- strings are rendered exactly as the server formats them:
--   details        free text ("Type: Fire and Flying ...")
--   moves          "lvl,type,name,category,power,energy,level,cooldown,range;..."
--   effectiveness  "normal;immune;resistant;weak", each a comma list of type ids
--   families       comma list of Pokemon numbers

local Status = PokeNation.DexStatus

local DEX_ICON_KANTO, DEX_ICON_JOHTO = 11242, 16808
local UNKNOWN_ITEMID = 16410
local STATUS_ICON = {
    [Status.CATCHED] = 12854,
    [Status.DEXED_CATCHED] = 12854,
    [Status.SHINYCATCHED] = 12855,
    [Status.DEXED_SHINYCATCHED] = 12855,
    [Status.DEXED_CATCHED_SHINYCATCHED] = 12856,
    [Status.CATCHED_SHINYCATCHED] = 12856
}
local MOVE_COLUMNS = {
    { name = '#', width = 30 }, { name = 'Type', width = 34 }, { name = 'Name', width = 120 },
    { name = 'Ctgry', width = 34 }, { name = 'Pwr', width = 40 }, { name = 'Energy', width = 44 },
    { name = 'Level', width = 40 }, { name = 'Cdwn', width = 40 }, { name = 'Range', width = 40 }
}
local EFFECT_SECTIONS = { 'Normal', 'Immune', 'Resistant', 'Weak' }
local CRY_FOLDER = '/sounds/psoul/cries/'

local window, entriesPanel, optionsTabBar, detailsTab, movesTab, typesTab
local entries = {}       -- pokemon number -> { widget, status }
local selectedNumber

function hide()
    if window then
        window:hide()
    end
end

function show()
    window:show()
    window:raise()
    window:focus()
end

local function dexItemId(number)
    if number <= 151 then
        return 11873 + number
    elseif number <= 251 then
        return (15798 - 151) + number
    end
    return (27108 - 251) + number
end

local function isSeen(status)
    return status == Status.DEXED or status == Status.DEXED_CATCHED or status == Status.DEXED_SHINYCATCHED
        or status == Status.DEXED_CATCHED_SHINYCATCHED
end

local function request(number)
    return PokeNation.say('/dv ' .. number)
end

local function playCry(number)
    if not g_sounds then
        return
    end
    local channel = g_sounds.getChannel(SoundChannels.Effect)
    if channel then
        channel:stop(0)
        channel:play(CRY_FOLDER .. number .. '.ogg', 0, channel:getGain())
    end
end

local function setEntryStatus(number, status)
    local entry = entries[number]
    if not entry then
        return
    end
    entry.status = status
    local widget = entry.widget
    widget:setItemId(isSeen(status) and dexItemId(number) or UNKNOWN_ITEMID)
    widget:destroyChildren()
    if STATUS_ICON[status] then
        g_ui.createWidget('DexStatusItem', widget):setItemId(STATUS_ICON[status])
    end
    local name = status ~= Status.UNKNOWN and getPokemonNameByNumber(number) or '???'
    widget:setTooltip(string.format('#%03d %s', number, name))
end

local function showUnknown()
    window:getChildById('pokePicture'):setImageSource(PokeNation.image('pictures/0'))
    window:getChildById('pokeName'):setText(tr('Unknown'))
    window:getChildById('pokeId'):setText('#000')
    window:getChildById('family'):destroyChildren()
    window:getChildById('pokeType1'):setImageSource('')
    window:getChildById('pokeType2'):setImageSource('')
    detailsTab:getChildById('text'):setText('???')
    movesTab:getChildById('content'):destroyChildren()
    typesTab:getChildById('content'):destroyChildren()
end

local function extractTypes(details)
    local text = string.stripAccents(details)
    local type1, type2 = text:match('Type: (%a+) and (%a+)')
    if not type1 then
        type1 = text:match('Type: (%a+)')
    end
    return type1, type2
end

local function setTypeIcon(widget, typeName)
    if typeName then
        widget:setImageSource(PokeNation.image('types/' .. getTypeIdByName(typeName)))
        widget:setTooltip(typeName)
    else
        widget:setImageSource('')
        widget:setTooltip('')
    end
end

local function addCell(row, width, text)
    local cell = g_ui.createWidget('DexCell', row)
    cell:setWidth(width)
    if text then
        cell:setText(text)
    end
    return cell
end

local function fillMoves(moves)
    local content = movesTab:getChildById('content')
    content:destroyChildren()
    local header = g_ui.createWidget('DexMoveRow', content)
    header:setBackgroundColor('#898989cc')
    for _, column in ipairs(MOVE_COLUMNS) do
        addCell(header, column.width, tr(column.name))
    end
    for _, line in ipairs(moves:split(';')) do
        if line ~= '' then
            local row = g_ui.createWidget('DexMoveRow', content)
            for index, value in ipairs(line:split(',')) do
                local column = MOVE_COLUMNS[index] or { width = 40 }
                local cell = addCell(row, column.width)
                if index == 2 then
                    cell:setImageSource(PokeNation.image('types/' .. value))
                    cell:setTooltip(getTypeNameById(value))
                elseif index == 3 then
                    cell:setText(value)
                    cell:setTooltip(getMoveDescriptionByName(value))
                elseif index == 4 then
                    cell:setImageSource(PokeNation.image('moveCategories/' .. value))
                    cell:setTooltip(getMoveCategoryNameById(value))
                else
                    cell:setText(value)
                end
            end
        end
    end
end

local function fillEffectiveness(effectiveness)
    local content = typesTab:getChildById('content')
    content:destroyChildren()
    local lists = effectiveness:explode(';')
    for index, sectionName in ipairs(EFFECT_SECTIONS) do
        local section = g_ui.createWidget('DexEffectSection', content)
        section:getChildById('header'):setText(tr(sectionName))
        local box = section:getChildById('types')
        local list = lists[index]
        local count = 0
        if list and list ~= '' then
            for _, typeId in ipairs(list:split(',')) do
                local icon = g_ui.createWidget('UIWidget', box)
                icon:setImageSource(PokeNation.image('types/square/' .. typeId))
                icon:setTooltip(getTypeNameById(typeId))
                count = count + 1
            end
        end
        section:setHeight(6 + math.max(1, math.ceil(count / 6)) * 23)
    end
end

local function fillFamily(families)
    local family = window:getChildById('family')
    family:destroyChildren()
    for _, value in ipairs(families:split(',')) do
        local number = tonumber(value)
        if number then
            local icon = g_ui.createWidget('UIWidget', family)
            icon:setImageSource(PokeNation.image(string.format('pokeicons/%03d', number)))
            icon:setBorderWidth(1)
            icon:setBorderColor('#5b5b5bcc')
            icon:setBackgroundColor('#4b4b4bcc')
            icon:setTooltip(getPokemonNameByNumber(number))
            icon.onClick = function() request(number) end
        end
    end
end

local function select(number)
    if selectedNumber and entries[selectedNumber] then
        entries[selectedNumber].widget:setBorderWidth(0)
    end
    selectedNumber = number
    if entries[number] then
        entries[number].widget:setBorderWidth(1)
        entriesPanel:ensureChildVisible(entries[number].widget)
    end
end

local function onPokedexInfo(pokemonId, details, moves, effectiveness, families)
    window:getChildById('pokePicture'):setImageSource(PokeNation.image('pictures/' .. pokemonId))
    window:getChildById('pokeName'):setText(getPokemonNameByNumber(pokemonId))
    window:getChildById('pokeId'):setText(string.format('#%03d', pokemonId))
    local type1, type2 = extractTypes(details)
    setTypeIcon(window:getChildById('pokeType1'), type1)
    setTypeIcon(window:getChildById('pokeType2'), type2)
    fillFamily(families)
    detailsTab:getChildById('text'):setText(details)
    fillMoves(moves)
    fillEffectiveness(effectiveness)
    select(pokemonId)
    playCry(pokemonId)
    show()
end

local function onPokedexStatus(statusList)
    entriesPanel:destroyChildren()
    entries = {}
    selectedNumber = nil
    for number, status in ipairs(statusList) do
        local widget = g_ui.createWidget('DexEntry', entriesPanel)
        widget:setId('dex' .. number)
        entries[number] = { widget = widget }
        setEntryStatus(number, status)
        widget.onClick = function()
            if entries[number].status ~= Status.UNKNOWN then
                request(number)
            else
                select(number)
                showUnknown()
            end
        end
    end
    window:getChildById('dexItem'):setItemId(#statusList <= 151 and DEX_ICON_KANTO or DEX_ICON_JOHTO)
end

local function onPokedexUpdate(pokemonNumber, status)
    setEntryStatus(pokemonNumber, status)
end

local function onPokedexOpen()
    show()
end

local function reset()
    entriesPanel:destroyChildren()
    entries = {}
    selectedNumber = nil
    showUnknown()
    hide()
end

function getState()
    local seen, caught = 0, 0
    for _, entry in pairs(entries) do
        if isSeen(entry.status) then
            seen = seen + 1
        end
        if STATUS_ICON[entry.status] then
            caught = caught + 1
        end
    end
    return { visible = window:isVisible(), entries = #entriesPanel:getChildren(), seen = seen, caught = caught,
        selected = selectedNumber, name = window:getChildById('pokeName'):getText(),
        moves = math.max(0, movesTab:getChildById('content'):getChildCount() - 1) }
end

function getWindow()
    return window
end

function init()
    g_ui.importStyle('pokedex')
    window = g_ui.createWidget('PokedexWindow', modules.game_interface.getRootPanel())
    window:hide()
    entriesPanel = window:getChildById('ownDexContainer')
    window:getChildById('dexItem'):setItemId(DEX_ICON_KANTO)

    optionsTabBar = window:getChildById('optionsTabBar')
    optionsTabBar:setContentWidget(window:getChildById('optionsTabContent'))
    detailsTab = g_ui.createWidget('DexTabText')
    movesTab = g_ui.createWidget('DexTabList')
    typesTab = g_ui.createWidget('DexTabList')
    optionsTabBar:addTab(tr('Details'), detailsTab, PokeNation.image('optionstab/details'))
    optionsTabBar:addTab(tr('Moves'), movesTab, PokeNation.image('optionstab/moves'))
    optionsTabBar:addTab(tr('Types'), typesTab, PokeNation.image('optionstab/effectiveness'))
    showUnknown()

    connect(g_game, {
        onGameStart = reset,
        onGameEnd = reset,
        onPokedexStatus = onPokedexStatus,
        onPokedexUpdate = onPokedexUpdate,
        onPokedexOpen = onPokedexOpen,
        onPokedexInfo = onPokedexInfo
    })
end

function terminate()
    disconnect(g_game, {
        onGameStart = reset,
        onGameEnd = reset,
        onPokedexStatus = onPokedexStatus,
        onPokedexUpdate = onPokedexUpdate,
        onPokedexOpen = onPokedexOpen,
        onPokedexInfo = onPokedexInfo
    })
    window:destroy()
    window = nil
end

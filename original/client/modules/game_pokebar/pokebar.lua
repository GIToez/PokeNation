-- Constants
pokemonBar = nil

local lastBarIcon = nil
local portraitLabels = {}
local currentPokemonPortraitLabel
local currentPokemonPortrait

local ORIENTATIONS = {}
ORIENTATIONS.HORIZONTAL = 0
ORIENTATIONS.VERTICAL = 1

local orientation = ORIENTATIONS.HORIZONTAL
local defaultWidth = 0
local defaultHeight = 0

local POKEBELT_ITEM_IMAGE = "/images/ui/pokebelt_item"
local POKEBELT_ITEM_USE_IMAGE = "/images/ui/pokebelt_item_use"

-- Methods
local function resetCurrentPortrait()
    currentPokemonPortraitLabel = nil
    currentPokemonPortrait = nil
end

local function getColorByHealthPercent(percent, serverId)
    if (percent >= 80) then
        return '#00851B'
    elseif (percent >= 40) then
        return '#8A8A00'
    end
    return '#850000'
end

local function updatePortraitLabel(portrait, textColor, text)
    local label = portraitLabels[portrait:getId()]
    if (text == tr("USE")) then
        if (currentPokemonPortrait) then
            currentPokemonPortrait:setImageSource(POKEBELT_ITEM_IMAGE)
        end

        currentPokemonPortraitLabel = label
        currentPokemonPortrait = portrait
        portrait:setImageSource(POKEBELT_ITEM_USE_IMAGE)
        return -- Dont update the label, this is just a signal about what icon/label the player is using

    elseif (portrait == currentPokemonPortrait) then
        currentPokemonPortrait:setImageSource(POKEBELT_ITEM_IMAGE)
        resetCurrentPortrait()
    end

    if (textColor == 0) then
        label:setColor('#00851B')
        portrait:getChildById('portrait'):setColor(TextColors.white)
    elseif (textColor == 1) then
        label:setColor('#8A8A00')
        portrait:getChildById('portrait'):setColor(TextColors.white)
    elseif (textColor == 2) then
        label:setColor('#850000')
        if (text == "FNT") then
            portrait:getChildById('portrait'):setColor('#00000099')
        end
    else
        label:setColor('#FFFFFF')
        portrait:getChildById('portrait'):setColor(TextColors.white)
    end
    label:setText(text)
end

local function hide()
    pokemonBar:hide()
end

local function show()
    pokemonBar:show()
end

local function resize()
    if (orientation == ORIENTATIONS.HORIZONTAL) then
        pokemonBar:setImageSource("/images/ui/pokebelth")
        local width = pokemonBar:getPaddingLeft() + pokemonBar:getPaddingRight()

        if (pokemonBar:getChildCount() == 0) then
            width = width + 32

        else
            for k, v in pairs(pokemonBar:getChildren()) do
                if (v:getStyleName() == 'BeltItem') then
                    width = width + v:getWidth() + 2
                end
            end
        end

        pokemonBar:resize(width, defaultHeight)

    else
        pokemonBar:setImageSource("/images/ui/pokebeltv")
        local height = pokemonBar:getPaddingTop() + pokemonBar:getPaddingBottom() + 5

        if (pokemonBar:getChildCount() == 0) then
            height = height + 32

        else
            for k, v in pairs(pokemonBar:getChildren()) do
                height = height + v:getHeight()
            end
        end

        pokemonBar:resize(65, height)
    end
end

local function reallocatePortraits()
    local last
    for k, v in pairs(pokemonBar:getChildren()) do
        if (v:getStyleName() == 'BeltItem') then
            v:breakAnchors()

            if (orientation == ORIENTATIONS.HORIZONTAL) then
                if (last) then
                    v:addAnchor(AnchorLeft, last:getId(), AnchorRight)
                else
                    v:addAnchor(AnchorLeft, 'parent', AnchorLeft)
                end
                v:addAnchor(AnchorTop, 'parent', AnchorTop)
                v:addAnchor(AnchorVerticalCenter, 'parent', AnchorVerticalCenter)

                last = v

            else
                if (last) then
                    v:addAnchor(AnchorTop, last:getId(), AnchorBottom)
                else
                    v:addAnchor(AnchorTop, 'parent', AnchorTop)
                end
                v:addAnchor(AnchorLeft, 'parent', AnchorLeft)
                v:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)

                --v:setMarginLeft(0)
                last = v
            end

        --elseif (--[[]orientation == ORIENTATIONS.VERTICAL and ]]v:getStyleName() == 'HealthLabel') then
        --    last = v
        end
    end
end

function switchOrientation()
    orientation = orientation == ORIENTATIONS.HORIZONTAL and ORIENTATIONS.VERTICAL or ORIENTATIONS.HORIZONTAL
    resize()
    reallocatePortraits()
end

local function removePortrait(portrait)
    local id = portrait:getId()
    if (portraitLabels[id] == currentPokemonPortraitLabel) then
        currentPokemonPortraitLabel = nil
        currentPokemonPortrait = nil
    end

    portraitLabels[id]:destroy()
    portraitLabels[id] = nil
    portrait:destroy()
end

local function reset()
    pokemonBar:destroyChildren()
    resetCurrentPortrait()
end

-- Hooks
function onPokemonBarAdd(itemId, fastcallNumber, textColor, text)
    local item = g_ui.createWidget('BeltItem', pokemonBar)
    local portrait = item:getChildById('portrait')
    local label = item:getChildById('health')

    item:setId('poke' .. fastcallNumber)
    portrait:setItemId(itemId)
    item.onMouseRelease = function(self, mousePosition, mouseButton)
        if mouseButton == MouseLeftButton and g_keyboard.isShiftPressed() then
            g_game.talkChannel(MessageModes.Say, 0 , '/pd ' .. fastcallNumber)
            return true
        end
        g_game.talkChannel(MessageModes.Say, 0 , '/cp ' .. fastcallNumber)
        return true
    end
    item:setTooltip(getPokemonNameByIconItemId(itemId))
    portrait:setTooltip(getPokemonNameByIconItemId(itemId))

    --[[if (pokemonBar:getChildCount() == 1) then -- Ugly hack
        item:setMarginLeft(0)
    end]]

    -- local label = g_ui.createWidget('HealthLabel', pokemonBar)
    label:setId(item:getId() .. 'label')
    --label:addAnchor(AnchorTop, item:getId(), AnchorBottom)
    --label:addAnchor(AnchorHorizontalCenter, item:getId(), AnchorHorizontalCenter)

    lastBarIcon = item
    portraitLabels[item:getId()] = label
    updatePortraitLabel(item, textColor, text)

    resize()
    reallocatePortraits()
    show()
end

function onPokemonBarRemove(fastcallNumber)
    local id = 'poke' .. fastcallNumber
    for k, v in pairs(pokemonBar:getChildren()) do
        if (v:getStyleName() == 'BeltItem' and v:getId() == id) then
            removePortrait(v)
        end
    end

    resize()
    reallocatePortraits()
    show()
end

function onPokemonBarUpdate(fastcallNumber, textColor, text)
    local id = 'poke' .. fastcallNumber
    for k, v in pairs(pokemonBar:getChildren()) do
        if (v:getStyleName() == 'BeltItem' and v:getId() == id) then
            updatePortraitLabel(v, textColor, text)
        end
    end
end

function onPokemonBarOpen()
    show()
end

function onPokemonBarClose()
    hide()
    reset()
end

function onOnline()
    hide()
    reset()
    resize()
end

function onOffline()
    hide()
    reset()
end

function onCreatureHealthPercentChange(creature, health)
    if (creature:isLocalPlayerSummon() and currentPokemonPortraitLabel) then
        local p = creature:getHealthPercent()
        currentPokemonPortraitLabel:setColor(getColorByHealthPercent(p))
        currentPokemonPortraitLabel:setText(p .. "%")
    end
end

function onInit()
    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPokemonBarAdd = onPokemonBarAdd,
        onPokemonBarRemove = onPokemonBarRemove,
        onPokemonBarUpdate = onPokemonBarUpdate,
        onPokemonBarOpen = onPokemonBarOpen,
        onPokemonBarClose = onPokemonBarClose})

    connect(Creature, {
        onHealthPercentChange = onCreatureHealthPercentChange,
    })

    pokemonBar = g_ui.loadUI('pokebar', modules.game_interface.getRootPanel())
    scheduleEvent(function()
        local p = g_settings.getPoint('pokebar-pos')
        if (p and p.x > 0 and p.y > 0) then
            pokemonBar:breakAnchors()
            pokemonBar:setPosition(p)
        end
    end, 100)
    orientation = g_settings.getInteger('pokebar-orientation', ORIENTATIONS.HORIZONTAL)
    pokemonBar:hide()

    pokemonBar.onMouseRelease = function(self, mousePosition, mouseButton)
        if (mouseButton == MouseRightButton) then
            local menu = g_ui.createWidget('PopupMenu')
            menu:addOption(tr('Switch Orientation'), switchOrientation)
            menu:display(mousePosition)
            return true
        end
        return false
    end

    defaultWidth = pokemonBar:getWidth()
    defaultHeight = pokemonBar:getHeight()

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPokemonBarAdd = onPokemonBarAdd,
        onPokemonBarRemove = onPokemonBarRemove,
        onPokemonBarUpdate = onPokemonBarUpdate,
        onPokemonBarOpen = onPokemonBarOpen,
        onPokemonBarClose = onPokemonBarClose})

    disconnect(Creature, {
        onHealthPercentChange = onCreatureHealthPercentChange,
    })

    g_settings.set('pokebar-pos', pokemonBar:getPosition())
    g_settings.set('pokebar-orientation', orientation)

    pokemonBar:destroy()
end
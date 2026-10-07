-- PokeNation level-up popups. Port of the legacy PSoul game_advanceeffect:
--   * trainer level change (stock level field) with the features unlocked at that level;
--   * trainer skill change (catching, fishing, headbutting);
--   * Pokemon level up, 0xFF 0x19: Pokemon number, new level, U16 count + U16 move icon ids.
-- The C++ parser reads the move count as U16 (the legacy client truncated it to U8, BUG-60), and the
-- popup shows every move: up to MAX_MOVE_ROWS as named rows, more as one icon grid with the
-- names in tooltips (16 moves = two rows). Popups stack in one fit-children container instead of
-- fixed per-kind margins, so simultaneous level / skill / Pokemon popups never overlap.
-- The legacy ADVANCES table repeated the keys 75 and 85, so Lua kept only the last entry; both
-- features per level are listed here.

local MAX_MOVE_ROWS = 2
local SHOW_MS, FADE_MS = 9000, 3000

local ADVANCES = {
    [10] = { { 'rangerclub', 'Ranger Club - Rookie' } },
    [15] = { { 'tournament', 'Tournament - Starter' } },
    [25] = { { 'rangerclub', 'Ranger Club - Mentor' } },
    [30] = { { 'safarizone', 'The Safari Zone' } },
    [41] = { { 'tournament', 'Tournament - Pro' } },
    [46] = { { 'tournament', 'Tournament - Master' } },
    [50] = { { 'rangerclub', 'Ranger Club - Coordinator' } },
    [61] = { { 'tournament', 'Tournament - Elite' } },
    [70] = { { 'battletower', 'Battle Tower - Twenty' } },
    [75] = { { 'rangerclub', 'Ranger Club - Coach' }, { 'tournament', 'Tournament - Titan' } },
    [80] = { { 'battletower', 'Battle Tower - Fifteen' } },
    [85] = { { 'daycare', 'Day Care' }, { 'mastery', 'Mastery' } },
    [90] = { { 'battletower', 'Battle Tower - Ten' } }
}

local SKILLS = {
    [PLAYER_SKILL_CATCHING] = { 'catching', 'Catching' },
    [PLAYER_SKILL_FISHING] = { 'fishing', 'Fishing' },
    [PLAYER_SKILL_HEADBUTTING] = { 'headbutting', 'Headbutting' }
}

local stack
local popups = {}       -- kind -> widget currently shown
local lastLevel
local lastSkill = {}
local lastPokemonLevelUp

local function addSection(popup, title, description, opts)
    local section = g_ui.createWidget('AdvanceSection', popup)
    section:getChildById('title'):setText(title)
    section:getChildById('description'):setText(description)
    if opts.itemId then
        local item = section:getChildById('item')
        item:setItemId(opts.itemId)
        item:show()
    elseif opts.image then
        local image = section:getChildById('image')
        image:setImageSource(opts.image)
        image:show()
    else
        section:getChildById('title'):setMarginLeft(0)
        section:getChildById('description'):setMarginLeft(0)
    end
    return section
end

local function closePopup(kind)
    local popup = popups[kind]
    if popup then
        removeEvent(popup.fadeEvent)
        removeEvent(popup.hideEvent)
        popup:destroy()
        popups[kind] = nil
    end
end

local function createPopup(kind, subtitle, headline)
    closePopup(kind)
    local popup = g_ui.createWidget('AdvancePopup', stack)
    popup:setId('advance_' .. kind)
    local header = popup:getChildById('header')
    header:getChildById('subtitle'):setText(subtitle)
    header:getChildById('headline'):setText(headline)
    popup.onClick = function() closePopup(kind) end
    popups[kind] = popup
    return popup
end

local function present(kind, popup)
    popup:show()
    popup:raise()
    g_effects.fadeIn(popup, 1000)
    popup.fadeEvent = scheduleEvent(function()
        g_effects.fadeOut(popup, FADE_MS)
        popup.hideEvent = scheduleEvent(function() closePopup(kind) end, FADE_MS)
    end, SHOW_MS)
end

local function showTrainerLevel(level)
    local popup = createPopup('level', tr("You've Reached"), tr('Level %d', level))
    for _, advance in ipairs(ADVANCES[level] or {}) do
        addSection(popup, tr('New Feature'), tr(advance[2]), { image = PokeNation.image('advances/' .. advance[1]) })
    end
    present('level', popup)
end

local function showSkill(skillId, level)
    local skill = SKILLS[skillId]
    if not skill then
        return
    end
    local popup = createPopup('skill', tr('Skill Advance'), tr(skill[2]))
    addSection(popup, tr(skill[2]), tostring(level), { image = PokeNation.image('advances/' .. skill[1]) })
    present('skill', popup)
end

local function onPokemonLevelUp(pokemonNumber, newLevel, newMoves)
    lastPokemonLevelUp = { number = pokemonNumber, level = newLevel, moves = #newMoves }
    local popup = createPopup('pokemon', getPokemonNameByNumber(pokemonNumber), tr('Level %d', newLevel))
    local portrait = popup:getChildById('header'):getChildById('portrait')
    portrait:setImageSource(PokeNation.image('staticPortraits/' .. pokemonNumber))
    portrait:show()
    if #newMoves <= MAX_MOVE_ROWS then
        for _, moveItemId in ipairs(newMoves) do
            addSection(popup, tr('New Move'), getMoveNameByIconItemId(moveItemId), { itemId = moveItemId })
        end
    else
        g_ui.createWidget('AdvanceMovesTitle', popup):setText(tr('New Moves (%d)', #newMoves))
        local grid = g_ui.createWidget('AdvanceMoveGrid', popup)
        for _, moveItemId in ipairs(newMoves) do
            local icon = g_ui.createWidget('AdvanceMoveIcon', grid)
            icon:setItemId(moveItemId)
            icon:setTooltip(getMoveNameByIconItemId(moveItemId))
        end
    end
    present('pokemon', popup)
end

local function onLevelChange(player, level)
    if lastLevel and level > lastLevel then
        showTrainerLevel(level)
    end
    lastLevel = level
end

local function onSkillChange(player, skillId, level)
    if lastSkill[skillId] and level > lastSkill[skillId] then
        showSkill(skillId, level)
    end
    lastSkill[skillId] = level
end

local function reset()
    for kind in pairs(popups) do
        closePopup(kind)
    end
    lastLevel = nil
    lastSkill = {}
end

function getLastPokemonLevelUp()
    return lastPokemonLevelUp
end

function getPopup(kind)
    return popups[kind]
end

function init()
    g_ui.importStyle('advanceeffect')
    stack = g_ui.createWidget('AdvanceStack', modules.game_interface.getRootPanel())
    connect(g_game, { onGameStart = reset, onGameEnd = reset, onPokemonLevelUp = onPokemonLevelUp })
    connect(LocalPlayer, { onLevelChange = onLevelChange, onSkillChange = onSkillChange })
end

function terminate()
    disconnect(g_game, { onGameStart = reset, onGameEnd = reset, onPokemonLevelUp = onPokemonLevelUp })
    disconnect(LocalPlayer, { onLevelChange = onLevelChange, onSkillChange = onSkillChange })
    reset()
    stack:destroy()
    stack = nil
end

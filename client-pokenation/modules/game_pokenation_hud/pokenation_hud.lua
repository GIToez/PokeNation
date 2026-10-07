-- PokeNation vitals panel. PSoul reuses stock 8.54 player stats with Pokemon meanings
-- (docs/reference/OPCODES.md): mana = summoned Pokemon energy, magic level = Pokemon level and
-- experience percent, soul = Respect, free capacity = Balls. Values are display-only.

local hud

local function percentOf(value, max)
    if not max or max <= 0 then
        return 0
    end
    return math.max(0, math.min(100, value * 100 / max))
end

local function onHealthChange(player, health, maxHealth)
    local bar = hud:getChildById('health')
    bar:setPercent(percentOf(health, maxHealth))
    bar:setText(string.format('%d / %d', health, maxHealth))
    bar:setTooltip(tr('Trainer health: %d out of %d.', health, maxHealth))
end

local function onManaChange(player, mana, maxMana)
    local bar = hud:getChildById('energy')
    bar:setPercent(percentOf(mana, maxMana))
    bar:setText(string.format('%s %d / %d', tr('Energy'), mana, maxMana))
    bar:setTooltip(tr('Pokemon energy: %d out of %d.', mana, maxMana))
end

local function refreshLevels(player)
    local pokemonLevel = player:getMagicLevel()
    local pokemonPercent = player:getMagicLevelPercent()
    hud:getChildById('levels'):setText(string.format('%s %d  |  %s %d', tr('Trainer Lv'), player:getLevel(),
        tr('Pokemon Lv'), pokemonLevel))
    hud:getChildById('levels'):setTooltip(tr('Trainer: %d%% to level %d.', player:getLevelPercent(),
        player:getLevel() + 1))
    local exp = hud:getChildById('pokemonExp')
    exp:setPercent(pokemonPercent)
    exp:setTooltip(tr('Your Pokemon have %d%% to advance to level %d.', pokemonPercent, pokemonLevel + 1))
end

local function onSoulChange(player, soul)
    hud:getChildById('respect'):setText(tr('Respect') .. ': ' .. soul)
end

local function onFreeCapacityChange(player, freeCapacity)
    hud:getChildById('balls'):setText(tr('Balls') .. ': ' .. math.floor(freeCapacity))
end

local function refreshAll()
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end
    onHealthChange(player, player:getHealth(), player:getMaxHealth())
    onManaChange(player, player:getMana(), player:getMaxMana())
    refreshLevels(player)
    onSoulChange(player, player:getSoul())
    onFreeCapacityChange(player, player:getFreeCapacity())
end

local function onGameStart()
    refreshAll()
    hud:show()
end

local function onGameEnd()
    hud:hide()
end

function getValues()
    return {
        health = hud:getChildById('health'):getText(),
        energy = hud:getChildById('energy'):getText(),
        levels = hud:getChildById('levels'):getText(),
        respect = hud:getChildById('respect'):getText(),
        balls = hud:getChildById('balls'):getText()
    }
end

function getWidget()
    return hud
end

local playerEvents = {
    onHealthChange = onHealthChange,
    onManaChange = onManaChange,
    onLevelChange = refreshLevels,
    onMagicLevelChange = refreshLevels,
    onSoulChange = onSoulChange,
    onFreeCapacityChange = onFreeCapacityChange
}

function init()
    g_ui.importStyle('pokenation_hud')
    hud = g_ui.createWidget('PokeNationHud', modules.game_interface.getRootPanel())
    hud:hide()
    connect(LocalPlayer, playerEvents)
    connect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    if g_game.isOnline() then
        onGameStart()
    end
end

function terminate()
    disconnect(LocalPlayer, playerEvents)
    disconnect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    hud:destroy()
    hud = nil
end

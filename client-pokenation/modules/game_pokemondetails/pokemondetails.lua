-- PokeNation Pokemon details. "/pd N" (team bar shift-click / context menu) makes the server answer with
-- the ball description as a MESSAGE_INFO_DESCR text (server lib/ps/events/talkactions/client/
-- pokemonDescription.lua). That text is built by doBallUpdateDescription (server lib/ps/config/balls.lua):
--   "Contains a <sex> <Species>(<nickname>) (Level <n>) [+<extra points>].\n<Special Ability / TM / Egg
--    Move / Seal / Held Item lines>"
-- The window shows exactly those fields; nothing is computed client-side. Health comes from the team bar.

local ANSWER_WINDOW_MS = 3000

local window
local pending        -- { fastcall, itemId, name, time }
local last           -- parsed details of the last answer

local function parse(text)
    local firstLine, rest = text:match('^([^\n]*)\n?(.*)$')
    local sex, body = firstLine:match('^Contains an? (%S+) (.+)$')
    if not sex then
        return nil
    end
    local species, nickname, level, extra = body:match('^(.-)%((.-)%) %(Level (%d+)%) %[%+(%-?%d+)%]%.$')
    if not species then
        species, level, extra = body:match('^(.-) %(Level (%d+)%) %[%+(%-?%d+)%]%.$')
    end
    if not species then
        return nil
    end
    return { sex = sex, species = species, nickname = nickname, level = tonumber(level),
        extraPoints = tonumber(extra), extra = rest or '' }
end

local function setRow(key, value)
    local rows = window:getChildById('rows')
    local row = g_ui.createWidget('DetailsRow', rows)
    row:getChildById('key'):setText(key)
    row:getChildById('value'):setText(value)
end

local function present(details, request)
    last = details
    local title = details.nickname and string.format('%s (%s)', details.nickname, details.species) or details.species
    window:setText(title)
    window:getChildById('name'):setText(title)
    window:getChildById('subtitle'):setText(tr('Level %d', details.level))
    window:getChildById('portrait'):setItemId(request and request.itemId or 0)
    window:getChildById('rows'):destroyChildren()
    setRow(tr('Species'), details.species)
    if details.nickname then
        setRow(tr('Nickname'), details.nickname)
    end
    setRow(tr('Level'), tostring(details.level))
    setRow(tr('Sex'), details.sex)
    setRow(tr('Extra points'), '+' .. details.extraPoints)
    if request and modules.game_pokebar then
        for _, slot in ipairs(modules.game_pokebar.getSlots()) do
            if slot.fastcall == request.fastcall then
                setRow(tr('Health'), slot.fainted and tr('fainted') or (slot.text or ''))
            end
        end
    end
    window:getChildById('extra'):setText(details.extra ~= '' and details.extra or tr('No TM, egg move or held item.'))
    window:show()
    window:raise()
end

function request(fastcall, itemId, name)
    pending = { fastcall = fastcall, itemId = itemId, name = name, time = g_clock.millis() }
end

local function onTextMessage(mode, text)
    if not pending or g_clock.millis() - pending.time > ANSWER_WINDOW_MS then
        return
    end
    local details = parse(text)
    if details then
        present(details, pending)
        pending = nil
    end
end

local function reset()
    pending = nil
    last = nil
    window:hide()
end

function getLast()
    return last
end

function getWindow()
    return window
end

function init()
    g_ui.importStyle('pokemondetails')
    window = g_ui.createWidget('PokemonDetailsWindow', modules.game_interface.getRootPanel())
    window:hide()
    connect(g_game, { onGameStart = reset, onGameEnd = reset, onTextMessage = onTextMessage })
end

function terminate()
    disconnect(g_game, { onGameStart = reset, onGameEnd = reset, onTextMessage = onTextMessage })
    window:destroy()
    window = nil
end

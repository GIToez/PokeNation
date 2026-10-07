-- PokeNation client smoke test. Drives the normal login UI (EnterGame -> CharacterList -> game)
-- against a local PSoul server and logs every protocol milestone as "[pn-smoke] ..." lines.
-- "[pn-smoke] SHOT <name>" asks the runner to take a screenshot; "[pn-smoke] RESULT PASS|FAIL"
-- ends the run. Configuration comes from environment variables set by the runner:
--   PN_SMOKE_ACCOUNT, PN_SMOKE_PASSWORD, PN_SMOKE_CHARACTER, PN_SMOKE_LOCALE (en|pt|es)

PNSmoke = {}

local cfg = {
    account = os.getenv('PN_SMOKE_ACCOUNT') or 'admin',
    password = os.getenv('PN_SMOKE_PASSWORD') or 'admin',
    character = os.getenv('PN_SMOKE_CHARACTER') or 'Tester',
    locale = os.getenv('PN_SMOKE_LOCALE')
}

local checks = {}
local counters = { pokemonBarAdd = 0, pokemonMoves = 0, pokedexStatus = 0, creatures = 0, ownSummons = 0 }
local finished = false
local startPos
local hasPoll = false
local pollContinue

local function log(fmt, ...)
    g_logger.info('[pn-smoke] ' .. string.format(fmt, ...))
end

local function check(name, ok, detail)
    checks[#checks + 1] = { name = name, ok = ok }
    log('CHECK %s %s%s', ok and 'PASS' or 'FAIL', name, detail and (' (' .. detail .. ')') or '')
end

local function finish()
    if finished then
        return
    end
    finished = true
    local failed = 0
    for _, c in ipairs(checks) do
        if not c.ok then
            failed = failed + 1
        end
    end
    log('RESULT %s %d/%d checks passed', failed == 0 and #checks > 0 and 'PASS' or 'FAIL', #checks - failed, #checks)
    scheduleEvent(function() g_app.exit() end, 500)
end

local function fail(reason)
    check('run', false, reason)
    finish()
end

-- Reads the GL framebuffer of the next frame into the user write dir; the runner collects it.
local function shot(name)
    g_app.doScreenshot('/pn-smoke-' .. name .. '.png')
    log('SHOT %s', name)
end

local function onCharacterListCreated(characters, account)
    log('charlist: %d characters, premDays=%s, hasPoll=%s', #characters, tostring(account.premDays), tostring(account.hasPoll))
    local found
    for _, c in ipairs(characters) do
        log('  %s world=%s %s:%d level=%s vocation=%s looktype=%s team=%d', c.name, c.worldName, c.worldIp, c.worldPort,
            tostring(c.level), tostring(c.vocation), tostring(c.outfit and c.outfit.type), c.pokemonTeam and #c.pokemonTeam or -1)
        if c.name == cfg.character then
            found = c
        end
    end
    check('charlist parsed with PSoul extras', found ~= nil and found.level ~= nil and found.outfit ~= nil and found.pokemonTeam ~= nil)
    check('charlist poll flag read', account.hasPoll ~= nil)
    hasPoll = account.hasPoll == true
    if not found then
        return fail('character ' .. cfg.character .. ' not in list')
    end
    scheduleEvent(function() shot('02-charlist') end, 1000)
    scheduleEvent(function()
        CharacterList.doLogin()
    end, 2500)
end

-- Only when the character list announced a poll: 0xFA request -> 0xFF 0x18 window -> 0xFB vote.
local function pollStep(nextStep)
    if not hasPoll then
        return nextStep()
    end
    pollContinue = nextStep
    g_game.requestPollWindow()
    scheduleEvent(function()
        if pollContinue then
            check('0xFA poll request answered by 0xFF 0x18', false, 'no poll window within 4 s')
            pollContinue = nil
            nextStep()
        end
    end, 4000)
end

local function onPollWindow(question, options)
    if not pollContinue then
        return
    end
    local nextStep = pollContinue
    pollContinue = nil
    check('0xFA poll request answered by 0xFF 0x18', type(question) == 'string' and question ~= '', question)
    if type(options) == 'table' then
        local firstId
        for id, text in pairs(options) do
            log('poll option %d: %s', id, text)
            if not firstId or id < firstId then
                firstId = id
            end
        end
        log('POLL VOTE option %s', tostring(firstId))
        check('0xFB poll vote sent', firstId ~= nil and g_game.doPollVote(firstId))
    else
        log('POLL VOTE text')
        check('0xFB poll text vote sent', g_game.doPollVoteText('pn-smoke text vote'))
    end
    scheduleEvent(nextStep, 1500)
end

local function afterWorld()
    local player = g_game.getLocalPlayer()
    startPos = player:getPosition()
    log('in world as %s at %d,%d,%d health=%d/%d level=%d', player:getName(), startPos.x, startPos.y, startPos.z,
        player:getHealth(), player:getMaxHealth(), player:getLevel())
    check('local player placed', startPos.x > 0)

    local spectators = g_map.getSpectators(startPos, false)
    for _, creature in ipairs(spectators) do
        counters.creatures = counters.creatures + 1
        if creature:isLocalPlayerSummon() then
            counters.ownSummons = counters.ownSummons + 1
        end
    end
    log('spectators=%d ownSummons=%d', counters.creatures, counters.ownSummons)
    check('creature descriptions parsed', counters.creatures >= 1)
    shot('03-world')
    local motd = g_ui.getRootWidget():recursiveGetChildById('motdWindow')
    if motd then
        motd:destroy()
    end

    g_game.requestChannels()

    -- Try each direction until the server moves the player (the tile next to the spawn may be blocked).
    local directions = { South, East, North, West }
    local function tryWalk(i)
        if i > #directions then
            check('walk accepted by server', false, 'no direction moved the player')
            return scheduleEvent(PNSmoke.logout, 500)
        end
        local before = g_game.getLocalPlayer():getPosition()
        g_game.walk(directions[i])
        scheduleEvent(function()
            local pos = g_game.getLocalPlayer():getPosition()
            log('walk %d: %d,%d,%d -> %d,%d,%d', directions[i], before.x, before.y, before.z, pos.x, pos.y, pos.z)
            if pos.x ~= before.x or pos.y ~= before.y then
                check('walk accepted by server', true, 'direction ' .. directions[i])
                shot('04-after-walk')
                scheduleEvent(function() pollStep(PNSmoke.logout) end, 2500)
            else
                tryWalk(i + 1)
            end
        end, 1200)
    end
    scheduleEvent(function() tryWalk(1) end, 2500)
end

function PNSmoke.logout()
    log('pokemonBarAdd=%d pokemonMoves=%d pokedexStatus=%d', counters.pokemonBarAdd, counters.pokemonMoves, counters.pokedexStatus)
    g_game.safeLogout()
end

local handlers = {
    onGameStart = function()
        log('onGameStart: feature GamePSoulProtocol=%s wire=%d protocol=%d client=%d os=%d', tostring(g_game.getFeature(GamePSoulProtocol)),
            g_game.getWireProtocolVersion(), g_game.getProtocolVersion(), g_game.getClientVersion(), g_game.getOs())
        check('PSoul profile active', g_game.getFeature(GamePSoulProtocol) and g_game.getWireProtocolVersion() == 312)
        scheduleEvent(afterWorld, 3000)
    end,
    onGameEnd = function()
        log('onGameEnd')
        check('logout', true)
        finish()
    end,
    onExtendedOpcodeEnabled = function()
        check('ACTIVATE (extended opcode 0) received', true)
    end,
    onLightHour = function(minutes)
        check('login light hour read', minutes >= 0 and minutes < 24 * 60, tostring(minutes))
    end,
    onChannelList = function(channels)
        check('0xAB channel list (U16 count)', #channels > 0, #channels .. ' channels')
    end,
    onPokemonBarAdd = function() counters.pokemonBarAdd = counters.pokemonBarAdd + 1 end,
    onPokemonMoves = function() counters.pokemonMoves = counters.pokemonMoves + 1 end,
    onPokedexStatus = function(status)
        counters.pokedexStatus = counters.pokedexStatus + 1
        log('pokedex status entries=%d', #status)
    end,
    onPollWindow = onPollWindow,
    onLoginError = function(msg)
        fail('login error: ' .. tostring(msg))
    end
}

local originalCreate

function PNSmoke.init()
    log('starting: account=%s character=%s', cfg.account, cfg.character)
    connect(g_game, handlers)

    originalCreate = CharacterList.create
    CharacterList.create = function(characters, account, otui)
        originalCreate(characters, account, otui)
        onCharacterListCreated(characters, account)
    end

    g_settings.set('last-used-character', cfg.character)
    g_settings.set('last-used-world', 'Cristal')

    scheduleEvent(function()
        local locales = modules.client_locales
        if locales then
            -- First run shows a language picker; close it without the module reload it triggers.
            if locales.localesWindow then
                locales.localesWindow:destroy()
                locales.localesWindow = nil
            end
            locales.setLocale(cfg.locale or 'en')
        end
        if not (modules.client_entergame and EnterGame) then
            return fail('client_entergame not loaded')
        end
        local root = g_ui.getRootWidget()
        root:recursiveGetChildById('accountNameTextEdit'):setText(cfg.account)
        root:recursiveGetChildById('accountPasswordTextEdit'):setText(cfg.password)
        shot('01-login')
        scheduleEvent(function() EnterGame.doLogin() end, 2500)
    end, 3000)

    scheduleEvent(function()
        if not finished then
            fail('timeout')
        end
    end, 75000)
end

function PNSmoke.terminate()
    disconnect(g_game, handlers)
    if originalCreate then
        CharacterList.create = originalCreate
    end
end

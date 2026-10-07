-- Server-wide EXP event (/doubleexp).
--
-- The active multiplier lives in C++ (getServerExpEventMultiplier / setServerExpEventMultiplier),
-- so every Lua interface sees the same value. It is applied once, after every other modifier:
--   trainer: Player::rateExperience (stage + extra EXP rate, stamina, then the event)
--   Pokemon: doPlayerPokemonAddExperience (level stage, x1.25, extra EXP rate, then the event)
-- A timed event is stored in GLOBAL_STORAGES.EXP_EVENT_* and written to `global_storage`
-- immediately, so it survives a crash or restart; ExpEvent.onStartup restores it.

ExpEvent = {}

local MAX_DURATION = 30 * 24 * 60 * 60
local MAX_MULTIPLIER = 10
local TIMER_MAX_DELAY = 60 * 60

local function saveState(multiplier, expiresAt)
	local stored = math.floor(multiplier * 100 + 0.5)
	setGlobalStorageValue(GLOBAL_STORAGES.EXP_EVENT_MULTIPLIER, stored)
	setGlobalStorageValue(GLOBAL_STORAGES.EXP_EVENT_EXPIRES_AT, expiresAt)

	local worldId = getConfigValue("worldId")
	db.executeQuery(string.format("REPLACE INTO `global_storage` (`key`, `world_id`, `value`) VALUES (%d, %d, '%d'), (%d, %d, '%d');",
		GLOBAL_STORAGES.EXP_EVENT_MULTIPLIER, worldId, stored,
		GLOBAL_STORAGES.EXP_EVENT_EXPIRES_AT, worldId, expiresAt))
end

local function loadState()
	local multiplier = tonumber(getGlobalStorageValue(GLOBAL_STORAGES.EXP_EVENT_MULTIPLIER)) or 0
	local expiresAt = tonumber(getGlobalStorageValue(GLOBAL_STORAGES.EXP_EVENT_EXPIRES_AT)) or 0
	if (multiplier <= 0 or expiresAt <= 0) then
		return nil
	end

	return multiplier / 100, expiresAt
end

function ExpEvent.formatMultiplier(multiplier)
	if (math.floor(multiplier) == multiplier) then
		return string.format("%dx", multiplier)
	end
	return (string.format("%.2f", multiplier):gsub("0+$", "")) .. "x"
end

function ExpEvent.getName(cid, multiplier)
	if (multiplier == 2) then
		return __L(cid, "Double")
	end
	return ExpEvent.formatMultiplier(multiplier)
end

-- "2 hours", "1 hour 30 minutes", "1 day"
function ExpEvent.formatDuration(cid, seconds)
	local units = {{86400, "day", "days"}, {3600, "hour", "hours"}, {60, "minute", "minutes"}}
	local parts = {}
	for _, unit in ipairs(units) do
		local amount = math.floor(seconds / unit[1])
		seconds = seconds % unit[1]
		if (amount > 0) then
			parts[#parts + 1] = string.format("%d %s", amount, __L(cid, amount == 1 and unit[2] or unit[3]))
		end
	end
	if (#parts == 0) then
		return string.format("%d %s", seconds, __L(cid, seconds == 1 and "second" or "seconds"))
	end
	return table.concat(parts, " ")
end

-- "1h 32m", "2d 4h", "45s"
function ExpEvent.formatRemaining(seconds)
	if (seconds < 60) then
		return string.format("%ds", math.max(seconds, 0))
	end

	local days, hours, minutes = math.floor(seconds / 86400), math.floor(seconds % 86400 / 3600), math.floor(seconds % 3600 / 60)
	local parts = {}
	if (days > 0) then parts[#parts + 1] = days .. "d" end
	if (hours > 0) then parts[#parts + 1] = hours .. "h" end
	if (minutes > 0 and days == 0) then parts[#parts + 1] = minutes .. "m" end
	return table.concat(parts, " ")
end

local function broadcast(buildMessage)
	for _, pid in ipairs(getPlayersOnline()) do
		doPlayerSendTextMessage(pid, MESSAGE_STATUS_WARNING, buildMessage(pid))
	end
end

-- Returns the active timed event as multiplier, expiresAt, or nil.
function ExpEvent.getActive()
	local multiplier, expiresAt = loadState()
	if (not multiplier or expiresAt <= os.time()) then
		return nil
	end
	return multiplier, expiresAt
end

function ExpEvent.getRemaining()
	local _, expiresAt = ExpEvent.getActive()
	return expiresAt and (expiresAt - os.time()) or 0
end

local function finish(announce)
	local multiplier = loadState()
	saveState(0, 0)
	setServerExpEventMultiplier()
	if (announce and multiplier) then
		broadcast(function(pid)
			return string.format(__L(pid, "The %s Experience Event has ended."), ExpEvent.getName(pid, multiplier))
		end)
	end
	print(string.format(">> Experience Event ended, multiplier back to %s.", ExpEvent.formatMultiplier(getServerExpEventMultiplier())))
end

-- Ends the stored event once its time is up. Safe to call at any time and from any interface.
function ExpEvent.check()
	local multiplier, expiresAt = loadState()
	if (multiplier and expiresAt <= os.time()) then
		finish(true)
		return false
	end
	return multiplier ~= nil
end

local function onTimer(expiresAt)
	local _, storedExpiresAt = loadState()
	if (storedExpiresAt ~= expiresAt) then
		return -- replaced or stopped since this timer was scheduled
	end

	if (not ExpEvent.check()) then
		return
	end
	ExpEvent.scheduleTimer(expiresAt)
end

-- addEvent delays are capped and re-armed, so long events never overflow the timer and a
-- stale timer (event replaced or stopped) does nothing. The expEventCheck globalevent is the
-- safety net for timers lost to /reload.
function ExpEvent.scheduleTimer(expiresAt)
	local delay = math.min(math.max(expiresAt - os.time(), 1), TIMER_MAX_DELAY)
	addEvent(onTimer, delay * 1000, expiresAt)
end

function ExpEvent.start(multiplier, seconds)
	if (type(multiplier) ~= "number" or multiplier <= 1 or multiplier > MAX_MULTIPLIER) then
		return false, string.format("Multiplier must be above 1 and at most %d.", MAX_MULTIPLIER)
	end
	if (type(seconds) ~= "number" or seconds < 60 or seconds > MAX_DURATION) then
		return false, "Duration must be between 1 minute and 30 days."
	end

	if (not setServerExpEventMultiplier(multiplier)) then
		return false, "The server rejected that multiplier."
	end

	local expiresAt = os.time() + seconds
	saveState(multiplier, expiresAt)
	ExpEvent.scheduleTimer(expiresAt)

	broadcast(function(pid)
		return string.format(__L(pid, "%s Experience Event is now active for %s!"), ExpEvent.getName(pid, multiplier), ExpEvent.formatDuration(pid, seconds))
	end)
	print(string.format(">> Experience Event started: %s for %d seconds.", ExpEvent.formatMultiplier(multiplier), seconds))
	return true
end

function ExpEvent.stop()
	if (not ExpEvent.getActive()) then
		return false
	end

	saveState(0, 0)
	setServerExpEventMultiplier()
	broadcast(function(pid)
		return __L(pid, "The Experience Event has been disabled.")
	end)
	print(">> Experience Event disabled manually.")
	return true
end

-- "Experience Event: 2x\nTime remaining: 1h 32m"
function ExpEvent.getStatusText(cid)
	ExpEvent.check()
	local multiplier, expiresAt = ExpEvent.getActive()
	if (multiplier) then
		return string.format(__L(cid, "Experience Event: %s\nTime remaining: %s"), ExpEvent.formatMultiplier(multiplier), ExpEvent.formatRemaining(expiresAt - os.time()))
	end

	local current = getServerExpEventMultiplier()
	if (current ~= 1) then
		return string.format(__L(cid, "Experience Event: %s\nTime remaining: permanent (server configuration)"), ExpEvent.formatMultiplier(current))
	end
	return __L(cid, "There is no Experience Event active.")
end

function ExpEvent.onLogin(cid)
	if (getServerExpEventMultiplier() ~= 1) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, ExpEvent.getStatusText(cid))
	end
end

function ExpEvent.onStartup()
	local multiplier, expiresAt = loadState()
	if (not multiplier) then
		return
	end

	if (expiresAt <= os.time()) then
		saveState(0, 0)
		print(">> Experience Event expired while the server was offline.")
		return
	end

	if (not setServerExpEventMultiplier(multiplier)) then
		saveState(0, 0)
		print(">> Experience Event had an invalid stored multiplier and was cleared.")
		return
	end

	ExpEvent.scheduleTimer(expiresAt)
	print(string.format(">> Experience Event restored: %s, %s remaining.", ExpEvent.formatMultiplier(multiplier), ExpEvent.formatRemaining(expiresAt - os.time())))
end

-- Accepts "2h", "30m", "1d", "1h30m", optionally with a multiplier token ("3x 2h").
-- Returns multiplier, seconds or nil, error.
function ExpEvent.parseCommand(param)
	local multiplier, seconds
	for token in param:lower():gmatch("%S+") do
		local value = token:match("^(%d+%.?%d*)x$")
		if (value) then
			if (multiplier) then
				return nil, "Only one multiplier is allowed."
			end
			multiplier = tonumber(value)
		else
			local total = 0
			local rest = token:gsub("(%d+)([dhm])", function(amount, unit)
				total = total + tonumber(amount) * (unit == "d" and 86400 or unit == "h" and 3600 or 60)
				return ""
			end)
			if (rest ~= "" or total == 0) then
				return nil, string.format("Invalid duration '%s'. Use e.g. 30m, 2h, 1d or 1h30m.", token)
			end
			if (seconds) then
				return nil, "Only one duration is allowed."
			end
			seconds = total
		end
	end

	if (not seconds) then
		return nil, "A duration is required, e.g. /doubleexp 2h."
	end
	return multiplier or 2, seconds
end

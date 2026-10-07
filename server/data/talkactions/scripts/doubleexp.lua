local USAGE = "Usage: /doubleexp <duration> | /doubleexp <multiplier>x <duration> | /doubleexp off | /doubleexp status\n" ..
	"Durations: 30m, 2h, 1d, 1h30m (1 minute to 30 days). Multiplier defaults to 2x, e.g. /doubleexp 3x 2h."

function onSay(cid, words, param, channel)
	param = param:trim():lower()
	if (param == "" or param == "help") then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, USAGE)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, ExpEvent.getStatusText(cid))
		return true
	end

	if (param == "status") then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, ExpEvent.getStatusText(cid))
		return true
	end

	if (param == "off" or param == "stop") then
		if (not ExpEvent.stop()) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "There is no timed Experience Event active.")
		end
		return true
	end

	local multiplier, seconds = ExpEvent.parseCommand(param)
	if (not multiplier) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, seconds .. "\n" .. USAGE)
		return true
	end

	local ok, err = ExpEvent.start(multiplier, seconds)
	if (not ok) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, err)
	end
	return true
end

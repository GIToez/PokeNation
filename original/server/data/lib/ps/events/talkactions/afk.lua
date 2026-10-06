local MIN_LENGHT = 5
local MAX_LENGHT = 50

function onSay(cid, words, param, channel)
  local afk = not getPlayerIsAfk(cid)
  
  if (afk and param ~= "") then
    if (string.len(param) < MIN_LENGHT) then
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your message must contain at least %s characters, please try again."), MIN_LENGHT))
      return true
      
    elseif (string.len(param) > MAX_LENGHT) then
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your message can't contain more than %s characters, please try again."), MAX_LENGHT))
      return true
    end
  end
  
  if (not param) then
    param = ""
  end
  
	setPlayerIsAfk(cid, afk, param)
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "AFK %s!"), (afk and "ON" or "OFF")))
	return true
end

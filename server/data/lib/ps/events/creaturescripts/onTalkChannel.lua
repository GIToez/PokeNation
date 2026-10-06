local SAY_HI = 'hi'

function onTalkChannel(cid, channelId, message)
    if (channelId == CHANNEL_WIKI_CHAT) then
        WikiChat.handler:processMessage(cid, message)
        return false -- Hide player message

    elseif (channelId == CHANNEL_HELP and message == SAY_HI) then
        doCreatureSay(cid, SAY_HI, TALKTYPE_SAY)
        return false -- Hide player message
    end

    return true
end
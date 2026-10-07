function onLeaveChannel(cid, channel, users)
    if (channel == CHANNEL_WIKI_CHAT) then
        WikiChat.handler:reset(cid)
    end

    return true
end
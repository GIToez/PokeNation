function onJoinChannel(cid, channelId, users)
	if(channelId == CHANNEL_GUILD) then
		local guildId = getPlayerGuildId(cid)
		if(guildId and guildId ~= 0) then
			local guildMotd = getGuildMotd(guildId)
			if(guildMotd and guildMotd ~= "") then
				addEvent(function(cid, guildMotd)
                        if (isCreature(cid)) then
                            doPlayerSendChannelMessage(cid, "",
								string.format(__L(cid, "Message of the Day: %s"), guildMotd), TALKTYPE_CHANNEL_W, CHANNEL_GUILD)
                        end
                    end, 150, cid, guildMotd)
			end
		end
	end

	return true
end

local GLOBALMESSAGES = {
	{
		"Never enter your account details on any website other than PokeNordic.com. The staff will never give away items or Pokemon."
	},
	{
		"Think twice before using any kind of bot or hack on your character. It will not be tolerated and your character will be deleted. Play fair."
	},
	{
		"Need information about the game? Visit: http://www.PokeNordic.com/blogCategories/1-tutorials"
	},
	{
		"Enjoying the game? Then start spreading the word! Invite your friends to play. You will have more fun and help keep the project alive!"
	},
	{
		"Never enter your account details on any website other than the official Pokenordic site (http://www.PokeNordic.com)! Take care of your account!"
	},
	{
		"Stay up to date with the latest tournament rounds on Pokenordic! Visit: http://www.PokeNordic.com/TournamentHistories/view"
	},
	{
		"Keep up with the news, share your opinion and take part in the development of the game! Visit: http://forum.PokeNordic.com/"
	},
	{
		"Want to leave a message, comment or suggestion for the Pokenordic developers? Visit: http://www.PokeNordic.com/accounts/sendFeedback"
	},
}

local MSGTYPES = {
	MESSAGE_STATUS_WARNING, --[[Red message in game window and in the console]]
	MESSAGE_EVENT_ADVANCE, --[[White message in game window and in the console]]
	MESSAGE_INFO_DESCR --[[Green message in game window and in the console]]
}

local LAST_MESSAGE_ID = 0
local LAST_TYPE_ID = 0

function onThink()
	local msgs = GLOBALMESSAGES[LAST_MESSAGE_ID + 1]
	if (msgs) then
		LAST_MESSAGE_ID = LAST_MESSAGE_ID + 1
	else
		msgs = GLOBALMESSAGES[1]
		LAST_MESSAGE_ID = 1
	end

	local msgtype = MSGTYPES[LAST_TYPE_ID + 1]
	if (msgtype) then
		LAST_TYPE_ID = LAST_TYPE_ID + 1
	else
		msgtype = MSGTYPES[1]
		LAST_TYPE_ID = 1
	end

	for i, msg in ipairs(msgs) do
		doBroadcastMessage(msg, msgtype)
	end
	return true
end

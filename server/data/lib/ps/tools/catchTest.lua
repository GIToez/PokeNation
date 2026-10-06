--[[
local function getCatchChance(cid, catchChance)
	local chanceMax = catchChance - getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) / 10

	if (chanceMax < 5) then
		chanceMax = 5
	end

	return math.random(1, chanceMax)
end

local function testCatch(tries, baseChance, cid)
	local i, pokeBallCatch, greatBallCatch, ultraBallCatch = 0, 0, 0, 0
	local pokeBall, greatBall, ultraBall = balls["poke"].empty, balls["great"].empty, balls["ultra"].empty

	for i = 1, tries do
		local catchChance = getCatchChance(cid, baseChance)

		if (catchChance <= getBallCatchRate("poke")) then
			pokeBallCatch = pokeBallCatch + 1
			lastnumber = catchChance
			randomize()
		end

		if (catchChance <= getBallCatchRate("great")) then
			greatBallCatch = greatBallCatch + 1
			lastnumber = catchChance
			randomize()
		end

		if (catchChance <= getBallCatchRate("ultra")) then
			ultraBallCatch = ultraBallCatch + 1
			lastnumber = catchChance
			randomize()
		end
	end

	return pokeBallCatch, greatBallCatch, ultraBallCatch
end

function onSay(cid, words, param, channel)
	local tmp1, tmp2, tmp3
	local pokeBallCatch, greatBallCatch, ultraBallCatch = 0, 0, 0

	for i = 1, 10 do
		tmp1, tmp2, tmp3 = testCatch(1000, param, cid)
		pokeBallCatch = pokeBallCatch + tmp1
		greatBallCatch = greatBallCatch + tmp2
		ultraBallCatch = ultraBallCatch + tmp3
	end


	local text = "\n========== CATCH RATE TEST ==========\n"
	text = text .. "Tries: 1000 x 10 with base chance: " .. param .. "\n"
	text = text .. "Catchs with pokeball = " .. pokeBallCatch .. "\n"
	text = text .. "Catchs with greatball = " .. greatBallCatch .. "\n"
	text = text .. "Catchs with ultraball = " .. ultraBallCatch .. "\n"
	text = text .. "========== END OF CATCH RATE TEST ========== \n"

	print(text)

	return true
end
]]
local function generateTest(triesPerBall, chance, randomFunction)
    for i = 0, 100 do
        randomize()
    end

    local file = io.open(LOGS_DIR .. "catch_test.out", "a+")
    if (not file) then
        log(LOG_TYPES.ERROR, "generateTest - Can't open file")
        return false
    end

    file:write("== Catch change test generated at ".. os.date("%a %b %d %X %Y", os.time()) .." ==\n")
    file:write("Tries per ball: ".. triesPerBall .." - Chance: ".. chance .." - Random function: "..
            (randomFunction == math.random and "default" or "custom") .. "\n")

    local balls = {{1, "poke"}, {2, "great"}, {3, "ultra"}}
    for _, ball in pairs(balls) do
        local caughts = 0
        for i = 1, triesPerBall do
            if (randomFunction(1, chance) <= ball[1]) then
                caughts = caughts + 1
            end
        end
        file:write("= Caughts with ".. ball[2] .." ball: ".. caughts .." (".. ((caughts / triesPerBall) * 100) .. "%)\n")
    end
    file:write("\n\n\n")
    file:close()
end

function onSay(cid, words, param, channel)
	param = string.explode(param, ",")
    generateTest(tonumber(param[1]), tonumber(param[2]), (param[3] == "custom" and getRandom or math.random))
	return true
end

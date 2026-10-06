local BUG_REPORT_LOG_DIR = LOGS_DIR .. "reports/"

function onReportBug(cid, comment)
    local logFile = io.open(BUG_REPORT_LOG_DIR .. tostring(getPlayerName(cid)) .. ".log", "a+")
    if (logFile) then
        local pos = getPlayerPosition(cid)
        logFile:write(string.concat("[", getPlayerName(cid), "][", os.date("%a %b %d %X %Y", os.time()),
            "][X: ", pos.x, ", Y:", pos.y, ", Z:", pos.z, "][", doConvertIntegerToIp(getPlayerIp(cid)),
            "] :\n", comment, "\n\n"))
        logFile:close()
    else
        log(LOG_TYPES.WARNING, string.concat("Unable to log bug report. (cid: ", cid, ", comment: ",
            comment, ")"))
    end
    doPlayerSendCancel(cid, "The report was sent, thank you!")
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.REPORT_BUG)
    return true
end
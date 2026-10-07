LOG_TYPES = {}
LOG_TYPES.INFO = 0 -- Informational messages
LOG_TYPES.WARNING = 1 -- Non-critical problems
LOG_TYPES.ERROR = 2 -- Major failures
LOG_TYPES.DEBUG = 3 -- Debugging
LOG_TYPES.PRINT = 4 -- Printing

local LOG_TYPE_NAME = {
	[LOG_TYPES.INFO] = "Info",
	[LOG_TYPES.WARNING] = "Warning",
	[LOG_TYPES.ERROR] = "Error",
    [LOG_TYPES.DEBUG] = "Debug",
    [LOG_TYPES.PRINT] = "Print"
}

local luaPrint = print

function log(logType, message, ...)
    local logFile = io.open(LOGS_DIR .. (LOG_TYPE_NAME[logType] or "Logger") .. " - " ..
            os.date("%d-%m-%Y", os.time()) .. ".log", "a+")
    if (logFile) then
        logFile:write("[".. LOG_TYPE_NAME[logType] .."][".. os.date("%a %b %d %X %Y", os.time()) .."]: "..
                message .."\n")
        for k, v in pairs({...}) do
            if (type(v) == "table") then
                for k2, v2 in pairs(v) do
                    logFile:write("    Var-Table" .. k .. " " .. k2 .. " : " .. tostring(v2))
                end
            else
                logFile:write("    Var " .. k .. " : " .. tostring(v))
            end
        end
        logFile:write("\n")
        logFile:close()
    else
        luaPrint("[Error]Unable to save log file:\n")
        luaPrint("... type: " .. LOG_TYPE_NAME[logType])
        luaPrint("... message: " .. message)
    end
end

function print(...)
    luaPrint(...)
    local msg = {}
    for k, v in pairs({...}) do
        msg[#msg + 1] = tostring(v)
        msg[#msg + 1] = "    "
    end
    log(LOG_TYPES.PRINT, table.concat(msg))
end


local skynet = require "skynet"
local http = require "http"
local cjson = require "cjson"
local const_game = require "const_game"

local __RUNTIME = skynet.getenv("runtime")
local M = {}

function M.log(format, ...)
    --skynet.error("["..skynet.time().."]"..string.format(format, ...).."\n")
    skynet.error(string.format(format, ...))
end

function M.ding(format, ...)
    skynet.error(string.format(format, ...))
    --生产环境才推送到钉钉
    if __RUNTIME == "PRD" then
        local ding_webhook = const_game.DING_WEBHOOK
        if ding_webhook and ding_webhook ~= "" then
            local data = {msgtype="text", text={content=table.concat({"[浠水打七]", string.format(format, ...)})}}
            http.post(ding_webhook, cjson.encode(data), true, {"Content-Type: application/json;charset=utf-8"})
        end
    end
end

return M
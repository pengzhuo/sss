---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by breeze.
--- DateTime: 2018/10/12 下午4:40
---
local skynet = require "skynet"
local socket = require "skynet.socket"
require "skynet.manager"
require "functions"


local CMD = {}

skynet.start(function()
    skynet.dispatch("lua", function(_, _, cmd, ...)
        local f = CMD[cmd]
        if f then
            f(...)
        else
            skynet.error("service_clienthandler invalid_cmd %s", cmd)
        end
    end)

    local fd = assert(socket.listen(skynet.getenv("wshost")))
    socket.start(fd , function(fd, addr)
        local agent = skynet.newservice("agent")
        skynet.send(agent, "lua", "start", fd, addr)
    end)

    skynet.register("watchdog")
end)
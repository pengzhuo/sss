---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by b_ree.
--- DateTime: 2019/2/18 16:05
---

local skynet = require "skynet"
local redis  = require "skynet.db.redis"
require "skynet.manager"
require "functions"

local db_pool = {}
local index, db_pool_size = 1, 10

local function getdb()
    local db = db_pool[index]
    index = index + 1
    if index > db_pool_size then
        index = 1
    end
    return db
end

local CMD = {}

function CMD.start(conf, sev_name)
    skynet.register(sev_name)
    for i = 1, db_pool_size do
        db_pool[i] = redis.connect {
            host = conf.host,
            port = conf.port,
            db   = conf.db,
            auth = conf.auth
        }
    end
end

skynet.start(function ()
    skynet.dispatch("lua", function (_, _, cmd, ...)
        --local f = assert(CMD[cmd])
        if cmd == "start" then
            skynet.ret(skynet.pack(CMD.start(...)))
        else
            local db = getdb()
            local f = assert(db[cmd])
            skynet.ret(skynet.pack(f(db, ...)))
        end
    end)
end)
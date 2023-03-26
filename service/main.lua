---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by breeze.
--- DateTime: 2018/10/12 下午4:40
---
local skynet = require "skynet"
local cjson = require "cjson"
local const_game = require "const_game"
local log = require "log"
require "functions"

skynet.start(function()
    skynet.error("Server start")

    if skynet.getenv("debugport") then
        skynet.newservice("console")
        skynet.newservice("debug_console", "127.0.0.1", skynet.getenv("debugport"))
    end

    --MySQL master
    local m_conf_tab = cjson.decode(skynet.getenv("db_mysql_master"))
    local db_mysql = skynet.newservice("db_mysql", "master")
    skynet.call(db_mysql, "lua", "start", m_conf_tab, ".mysql_master")

    --MySQL slave
    local s_conf_tab = cjson.decode(skynet.getenv("db_mysql_slave"))
    local idx = 1;
    for _, conf in pairs(s_conf_tab) do
        for _ = 1, skynet.getenv("mysql_snlua_num") do
            local db_mysql = skynet.newservice("db_mysql", "slave", idx)
            skynet.call(db_mysql, "lua", "start", conf, table.concat({".mysql_slave_", idx}))
            idx = idx + 1
        end
    end

    --Redis server
    local redis_conf_tab = cjson.decode(skynet.getenv("db_redis"))
    idx = 1;
    for _, conf in ipairs(redis_conf_tab) do
        for _ = 1, skynet.getenv("redis_snlua_num") do
            local db_redis = skynet.newservice("db_redis", idx)
            skynet.call(db_redis, "lua", "start", conf, table.concat({".db_redis_", idx}))
            idx = idx + 1
        end
    end

    --webclient
    idx = 1
    for _ = 1, skynet.getenv("webc_snlub_num") do
        local webc = skynet.newservice("webclient", idx)
        skynet.call(webc, "lua", "start", table.concat({".webclient_", idx}))
        idx = idx + 1
    end

    skynet.uniqueservice("room_mgr_server")
    skynet.uniqueservice("game_task_server")

    if const_game.SNAPSHOT then
        local recovery = skynet.newservice("recovery")
        skynet.call(recovery, "lua", "start")
    end

    skynet.uniqueservice("agent_mgr")
    skynet.uniqueservice("http_listener")

    skynet.uniqueservice("watchdog")

    require "functions"
    local card_type = require "games/card_type"
    dump(card_type.is_continue({0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e,}))

    log.ding("Xsdq Server started successfully.")
    skynet.exit()
end)
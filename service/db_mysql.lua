---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by b_ree.
--- DateTime: 2019/2/16 16:56
---

local skynet = require "skynet"
local mysql = require "skynet.db.mysql"
local log = require "log"
require "skynet.manager"
require "functions"
local cjson = require "cjson"

local heartbeat = true
local db_pool = {}
local index, db_pool_size = 1, 2
local CMD = {}

local function getdb()
    local db = db_pool[index]
    index = index + 1
    if index > db_pool_size then
        index = 1
    end
    return db
end

local function db_execute(db, sql)
    local ok, result = pcall(db.query, db, sql)
    if not ok then
        log.log("db query error!!!!")
        result = db:query(sql)
    end
    return result
end

function CMD.start(conf, sev_name)
    skynet.register(sev_name)

    local function on_connect(db)
        db:query("set charset utf8mb4")
    end

    for i = 1, db_pool_size do
        log.log("[%s] connect mysql:%s", sev_name, conf.host)
        local db = mysql.connect({
            host = conf.host,
            port = conf.port,
            database = conf.database,
            user = conf.user,
            password = conf.password,
            max_packet_size = 1024 * 1024,
            on_connect = on_connect
        })
        if not db then
            error("failed to mysql connect")
        else
            db_pool[i] = db
        end
    end

    if heartbeat then
        skynet.fork(function ()
            while true do
                skynet.sleep(20000)
                for _, v in pairs(db_pool) do
                    v:query("select 1")
                end
            end
        end)
    end
end

function CMD.query(sql)
    local db = getdb()
    local rs = db_execute(db, sql)
    if rs.errno then
        log.ding("[db_mysql err]%s SQL:[%s]", rs.err, sql)
        error(string.format("[db_mysql err]%s SQL:[%s]", rs.err, sql))
        --return false, rs.errno
    end
    return rs
end

--不带事务的多查询
--参数为要执行的多条sql
function CMD.multi_query(sql_table)
    local db = getdb()
    for _, sql in pairs(sql_table) do
        local rs = db_execute(db, sql)
        if rs.errno then
            --遇到mysql 1213 死锁错误码，则1秒后重试1次
            if rs.errno == 1213 then
                skynet.timeout(100, function ()
                    rs = db_execute(db, sql)
                    if rs.errno then
                        log.log("[db_mysql err: %s]Retry failure. %s SQL:[%s] ERR_SQL:[%s]", rs.errno, rs.err, cjson.encode(sql_table), sql)
                        log.ding("[db_mysql err: %s]Retry failure. %s SQL:[%s] ERR_SQL:[%s]", rs.errno, rs.err, cjson.encode(sql_table), sql)
                    else
                        log.log("[db_mysql.multi_query] errcode:1213 Retry scuess. SQL:[%s]", sql)
                        log.ding("[db_mysql.multi_query] errcode:1213 Retry scuess. SQL:[%s]", sql)
                    end
                end)
            else
                log.log("[db_mysql err: %s]%s SQL:[%s] ERR_SQL:[%s]", rs.errno, rs.err, cjson.encode(sql_table), sql)
                log.ding("[db_mysql err: %s]%s SQL:[%s] ERR_SQL:[%s]", rs.errno, rs.err, cjson.encode(sql_table), sql)
            end
        end
    end
    return true
end

--带事务的多查询
--参数为要执行的多条sql
--返回执行结果和错误码,只要其中一条执行出错，则回滚事务
function CMD.tran_query(sql_table)
    local db = getdb()
    local rs = db_execute(db, "begin")
    if rs.errno then
        return false, rs.errno
    end
    for _, sql in pairs(sql_table) do
        local rs = db_execute(db, sql)
        if rs.errno then
            db_execute(db, "rollback")
            log.ding("[db_mysql err: %s]%s SQL:[%s] ERR_SQL:[%s]", rs.errno, rs.err, cjson.encode(sql_table), sql)
            error(string.format("[db_mysql err: %s]%s SQL:[%s] ERR_SQL:[%s]", rs.errno, rs.err, cjson.encode(sql_table), sql))
        end
    end
    db_execute(db, "commit")
    return true
end

skynet.start(function ()
    skynet.dispatch("lua", function (_, _, cmd, ...)
        local f = assert(CMD[cmd])
        skynet.ret(skynet.pack(f(...)))
    end)
end)
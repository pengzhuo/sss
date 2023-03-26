---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by b_ree.
--- DateTime: 2018/11/29 21:32
---
local skynet = require "skynet"
local crypt = require "skynet.crypt"
local httpd = require "http.httpd"
local socketdriver = require "skynet.socketdriver"
local websocket = require "websocket"
local socket = require "skynet.socket"
local sockethelper = require "http.sockethelper"
local protopack = require "protopack"
local neturl = require "neturl"
local log = require "log"
local const_code = require "const_code"
local const_game = require "const_game"
local utils = require "utils"
require "functions"

local CMD = {}
local handler = {}

local client_ip
local agent_ws
local agent_msgid = 0
local agent_uid --玩家uid
local time_tick = 0   --用于检测长时间无心跳包，主动断开
local time_tick_flag = true
local task_num = 0 --用于记录是否有任务被挂起还未返回

local route_tbl = require "const_route_socket"  --路由配置
local room_server --房间服务

--清理工作及服务退出
local function skynet_exit()
    if agent_uid then
        skynet.send(".agent_mgr", "lua", "del", agent_uid, skynet.self())
    end
    if room_server then
        skynet.send(room_server, "lua", "offline", agent_uid, skynet.self())
    end
    client_ip = nil
    agent_ws = nil
    agent_uid = nil
    room_server = nil

    --如果当前有任务还在挂起，则延时退出服务
    if task_num > 0 then
        skynet.timeout(500, function ()
            skynet.exit()
        end)
    else
        skynet.exit()
    end
end

function handler.on_open(ws, url)
    agent_ws = ws
    agent_msgid = -1

    --是否有老的连接
    local old_agent = skynet.call(".agent_mgr", "lua", "get", agent_uid)
    if old_agent then
        --断开老的连接
        --skynet.send(old_agent, "lua", "send", const_proto.PUSH_MESSAGE, {type=const_game.MSG_KICK_ONLINE, msg=cjson.encode({notice="您已在别的设备登录！"})})
        skynet.timeout(10, function ()
            log.log("kick old connection. old_agent [%s]", skynet.address(old_agent))
            skynet.send(old_agent, "lua", "close")
        end)
    end
    --保存当前agent
    skynet.call(".agent_mgr", "lua", "set", agent_uid, skynet.self())

    skynet.fork(function ()
        while time_tick_flag do
            skynet.sleep(100)
            time_tick = time_tick + 1
            if time_tick > 15 then
                time_tick_flag = false
                log.log("aid[%d] ---> heart timeout, Server forced disconnect!", agent_uid or 0)
                CMD.close()
            end
        end
    end)
end

function handler.on_message(ws, buff)
    --skynet.error("on_message:"..buff)

    --半包，全包，粘包处理
    if ws._stick_package_stack then
        buff = ws._stick_package_stack .. buff
        ws._stick_package_stack = nil
    end

    local _size = protopack.getSize(buff)

    local _raw_size = #buff

    if _raw_size > _size then           --至少有一个包
        local _cmd, _msg = protopack.unpack(buff)
        CMD.handle(_cmd, _msg)

        local rest = string.sub(buff, _size + 1)
        handler.on_message(ws, rest)
    elseif _raw_size < _size then      --半包
        ws._stick_package_stack = buff
    elseif _raw_size == _size then     --整包
        local _cmd, _msg = protopack.unpack(buff)
        CMD.handle(_cmd, _msg)
    end
end

function handler.on_error(ws, msg)
    log.log("Client may be force closed. [%d]", agent_uid or 0)
    skynet_exit()
end

function handler.on_close(ws, code, reason)
    log.log("Client disconnected. [%d]", agent_uid or 0)
    skynet_exit()
end

-------------------------------------------------------------------------------------------------
function CMD.start(fd, addr)
    socket.start(fd)
    socketdriver.nodelay(fd)
    local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(fd), 8192)
    if code then
        local para = neturl.parse(url)
        if para.path == "/ws" and tonumber(para.query.app_id) == const_game.APP_ID and para.query.uuid and para.query.timestamp and para.query.key then
            if true or para.query.key == utils.to_hex(crypt.sha1(table.concat({para.query.uuid, para.query.timestamp, const_game.API_PRIVATE_KEY}))) then
                log.log("fd[%d], addr[%s], ws_url: %s", fd, addr, url)
                client_ip = header['x-real-ip'] or utils.get_ip(addr)
                agent_uid = tonumber(para.query.uuid)
                local ws = websocket.new(fd, addr, header, handler, nil, url)
                ws:start()
            else
                log.log("ws sign error.[%s]", addr)
                socket.close(fd)
                skynet.exit()
            end
        else
            log.log("ws Authentication failure.[%s]", addr)
            socket.close(fd)
            skynet.exit()
        end
    else
        log.log("Illegal connection.[%s]", addr)
        socket.close(fd)
        skynet.exit()
    end
end

function CMD.handle(cmd, msg)
    time_tick = 0 --重置定时器

    local route = assert(route_tbl[cmd], "command "..cmd.." route undefined")
    if not agent_uid then
        skynet_exit()
        return
    end

    task_num = task_num + 1
    local f = route["_c"][route["_m"]]
    CMD.send(route["_p"] or cmd, f(route["_c"], room_server, agent_uid, msg, client_ip))
    task_num = task_num - 1
end

--发送数据
function CMD.send(cmd, data)
    if agent_ws and data then
        agent_msgid = agent_msgid + 1
        local pack = protopack.pack(cmd, data, agent_msgid)
        agent_ws:send_binary(pack)
    end
end

--保存当前agent对应的房间服务
function CMD.set_room_server(server)
    room_server = server
end

--延时关闭连接(防止结算数据未发送成功)
function CMD.delay_close()
    skynet.timeout(10, function ()
        CMD.close()
    end)
end

--关闭连接
function CMD.close()
    if agent_ws then
        agent_ws:close()
        agent_ws = nil
    end
    skynet_exit()
end

skynet.start(function()
    skynet.dispatch("lua", function(_, _, cmd, ...)
        local f = CMD[cmd]
        if f then
            f(...)
        else
            log.log("service_clienthandler invalid_cmd %s", cmd)
        end
    end)
end)
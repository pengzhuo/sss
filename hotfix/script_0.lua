---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by b_ree.
--- DateTime: 2019/9/4 15:55
---
--- use example
--- inject :00000018 ../hotfix/script_0.lua
---
local skynet = require "skynet"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local cjson = require "cjson"
local user_model = require "user_model"
require "functions"

if not _P then
    print "fixbug error"
    return
end

local command = _P.lua.CMD

local function response(id, code, data, ...)
    local header = ... or {}
    header["Content-Type"] = "text/html; charset=UTF-8"
    header['Access-Control-Allow-Origin'] = '*'
    local ok, err = httpd.write_response(sockethelper.writefunc(id), code, data, header)
    if not ok then
        skynet.error(string.format("fd = %d, %s", id, err))
    end
end

command.test = function(_id, _data, _addr)
    local user_info = user_model:get_user_base_info_by_aid(tonumber(_data.aid))
    response(_id, 200, cjson.encode(user_info or {}))
end
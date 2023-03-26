root="../"
thread = 4
logger = nil
logger = "../logs/510k.log"
logpath = "."
harbor = 0
start = "main"  -- main script
bootstrap = "snlua bootstrap"   -- The service for bootstrap
luaservice = "../service/?.lua;../libs/service/?.lua;../business/?.lua"
lualoader = "../libs/lualib/loader.lua"
lua_path = "../lualib/?.lua;../libs/lualib/?.lua;../libs/lualib/?/init.lua;../business/?.lua;../controller/?.lua;../const/?.lua;../model/?.lua"
lua_cpath = "../luaclib/?.so;../libs/luaclib/?.so"
cpath = "../libs/cservice/?.so"
daemon = "../game.pid"
debugport = 8862  --debug_console
wshost = "0.0.0.0:8861"
httpport = 8860

db_mysql_master = '{"host":"119.23.16.104","port":3306,"user":"game","password":"fcxjddl_123_#@!","database":"dzhs"}'
db_mysql_slave = '[{"host":"119.23.16.104","port":3306,"user":"game","password":"fcxjddl_123_#@!","database":"dzhs"}]'
db_redis = '[{"host":"119.23.16.104","port":6379,"db":13,"auth":"Ems358Hxgames163"}]'

http_snlua_num = 2
mysql_snlua_num = 2
redis_snlua_num = 2
webc_snlub_num = 2

runtime = "DEV" -- "DEV"/"PRD"

APP_ID = 1
GAME_ID = 6
API_PRIVATE_KEY = "dzhs-uxixcd7u-r9gf-kwk8-lype"
LOBBY_API_HOST = "http://119.23.16.104:9901"
DING_WEBHOOK = "https://oapi.dingtalk.com/robot/send?access_token=c3f6903299db9714fecf2e5a93261e1bfde41b0857fc6b7d5bb7be8173b0036c"

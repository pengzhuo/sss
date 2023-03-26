root="../"
thread = 4
logger = nil
logger = "../logs/ddz.log"
logpath = "."
harbor = 0
start = "main"  -- main script
bootstrap = "snlua bootstrap"   -- The service for bootstrap
luaservice = "../service/?.lua;../libs/service/?.lua;../business/?.lua"
lualoader = "../libs/lualib/loader.lua"
lua_path = "../lualib/?.lua;../libs/lualib/?.lua;../libs/lualib/?/init.lua;../business/?.lua;../controller/?.lua;../const/?.lua"
lua_cpath = "$SKYNET_ROOT/luaclib/?.so"
cpath = "$SKYNET_ROOT/cservice/?.so"
daemon = "../game.pid"
debugport = 8852  --debug_console
wshost = "0.0.0.0:8851"
httpport = 8850

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
API_PRIVATE_KEY = "shanxi-oicnls8-pi32-zlia-li2n"
LOBBY_API_HOST = "http://119.23.16.104:9901"
DING_WEBHOOK = ""
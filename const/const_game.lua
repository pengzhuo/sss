---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by breeze.
--- DateTime: 2018/10/20 下午4:11
---
local skynet = require "skynet"
local M = {
    APP_ID                           = tonumber(skynet.getenv("APP_ID")),
    GAME_ID                          = tonumber(skynet.getenv("GAME_ID")),
    LOBBY_API_HOST                   = skynet.getenv("LOBBY_API_HOST"),
    API_PRIVATE_KEY                  = skynet.getenv("API_PRIVATE_KEY"), --外部API接口签名KEY
    DING_WEBHOOK                     = skynet.getenv("DING_WEBHOOK"), --钉钉机器人webhook
    ROOM_AUTO_DISMISS_TIME           = 600,         --未开始房间自动解散时间
    ROOM_START_AUTO_DISMISS_TIME     = 3600 * 2,    --已开始房间自动解散时间
    PB_NAMESPACE                     = "xsdq",      -- pb协议命名空间

    VOTE_TIME                        = 120, -- 投票时间

    SNAPSHOT                         = false, -- 是否启用快照功能
    SNAPSHOT_TIME                    = 30,   -- 每隔多少秒写一次快照

    --房间状态
    ROOM_STATS = {
        InitState            = 0,            --初始状态
        ReadyState           = 1,            --准备状态
        DealState            = 2,            --起手发牌状态
        DrawState            = 3,            --摸牌
        LordState            = 4,            --叫主
        BuryState            = 5,            --埋底
        RebelState           = 6,            --反主
        StepState            = 7,            --轮询状态
        SettleForRoundState  = 8,            --小结算状态
        SettleForRoomState   = 9,            --大结算状态
        CloseState           = 10,           --解散状态
    },

    --玩家状态
    PLAYER_STATS = {
        InitState            = 0,            --初始状态
        ReadyState           = 1,            --准备状态
        DealState            = 2,            --起手发牌状态
        LordState            = 3,            --叫主/反主状态
        StepState            = 4,            --轮询状态
        WaitState            = 5,            --等待状态
        SettleForRoundState  = 6,            --小结算状态
    },

    --REDIS_KEY_RECORD_ROUND     =     "record:%s:%s:%s",      --战绩REDIS KEY
    REDIS_KEY_SNAPSHOT_ROOM    =     table.concat({"game_", skynet.getenv("GAME_ID"), ":room:"}),             --快照房间信息REDIS KEY
    REDIS_KEY_SNAPSHOT_PLAYER  =     table.concat({"game_", skynet.getenv("GAME_ID"), ":player:"}),           --快照玩家信息REDIS KEY

    --解散房间结算状态
    SETTLE_ROOM_STATUS = {
        Normal     = 0,  --正常解散
        Vote       = 1,  --投票解散
        TimeOut    = 2,  --超时解散
        Robot      = 3,  --托管解散
        GM         = 4,  --GM解散
    }
}

return M
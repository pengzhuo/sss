---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by b_ree.
--- DateTime: 2019/11/15 10:00
---

local skynet = require "skynet"
local utils = require "utils"

local card_pool = {
    0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e,
    0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e,
    0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e,
    0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e,
}

local M = {}

M.type = {
    normal = {
        wt  = 1,        -- 五同       5张同种点数的牌型，例：A、A、A、A、A
        ths = 2,        -- 同花顺      同一花色的顺子，例：6、7、8、9、10（同花色）
        tz  = 3,        -- 铁支       4张相同+单张的牌型，例：J、J、J、J、8
        hl  = 4,        -- 葫芦       3张相同+一对的牌型，例：8、8、8、Q、Q
        th  = 5,        -- 同花       相同花色，例：Q、10、7、9、K（同花色）
        sz  = 6,        -- 顺子       连续的不同花色牌型，例：9、10、J、 Q、K（5张牌不是同一种花色），注：A~5的顺子是仅次于10~A的顺子
        st  = 7,        -- 三条       3张相同+两张单的牌型，例：Q、Q、Q、J、10
        ld  = 8,        -- 两对       两个对子+单张，例：6、6、7、7、8
        yd  = 9,        -- 一对       一个对子，例：K、K、7、8、9
        wl  = 10,       -- 乌龙       无法组成以上牌型，以点数决定大小，例：Q、J、7、K、6。（5张牌不是同一种花色）
    },
    special = {
        zzql    = 1,    -- 至尊青龙    A—K清一色顺子
        ytl     = 2,    -- 一条龙      A-K顺子
        sths    = 3,    -- 三同花顺    头道， 中道，尾道皆可配出同花顺牌型
        sftx    = 4,    -- 三分天下    三组铁支和任意单牌
        stst    = 5,    -- 四套三条    拥有四组三条
        ldb     = 6,    -- 六对半      13张牌中拥有6张对牌
        ssz     = 7,    -- 三顺子      头道，中道，尾道皆可配出顺子牌型
        sth     = 8,    -- 三同花      头道，中道，尾道皆可配出同花牌型
    },
}

function M.shuffle()
    --洗牌
    local cards = utils.random_array(card_pool)
    return cards
end

--得到牌面的点数
function M.get_card_value(card)
    return card & 0x0f
end

--得到牌面的花色
function M.get_card_color(card)
    return card >> 4;
end

--得到指定数量的组合
function M.combination(cards, cbntNumber)
    if cbntNumber > #cards then
        return nil
    end

    local assistArray = {}
    for i = 1, #cards do
        if i <= cbntNumber then
            assistArray[i] = 1
        else
            assistArray[i] = 0
        end
    end

    local cbntResult = {}

    local function getResult(astArray, srcArray, cbntResult)
        local oneOfCombination = {}
        for k,v in ipairs(astArray) do
            if v == 1 then
                table.insert(oneOfCombination, srcArray[k])
            end
        end

        table.insert(cbntResult, oneOfCombination)
    end

    getResult(assistArray, cards, cbntResult)

    local idx = 1
    while true do
        if assistArray[idx + 1] == nil then
            break
        end
        if assistArray[idx] == 1 and assistArray[idx + 1] == 0 then
            assistArray[idx] = 0
            assistArray[idx + 1] = 1

            for i = 1 , idx -1 do
                for j = i + 1, idx do
                    if assistArray[i] < assistArray[j] then
                        local mid = assistArray[i]
                        assistArray[i] = assistArray[j]
                        assistArray[j] = mid
                    end
                end
            end
            getResult(assistArray, cards, cbntResult)
            idx = 1
        else
            idx = idx + 1
        end
    end
    return cbntResult
end

--- 是否顺子
function M.is_continue(cards)
    local ret = true
    local arr = {}
    local have_a = false
    for _, v in pairs(cards) do
        local tmp = M.get_card_value(v)
        if tmp ~= 0xe then
            table.insert(arr, tmp)
        end
    end
    table.sort(arr, function(a, b)
        return a < b
    end)
    for i = 1, #arr-1 do
        if arr[i] ~= arr[i+1] - 1 then
            ret = false
            break
        end
    end
    if ret then
        if have_a then
            if not (arr[#arr] == 0xd or arr[1] == 0x2) then
                ret = false
            end
        end
    end
    return ret
end

--- 是否为同花
function M.is_the_same_color(cards)
    local ret = true
    local color = nil
    for _, v in pairs(cards) do
        if not color then
            color = M.get_card_color(v)
        else
            local tmp = M.get_card_color(v)
            if color ~= tmp then
                ret = false
                break
            end
        end
    end
    return ret
end

--- 根据花色分组
function M.split_by_color(cards)
    local ret = {}
    for _, v in pairs(cards) do
        local tmp = M.get_card_color(v)
        if not ret[tmp] then
            ret[tmp] = {}
        end
        table.insert(ret[tmp], v)
    end
    return ret
end

--- 根据值分组
function M.split_by_value(cards)
    local ret = {}
    for _, v in pairs(cards) do
        local tmp = M.get_card_value(v)
        if not ret[tmp] then
            ret[tmp] = {}
        end
        table.insert(ret[tmp], v)
    end
    return ret
end

function M.deal_cards(cards)
    local ret = {}
    for _, v in pairs(cards) do
        table.insert(ret, M.get_card_value(v))
    end
    return ret
end

function M.get_type(cards)
    if table.nums(cards) ~= 13 then
        return nil
    end
    
end

function M.is_zzql(cards)
    local ret = M.is_the_same_color(cards)
    if ret then
        ret = M.is_continue(cards)
    end
    return ret
end

function M.is_ytl(cards)
    local ret = M.is_continue(cards)
    return ret
end

function M.is_sths(cards)
    local ret = true
    local group = M.split_by_color(cards)
    local num = table.nums(group)
    if num > 3 then
        ret = false
    elseif num == 3 then
        for _, v in pairs(group) do
            local _num = table.nums(v)
            if _num == 3 or _num == 5 then
                if not M.is_continue(v) then
                    ret = false
                    break
                end
            else
                ret = false
                break
            end
        end
    elseif num == 2 then
        for _, v in pairs(group) do
            local _num = table.nums(v)
            table.sort(v, function(a, b) return a < b end)
            if _num == 3 or _num == 5 then
                if not M.is_continue(v) then
                    ret = false
                    break
                end
            elseif _num == 8 then
                if not M.is_continue({v[1], v[2], v[3]}) or not M.is_continue({v[4], v[5], v[6], v[7], v[8]}) then
                    ret = false
                    break
                end
            elseif _num == 10 then
                if not M.is_continue({v[1], v[2], v[3], v[4], v[5]}) or not M.is_continue({v[6], v[7], v[8], v[9], v[10]}) then
                    ret = false
                    break
                end
            else
                ret = false
                break
            end
        end
    else
        ret = false
    end
    return ret
end

function M.is_sftx(cards)
    local ret = true
    local group = M.split_by_value(cards)
    local num = table.nums(group)
    if num == 4 then
        local index = 0
        for _, v in pairs(group) do
            if #v == 4 then
                index = index + 1
            end
        end
        if index ~= 3 then
            ret = false
        end
    else
        ret = false
    end
    return ret
end

function M.is_stst(cards)
    local ret = true
    local group = M.split_by_value(cards)
    local num = table.nums(group)
    if num == 4 then
        local index = 0
        for _, v in pairs(group) do
            if #v == 3 then
                index = index + 1
            end
        end
        if index ~= 4 then
            ret = false
        end
    else
        ret = false
    end
    return ret
end

function M.is_ldb(cards)
    local ret = true
    local group = M.split_by_value(cards)
    local index = 0
    for _, v in pairs(group) do
        local num = table.nums(v)
        if num > 1 then
            index = index + (num // 2)
        end
    end
    if index ~= 6 then
        ret = false
    end
    return ret
end

function M.is_ssz(cards)
    local ret = true
    local arr = M.deal_cards(cards)
    table.sort(arr, function(a, b) return a < b end)

    local tmp_arr = {
        [1] = {},
        [2] = {},
        [3] = {},
    }

    for i = 1, #arr do
        local flag = false
        for j = 1, #tmp_arr do
            if #tmp_arr[j] < 5 then
                if #tmp_arr[j] == 0 then
                    table.insert(tmp_arr[j], arr[i])
                    flag = true
                    break
                elseif arr[i] - tmp_arr[j][#tmp_arr[j]] == 1 then
                    table.insert(tmp_arr[j], arr[i])
                    flag = true
                    break
                elseif arr[i] == 0xe and tmp_arr[j][1] == 0x2 then
                    table.insert(tmp_arr[j], 1, arr[i])
                    flag = true
                    break
                end
            end
        end
        if not flag then
            ret = false
            break
        end
    end

    return ret
end

function M.is_sth(cards)
    local ret = true
    local group = M.split_by_color(cards)
    local num = table.nums(group)
    if num > 3 then
        ret = false
    elseif num == 3 then
        for _, v in pairs(group) do
            local _num = table.nums(v)
            if _num ~= 3 and _num ~= 5 then
                ret = false
                break
            end
        end
    elseif num == 2 then
        for _, v in pairs(group) do
            local _num = table.nums(v)
            if _num ~= 3 and _num ~= 5 and _num ~= 8 and _num ~= 10 then
                ret = false
                break
            end
        end
    else
        ret = false
    end
    return ret
end

return M
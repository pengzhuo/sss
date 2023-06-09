---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by b_ree.
--- DateTime: 2019/11/16 16:28
---

local COLORS = {"♠","♥","♣","♦"}
--local COLORS = {"黑","红","梅","方"}
local VALUES = {"","2","3","4","5","6","7","8","9","10","J","Q","K","A","","","g","G","BK","RK"}

local skynet = require "skynet"
local card_type = require "games/card_type"
local utils = require "utils"

local M = {}

---@public 将协议中的牌转换成可计算的牌
function M.conv_cards(_cards)
    local cards = {}
    for i, v in pairs(_cards) do
        cards[i] = v.card
    end
    return cards
end

---@public 将牌转换为协议中的牌
function M.reconv_cards(_cards)
    local cards = {}
    for i, v in pairs(_cards) do
        cards[i] = {card=v}
    end
    return cards
end

---@public 得到牌的类型
---@param _discard table 牌数据
---@param _lord_color number 主花色
function M.get_card_type(_discard, _lord_color)
    return card_type.get_type(_discard, _lord_color)
end

---@public 手牌中是否存在要打出的牌
function M.have_card(_cards, _hand_cards)
    local total = 0
    local hc_clone = utils.clone(_hand_cards)
    for _, v in pairs(_cards) do
        for i, j in pairs(hc_clone) do
            if v.card == j then
                table.remove(hc_clone, i)
                total = total + 1
                break
            end
        end
    end
    if table.nums(_cards) == total then
        return true
    else
        return false
    end
end

---@public 手牌中有指定花色的副牌多少张
---@param _hand_cards table
---@param _c number 黑1,红2,梅3,方4
---@return number
function M.has_aux_total_by_color(_hand_cards, _c)
    local total = 0
    for _, v in pairs(_hand_cards) do
        if card_type.get_card_color(v) == _c and card_type.get_card_index(v) ~= 7 then
            total = total + 1
        end
    end
    return total
end

---@public 指定牌中有主牌多少张
---@param _hand_cards table
---@param _lord_color number 红王128,蓝王64,大王32,小王16,黑8,红4,梅2,方1
---@return number
function M.has_lord_total(_hand_cards, _lord_color)
    local total = 0
    local c, p
    for _, v in pairs(_hand_cards) do
        c = card_type.get_card_color(v)
        p = card_type.get_card_index(v)
        if (1<<4-c) == _lord_color or p == 7 or p > 15 then
            total = total + 1
        end
    end
    return total
end

---@public 牌是否能打出去
---@param _hand_cards table 手牌
---@param _discard table 要打出的牌
---@param _base_card_type table 本轮首出牌型
---@param _lord_color number 主花色
---@return boolean, table
function M.can_discard(_hand_cards, _discard, _base_card, _base_card_type, _lord_color)
    local out_cards = M.conv_cards(_discard)
    local c_type = M.get_card_type(out_cards, _lord_color)
    --dump(_base_card_type, "首出牌型")
    --dump(c_type, "压牌牌型")

    --首出副，花色检测
    if _base_card_type.l == 0 then
        local base_color = card_type.get_card_color(_base_card[1]) --首出花色
        --本次出牌包含首出花色的张数
        local num = M.has_aux_total_by_color(out_cards, base_color)
        if num < #out_cards then
            --垫牌
            if M.has_aux_total_by_color(_hand_cards, base_color) > num then
                print("垫牌不合规,你还有副花色", base_color)
                return false
            end
        end
    else --首出主，花色检测
        local num = M.has_lord_total(out_cards, _lord_color)
        if num < #out_cards then
            --垫牌
            if M.has_lord_total(_hand_cards, _lord_color) > num then
                print("垫牌不合规,你还有主花色", _lord_color)
                return
            end
        end
    end

    --如果为垫牌，则判断是否合规
    if not c_type or c_type.t ~= _base_card_type.t then
        if _base_card_type.t == card_type.type.t_akk or _base_card_type.t == card_type.type.t_aak then
            --如果首出为边三轮(首出一定为副)必须出对子或手上无对子
            local base_color = card_type.get_card_color(_base_card[1]) --首出花色
            local counts, _ = card_type.split_card(M.filter_card_by_color(_hand_cards, base_color))
            local counts_d, _ = card_type.split_card(M.filter_card_by_color(out_cards, base_color))
            if counts_d[2] ~= 1 and counts[2] == 1 then
                print("首出副边三轮，有对子必须出.")
                return
            end
        elseif _base_card_type.t == card_type.type.t_akkn or _base_card_type.t == card_type.type.t_aakn then
            --如果首出为多边三轮(首出一定为副)必须出对子或手上无对子
            local base_color = card_type.get_card_color(_base_card[1]) --首出花色
            local counts, _ = card_type.split_card(M.filter_card_by_color(_hand_cards, base_color))
            local counts_d, _ = card_type.split_card(M.filter_card_by_color(out_cards, base_color))
            if not counts_d[2] then counts_d[2] = 0 end
            if not counts[2] then counts[2] = 0 end
            if counts_d[2] < _base_card_type.n and counts[2] > 0 and (counts[2] - counts_d[2]) > 0 then --打出的对子小于首出牌型的对子数，且手牌还留了对子
                print("首出副多边三轮，有对子必须出.")
                return
            end
        elseif _base_card_type.t == card_type.type.t_2n then --拖拉机
            local counts, counts_d
            if _base_card_type.l == 0 then
                local base_color = card_type.get_card_color(_base_card[1]) --首出花色
                counts = card_type.split_card(M.filter_card_by_color(_hand_cards, base_color))
                counts_d = card_type.split_card(M.filter_card_by_color(out_cards, base_color))
            else
                counts = card_type.split_card(M.filter_card_by_lord(_hand_cards, _lord_color))
                counts_d = card_type.split_card(M.filter_card_by_lord(out_cards, _lord_color))
            end
            if not counts_d[2] then counts_d[2] = 0 end
            if not counts[2] then counts[2] = 0 end
            if counts_d[2] < _base_card_type.n and counts[2] > 0 and (counts[2] - counts_d[2] > 0) then --打出的对子小于首出牌型的对子数，且手牌还留了对子
                print("首出拖拉机，有对子必须出.")
                return
            end
        elseif _base_card_type.t == card_type.type.t_2 then --对子
            local counts, counts_d
            if _base_card_type.l == 0 then
                local base_color = card_type.get_card_color(_base_card[1]) --首出花色
                counts = card_type.split_card(M.filter_card_by_color(_hand_cards, base_color))
                counts_d = card_type.split_card(M.filter_card_by_color(out_cards, base_color))
            else
                counts = card_type.split_card(M.filter_card_by_lord(_hand_cards, _lord_color))
                counts_d = card_type.split_card(M.filter_card_by_lord(out_cards, _lord_color))
            end
            if not counts_d[2] then counts_d[2] = 0 end
            if not counts[2] then counts[2] = 0 end
            if counts_d[2] < 1 and counts[2] > 0 then --打出的对子小于首出牌型的对子数，且手牌有大于首出牌型的对子数
                print("首出对子，有对子必须出.")
                return
            end
        end
    end

    return true
end

---@public 得到指定副花色的牌
function M.filter_card_by_color(_cards, _color)
    local tb = {}
    local c, p
    for _, v in pairs(_cards) do
        c = card_type.get_card_color(v)
        p = card_type.get_card_index(v)
        if p ~= 7 and c > 0 and c == _color then
            tb[#tb+1] = v
        end
    end
    return tb
end

---@public 得到指定牌中的主牌
---@param _cards table
---@param _lord_color number 方1,梅2,红4,黑8,小王16,大王32,蓝王64,红王128
---@return table
function M.filter_card_by_lord(_cards, _lord_color)
    local tb = {}
    local c, p
    for _, v in pairs(_cards) do
        c = card_type.get_card_color(v)
        p = card_type.get_card_index(v)
        if _lord_color <= 8 then
            if 1 << 4-c == _lord_color or c == 0 or p == 7 then
                tb[#tb+1] = v
            end
        else
            if c == 0 or p == 7 then
                tb[#tb+1] = v
            end
        end
    end
    return tb
end

---@private tbl中是否有比min大并且连续size次的值
function M._has_link_num(tbl, min, size)
    local list, len = {}, 0
    for _, v in pairs(tbl) do
        if v >= 15 then
            return false --2，小王，大王不能连
        end
        if v > min then --大于被压的最小牌
            len = #list+1
            list[len] = v
            if len > 1 then
                if v - list[len-1] == 1 then
                    if len >= size then
                        return true
                    end
                else
                    list = {v}
                end
            end
        end
    end
    return false
end

--根据规则得到1张可以出的牌
function M.get_one_card(_cards)
    local counts, cards = card_type.split_card(_cards)
    if counts[1] > 0 then
        return cards[1][#cards[1]]
    else
        return _cards[1]
    end
end

---@private
function M.get_card_by_value(cards, val, num)
    local rs = {}
    local n = 0
    for i, v in pairs(cards) do
        if v == val then
            cards[i] = nil
            table.insert(rs, v)
            n = n + 1
            if n == num then
                break
            end
        end
    end
    local tb = {}
    for _, v in pairs(cards) do
        table.insert(tb, v)
    end
    return rs, tb
end

--根据规则得到一张可以出的牌以拼凑成一手可以出的牌
function M.get_robot_card_one(_lord_color, _hand_cards, _base_card_type, _base_cards)
    local rs = {}
    local hand_cards = utils.clone(_hand_cards)
    local priority_cards = {} --优先选的牌
    if _base_card_type.l == 1 then
        priority_cards = M.filter_card_by_lord(hand_cards, _lord_color)
    else
        priority_cards = M.filter_card_by_color(hand_cards, card_type.get_card_color(_base_cards[1]))
    end
    if #priority_cards > 0 then
        table.sort(priority_cards, function(a, b) return card_type.get_card_index(a) > card_type.get_card_index(b) end)
        rs, priority_cards = M.get_card_by_value(priority_cards, priority_cards[1], 1)
        table.removebyvalue(hand_cards, rs[1])
    end
    if #rs < 1 then
        table.sort(hand_cards, function(a, b) return card_type.get_card_index(a) > card_type.get_card_index(b) end)
        rs, hand_cards = M.get_card_by_value(hand_cards, hand_cards[1], 1)
    end
    return rs, hand_cards
end

--根据规则得到2张可以出的牌以拼凑成一手可以出的牌
function M.get_robot_card_two(_lord_color, _hand_cards, _base_card_type, _base_cards)
    local rs = {}
    local hand_cards = utils.clone(_hand_cards)
    local priority_cards = {} --优先选的牌
    if _base_card_type.l == 1 then
        priority_cards = M.filter_card_by_lord(hand_cards, _lord_color)
    else
        priority_cards = M.filter_card_by_color(hand_cards, card_type.get_card_color(_base_cards[1]))
    end
    local counts, cards = card_type.split_card(priority_cards)
    if counts[2] > 0 then
        rs, priority_cards = M.get_card_by_value(priority_cards, cards[2][1], 2)
        table.removebyvalue(hand_cards, rs[1], true)
    else
        local rs1
        for _ = 1, 2 do
            rs1, priority_cards = M.get_robot_card_one(_lord_color, priority_cards, _base_card_type, _base_cards)
            table.insert(rs, rs1[1])
            table.removebyvalue(hand_cards, rs1[1])
        end
    end
    if #rs < 2 then
        local rs1
        for i = 1, 2-#rs do
            rs1, hand_cards = M.get_robot_card_one(_lord_color, hand_cards, _base_card_type, _base_cards)
            table.insert(rs, rs1[1])
        end
    end
    return rs, hand_cards
end

---@public 根据上下文得到托管要出的牌
function M.get_robot_cards(_lord_color, _hand_cards, _base_card_type, _base_cards)
    local hand_cards = utils.clone(_hand_cards)
    local rs = {}
    if not _base_card_type then
        rs[1] = M.get_one_card(hand_cards)
    else
        local r = {}
        if _base_card_type.t == card_type.type.t_1 then
            rs, hand_cards = M.get_robot_card_one(_lord_color, hand_cards, _base_card_type, _base_cards)
        elseif _base_card_type.t == card_type.type.t_2 or _base_card_type.t == card_type.type.t_2n then
            for _ = 1, _base_card_type.n or 1 do
                r, hand_cards = M.get_robot_card_two(_lord_color, hand_cards, _base_card_type, _base_cards)
                table.insertto(rs, r)
            end
        elseif _base_card_type.t == card_type.type.t_aak or _base_card_type.t == card_type.type.t_akk
                or _base_card_type.t == card_type.type.t_aakn or _base_card_type.t == card_type.type.t_akkn then
            for _ = 1, _base_card_type.n or 1 do
                r, hand_cards = M.get_robot_card_two(_lord_color, hand_cards, _base_card_type, _base_cards)
                table.insertto(rs, r)
            end
            r, hand_cards = M.get_robot_card_one(_lord_color, hand_cards, _base_card_type, _base_cards)
            table.insertto(rs, r)
        end
    end
    return rs
end

--将牌面花色，点数显示成易于阅读的字符串
function M.cards_tostring(_cards)
    local show_tb = {}
    local c, v
    for i, card in pairs(_cards) do
        c = card_type.get_card_color(card)
        v = card_type.get_card_index(card)
        if c == 0 then
            show_tb[i] = VALUES[v]
        else
            show_tb[i] = table.concat({COLORS[c], VALUES[v]})
        end
    end
    return table.concat(show_tb, ",")
end

return M
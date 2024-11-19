local talent = {  }
local spell = {  }
local buff = {  }
local item = {  }
local color = {  }

local f = CreateFrame("Frame", nil, UIParent)
--f:SetPoint("CENTER")
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0) -- 设置到左上角
f:SetSize(32, 32)

f.tex = f:CreateTexture()
f.tex:SetAllPoints()
--f.tex:SetColorTexture(0, 0, 0, 1)

local textBox = CreateFrame("Frame", nil, UIParent)
textBox:SetPoint("TOPLEFT", f, "TOPRIGHT", 0, 0) -- 放置在图标右侧
textBox:SetSize(512, 32)
local text = textBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("LEFT", textBox, "LEFT", 0, 0)
text:SetFont("Fonts\\FRIZQT__.TTF", 24, nil)
--text:SetText("这是一个文本框")
f:RegisterEvent("UNIT_COMBAT")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PLAYER_ENTER_COMBAT")

f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_STARTED_MOVING")
f:RegisterEvent("PLAYER_STOPPED_MOVING")
f:RegisterEvent("PLAYER_TOTEM_UPDATE")
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_SPELLCAST_START")
f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:RegisterEvent("UNIT_SPELLCAST_FAILED")
f:RegisterEvent("UNIT_SPELLCAST_STOP")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE")
f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
f:RegisterEvent("UNIT_POWER_UPDATE")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterUnitEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
f:RegisterUnitEvent("AZERITE_ESSENCE_ACTIVATED")
f:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterUnitEvent("TRAIT_CONFIG_UPDATED")
f:RegisterUnitEvent("UI_ERROR_MESSAGE")
f:RegisterEvent("LOADING_SCREEN_ENABLED")
f:RegisterEvent("LOADING_SCREEN_DISABLED")

local function convertToRGB(number)
    -- 确保输入数字在有效范围内
    --number = tonumber(number)
    --print(number)
    if number < 0 or number > 16777216 then
        print("输入数字无效" .. number)
        return
    end

    -- 将输入数字转换为RGB分量
    local r = math.floor(number / 65536)
    local g = math.floor((number % 65536) / 256)
    local b = number % 256

    -- 返回RGB分量
    return r, g, b
end

local last_title = 0
local function SetTitleAndColor(title, r, g, b)
    ----如果和上一个相同，则不更新颜色
    --if last_title == title then
    --    return
    --end
    --last_title = title
    f.tex:SetColorTexture(r, g, b, 1)
    text:SetText(title)
end

local SetTC = SetTitleAndColor

local function SetTitleBySpellColor(spell_name, title)
    local spell_id = spell[spell_name]
    if spell_id == nil then
        print("没有找到法术ID: " .. spell_name)
        return false
    end
    --print("法术ID: " .. spell_id)
    local r, g, b = convertToRGB(spell_id)
    --print(r,g,b)
    return SetTitleAndColor(title, r / 255, g / 255, b / 255)
end

SetSC = SetTitleBySpellColor

local function SetTitleBySpellID(spell_id, title)
    local r, g, b = convertToRGB(spell_id)
    --print(r,g,b)
    return SetTitleAndColor(title, r / 255, g / 255, b / 255)
end


---


-- 通用技能
spell["global_cooldown"] = 61304
spell["GCD"] = 61304
-- 防骑技能
spell["奉献"] = 26573
spell["祝福之锤"] = 204019
spell["审判"] = 275779
spell["复仇者之盾"] = 31935
spell["责难"] = 96231
spell["清毒术"] = 213644
spell["神圣军备"] = 432459
spell["圣洁鸣钟"] = 375576
spell["愤怒之锤"] = 24275
spell["荣耀圣令"] = 85673
spell["制裁之锤"] = 853
spell["圣盾术"] = 642
spell["保护祝福"] = 1022
spell["提尔之眼"] = 387174
spell["炽热防御者"] = 31850
spell["戍卫"] = 389539
spell["正义盾击"] = 53600
-- 血迪凯技能
spell["死神的抚摩"] = 195292
spell["精髓分裂"] = 195182
spell["死神印记"] = 439843
spell["灵界打击"] = 49998
spell["心灵冰冻"] = 47528
spell["血液沸腾"] = 50842
spell["枯萎凋零"] = 43265
spell["吞噬"] = 274156
spell["吸血鬼之血"] = 136168
spell["符文刃舞"] = 49028
spell["墓石"] = 219809
spell["心脏打击"] = 206930
spell["亡者复生"] = 46585
spell["白骨风暴"] = 194844

-- 防骑buff
buff["正义盾击"] = 132403
buff["奉献"] = 188370
buff["圣洁武器"] = 432502
buff["神圣壁垒"] = 432496
buff["闪耀之光"] = 327510
buff["闪耀之光2"] = 182104
buff["圣盾术"] = 642
buff["保护祝福"] = 1022
buff["炽热防御者"] = 31850
buff["戍卫"] = 389539
buff["信仰壁垒"] = 385724
buff["信仰圣光"] = 379041
-- 血迪凯 buff
buff["白骨之盾"] = 195181
buff["血之疫病"] = 55078
buff["枯萎凋零"] = 188290
buff["赤色天灾"] = 81141
buff["吸血鬼之血"] = 55233
buff["破灭"] = 441416
-- 副本
buff["抓握之血"] = 432031

-- 血迪凯天赋
talent["死神印记"] = 439843
talent["冷面死神"] = 434905
talent["吸血鬼打击"] = 433901

---- 爆发控制

local burst_time = GetTime()
local burst_status = false

local function IsBurst()
    return GetTime() <= burst_time
end

local function SetBurst(time)
    burst_time = GetTime() + time
end

local function ClearBurst()
    burst_time = GetTime() - 30
end

local function HandleEntryBurst()

    if Hekili.DB.profile.toggles.cooldowns.value == false then
        Hekili:FireToggle("cooldowns")
    end
    if Hekili.DB.profile.toggles.essences.value == false then
        Hekili:FireToggle("essences")
    end

end

local function HandleLevelBurst()
    if Hekili.DB.profile.toggles.cooldowns.value == true then
        Hekili:FireToggle("cooldowns")
    end
    if Hekili.DB.profile.toggles.essences.value == true then
        Hekili:FireToggle("essences")
    end
end

function ManualBurst(time)
    burst_status = true
    burst_time = GetTime() + time
    HandleEntryBurst()
end

local in_combat = false
-- 奉献计时器
local feng_xian_timer = 0

-- 打断优先清单
local interrupt_priority_list = {
    322938, -- 仙林,收割精魂
    323057, -- 仙林,BOSS1
    324776, -- 仙林,木棘外壳
    324914, -- 仙林,滋养森林
    321828, -- 仙林,拍手手
    326046, -- 仙林,模拟抗性
    340544, -- 仙林,再生鼓舞
    443430, -- 千丝之城, 流丝缠缚
    443443, -- 千丝之城, 扭曲思绪
    446086, -- 千丝之城, 虚空之波
    434793, -- 回响之城, 共振弹幕
    434802, -- 回响之城, 惊惧尖鸣
    448248, -- 回响之城, 恶臭齐射
    433841, -- 回响之城, 毒液剑雨
    451871, -- 格瑞姆巴托,剧烈震颤
    76711, -- 格瑞姆巴托,灼烧心智
    451224, -- 格瑞姆巴托,暗影烈焰笼罩
    431309, -- 破晨号,诱捕暗影
    450756, -- 破晨号,深渊嗥叫
    431333, -- 破晨号,折磨射线
    432520, -- 破晨号,暗影屏障
    449455, -- 矶石宝库,咆哮恐惧
    445207, -- 矶石宝库,穿透哀嚎
    429545, -- 矶石宝库,噤声齿轮
    429109, -- 矶石宝库,愈合金属
    430097, -- 矶石宝库,融铁之水
    256957, -- 围攻伯拉勒斯,防水甲壳
    454440, -- 围攻伯拉勒斯,恶臭喷吐
    272571, -- 围攻伯拉勒斯,窒息之水
    334748, -- 通灵战潮,排干体液
    320462, -- 通灵战潮,通灵箭
    324293, -- 通灵战潮,刺耳尖啸
    327127, -- 通灵战潮,修复血肉
    462802     -- 主机觉醒,净化烈焰
}

-- 焦点判断函数
-- 如果有焦点，返回焦点，否则返回目标。

local function GetFocusOrTargetEnemy()
    if UnitExists("focus") and UnitCanAttack("player", "focus") then
        return "focus"
    elseif UnitExists("target") and UnitCanAttack("player", "target") then
        return "target"
    else
        return nil
    end

end


-- 焦点或目标的打断是否值得打断的判断函数。

local function IsCastInterruptable(target)

    if target == nil then
        return false
    end


    -- 如果目标没在施法，则判断是否在通道读条，都不是返回false
    name, _, _, startTimeMs, endTimeMs, _, _, uninterruptible, T_spellId = UnitCastingInfo(target)
    if T_spellId == nil then
        name, _, _, startTimeMs, endTimeMs, _, uninterruptible, T_spellId, _, _ = UnitChannelInfo(target)
        -- 如果目标没在施法，返回false
        if T_spellId == nil then
            return false
        end
    end

    -- 施法无法被打断，则返回false
    if uninterruptible then
        return false
    end

    -- 如果施法的spellId在白名单列表中，true
    for _, v in ipairs(interrupt_priority_list) do
        if v == T_spellId then
            return true
        end
    end

    return false
end -- IsInterruptable

local function AnyInterruptable(target)
    if target == nil then
        return false
    end


    -- 如果目标没在施法，则判断是否在通道读条，都不是返回false
    name, _, _, startTimeMs, endTimeMs, _, _, uninterruptible, T_spellId = UnitCastingInfo(target)
    if T_spellId == nil then
        name, _, _, startTimeMs, endTimeMs, _, uninterruptible, T_spellId, _, _ = UnitChannelInfo(target)
        -- 如果目标没在施法，返回false
        if T_spellId == nil then
            return false
        end
    end

    -- 施法无法被打断，则返回false
    if uninterruptible then
        return false
    end

    return true
end

-- 尖刺判断


-- 80%减伤清单
-- /dump DamageReduction()
local function DamageReduction()
    local damage_spell_list = {
        320655, --通灵 凋骨
        424888, -- 宝库 老1
        428711, -- 宝库 老3
        434722, -- 千丝 老1
        441298, -- 千丝 老2
        461842, -- 千丝 老3
        447261, -- 拖把 老1
        449444, -- 拖把 老2
        450100, -- 拖把 老4
        453212, -- 破晨 老1
        427001, -- 破晨 老2
        438471, -- 回响 老1
        8690           -- 炉石
    }
    name, _, _, startTimeMs, endTimeMs, _, _, uninterruptible, T_spellId = UnitCastingInfo("target")

    if T_spellId == nil then
        name, _, _, startTimeMs, endTimeMs, _, uninterruptible, T_spellId, _, _ = UnitChannelInfo("target")
        -- 如果目标没在施法，返回false
        if T_spellId == nil then
            return false
        end
    end

    for _, v in ipairs(damage_spell_list) do
        if v == T_spellId then
            return true
        end
    end
    return false

end



-- 判断天赋是否启用
local function TalentEnabled(talent_name)
    return IsPlayerSpell(talent[talent_name])
end

local function TalentDisabled(talent_name)
    return not IsPlayerSpell(talent[talent_name])
end

-- 判断buff状态

local function PlayerHaveBuff(buff_name)
    -- /dump PlayerHaveBuff("正义盾击")
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(buff[buff_name])
    if aura then
        return true
    end
    return false
end

local function PlayerBuffRemaining(buff_name)
    -- /dump PlayerBuffRemaining("正义盾击")
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(buff[buff_name])
    if aura then
        -- duration 为0的buff，是长期无持续时间的
        if aura.duration == 0 then
            return 1000
        end
        local remaining = aura.expirationTime - GetTime()
        return math.max(remaining, 0)
    end
    return 0
end

local function PlayerBuffCount(buff_name)
    local data = C_UnitAuras.GetPlayerAuraBySpellID(buff[buff_name])
    local count
    if data then
        count = data.applications
    else
        -- 如果是nil，那就是无buff，返回0。
        return 0
    end
    -- 如果是0层，他们可能没有层数设置。
    if data.applications == 0 then
        count = 1
    end
    return count
end


-- 由玩家释放的目标buff/de_buff状态
-- /dump TargetDeBuffRemaining("target","血之疫病")
local function TargetDeBuffRemaining(unitID, buff_name)
    local spell_id = buff[buff_name]
    for i = 1, 40 do
        -- /dump C_UnitAuras.GetAuraDataByIndex("target", 1, "HARMFUL|PLAYER")
        local auraData = C_UnitAuras.GetAuraDataByIndex(unitID, i, "HARMFUL|PLAYER")
        if auraData ~= nil and auraData.spellId == spell_id then
            if auraData.duration == 0 then
                return 1000
            end
            local remaining = auraData.expirationTime - GetTime()
            return math.max(remaining, 0)
        end
    end
    return 0
end

-- 有没有可驱散的debuff

local function MouseOverHaveCanDispelDeBuff(buff_type)
    for i = 1, 40 do
        local aura = C_UnitAuras.GetAuraDataByIndex('mouseover', i, "HARMFUL|RAID")
        if aura then
            if aura.isRaid and (aura.dispelName == buff_type) then
                return true
            end
        else
            break
        end
    end
    return false
end

-- 返回gcd的剩余时间，单位为秒。
-- /dump C_Spell.GetSpellCooldown(61304)
-- /dump GcdRemaining()

local function GcdRemaining()
    local spellCooldownInfo = C_Spell.GetSpellCooldown(spell["global_cooldown"])
    if spellCooldownInfo.duration == 0 then
        return 0
    else
        return spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime()
    end
end

-- 返回技能的剩余冷却时间，单位为秒。

local function SpellCDRemaining(spell_name)
    local spellCooldownInfo = C_Spell.GetSpellCooldown(spell[spell_name])
    if spellCooldownInfo.duration == 0 then
        return 0
    else
        return spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime()
    end
end

-- 返回技能的剩余冷却，减去gcd的时间。
-- 当为0的时候，则表明下次GCD可以使用
-- /dump SpellCDRemaining_GCD("圣洁鸣钟")
-- /dump C_Spell.GetSpellCooldown(31935)

function SpellCDRemaining_GCD(spell_name)
    --print(spell[spell_name])
    local spellCooldownInfo = C_Spell.GetSpellCooldown(spell[spell_name])
    if spellCooldownInfo.duration == 0 then
        return 0
    else
        local remaining = spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime()
        return math.max(remaining - GcdRemaining(), 0)
    end
end


-- 返回技能的使用次数
local function SpellCharges(spell_name)
    local chargeInfo = C_Spell.GetSpellCharges(spell[spell_name])
    return chargeInfo.currentCharges
end


-- 施法在范围

local function SpellInRange(spell_name, target)
    return C_Spell.IsSpellInRange(spell[spell_name], target)
end

-- 法术可用

local function SpellUsable(spell_name)
    return C_Spell.IsSpellUsable(spell[spell_name])
end

-- 护腕可用

local function bracers_available()
    local startTime, duration, enable = C_Container.GetItemCooldown(GetInventoryItemID("player", 9))
    return (enable == 1) and (duration == 0)
end

-- /dump isUnitInRange("target", 5)
local function isUnitInRange(unit, range)
    local getRange = {
        { 5, 37727 },
        { 6, 63427 },
        { 8, 34368 },
        { 10, 32321 },
        { 15, 33069 },
        { 20, 10645 },
        { 25, 24268 },
        { 30, 835 },
        { 35, 24269 },
        { 40, 28767 },
        { 45, 23836 },
        { 50, 116139 },
        { 60, 32825 },
        { 70, 41265 },
        { 80, 35278 },
        { 100, 33119 },
    }
    for _, rangeData in ipairs(getRange) do
        local maxRange, itemID = unpack(rangeData)
        if maxRange == range then
            return C_Item.IsItemInRange(itemID, unit)
        end
    end
    return false
end


-- 身边多少距离内敌人的数量
function EnemiesInRangeCount(mod_health, range)
    local inRange, unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        --if UnitCanAttack("player", unitID) and UnitAffectingCombat(unitID) and UnitIsEnemy("player", unitID) then
        if UnitCanAttack("player", unitID) then
            if isUnitInRange(unitID, range) then
                if UnitHealth(unitID) > mod_health then
                    inRange = inRange + 1
                end
            end
        end
    end
    return inRange
end

-- 防骑模块

local function PR_PaladinProtection()

    if PlayerHaveBuff("抓握之血") then
        return SetTC("001 抓握之血", 1, 1, 1)
    end

    if not UnitAffectingCombat("player") then
        --return false
        return SetTC("002 不在战斗中", 1, 1, 1)
    end

    if IsMounted() then
        return SetTC("003 在坐骑上", 1, 1, 1)
    end

    if UnitIsPlayer("target") then
        return SetTC("004 目标是玩家", 1, 1, 1)
    end



    -- -------
    -- 职业资源
    -- -------

    local HolyPower = UnitPower("player", Enum.PowerType.HolyPower)
    -- 配合焦点宏的目标
    local AutoTarget = GetFocusOrTargetEnemy()
    -- 速度
    local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player")

    -- PR开始

    -- 如果神圣能量>=3
    if (HolyPower >= 3) then
        -- 如果没有盾击覆盖，或持续时间少于7秒
        if (PlayerBuffRemaining("正义盾击") < 7) then
            return SetSC("正义盾击", "10 正义盾击")
        end
    end

    -- 如果没有奉献buff，或者奉献剩余2秒
    if (not PlayerHaveBuff("奉献")) or ((feng_xian_timer - GetTime()) < 2.0) then
        -- 奉献在CD
        if (SpellCDRemaining_GCD("奉献") == 0) then
            -- 不在移动中
            if (currentSpeed == 0) then
                return SetSC("奉献", "20 奉献")
            end
        end
    end

    -- 血量少于50%
    if (UnitHealth("player") / UnitHealthMax("player")) < 0.5 then
        -- 护腕可用
        if bracers_available() then
            -- 用护腕
            return SetTitleBySpellID(431416, "30 护腕")
        end
    end

    -- 血量低于50%，，
    if ((UnitHealth("player") / UnitHealthMax("player")) < 0.5) then
        -- 存在闪耀之光buff 327510
        if PlayerHaveBuff("闪耀之光") then
            -- 蓝大于 250000
            if (UnitPower("player", Enum.PowerType.Mana) >= 250000) then
                -- 则释放荣耀圣令
                return SetSC("荣耀圣令", "40 荣耀圣令")
            end
        end
    end

    -- 目标释放尖刺
    if DamageReduction() then
        -- 以下buff没开
        if (PlayerBuffRemaining("圣盾术") < 1.2) and
                (PlayerBuffRemaining("保护祝福") < 1.2) and
                (PlayerBuffRemaining("炽热防御者") < 1.2) and
                (PlayerBuffRemaining("戍卫") < 1.2) and
                (PlayerBuffRemaining("信仰圣光") < 1.2) then
            if PlayerHaveBuff("闪耀之光") then
                -- 蓝大于 250000
                if (UnitPower("player", Enum.PowerType.Mana) >= 250000) then
                    -- 则释放荣耀圣令
                    return SetSC("荣耀圣令", "50 荣耀圣令")
                end
            end
        end
    end

    -- 如果有2层闪耀之光，且圣洁武器或者神圣壁垒存在，且持续时间小于3秒，释放荣耀圣令
    if (PlayerBuffCount("闪耀之光") == 2) then
        if (PlayerHaveBuff("圣洁武器") or PlayerHaveBuff("神圣壁垒")) then
            if  (PlayerBuffRemaining("圣洁武器") <=3) or  (PlayerBuffRemaining("神圣壁垒") <=3)  then
                if (UnitPower("player", Enum.PowerType.Mana) >= 250000) then
                    -- 则释放荣耀圣令
                    return SetSC("荣耀圣令", "55 荣耀圣令")
                end
            end
        end

    end

    -- 如果焦点或目标的施法，有任意施法
    if AnyInterruptable(AutoTarget) then
        -- 复仇者之盾在CD
        if (SpellCDRemaining_GCD("复仇者之盾") == 0) then
            -- 复仇者之盾在施法范围
            if SpellInRange("复仇者之盾", AutoTarget) then
                return SetSC("复仇者之盾", "60 复仇者之盾")
            end
        end
    end

    -- 如果焦点或目标的施法，属于要打断的
    if IsCastInterruptable(AutoTarget) then
        -- 责难在CD
        if (SpellCDRemaining("责难") == 0) then
            -- 在责难施法范围
            if SpellInRange("责难", AutoTarget) then
                SetSC("责难", "70 责难")
            end

        end
    end

    -- 如果存在鼠标指向目标，且是小队成员
    if (UnitExists("mouseover") and (UnitInParty("mouseover") or UnitInRaid("mouseover"))) then
        -- 如果鼠标指向目标身上有毒 or 疾病
        if (MouseOverHaveCanDispelDeBuff("Poison") or MouseOverHaveCanDispelDeBuff("Disease")) then
            -- 如果清毒术在cd
            if (SpellCDRemaining_GCD("清毒术") == 0) then
                return SetSC("清毒术", "80 清毒术")
            end
        end
    end

    -- 如果在爆发期
    if IsBurst() then
        -- 如果身边有3000万血大怪5个
        if (EnemiesInRangeCount(30000000, 10) >= 5) then
            -- 如果敲钟在CD
            if (SpellCDRemaining_GCD("圣洁鸣钟") == 0) then
                -- 如果没有这些buff
                if (PlayerBuffRemaining("圣盾术") < 1.2) and
                        (PlayerBuffRemaining("保护祝福") < 1.2) and
                        (PlayerBuffRemaining("炽热防御者") < 1.2) and
                        (PlayerBuffRemaining("戍卫") < 1.2) and
                        (PlayerBuffRemaining("信仰圣光") < 1.2) then
                    return SetSC("圣洁鸣钟", "90 圣洁鸣钟")

                end
            end
        end
    end

    -- 如果在爆发期
    if IsBurst() then
        -- 如果身边有3000万血大怪4个
        if (EnemiesInRangeCount(30000000, 10) >= 4) then
            -- 如果神圣军备可用次数大于 0
            if (SpellCharges("神圣军备") > 0) then
                -- 如果玩家没有圣洁武器buff 也没有 神圣壁垒buff
                if (not PlayerHaveBuff("圣洁武器")) and (not PlayerHaveBuff("神圣壁垒")) then
                    return SetSC("神圣军备", "100 神圣军备")
                end
            end
        end
    end


    -- 如果飞盾冷却好了
    if (SpellCDRemaining_GCD("复仇者之盾") == 0) then
        -- 在飞盾施法范围
        if SpellInRange("复仇者之盾", AutoTarget) then
            -- 如果没有“信仰壁垒”buff
            if (not PlayerHaveBuff("信仰壁垒")) then
                return SetSC("复仇者之盾", "110 复仇者之盾")
            end
        end
    end

    -- 如果愤怒之锤可用、愤怒之锤在CD、愤怒之锤在距离内
    if SpellUsable("愤怒之锤") and (SpellCDRemaining_GCD("愤怒之锤") == 0) and SpellInRange("愤怒之锤", "target") then
        return SetSC("愤怒之锤", "120 愤怒之锤")
    end

    -- 如果审判可用，在施法范围，释放审判。
    if (SpellCharges("审判") >= 1) and SpellInRange("审判", "target") then
        return SetSC("审判", "150 审判")
    end

    -- 如果祝福之锤可用，释放祝福之锤。
    if (SpellCharges("祝福之锤") >= 1) then
        return SetSC("祝福之锤", "160 祝福之锤")
    end

    -- 释放飞盾打dps
    -- 如果飞盾冷却好了
    if (SpellCDRemaining_GCD("复仇者之盾") == 0) then
        -- 飞盾在施法范围
        if SpellInRange("复仇者之盾", AutoTarget) then
            return SetSC("复仇者之盾", "170 复仇者之盾")
        end
    end

    -- 能量满了就打盾击
    if (HolyPower >= 5) then
        return SetSC("正义盾击", "180 正义盾击")
    end

    return SetTC("999空白", 1, 1, 1)
end -- PR_PaladinProtection()

-- 计算符文数
local function getRuneCount()
    local amount = 0
    for i = 1, 6 do
        local start, duration, runeReady = GetRuneCooldown(i)
        if runeReady then
            amount = amount + 1
        end
    end
    return amount
end

local function PR_DeathKnightBlood()

    if PlayerHaveBuff("抓握之血") then
        return SetTC("001 抓握之血", 1, 1, 1)
    end

    if not UnitAffectingCombat("player") then
        --return false
        return SetTC("002 不在战斗中", 1, 1, 1)
    end

    if IsMounted() then
        return SetTC("003 在坐骑上", 1, 1, 1)
    end

    if UnitIsPlayer("target") then
        return SetTC("004 目标是玩家", 1, 1, 1)
    end

    -- 符文
    local runes = getRuneCount()
    -- 符文能量
    local runic_power = UnitPower("player", Enum.PowerType.RunicPower)
    -- 配合焦点宏的目标
    local AutoTarget = GetFocusOrTargetEnemy()
    -- 速度
    local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player")

    -- PR开始
    --print(runes)
    --print(runic_power)
    --   如果 超出 精髓分裂 的距离， 且 死神的抚摩 CD好 ， 使用 死神的抚摩 195292
    --   否则 使用 精髓分裂  195182
    -- 且死亡触摸在CD，则死亡触摸。

    --print(PlayerBuffCount("白骨之盾"))
    --print(PlayerBuffRemaining("白骨之盾"))
    --print(SpellCDRemaining_GCD("死神的抚摩") )

    -- 如果骨盾<3，或者骨盾持续事件小于4秒优先补骨盾
    if (PlayerBuffCount("白骨之盾") < 3) or (PlayerBuffRemaining("白骨之盾") < 8) then

        --如果存在破灭buff，且在精髓分裂的施法距离，释放精髓分裂，目标血量大于1000万
        if PlayerHaveBuff("破灭") and SpellInRange("精髓分裂", "target") and (UnitHealth("target") > 10000000) then
            return SetSC("精髓分裂", "10 精髓分裂")
        end

        -- 如果 死神的抚摩 在CD好.
        if (SpellCDRemaining_GCD("死神的抚摩") == 0) then
            --print("死神的抚摩 在CD好")
            -- 符文 < 3,使用 死神的抚摩
            if (runes < 2) then
                --print("符文 < 3,使用")
                return SetSC("死神的抚摩", "10 死神的抚摩")
            end

            -- 如果超出精髓分裂 的距离，使用死神的抚摩
            if (not SpellInRange("精髓分裂", "target")) then
                return SetSC("死神的抚摩", "20 死神的抚摩")
            end

        end
        -- 不满足上述条件，使用精髓分裂
        return SetSC("精髓分裂", "30 精髓分裂")
    end

    -- 血量少于50%
    if (UnitHealth("player") / UnitHealthMax("player")) < 0.3 then
        -- 护腕可用
        if bracers_available() then
            -- 用护腕
            return SetTitleBySpellID(431416, "40 护腕")
        end
    end

    -- 目标释放尖刺
    if DamageReduction() then
        -- 血量低于80%
        if (UnitHealth("player") / UnitHealthMax("player")) < 0.8 then
            -- 符文能量大于40
            if runic_power > 40 then
                return SetSC("灵界打击", "50 灵界打击")
            end
        end
    end

    -- 血量低于50%
    if (UnitHealth("player") / UnitHealthMax("player")) < 0.5 then
        -- 符文能量大于40
        if runic_power > 40 then
            return SetSC("灵界打击", "60 灵界打击")
        end
    end

    -- 如果焦点或目标的施法，属于要打断的，则打断
    if IsCastInterruptable(AutoTarget) then
        -- 责难在CD
        if (SpellCDRemaining("心灵冰冻") == 0) then
            -- 在责难施法范围
            if SpellInRange("心灵冰冻", AutoTarget) then
                SetSC("心灵冰冻", "70 心灵冰冻")
            end

        end
    end

    --如果能量大于100，泄能，打灵打
    if runic_power > 100 then
        return SetSC("灵界打击", "80 泄能灵界打击")
    end

    -- 如果学血沸有充能
    if SpellCharges("血液沸腾") >= 1 then
        -- 死亡设置天赋下，周围目标大于等于3个，就用血沸
        if TalentEnabled("死神印记") then
            if EnemiesInRangeCount(1000000, 10) >= 3 then
                return SetSC("血液沸腾", "90 血液沸腾")
            end
        end
        -- 否则目标身上血沸少于3秒，用血沸
        if TargetDeBuffRemaining("target", "血之疫病") < 4 then
            return SetSC("血液沸腾", "100 <3补血液沸腾")
        end
    end

    -- 如果凋零buff持续小于2秒
    if PlayerBuffRemaining("枯萎凋零") <= 2 then
        --print("如果凋零buff持续小于2秒")
        -- 有赤色天灾buff，则立即放凋零。
        if PlayerHaveBuff("赤色天灾") then
            --print("有赤色天灾buff，则立即放凋零。")
            return SetSC("枯萎凋零", "110 赤色天灾枯萎凋零")
        end

        -- 如果凋零有两层充能，则释放凋零。
        if SpellCharges("枯萎凋零") >= 2 then
            --print("如果凋零有两层充能，则释放凋零")
            return SetSC("枯萎凋零", "120 两层枯萎凋零")
        end

        -- 如果在爆发期内，且不在移动，则补凋零。
        if IsBurst() and (SpellCharges("枯萎凋零") >= 1) and (currentSpeed == 0) then
            return SetSC("枯萎凋零", "130 爆发枯萎凋零")
        end
    end

    -- 如果是死亡使者天赋
    if TalentEnabled("死神印记") then
        -- 如果死神印记在CD，符文大于等于2
        --if (SpellCDRemaining_GCD("死神印记") == 0) and (runes >= 2) then
        if (SpellCDRemaining_GCD("死神印记") == 0) then
            return SetSC("死神印记", "130 死神印记")
        end
    end

    -- 如果有吸血鬼之血buff，则吞噬在CD就释放吞噬
    if PlayerHaveBuff("吸血鬼之血") then
        if (SpellCDRemaining_GCD("吞噬") == 0) then
            return SetSC("吞噬", "140 吞噬")
        end
    end

    -- 当符文刃舞的CD大于25秒时候
    if (SpellCDRemaining_GCD("符文刃舞") >= 25) then
        --骨盾数量大于8层。
        if PlayerBuffCount("白骨之盾") >= 8 then

            --如果墓石在CD，能量大于90
            if (runic_power < 90) and (SpellCDRemaining_GCD("墓石") == 0) then
                return SetSC("墓石", "150 墓石")
            end

            -- 如果白骨风暴在CD
            if (SpellCDRemaining_GCD("白骨风暴") == 0) then
                -- 如果目标血量大于2亿
                if (UnitHealth("target") > 200000000) then
                    return SetSC("白骨风暴", "160 白骨风暴")
                end
                -- 如果周围有2500万血量怪超过5个
                if EnemiesInRangeCount(25000000, 10) >= 5 then
                    return SetSC("白骨风暴", "170 白骨风暴")
                end

            end

        end
    end

    -- 如果是萨莱因天赋，
    if TalentEnabled("吸血鬼打击") then
        -- 使用死神的抚摩补骨盾
        if (SpellCDRemaining_GCD("死神的抚摩") == 0) then
            if (PlayerBuffCount("白骨之盾") < 8) and (UnitHealth("target") > 20000000) then
                return SetSC("死神的抚摩", "180 <8补死神的抚摩")
            end
        end
        return SetSC("心脏打击", "190 填充心脏打击")
    end

    -- 如果是死亡使者天赋，
    if TalentEnabled("死神印记") then
        -- 用精髓分裂补骨盾

        if (PlayerBuffCount("白骨之盾") < 8) and (UnitHealth("target") > 20000000) then
            return SetSC("精髓分裂", "190 <8补精髓分裂")
        end


        -- 使用心脏打击填充
        return SetSC("心脏打击", "190 填充心脏打击")
    end

    -- 亡者复生填充
    if (SpellCDRemaining_GCD("亡者复生") == 0) then
        return SetSC("亡者复生", "300 填充亡者复生")
    end

    -- 血沸填充
    -- 如果学血沸有充能
    if SpellCharges("血液沸腾") >= 1 then
        if EnemiesInRangeCount(100000, 5) then
            return SetSC("血液沸腾", "301 填充血液沸腾")
        end

    end

    return SetTC("999空白", 1, 1, 1)

end  -- PR_DeathKnightBlood()

-- 全局入口




local function PixelRotationHekili()
    if PlayerHaveBuff("抓握之血") then
        return SetTC("001 抓握之血", 1, 1, 1)
    end

    if not UnitAffectingCombat("player") then
        --return false
        return SetTC("002 不在战斗中", 1, 1, 1)
    end

    if IsMounted() then
        return SetTC("003 在坐骑上", 1, 1, 1)
    end

    if UnitIsPlayer("target") then
        return SetTC("004 目标是玩家", 1, 1, 1)
    end

    if Hekili.DB.profile.toggles.mode.value ~= "automatic" then
        Hekili.DB.profile.toggles.mode.value = "automatic"
        Hekili:UpdateDisplayVisibility()
        Hekili:ForceUpdate("HEKILI_TOGGLE", true)
    end

    local ability_id, err, info = Hekili_GetRecommendedAbility("Primary", 1)
    if ability_id == nil then
        return SetTC("005 没有推荐技能", 1, 1, 1)
    end
    if ability_id <= 0 then
        ability_id, err, info = Hekili_GetRecommendedAbility("Primary", 2)
        if ability_id <= 0 then
            ability_id, err, info = Hekili_GetRecommendedAbility("Primary", 3)
            if ability_id <= 0 then
                return SetTC("006 没有推荐技能", 1, 1, 1)
            end
        end
    end
    --print(ability_id)
    ----print(err)
    if ability_id ~= nil then
        local r, g, b = convertToRGB(ability_id)
        local spellInfo = C_Spell.GetSpellInfo(ability_id)
        --local spellInfo = C_SpellBook.GetSpellInfo(ability_id)
        --print(spellInfo)
        local title = "Hekili" .. spellInfo.name
        --    print(ability_id .. "," .. r .. "," .. g .. "," .. b)
        --    SetTC(title, r/255, g/255, b/255)
        --    return true
        --    print(title)
        return SetTC(title, r / 255, g / 255, b / 255)
    end
    --return false
end

local tick = 0


-- 进入战斗控制
local function handleEnterCombat()
    SetBurst(25);
    --print("进入战斗")
end

-- 退出战斗
local function handleLeaveCombat()
    ClearBurst();
    --print("退出战斗")
end

function PixelRotationXLMain()

    -- 减少执行次数，这将显著优化速度。
    if GetTime() - tick < 0.1 then
        return false
    end
    tick = GetTime()

    if UnitAffectingCombat("player") ~= in_combat then
        if UnitAffectingCombat("player") then
            handleEnterCombat()
        else
            handleLeaveCombat()
        end
        in_combat = UnitAffectingCombat("player")
    end

    if burst_status ~= IsBurst() then
        if IsBurst() then
            HandleEntryBurst()
            print("进入爆发模式")

        else
            HandleLevelBurst()
            print("退出爆发模式")
        end
        burst_status = IsBurst()
    end

    -- /dump GetSpecialization()
    -- /dump UnitClass("player")
    local className, classFilename, classId = UnitClass("player")
    local currentSpec = GetSpecialization()

    if classFilename == "PALADIN" and currentSpec == 2 then
        return PR_PaladinProtection()
    elseif classFilename == "DEATHKNIGHT" and currentSpec == 1 then
        return PR_DeathKnightBlood()
    else
        return PixelRotationHekili()
    end

end -- PixelRotationXLMain


--/dump PixelRotationXLTest()
function PixelRotationXLTest()
    return MouseOverHaveCanDispelDeBuff("Poison")
end

function f:UNIT_SPELLCAST_SUCCEEDED(unitTarget, castGUID, spellID)
    if (unitTarget == "player" and spellID == 26573) then
        feng_xian_timer = GetTime() + 12
    end
end

local function OnEvent(self, event, ...)
    --print(event)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        f:UNIT_SPELLCAST_SUCCEEDED(...)
    end
    PixelRotationXLMain()
end

f:SetScript("OnEvent", OnEvent)
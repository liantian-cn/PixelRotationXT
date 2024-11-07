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
    if number < 0 or number > 16777216 then
        print("输入数字无效")
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



spell["global_cooldown"] = 61304
spell["GCD"] = 61304
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
buff["抓握之血"] = 432031


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

PR_SetBurst = SetBurst

local in_combat = false

-- 打断优先清单
local interrupt_priority_list = {
  322938,    -- 仙林,收割精魂
  323057,    -- 仙林,BOSS1
  324776,    -- 仙林,木棘外壳
  324914,    -- 仙林,滋养森林
  321828,    -- 仙林,拍手手
  326046,    -- 仙林,模拟抗性
  340544,    -- 仙林,再生鼓舞
  443430,    -- 千丝之城, 流丝缠缚
  443443,    -- 千丝之城, 扭曲思绪
  446086,    -- 千丝之城, 虚空之波
  434793,    -- 回响之城, 共振弹幕
  434802,    -- 回响之城, 惊惧尖鸣
  448248,    -- 回响之城, 恶臭齐射
  433841,    -- 回响之城, 毒液剑雨
  451871,    -- 格瑞姆巴托,剧烈震颤
  76711,     -- 格瑞姆巴托,灼烧心智
  451224,    -- 格瑞姆巴托,暗影烈焰笼罩
  431309,    -- 破晨号,诱捕暗影
  450756,    -- 破晨号,深渊嗥叫
  431333,    -- 破晨号,折磨射线
  432520,    -- 破晨号,暗影屏障
  449455,    -- 矶石宝库,咆哮恐惧
  445207,    -- 矶石宝库,穿透哀嚎
  429545,    -- 矶石宝库,噤声齿轮
  429109,    -- 矶石宝库,愈合金属
  430097,    -- 矶石宝库,融铁之水
  256957,    -- 围攻伯拉勒斯,防水甲壳
  454440,    -- 围攻伯拉勒斯,恶臭喷吐
  272571,    -- 围攻伯拉勒斯,窒息之水
  334748,    -- 通灵战潮,排干体液
  320462,    -- 通灵战潮,通灵箭
  324293,    -- 通灵战潮,刺耳尖啸
  327127,    -- 通灵战潮,修复血肉
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
local function get80DamageReduction()
  local damage_spell_list = {
    320655,   --通灵 凋骨
    424888,   -- 宝库 老1
    428711,   -- 宝库 老3
    434722,   -- 千丝 老1
    441298,   -- 千丝 老2
    461842,   -- 千丝 老3
    447261,   -- 拖把 老1
    449444,   -- 拖把 老2
    450100,   -- 拖把 老4
    453212,   -- 破晨 老1
    427001,   -- 破晨 老2
    438471,   -- 回响 老1
    8690           -- 炉石
  }
  name, _, _, startTimeMs, endTimeMs, _, _, uninterruptible, T_spellId = UnitCastingInfo(target)

  if T_spellId == nil then
        name, _, _, startTimeMs, endTimeMs, _, uninterruptible, T_spellId, _, _ = UnitChannelInfo(target)
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

local function SpellCDRemaining_GCD(spell_name)
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
  return (enable==1) and (duration==0)
end

-- 如果身边有指定技能可攻击的怪，最大血量多少的。

local function EnemiesInRangeCount(mod_health, spell_name)
    local inRange, unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) then
            if C_Spell.IsSpellInRange(spell[spell_name], target) then
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


    if burst_status ~= IsBurst() then
        if IsBurst() then
            --print("进入爆发模式")
            print("进入爆发模式")
        else
            --print("退出爆发模式")
            print("退出爆发模式")
        end
        burst_status = IsBurst()
    end

    if PlayerHaveBuff("抓握之血") then
        return SetTC("抓握之血", 1, 1, 1)
    end

    if not UnitAffectingCombat("player") then
        --return false
        return SetTC("不在战斗中", 1, 1, 1)
    end

    if IsMounted() then
        return SetTC("在坐骑上", 1, 1, 1)
    end

    if UnitIsPlayer("target") then
        return SetTC("目标是玩家", 1, 1, 1)
    end



    -- -------
    -- 职业资源
    -- -------

    local HolyPower = UnitPower("player", Enum.PowerType.HolyPower)

    -- 配合焦点宏的目标
    local AutoTarget = GetFocusOrTargetEnemy()

    -- ----------
    -- 基础减伤覆盖
    -- ----------
    -- 如果神圣能量>=3
    local p1_1 = (HolyPower >= 3)
    -- 如果没有盾击覆盖，或持续时间少于4秒
    local p1_2 = (PlayerBuffRemaining("正义盾击") < 10)
    if (p1_1 and p1_2) then
        return SetSC("正义盾击", "p1 正义盾击")
    end


    -- 如果没有奉献buff，
    local p2_1 = (not PlayerHaveBuff("奉献"))
    -- 奉献在冷却
    local p2_2 = (SpellCDRemaining_GCD("奉献") == 0)
    -- 则释放奉献
    if (p2_1 and p2_2) then
        return SetSC("奉献", "p2 奉献")
    end

  if (UnitHealth("player")/UnitHealthMax("player")) < 0.3 then
    if bracers_available()  then
        return SetTitleBySpellID(431416, "p3 护腕")
    end
  end

    -- 血量低于50%，，
    local p3_1 = ((UnitHealth("player") / UnitHealthMax("player")) < 0.8)
    -- 存在闪耀之光buff 327510
    local p3_2 = PlayerHaveBuff("闪耀之光")
    -- 蓝大于 250000
    local p3_3 = (UnitPower("player", Enum.PowerType.Mana) >= 250000)
    -- 则释放荣耀圣令
    if (p3_1 and p3_2 and p3_3) then
        return SetSC("荣耀圣令", "p3 荣耀圣令")
    end


    -- 如果焦点或目标的施法，属于要打断的
    local p4_1 = IsCastInterruptable(AutoTarget)
    -- 责难在CD
    local p4_2 = (SpellCDRemaining("责难") == 0)
    -- 责难在施法范围
    local p4_3 = SpellInRange("责难", AutoTarget)
    -- 优先责难，其次复仇者之盾
    if (p4_1 and p4_2 and p4_3) then
        return SetSC("责难", "p4 责难")
    end

    -- 复仇者之盾在CD
    local p4_4 = (SpellCDRemaining_GCD("复仇者之盾") == 0)
    -- 复仇者之盾在施法范围
    local p4_5 = SpellInRange("复仇者之盾", AutoTarget)
    -- 目标可打断
    local p4_6 = AnyInterruptable(AutoTarget)
    if (p4_6 and p4_4 and p4_5) then
        return SetSC("复仇者之盾", "p4 复仇者之盾")
    end

    -- ----------
    -- 驱散
    -- ----------

    -- 如果存在鼠标指向目标，且是小队成员
    local p5_1 = (UnitExists("mouseover") and (UnitInParty("mouseover") or UnitInRaid("mouseover")))
    -- 如果鼠标指向目标身上有毒 or 疾病
    local p5_2 = (MouseOverHaveCanDispelDeBuff("Poison") or MouseOverHaveCanDispelDeBuff("Disease"))
    -- 如果清毒术在cd
    local p5_3 = (SpellCDRemaining_GCD("清毒术") == 0)
    -- 满足上述条件，释放清毒术
    if (p5_1 and p5_2 and p5_3) then
        return SetSC("清毒术", "p5 清毒术")
    end



    -- ----------
    -- 输出优先级
    -- ----------


    -- 如果身边有3000万血大怪4个
    local p6_1 = (EnemiesInRangeCount(30000000, "制裁之锤") >= 4)
    -- 如果敲钟在CD
    local p6_2 = (SpellCDRemaining_GCD("圣洁鸣钟") == 0)
    -- 如果豆子 < 3
    local p6_3 = (HolyPower < 3)
    -- 如果没有 圣盾术、 保护祝福、 、 、 、buff
    local p6_4_1 = (PlayerBuffRemaining("圣盾术") < 1.2)
    local p6_4_2 = (PlayerBuffRemaining("保护祝福") < 1.2)
    local p6_4_3 = (PlayerBuffRemaining("炽热防御者") < 1.2)
    local p6_4_4 = (PlayerBuffRemaining("戍卫") < 1.2)
    local p6_4 = p6_4_1 and p6_4_2 and p6_4_3 and p6_4_4
    -- 满足以上条件，在爆发期内，使用圣洁鸣钟
    if (p6_1 and p6_2 and p6_3 and p6_4 and IsBurst()) then
        return SetSC("圣洁鸣钟", "p6 圣洁鸣钟")
    end


    -- 如果周围有剩余血量大于3000万血量的怪，数量超过4个。
    local p7_1 = (EnemiesInRangeCount(30000000, "制裁之锤") >= 4)
    -- 如果神圣军备可用次数大于 0
    local p7_2 = (SpellCharges("神圣军备") > 0)
    -- 如果玩家没有圣洁武器buff
    local p7_3 = (not PlayerHaveBuff("圣洁武器"))
    -- 如果玩家没有神圣壁垒buff
    local p7_4 = (not PlayerHaveBuff("神圣壁垒"))
    -- 满足以上条件，在爆发期，使用神圣军备
    if (p7_1 and p7_2 and p7_3 and p7_4 and IsBurst()) then
        return SetSC("神圣军备", "p7 神圣军备")
    end


    -- 如果飞盾冷却好了
    local p8_1 = (SpellCDRemaining_GCD("复仇者之盾") == 0)
    -- 在施法范围
    local p8_2 = SpellInRange("复仇者之盾", AutoTarget)
    -- 如果没有“信仰壁垒”buff
    local p8_3 = (not PlayerHaveBuff("信仰壁垒"))
    -- 满足上述条件，释放飞盾
    if (p8_1 and p8_2 and p8_3) then
        return SetSC("复仇者之盾", "p8 复仇者之盾")
    end



    -- 如果神圣能量小于5
    local p9_1 = (HolyPower < 5)
    -- 如果愤怒支持可用
    local p9_2 = SpellUsable("愤怒之锤")
    -- 如果愤怒之锤在CD
    local p9_3 = (SpellCDRemaining_GCD("愤怒之锤") == 0)
    -- 如果愤怒之锤在距离内
    local p9_4 = SpellInRange("愤怒之锤", "target")
    -- 满足以上条件，释放愤怒之锤
    if (p9_1 and p9_2 and p9_3 and p9_4) then
        return SetSC("愤怒之锤", "p9 愤怒之锤")
    end


    -- 如果神圣能量小于5
    local p11_1 = (HolyPower < 5)
    -- 审判在施法范围
    local p11_2 = SpellInRange("审判", "target")
    -- 审判可用次数大于等于1
    local p11_3 = (SpellCharges("审判") >= 1)
    -- 满足上述条件，释放审判
    if (p11_1 and p11_2 and p11_3) then
        return SetSC("审判", "p11 审判")
    end


    -- 如果神圣能量小于5
    local p10_1 = (HolyPower < 5)
    -- 祝福之锤可用次数大于1
    local p10_2 = (SpellCharges("祝福之锤") >= 1)
    -- 则释放祝福之锤。
    if (p10_1 and p10_2) then
        return SetSC("祝福之锤", "p10 祝福之锤")
    end

    -- 如果飞盾冷却好了
    local p12_1 = (SpellCDRemaining_GCD("复仇者之盾") == 0)
    -- 飞盾在施法范围
    local p12_2 = SpellInRange("复仇者之盾", AutoTarget)
    -- 则释放飞盾
    if (p12_1 and p12_2) then
        return SetSC("复仇者之盾", "p12 复仇者之盾")
    end



    ---- 如果有5层神圣能量。
    --local p13_1 = (HolyPower >= 5)
    ---- 释放盾击
    --if (p13_1) then
    --    return SetSC("正义盾击", "p13 正义盾击")
    --end

    return SetTC("空白", 1, 1, 1)
end -- PR_PaladinProtection()

-- 全局入口




local function PixelRotationHekili()
    local ability_id, err = Hekili_GetRecommendedAbility("Primary", 1)
    if ability_id then
        --return SetSC(ability_id)
        local r, g, b = convertToRGB(ability_id)
        print(ability_id .. "," .. r .. "," .. g .. "," .. b)
        return true
    end
    return false
end

local tick = 0


-- 进入战斗控制
local function handleEnterCombat()
    SetBurst(30);
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

    --print(SpellCDRemainingGCD("奉献"))
    -- /dump GetSpecialization()
    -- /dump UnitClass("player")
    local className, classFilename, classId = UnitClass("player")
    local currentSpec = GetSpecialization()

    if classFilename == "PALADIN" and currentSpec == 2 then
        return PR_PaladinProtection()
    else
        return PixelRotationHekili()
    end

end -- PixelRotationXLMain


--/dump PixelRotationXLTest()
function PixelRotationXLTest()
    return MouseOverHaveCanDispelDeBuff("Poison")
end

local function OnEvent(self, event, ...)
    --print(event)
    --if event == "PLAYER_LEAVE_COMBAT" then
    --print("离开战斗")
    --handleLeaveCombat()
    --elseif event == "PLAYER_ENTER_COMBAT" then
    --print("进入战斗")
    --handleEnterCombat()
    --end
    PixelRotationXLMain()
end

f:SetScript("OnEvent", OnEvent)
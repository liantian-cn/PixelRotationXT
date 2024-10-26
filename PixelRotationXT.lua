local talent = {  }
local spell = {  }
local buff = {  }
local item = {  }
local color = {  }

local f = CreateFrame("Frame", nil, UIParent)
--f:SetPoint("CENTER")
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0) -- 设置到左上角
f:SetSize(64, 64)

f.tex = f:CreateTexture()
f.tex:SetAllPoints()
--f.tex:SetColorTexture(0, 0, 0, 1)

local textBox = CreateFrame("Frame", nil, UIParent)
textBox:SetPoint("TOPLEFT", f, "TOPRIGHT", 0, 0) -- 放置在图标右侧
textBox:SetSize(256, 64)
local text = textBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("LEFT", textBox, "LEFT", 0, 0)
text:SetFont("Fonts\\FRIZQT__.TTF", 32, nil)
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
f:SetScript("OnEvent", function()
    PixelRotationXLMain()
end)

local last_title = 0
local function SetTitleAndColor(title, r, g, b)
    --如果和上一个相同，则不更新颜色
    if last_title == title then
        return
    end
    last_title = title
    f.tex:SetColorTexture(r, g, b, 1)
    text:SetText(title)
end

local SetTC = SetTitleAndColor

function SetTitleBySpellColor(spell_name)
    local r, g, b = unpack(color[spell_name])
    return SetTitleAndColor(spell_name, r, g, b)
end

SetSC = SetTitleBySpellColor
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

buff["正义盾击"] = 132403
buff["奉献"] = 188370
buff["圣洁武器"] = 432502
buff["神圣壁垒"] = 432496
buff["闪耀之光"] = 327510

color["奉献"] = { 0, 0, 0.25 }    -- 1
color["祝福之锤"] = { 0, 0, 0.5 }   -- 2
color["正义盾击"] = { 0, 0, 0.75 }    -- 3
color["审判"] = { 0, 0, 1 }           -- 4
color["复仇者之盾"] = { 0, 0.25, 0 }   -- 5
color["责难"] = { 0, 0.25, 0.25 }     -- 6
color["清毒术"] = { 0, 0.25, 0.5 }     -- 7
color["神圣军备"] = { 0, 0.25, 0.75 }    -- 8
color["圣洁鸣钟"] = { 0, 0.25, 1 }     -- 9
color["愤怒之锤"] = { 0, 0.5, 0 }     -- 10
color["荣耀圣令"] = { 0, 0.5, 0.25 }     -- 11



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
    -- 如果没有盾击覆盖，则打盾击
    -- 如果盾击持续时间少于3秒，则打盾击
    -- 因为没有时候，PlayerBuffRemaining也返回0，所以合并

    if HolyPower >= 3 then
        if PlayerBuffRemaining("正义盾击") < 2.5 then
            return SetSC("正义盾击")
        end
    end

    -- 如果没有奉献buff
    -- 如果奉献在冷却
    -- 则释放奉献

    if not PlayerHaveBuff("奉献") then
        if SpellCDRemaining_GCD("奉献") == 0 then
            return SetSC("奉献")
        end
    end

    -- ----------
    -- 减伤
    -- ----------

    -- 血量低于80%，存在闪耀之光buff 327510，则释放荣耀圣令


    if (UnitHealth("player") / UnitHealthMax("player")) < 0.7 then
        if PlayerHaveBuff("闪耀之光") then
            return SetSC("荣耀圣令")
        end
    end

    -- ----------
    -- 打断
    -- ----------

    -- 如果焦点或目标的施法，属于要打断的
    -- 如果在近战范围，责难的CD好，用责难打断。
    -- 如果不在近战范围，且飞盾CD，用飞盾打断。


    if IsCastInterruptable(AutoTarget) then
        if SpellCDRemaining("责难") == 0 then
            if SpellInRange("责难", AutoTarget) then
                return SetSC("责难")
            end
        end
        if SpellCDRemaining_GCD("复仇者之盾") == 0 then
            if SpellInRange("复仇者之盾", AutoTarget) then
                return SetSC("复仇者之盾")
            end
        end

    end

    -- ----------
    -- 驱散
    -- ----------

    -- 如果存在鼠标指向的目标。
    -- 如果鼠标指向的目标是队员。
    -- 如果鼠标指向目标有毒或者疾病。
    -- 如果清毒术在cd
    -- 清毒
    if UnitExists("mouseover") then
        if UnitInParty("mouseover") or UnitInRaid("mouseover") then
            if MouseOverHaveCanDispelDeBuff("Poison") or MouseOverHaveCanDispelDeBuff("Disease") then
                if SpellCDRemaining_GCD("清毒术") == 0 then
                    return SetSC("清毒术")
                end
            end
        end
    end

    -- ----------
    -- 牺牲祝福
    -- ----------

    -- 如果自己血量>80%.
    -- 周围怪数量>6
    --


    -- ----------
    -- 输出优先级
    -- ----------

    -- 如果周围有剩余血量大于3000万血量的怪，数量超过4个。
    -- 如果敲钟在CD
    -- 则圣洁鸣钟

    if EnemiesInRangeCount(40000000, "制裁之锤") >= 4 then
        if SpellCDRemaining_GCD("圣洁鸣钟") == 0 then
            return SetSC("圣洁鸣钟")
        end
    end


    -- 如果周围有剩余血量大于4000万血量的怪，数量超过4个。
    -- 如果没有圣洁武器和神圣壁垒buff
    -- 神圣军备
    if EnemiesInRangeCount(40000000, "制裁之锤") >= 4 then
        if SpellCharges("神圣军备") > 0 then
            if (not PlayerHaveBuff("圣洁武器")) and (not PlayerHaveBuff("神圣壁垒"))  then
                return SetSC("神圣军备")
            end
        end
    end

    -- 如果周围有剩余血量大于3000万血量的怪，数量超过4个。
    -- 如果没有圣洁武器和神圣壁垒buff
    -- 不浪费层数
    -- 神圣军备
    if EnemiesInRangeCount(30000000, "制裁之锤") >= 4 then
        if SpellCharges("神圣军备") > 1 then
            if (not PlayerHaveBuff("圣洁武器")) and (not PlayerHaveBuff("神圣壁垒"))  then
                return SetSC("神圣军备")
            end
        end
    end

    -- 如果飞盾冷却好了
    -- 在施法范围
    -- 如果能量大于等于3
    -- 则释放飞盾
    if SpellCDRemaining_GCD("复仇者之盾") == 0 then
        if SpellInRange("复仇者之盾", AutoTarget) then
            if HolyPower > 3 then
                return SetSC("复仇者之盾")

            end
        end
    end


    -- 如果神圣能量小于5
    -- 如果愤怒支持可用24275
    -- 如果距离内
    -- 则释放愤怒之锤
    if HolyPower < 5 then
        if SpellUsable("愤怒之锤") then
            if SpellCDRemaining_GCD("愤怒之锤") == 0 then
                if SpellInRange("愤怒之锤", "target") then
                    return SetSC("愤怒之锤")
                end
            end
        end
    end


    -- 如果神圣能量小于5
    -- 祝福之锤可用次数大于1
    -- 则释放祝福之锤。
    if HolyPower < 5 then
        if SpellCharges("祝福之锤") >= 1 then
            return SetSC("祝福之锤")
        end
    end

    -- 如果神圣能量小于5
    -- 在施法范围d
    -- 审判可用次数大于等于1
    -- 则释放审判。
    if HolyPower < 5 then
        if SpellCharges("审判") >= 1 then
            if SpellInRange("审判", "target") then
                return SetSC("审判")
            end
        end
    end


        -- 如果飞盾冷却好了
    -- 在施法范围
    -- 如果能量大于等于3
    -- 则释放飞盾
    if SpellCDRemaining_GCD("复仇者之盾") == 0 then
        if SpellInRange("复仇者之盾", AutoTarget) then
            return SetSC("复仇者之盾")
        end
    end


    -- ----------
    -- 默认值
    -- ----------

    return SetTC("空白", 1, 1, 1)
end -- PR_PaladinProtection()

-- 全局入口

function PixelRotationXLMain()

    --print(SpellCDRemainingGCD("奉献"))
    -- /dump GetSpecialization()
    -- /dump UnitClass("player")
    local className, classFilename, classId = UnitClass("player")
    local currentSpec = GetSpecialization()

    if classFilename == "PALADIN" and currentSpec == 2 then
        return PR_PaladinProtection()
    end


end -- PixelRotationXLMain



--/dump PixelRotationXLTest()
function PixelRotationXLTest()
    return MouseOverHaveCanDispelDeBuff("Poison")
end
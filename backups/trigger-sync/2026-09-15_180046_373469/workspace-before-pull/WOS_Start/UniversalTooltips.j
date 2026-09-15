library AAUniversalTooltips initializer Init requires GearSystems, TooltipBuilder

    globals
        private hashtable HT_DATA = null
        private hashtable HT_DESC = null
        private hashtable HT_TIMERS = null
        private constant string NL = "|n"

        private unit TOOLTIP_DAMAGE_TARGET = null
        private unit array WATCHED_HERO
        private timer POLL_TIMER = null

        private constant integer POLL_KEY_TYPE     = -101
        private constant integer POLL_KEY_STR      = -102
        private constant integer POLL_KEY_AGI      = -103
        private constant integer POLL_KEY_INT      = -104
        private constant integer POLL_KEY_ATTACK   = -105
        private constant integer POLL_KEY_NORMAL   = -106
        private constant integer POLL_KEY_MAGIC    = -107
        private constant integer POLL_KEY_PHYSICAL = -108

        private constant integer TIMER_KEY_PENDING = -201
        private constant real POLL_PERIOD = 0.25
        
        private timer array TPool
        private integer TCount = 0
    endglobals

    //===========================================================================
    // Снятие ограничений высоты контейнеров тултипов (UI Frame API)
    //===========================================================================
    private function FixTooltipBoxSize takes nothing returns nothing
        local framehandle tooltip = BlzGetFrameByName("CommandBarTooltip", 0)
        local framehandle tooltipText = BlzGetFrameByName("CommandBarTooltipText", 0)
        local framehandle itemTooltip = BlzGetFrameByName("InventoryBarTooltip", 0)
        local framehandle itemTooltipText = BlzGetFrameByName("InventoryBarTooltipText", 0)
        
        if tooltipText != null then
            call BlzFrameSetSize(tooltipText, 0.28, 0.0)
        endif
        if tooltip != null then
            call BlzFrameSetSize(tooltip, 0.28, 0.0)
        endif
        
        if itemTooltipText != null then
            call BlzFrameSetSize(itemTooltipText, 0.28, 0.0)
        endif
        if itemTooltip != null then
            call BlzFrameSetSize(itemTooltip, 0.28, 0.0)
        endif
        
        set tooltipText = null
        set tooltip = null
        set itemTooltipText = null
        set itemTooltip = null
        call DestroyTimer(GetExpiredTimer())
    endfunction

    private function InitTooltipFrameFix takes nothing returns nothing
        call TimerStart(CreateTimer(), 0.00, false, function FixTooltipBoxSize)
    endfunction

    //===========================================================================
    // Утилиты таймеров и форматирования
    //===========================================================================
    private function GetT takes nothing returns timer
        if TCount > 0 then
            set TCount = TCount - 1
            return TPool[TCount]
        endif
        return CreateTimer()
    endfunction

    private function RelT takes timer t returns nothing
        call PauseTimer(t)
        call FlushChildHashtable(HT_TIMERS, GetHandleId(t))
        set TPool[TCount] = t
        set TCount = TCount + 1
    endfunction

    private function FormatReal takes real x returns string
        if (x - R2I(x) == 0.0) then
            return I2S(R2I(x))
        endif
        return R2SW(x, 1, 2)
    endfunction
    
    public function T_Invul takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Invulnerability:|r " + FormatReal(val) + " sec|n"
    endfunction

    public function T_Bonus takes string source, string text returns string
        if text == "" then 
            return "" 
        endif
        return "|cffffa500[" + source + "]:|r " + text + "|n"
    endfunction

    public function T_Prop takes string name, real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00" + name + ":|r " + I2S(R2I(val)) + "|n"
    endfunction
    
    public function T_PropS takes string name, string val returns string
        if val == "" or val == null then
            return ""
        endif
        return "|cffffcc00" + name + ":|r " + val + "|n"
    endfunction

    public function T_Dur takes string name, real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00" + name + ":|r " + FormatReal(val) + " sec|n"
    endfunction

    public function T_Stun takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Stun:|r " + FormatReal(val) + " sec|n"
    endfunction

    public function T_Push takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Knockback:|r " + I2S(R2I(val)) + "|n"
    endfunction

    public function T_Rad takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Radius:|r " + I2S(R2I(val)) + "|n"
    endfunction

    public function T_RadExp takes real val, real exp returns string
        if val == 0 then 
            return "" 
        endif
        if exp == 0 then 
            return "|cffffcc00Radius:|r " + I2S(R2I(val)) + "|n" 
        endif
        return "|cffffcc00Radius:|r " + I2S(R2I(val)) + " (Explosion " + I2S(R2I(exp)) + ")|n"
    endfunction

    public function T_Slow takes real percent, real dur returns string
        if percent <= 0.0 or dur <= 0.0 then
            return ""
        endif
        return "|cffffcc00Slow:|r " + FormatReal(percent) + "% for " + FormatReal(dur) + " sec|n"
    endfunction

    public function T_Root takes real dur returns string
        if dur == 0 then 
            return "" 
        endif
        return "|cffffcc00Root:|r " + FormatReal(dur) + " sec|n"
    endfunction

    public function T_Silence takes real dur returns string
        if dur == 0 then 
            return "" 
        endif
        return "|cffffcc00Silence:|r " + FormatReal(dur) + " sec|n"
    endfunction
    
    public function T_Element takes integer elem returns string
        if elem == 1 then
            return "|cffffcc00Applies:|r Fire debuff|n"
        elseif elem == 2 then
            return "|cffffcc00Applies:|r Water debuff|n"
        elseif elem == 3 then
            return "|cffffcc00Applies:|r Electro debuff|n"
        endif
        return ""
    endfunction
    
    public function T_Cast takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Cast Time:|r " + FormatReal(val) + " sec|n"
    endfunction

    public function T_Duration takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Duration:|r " + FormatReal(val) + " sec|n"
    endfunction

    public function T_CastInvul takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Cast Time:|r " + FormatReal(val) + " sec (Invulnerable)|n"
    endfunction

    public function T_DurationInvul takes real val returns string
        if val == 0 then 
            return "" 
        endif
        return "|cffffcc00Duration:|r " + FormatReal(val) + " sec (Invulnerable)|n"
    endfunction
    
    public function FormatInt takes real val returns string
        return I2S(R2I(val))
    endfunction

    public function T_Decor takes real val returns string
        return I2S(R2I(val))
    endfunction

    public function T_DecorExp takes real baseDmg, real expDmg returns string
        return I2S(R2I(baseDmg)) + " (Explosion " + I2S(R2I(expDmg)) + ")"
    endfunction

    public function T_DecorFlight takes real baseDmg, real flightDmg, real expDmg returns string
        return I2S(R2I(baseDmg)) + " (Flight " + I2S(R2I(flightDmg)) + " / Explosion " + I2S(R2I(expDmg)) + ")"
    endfunction

    public function T_DecorAoe takes real dmg, real aoe returns string
        return I2S(R2I(dmg)) + " (Radius " + I2S(R2I(aoe)) + ")"
    endfunction
    
    public function T_DurAuto takes real val, boolean isInvul returns string
        if val == 0 then 
            return "" 
        endif
        if isInvul then
            return "|cffffcc00Duration:|r " + FormatReal(val) + " sec (Invulnerable)|n"
        endif
        return "|cffffcc00Duration:|r " + FormatReal(val) + " sec|n"
    endfunction

    public function T_CastAuto takes real val, boolean isInvul returns string
        if val == 0 then 
            return "" 
        endif
        if isInvul then
            return "|cffffcc00Cast Time:|r " + FormatReal(val) + " sec (Invulnerable)|n"
        endif
        return "|cffffcc00Cast Time:|r " + FormatReal(val) + " sec|n"
    endfunction

    public function T_InvulAuto takes real val, boolean isInvul returns string
        if not isInvul or val == 0 then 
            return "" 
        endif
        return "|cffffcc00Invulnerability:|r " + FormatReal(val) + " sec|n"
    endfunction
    
    public function T_Debuff takes string debuffName returns string
        if debuffName == "" or debuffName == null then
            return ""
        endif
        return "|cffffcc00Applies:|r " + debuffName + " debuff|n"
    endfunction

    //===========================================================================
    // Парсеры и Нормализация
    //===========================================================================
    private function GetListElement takes string list, integer index returns string
        local integer i = 0
        local integer len = StringLength(list)
        local integer start = 0
        local integer current = 1
        local string char = ""
        
        if index <= 0 then
            return list
        endif
        
        loop
            exitwhen i >= len
            set char = SubString(list, i, i + 1)
            if char == "/" then
                if current == index then
                    return SubString(list, start, i)
                endif
                set start = i + 1
                set current = current + 1
            endif
            set i = i + 1
        endloop
        
        return SubString(list, start, len)
    endfunction

    private function ParseLevelTags takes string src, integer lvl returns string
        local integer i = 0
        local integer len = 0
        local integer startPos = -1
        local integer endPos = -1
        local string listStr = ""
        local string result = src
        local integer strHash
        local string cachedStr
        
        if src == "" or src == null then
            return ""
        endif

        set strHash = StringHash(src)
        set cachedStr = LoadStr(HT_DESC, strHash, lvl)
        if cachedStr != null then
            return cachedStr
        endif
        
        loop
            set len = StringLength(result)
            set i = 0
            set startPos = -1
            set endPos = -1
            
            loop
                exitwhen i > len - 3
                if SubString(result, i, i + 3) == "<L:" then
                    set startPos = i
                    exitwhen true
                endif
                set i = i + 1
            endloop
            
            exitwhen startPos == -1
            
            set i = startPos + 3
            loop
                exitwhen i >= len
                if SubString(result, i, i + 1) == ">" then
                    set endPos = i
                    exitwhen true
                endif
                set i = i + 1
            endloop
            
            if endPos != -1 then
                set listStr = SubString(result, startPos + 3, endPos)
                set result = SubString(result, 0, startPos) + GetListElement(listStr, lvl) + SubString(result, endPos + 1, len)
            else
                exitwhen true
            endif
        endloop
        
        call SaveStr(HT_DESC, strHash, lvl, result)
        return result
    endfunction

    private function StringReplace takes string src, string oldStr, string newStr returns string
        local integer len = StringLength(src)
        local integer oldLen = StringLength(oldStr)
        local integer i = 0
        local string res = ""
        
        if oldLen == 0 or len == 0 then
            return src
        endif
        
        loop
            exitwhen i > len - oldLen
            if SubString(src, i, i + oldLen) == oldStr then
                set res = res + newStr
                set i = i + oldLen
            else
                set res = res + SubString(src, i, i + 1)
                set i = i + 1
            endif
        endloop
        
        set res = res + SubString(src, i, len)
        return res
    endfunction

    private function NormalizeDesc takes string s returns string
        local integer len = StringLength(s)
        local integer i = 0
        local string res = ""
        local string c = ""
        
        loop
            exitwhen i >= len
            set c = SubString(s, i, i + 1)
            if c == "\n" then
                set res = res + "|n"
            elseif c != "\r" then
                set res = res + c
            endif
            set i = i + 1
        endloop
        
        set s = res
        set len = StringLength(s)
        loop
            exitwhen len == 0
            if SubString(s, len - 1, len) == " " then
                set s = SubString(s, 0, len - 1)
                set len = len - 1
            elseif len >= 2 and SubString(s, len - 2, len) == "|n" then
                set s = SubString(s, 0, len - 2)
                set len = len - 2
            else
                exitwhen true
            endif
        endloop
        return s
    endfunction

    private function CaptureDesc takes integer abilId returns nothing
        if not HaveSavedString(HT_DATA, abilId, 9999) then
            call SaveStr(HT_DATA, abilId, 9999, NormalizeDesc(BlzGetAbilityExtendedTooltip(abilId, 0)))
        endif
    endfunction

    public function GetDesc takes integer abilId returns string
        if HaveSavedString(HT_DATA, abilId, 9999) then
            return LoadStr(HT_DATA, abilId, 9999)
        endif
        return BlzGetAbilityExtendedTooltip(abilId, 0)
    endfunction

    private function FormulaStr takes integer statType, real statBase, real statStep, real staticBase, real staticStep, integer lvl returns string
        local string statName = ""
        local string s = ""
        local real st = 0.0
        
        if statType == 1 then
            set statName = "Strength"
        elseif statType == 2 then
            set statName = "Agility"
        elseif statType == 3 then
            set statName = "Intelligence"
        elseif statType == 4 then
            set statName = "Attack"
        endif

        if (statBase != 0.0 or statStep != 0.0) then
            set s = statName + " x " + FormatReal(statBase + statStep * (lvl - 1))
            set st = staticBase + staticStep * (lvl - 1)
            if (st != 0.0) then
                set s = s + " + " + FormatReal(st)
            endif
        else
            set s = FormatReal(staticBase + staticStep * (lvl - 1))
        endif
        return s
    endfunction

    private function FormulaList takes integer statType, real statBase, real statStep, real staticBase, real staticStep, integer maxLv returns string
        local string statName = ""
        local string s = ""
        local integer i = 1
        local boolean sameStat = (statStep == 0.0)
        local boolean sameStatic = (staticStep == 0.0)
        
        if statType == 1 then
            set statName = "Strength"
        elseif statType == 2 then
            set statName = "Agility"
        elseif statType == 3 then
            set statName = "Intelligence"
        elseif statType == 4 then
            set statName = "Attack"
        endif

        if (statBase != 0.0 or statStep != 0.0) then
            set s = statName + " x "
            if sameStat then
                set s = s + FormatReal(statBase)
            else
                loop
                    exitwhen i > maxLv
                    if (i > 1) then
                        set s = s + "/"
                    endif
                    set s = s + FormatReal(statBase + statStep * (i - 1))
                    set i = i + 1
                endloop
            endif
            
            if (staticBase != 0.0 or staticStep != 0.0) then
                set s = s + " + "
                if sameStatic then
                    set s = s + FormatReal(staticBase)
                else
                    set i = 1
                    loop
                        exitwhen i > maxLv
                        if (i > 1) then
                            set s = s + "/"
                        endif
                        set s = s + FormatReal(staticBase + staticStep * (i - 1))
                        set i = i + 1
                    endloop
                endif
            endif
        else
            if sameStatic then
                set s = FormatReal(staticBase)
            else
                loop
                    exitwhen i > maxLv
                    if (i > 1) then
                        set s = s + "/"
                    endif
                    set s = s + FormatReal(staticBase + staticStep * (i - 1))
                    set i = i + 1
                endloop
            endif
        endif
        return s
    endfunction

    private function ListRealField takes ability ab, abilityreallevelfield field, integer minLv, integer maxLv returns string
        local string s = ""
        local real v = 0.0
        local real first = 0.0
        local boolean same = true
        local integer i = minLv
        if (ab == null) then
            return ""
        endif
        loop
            exitwhen i > maxLv
            set v = BlzGetAbilityRealLevelField(ab, field, i - 1)
            if (i == minLv) then
                set first = v
            elseif (v != first) then
                set same = false
            endif
            if (i > minLv) then
                set s = s + "/"
            endif
            set s = s + FormatReal(v)
            set i = i + 1
        endloop
        if (same) then
            return FormatReal(first)
        endif
        return s
    endfunction

    private function ListCooldown takes integer abilId, integer minLv, integer maxLv returns string
        local string s = ""
        local real v = 0.0
        local real first = 0.0
        local boolean same = true
        local integer i = minLv
        loop
            exitwhen i > maxLv
            set v = BlzGetAbilityCooldown(abilId, i - 1)
            if (i == minLv) then
                set first = v
            elseif (v != first) then
                set same = false
            endif
            if (i > minLv) then
                set s = s + "/"
            endif
            set s = s + FormatReal(v)
            set i = i + 1
        endloop
        if (same) then
            return FormatReal(first)
        endif
        return s
    endfunction

    private function ListMana takes integer abilId, integer minLv, integer maxLv returns string
        local string s = ""
        local integer v = 0
        local integer first = 0
        local boolean same = true
        local integer i = minLv
        loop
            exitwhen i > maxLv
            set v = BlzGetAbilityManaCost(abilId, i - 1)
            if (i == minLv) then
                set first = v
            elseif (v != first) then
                set same = false
            endif
            if (i > minLv) then
                set s = s + "/"
            endif
            set s = s + I2S(v)
            set i = i + 1
        endloop
        if (same) then
            return I2S(first)
        endif
        return s
    endfunction

    //===========================================================================
    // База Данных Способностей и Героев
    //===========================================================================
    struct SpellData
        integer abilId
        integer maxLv
        integer dmgType
        integer statType
        real statBase
        real statStep
        real staticBase
        real staticStep
        string mecha
        string bonus
        integer formId = 0
        real bMult1 = 0.0
        real bMult2 = 0.0

        integer dmgType2 = 0
        string dmgName2 = ""
        integer statType2 = 0
        real statBase2 = 0.0
        real statStep2 = 0.0
        real staticBase2 = 0.0
        real staticStep2 = 0.0
        string decor = ""
        boolean cdAfterDur = false

        method setBonusMults takes real m1, real m2 returns thistype
            set this.bMult1 = m1
            set this.bMult2 = m2
            return this
        endmethod

        method setSecondDamage takes integer dmgType, string name, integer statType, real sBase, real sStep, real stBase, real stStep returns thistype
            set this.dmgType2 = dmgType
            set this.dmgName2 = name
            set this.statType2 = statType
            set this.statBase2 = sBase
            set this.statStep2 = sStep
            set this.staticBase2 = stBase
            set this.staticStep2 = stStep
            call this.SetInitialTips()
            return this
        endmethod

        method setDecor takes string d returns thistype
            set this.decor = d
            call this.SetInitialTips()
            return this
        endmethod

        method setCdAfterDuration takes boolean flag returns thistype
            set this.cdAfterDur = flag
            call this.SetInitialTips()
            return this
        endmethod

        private method SetInitialTips takes nothing returns nothing
            local string desc
            local TooltipBuilder builder
            local integer i = 1
            local unit dummy
            local ability ab
            local string bns

            if this.formId != 0 then
                return
            endif

            set desc = GetDesc(this.abilId)
            set dummy = CreateUnit(Player(15), 'hfoo', 0, 0, 0)
            set bns = this.bonus

            if (this.bMult1 != 0.0) then
                set bns = StringReplace(bns, "<V1>", "0")
            endif
            if (this.bMult2 != 0.0) then
                set bns = StringReplace(bns, "<V2>", "0")
            endif

            call UnitAddAbility(dummy, this.abilId)
            set ab = BlzGetUnitAbility(dummy, this.abilId)

            // Меню изучения (V)
            set builder = TooltipBuilder.create()
            call builder.addDescription(desc)
            call builder.addBonus(ParseLevelTags(bns, 0))
            if (this.statBase != 0 or this.staticBase != 0) then
                call builder.addDamage(this.dmgType, FormulaList(this.statType, this.statBase, this.statStep, this.staticBase, this.staticStep, this.maxLv))
            endif
            if (this.dmgType2 != 0) then
                call builder.addCustomDamage(this.dmgType2, this.dmgName2, FormulaList(this.statType2, this.statBase2, this.statStep2, this.staticBase2, this.staticStep2, this.maxLv))
            endif
            call builder.addRange(ListRealField(ab, ABILITY_RLF_CAST_RANGE, 1, this.maxLv))
            call builder.addMechanic(ParseLevelTags(this.mecha, 0))
            call builder.addCooldownEx(ListCooldown(this.abilId, 1, this.maxLv), this.cdAfterDur)
            if (this.decor != "") then
                call builder.addDecorDamage(ParseLevelTags(this.decor, 0))
            endif
            call builder.addMana(ListMana(this.abilId, 1, this.maxLv))

            loop
                exitwhen i > this.maxLv
                call builder.applyToAbilityLearn(this.abilId, i)
                set i = i + 1
            endloop
            call builder.destroy()

            // Изученная способность на панели
            set i = 1
            loop
                exitwhen i > this.maxLv
                set builder = TooltipBuilder.create()
                call builder.addDescription(desc)
                call builder.addBonus(ParseLevelTags(bns, i))
                if (this.statBase != 0 or this.staticBase != 0) then
                    call builder.addDamage(this.dmgType, FormulaStr(this.statType, this.statBase, this.statStep, this.staticBase, this.staticStep, i))
                endif
                if (this.dmgType2 != 0) then
                    call builder.addCustomDamage(this.dmgType2, this.dmgName2, FormulaStr(this.statType2, this.statBase2, this.statStep2, this.staticBase2, this.staticStep2, i))
                endif
                call builder.addRange(ListRealField(ab, ABILITY_RLF_CAST_RANGE, i, i))
                call builder.addMechanic(ParseLevelTags(this.mecha, i))
                call builder.addCooldownEx(ListCooldown(this.abilId, i, i), this.cdAfterDur)
                if (this.decor != "") then
                    call builder.addDecorDamage(ParseLevelTags(this.decor, i))
                endif

                call builder.applyToAbility(this.abilId, i)
                call builder.destroy()
                set i = i + 1
            endloop

            call RemoveUnit(dummy)
            set dummy = null
            set ab = null
        endmethod

        static method create takes integer abilId, integer maxLv, integer dmgType, integer statType, real aBase, real aStep, real sBase, real sStep, string mecha, string bonus returns thistype
            local thistype this = thistype.allocate()
            set this.abilId = abilId
            set this.maxLv = maxLv
            set this.dmgType = dmgType
            set this.statType = statType
            set this.statBase = aBase
            set this.statStep = aStep
            set this.staticBase = sBase
            set this.staticStep = sStep
            set this.mecha = mecha
            set this.bonus = bonus

            set this.bMult1 = 0.0
            set this.bMult2 = 0.0
            set this.dmgType2 = 0
            set this.dmgName2 = ""
            set this.statType2 = 0
            set this.statBase2 = 0.0
            set this.statStep2 = 0.0
            set this.staticBase2 = 0.0
            set this.staticStep2 = 0.0
            set this.decor = ""
            set this.cdAfterDur = false

            call SaveInteger(HT_DATA, abilId, 0, this)
            call CaptureDesc(abilId)
            call this.SetInitialTips()
            return this
        endmethod
        
        static method createSimple takes integer abilId, integer maxLv, integer dmgType, integer statType, real aBase, real aStep, string mecha, string bonus returns thistype
            return thistype.create(abilId, maxLv, dmgType, statType, aBase, aStep, 0.0, 0.0, mecha, bonus)
        endmethod

        static method createUtility takes integer abilId, integer maxLv, string mecha, string bonus returns thistype
            return thistype.create(abilId, maxLv, 0, 0, 0.0, 0.0, 0.0, 0.0, mecha, bonus)
        endmethod

        static method createAlt takes integer abilId, integer formId, integer maxLv, integer dmgType, integer statType, real aBase, real aStep, real sBase, real sStep, string mecha, string bonus returns thistype
            local thistype this = thistype.allocate()
            set this.abilId = abilId
            set this.formId = formId
            set this.maxLv = maxLv
            set this.dmgType = dmgType
            set this.statType = statType
            set this.statBase = aBase
            set this.statStep = aStep
            set this.staticBase = sBase
            set this.staticStep = sStep
            set this.mecha = mecha
            set this.bonus = bonus

            set this.bMult1 = 0.0
            set this.bMult2 = 0.0
            set this.dmgType2 = 0
            set this.dmgName2 = ""
            set this.statType2 = 0
            set this.statBase2 = 0.0
            set this.statStep2 = 0.0
            set this.staticBase2 = 0.0
            set this.staticStep2 = 0.0
            set this.decor = ""
            set this.cdAfterDur = false

            call CaptureDesc(abilId)
            call SaveInteger(HT_DATA, abilId, formId, this)
            return this
        endmethod

        static method createUtilityAlt takes integer abilId, integer formId, integer maxLv, string mecha, string bonus returns thistype
            return thistype.createAlt(abilId, formId, maxLv, 0, 0, 0.0, 0.0, 0.0, 0.0, mecha, bonus)
        endmethod
    endstruct

    struct HeroData
        integer heroId
        integer formId
        integer array abilities[50]
        integer count = 0

        private method push takes integer abilId returns nothing
            if abilId != 0 and this.count < 50 then
                set this.abilities[this.count] = abilId
                set this.count = this.count + 1
            endif
        endmethod

        static method create takes integer heroId, integer formId, integer a1, integer a2, integer a3, integer a4, integer a5, integer a6, integer a7, integer a8, integer a9, integer a10 returns thistype
            local thistype this = thistype.allocate()
            set this.heroId = heroId
            set this.formId = formId
            set this.count = 0
            
            call this.push(a1)
            call this.push(a2)
            call this.push(a3)
            call this.push(a4)
            call this.push(a5)
            call this.push(a6)
            call this.push(a7)
            call this.push(a8)
            call this.push(a9)
            call this.push(a10)
            
            call SaveInteger(HT_DATA, heroId, 1000 + formId, this)
            return this
        endmethod

        method addExtra takes integer a1, integer a2, integer a3, integer a4, integer a5, integer a6, integer a7, integer a8, integer a9, integer a10 returns thistype
            call this.push(a1)
            call this.push(a2)
            call this.push(a3)
            call this.push(a4)
            call this.push(a5)
            call this.push(a6)
            call this.push(a7)
            call this.push(a8)
            call this.push(a9)
            call this.push(a10)
            return this
        endmethod
    endstruct

    function converttypedmg takes integer k returns integer 
        local integer i = 0
        if k == 1 then 
            set i = 2
        elseif k == 2 then 
            set i = 1
        endif
        return i
    endfunction

    private function RefreshSkill takes unit hero, integer abilId returns nothing
        local integer lvl
        local ability ab
        local SpellData data
        local real heroStat = 0.0
        local real heroStat2 = 0.0
        local TooltipBuilder builder
        local string dmgStr = ""
        local string dmgStr2 = ""
        local real cdBase = 0.0
        local real cdReal = 0.0
        local string cdStr = ""
        local integer formId
        local string bns = ""
        local real rawDamage = 0.0
        local real checkedDamage = 0.0
        local real rawDamage2 = 0.0
        local real checkedDamage2 = 0.0
        
        local integer heroHandle
        local integer keyStat
        local integer keyCd
        local integer keyLvl
        local integer keyDamage
        
        if (abilId == 0) then
            return
        endif
        
        set lvl = GetUnitAbilityLevel(hero, abilId)
        if (lvl <= 0 or not HaveSavedInteger(HT_DATA, abilId, 0)) then
            return
        endif
        
        set formId = LoadInteger(HT_DATA, GetHandleId(hero), 8888)
        set data = LoadInteger(HT_DATA, abilId, formId)
        if data == 0 then
            set data = LoadInteger(HT_DATA, abilId, 0)
        endif
        
        set ab = BlzGetUnitAbility(hero, abilId)
        
        // 1. Расчет основного урона
        if (data.statType == 1) then
            set heroStat = I2R(GetHeroStr(hero, true))
        elseif (data.statType == 2) then
            set heroStat = I2R(GetHeroAgi(hero, true))
        elseif (data.statType == 3) then
            set heroStat = I2R(GetHeroInt(hero, true))
        elseif (data.statType == 4) then
            set heroStat = GetAttack(hero) 
        endif

        if (data.statBase != 0.0 or data.statStep != 0.0 or data.staticBase != 0.0 or data.staticStep != 0.0) then
            set rawDamage = heroStat * (data.statBase + data.statStep * (lvl - 1)) + data.staticBase + data.staticStep * (lvl - 1)

            if TOOLTIP_DAMAGE_TARGET != null then
                set checkedDamage = DamageCheck(hero, TOOLTIP_DAMAGE_TARGET, rawDamage, converttypedmg(data.dmgType))
            else
                set checkedDamage = DamageCheck(hero, hero, rawDamage, converttypedmg(data.dmgType))
            endif
        endif

        // 2. Расчет дополнительного урона
        if (data.dmgType2 != 0) then
            if (data.statType2 == 1) then
                set heroStat2 = I2R(GetHeroStr(hero, true))
            elseif (data.statType2 == 2) then
                set heroStat2 = I2R(GetHeroAgi(hero, true))
            elseif (data.statType2 == 3) then
                set heroStat2 = I2R(GetHeroInt(hero, true))
            elseif (data.statType2 == 4) then
                set heroStat2 = GetAttack(hero) 
            endif
            
            set rawDamage2 = heroStat2 * (data.statBase2 + data.statStep2 * (lvl - 1)) + data.staticBase2 + data.staticStep2 * (lvl - 1)
            if TOOLTIP_DAMAGE_TARGET != null then
                set checkedDamage2 = DamageCheck(hero, TOOLTIP_DAMAGE_TARGET, rawDamage2, converttypedmg(data.dmgType2))
            else
                set checkedDamage2 = DamageCheck(hero, hero, rawDamage2, converttypedmg(data.dmgType2))
            endif
        endif

        set cdBase = BlzGetAbilityCooldown(abilId, lvl - 1)
        set cdReal = BlzGetUnitAbilityCooldown(hero, abilId, lvl - 1)

        set heroHandle = GetHandleId(hero)
        set keyStat = abilId           
        set keyCd = abilId + 1000000   
        set keyLvl = abilId + 2000000  
        set keyDamage = abilId + 3000000 
        
        if HaveSavedReal(HT_DATA, heroHandle, keyStat) then
            if (data.statBase != 0.0 or data.staticBase != 0.0 or cdBase > 0.0) then
                if (LoadReal(HT_DATA, heroHandle, keyStat) == heroStat) and (LoadReal(HT_DATA, heroHandle, keyCd) == cdReal) and (LoadInteger(HT_DATA, heroHandle, keyLvl) == lvl) and (LoadReal(HT_DATA, heroHandle, keyDamage) == checkedDamage) then
                    set ab = null
                    return 
                endif
            endif
        endif
        
        call SaveReal(HT_DATA, heroHandle, keyStat, heroStat)
        call SaveReal(HT_DATA, heroHandle, keyCd, cdReal)
        call SaveInteger(HT_DATA, heroHandle, keyLvl, lvl)
        call SaveReal(HT_DATA, heroHandle, keyDamage, checkedDamage)

        if (data.statBase != 0 or data.statStep != 0 or data.staticBase != 0 or data.staticStep != 0) then
            if (data.statType != 0) then
                set dmgStr = FormulaStr(data.statType, data.statBase, data.statStep, data.staticBase, data.staticStep, lvl) + " (" + FormatReal(checkedDamage) + ")"
            else
                set dmgStr = FormatReal(checkedDamage)
            endif
        endif
        
        if (data.dmgType2 != 0) then
            if (data.statType2 != 0) then
                set dmgStr2 = FormulaStr(data.statType2, data.statBase2, data.statStep2, data.staticBase2, data.staticStep2, lvl) + " (" + FormatReal(checkedDamage2) + ")"
            else
                set dmgStr2 = FormatReal(checkedDamage2)
            endif
        endif
        
        set cdStr = FormatReal(cdBase)
        if (cdReal > 0 and cdReal != cdBase) then
            set cdStr = cdStr + " (" + FormatReal(cdReal) + ")"
        endif
        
        set bns = data.bonus
        if (data.bMult1 != 0.0) then
            set bns = StringReplace(bns, "<V1>", I2S(R2I(heroStat * data.bMult1)))
        endif
        if (data.bMult2 != 0.0) then
            set bns = StringReplace(bns, "<V2>", I2S(R2I(heroStat * data.bMult2)))
        endif
        
        set builder = TooltipBuilder.create()
        call builder.addDescription(GetDesc(abilId))
        call builder.addBonus(ParseLevelTags(bns, lvl))
        
        if (dmgStr != "") then
            call builder.addDamage(data.dmgType, dmgStr)
        endif
        
        if (dmgStr2 != "") then
            call builder.addCustomDamage(data.dmgType2, data.dmgName2, dmgStr2)
        endif
        
        call builder.addRange(ListRealField(ab, ABILITY_RLF_CAST_RANGE, lvl, lvl)) 
        call builder.addMechanic(ParseLevelTags(data.mecha, lvl))
        call builder.addCooldownEx(cdStr, data.cdAfterDur)

        if (data.decor != "") then
            call builder.addDecorDamage(ParseLevelTags(data.decor, lvl))
        endif
        
        call builder.applyToAbility(abilId, lvl)
        call builder.destroy()
        
        set ab = null
    endfunction
    
    public function UpdateHeroTooltips takes unit hero returns nothing
        local integer heroId = GetUnitTypeId(hero)
        local integer formId = LoadInteger(HT_DATA, GetHandleId(hero), 8888)
        local HeroData hData = 0
        local integer i = 0
        
        if HaveSavedInteger(HT_DATA, heroId, 1000 + formId) then
            set hData = LoadInteger(HT_DATA, heroId, 1000 + formId)
        elseif HaveSavedInteger(HT_DATA, heroId, 1000) then
            set hData = LoadInteger(HT_DATA, heroId, 1000)
        endif

        if hData != 0 then
            loop
                exitwhen i >= hData.count
                call RefreshSkill(hero, hData.abilities[i])
                set i = i + 1
            endloop
        endif
    endfunction

    public function SetUnitForm takes unit hero, integer formId returns nothing
        call FlushChildHashtable(HT_DATA, GetHandleId(hero))
        call SaveInteger(HT_DATA, GetHandleId(hero), 8888, formId)
        call UpdateHeroTooltips(hero)
    endfunction

    private function CheckAndSavePreviewState takes unit u returns boolean
        local integer hid = GetHandleId(u)
        local integer unitType = GetUnitTypeId(u)
        local real str = I2R(GetHeroStr(u, true))
        local real agi = I2R(GetHeroAgi(u, true))
        local real int = I2R(GetHeroInt(u, true))
        local real attack = GetAttack(u)
        local real normalFactor
        local real magicFactor
        local real physicalFactor
        local boolean changed = false

        if TOOLTIP_DAMAGE_TARGET != null then
            set normalFactor = DamageCheck(u, TOOLTIP_DAMAGE_TARGET, 1.0, 0)
            set magicFactor = DamageCheck(u, TOOLTIP_DAMAGE_TARGET, 1.0, 1)
            set physicalFactor = DamageCheck(u, TOOLTIP_DAMAGE_TARGET, 1.0, 2)
        else
            set normalFactor = DamageCheck(u, u, 1.0, 0)
            set magicFactor = DamageCheck(u, u, 1.0, 1)
            set physicalFactor = DamageCheck(u, u, 1.0, 2)
        endif

        if not HaveSavedInteger(HT_DATA, hid, POLL_KEY_TYPE) then
            set changed = true
        elseif LoadInteger(HT_DATA, hid, POLL_KEY_TYPE) != unitType then
            set changed = true
        elseif LoadReal(HT_DATA, hid, POLL_KEY_STR) != str then
            set changed = true
        elseif LoadReal(HT_DATA, hid, POLL_KEY_AGI) != agi then
            set changed = true
        elseif LoadReal(HT_DATA, hid, POLL_KEY_INT) != int then
            set changed = true
        elseif LoadReal(HT_DATA, hid, POLL_KEY_ATTACK) != attack then
            set changed = true
        elseif LoadReal(HT_DATA, hid, POLL_KEY_NORMAL) != normalFactor then
            set changed = true
        elseif LoadReal(HT_DATA, hid, POLL_KEY_MAGIC) != magicFactor then
            set changed = true
        elseif LoadReal(HT_DATA, hid, POLL_KEY_PHYSICAL) != physicalFactor then
            set changed = true
        endif

        if changed then
            call SaveInteger(HT_DATA, hid, POLL_KEY_TYPE, unitType)
            call SaveReal(HT_DATA, hid, POLL_KEY_STR, str)
            call SaveReal(HT_DATA, hid, POLL_KEY_AGI, agi)
            call SaveReal(HT_DATA, hid, POLL_KEY_INT, int)
            call SaveReal(HT_DATA, hid, POLL_KEY_ATTACK, attack)
            call SaveReal(HT_DATA, hid, POLL_KEY_NORMAL, normalFactor)
            call SaveReal(HT_DATA, hid, POLL_KEY_MAGIC, magicFactor)
            call SaveReal(HT_DATA, hid, POLL_KEY_PHYSICAL, physicalFactor)
        endif

        return changed
    endfunction

    private function OnRefreshTimeout takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer timerId = GetHandleId(t)
        local unit u = LoadUnitHandle(HT_TIMERS, timerId, 0)
        local boolean stateWasChanged
        
        if (u != null) then
            call SaveBoolean(HT_TIMERS, GetHandleId(u), TIMER_KEY_PENDING, false)
            if GetUnitTypeId(u) != 0 then
                call UpdateHeroTooltips(u)
                set stateWasChanged = CheckAndSavePreviewState(u)
            endif
        endif
        
        call RelT(t)
        set t = null
        set u = null
    endfunction

    public function RequestHeroTooltipUpdate takes unit u returns nothing
        local integer hid
        local integer pid
        local timer t

        if u == null or not HaveSavedInteger(HT_DATA, GetUnitTypeId(u), 1000) then
            return
        endif

        set hid = GetHandleId(u)
        set pid = GetPlayerId(GetOwningPlayer(u))

        if pid >= 0 and pid <= 11 then
            set WATCHED_HERO[pid] = u
        endif

        if not LoadBoolean(HT_TIMERS, hid, TIMER_KEY_PENDING) then
            call SaveBoolean(HT_TIMERS, hid, TIMER_KEY_PENDING, true)
            set t = GetT()
            call SaveUnitHandle(HT_TIMERS, GetHandleId(t), 0, u)
            call TimerStart(t, 0.05, false, function OnRefreshTimeout)
        endif

        set t = null
    endfunction

    private function OnHeroEvent takes nothing returns nothing
        call RequestHeroTooltipUpdate(GetTriggerUnit())
    endfunction

    private function OnPollTimeout takes nothing returns nothing
        local integer i = 0
        local unit u

        loop
            exitwhen i > 11
            set u = WATCHED_HERO[i]

            if u != null and GetUnitTypeId(u) != 0 then
                if CheckAndSavePreviewState(u) then
                    call RequestHeroTooltipUpdate(u)
                endif
            endif

            set i = i + 1
        endloop

        set u = null
    endfunction
    
    private function InitHeroes_Part1 takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local HeroData form

        // ===========================================================================
        // 1. Сакадзуки Акаину (Akainu_ID) -> Ловкость (2)
        // ===========================================================================
        // --- БАЗОВЫЕ СПОСОБНОСТИ ---
        call SpellData.create(AkainuQ_ID, 5, 1, 2, AkainuQ_DamageAgiBase, AkainuQ_DamageAgiStep, AkainuQ_Damage2StaticBase, AkainuQ_Damage2StaticStep, T_Rad(AkainuQ_DamageAoe) + T_CastAuto(AkainuQ_CastTime, AkainuQ_IsInvul) + T_Stun(AkainuQ_Stun) + T_Push(AkainuQ_PushRange) + T_Dur("Push Duration", AkainuQ_PushDuration), T_Bonus("Lv. 35 Magma Mastery", "Hits apply Great Eruption (F) bonus damage.")).setDecor(T_Decor(AkainuQ_DecorDamage))
        call SpellData.create(AkainuW_ID, 5, 2, 2, AkainuW_DamageAgiBase, AkainuW_DamageAgiStep, AkainuW_Damage2StaticBase, AkainuW_Damage2StaticStep, T_Prop("Punches", AkainuW_Fists) + T_Prop("Search Radius", AkainuW_DamageAoe) + T_RadExp(0, AkainuW_DamageAoePunch) + T_CastAuto(AkainuW_CastTime, AkainuW_IsInvul) + T_Slow(AkainuW_Slow, AkainuW_Duration), "").setDecor(T_DecorExp(AkainuW_DecorFlightDamage, AkainuW_DecorImpactDamage))
        call SpellData.createSimple(AkainuE_ID, 5, 2, 2, AkainuE_DamageAgiBase, AkainuE_DamageAgiStep, T_Rad(AkainuE_DamageAoe) + T_CastAuto(AkainuE_CastTime, AkainuE_IsInvul), "").setDecor(T_Decor(AkainuE_DecorDamage))
        call SpellData.createSimple(AkainuR_ID, 5, 1, 2, AkainuR_DamageAgiBase, AkainuR_DamageAgiStep, T_Rad(AkainuR_DamageAoe) + T_CastAuto(AkainuR_CastTime, AkainuR_IsInvul) + T_Stun(AkainuR_Stun) + T_Push(AkainuR_PushRange) + T_Dur("Push Duration", AkainuR_PushDuration), T_Bonus("Lv. 35 Magma Mastery", "Hits apply Great Eruption (F) bonus damage.")).setDecor(T_Decor(AkainuR_DecorDamage))
        call SpellData.createSimple(AkainuT_ID, 1, 2, 2, AkainuT_DamageAgiBase, 0.0, T_Prop("Meteors", AkainuT_Fists) + T_Prop("Area Radius", AkainuT_DamageAoe) + T_RadExp(0, AkainuT_DamageAoePunch) + T_CastAuto(AkainuT_CastTime, AkainuT_IsInvul) + T_Slow(AkainuT_Slow, AkainuT_Duration), "").setDecor(T_Decor(AkainuT_DecorDamage))
        call SpellData.createUtility(AkainuF_ID, 1, T_PropS("Phys. Resist", FormatInt(AkainuF_DamagePhysResist) + "%") + T_Dur("Cooldown", AkainuF_CD), T_Bonus("Lv. 35 Magma Mastery", "Q and R hits trigger Great Eruption, dealing Agility x " + FormatReal(AkainuF_Damage) + " physical damage (" + FormatReal(AkainuF_CD) + " sec CD)."))
        // --- РЕГИСТРАЦИЯ НАБОРА СПОСОБНОСТЕЙ ГЕРОЯ ---
        set form = HeroData.create(Akainu_ID, 0, AkainuQ_ID, AkainuW_ID, AkainuE_ID, AkainuR_ID, AkainuT_ID, AkainuF_ID, 0, 0, 0, 0)
        
        // ===========================================================================
        // 2. Аинз Оал Гоун (Ainz_ID) -> Интеллект (3)
        // ===========================================================================
        // --- ФОРМА 0 (БАЗОВАЯ) ---
        call SpellData.create(AinzQ_ID, 5, 2, 3, AinzQ_DamageIntBase, AinzQ_DamageIntStep, AinzQ_Damage2StaticBase, AinzQ_Damage2StaticStep, T_Rad(AinzQ_DamageAoe) + T_Prop("Trigger Radius", AinzQ_MineTriggerAoe) + T_Dur("Mine Lifetime", AinzQ_MineDuration) + T_Prop("Chain Radius", AinzQ_MineChainAoe) + T_Prop("Min Spacing", AinzQ_MineMinDistance), T_Bonus("Dozen Layer Buffs (F)", "Chanting unlocks Ring of Mines (Q2) for " + FormatInt(AinzF_Q2Duration) + " sec") + T_Bonus("Chain Reaction", "Detonation triggers all armed mines within " + FormatInt(AinzQ_MineChainAoe) + " AoE") + T_Bonus("T Mode", "Replaced by Twin Dragon Lightning (Q3)")).setDecor(T_Decor(AinzQ_DecorDamage))
        call SpellData.create(AinzW_ID, 5, 1, 3, AinzW2_DamageIntBase, AinzW2_DamageIntStep, AinzW2_Damage2StaticBase, AinzW2_Damage2StaticStep, T_PropS("Knights Summoned", "<L:1/2/3/4/5>") + T_PropS("Knight HP", "<L:" + I2S(AinzW_SummonHpBase) + "/" + I2S(AinzW_SummonHpBase + AinzW_SummonHpStep) + "/" + I2S(AinzW_SummonHpBase + AinzW_SummonHpStep*2) + "/" + I2S(AinzW_SummonHpBase + AinzW_SummonHpStep*3) + "/" + I2S(AinzW_SummonHpBase + AinzW_SummonHpStep*4) + ">") + T_Dur("Duration", AinzW_Duration) + T_Prop("Hit Radius", AinzW_KnightHitAoe), T_Bonus("Active (W2)", "Orders closest Knight to charge or protect an ally") + T_Bonus("Active (W3)", "Orders up to 3 Knights to charge in formation") + T_Bonus("T Mode", "Replaced by Negative Burst (W4)")).setDecor(T_Decor(AinzW_DecorDamage))
        call SpellData.createSimple(AinzE_ID, 5, 1, 3, AinzE_DamageIntBase, AinzE_DamageIntStep, T_Prop("Wall Length", AinzE_WallLength) + T_Prop("Wall Width", AinzE_RectWidth) + T_PropS("Duration", "<L:" + FormatReal(AinzE_DurationBase) + "/" + FormatReal(AinzE_DurationBase+AinzE_DurationStep) + "/" + FormatReal(AinzE_DurationBase+AinzE_DurationStep*2) + "/" + FormatReal(AinzE_DurationBase+AinzE_DurationStep*3) + "/" + FormatReal(AinzE_DurationBase+AinzE_DurationStep*4) + "> sec") + T_Slow(I2R(AinzE_Slow), 1.0), T_Bonus("Wall Collision", "Enemies pushed into wall take Int x " + FormatReal(AinzE_WallHitDamageInt) + " Mag. Dmg and are stunned for " + FormatReal(AinzE_WallHitStun) + " sec") + T_Bonus("Ability Lv. 5", "Unlocks Hold of Ribs (E2)") + T_Bonus("T Mode", "Replaced by Black Hole (E3)")).setDecor(T_Decor(AinzE_DecorDamage))
        call SpellData.create(AinzR_ID, 5, 2, 3, AinzR_DamageIntBase, AinzR_DamageIntStep, AinzR_Damage2StaticBase, AinzR_Damage2StaticStep, T_Rad(AinzR_DamageAoe) + T_CastAuto(AinzR_CastTime, AinzR_IsInvul) + T_Element(AinzR_Debuff), T_Bonus("T Mode", "Replaced by Reality Slash (R2)")).setDecor(T_Decor(AinzR_DecorDamage))
        call SpellData.createUtility(AinzT_ID, 1, T_Dur("Chant Duration", AinzT_Duration) + T_Dur("T Mode Duration", AinzT_AddDuration) + T_Rad(AinzT_DamageAoe) + T_PropS("All Resistances Reduction", "-" + FormatInt(AinzT_ResistReduce) + "%") + T_PropS("Cooldown Reduction", "10 sec"), T_Bonus("Empowerment", "Instantly cuts remaining basic cooldowns by 10 sec and transforms Q, W, E, R into Super-Tier spells") + T_Bonus("Death Toll", "After 12 sec chant, shreds enemy resistances in a massive area for " + FormatInt(AinzT_AddDuration) + " sec")).setDecor(T_Decor(AinzT_DecorDamage))
        call SpellData.createUtility(AinzF_ID, 1, T_PropS("Channeling", "<L:2.1/5.8/9.0> sec (Lv. 12/25/35)") + T_Dur("Q2 Duration", AinzF_Q2Duration), T_Bonus("Chant Layers", "Grants up to 6 cumulative combat buffs during channeling and unlocks Ring of Mines (Q2)"))
        call SpellData.create(AinzG_ID, 1, 2, 3, AinzG_DamageIntBase, AinzG_DamageIntStep, 0.0, 0.0, T_Rad(AinzG_Aoe) + T_CastAuto(AinzG_PrepareTime, AinzG_IsInvul) + T_DurAuto(AinzG_Duration, AinzG_IsInvul) + T_Prop("Pulses", AinzG_DamageCount) + T_Dur("Pulse Interval", AinzG_DamagePeriod), "").setDecor(T_Decor(AinzG_DecorDamage))
        // --- ДОПОЛНИТЕЛЬНЫЕ И СВЯЗАННЫЕ СПОСОБНОСТИ ---
        call SpellData.create(AinzQ2_ID, 5, 2, 3, AinzQ_DamageIntBase, AinzQ_DamageIntStep, AinzQ_Damage2StaticBase, AinzQ_Damage2StaticStep, T_Rad(AinzQ_DamageAoe) + T_Prop("Ring Radius", AinzQ2_MineOffset) + T_Prop("Mines Placed", AinzQ2_MineCount) + T_Dur("Mine Lifetime", AinzQ_MineDuration), T_Bonus("Formation", "Places 6 mines in a ring around target area")).setDecor(T_Decor(AinzQ2_DecorDamage))
        call SpellData.create(AinzW2_ID, 5, 1, 3, AinzW2_DamageIntBase, AinzW2_DamageIntStep, AinzW2_Damage2StaticBase, AinzW2_Damage2StaticStep, T_Prop("Charge Range", AinzW_KnightRunRange) + T_Prop("Hit Radius", AinzW_KnightHitAoe), T_Bonus("Target Ally", "Grants protective shield. When ally is attacked, nearest Knight teleports and counter-charges attacker") + T_Bonus("Wall Collision", "Enemies pushed into Wall of Skeleton (E) take Int x " + FormatReal(AinzE_WallHitDamageInt) + " Mag. Dmg and are stunned for " + FormatReal(AinzE_WallHitStun) + " sec")).setDecor(T_Decor(AinzW2_DecorDamage))
        call SpellData.create(AinzW3_ID, 5, 1, 3, AinzW2_DamageIntBase, AinzW2_DamageIntStep, AinzW2_Damage2StaticBase, AinzW2_Damage2StaticStep, T_Prop("Charge Range", AinzW_KnightRunRange) + T_Prop("Hit Radius", AinzW_KnightHitAoe) + T_Prop("Knights", 3), T_Bonus("Formation Charge", "Teleports up to 3 living Knights in line and charges together") + T_Bonus("Wall Collision", "Enemies pushed into Wall of Skeleton (E) take Int x " + FormatReal(AinzE_WallHitDamageInt) + " Mag. Dmg and are stunned for " + FormatReal(AinzE_WallHitStun) + " sec")).setDecor(T_Decor(AinzW3_DecorDamage))
        call SpellData.createSimple(AinzE2_ID, 5, 1, 3, AinzE2_DamageIntBase, AinzE2_DamageIntStep, T_Root(AinzE2_RootDuration) + T_Dur("Damage Interval", AinzE2_DamagePeriod), T_Bonus("Ability Lv. 5", "Traps target inside bone cage, dealing continuous physical damage")).setDecor(T_Decor(AinzE2_DecorDamage))
        // --- СПОСОБНОСТИ T-РЕЖИМА (The Goal of All Life is Death) ---
        call SpellData.create(AinzQ3_ID, 5, 2, 3, AinzTQ_DamageIntBase, 0.0, 0.0, 0.0, T_RadExp(AinzTQ_DamageAoe, AinzTQ_DamageAoe2) + T_CastAuto(AinzTQ_CastTime, AinzTQ_IsInvul) + T_Prop("Max Bounces", AinzTQ_MaxChain) + T_Prop("Search Range", AinzTQ_SearchAoe), T_Bonus("Form", "|cff00BFFFT Mode: Twin Dragon Lightning|r")).setDecor(T_Decor(AinzTQ_DecorDamage))
        call SpellData.create(AinzW4_ID, 5, 1, 3, AinzTW_DamageIntBase, 0.0, 0.0, 0.0, T_Rad(AinzTW_DamageAoe) + T_CastAuto(AinzTW_CastTime, AinzTW_IsInvul) + T_Slow(I2R(AinzTW_Slow), I2R(AinzTW_Duration)), T_Bonus("Form", "|cff00BFFFT Mode: Negative Burst|r")).setDecor(T_Decor(AinzTW_DecorDamage))
        call SpellData.create(AinzE3_ID, 5, 2, 3, AinzTE_DamageIntBase, 0.0, 0.0, 0.0, T_Rad(AinzTE_DamageAoe) + T_DurAuto(AinzTE_Duration, AinzTE_IsInvul) + T_Prop("Pulses", AinzTE_PulseCount) + T_Prop("Pull Range", AinzTE_PullMaxRange), T_Bonus("Form", "|cff00BFFFT Mode: Black Hole|r")).setDecor(T_Decor(AinzTE_DecorDamage))
        call SpellData.create(AinzR2_ID, 5, 2, 3, AinzTR_DamageIntBase, AinzTR_DamageIntStep, 0.0, 0.0, T_Prop("Max Range", AinzTR_MaxRange) + T_CastAuto(AinzTR_CastTime, AinzTR_IsInvul) + T_Push(AinzR_PushRange), T_Bonus("Form", "|cff00BFFFT Mode: Reality Slash|r") + T_Bonus("Wall Collision", "Enemies pushed into Wall of Skeleton (E) take Int x " + FormatReal(AinzE_WallHitDamageInt) + " Mag. Dmg and are stunned for " + FormatReal(AinzE_WallHitStun) + " sec")).setDecor(T_Decor(AinzTR_DecorDamage))
        // --- РЕГИСТРАЦИЯ НАБОРОВ СПОСОБНОСТЕЙ ГЕРОЯ ---
        // Форма 0: Базовый набор
        set form = HeroData.create(Ainz_ID, 0, AinzQ_ID, AinzW_ID, AinzE_ID, AinzR_ID, AinzT_ID, AinzF_ID, AinzG_ID, AinzQ2_ID, AinzW2_ID, AinzW3_ID)
        call form.addExtra(AinzE2_ID, AinzQ3_ID, AinzW4_ID, AinzE3_ID, AinzR2_ID, 0, 0, 0, 0, 0)
        // Форма 1: Режим The Goal of All Life is Death
        set form = HeroData.create(Ainz_ID, 1, AinzQ3_ID, AinzW4_ID, AinzE3_ID, AinzR2_ID, AinzT_ID, AinzF_ID, AinzG_ID, 0, 0, 0)
        
        // ===========================================================================
        // 3. Лексус Дреяр (Laxus_ID) -> Сила (1)
        // ===========================================================================
        // --- ФОРМА 0 (БАЗОВАЯ) ---
        call SpellData.create(LaxusQ_ID, 5, 2, 1, LaxusQ_DamageStrBase, LaxusQ_DamageStrStep, LaxusQ_Damage2StaticBase, LaxusQ_Damage2StaticStep, T_Rad(LaxusQ_DamageAoe) + T_CastAuto(LaxusQ_CastTime, LaxusQ_IsInvul), T_Bonus("Dragon Slayer Mode", "Replaced by piercing beam Raienryuu Roar (Q2)") + T_Bonus("Red Lightning Mode (Lv. 35)", "Roar gains additional +Str x " + FormatReal(LaxusGQ2_DamageStrBonus) + " damage")).setDecor(T_Decor(LaxusQ_DecorDamage))
        call SpellData.create(LaxusW_ID, 5, 1, 1, LaxusW_DamageStrBase, LaxusW_DamageStrStep, LaxusW_Damage2StaticBase, LaxusW_Damage2StaticStep, T_CastAuto(LaxusW_CastTime, LaxusW_IsInvul) + T_Stun(LaxusW_Stun) + T_Push(LaxusW_PushRange), T_Bonus("Ability Lv. 5", "Landing the strike unlocks Roaring Thunder Crush (W2) for 3 sec") + T_Bonus("Dragon Slayer Mode", "Applies Electro debuff") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGW_DamageStrBonus2) + " damage")).setDecor(T_Decor(LaxusW_DecorDamage))
        call SpellData.create(LaxusE_ID, 5, 1, 1, LaxusE_DamageStrBase, LaxusE_DamageStrStep, LaxusE_Damage2StaticBase, LaxusE_Damage2StaticStep, T_Rad(LaxusE_DamageAoe) + T_CastAuto(LaxusE_CastTime, LaxusE_IsInvul) + T_Element(LaxusE_Debuff) + T_Slow(I2R(LaxusE_Slow), I2R(LaxusE_Duration)), T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGE_DamageStrBonus2) + " damage")).setDecor(T_Decor(LaxusE_DecorDamage))
        call SpellData.create(LaxusR_ID, 5, 2, 1, LaxusR_DamageStrBase, LaxusR_DamageStrStep, LaxusR_Damage2StaticBase, LaxusR_Damage2StaticStep, T_RadExp(LaxusR_DamageAoe, LaxusR_DamageAoe2) + T_CastAuto(LaxusR_CastTime, LaxusR_IsInvul) + T_Stun(LaxusR_Stun), T_Bonus("Electrified Target", "+" + FormatInt(LaxusR_DamageBonus) + "% Damage against targets with Electro debuff") + T_Bonus("Synergy (Natsu)", "Targeting ally Natsu (Lv. 25+) awakens his Raienryuu Mode for 20 sec (60 sec CD)") + T_Bonus("Dragon Slayer Mode", "Deals +Str x " + FormatReal(LaxusGR_DamageStrBonus) + " damage and applies Electro debuff") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGR_DamageStrBonus2) + " damage (+Str x 2.0 total bonus)")).setDecor(T_DecorExp(LaxusR_DecorDamage, LaxusR_ExplosionDecorDamage))
        call SpellData.createSimple(LaxusT_ID, 1, 2, 1, LaxusT_DamageStrBase, 0.0, T_Rad(LaxusT_DamageAoe) + T_CastAuto(LaxusT_CastTime, LaxusT_IsInvul) + T_Silence(LaxusT_Silence), "").setDecor(T_Decor(LaxusT_DecorDamage))
        call SpellData.createUtility(LaxusG_ID, 1, T_Dur("Duration", LaxusG_Duration) + T_PropS("Empowerment", "Replaces Q with Raienryuu Roar (Q2)|nAll abilities apply Electro debuff"), T_Bonus("Lv. 35 Red Lightning", "+" + FormatInt(LaxusG_HpBonus35) + " Max HP, transforms into Red Lightning Mode and adds +Str x 1.0 damage to all abilities")).setDecor(T_Decor(LaxusG_DecorDamage))
        call SpellData.createSimple(LaxusF_ID, 1, 1, 1, LaxusF_DamageStrBase, 0.0, T_CastAuto(LaxusF_CastTime, LaxusF_IsInvul) + T_Element(LaxusF_Debuff) + T_Stun(LaxusF_Stun) + T_Push(LaxusF_PushRange), T_Bonus("Lv. 25 Instinct", "Unlocks when an ally within " + FormatInt(LaxusF_AoeSearch) + " takes " + FormatInt(LaxusF_DmgPorog) + "+ damage (5 sec CD)|nActive: Teleports in lightning form and counter-strikes") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGF_DamageStrBonus2) + " damage")).setDecor(T_Decor(LaxusF_DecorDamage))

        // --- ДОПОЛНИТЕЛЬНЫЕ СПОСОБНОСТИ ФОРМЫ 0 ---
        call SpellData.create(LaxusQ2_ID, 5, 2, 1, LaxusQ_DamageStrBase, LaxusQ_DamageStrStep, LaxusQ_Damage2StaticBase, LaxusQ_Damage2StaticStep, T_RadExp(LaxusQ2_DamageAoe, LaxusQ2_DamageAoe2) + T_CastAuto(LaxusQ2_CastTime, LaxusQ2_IsInvul) + T_Prop("Range", LaxusQ_Range2) + T_Element(LaxusQ2_Debuff), T_Bonus("Dragon Slayer Mode", "Replaces Lightning Strike during transformation") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGQ2_DamageStrBonus) + " damage")).setDecor(T_DecorExp(LaxusQ2_DecorDamage, LaxusQ2_ExplosionDecorDamage))
        call SpellData.create(LaxusW2_ID, 1, 1, 1, LaxusW2_DamageStrBase, 0.0, 0.0, 0.0, T_Rad(LaxusW2_DamageAoe) + T_CastAuto(LaxusW2_CastTime, LaxusW2_IsInvul) + T_Stun(LaxusW2_Stun), T_Bonus("Combo Activation", "Available for 3 sec after landing Lightning Dragon Jaw (W)") + T_Bonus("Dragon Slayer Mode", "Applies Electro debuff") + T_Bonus("Red Lightning Mode (Lv. 35)", "Both strikes deal additional +Str x " + FormatReal(LaxusGW2_DamageStrBonus2) + " damage")).setSecondDamage(2, "Mag. Damage (Explosion):", 1, LaxusW2_DamageStrBase2, 0.0, 0.0, 0.0).setDecor(T_Decor(LaxusW2_DecorDamage))

        // --- ФОРМА 1 (LIGHTNING DRAGON SLAYER MODE - MODE G) ---
        call SpellData.createAlt(LaxusQ2_ID, 1, 5, 2, 1, LaxusQ_DamageStrBase, LaxusQ_DamageStrStep, LaxusQ_Damage2StaticBase, LaxusQ_Damage2StaticStep, T_RadExp(LaxusQ2_DamageAoe, LaxusQ2_DamageAoe2) + T_CastAuto(LaxusQ2_CastTime, LaxusQ2_IsInvul) + T_Prop("Range", LaxusQ_Range2) + T_Element(LaxusQ2_Debuff), T_Bonus("Form", "|cff9933ffDragon Slayer Mode|r") + T_Bonus("Red Lightning Mode (Lv. 35)", "Gains additional +Str x " + FormatReal(LaxusGQ2_DamageStrBonus) + " damage")).setDecor(T_DecorExp(LaxusQ2_DecorDamage, LaxusQ2_ExplosionDecorDamage))
        call SpellData.createAlt(LaxusW_ID, 1, 5, 1, 1, LaxusW_DamageStrBase, LaxusW_DamageStrStep, LaxusW_Damage2StaticBase, LaxusW_Damage2StaticStep, T_CastAuto(LaxusW_CastTime, LaxusW_IsInvul) + T_Element(LaxusW_Debuff) + T_Stun(LaxusW_Stun) + T_Push(LaxusW_PushRange), T_Bonus("Form", "|cff9933ffDragon Slayer Mode|r") + T_Bonus("Ability Lv. 5", "Landing the strike unlocks Roaring Thunder Crush (W2) for 3 sec") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGW_DamageStrBonus2) + " damage")).setDecor(T_Decor(LaxusW_DecorDamage))
        call SpellData.createAlt(LaxusW2_ID, 1, 1, 1, 1, LaxusW2_DamageStrBase, 0.0, 0.0, 0.0, T_Rad(LaxusW2_DamageAoe) + T_CastAuto(LaxusW2_CastTime, LaxusW2_IsInvul) + T_Element(LaxusW2_Debuff) + T_Stun(LaxusW2_Stun), T_Bonus("Form", "|cff9933ffDragon Slayer Mode|r") + T_Bonus("Red Lightning Mode (Lv. 35)", "Both strikes deal additional +Str x " + FormatReal(LaxusGW2_DamageStrBonus2) + " damage")).setSecondDamage(2, "Mag. Damage (Explosion):", 1, LaxusW2_DamageStrBase2, 0.0, 0.0, 0.0).setDecor(T_Decor(LaxusW2_DecorDamage))
        call SpellData.createAlt(LaxusE_ID, 1, 5, 1, 1, LaxusE_DamageStrBase, LaxusE_DamageStrStep, LaxusE_Damage2StaticBase, LaxusE_Damage2StaticStep, T_Rad(LaxusE_DamageAoe) + T_CastAuto(LaxusE_CastTime, LaxusE_IsInvul) + T_Element(LaxusE_Debuff) + T_Slow(I2R(LaxusE_Slow), I2R(LaxusE_Duration)), T_Bonus("Form", "|cff9933ffDragon Slayer Mode|r") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGE_DamageStrBonus2) + " damage")).setDecor(T_Decor(LaxusE_DecorDamage))
        call SpellData.createAlt(LaxusR_ID, 1, 5, 2, 1, LaxusR_DamageStrBase + LaxusGR_DamageStrBonus, LaxusR_DamageStrStep, LaxusR_Damage2StaticBase, LaxusR_Damage2StaticStep, T_RadExp(LaxusR_DamageAoe, LaxusR_DamageAoe2) + T_CastAuto(LaxusR_CastTime, LaxusR_IsInvul) + T_Element(3) + T_Stun(LaxusR_Stun), T_Bonus("Form", "|cff9933ffDragon Slayer Mode|r") + T_Bonus("Electrified Target", "+" + FormatInt(LaxusR_DamageBonus) + "% Damage against targets with Electro debuff") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGR_DamageStrBonus2) + " damage")).setDecor(T_DecorExp(LaxusR_DecorDamage, LaxusR_ExplosionDecorDamage))
        call SpellData.createAlt(LaxusF_ID, 1, 1, 1, 1, LaxusF_DamageStrBase, 0.0, 0.0, 0.0, T_CastAuto(LaxusF_CastTime, LaxusF_IsInvul) + T_Element(LaxusF_Debuff) + T_Stun(LaxusF_Stun) + T_Push(LaxusF_PushRange), T_Bonus("Form", "|cff9933ffDragon Slayer Mode|r") + T_Bonus("Red Lightning Mode (Lv. 35)", "Deals additional +Str x " + FormatReal(LaxusGF_DamageStrBonus2) + " damage")).setDecor(T_Decor(LaxusF_DecorDamage))

        // --- ФОРМА 2 (RED LIGHTNING DRAGON MODE - LV. 35) ---
        call SpellData.createAlt(LaxusQ2_ID, 2, 5, 2, 1, LaxusQ_DamageStrBase + LaxusGQ2_DamageStrBonus, LaxusQ_DamageStrStep, LaxusQ_Damage2StaticBase, LaxusQ_Damage2StaticStep, T_RadExp(LaxusQ2_DamageAoe, LaxusQ2_DamageAoe2) + T_CastAuto(LaxusQ2_CastTime, LaxusQ2_IsInvul) + T_Prop("Range", LaxusQ_Range2) + T_Element(LaxusQ2_Debuff), T_Bonus("Form", "|cffFF0000Red Lightning Mode|r") + T_Bonus("Red Dragon Core", "Infused with Red Lightning; maximum roar power unlocked")).setDecor(T_DecorExp(LaxusQ2_DecorDamage, LaxusQ2_ExplosionDecorDamage))
        call SpellData.createAlt(LaxusW_ID, 2, 5, 1, 1, LaxusW_DamageStrBase + LaxusGW_DamageStrBonus2, LaxusW_DamageStrStep, LaxusW_Damage2StaticBase, LaxusW_Damage2StaticStep, T_CastAuto(LaxusW_CastTime, LaxusW_IsInvul) + T_Element(LaxusW_Debuff) + T_Stun(LaxusW_Stun) + T_Push(LaxusW_PushRange), T_Bonus("Form", "|cffFF0000Red Lightning Mode|r") + T_Bonus("Ability Lv. 5", "Landing the strike unlocks Roaring Thunder Crush (W2) for 3 sec")).setDecor(T_Decor(LaxusW_DecorDamage))
        call SpellData.createAlt(LaxusW2_ID, 2, 1, 1, 1, LaxusW2_DamageStrBase + LaxusGW2_DamageStrBonus2, 0.0, 0.0, 0.0, T_Rad(LaxusW2_DamageAoe) + T_CastAuto(LaxusW2_CastTime, LaxusW2_IsInvul) + T_Element(LaxusW2_Debuff) + T_Stun(LaxusW2_Stun), T_Bonus("Form", "|cffFF0000Red Lightning Mode|r") + T_Bonus("Red Dragon Core", "Full devastating double impact")).setSecondDamage(2, "Mag. Damage (Explosion):", 1, LaxusW2_DamageStrBase2 + LaxusGW2_DamageStrBonus2, 0.0, 0.0, 0.0).setDecor(T_Decor(LaxusW2_DecorDamage))
        call SpellData.createAlt(LaxusE_ID, 2, 5, 1, 1, LaxusE_DamageStrBase + LaxusGE_DamageStrBonus2, LaxusE_DamageStrStep, LaxusE_Damage2StaticBase, LaxusE_Damage2StaticStep, T_Rad(LaxusE_DamageAoe) + T_CastAuto(LaxusE_CastTime, LaxusE_IsInvul) + T_Element(LaxusE_Debuff) + T_Slow(I2R(LaxusE_Slow), I2R(LaxusE_Duration)), T_Bonus("Form", "|cffFF0000Red Lightning Mode|r")).setDecor(T_Decor(LaxusE_DecorDamage))
        call SpellData.createAlt(LaxusR_ID, 2, 5, 2, 1, LaxusR_DamageStrBase + LaxusGR_DamageStrBonus + LaxusGR_DamageStrBonus2, LaxusR_DamageStrStep, LaxusR_Damage2StaticBase, LaxusR_Damage2StaticStep, T_RadExp(LaxusR_DamageAoe, LaxusR_DamageAoe2) + T_CastAuto(LaxusR_CastTime, LaxusR_IsInvul) + T_Element(3) + T_Stun(LaxusR_Stun), T_Bonus("Form", "|cffFF0000Red Lightning Mode|r") + T_Bonus("Electrified Target", "+" + FormatInt(LaxusR_DamageBonus) + "% Damage against targets with Electro debuff")).setDecor(T_DecorExp(LaxusR_DecorDamage, LaxusR_ExplosionDecorDamage))
        call SpellData.createAlt(LaxusF_ID, 2, 1, 1, 1, LaxusF_DamageStrBase + LaxusGF_DamageStrBonus2, 0.0, 0.0, 0.0, T_CastAuto(LaxusF_CastTime, LaxusF_IsInvul) + T_Element(LaxusF_Debuff) + T_Stun(LaxusF_Stun) + T_Push(LaxusF_PushRange), T_Bonus("Form", "|cffFF0000Red Lightning Mode|r")).setDecor(T_Decor(LaxusF_DecorDamage))

        // --- РЕГИСТРАЦИЯ НАБОРОВ КНОПОК ПО ФОРМАМ ---
        set form = HeroData.create(Laxus_ID, 0, LaxusQ_ID, LaxusW_ID, LaxusE_ID, LaxusR_ID, LaxusT_ID, LaxusF_ID, LaxusG_ID, LaxusQ2_ID, LaxusW2_ID, 0)
        set form = HeroData.create(Laxus_ID, 1, LaxusQ2_ID, LaxusW_ID, LaxusE_ID, LaxusR_ID, LaxusT_ID, LaxusF_ID, LaxusG_ID, LaxusW2_ID, 0, 0)
        set form = HeroData.create(Laxus_ID, 2, LaxusQ2_ID, LaxusW_ID, LaxusE_ID, LaxusR_ID, LaxusT_ID, LaxusF_ID, LaxusG_ID, LaxusW2_ID, 0, 0)
        
        // ===========================================================================
        // 4. Брандиш (Brandish_ID) -> Интеллект (3)
        // ===========================================================================
        // --- БАЗОВЫЕ СПОСОБНОСТИ ---
        call SpellData.create(BrandishQ_ID, 5, 1, 3, BrandishQ_DamageIntBase, BrandishQ_DamageIntStep, BrandishQ_Damage2StaticBase, BrandishQ_Damage2StaticStep, T_Rad(BrandishQ_DamageAoe) + T_Push(BrandishQ_PushRange) + T_CastAuto(BrandishQ_CastTime, BrandishQ_IsInvul) + T_Dur("Wave Travel", BrandishQ_Duration), "").setDecor(T_Decor(BrandishQ_DecorDamage))
        call SpellData.create(BrandishW_ID, 5, 1, 3, BrandishW_DamageIntBase, BrandishW_DamageIntStep, BrandishW_Damage2StaticBase, BrandishW_Damage2StaticStep, T_Rad(BrandishW_DamageAoe) + T_PropS("Delay", "<L:" + FormatReal(BrandishW_DelayBase) + "/" + FormatReal(BrandishW_DelayBase-BrandishW_DelayStep) + "/" + FormatReal(BrandishW_DelayBase-BrandishW_DelayStep*2) + "/" + FormatReal(BrandishW_DelayBase-BrandishW_DelayStep*3) + "/" + FormatReal(BrandishW_DelayBase-BrandishW_DelayStep*4) + "> sec") + T_Root(BrandishW_RootDuration), "").setDecor(T_Decor(BrandishW_DecorDamage))
        call SpellData.createUtility(BrandishE_ID, 5, T_PropS("Heal per sec", "Intelligence x " + FormatReal(BrandishE_HealIntBase)) + T_PropS("Duration", "<L:" + FormatReal(BrandishE_DurationBase) + "/" + FormatReal(BrandishE_DurationBase+BrandishE_DurationStep) + "/" + FormatReal(BrandishE_DurationBase+BrandishE_DurationStep*2) + "/" + FormatReal(BrandishE_DurationBase+BrandishE_DurationStep*3) + "/" + FormatReal(BrandishE_DurationBase+BrandishE_DurationStep*4) + "> sec") + T_PropS("Damage Reduction", FormatInt(BrandishE_DamageDecrease) + "%"), "")
        call SpellData.createSimple(BrandishR_ID, 5, 1, 3, BrandishR_DamageIntBase, BrandishR_DamageIntStep, T_Rad(BrandishR_DamageAoe) + T_Dur("Delay", BrandishR_Delay) + T_Slow(BrandishR_Slow, BrandishR_SlowDuration), "").setDecor(T_Decor(BrandishR_DecorDamage))
        call SpellData.createSimple(BrandishT_ID, 1, 1, 3, BrandishT_DamageIntBase, 0.0, T_Rad(BrandishT_DamageAoe) + T_CastAuto(BrandishT_CastTime, BrandishT_IsInvul) + T_PropS("Size Increase", "+" + FormatInt(BrandishT_ScaleIncrease) + "%"), T_Bonus("Lv. 35", "Moving triggers shockwaves dealing Intelligence x " + FormatReal(BrandishT_DamageIntBase2) + " damage")).setDecor(T_Decor(BrandishT_DecorDamage))
        call SpellData.createUtility(BrandishF_ID, 1, T_PropS("Ally Size", "+" + FormatInt(BrandishF_DamageOutputIncreaseScale) + "%") + T_PropS("Ally Damage", "+" + FormatInt(BrandishF_DamageOutputIncrease) + "%") + T_PropS("Enemy Size", "-" + FormatInt(BrandishF_DamageOutputDecreaseScale) + "%") + T_PropS("Enemy Damage", "-" + FormatInt(BrandishF_DamageOutputDecrease) + "%") + T_Dur("Duration", BrandishF_Time), "")
        // --- РЕГИСТРАЦИЯ НАБОРА СПОСОБНОСТЕЙ ГЕРОЯ ---
        set form = HeroData.create(Brandish_ID, 0, BrandishQ_ID, BrandishW_ID, BrandishE_ID, BrandishR_ID, BrandishT_ID, BrandishF_ID, 0, 0, 0, 0)
        
        // ===========================================================================
        // 5. Патриот (Patriot_ID) -> Ловкость (2)
        // ===========================================================================
        // --- БАЗОВЫЕ СПОСОБНОСТИ (МАРШЕВАЯ СТОЙКА) ---
        call SpellData.create(PatriotQ_ID, 5, 1, 2, PatriotQ_DamageAgiBase, PatriotQ_DamageAgiStep, PatriotQ_Damage2StaticBase, PatriotQ_Damage2StaticStep, T_RadExp(PatriotQ_DamageAoe, PatriotQ_DamageAoe2) + T_PropS("Projectile Range", "<L:" + FormatInt(PatriotQ_RangeBase) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep * 2) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep * 3) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep * 4) + ">") + T_CastAuto(PatriotQ_CastTime, PatriotQ_IsInvul) + T_Slow(PatriotQ_SlowPercent, PatriotQ_SlowDuration), T_Bonus("Ruination Stance (E)", "Empowers strike (+Agility x " + FormatReal(PatriotQ_RuinationAgiBonus) + ") and removes flight slow") + T_Bonus("Shield Combo", "Passing through W, R, or T detonates the zone early and Stuns enemies for 1.0 sec")).setDecor(T_DecorExp(PatriotQ_DecorDamage, PatriotQ_DecorExpDamage))
        call SpellData.create(PatriotW_ID, 5, 2, 2, PatriotW_DamageAgiBase, PatriotW_DamageAgiStep, PatriotW_Damage2StaticBase, PatriotW_Damage2StaticStep, T_Rad(PatriotW_DamageAoe) + T_PropS("Heal", "Agility x " + FormatReal(PatriotW_HealAgiBase)) + T_PropS("Pulses", "<L:" + FormatInt(PatriotW_DurationBase) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep * 2) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep * 3) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep * 4) + ">") + T_Dur("Pulse Interval", PatriotW_PulseInterval) + T_Dur("Activation Delay", PatriotW_CastTime), T_Bonus("Spear Detonation (Q)", "Throwing Q into the zone instantly detonates all remaining pulses")).setDecor(T_DecorExp(PatriotW_DecorDamage, PatriotW_DecorExpDamage))
        call SpellData.createUtility(PatriotE_ID, 5, T_PropS("Q Cooldown Reduction", "<L:" + FormatReal(PatriotE_CDReductBase + PatriotE_CDReductStep * 0) + "/" + FormatReal(PatriotE_CDReductBase + PatriotE_CDReductStep * 1) + "/" + FormatReal(PatriotE_CDReductBase + PatriotE_CDReductStep * 2) + "/" + FormatReal(PatriotE_CDReductBase + PatriotE_CDReductStep * 3) + "/" + FormatReal(PatriotE_CDReductBase + PatriotE_CDReductStep * 4) + "> sec") + T_PropS("R Cooldown Reduction", "2 sec (Lv. 35)"), T_Bonus("Stance Switch", "Toggles between Marching Stance (Defensive) and Ruination Stance (Offensive)|nSwaps F and T abilities") + T_Bonus("Perseverance (EE)", "Survives lethal damage for " + FormatReal(PatriotEE_Duration) + " sec with max offensive power"))
        call SpellData.create(PatriotR_ID, 5, 1, 2, PatriotR_DamageAgiBase, PatriotR_DamageAgiStep, 0.0, 0.0, T_Rad(PatriotR_DamageAoe) + T_PropS("March Range", "<L:" + FormatInt(PatriotR_RangeBase) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep * 2) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep * 3) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep * 4) + ">") + T_CastAuto(PatriotR_CastTime, PatriotR_IsInvul) + T_DurAuto(PatriotR_Duration, PatriotR_IsInvul), T_Bonus("Phalanx Wall", "Soldiers plant shields at destination for " + FormatReal(PatriotR_Duration) + " sec, dealing Agility x <L:" + FormatReal(PatriotR2_DamageAgiBase) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep * 2) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep * 3) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep * 4) + "> damage (4 ticks)") + T_Bonus("Ruination Stance (E)", "March reverses direction: soldiers spawn at max range and pull enemies toward Patriot") + T_Bonus("Spear Trigger (Q)", "Hit with Q to instantly trigger the standing phase")).setDecor(T_Decor(PatriotR_DecorDamage))
        call SpellData.createSimple(PatriotT_ID, 1, 1, 2, PatriotT_DamageAgiBase, 0.0, T_Rad(PatriotT_DamageAoe) + T_CastAuto(PatriotT_CastTime, PatriotT_IsInvul) + T_Dur("Duration", PatriotT_Duration) + T_Push(165), T_Bonus("Ruination Stance (E)", "Replaced by Catastrophic Javelin (T2)") + T_Bonus("Lv. 35 Vanguard", "Outer barrier impact deals bonus +100% Attack damage")).setDecor(T_Decor(PatriotT_DecorDamage))
        call SpellData.createUtility(PatriotF_ID, 1, T_Rad(PatriotF_AoE) + T_Dur("Duration", PatriotF_Duration) + T_Push(250) + T_PropS("Damage Resistance", FormatInt(PatriotF_Buff1_Resist) + "%"), T_Bonus("Shield March", "Marches forward guided by mouse, pushing enemies aside") + T_Bonus("Ruination Stance (E)", "Replaced by Offensive Advance (F2)") + T_Bonus("Lv. 25 Fortitude", "Continuously cleanses all negative debuffs") + T_Bonus("Lv. 35 Bulwark", "Grants +" + FormatInt(PatriotF_Buff2_Resist) + "% damage resistance to nearby allies")).setDecor(T_Decor(PatriotF_DecorDamage))
        call SpellData.createSimple(PatriotG_ID, 1, 2, 2, PatriotG_DamageAgiBase, 0.0, T_PropS("Marching CD", FormatReal(PatriotG_CD_Def) + " sec") + T_PropS("Ruination CD", FormatReal(PatriotG_CD_Atk) + " sec"), T_Bonus("Passive Strike", "Deals magical damage on attack with stance-dependent cooldown") + T_Bonus("Lv. 35 Mastery", "Q, R, T, and T2 trigger passive strike on enemy hit"))

        // --- СПОСОБНОСТИ СТОЙКИ СОКРУШЕНИЯ (СВОИ ID В РЕДАКТОРЕ) ---
        call SpellData.createSimple(PatriotT2_ID, 1, 1, 2, PatriotT2_DamageAgiBase, 0.0, T_Rad(PatriotT2_DamageAoe) + T_CastAuto(PatriotT2_CastTime, PatriotT2_IsInvul) + T_DurAuto(PatriotT2_Duration, false), T_Bonus("Form", "|cff9933ffRuination Stance|r") + T_Bonus("Catastrophic Strike", "Aims up to 1.5 sec before launching spear into orbit, crushing target location")).setDecor(T_Decor(PatriotT2_DecorDamage))
        call SpellData.createUtility(PatriotF2_ID, 1, T_Rad(PatriotF_AoE) + T_Dur("Duration", PatriotF_Duration) + T_Push(250) + T_PropS("Damage Resistance", FormatInt(PatriotF_Buff1_Resist) + "%"), T_Bonus("Form", "|cff9933ffRuination Stance|r") + T_Bonus("Aggressive Advance", "Guides march toward cursor while maintaining high crowd control")).setDecor(T_Decor(PatriotF_DecorDamage))

        // --- МОДИФИКАТОРЫ ДЛЯ ОБЩИХ СПОСОБНОСТЕЙ (ФОРМА 1) ---
        call SpellData.createAlt(PatriotQ_ID, 1, 5, 1, 2, PatriotQ_DamageAgiBase + PatriotQ_RuinationAgiBonus, PatriotQ_DamageAgiStep, PatriotQ_Damage2StaticBase, PatriotQ_Damage2StaticStep, T_RadExp(PatriotQ_DamageAoe, PatriotQ_DamageAoe2) + T_PropS("Projectile Range", "<L:" + FormatInt(PatriotQ_RangeBase) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep * 2) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep * 3) + "/" + FormatInt(PatriotQ_RangeBase + PatriotQ_RangeStep * 4) + ">") + T_CastAuto(PatriotQ_CastTime, PatriotQ_IsInvul), T_Bonus("Form", "|cff9933ffRuination Stance|r") + T_Bonus("Mechanic", "Piercing throw deals enhanced damage without flight slow") + T_Bonus("Shield Combo", "Passing through W, R, or T detonates the zone early and Stuns enemies for 1.0 sec")).setDecor(T_DecorExp(PatriotQ_DecorDamage, PatriotQ_DecorExpDamage))
        call SpellData.createAlt(PatriotW_ID, 1, 5, 2, 2, PatriotW_DamageAgiBase, PatriotW_DamageAgiStep, PatriotW_Damage2StaticBase, PatriotW_Damage2StaticStep, T_Rad(PatriotW_DamageAoe) + T_PropS("Heal", "Agility x " + FormatReal(PatriotW_HealAgiBase)) + T_PropS("Pulses", "<L:" + FormatInt(PatriotW_DurationBase) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep * 2) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep * 3) + "/" + FormatInt(PatriotW_DurationBase + PatriotW_DurationStep * 4) + ">") + T_Dur("Pulse Interval", PatriotW_PulseInterval) + T_Dur("Activation Delay", PatriotW_CastTime), T_Bonus("Form", "|cff9933ffRuination Stance|r") + T_Bonus("Spear Detonation (Q)", "Throwing Q into the zone instantly detonates all remaining pulses")).setDecor(T_DecorExp(PatriotW_DecorDamage, PatriotW_DecorExpDamage))
        call SpellData.createAlt(PatriotR_ID, 1, 5, 1, 2, PatriotR_DamageAgiBase, PatriotR_DamageAgiStep, 0.0, 0.0, T_Rad(PatriotR_DamageAoe) + T_PropS("March Range", "<L:" + FormatInt(PatriotR_RangeBase) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep * 2) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep * 3) + "/" + FormatInt(PatriotR_RangeBase + PatriotR_RangeStep * 4) + ">") + T_CastAuto(PatriotR_CastTime, PatriotR_IsInvul) + T_DurAuto(PatriotR_Duration, PatriotR_IsInvul), T_Bonus("Form", "|cff9933ffRuination Stance|r") + T_Bonus("Reverse Pull", "Phalanx spawns at target location and marches inward, pulling enemies across full distance") + T_Bonus("Phalanx Wall", "Soldiers plant shields for " + FormatReal(PatriotR_Duration) + " sec, dealing Agility x <L:" + FormatReal(PatriotR2_DamageAgiBase) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep * 2) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep * 3) + "/" + FormatReal(PatriotR2_DamageAgiBase + PatriotR2_DamageAgiStep * 4) + "> damage (4 ticks)")).setDecor(T_Decor(PatriotR_DecorDamage))

        // --- МОДИФИКАТОРЫ ДЛЯ ФОРМЫ 2 (LAST STAND / PERSEVERANCE) ---
        call SpellData.createAlt(PatriotQ_ID, 2, 5, 1, 2, PatriotQ_DamageAgiBase + PatriotQ_RuinationAgiBonus, PatriotQ_DamageAgiStep, PatriotQ_Damage2StaticBase, PatriotQ_Damage2StaticStep, T_RadExp(PatriotQ_DamageAoe, PatriotQ_DamageAoe2) + T_CastAuto(PatriotQ_CastTime, PatriotQ_IsInvul), T_Bonus("Form", "|cffFF0000Perseverance Stance|r") + T_Bonus("Last Stand", "Lethal surge active: Patriot fights for " + FormatReal(PatriotEE_Duration) + " sec before collapsing")).setDecor(T_DecorExp(PatriotQ_DecorDamage, PatriotQ_DecorExpDamage))
        call SpellData.createAlt(PatriotT2_ID, 2, 1, 1, 2, PatriotT2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(PatriotT2_DamageAoe) + T_CastAuto(PatriotT2_CastTime, PatriotT2_IsInvul) + T_DurAuto(PatriotT2_Duration, false), T_Bonus("Form", "|cffFF0000Perseverance Stance|r") + T_Bonus("Catastrophic Strike", "Final devastating spear throw at target coordinate")).setDecor(T_Decor(PatriotT2_DecorDamage))

        // --- РЕГИСТРАЦИЯ НАБОРОВ СПОСОБНОСТЕЙ ГЕРОЯ ---
        set form = HeroData.create(Patriot_ID, 0, PatriotQ_ID, PatriotW_ID, PatriotE_ID, PatriotR_ID, PatriotT_ID, PatriotF_ID, PatriotG_ID, PatriotT2_ID, PatriotF2_ID, 0)
        set form = HeroData.create(Patriot_ID, 1, PatriotQ_ID, PatriotW_ID, PatriotE_ID, PatriotR_ID, PatriotT2_ID, PatriotF2_ID, PatriotG_ID, 0, 0, 0)
        set form = HeroData.create(Patriot_ID, 2, PatriotQ_ID, PatriotW_ID, PatriotE_ID, PatriotR_ID, PatriotT2_ID, PatriotF2_ID, PatriotG_ID, 0, 0, 0)
        
        // ===========================================================================
        // 6. Аста (Asta_ID) -> Ловкость (2)
        // ===========================================================================
        // --- ФОРМА 0 (БАЗОВАЯ) ---
        call SpellData.create(AstaQ_ID, 5, 1, 2, AstaQ_DamageAgiBase, AstaQ_DamageAgiStep, AstaQ_Damage2StaticBase, AstaQ_Damage2StaticStep, T_Rad(AstaQ_DamageAoe) + T_PropS("Max Range", "<L:" + FormatInt(AstaQ_RangeBase) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep*2) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep*3) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep*4) + ">") + T_CastAuto(AstaQ_CastTime, AstaQ_IsInvul) + T_Push(150.0), T_Bonus("Demon Form (T)", "Increases AoE by +" + FormatInt(AstaTQ_AoeBonus) + "% and deals additional Agility x " + FormatReal(AstaTQ_DmgBonus) + " damage") + T_Bonus("Ability Lv. 5", "Unlocks Flying Slash Barrage (Q2)")).setDecor(T_DecorExp(AstaQ_DecorDamage, AstaQ_DecorExpDamage))
        call SpellData.create(AstaW_ID, 5, 1, 2, AstaW_DamageAgiBase, AstaW_DamageAgiStep, AstaW_Damage2StaticBase, AstaW_Damage2StaticStep, T_Rad(AstaW_DamageAoe) + T_PropS("Dash Range", "<L:" + FormatInt(AstaW_RangeBase) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep*2) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep*3) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep*4) + ">") + T_CastAuto(AstaW_CastTime, AstaW_IsInvul) + T_Push(AstaW_PushRange), T_Bonus("Demon Form (T)", "Deals additional Agility x " + FormatReal(AstaTW_DmgBonus) + " damage and pins the target in front") + T_Bonus("Ability Lv. 5", "Unlocks Intercepting Charge (W2)")).setDecor(T_Decor(AstaW_DecorDamage))
        call SpellData.create(AstaE_ID, 5, 1, 2, AstaE_DamageAgiBase, AstaE_DamageAgiStep, AstaE_DamageStatic, 0.0, T_Rad(AstaE_DamageAoe) + T_Dur("Spin Duration", AstaE_Duration) + T_Dur("Hit Interval", AstaE_Interval) + T_Push(100.0), T_Bonus("Demon Form (T)", "Increases AoE by +" + FormatInt(AstaTE_AoeBonus) + "% and enhances spin damage") + T_Bonus("Lv. 35 Mastery", "Increases movement speed during spin by +" + FormatInt(AstaE_35_bonuspeed) + "%")).setDecor(T_Decor(AstaE_DecorDamage))
        call SpellData.createSimple(AstaR_ID, 5, 1, 2, AstaR_DamageAgiBase, AstaR_DamageAgiStep, T_Rad(AstaR_DamageAoe) + T_CastAuto(AstaR_CastTime, AstaR_IsInvul) + T_Push(AstaR_PushRange), T_Bonus("Demon Form (T)", "Replaced by Black Divider Strike (R2)")).setDecor(T_Decor(AstaR_DecorDamage))
        call SpellData.createUtility(AstaT_ID, 1, T_Dur("Duration", AstaT_Duration), T_Bonus("Demon Form", "Draws Anti-Magic power, enhancing Q, W, E and replacing R with R2|nAt Lv. 35 unlocks Black Meteorite (T2)")).setDecor(T_Decor(AstaT_DecorDamage))
        call SpellData.createUtility(AstaF_ID, 1, T_Rad(AstaF_AoE) + T_Dur("Duration", AstaF_Duration) + T_PropS("Mana Drain", FormatInt(AstaF_ManaSteal) + "% Max MP"), T_Bonus("Purge", "Cleanses all negative debuffs from nearby allies and transfers enemy mana to Asta"))
        call SpellData.createUtility(AstaG_ID, 1, T_PropS("Magic Resistance", "<L:" + FormatInt(AstaG_MagRes6) + "%/" + FormatInt(AstaG_MagRes12) + "%/" + FormatInt(AstaG_MagRes25) + "%/" + FormatInt(AstaG_MagRes35) + "%>"), T_Bonus("Passive", "Passively increases magic resistance at hero Lv. 6, 12, 25 and 35"))
        
        // Связанные и комбо-способности
        call SpellData.create(AstaQ2_ID, 1, 1, 2, AstaQ2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(AstaQ2_DamageAoe) + T_Prop("Strikes", 2) + T_CastAuto(AstaQ2_CastTime, AstaQ2_IsInvul) + T_Push(250.0), T_Bonus("Combo", "Fires 2 successive curved slashes, each dealing 50% damage")).setDecor(T_DecorExp(AstaQ2_DecorDamage, AstaQ2_DecorExpDamage))
        call SpellData.create(AstaW2_ID, 1, 1, 2, AstaW2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(AstaW2_DamageAoe) + T_Stun(AstaW2_Stun) + T_CastAuto(AstaW2_CastTime, AstaW2_IsInvul) + T_Push(AstaW_PushRange), T_Bonus("Targeted", "Charges directly at target, stunning it and scattering nearby enemies")).setDecor(T_Decor(AstaW2_DecorDamage))
        call SpellData.createSimple(AstaR2_ID, 1, 1, 2, AstaR2_DamageAgiBase, 0.0, T_Rad(AstaR2_DamageAoe) + T_CastAuto(AstaR2_CastTime, AstaR2_IsInvul) + T_Silence(AstaR2_Silence), T_Bonus("Demon Form", "Teleports to target, suppresses it and unleashes a massive shockwave")).setDecor(T_Decor(AstaR2_DecorDamage))
        call SpellData.createSimple(AstaT2_ID, 1, 1, 2, AstaT2_DamageAgiBase, 0.0, T_Rad(AstaT2_DamageAoe) + T_CastAuto(AstaT2_CastTime, AstaT2_IsInvul), T_Bonus("Lv. 35 Ultimate", "Devastating slam that cleanses all allies and obliterates enemy lines")).setDecor(T_Decor(AstaT2_DecorDamage))

        // --- ФОРМА 1 (ДЕМОНИЧЕСКАЯ ФОРМА - BLACK DIVIDER) ---
        call SpellData.createAlt(AstaQ_ID, 1, 5, 1, 2, AstaQ_DamageAgiBase + AstaTQ_DmgBonus, AstaQ_DamageAgiStep, AstaQ_Damage2StaticBase, AstaQ_Damage2StaticStep, T_Rad(AstaQ_DamageAoe * (1.0 + AstaTQ_AoeBonus / 100.0)) + T_PropS("Max Range", "<L:" + FormatInt(AstaQ_RangeBase) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep*2) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep*3) + "/" + FormatInt(AstaQ_RangeBase+AstaQ_RangeStep*4) + ">") + T_CastAuto(AstaQ_CastTime, AstaQ_IsInvul) + T_Push(150.0), T_Bonus("Form", "|cff9933ffDemon Form|r") + T_Bonus("Ability Lv. 5", "Unlocks Flying Slash Barrage (Q2)")).setDecor(T_DecorExp(AstaQ_DecorDamage, AstaQ_DecorExpDamage))
        call SpellData.createAlt(AstaW_ID, 1, 5, 1, 2, AstaW_DamageAgiBase + AstaTW_DmgBonus, AstaW_DamageAgiStep, AstaW_Damage2StaticBase, AstaW_Damage2StaticStep, T_Rad(AstaW_DamageAoe) + T_PropS("Dash Range", "<L:" + FormatInt(AstaW_RangeBase) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep*2) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep*3) + "/" + FormatInt(AstaW_RangeBase+AstaW_RangeStep*4) + ">") + T_CastAuto(AstaW_CastTime, AstaW_IsInvul) + T_Push(AstaW_PushRange), T_Bonus("Form", "|cff9933ffDemon Form|r") + T_Bonus("Pin", "Pins primary target in front of Asta") + T_Bonus("Ability Lv. 5", "Unlocks Intercepting Charge (W2)")).setDecor(T_Decor(AstaW_DecorDamage))
        call SpellData.createAlt(AstaE_ID, 1, 5, 1, 2, AstaE_DamageAgiBase + AstaE_DamageAgiStep, AstaE_DamageAgiStep, AstaE_DamageStatic, 0.0, T_Rad(AstaE_DamageAoe * (1.0 + AstaTE_AoeBonus / 100.0)) + T_Dur("Spin Duration", AstaE_Duration) + T_Dur("Hit Interval", AstaE_Interval) + T_Push(100.0), T_Bonus("Form", "|cff9933ffDemon Form|r") + T_Bonus("Lv. 35 Mastery", "Increases movement speed during spin by +" + FormatInt(AstaE_35_bonuspeed) + "%")).setDecor(T_Decor(AstaE_DecorDamage))
        call SpellData.createAlt(AstaR2_ID, 1, 1, 1, 2, AstaR2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(AstaR2_DamageAoe) + T_CastAuto(AstaR2_CastTime, AstaR2_IsInvul) + T_Silence(AstaR2_Silence), T_Bonus("Form", "|cff9933ffDemon Form|r") + T_Bonus("Execution", "Teleports to target, suppresses it and unleashes a massive shockwave")).setDecor(T_Decor(AstaR2_DecorDamage))
        call SpellData.createAlt(AstaT2_ID, 1, 1, 1, 2, AstaT2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(AstaT2_DamageAoe) + T_CastAuto(AstaT2_CastTime, AstaT2_IsInvul), T_Bonus("Form", "|cff9933ffDemon Form|r") + T_Bonus("Lv. 35 Ultimate", "Devastating slam that cleanses all allies and obliterates enemy lines")).setDecor(T_Decor(AstaT2_DecorDamage))

        // --- РЕГИСТРАЦИЯ НАБОРОВ СПОСОБНОСТЕЙ ГЕРОЯ ---
        set form = HeroData.create(Asta_ID, 0, AstaQ_ID, AstaW_ID, AstaE_ID, AstaR_ID, AstaT_ID, AstaF_ID, AstaG_ID, AstaQ2_ID, AstaW2_ID, AstaR2_ID)
        call form.addExtra(AstaT2_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        set form = HeroData.create(Asta_ID, 1, AstaQ_ID, AstaW_ID, AstaE_ID, AstaR2_ID, AstaT2_ID, AstaF_ID, AstaG_ID, AstaQ2_ID, AstaW2_ID, 0)
        call form.addExtra(AstaT_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        
        // ===================================
        // 7. Годжо Сатору (Gojo_ID) -> Интеллект (3)
        // ===================================
        call SpellData.create(GojoQ_ID, 5, 1, 3, GojoQ_DamageIntBase, GojoQ_DamageIntStep, GojoQ_Damage2StaticBase, GojoQ_Damage2StaticStep, "Radius: <L:" + I2S(R2I(GojoQ_DamageAoe)) + "/" + I2S(R2I(GojoQ_DamageAoe)) + "/" + I2S(R2I(GojoQLvl2_DamageAoe)) + "/" + I2S(R2I(GojoQLvl2_DamageAoe)) + "/" + I2S(R2I(GojoQLvl3_DamageAoe)) + ">|n" + T_Push(GojoQ_PushRange), "")
        call SpellData.create(GojoW_ID, 5, 2, 3, GojoW_DamageIntBase, GojoW_DamageIntStep, GojoW_Damage2StaticBase, GojoW_Damage2StaticStep, "Radius: <L:" + I2S(R2I(GojoW_DamageAoe)) + "/" + I2S(R2I(GojoW_DamageAoe)) + "/" + I2S(R2I(GojoWLvl2_DamageAoe)) + "/" + I2S(R2I(GojoWLvl2_DamageAoe)) + "/" + I2S(R2I(GojoWLvl3_DamageAoe)) + ">|n" + T_Push(GojoW_PushRange), "")
        call SpellData.createUtility(GojoE_ID, 5, "Duration: <L:" + FormatReal(GojoE_Duration) + "/" + FormatReal(GojoE_Duration+GojoE_AddDuration) + "/" + FormatReal(GojoE_Duration+GojoE_AddDuration*2) + "/" + FormatReal(GojoE_Duration+GojoE_AddDuration*3) + "/" + FormatReal(GojoE_MaxDuration) + "> sec", T_Bonus("Ability Lv. 5", "Drains " + FormatReal(GojoE_Lvl5Manacost) + "% Max Mana per sec after base duration"))
        call SpellData.createSimple(GojoR_ID, 5, 2, 3, GojoR_DamageIntFirst, GojoR_DamageIntFirst, T_Rad(GojoR_DamageAoe) + "Duration: <L:" + FormatReal(GojoR_DurationBase) + "/" + FormatReal(GojoR_DurationBase+GojoR_DurationStep) + "/" + FormatReal(GojoR_DurationBase+GojoR_DurationStep*2) + "/" + FormatReal(GojoR_DurationBase+GojoR_DurationStep*3) + "/" + FormatReal(GojoR_DurationBase+GojoR_DurationStep*4) + "> sec|n" + T_Stun(GojoR_StunTime) + "Tick Damage: Intelligence x <L:" + FormatReal(GojoR_DamageIntBase) + "/" + FormatReal(GojoR_DamageIntBase+GojoR_DamageIntStep) + "/" + FormatReal(GojoR_DamageIntBase+GojoR_DamageIntStep*2) + "/" + FormatReal(GojoR_DamageIntBase+GojoR_DamageIntStep*3) + "/" + FormatReal(GojoR_DamageIntBase+GojoR_DamageIntStep*4) + "> every 1.8 sec", T_Bonus("Lv. 35", "+" + I2S(R2I(GojoR_35lvl_AddAoe)) + " Radius"))
        call SpellData.createSimple(GojoT_ID, 1, 2, 3, GojoT_DamageIntBase, 0.0, T_Rad(GojoT_DamageAoe) + T_Push(GojoT_PushRange), "")
        call SpellData.createUtility(GojoG_ID, 1, "Passive|nMana Restore: " + FormatReal(Gojo_G_ManaRestore) + "% for " + FormatReal(Gojo_G_ManaRestoreTime) + " sec", "")
        call SpellData.create(GojoQ2_ID, 1, 1, 3, GojoQ_DamageIntBase + (GojoQ_DamageIntStep * 6.0), 0.0, GojoQ_Damage2StaticBase + (GojoQ_Damage2StaticStep * 5.0), 0.0, T_Rad(GojoQLvl3_DamageAoe) + "Pulls enemies towards the center", "")
        call SpellData.create(GojoW2_ID, 1, 2, 3, GojoW_DamageIntBase + (GojoW_DamageIntStep * 6.0), 0.0, GojoW_Damage2StaticBase + (GojoW_Damage2StaticStep * 5.0), 0.0, T_Rad(GojoWLvl3_DamageAoe), "")
        call SpellData.createUtility(GojoE2_ID, 1, "", "")
        call SpellData.createSimple(GojoRQ_ID, 5, 1, 4, GojoRQ_Damage, 0.0, T_Rad(GojoRQ_DamageAoe) + T_Stun(GojoRQ_Stun), "")
        call SpellData.createUtility(GojoRW_ID, 5, "", "")
        call SpellData.createUtility(GojoRR_ID, 5, "", "")
        call SpellData.createSimple(GojoT2_ID, 1, 2, 3, GojoT_DamageIntBase, 0.0, "", "")
        
        set form = HeroData.create(Gojo_ID, 0, GojoQ_ID, GojoW_ID, GojoE_ID, GojoR_ID, GojoT_ID, GojoG_ID, GojoQ2_ID, GojoW2_ID, GojoE2_ID, GojoRR_ID)
        call form.addExtra(GojoT2_ID, GojoRQ_ID, GojoRW_ID, GojoRCancel_ID, 0, 0, 0, 0, 0, 0)
        
        // ===========================================================================
        // 8. Бамбиетта Бастербайн (Bambietta_ID) -> Ловкость (2)
        // ===========================================================================
        // --- БАЗОВАЯ ФОРМА (Form 0) ---
        // --- БАЗОВАЯ ФОРМА (Form 0) ---
        call SpellData.create(BambiettaQ_ID, 5, 2, 2, BambiettaQ_DamageAgiBase, BambiettaQ_DamageAgiStep, BambiettaQ_Damage2StaticBase, BambiettaQ_Damage2StaticStep, T_RadExp(BambiettaQ_DamageAoe, BambiettaQ_DamageAoe2) + T_CastAuto(BambiettaQ_CastTime, BambiettaQ_IsInvul), T_Bonus("Vollstandig (T)", "Increases damage (+Agility x " + FormatInt(BambiettaTQ_DamageAgiBase - BambiettaQ_DamageAgiBase) + "), +" + FormatInt(BambiettaTQ_RangeBase - BambiettaQ_RangeBase) + " Range and fires 3 shells")).setDecor(T_DecorExp(BambiettaQ_DecorDamage, BambiettaQ_ExplosionDecorDamage))
        call SpellData.create(BambiettaW_ID, 5, 2, 2, BambiettaW_DamageAgiBase, BambiettaW_DamageAgiStep, BambiettaW_Damage2StaticBase, BambiettaW_Damage2StaticStep, T_RadExp(BambiettaW_DamageAoe, BambiettaW_DamageAoe2) + T_CastAuto(BambiettaW_CastTime, BambiettaW_IsInvul) + T_Prop("Shells", 5), T_Bonus("Vollstandig (T)", "Transforms into a dash with homing explosions (+Agility x " + FormatInt(BambiettaTW_DamageAgiBase - BambiettaW_DamageAgiBase) + ")")).setDecor(T_DecorExp(BambiettaW_DecorDamage, BambiettaW_ExplosionDecorDamage))
        call SpellData.createSimple(BambiettaE_ID, 5, 2, 2, BambiettaE_DamageAgiBase, BambiettaE_DamageAgiStep, T_RadExp(BambiettaE_DamageAoe, BambiettaE_DamageAoe2) + T_CastAuto(BambiettaE_CastTime, BambiettaE_IsInvul) + T_Slow(I2R(BambiettaE_Slow), I2R(BambiettaE_SlowDuration)) + T_Prop("Shells", 3), T_Bonus("Vollstandig (T)", "Fires a rapid barrage of 14 mini-bombs (+Agility x " + FormatInt(BambiettaTE_DamageAgiBase - BambiettaE_DamageAgiBase) + ") with micro-stun")).setDecor(T_DecorExp(BambiettaE_DecorDamage, BambiettaE_ExplosionDecorDamage))
        call SpellData.createSimple(BambiettaR_ID, 5, 2, 2, BambiettaR_DamageAgiBase, BambiettaR_DamageAgiStep, T_Rad(BambiettaR_DamageAoe) + T_CastAuto(BambiettaR_CastTime, BambiettaR_IsInvul) + T_DurAuto(BambiettaR_Duration, BambiettaR_IsInvul) + T_Push(BambiettaR_PushRange), T_Bonus("Vollstandig (T)", "Increases damage (+Agility x " + FormatInt(BambiettaTR_DamageAgiBase - BambiettaR_DamageAgiBase) + "), Radius (" + FormatInt(BambiettaTR_DamageAoe) + ") and Knockback (" + FormatInt(BambiettaTR_PushRange) + ")")).setDecor(T_Decor(BambiettaR_DecorDamage))
        call SpellData.createUtility(BambiettaT_ID, 1, T_Duration(BambiettaT_Duration) + T_CastAuto(BambiettaT_CastTime, BambiettaT_IsInvul) + "Reduces active skill cooldowns by " + FormatInt(BambiettaT_ReduceCD) + " sec|nGrants 2 charges of The Explode (G)", T_Bonus("Form", "Unlocks Vollstandig skills and Rain of Carnage (T2)")).setDecor(T_Decor(BambiettaT_DecorDamage))
        call SpellData.createUtility(BambiettaG_ID, 1, T_Rad(400.0) + "Base Damage: Agility x <L:" + FormatReal(BambiettaG_DamageAgiBase12) + "/" + FormatReal(BambiettaG_DamageAgiBase12) + "/" + FormatReal(BambiettaG_DamageAgiBase12) + "/" + FormatReal(BambiettaG_DamageAgiBase25) + "/" + FormatReal(BambiettaG_DamageAgiBase35) + ">|n" + T_Dur("Recharge CD", BambiettaG_CD), T_Bonus("Lv. 25", "Agi x" + FormatReal(BambiettaG_DamageAgiBase25) + " Dmg") + T_Bonus("Lv. 35", "Agi x" + FormatReal(BambiettaG_DamageAgiBase35) + " Dmg") + T_Bonus("Vollstandig (T)", "Stores 2 charges")).setDecor(T_Decor(BambiettaG_DecorDamage))

        // --- ФОРМА VOLLSTANDIG (Form 1) ---
        call SpellData.createAlt(BambiettaQ_ID, 1, 5, 2, 2, BambiettaTQ_DamageAgiBase, BambiettaTQ_DamageAgiStep, BambiettaQ_Damage2StaticBase, BambiettaQ_Damage2StaticStep, T_RadExp(BambiettaTQ_DamageAoe, BambiettaTQ_DamageAoe2) + T_CastAuto(BambiettaTQ_CastTime, BambiettaTQ_IsInvul) + T_Prop("Shells", 3), T_Bonus("Form", "|cffFF0000Vollstandig Form|r")).setDecor(T_DecorExp(BambiettaTQ_DecorDamage, BambiettaTQ_ExplosionDecorDamage))
        call SpellData.createAlt(BambiettaW_ID, 1, 5, 2, 2, BambiettaTW_DamageAgiBase, BambiettaTW_DamageAgiStep, BambiettaW_Damage2StaticBase, BambiettaW_Damage2StaticStep, T_RadExp(BambiettaTW_DamageAoe, BambiettaTW_DamageAoe2) + T_CastAuto(BambiettaTW_CastTime, BambiettaTW_IsInvul) + T_DurAuto(BambiettaTW_Duration, BambiettaTW_IsInvul), T_Bonus("Form", "|cffFF0000Vollstandig Form|r")).setDecor(T_Decor(BambiettaTW_DecorDamage))
        call SpellData.createAlt(BambiettaE_ID, 1, 5, 2, 2, BambiettaTE_DamageAgiBase, BambiettaTE_DamageAgiStep, 0.0, 0.0, T_Rad(BambiettaTE_DamageAoe) + T_CastAuto(BambiettaTE_CastTime, BambiettaTE_IsInvul) + T_DurAuto(BambiettaTE_Duration, BambiettaTE_IsInvul) + T_Stun(BambiettaTE_Stun) + T_Slow(I2R(BambiettaE_Slow), I2R(BambiettaE_SlowDuration)) + T_Prop("Shells", 14), T_Bonus("Form", "|cffFF0000Vollstandig Form|r")).setDecor(T_Decor(BambiettaTE_DecorDamage))
        call SpellData.createAlt(BambiettaR_ID, 1, 5, 2, 2, BambiettaTR_DamageAgiBase, BambiettaTR_DamageAgiStep, 0.0, 0.0, T_Rad(BambiettaTR_DamageAoe) + T_CastAuto(BambiettaTR_CastTime, BambiettaTR_IsInvul) + T_DurAuto(BambiettaTR_Duration, BambiettaTR_IsInvul) + T_Push(BambiettaTR_PushRange), T_Bonus("Form", "|cffFF0000Vollstandig Form|r")).setDecor(T_Decor(BambiettaTR_DecorDamage))
        call SpellData.createSimple(BambiettaT2_ID, 1, 2, 2, BambiettaTT_DamageAgiBase, 0.0, T_RadExp(BambiettaTT_DamageAoe, BambiettaTT_DamageAoe2) + T_DurAuto(BambiettaTT_Duration, BambiettaT2_IsInvul) + T_Prop("Explosions", 21), T_Bonus("Form", "|cffFF0000Vollstandig Form|r")).setDecor(T_Decor(BambiettaTT_DecorDamage))

        // Регистрация обеих форм
        set form = HeroData.create(Bambietta_ID, 0, BambiettaQ_ID, BambiettaW_ID, BambiettaE_ID, BambiettaR_ID, BambiettaT_ID, BambiettaG_ID, 0, 0, 0, 0)
        set form = HeroData.create(Bambietta_ID, 1, BambiettaQ_ID, BambiettaW_ID, BambiettaE_ID, BambiettaR_ID, BambiettaT2_ID, BambiettaG_ID, 0, 0, 0, 0)
        set form = HeroData.create(Bambietta2_ID, 1, BambiettaQ_ID, BambiettaW_ID, BambiettaE_ID, BambiettaR_ID, BambiettaT2_ID, BambiettaG_ID, 0, 0, 0, 0)
        
        call DestroyTimer(t)
    endfunction
    
    private function InitHeroes_Part2 takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local HeroData form
        
        // ----------------------------------------------------------
        // 9. Кирито ('H023') -> Ловкость (2)
        // ----------------------------------------------------------
        call SpellData.create(KiritoQ_ID, 5, 1, 2, KiritoQ_DamageAgiBase, KiritoQ_DamageAgiStep, KiritoQ_Damage2StaticBase, KiritoQ_Damage2StaticStep, T_Rad(KiritoQ_DamageAoe) + T_Stun(KiritoQ_StunDuration), T_Bonus("T Mode", "+35% AoE"))
        call SpellData.create(KiritoW_ID, 5, 1, 2, KiritoW_DamageAgiBase, KiritoW_DamageAgiStep, KiritoW_Damage2StaticBase, KiritoW_Damage2StaticStep, T_Rad(KiritoW_DamageAoe) + T_Slow(KiritoW_Slow, KiritoW_SlowDuration), T_Bonus("R Mode", "+200 AoE, Agility x " + FormatReal(KiritoRW_AdditionalDamageAgi) + " Bonus Damage"))
        call SpellData.create(KiritoE_ID, 5, 1, 2, KiritoE_DamageAgiBase, KiritoE_DamageAgiStep, KiritoE_Damage2StaticBase, KiritoE_Damage2StaticStep, T_Rad(KiritoE_DamageAoe), "Creates 4 shadow clones")
        
        call SpellData.createSimple(KiritoR_ID, 5, 1, 2, KiritoR_DamageAgiBase, KiritoR_DamageAgiStep, "Duration: <L:" + FormatReal(KiritoR_DurationBase) + "/" + FormatReal(KiritoR_DurationBase + KiritoR_DurationStep) + "/" + FormatReal(KiritoR_DurationBase + KiritoR_DurationStep * 2) + "/" + FormatReal(KiritoR_DurationBase + KiritoR_DurationStep * 3) + "/" + FormatReal(KiritoR_DurationBase + KiritoR_DurationStep * 4) + "> sec|n" + T_Rad(KiritoR_DamageAoe), T_Bonus("Final Strike (13th)", "Agility x <L:" + FormatReal(KiritoR_Damage2AgiBase) + "/" + FormatReal(KiritoR_Damage2AgiBase + KiritoR_Damage2AgiStep) + "/" + FormatReal(KiritoR_Damage2AgiBase + KiritoR_Damage2AgiStep * 2) + "/" + FormatReal(KiritoR_Damage2AgiBase + KiritoR_Damage2AgiStep * 3) + "/" + FormatReal(KiritoR_Damage2AgiBase + KiritoR_Damage2AgiStep * 4) + "> Dmg"))
        
        call SpellData.createSimple(KiritoT_ID, 1, 1, 2, KiritoT_DamageAgiBase, 0.0, T_Rad(KiritoT_DamageAoe) + "Blocks " + FormatReal(KiritoT_BlockHpRegenAmount) + "% HP Regen for " + FormatReal(KiritoT_BlockHpRegenTime) + " sec", "")
        call SpellData.createUtility(KiritoF_ID, 1, "Swaps positions with target", "")
        call SpellData.createUtility(KiritoG_ID, 1, "Passive|nHeal: Agility x " + FormatReal(KiritoG_Heal) + " every " + FormatReal(KiritoG_Time) + " sec", "")
        
        call SpellData.createUtility(KiritoE2_ID, 1, "Teleports to a shadow clone", "")
        call SpellData.createSimple(KiritoR2_ID, 5, 1, 4, 1.0, 0.0, "Final Strike of Starburst Stream", "")
        call SpellData.createUtility(KiritoR_AS, 1, "Attack Speed buff from R", "")
        call SpellData.createSimple(KiritoT2_ID, 1, 1, 2, KiritoT2_DamageAgiBase, 0.0, T_Rad(800) + T_Stun(KiritoT2_Stun), "")
        call SpellData.createUtility(KiritoG2_ID, 1, "Toggle: Teleport to Closest/Farthest clone", "")

        set form = HeroData.create(Kirito_ID, 0, KiritoQ_ID, KiritoW_ID, KiritoE_ID, KiritoR_ID, KiritoT_ID, KiritoF_ID, KiritoG_ID, KiritoE2_ID, KiritoR2_ID, KiritoR_AS)
        call form.addExtra(KiritoT2_ID, KiritoG2_ID, 0, 0, 0, 0, 0, 0, 0, 0)
        
        // ===================================
        // 10. Алукард (Alucard_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(AlucardQ_ID, 5, 1, 2, AlucardQ_DamageAgiBase, AlucardQ_DamageAgiStep, AlucardQ_Damage2StaticBase, AlucardQ_Damage2StaticStep, T_Rad(AlucardQ_DamageAoe), T_Bonus("Ability Lv. 5", "Unlocks Q2"))
        call SpellData.create(AlucardW_ID, 5, 1, 2, AlucardW_DamageAgiBase, AlucardW_DamageAgiStep, AlucardW_Damage2StaticBase, AlucardW_Damage2StaticStep, "Heal: Agility x <L:" + FormatReal(AlucardW_SelfHealAgiBase) + "/" + FormatReal(AlucardW_SelfHealAgiBase+AlucardW_SelfHealAgiStep) + "/" + FormatReal(AlucardW_SelfHealAgiBase+AlucardW_SelfHealAgiStep*2) + "/" + FormatReal(AlucardW_SelfHealAgiBase+AlucardW_SelfHealAgiStep*3) + "/" + FormatReal(AlucardW_SelfHealAgiBase+AlucardW_SelfHealAgiStep*4) + ">", "")
        call SpellData.create(AlucardE_ID, 5, 1, 2, AlucardE_DamageAgiBase, AlucardE_DamageAgiStep, AlucardE_DamageStatic, 0.0, T_Rad(AlucardE_DamageAoe) + T_Slow(AlucardE_Slow, AlucardE_Duration), "")
        call SpellData.createUtility(AlucardR_ID, 5, "Duration: <L:" + FormatReal(AlucardR_DurationBase) + "/" + FormatReal(AlucardR_DurationBase+AlucardR_DurationStep) + "/" + FormatReal(AlucardR_DurationBase+AlucardR_DurationStep*2) + "/" + FormatReal(AlucardR_DurationBase+AlucardR_DurationStep*3) + "/" + FormatReal(AlucardR_DurationBase+AlucardR_DurationStep*4) + "> sec|nEnhances Q, W, E abilities", "")
        call SpellData.createUtility(AlucardT_ID, 1, T_Dur("Duration", AlucardT_Duration) + "Damage Amp to target: " + FormatReal(AlucardT_AdditionalDamageToTarget) + "%|nDamage Resistance: 75%|nLifesteal: " + FormatReal(AlucardT_Heal) + "%", "")
        call SpellData.createUtility(AlucardF_ID, 1, "Passive|nFacing target within " + I2S(R2I(AlucardF_MSBonusAngleCap)) + " deg grants MS|nGrants vision (" + I2S(R2I(AlucardF_VisionAoe)) + " AoE) for " + FormatReal(AlucardF_VisionTime) + " sec|n" + T_Dur("Vision CD", AlucardF_Cooldown), "")
        call SpellData.createUtility(AlucardG_ID, 1, "Passive|n< " + I2S(R2I(AlucardG_HpCond1)) + "% HP: Immune to Slow|n< " + I2S(R2I(AlucardG_HpCond2)) + "% HP: Immune to Attacks|n< " + I2S(R2I(AlucardG_HpCond3)) + "% HP: Immune to Debuffs", "")
        
        call SpellData.createAlt(AlucardQ_ID, 1, 5, 1, 2, AlucardQ_DamageAgiBase, AlucardQ_DamageAgiStep, AlucardQ_Damage2StaticBase, AlucardQ_Damage2StaticStep, T_Rad(AlucardRQ_DamageAoe) + "Below " + I2S(R2I(AlucardRQ_HpToAddDamageCondition)) + "% HP: +" + FormatReal(AlucardRQ_AddDamageFromMissedHp) + "% Missing HP Dmg", T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createAlt(AlucardE_ID, 1, 5, 1, 2, AlucardE_DamageAgiBase + AlucardRE_DamageAgiIncrease, AlucardE_DamageAgiStep, AlucardE_DamageStatic, 0.0, T_Rad(AlucardE_DamageAoe) + T_Slow(AlucardE_Slow, AlucardE_Duration) + "Continuous Knockback", T_Bonus("Form", "|cffFF0000Release State|r"))
        
        call SpellData.create(AlucardQ2_ID, 5, 1, 2, AlucardQ2_DamageAgiBase, AlucardQ2_DamageAgiStep, AlucardQ2_Damage2StaticBase, AlucardQ2_Damage2StaticStep, T_Stun(AlucardQ2_StunTime) + T_Dur("Cast window", AlucardQ_TimeBeforeQ2Expire), "")
        call SpellData.createSimple(AlucardW2_ID, 5, 1, 2, AlucardRW_DamageAgiBase, AlucardRW_DamageAgiStep, T_Rad(AlucardRW_DamageAoe) + T_Dur("Duration", AlucardRW_Duration + 0.33) + "Speed: " + I2S(R2I(AlucardRW_Speed)), "")
        call SpellData.createSimple(AlucardT2_ID, 1, 1, 2, AlucardT2_DamageAgiBase, 0.0, T_Rad(AlucardT2_DamageAoe) + "(Expands by " + I2S(R2I(AlucardT2_DamageAoeStep)) + " x4)|nHP Cost: " + FormatReal(AlucardT2_HpCost) + "% Current HP|nLesser Approval: " + FormatReal(AlucardT_Duration / 2) + " sec, +" + FormatReal(AlucardT_AdditionalDamageToTarget * (AlucardT2_PercentageCrumwell / 100)) + "% Dmg Amp, " + FormatReal(AlucardT2_Heal) + "% Lifesteal", "")
        
        set form = HeroData.create(Alucard_ID, 0, AlucardQ_ID, AlucardW_ID, AlucardE_ID, AlucardR_ID, AlucardT_ID, AlucardF_ID, AlucardG_ID, AlucardQ2_ID, AlucardW2_ID, AlucardT2_ID)
        set form = HeroData.create(Alucard_ID, 1, AlucardQ_ID, AlucardW_ID, AlucardE_ID, AlucardR_ID, AlucardT_ID, AlucardF_ID, AlucardG_ID, AlucardQ2_ID, AlucardW2_ID, AlucardT2_ID)
        
        // ===================================
        // 11. Старрк (Starrk_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(StarrkQ_ID, 5, 2, 2, StarrkQ_DamageAgiBase, StarrkQ_DamageAgiStep, StarrkQ_Damage2StaticBase, StarrkQ_Damage2StaticStep, T_Rad(StarrkQ_DamageAoe), "") 
        call SpellData.create(StarrkW_ID, 5, 1, 2, StarrkW_DamageAgiBase, StarrkW_DamageAgiStep, StarrkW_Damage2StaticBase, StarrkW_Damage2StaticStep, T_Rad(StarrkW_DamageAoe) + T_Stun(StarrkW_StunDuration), "")
        call SpellData.createUtility(StarrkE_ID, 5, "Duration: <L:" + FormatReal(StarrkE_DurationBase) + "/" + FormatReal(StarrkE_DurationBase+StarrkE_DurationStep) + "/" + FormatReal(StarrkE_DurationBase+StarrkE_DurationStep*2) + "/" + FormatReal(StarrkE_DurationBase+StarrkE_DurationStep*3) + "/" + FormatReal(StarrkE_DurationBase+StarrkE_DurationStep*4) + "> sec|nBonus MS: " + I2S(StarrkE_MS) + "%|nBonus Attack Range: " + I2S(R2I(StarrkE_AttackRange)), T_Bonus("Lv. 35", "Reduces R Cooldown by " + I2S(R2I(StarrkE_ReduceR_CD)) + " sec"))        
        call SpellData.createSimple(StarrkR_ID, 5, 2, 2, StarrkR_DamageAgiBase, StarrkR_DamageAgiStep, T_Rad(StarrkR_DamageAoe), "")
        call SpellData.createSimple(StarrkT_ID, 1, 2, 2, StarrkT_DamageAgiBase, 0.0, T_Dur("Duration", StarrkT_Duration) + T_Prop("Search Radius", StarrkT_SearchAoe), "Summons wolves that hunt down enemies")
        call SpellData.createUtility(StarrkF_ID, 1, "Ends Wolf State early", "")
        call SpellData.createUtility(StarrkG_ID, 1, "Passive (Unlocks at Lv. 12)|nCondition: No allies within " + I2S(R2I(StarkG_Aoe12)) + "/" + I2S(R2I(StarkG_Aoe25)) + "/" + I2S(R2I(StarkG_Aoe35)) + " range|nOn Cast (3+ sec CD):|n- Restores 0.85/1.05/1.25% Max HP & MP|n- Grants +4 Agi, +2 Str/Int for " + I2S(R2I(StarkG_TimeStatAdd)) + " sec|n- Max Stacks: 2/4/6", "")

        call SpellData.createAlt(StarrkQ_ID, 1, 5, 2, 2, StarrkQ_DamageAgiBase + StarrkQ_DamageMorphIntImprove, StarrkQ_DamageAgiStep, StarrkQ_Damage2StaticBase, StarrkQ_Damage2StaticStep, T_Rad(StarrkQ_DamageAoe * StarrkEQ_AoeMultiplier) + T_Push(StarrkEQ_PushDistance), T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createAlt(StarrkW_ID, 1, 5, 1, 2, StarrkW_DamageAgiBase + StarrkEW_DamageMorphIntImprove, StarrkW_DamageAgiStep, StarrkW_Damage2StaticBase, StarrkW_Damage2StaticStep, T_Rad(StarrkEW_DamageAoe) + T_Prop("Strikes", StarrkEW_AttackCount), T_Bonus("Form", "|cffFF0000Release State|r"))
        
        call SpellData.createAlt(StarrkQ_ID, 2, 5, 2, 2, StarrkQ_DamageAgiBase + StarrkQ_DamageMorphIntImprove + StarrkQ_DamageTIntImprove, StarrkQ_DamageAgiStep, StarrkQ_Damage2StaticBase, StarrkQ_Damage2StaticStep, T_Rad(StarrkTQ_Aoe) + T_Stun(StarrkTQ_Stun), T_Bonus("Form", "|cffFF0000Wolf State|r"))
        call SpellData.createAlt(StarrkW_ID, 2, 5, 1, 2, StarrkW_DamageAgiBase + StarrkEW_DamageMorphIntImprove + StarrkTW_DamageImprove, StarrkW_DamageAgiStep, StarrkW_Damage2StaticBase, StarrkW_Damage2StaticStep, T_Rad(StarrkEW_DamageAoe), T_Bonus("Form", "|cffFF0000Wolf State|r"))
        
        call SpellData.createUtility(StarrkE2_ID, 5, "Dash Distance: <L:" + I2S(R2I(StarrkE2_RangeBase)) + "/" + I2S(R2I(StarrkE2_RangeBase+StarrkE2_RangeStep)) + "/" + I2S(R2I(StarrkE2_RangeBase+StarrkE2_RangeStep*2)) + "/" + I2S(R2I(StarrkE2_RangeBase+StarrkE2_RangeStep*3)) + "/" + I2S(R2I(StarrkE2_RangeBase+StarrkE2_RangeStep*3)) + ">", T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createSimple(StarrkR2_ID, 5, 2, 2, StarrkR2_DamageAgiBase, StarrkR2_DamageAgiStep, T_Rad(StarrkR2_DamageAoe) + T_Dur("Duration", 3.2) + T_Slow(StarrkR2_Slow, StarrkR2_SlowDuration), T_Bonus("Lv. 35", "Stuns for " + FormatReal(StarrkR2_Stun) + " sec") + "|n" + T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createSimple(StarrkT2_ID, 1, 2, 2, StarrkT_DamageAgiBase2, 0.0, T_Rad(StarrkT_DamageAoe) + "Damage is multiplied by the number of active wolves (Max 10)", T_Bonus("Form", "|cffFF0000Wolf State|r"))
        call SpellData.createSimple(StarrkR3_ID, 1, 2, 2, StarrkTR_DamageAgiBase, 0.0, T_Rad(StarrkT_DamageAoe) + T_Dur("Invulnerability", 1.6) + "Damage is multiplied by the number of active wolves (Max 10)", T_Bonus("Form", "|cffFF0000Wolf State|r"))
        
        set form = HeroData.create(Starrk_ID, 0, StarrkQ_ID, StarrkW_ID, StarrkE_ID, StarrkR_ID, StarrkT_ID, StarrkF_ID, StarrkG_ID, StarrkE2_ID, StarrkR2_ID, StarrkT2_ID)
        call form.addExtra(StarrkR3_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        
        set form = HeroData.create(Starrk_ID, 1, StarrkQ_ID, StarrkW_ID, StarrkE_ID, StarrkR_ID, StarrkT_ID, StarrkF_ID, StarrkG_ID, StarrkE2_ID, StarrkR2_ID, StarrkT2_ID)
        call form.addExtra(StarrkR3_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0)

        set form = HeroData.create(Starrk_ID, 2, StarrkQ_ID, StarrkW_ID, StarrkE_ID, StarrkR_ID, StarrkT_ID, StarrkF_ID, StarrkG_ID, StarrkE2_ID, StarrkR2_ID, StarrkT2_ID)
        call form.addExtra(StarrkR3_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        
        // ===================================
        // 12. Такеши Ямамото (Takeshi_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(TakeshiQ_ID, 5, 1, 2, TakeshiQ_DamageAgiBase, TakeshiQ_DamageAgiStep, TakeshiQ_Damage2StaticBase, TakeshiQ_Damage2StaticStep, T_Rad(TakeshiQ_DamageAoe), T_Bonus("State", "|cffFF3333Offensive State|r"))
        call SpellData.create(TakeshiW_ID, 5, 1, 2, TakeshiW_DamageAgiBase, TakeshiW_DamageAgiStep, TakeshiW_Damage2StaticBase, TakeshiW_Damage2StaticStep, T_Rad(TakeshiW_DamageAoe) + T_Push(TakeshiW_PushRange) + T_Stun(TakeshiW_Stun), T_Bonus("State", "|cffFF3333Offensive State|r"))
        call SpellData.createSimple(TakeshiE_ID, 5, 1, 2, TakeshiE_DamageAgiBase, TakeshiE_DamageAgiStep, T_Rad(TakeshiE_DamageAoe), T_Bonus("State", "|cffFF3333Offensive State|r"))
        call SpellData.createSimple(TakeshiR_ID, 5, 2, 2, TakeshiR_DamageAgiBase, TakeshiR_DamageAgiStep, T_Rad(TakeshiR_DamageAoe) + T_Stun(TakeshiR_Stun), T_Bonus("State", "|cffFF3333Offensive State|r"))
        call SpellData.createUtility(TakeshiT_ID, 1, T_Dur("Duration", TakeshiT_Duration) + T_Slow(TakeshiT_Slow, TakeshiT_SlowDuration), "Reduces all CDs by " + FormatReal(TakeshiT_ReduceCD) + " sec per second|nAdds Agility x" + FormatReal(TakeshiT_AddDmg) + " to abilities")
        call SpellData.createUtility(TakeshiF_ID, 1, "Switches between Offensive and Defensive styles", "")
        call SpellData.createUtility(TakeshiG_ID, 1, "Passive|nDealing " + I2S(R2I(TakeshiG_TakenDamageToEnter)) + " damage to enemy heroes unlocks Vongola Primo Form", "")
        
        call SpellData.createUtility(TakeshiQ2_ID, 5, T_Rad(TakeshiQ2_Aoe) + T_Push(TakeshiQ2_PushDistance) + T_Stun(TakeshiQ2_Stun), "Lv. 12: Unlocks Utsushi Ame (Q3)|n" + T_Bonus("State", "|cff00FFFFDefensive State|r"))
        call SpellData.createSimple(TakeshiQ3_ID, 1, 1, 2, TakeshiQ3_DamageAgiBase, 0.0, T_Stun(TakeshiQ3_Stun), T_Bonus("State", "|cff00FFFFDefensive State|r"))
        call SpellData.create(TakeshiW2_ID, 5, 1, 2, TakeshiW2_DamageAgiBase, TakeshiW2_DamageAgiStep, TakeshiW2_Damage2StaticBase, TakeshiW2_Damage2StaticStep, "", T_Bonus("State", "|cff00FFFFDefensive State|r"))
        call SpellData.createUtility(TakeshiE2_ID, 5, T_Dur("Blink duration", TakeshiE2_Duration), T_Bonus("State", "|cff00FFFFDefensive State|r"))
        call SpellData.createUtility(TakeshiR2_ID, 5, "Duration: <L:" + FormatReal(TakeshiR2_DurationBase) + "/" + FormatReal(TakeshiR2_DurationBase+TakeshiR2_DurationStep) + "/" + FormatReal(TakeshiR2_DurationBase+TakeshiR2_DurationStep*2) + "/" + FormatReal(TakeshiR2_DurationBase+TakeshiR2_DurationStep*3) + "/" + FormatReal(TakeshiR2_DurationBase+TakeshiR2_DurationStep*4) + "> sec", T_Bonus("State", "|cff00FFFFDefensive State|r"))
        
        call SpellData.createUtility(TakeshiG2_ID, 1, T_Dur("Duration", TakeshiG_Duration) + "Reduces all CDs by " + FormatReal(TakeshiG_ReduceCD) + " sec|nUnlocks ultimate abilities", "")
        call SpellData.createSimple(TakeshiGQ_ID, 1, 1, 2, TakeshiGQ_DamageAgiBase, 0.0, T_Rad(TakeshiGQ_DamageAoe) + T_Stun(TakeshiGQ_Stun), T_Bonus("Form", "|cffFF6600Primo Form|r"))
        call SpellData.createSimple(TakeshiGW_ID, 1, 1, 2, TakeshiGW_DamageAgiBase, 0.0, T_Rad(TakeshiGW_DamageAoe) + T_Dur("Summon Duration", TakeshiGW_Time), T_Bonus("Form", "|cffFF6600Primo Form|r"))
        call SpellData.createSimple(TakeshiGE_ID, 1, 2, 2, TakeshiGE_DamageAgiBase, 0.0, T_Rad(TakeshiGE_DamageAoe), T_Bonus("Form", "|cffFF6600Primo Form|r"))
        call SpellData.createSimple(TakeshiGR_ID, 1, 2, 2, TakeshiGR_DamageAgiBase, 0.0, T_Rad(TakeshiGR_DamageAoe) + T_Stun(TakeshiGR_Stun), T_Bonus("Form", "|cffFF6600Primo Form|r"))
        call SpellData.createSimple(TakeshiGF_ID, 1, 1, 2, TakeshiGF_DamageAgiBase, 0.0, T_Root(TakeshiGF_Root), T_Bonus("Form", "|cffFF6600Primo Form|r"))

        set form = HeroData.create(Takeshi_ID, 0, TakeshiQ_ID, TakeshiW_ID, TakeshiE_ID, TakeshiR_ID, TakeshiT_ID, TakeshiF_ID, TakeshiG_ID, TakeshiQ2_ID, TakeshiW2_ID, TakeshiE2_ID)
        call form.addExtra(TakeshiR2_ID, TakeshiG2_ID, TakeshiGQ_ID, TakeshiGW_ID, TakeshiGE_ID, TakeshiGR_ID, TakeshiGF_ID, TakeshiQ3_ID, 0, 0)
        
        // ===================================
        // 13. Барраган (Barragan_ID) -> Интеллект (3)
        // ===================================
        call SpellData.create(BarraganQ_ID, 5, 2, 3, BarraganQ_DamageIntBase, BarraganQ_DamageIntStep, BarraganQ_Damage2StaticBase, BarraganQ_Damage2StaticStep, T_Rad(BarraganQ_DamageAoe), T_Bonus("Lv. 35", "Applies Senescencia (G) passive"))
        call SpellData.create(BarraganW_ID, 5, 1, 3, BarraganW_DamageIntBase, BarraganW_DamageIntStep, BarraganW_Damage2StaticBase, BarraganW_Damage2StaticStep, T_Rad(BarraganW_DamageAoe), T_Bonus("Ability Lv. 5", "Unlocks W2"))
        call SpellData.createUtility(BarraganE_ID, 5, "Duration: <L:" + FormatReal(BarraganE_DurationBase) + "/" + FormatReal(BarraganE_DurationBase+BarraganE_DurationStep) + "/" + FormatReal(BarraganE_DurationBase+BarraganE_DurationStep*2) + "/" + FormatReal(BarraganE_DurationBase+BarraganE_DurationStep*3) + "/" + FormatReal(BarraganE_DurationBase+BarraganE_DurationStep*4) + "> sec|nBonus Max HP: <L:" + I2S(BarraganE_HP_Base) + "/" + I2S(BarraganE_HP_Base+BarraganE_HP_Step) + "/" + I2S(BarraganE_HP_Base+BarraganE_HP_Step*2) + "/" + I2S(BarraganE_HP_Base+BarraganE_HP_Step*3) + "/" + I2S(BarraganE_HP_Base+BarraganE_HP_Step*4) + ">", T_Bonus("Lv. 35", "Reduces R Cooldown by " + I2S(R2I(BarraganE_ReduceR_CD)) + " sec"))
        call SpellData.create(BarraganR_ID, 5, 2, 3, BarraganR_DamageIntBase, BarraganR_DamageIntStep, BarraganR_Damage2StaticBase, BarraganR_Damage2StaticStep, T_Rad(BarraganR_DamageAoe) + "Invulnerability: <L:" + FormatReal(BarraganR_DamageInvulBase) + "/" + FormatReal(BarraganR_DamageInvulBase+BarraganR_DamageInvulStep) + "/" + FormatReal(BarraganR_DamageInvulBase+BarraganR_DamageInvulStep*2) + "/" + FormatReal(BarraganR_DamageInvulBase+BarraganR_DamageInvulStep*3) + "/" + FormatReal(BarraganR_DamageInvulBase+BarraganR_DamageInvulStep*4) + "> sec|nRestores " + FormatReal(BarraganR_ManaRestore) + "% Max MP|n" + T_Slow(BarraganR_Slow, BarraganR_SlowDuration), "")
        call SpellData.createUtility(BarraganT_ID, 1, T_Dur("Duration", BarraganT_Duration) + "Enhances Q and E2 abilities", "Can only be cast in Release State")
        call SpellData.create(BarraganG_ID, 1, 2, 3, BarraganG_DamageIntBase, 0.0, BarraganG_Damage2Static_6, 0.0, "Passive (Senescencia)|nBurns enemies over " + FormatReal(BarraganG_DamageDuration) + " sec", T_Bonus("Lv. 25", "Base Damage " + I2S(R2I(BarraganG_Damage2Static_25)) + "|nLv. 35: Base Damage " + I2S(R2I(BarraganG_Damage2Static_35)) + ", added to Release State abilities"))
        call SpellData.create(BarraganW2_ID, 5, 1, 3, BarraganW2_DamageIntBase, 0.0, BarraganW2_Damage2StaticBase, 0.0, T_Rad(BarraganW2_DamageAoe), "")
        call SpellData.createSimple(BarraganE2_ID, 5, 1, 3, BarraganE2_DamageIntBase, 0.0, T_Rad(BarraganE2_DamageAoe), T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.create(BarraganT2_ID, 1, 2, 3, BarraganT2_DamageIntBase, 0.0, BarraganT2_Damage2StaticBase, 0.0, T_Rad(BarraganT2_DamageAoe) + T_Stun(BarraganT2_StunDuration), T_Bonus("Form", "|cffFF0000Release State|r"))
        
        call SpellData.createAlt(BarraganQ_ID, 1, 5, 2, 3, BarraganQ_DamageIntBase + BarraganQ_DamageMorphIntImprove, BarraganQ_DamageIntStep, BarraganQ_Damage2StaticBase, BarraganQ_Damage2StaticStep, T_Rad(BarraganQ_DamageAoe) + T_Prop("Bonus Range", BarraganEQ_RangeAdd), T_Bonus("Lv. 35", "Applies Senescencia (G) passive|n") + T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createAlt(BarraganQ_ID, 2, 5, 2, 3, BarraganQ_DamageIntBase + BarraganQ_DamageMorphIntImprove + BarraganQ_DamageTIntImprove, BarraganQ_DamageIntStep, BarraganQ_Damage2StaticBase, BarraganQ_Damage2StaticStep, T_Rad(BarraganQ_DamageAoe) + T_Stun(BarraganETQ_Stun) + T_Prop("Bonus Range", BarraganEQ_RangeAdd), T_Bonus("Lv. 35", "Applies Senescencia (G) passive|n") + T_Bonus("Form", "|cffFF0000Enhanced Release State|r"))
        call SpellData.createAlt(BarraganW_ID, 1, 5, 2, 3, BarraganW_DamageIntBase + BarraganW_DamageMorphIntImprove, BarraganW_DamageIntStep, BarraganW_Damage2StaticBase, BarraganW_Damage2StaticStep, T_Rad(BarraganW_DamageAoe) + T_Prop("Cast Range", BarraganW_MorphRange) + T_Slow(BarraganW_Slow, BarraganW_SlowDuration), T_Bonus("Lv. 35", "Applies Senescencia (G) passive|n") + T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createAlt(BarraganR_ID, 1, 5, 2, 3, BarraganER_DamageIntBase, BarraganER_DamageIntStep, BarraganER_Damage2StaticBase, BarraganER_Damage2StaticStep, T_Rad(BarraganER_DamageAoe) + T_Dur("Damage over Time", BarraganER_DamageDuration) + T_Slow(BarraganR_Slow, BarraganR_SlowDuration), T_Bonus("Lv. 35", "Applies Senescencia (G) passive|n") + T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createAlt(BarraganE2_ID, 2, 5, 1, 3, BarraganE2_DamageIntBase + BarraganE2_DamageIntBaseTAdd, 0.0, 0.0, 0.0, T_Rad(BarraganE2_DamageAoe) + T_Stun(BarraganE2T_Stun), T_Bonus("Lv. 35", "Applies Senescencia (G) passive|n") + T_Bonus("Form", "|cffFF0000Enhanced Release State|r"))
        
        set form = HeroData.create(Barragan_ID, 0, BarraganQ_ID, BarraganW_ID, BarraganE_ID, BarraganR_ID, BarraganT_ID, BarraganG_ID, BarraganW2_ID, BarraganE2_ID, BarraganT2_ID, 0)
        set form = HeroData.create(Barragan_ID, 1, BarraganQ_ID, BarraganW_ID, BarraganE_ID, BarraganR_ID, BarraganT_ID, BarraganG_ID, BarraganW2_ID, BarraganE2_ID, BarraganT2_ID, 0)
        set form = HeroData.create(Barragan_ID, 2, BarraganQ_ID, BarraganW_ID, BarraganE_ID, BarraganR_ID, BarraganT_ID, BarraganG_ID, BarraganW2_ID, BarraganE2_ID, BarraganT2_ID, 0)
        
        // ===================================
        // 14. Махорага (Mahoraga_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(MahoragaQ_ID, 5, 1, 2, MahoragaQ_DamageAgiBase, MahoragaQ_DamageAgiStep, MahoragaQ_Damage2StaticBase, MahoragaQ_Damage2StaticStep, T_Rad(MahoragaQ_DamageAoe) + T_Stun(MahoragaQ_Stun), T_Bonus("Lv. 35", "Unlocks Q2 for " + I2S(R2I(MahoragaQ2_TimeSwap)) + " sec on hit"))
        call SpellData.create(MahoragaW_ID, 5, 1, 2, MahoragaW_DamageAgiBase, MahoragaW_DamageAgiStep, MahoragaW_Damage2StaticBase, MahoragaW_Damage2StaticStep, T_Rad(MahoragaW_DamageAoe) + T_Slow(MahoragaW_Slow, MahoragaW_SlowDuration), T_Bonus("T", "3 Adaptation Stacks: Unlocks W2"))
        call SpellData.createSimple(MahoragaE_ID, 5, 1, 2, MahoragaE_DamageAgiBase, MahoragaE_DamageAgiStep, T_Rad(MahoragaE_DamageAoe), T_Bonus("Lv. 25", "Unlocks E2 for " + I2S(R2I(MahoragaE2_TimeSwap)) + " sec"))
        call SpellData.createUtility(MahoragaR_ID, 5, "Heal: Agility x <L:" + FormatReal(MahoragaR_HealAgiBase) + "/" + FormatReal(MahoragaR_HealAgiBase+MahoragaR_HealAgiStep) + "/" + FormatReal(MahoragaR_HealAgiBase+MahoragaR_HealAgiStep*2) + "/" + FormatReal(MahoragaR_HealAgiBase+MahoragaR_HealAgiStep*3) + "/" + FormatReal(MahoragaR_HealAgiBase+MahoragaR_HealAgiStep*4) + ">|n" + T_Dur("Duration", MahoragaR_Duration), T_Bonus("Lv. 35", "Dispels debuffs and grants Debuff Immunity"))
        call SpellData.createUtility(MahoragaT_ID, 1, "Passive (Adaptation)|nTaking " + I2S(MahoragaT_DamageToReduceCD) + " damage grants an Adaptation stack (Max 8)|nEach stack grants " + FormatReal(MahoragaT_DamageReductionPerStack) + "% Damage Reduction", "")
        call SpellData.createSimple(MahoragaF_ID, 1, 1, 2, MahoragaF_DamageAgiBase, 0.0, T_Rad(MahoragaF_DamageAoe) + T_Push(MahoragaF_PushRange), "")
        call SpellData.createSimple(MahoragaG_ID, 1, 1, 2, MahoragaG_DamageAgiBase, 0.0, "", "")
        
        call SpellData.createSimple(MahoragaQ2_ID, 5, 1, 2, MahoragaQ2_DamageAgiBase, 0.0, T_Rad(MahoragaQ2_DamageAoe) + T_Stun(MahoragaQ2_Stun), "")
        call SpellData.createSimple(MahoragaW2_ID, 5, 1, 2, MahoragaW2_DamageAgiBase, 0.0, T_Stun(MahoragaW2_Stun), "")
        call SpellData.createSimple(MahoragaE2_ID, 5, 1, 2, MahoragaE2_DamageAgiBase, 0.0, T_Rad(MahoragaE2_DamageAoe), "")
        call SpellData.createSimple(MahoragaE3_ID, 5, 1, 2, MahoragaE3_DamageAgiBase, 0.0, T_Rad(MahoragaE3_DamageAoe) + T_Prop("Bonus Damage to Buildings %", MahoragaE3_DamageAddForBuildings), "")
        
        set form = HeroData.create(Mahoraga_ID, 0, MahoragaQ_ID, MahoragaW_ID, MahoragaE_ID, MahoragaR_ID, MahoragaT_ID, MahoragaF_ID, MahoragaG_ID, MahoragaQ2_ID, MahoragaW2_ID, MahoragaE2_ID)
        call form.addExtra(MahoragaE3_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        
        // ===================================
        // 15. Тия Харрибел (Harribel_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(HarribelQ_ID, 5, 2, 2, HarribelQ_DamageAgiBase, HarribelQ_DamageAgiStep, HarribelQ_Damage2StaticBase, HarribelQ_Damage2StaticStep, T_Rad(HarribelQ_DamageAoe), "")
        call SpellData.create(HarribelW_ID, 5, 1, 2, HarribelW_DamageAgiBase, HarribelW_DamageAgiStep, HarribelW_Damage2StaticBase, HarribelW_Damage2StaticStep, T_Stun(HarribelW_StunDuration), "")
        call SpellData.createUtility(HarribelE_ID, 5, "Duration: <L:" + FormatReal(HarribelE_DurationBase) + "/" + FormatReal(HarribelE_DurationBase+HarribelE_DurationStep) + "/" + FormatReal(HarribelE_DurationBase+HarribelE_DurationStep*2) + "/" + FormatReal(HarribelE_DurationBase+HarribelE_DurationStep*3) + "/" + FormatReal(HarribelE_DurationBase+HarribelE_DurationStep*4) + "> sec", T_Bonus("Lv. 35", "Reduces R Cooldown by " + I2S(R2I(HarribelE_ReduceR_CD)) + " sec"))
        call SpellData.createSimple(HarribelR_ID, 5, 1, 2, HarribelR_DamageAgiBase, HarribelR_DamageAgiStep, T_Rad(HarribelR_DamageAoe), "")
        call SpellData.createSimple(HarribelT_ID, 1, 2, 2, HarribelT_DamageAgiBase, 0.0, T_Rad(HarribelT_DamageAoe), "")
        call SpellData.createUtility(HarribelG_ID, 1, "Passive (Sacrifice)|nRestores " + FormatReal(Harribel_Pas_RestoreHp1) + "/" + FormatReal(Harribel_Pas_RestoreHp2) + "/" + FormatReal(Harribel_Pas_RestoreHp3) + "% Max HP when an ally hero dies (Lv. 12/25/35)", T_Bonus("Stores", "Up to 1000/2000/3000 allied damage (Lv. 1/25/35) to grant buffs"))
        
        call SpellData.createAlt(HarribelQ_ID, 1, 5, 2, 2, HarribelQ_DamageAgiBase, HarribelQ_DamageAgiStep, HarribelQ_Damage2StaticBase, HarribelQ_Damage2StaticStep, T_Rad(HarribelEQ_AoeFinal), T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createAlt(HarribelW_ID, 1, 5, 1, 2, HarribelW_DamageAgiBase, HarribelW_DamageAgiStep, HarribelW_Damage2StaticBase, HarribelW_Damage2StaticStep, T_Rad(HarribelEW_DamageAoe) + T_Stun(HarribelW_StunDuration) + "Bonus Damage: Agility x" + FormatReal(HarribelEW_DamageAgiBonus) + " per tick (Max 3 sec)", T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createSimple(HarribelE2_ID, 5, 1, 2, HarribelEE_DamageAgiBase, HarribelEE_DamageAgiStep, T_Rad(HarribelEE_DamageAoe) + T_Push(HarribelEE_PushRange), T_Bonus("Form", "|cffFF0000Release State|r"))
        call SpellData.createSimple(HarribelR2_ID, 5, 2, 2, HarribelER_DamageAgiBase, HarribelER_DamageAgiStep, T_Rad(HarribelER_DamageAoeFinal) + "Projectiles: <L:" + I2S(HarribelER_BulletsNumberBase) + "/" + I2S(HarribelER_BulletsNumberBase+HarribelER_BulletsNumberStep) + "/" + I2S(HarribelER_BulletsNumberBase+HarribelER_BulletsNumberStep*2) + "/" + I2S(HarribelER_BulletsNumberBase+HarribelER_BulletsNumberStep*3) + "/" + I2S(HarribelER_BulletsNumberBase+HarribelER_BulletsNumberStep*4) + ">", T_Bonus("Form", "|cffFF0000Release State|r"))
        
        set form = HeroData.create(Harribel_ID, 0, HarribelQ_ID, HarribelW_ID, HarribelE_ID, HarribelR_ID, HarribelT_ID, HarribelG_ID, HarribelE2_ID, HarribelR2_ID, 0, 0)
        set form = HeroData.create(Harribel_ID, 1, HarribelQ_ID, HarribelW_ID, HarribelE_ID, HarribelR_ID, HarribelT_ID, HarribelG_ID, HarribelE2_ID, HarribelR2_ID, 0, 0)
        
        // ===========================================================================
        // ===========================================================================
        // 16. Тсунаеши Савада (Tsuna_ID) -> Ловкость (2)
        // ===========================================================================
        // --- БАЗОВАЯ ФОРМА (Form 0) ---
        call SpellData.create(TsunaQ_ID, 5, 1, 2, TsunaQ_DamageAgiBase, TsunaQ_DamageAgiStep, TsunaQ_DamageStaticBase, TsunaQ_DamageStaticStep, T_Rad(TsunaQ_DamageAoe) + T_Push(TsunaQ_PushRange), T_Bonus("W Buff", "Adds " + FormatInt(TsunaWQ_AddRange) + " Range") + T_Bonus("G Buff", "Transforms into Hyper Burning Axle")).setDecor(T_Decor(TsunaQ_DecorDamage))
        call SpellData.create(TsunaW_ID, 5, 2, 2, TsunaW_DamageAgiBase, TsunaW_DamageAgiStep, TsunaW_Damage2StaticBase, TsunaW_Damage2StaticStep, T_Dur("Stance Duration", TsunaW_BuffDuration) + T_Root(TsunaW_Root), T_Bonus("Stance Effect", "Replaces with an offensive strike (W2)|nAttacks deal bonus damage and root"))
        call SpellData.create(TsunaW2_ID, 5, 2, 2, TsunaW2_DamageAgiBase, TsunaW2_DamageAgiStep, TsunaW2_Damage2StaticBase, TsunaW2_Damage2StaticStep, T_RadExp(TsunaW_DamageAoe, TsunaW_DamageAoe + TsunaW_DamageAoeAdd * 5) + T_Root(TsunaW2_Root), "").setDecor(T_Decor(TsunaW2_DecorDamage))
        call SpellData.createSimple(TsunaE_ID, 5, 2, 2, TsunaE_DamageAgiBase, TsunaE_DamageAgiStep, T_RadExp(TsunaE_DamageAoe, TsunaE_DamageAoeFinal) + T_Cast(TsunaE_CastTime), "").setDecor(T_DecorExp(TsunaE_DecorDamage, TsunaE_ExplosionDecorDamage))
        call SpellData.createSimple(TsunaR_ID, 5, 2, 2, TsunaR_DamageAgiBase, TsunaR_DamageAgiStep, T_DurationInvul(TsunaR_Duration) + T_Slow(I2R(TsunaR_Slow), I2R(TsunaR_SlowDuration)) + T_Prop("Strikes", I2R(TsunaR_Ticks)), "")
        call SpellData.createSimple(TsunaT_ID, 1, 2, 2, TsunaT_DamageAgiBase, 0.0, T_Rad(TsunaT_DamageAoe) + T_Cast(TsunaT_ChargeTimeFull) + T_DurationInvul(TsunaT_Duration) + T_Slow(I2R(TsunaT_Slow), I2R(TsunaT_SlowDuration)) + T_Prop("Strikes", I2R(TsunaT_Ticks)), T_Bonus("Lv. 35", "Overcharge after " + FormatReal(TsunaT_OverchargeTime) + " sec (" + FormatInt(TsunaT_OverchargeDmgPct) + "% Dmg)")).setDecor(T_Decor(TsunaT_DecorDamage))
        call SpellData.createUtility(TsunaF_ID, 1, T_Rad(TsunaF_Aoe) + "Dodge Chance: <L:" + FormatReal(TsunaF_Chance12) + "/" + FormatReal(TsunaF_Chance12) + "/" + FormatReal(TsunaF_Chance12) + "/" + FormatReal(TsunaF_Chance25) + "/" + FormatReal(TsunaF_Chance35) + ">%|nHit Bonus: +" + FormatReal(TsunaF_SkillSuccessfulAtkBonusAdd) + "% for " + FormatReal(TsunaF_StackDuration) + " sec|n" + T_Dur("Cooldown", TsunaF_CD12), T_Bonus("Lv. 25", FormatReal(TsunaF_Chance25) + "% Dodge, CD " + FormatReal(TsunaF_CD25) + "s") + T_Bonus("Lv. 35", FormatReal(TsunaF_Chance35) + "% Dodge, CD " + FormatReal(TsunaF_CD35) + "s"))
        call SpellData.createUtility(TsunaG_ID, 1, T_Duration(TsunaG_Duration) + "Converts " + FormatReal(TsunaG_DamagetoMana) + "% damage to MP|n" + T_Dur("Stats Duration", TsunaG_StatsRemoveSec), T_Bonus("Absorption", FormatInt(TsunaG_DamagetoStats1) + "/" + FormatInt(TsunaG_DamagetoStats2) + "/" + FormatInt(TsunaG_DamagetoStats3) + " damage unlocks stats") + T_Bonus("Lv. 35", "Max absorption unlocks Vongola Gear"))
        // --- ФОРМА VONGOLA GEAR (Form 1) ---
        call SpellData.createAlt(TsunaQ2_ID, 1, 5, 1, 2, TsunaQ2_DamageAgiBase, TsunaQ2_DamageAgiStep, TsunaQ2_DamageStaticBase, TsunaQ2_DamageStaticStep, T_RadExp(TsunaQ2_DamageAoe, TsunaQ2_ExplosionAoeFinal) + T_Invul(0.45) + T_Push(TsunaQ2_PushRange), T_Bonus("Form", "|cffFF6600Vongola Gear|r")).setSecondDamage(2, "Mag. Damage (Explosion):", 2, TsunaQ2_ExplosionAgiBase, 0.0, 0.0, 0.0).setDecor(T_DecorFlight(TsunaQ2_DecorDamage, TsunaQ2_MissileDecorDamage, TsunaQ2_ExplosionDecorDamage))
        call SpellData.createAlt(TsunaW3_ID, 1, 5, 2, 2, TsunaW3_DamageAgiBase, 0.0, 0.0, 0.0, T_RadExp(TsunaW3_DamageAoe, TsunaW3_DamageAoeFinal) + T_Cast(TsunaW3_CastTime), T_Bonus("Form", "|cffFF6600Vongola Gear|r")).setDecor(T_DecorExp(TsunaW3_DecorDamage, TsunaW3_ExplosionDecorDamage))
        call SpellData.createAlt(TsunaE2_ID, 1, 5, 2, 2, TsunaE2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(TsunaE2_DamageAoe) + T_Cast(TsunaE2_CastTime) + T_Stun(TsunaE2_StunDuration), T_Bonus("Form", "|cffFF6600Vongola Gear|r")).setDecor(T_Decor(TsunaE2_DecorDamage))
        call SpellData.createAlt(TsunaR2_ID, 1, 5, 2, 2, TsunaR2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(TsunaR2_Aoe) + T_DurationInvul(TsunaR2_Duration) + T_Slow(I2R(TsunaR2_Slow), I2R(TsunaR2_SlowDuration)) + T_Push(TsunaR2_PullRange) + T_Prop("Strikes", I2R(TsunaR2_Ticks)), T_Bonus("Form", "|cffFF6600Vongola Gear|r"))
        call SpellData.createAlt(TsunaT3_ID, 1, 1, 2, 2, TsunaT2_DamageAgiBase, 0.0, 0.0, 0.0, T_Rad(TsunaT2_DamageAoe) + T_CastInvul(1.5) + T_DurationInvul(1.8) + T_Silence(TsunaT2_SilenceDuration) + T_Slow(I2R(TsunaT2_Slow), I2R(TsunaT2_SlowDuration)) + T_Prop("Strikes", 13), T_Bonus("Form", "|cffFF6600Vongola Gear|r")).setDecor(T_Decor(100.0))
        call SpellData.createUtility(TsunaG2_ID, 1, T_Duration(TsunaG2_Duration) + T_CastInvul(TsunaG2_CastTime) + "Reduces ongoing CDs by " + FormatReal(TsunaG2_ReduceCD) + " sec", T_Bonus("Form", "|cffFF6600Vongola Gear|r")).setDecor(T_DecorAoe(TsunaG2_TransformDecorDamage, TsunaG2_TransformDecorAoe))
        call SpellData.createUtility(TsunaG3_ID, 1, T_Rad(TsunaG3_DamageAoe) + T_Duration(TsunaG3_Duration) + T_Stun(TsunaG3_StunDuration) + "Ending barrier explodes and stuns nearby enemies", T_Bonus("Form", "|cffFF6600Vongola Gear|r")).setDecor(T_Decor(TsunaG3_DecorDamage))
        // Регистрация обеих форм
        set form = HeroData.create(Tsuna_ID, 0, TsunaQ_ID, TsunaW_ID, TsunaW2_ID, TsunaE_ID, TsunaR_ID, TsunaT_ID, TsunaF_ID, TsunaG_ID, TsunaG2_ID, 0)
        set form = HeroData.create(Tsuna_ID, 1, TsunaQ2_ID, TsunaW3_ID, TsunaE2_ID, TsunaR2_ID, TsunaT3_ID, TsunaF_ID, TsunaG3_ID, 0, 0, 0)
        set form = HeroData.create(Tsuna2_ID, 1, TsunaQ2_ID, TsunaW3_ID, TsunaE2_ID, TsunaR2_ID, TsunaT3_ID, TsunaF_ID, TsunaG3_ID, 0, 0, 0)
        
        call DestroyTimer(t)
    endfunction
    
    private function InitHeroes_Part3 takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local HeroData form
        
        // ===================================
        // 17. Римуру Темпест (Rimuru_ID) -> Интеллект (3)
        // ===================================
        call SpellData.create(RimuruQ_ID, 5, 1, 3, RimuruQ_DamageIntBase, RimuruQ_DamageIntStep, RimuruQ_Damage2StaticBase, RimuruQ_Damage2StaticStep, T_Rad(RimuruQ_DamageAoe), "")
        call SpellData.create(RimuruW_ID, 5, 1, 3, RimuruW_DamageIntBase, RimuruW_DamageIntStep, RimuruW_Damage2StaticBase, RimuruW_Damage2StaticStep, T_Root(RimiruW_Root), "")
        call SpellData.createSimple(RimuruE_ID, 5, 2, 3, RimuruE_DamageIntBase, RimuruE_DamageIntStep, T_Rad(RimuruE_DamageAoe) + "(Expands by " + I2S(R2I(RimuruE_DamageAoeAdd)) + ")|n" + T_Slow(RimuruE_SlowPercent, RimuruE_SlowTime), "")
        call SpellData.createSimple(RimuruR_ID, 5, 1, 3, RimuruR_DamageIntBase, RimuruR_DamageIntStep, "Single Target Damage", "")
        call SpellData.createSimple(RimuruT_ID, 1, 2, 3, RimuruT_DamageIntBase, 0.0, T_Rad(RimuruT_DamageAoe), "")
        call SpellData.createUtility(RimuruF_ID, 1, T_Dur("Cooldown", RimuruF_CD), "")
        call SpellData.createUtility(RimuruG_ID, 1, "Passive|nTaking damage drops restorative orbs", T_Bonus("Absorbing", I2S(RimuruEvol1_MagiculeDmg) + " damage unlocks Demon Lord Evolution"))
        
        call SpellData.createSimple(RimuruQ2_ID, 5, 2, 3, RimuruQ2_DamageIntBase, RimuruQ2_DamageIntStep, "Dodges next " + I2S(RimuruQ2_NumberofDodges) + " attacks|nHeal Reduction: " + FormatReal(RimuruQ2_DebuffHealReduce) + "% for " + FormatReal(RimuruQ2_DurationDebuff) + " sec", T_Bonus("Mag. Burn", "|cffccccccIntelligence x <L:" + FormatReal(RimuruQ2_DamageIntBurnBase) + "/" + FormatReal(RimuruQ2_DamageIntBurnBase+RimuruQ2_DamageIntBurnStep) + "/" + FormatReal(RimuruQ2_DamageIntBurnBase+RimuruQ2_DamageIntBurnStep*2) + "/" + FormatReal(RimuruQ2_DamageIntBurnBase+RimuruQ2_DamageIntBurnStep*3) + "/" + FormatReal(RimuruQ2_DamageIntBurnBase+RimuruQ2_DamageIntBurnStep*4) + "> (<V1>)|r")).setBonusMults(RimuruQ2_DamageIntBurnBase, RimuruQ2_DamageIntBurnStep)
        call SpellData.create(RimuruW2_ID, 5, 1, 3, RimuruW2_DamageIntBase, RimuruW2_DamageIntStep, RimuruW2_Damage2StaticBase, RimuruW2_Damage2StaticStep, T_Rad(RimiruW2_Aoe) + T_Root(RimiruW2_Root), "")
        call SpellData.createSimple(RimuruE2_ID, 5, 2, 3, RimuruE2_DamageIntBase, RimuruE2_DamageIntStep, T_Rad(RimuruE2_DamageAoe) + T_Stun(RimuruE2_Stun), "")
        call SpellData.createSimple(RimuruR2_ID, 5, 2, 3, RimuruR2_DamageIntBase, RimuruR2_DamageIntStep, T_Rad(RimuruR2_DamageAoe) + T_Slow(RimuruR2_Slow, RimuruR2_SlowDuration), "")
        call SpellData.createSimple(RimuruT2_ID, 1, 2, 3, RimuruT2_DamageIntBase, 0.0, T_Prop("Explosion Radius", RimuruT2_DamageAoe) + T_Root(RimuruT2_Root) + T_Slow(RimuruT2_SlowPercent, RimuruT2_SlowTime), "")
        call SpellData.createSimple(RimuruF2_ID, 1, 2, 3, RimuruF2_DamageIntBase, 0.0, T_Rad(RimiruF2_Aoe) + T_Push(RimiruF2_PushRange), "")
        call SpellData.createUtility(RimuruG2_ID, 1, "Passive Evolution", T_Bonus("Gathering", I2S(RimuruEvol2_Counter) + " souls unlocks True Dragon Evolution"))
        
        call SpellData.createSimple(RimuruQ3_ID, 5, 1, 3, RimuruQ3_DamageIntBase, 0.0, "Teleports to target and strikes", T_Bonus("Mag. Burn", "|cffccccccIntelligence x " + FormatReal(RimuruQ3_DamageIntBurnBase) + " (<V1>)|r")).setBonusMults(RimuruQ3_DamageIntBurnBase, 0.0)
        call SpellData.createUtility(RimuruW3_ID, 5, T_Rad(RimiruW3_Aoe) + T_Dur("Duration", RimiruW3_Duration) + "Draws enemies into the center", "")
        call SpellData.createSimple(RimuruE3_ID, 5, 2, 3, RimuruE5_DamageIntBase, 0.0, T_Rad(RimuruE5_DamageAoe) + T_Stun(RimuruE5_Stun), "Replaced by Ifrite Flame Attack after cast")
        call SpellData.createSimple(RimuruE4_ID, 5, 2, 3, RimuruE4_DamageIntBase, 0.0, T_Rad(RimuruE4_DamageAoe), "Replaced by Ultimate Skill Veldora after cast")
        call SpellData.createSimple(RimuruE5_ID, 5, 2, 3, RimuruE3_DamageIntBase, 0.0, T_Rad(RimuruE3_DamageAoe) + T_Slow(RimuruE3_SlowPercent, RimuruE3_SlowTime), "Replaced by Black Flame Erruption after cast")
        call SpellData.createSimple(RimuruR3_ID, 5, 2, 3, RimuruR3_DamageIntBase, 0.0, T_Rad(RimuruR3_DamageAoe), "")
        call SpellData.createSimple(RimuruT3_ID, 1, 2, 3, RimuruT3_DamageIntBase, 0.0, T_Rad(RimuruT3_DamageAoe) + "Duration: 6.5 sec|nTicks: 4", "")
        call SpellData.createUtility(RimuruF3_ID, 1, "Dodges next " + I2S(RimuruQ2_NumberofDodges) + " attacks|nReduces Q Cooldown by " + FormatReal(RimiruF3_ReduceQCdTime) + " sec per dodge", "")
        call SpellData.createUtility(RimuruG3_ID, 1, T_Dur("Buff Duration", RimuruG3_BonusDuration), "")
        
        set form = HeroData.create(Rimuru_ID, 0, RimuruQ_ID, RimuruW_ID, RimuruE_ID, RimuruR_ID, RimuruT_ID, RimuruF_ID, RimuruG_ID, RimuruQ2_ID, RimuruW2_ID, RimuruE2_ID)
        call form.addExtra(RimuruR2_ID, RimuruT2_ID, RimuruF2_ID, RimuruG2_ID, RimuruQ3_ID, RimuruW3_ID, RimuruE3_ID, RimuruE4_ID, RimuruE5_ID, RimuruR3_ID)
        call form.addExtra(RimuruT3_ID, RimuruF3_ID, RimuruG3_ID, 0, 0, 0, 0, 0, 0, 0)
        
        // ===================================
        // 18. Дарк Шики / Рёги (DarkShiki_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(DarkShikiQ_ID, 5, 1, 2, DarkShikiQ_DamageAgiBase, DarkShikiQ_DamageAgiStep, DarkShikiQ_Damage2StaticBase, DarkShikiQ_Damage2StaticStep, T_Rad(DarkShikiQ_DamageAoe), T_Bonus("Unlocks Q2", "Return to cast position (<L:" + FormatReal(DarkShikiQ_BackToPosDurationBase) + "/" + FormatReal(DarkShikiQ_BackToPosDurationBase+DarkShikiQ_BackToPosDurationStep) + "/" + FormatReal(DarkShikiQ_BackToPosDurationBase+DarkShikiQ_BackToPosDurationStep*2) + "/" + FormatReal(DarkShikiQ_BackToPosDurationBase+DarkShikiQ_BackToPosDurationStep*3) + "/" + FormatReal(DarkShikiQ_BackToPosDurationBase+DarkShikiQ_BackToPosDurationStep*4) + "> sec window)"))
        call SpellData.create(DarkShikiW_ID, 5, 1, 2, DarkShikiW_DamageAgiBase, DarkShikiW_DamageAgiStep, DarkShikiW_Damage2StaticBase, DarkShikiW_Damage2StaticStep, "", "")
        call SpellData.createSimple(DarkShikiE_ID, 5, 1, 2, DarkShikiE_DamageAgiBase, DarkShikiE_DamageAgiStep, T_Stun(DarkShikiE_Stun), "")
        call SpellData.createSimple(DarkShikiR_ID, 5, 1, 2, DarkShikiR_DamageAgiBase, DarkShikiR_DamageAgiStep, T_Rad(DarkShikiR_DamageAoe), "")
        call SpellData.createSimple(DarkShikiT_ID, 1, 1, 2, DarkShikiT_DamageAgiBase, 0.0, "", "")
        call SpellData.createSimple(DarkShikiG_ID, 1, 1, 2, DarkShikiG_DamageAgiBase, 0.0, T_Rad(DarkShikiG_DamageAoe), "")
        call SpellData.createUtility(DarkShikiF_ID, 1, "Passive|nAbilities mark the target for " + FormatReal(DarkShikiG_Time) + " sec.|nMarks deal Agility x " + FormatReal(DarkShikiG_Damage) + " damage over time.|nAt 4 stacks, deals Agility x " + FormatReal(DarkShikiG_StackFinalDamage) + " and silences for " + FormatReal(DarkShikiG_StackFinalSilenceDuration) + " sec.", T_Bonus("Lv. 35", "+" + FormatReal(DarkShikiG_Time35BonusAdd) + " sec duration, +" + FormatReal(DarkShikiG_Damage35BonusAdd) + "x Agi DoT, +" + FormatReal(DarkShikiG_StackFinalDamage35BonusAdd) + "x Agi Final Dmg"))
        call SpellData.createUtility(DarkShikiQ2_ID, 5, "Returns to the initial cast position", "")
        
        set form = HeroData.create(DarkShiki_ID, 0, DarkShikiQ_ID, DarkShikiW_ID, DarkShikiE_ID, DarkShikiR_ID, DarkShikiT_ID, DarkShikiF_ID, DarkShikiG_ID, DarkShikiQ2_ID, 0, 0)
        
        // ===========================================================================
        // 19. Базз-Би (BazzB_ID) -> Ловкость (2)
        // ===========================================================================
        // --- БАЗОВЫЕ СПОСОБНОСТИ ---
        call SpellData.create(BazzBQ_ID, 5, 2, 2, BazzBQ_DamageAgiBase, BazzBQ_DamageAgiStep, BazzBQ_Damage2StaticBase, BazzBQ_Damage2StaticStep, T_Rad(BazzBQ_DamageAoe) + T_CastAuto(BazzBQ_CastTime, BazzBQ_IsInvul), "").setDecor(T_Decor(BazzBQ_DecorDamage))
        call SpellData.create(BazzBW_ID, 5, 2, 2, BazzBW_DamageAgiBase, BazzBW_DamageAgiStep, BazzBW_Damage2StaticBase, BazzBW_Damage2StaticStep, T_Rad(BazzBW_DamageAoe) + T_CastAuto(BazzBW_CastTime, BazzBW_IsInvul), "").setDecor(T_Decor(BazzBW_DecorDamage))
        call SpellData.createSimple(BazzBE_ID, 5, 2, 2, BazzBE_DamageAgiBase, BazzBE_DamageAgiStep, T_Rad(BazzBE_DamageAoe) + T_Push(BazzBE_PushRange) + T_CastAuto(BazzBE_CastTime, BazzBE_IsInvul), T_Bonus("Burner Finger 3", "Dispels all debuffs upon explosion")).setDecor(T_Decor(BazzBE_DecorDamage))
        call SpellData.createSimple(BazzBR_ID, 5, 2, 2, BazzBR_DamageAgiBase, BazzBR_DamageAgiStep, T_Rad(BazzBR_DamageAoe) + T_Stun(BazzBR_StunDuration) + T_CastAuto(BazzBR_CastTime, BazzBR_IsInvul), "").setDecor(T_Decor(BazzBR_DecorDamage))
        call SpellData.createSimple(BazzBT_ID, 1, 2, 2, BazzBT_DamageAgiBase, 0.0, T_Rad(BazzBT_DamageAoe) + T_Push(BazzBT_Push) + T_CastAuto(BazzBT_CastTime, BazzBT_IsInvul) + T_DurAuto(BazzBT_Duration, BazzBT_IsInvul), "").setDecor(T_Decor(BazzBT_DecorDamage))
        call SpellData.createUtility(BazzBG_ID, 1, "", T_Bonus("The Heat", "Casting abilities reduces all cooldowns by " + FormatReal(BazzBG_CdReduce1) + "/" + FormatReal(BazzBG_CdReduce2) + "/" + FormatReal(BazzBG_CdReduce3) + " sec (Lv. 12/25/35)"))
        // --- РЕГИСТРАЦИЯ НАБОРА СПОСОБНОСТЕЙ ГЕРОЯ ---
        set form = HeroData.create(BazzB_ID, 0, BazzBQ_ID, BazzBW_ID, BazzBE_ID, BazzBR_ID, BazzBT_ID, BazzBG_ID, 0, 0, 0, 0)
        
        // ===========================================================================
        // 20. Невиллет (Neuvillette_ID) -> Интеллект (3)
        // ===========================================================================
        // --- БАЗОВЫЕ СПОСОБНОСТИ ---
        call SpellData.create(NeuvilletteQ_ID, 5, 2, 3, NeuvilletteQ_DamageIntBase, NeuvilletteQ_DamageIntStep, NeuvilletteQ_DamageStaticBase, NeuvilletteQ_DamageStaticStep, T_Rad(NeuvilletteQ_DamageAoe) + T_CastAuto(NeuvilletteQ_CastTime, NeuvilletteQ_IsInvul), T_Bonus("Lv. 35", "Applies Water debuff")).setDecor(T_Decor(NeuvilletteQ_DecorDamage))
        call SpellData.create(NeuvilletteW_ID, 5, 1, 3, NeuvilletteW_DamageIntBase, NeuvilletteW_DamageIntStep, NeuvilletteW_Damage2StaticBase, NeuvilletteW_Damage2StaticStep, T_Rad(NeuvilletteW_DamageAoe) + T_CastAuto(NeuvilletteW_CastTime, NeuvilletteW_IsInvul), "").setDecor(T_Decor(NeuvilletteW_DecorDamage))
        call SpellData.createSimple(NeuvilletteE_ID, 5, 2, 3, NeuvilletteE_DamageIntBase, NeuvilletteE_DamageIntStep, T_PropS("Radius", "<L:" + FormatInt(NeuvilletteE_DamageAoeBase) + "/" + FormatInt(NeuvilletteE_DamageAoeBase+NeuvilletteE_DamageAoeStep) + "/" + FormatInt(NeuvilletteE_DamageAoeBase+NeuvilletteE_DamageAoeStep*2) + "/" + FormatInt(NeuvilletteE_DamageAoeBase+NeuvilletteE_DamageAoeStep*3) + "/" + FormatInt(NeuvilletteE_DamageAoeBase+NeuvilletteE_DamageAoeStep*4) + ">") + T_DurAuto(NeuvilletteE_Duration, NeuvilletteE_IsInvul) + T_Dur("Damage Interval", NeuvilletteE_DamageInterval) + T_PropS("Slow", "<L:" + FormatInt(NeuvilletteE_SlowBase) + "/" + FormatInt(NeuvilletteE_SlowBase+NeuvilletteE_SlowAdd) + "/" + FormatInt(NeuvilletteE_SlowBase+NeuvilletteE_SlowAdd*2) + "/" + FormatInt(NeuvilletteE_SlowBase+NeuvilletteE_SlowAdd*3) + "/" + FormatInt(NeuvilletteE_SlowBase+NeuvilletteE_SlowAdd*4) + ">% for " + FormatInt(NeuvilletteE_SlowDuration) + " sec") + T_Element(2), "").setDecor(T_Decor(NeuvilletteE_DecorDamage))
        call SpellData.createSimple(NeuvilletteR_ID, 5, 2, 3, NeuvilletteR_DamageIntBase, NeuvilletteR_DamageIntStep, T_Rad(NeuvilletteR_DamageAoe) + T_CastAuto(NeuvilletteR_CastTime, NeuvilletteR_IsInvul) + T_DurAuto(NeuvilletteR_Duration, NeuvilletteR_IsInvul) + T_Dur("Damage Interval", NeuvilletteR_DamageInterval) + T_Push(NeuvilletteR_PushRange), T_Bonus("Lv. 35", "Applies Water debuff")).setDecor(T_Decor(NeuvilletteR_DecorDamage))
        call SpellData.createSimple(NeuvilletteT_ID, 1, 2, 3, NeuvilletteT_DamageIntBase, 0.0, T_Prop("Pillars", NeuvilletteT_PillarsCount) + T_Prop("Pillar Radius", NeuvilletteT_DamageAoePillar) + T_Prop("Search Area", NeuvilletteT_DamageAoe) + T_DurAuto(NeuvilletteT_Duration, NeuvilletteT_IsInvul) + T_Slow(NeuvilletteT_Slow, NeuvilletteT_Duration) + T_PropS("R CD Reduction", FormatInt(NeuvilletteT_ReduceRCd_Sec) + " sec") + T_Element(2), "").setDecor(T_Decor(NeuvilletteT_DecorDamage))
        call SpellData.createUtility(NeuvilletteF_ID, 1, "Damage Increase: +" + FormatInt(NeuvilletteF_DamageAdd) + "%", T_Bonus("Lv. 35 Grade", "+" + FormatInt(NeuvilletteF_DamageAdd35) + "% Damage (Total " + FormatInt(NeuvilletteF_DamageAdd + NeuvilletteF_DamageAdd35) + "%)"))
        // --- РЕГИСТРАЦИЯ НАБОРА СПОСОБНОСТЕЙ ГЕРОЯ ---
        set form = HeroData.create(Neuvillette_ID, 0, NeuvilletteQ_ID, NeuvilletteW_ID, NeuvilletteE_ID, NeuvilletteR_ID, NeuvilletteT_ID, NeuvilletteF_ID, 0, 0, 0, 0)
        
        // ===================================
        // 22. Окарун (Okarun_ID) -> Интеллект (3)
        // ===================================
        call SpellData.create(OkarunQ_ID, 5, 1, 3, OkarunQ_DamageIntBase, OkarunQ_DamageIntStep, OkarunQ_Damage2StaticBase, OkarunQ_Damage2StaticStep, T_RadExp(OkarunQ_DamageAoe, OkarunQ_DamageAoeFinal) + T_Push(OkarunQ_PushRange), "Damage increased by <L:" + I2S(R2I(OkarunQ_DamageSpeedBonusBase)) + "/" + I2S(R2I(OkarunQ_DamageSpeedBonusBase+OkarunQ_DamageSpeedBonusStep)) + "/" + I2S(R2I(OkarunQ_DamageSpeedBonusBase+OkarunQ_DamageSpeedBonusStep*2)) + "/" + I2S(R2I(OkarunQ_DamageSpeedBonusBase+OkarunQ_DamageSpeedBonusStep*3)) + "/" + I2S(R2I(OkarunQ_DamageSpeedBonusBase+OkarunQ_DamageSpeedBonusStep*4)) + ">% of Current Speed")
        call SpellData.create(OkarunW_ID, 5, 1, 3, OkarunW_DamageIntBase, OkarunW_DamageIntStep, OkarunW_Damage2StaticBase, OkarunW_Damage2StaticStep, T_Stun(OkarunW_Stun) + T_Push(OkarunW_PushRange), "")
        call SpellData.createSimple(OkarunE_ID, 5, 2, 3, OkarunE_DamageIntBase, OkarunE_DamageIntStep, T_Push(OkarunE_PushRange), "Damage increased by " + I2S(R2I(OkarunE_DamageSpeedBonus)) + "% of Current Speed")
        call SpellData.createSimple(OkarunR_ID, 5, 1, 3, OkarunR_DamageIntBase, OkarunR_DamageIntStep, T_Prop("Dash Range", OkarunR_Range) + "Throws target " + I2S(R2I(OkarunR_PushFly)) + " units in the air and knocks back " + I2S(R2I(OkarunR_PushRange)) + " units|n" + T_Stun(OkarunR_StunFinal), "Damage increased by <L:" + I2S(R2I(OkarunR_DamageSpeedBonusBase)) + "/" + I2S(R2I(OkarunR_DamageSpeedBonusBase+OkarunR_DamageSpeedBonusStep)) + "/" + I2S(R2I(OkarunR_DamageSpeedBonusBase+OkarunR_DamageSpeedBonusStep*2)) + "/" + I2S(R2I(OkarunR_DamageSpeedBonusBase+OkarunR_DamageSpeedBonusStep*3)) + "/" + I2S(R2I(OkarunR_DamageSpeedBonusBase+OkarunR_DamageSpeedBonusStep*4)) + ">% of Current Speed")
        call SpellData.createSimple(OkarunT_ID, 1, 1, 3, OkarunT_DamageIntBase, 0.0, T_Rad(OkarunT_DamageAoe) + T_Slow(OkarunT_Slow, OkarunT_SlowDuration) + "Self Speed Multiplier: x" + FormatReal(OkarunT_bonusspeed) + " for " + FormatReal(OkarunT_Buff_Duration) + " sec", "")
        call SpellData.createUtility(OkarunF_ID, 1, "Passive|nGradually increases Movement Speed up to a cap while running continuously|nSpeed Cap: 600/700/800/900/1000 (Lv. 1/12/18/25/35)|nAccelerates by " + FormatReal(OkarunF_AddSpeedPercentPerSec) + "% per sec|nDecelerates by " + FormatReal(OkarunF_DecreaseSpeedPercentPerSec) + "% per tick when stopped", "")
        
        set form = HeroData.create(Okarun_ID, 0, OkarunQ_ID, OkarunW_ID, OkarunE_ID, OkarunR_ID, OkarunT_ID, OkarunF_ID, 0, 0, 0, 0)
        
        // ===================================
        // 23. Инори (Inori_ID) -> Интеллект (3)
        // ===================================
        call SpellData.create(InoriQ_ID, 5, 2, 3, InoriQ_DamageIntBase, InoriQ_DamageIntStep, InoriQ_Damage2StaticBase, InoriQ_Damage2StaticStep, T_Rad(InoriQ_DamageAoe) + "Range: <L:" + I2S(R2I(InoriQ_Range)) + "/" + I2S(R2I(InoriQ_Range+InoriQ_RangeADD)) + "/" + I2S(R2I(InoriQ_Range+InoriQ_RangeADD*2)) + "/" + I2S(R2I(InoriQ_Range+InoriQ_RangeADD*3)) + "/" + I2S(R2I(InoriQ_Range+InoriQ_RangeADD*4)) + "> + Intelligence x 2", "")
        call SpellData.create(InoriW_ID, 5, 2, 3, InoriW_DamageIntBase, InoriW_DamageIntStep, InoriW_DamageStaticBase, InoriW_DamageStaticStep, "Enemy Target: Stuns for " + FormatReal(InoriW_Stun) + " sec|nAlly Target: Heals for Intelligence x <L:" + FormatReal(InoriW_HealBaseInt) + "/" + FormatReal(InoriW_HealBaseInt+InoriW_HealStepInt) + "/" + FormatReal(InoriW_HealBaseInt+InoriW_HealStepInt*2) + "/" + FormatReal(InoriW_HealBaseInt+InoriW_HealStepInt*3) + "/" + FormatReal(InoriW_HealBaseInt+InoriW_HealStepInt*4) + "> + 150 over 7.5 sec|nCooldown starts after healing ends", "")
        call SpellData.createUtility(InoriE_ID, 5, "Passive: Gains a stack when allies within " + I2S(R2I(InoriE_AoeSearch)) + " range take damage|nActive: Consumes stacks to upgrade basic abilities and gain HP Regeneration for " + FormatReal(InoriE_Duration) + " sec", "")
        call SpellData.createUtility(InoriR_ID, 5, T_Rad(InoriR_HealAoe) + "Heals allies in the area over time for Intelligence x <L:" + FormatReal(InoriR_HealIntBase) + "/" + FormatReal(InoriR_HealIntBase+InoriR_HealIntStep) + "/" + FormatReal(InoriR_HealIntBase+InoriR_HealIntStep*2) + "/" + FormatReal(InoriR_HealIntBase+InoriR_HealIntStep*3) + "/" + FormatReal(InoriR_HealIntBase+InoriR_HealIntStep*4) + "> + <L:" + FormatReal(InoriR_HealStaticBase) + "/" + FormatReal(InoriR_HealStaticBase+InoriR_HealStaticStep) + "/" + FormatReal(InoriR_HealStaticBase+InoriR_HealStaticStep*2) + "/" + FormatReal(InoriR_HealStaticBase+InoriR_HealStaticStep*3) + "/" + FormatReal(InoriR_HealStaticBase+InoriR_HealStaticStep*4) + "> per sec|nCooldown starts after healing ends", T_Bonus("Lv. 35", "+" + I2S(R2I(InoriR_HealAoeAdd)) + " Radius and +12 sec Duration. Casting abilities clears debuffs from allies in the radius"))
        call SpellData.createSimple(InoriT_ID, 1, 2, 3, InoriT_DamageIntBase, 0.0, T_Rad(InoriT_DamageAoe) + "(Max " + I2S(R2I(InoriT_DamageMaxAoe)) + ")|n" + T_Root(InoriT_RootTime) + "Transforms to upgrade basic abilities", "")
        call SpellData.createUtility(InoriF_ID, 1, "Dashes forward " + I2S(R2I(InoriF_PushRange)) + " units|nReduces Q Cooldown by 4 sec", "")
        call SpellData.createUtility(InoriG_ID, 1, "Ultimate Ability Selection Menu", "")
        call SpellData.createSimple(InoriT2_ID, 1, 2, 3, InoriT2_DamageIntBase, 0.0, T_Prop("Beam Radius", InoriT2_DamageAoeBeam) + T_Dur("Duration", InoriT2_Duration), "")
        
        call SpellData.create(InoriQ2_ID, 5, 2, 3, InoriEQ_DamageIntBase, InoriEQ_DamageIntStep, InoriEQ_Damage2StaticBase, InoriEQ_Damage2StaticStep, T_Rad(InoriEQ_DamageAoe) + T_Stun(InoriEQ_Stun), "")
        call SpellData.create(InoriW2_ID, 5, 2, 3, InoriEW_DamageIntBase, InoriEW_DamageIntStep, InoriEW_DamageStaticBase, InoriEW_DamageStaticStep, T_Stun(InoriEW_Stun), "")
        call SpellData.createSimple(InoriER_ID, 5, 2, 3, InoriER_DamageIntBase, InoriER_DamageIntStep, T_Rad(InoriER_DamageAoe), "")
        call SpellData.create(InoriQ3_ID, 5, 2, 3, InoriTQ_DamageIntBase, InoriTQ_DamageIntStep, InoriTQ_Damage2StaticBase, InoriTQ_Damage2StaticStep, T_Rad(InoriTQ_DamageAoe) + T_Stun(InoriTQ_Stun), "")
        call SpellData.create(InoriW3_ID, 5, 2, 3, InoriTW_DamageIntBase, InoriTW_DamageIntStep, InoriTW_DamageStaticBase, InoriTW_DamageStaticStep, T_Rad(InoriTW_DamageAoe) + T_Stun(InoriTW_Stun), "")
        call SpellData.createSimple(InoriR2_ID, 5, 2, 3, InoriR2_DamageIntBase, InoriR2_DamageIntStep, T_Rad(InoriR2_DamageAoe) + "(Grows by " + I2S(R2I(InoriR2_DamageAoeAdd)) + ")|n" + T_Stun(InoriR2_Stun), "")
        
        set form = HeroData.create(Inori_ID, 0, InoriQ_ID, InoriW_ID, InoriE_ID, InoriR_ID, InoriT_ID, InoriF_ID, InoriG_ID, InoriT2_ID, InoriQ2_ID, InoriW2_ID)
        call form.addExtra(InoriER_ID, InoriQ3_ID, InoriW3_ID, InoriR2_ID, 0, 0, 0, 0, 0, 0)
        
        // ===================================
        // 24. Кендзяку (Kenjaku_ID) -> Интеллект (3)
        // ===================================
        call SpellData.createUtility(KenjakuQ_ID, 5, "Heal: Intelligence x <L:" + FormatReal(KenjakuQ_HealIntBase) + "/" + FormatReal(KenjakuQ_HealIntBase+KenjakuQ_HealIntStep) + "/" + FormatReal(KenjakuQ_HealIntBase+KenjakuQ_HealIntStep*2) + "/" + FormatReal(KenjakuQ_HealIntBase+KenjakuQ_HealIntStep*3) + "/" + FormatReal(KenjakuQ_HealIntBase+KenjakuQ_HealIntStep*4) + "> + " + FormatReal(KenjakuQ_HealStaticBase) + " over " + FormatReal(KenjakuQ_Duration) + " sec|nReduces Q3/W3/E3 cooldowns by " + FormatReal(KenjakuQ_ReduceQ3W3E3_CD) + " sec", T_Bonus("Lv. 25", "Heal increased by Intelligence x " + FormatReal(KenjakuQ_HealInt25lvlBonus) + " and reduces cooldowns by additional " + FormatReal(KenjakuQ_Reduce25lvlBonusQ3W3E3_CD) + " sec"))
        call SpellData.create(KenjakuW_ID, 5, 1, 3, KenjakuW_DamageIntBase, KenjakuW_DamageIntStep, KenjakuW_DamageStaticBase, KenjakuW_DamageStaticStep, T_Stun(KenjakuW_StunForPunch), "")
        call SpellData.create(KenjakuE_ID, 5, 2, 3, KenjakuE_DamageIntBase, KenjakuE_DamageIntStep, KenjakuE_Damage2StaticBase, KenjakuE_Damage2StaticStep, T_Rad(KenjakuE_DamageAoe) + T_Slow(KenjakuE_SlowPercent, KenjakuE_SlowTime), "")
        call SpellData.createUtility(KenjakuR_ID, 5, "Summons up to 4 pillars|nPillar Duration: <L:" + FormatReal(KenjakuR_ColumnBase) + "/" + FormatReal(KenjakuR_ColumnBase+KenjakuR_ColumnStep) + "/" + FormatReal(KenjakuR_ColumnBase+KenjakuR_ColumnStep*2) + "/" + FormatReal(KenjakuR_ColumnBase+KenjakuR_ColumnStep*3) + "/" + FormatReal(KenjakuR_ColumnBase+KenjakuR_ColumnStep*4) + "> sec|nBarrier Duration: <L:" + FormatReal(KenjakuR_BarrierBase) + "/" + FormatReal(KenjakuR_BarrierBase+KenjakuR_BarrierStep) + "/" + FormatReal(KenjakuR_BarrierBase+KenjakuR_BarrierStep*2) + "/" + FormatReal(KenjakuR_BarrierBase+KenjakuR_BarrierStep*3) + "/" + FormatReal(KenjakuR_BarrierBase+KenjakuR_BarrierStep*4) + "> sec|nCooldown starts after ability ends", "")
        call SpellData.createSimple(KenjakuT_ID, 1, 2, 3, KenjakuT_DamageIntBase, 0.0, T_Rad(KenjakuT_DamageAoe) + "Duration: 3.42 sec|n" + T_Slow(KenjakuT_SlowPercent, KenjakuT_SlowTime), "")
        call SpellData.createUtility(KenjakuF_ID, 1, T_Rad(KenjakuF2_Aoe) + "Activation Time: " + FormatReal(KenjakuF2_CastTime) + " sec|nSeal Duration: " + FormatReal(KenjakuF2_SealTime) + " sec", "")
        call SpellData.createUtility(KenjakuF2_ID, 1, "", "")
        call SpellData.createUtility(KenjakuG_ID, 1, "Toggles abilities between Base and Spirit Summons", "")
        
        call SpellData.createUtility(KenjakuQ2_ID, 5, "Summons Spirit|nCost: " + I2S(KenjakuQ2_CostCurse) + " Curse Stacks|nHP: <L:" + I2S(KenjakuQ2_SummonHpBase) + "/" + I2S(KenjakuQ2_SummonHpBase+KenjakuQ2_SummonHpStep) + "/" + I2S(KenjakuQ2_SummonHpBase+KenjakuQ2_SummonHpStep*2) + "/" + I2S(KenjakuQ2_SummonHpBase+KenjakuQ2_SummonHpStep*3) + "/" + I2S(KenjakuQ2_SummonHpBase+KenjakuQ2_SummonHpStep*4) + ">", "")
        call SpellData.createUtility(KenjakuW2_ID, 5, "Summons Spirit|nCost: " + I2S(KenjakuW2_CostCurse) + " Curse Stacks|nHP: <L:" + I2S(KenjakuW2_SummonHpBase) + "/" + I2S(KenjakuW2_SummonHpBase+KenjakuW2_SummonHpStep) + "/" + I2S(KenjakuW2_SummonHpBase+KenjakuW2_SummonHpStep*2) + "/" + I2S(KenjakuW2_SummonHpBase+KenjakuW2_SummonHpStep*3) + "/" + I2S(KenjakuW2_SummonHpBase+KenjakuW2_SummonHpStep*4) + ">", "")
        call SpellData.createUtility(KenjakuE2_ID, 5, "Summons Spirit|nCost: " + I2S(KenjakuE2_CostCurse) + " Curse Stacks|nHP: <L:" + I2S(KenjakuE2_SummonHpBase) + "/" + I2S(KenjakuE2_SummonHpBase+KenjakuE2_SummonHpStep) + "/" + I2S(KenjakuE2_SummonHpBase+KenjakuE2_SummonHpStep*2) + "/" + I2S(KenjakuE2_SummonHpBase+KenjakuE2_SummonHpStep*3) + "/" + I2S(KenjakuE2_SummonHpBase+KenjakuE2_SummonHpStep*4) + ">", "")
        call SpellData.create(KenjakuQ3_ID, 5, 1, 3, KenjakuQ2_DamageIntBase, KenjakuQ2_DamageIntStep, KenjakuQ2_DamageStaticBase, KenjakuQ2_DamageStaticStep, "Spirit Attack|n" + T_Rad(KenjakuQ2_DamageAoe) + T_Slow(KenjakuQ2_SlowPercent, KenjakuQ2_SlowTime), T_Bonus("Lv. 35", "+ Intelligence x " + FormatReal(Kenjaku_35lvlDamageIntCreepSpellAdd) + " Damage"))
        call SpellData.create(KenjakuW3_ID, 5, 2, 3, KenjakuW2_DamageIntBase, KenjakuW2_DamageIntStep, KenjakuW2_DamageStaticBase, KenjakuW2_DamageStaticStep, "Spirit Attack|n" + T_Rad(KenjakuW2_DamageAoe) + T_Stun(KenjakuW2_Stun), T_Bonus("Lv. 35", "+ Intelligence x " + FormatReal(Kenjaku_35lvlDamageIntCreepSpellAdd) + " Damage"))
        call SpellData.create(KenjakuE3_ID, 5, 2, 3, KenjakuE2_DamageIntBase, KenjakuE2_DamageIntStep, KenjakuE2_Damage2StaticBase, KenjakuE2_Damage2StaticStep, "Spirit Attack", T_Bonus("Lv. 35", "+ Intelligence x " + FormatReal(Kenjaku_35lvlDamageIntCreepSpellAdd) + " Damage"))
        call SpellData.createSimple(KenjakuR2_ID, 5, 2, 3, KenjakuR2_DamageIntBase, KenjakuR2_DamageIntStep, T_Rad(KenjakuR2_DamageAoe) + T_Stun(KenjakuR2_Stun), "Damage increased by Intelligence x " + FormatReal(KenjakuR2_DamageIntBonusPerCurse) + " per Curse Stack")
        
        set form = HeroData.create(Kenjaku_ID, 0, KenjakuQ_ID, KenjakuW_ID, KenjakuE_ID, KenjakuR_ID, KenjakuT_ID, KenjakuF_ID, KenjakuG_ID, KenjakuQ2_ID, KenjakuW2_ID, KenjakuE2_ID)
        call form.addExtra(KenjakuF2_ID, KenjakuQ3_ID, KenjakuW3_ID, KenjakuE3_ID, KenjakuR2_ID, 0, 0, 0, 0, 0)
        
        // ===================================
        // 25. Альтер Сейбер (AlterSaber_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(AlterSaberQ_ID, 5, 1, 2, AlterSaberQ_DamageAgiBase, AlterSaberQ_DamageAgiStep, AlterSaberQ_Damage2StaticBase, AlterSaberQ_Damage2StaticStep, T_RadExp(AlterSaberQ_DamageAoe, AlterSaberQ_DamageAoe2) + T_Push(AlterSaberQ_PushRange), T_Bonus("Morph", "+Attack x " + FormatReal(AlterSaberRQ_DamageAttackBonus) + " Bonus Damage"))
        call SpellData.create(AlterSaberW_ID, 5, 1, 2, AlterSaberComboW_DamageAgiBase, AlterSaberComboW_DamageAgiStep, 100.0, 0.0, T_Stun(AlterSaberComboW_Stun), "")
        call SpellData.create(AlterSaberE_ID, 5, 2, 2, AlterSaberE_DamageAgiBase, AlterSaberE_DamageAgiStep, AlterSaberE_Damage2StaticBase, AlterSaberE_Damage2StaticStep, "Buff Duration: 1.5 sec|n" + T_Prop("Beam Radius", AlterSaberE_DamageAoe) + T_Prop("Beam Range", AlterSaberE_Mag_Range) + " (Magical Damage)|n" + T_Prop("Melee Dash Range", AlterSaberE_RangeCheck) + " (Physical Damage)", "")
        call SpellData.createUtility(AlterSaberR_ID, 5, "Morph Duration: <L:" + I2S(AlterSaberR_DurationBase) + "/" + I2S(AlterSaberR_DurationBase+AlterSaberR_DurationStep) + "/" + I2S(AlterSaberR_DurationBase+AlterSaberR_DurationStep*2) + "/" + I2S(AlterSaberR_DurationBase+AlterSaberR_DurationStep*3) + "/" + I2S(AlterSaberR_DurationBase+AlterSaberR_DurationStep*4) + "> sec", "")
        call SpellData.createSimple(AlterSaberT_ID, 1, 2, 2, AlterSaberT_DamageAgiBase, 0.0, T_Rad(AlterSaberT_DamageAoe), "")
        call SpellData.createUtility(AlterSaberF_ID, 1, "Passive|nBonus Damage per attack: " + FormatReal(AlterSaberF_DamageFromCurrentManaBase) + "% of Current Mana", T_Bonus("Morph", "Bonus Damage increases to " + FormatReal(AlterSaberF_DamageFromCurrentManaMorph) + "% of Current Mana"))
        call SpellData.create(AlterSaberG_ID, 5, 2, 2, AlterSaberG_DamageAgiBase, AlterSaberG_DamageAgiStep, AlterSaberG_Damage2StaticBase, AlterSaberG_Damage2StaticStep, "Cooldown: <L:" + I2S(R2I(AlterSaberG_CD_Base)) + "/" + I2S(R2I(AlterSaberG_CD_Base-AlterSaberG_CD_Step)) + "/" + I2S(R2I(AlterSaberG_CD_Base-AlterSaberG_CD_Step*2)) + "/" + I2S(R2I(AlterSaberG_CD_Base-AlterSaberG_CD_Step*3)) + "/" + I2S(R2I(AlterSaberG_CD_Base-AlterSaberG_CD_Step*4)) + "> sec", "")
        call SpellData.create(AlterSaberW2_ID, 5, 2, 2, AlterSaberW2_DamageAgiBase, AlterSaberW2_DamageAgiStep, AlterSaberW2_Damage2StaticBase, AlterSaberW2_Damage2StaticStep, T_Rad(AlterSaberW2_DamageAoe), "")
        call SpellData.createSimple(AlterSaberRR_ID, 5, 1, 2, AlterSaberRR_DamageAgiBase, AlterSaberRR_DamageAgiStep, T_Rad(AlterSaberRR_Aoe) + T_Dur("Area Duration", AlterSaberRR_Time) + T_Dur("Root Duration", AlterSaberRR_RootDurationBase), "")
        call SpellData.createSimple(AlterSaberComboE_ID, 5, 1, 2, AlterSaberComboE_DamageAgiBase, AlterSaberComboE_DamageAgiStep, T_Rad(AlterSaberComboE_Aoe), "")
        
        set form = HeroData.create(AlterSaber_ID, 0, AlterSaberQ_ID, AlterSaberW_ID, AlterSaberE_ID, AlterSaberR_ID, AlterSaberT_ID, AlterSaberF_ID, AlterSaberG_ID, AlterSaberW2_ID, AlterSaberRR_ID, AlterSaberComboE_ID)
        
        call DestroyTimer(t)
    endfunction
    
    private function InitHeroes_Part4 takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local HeroData form
        
        // ===========================================================================
        // 26. Райдэн (Raiden_ID) -> Ловкость (2)
        // ===========================================================================
        // --- БАЗОВАЯ ФОРМА (Form 0) ---
        call SpellData.create(RaidenQ_ID, 5, 1, 2, RaidenQ_DamageAgiBase, RaidenQ_DamageAgiStep, RaidenQ_Damage2StaticBase, RaidenQ_Damage2StaticStep, T_Rad(RaidenQ_DamageAoe) + T_CastAuto(RaidenQ_CastTime, RaidenQ_IsInvul) + T_Stun(RaidenQ_StunTime) + T_Push(RaidenQ_PushRange), T_Bonus("Passive Synergy", "Each slash counts as a basic attack for Thunder Blade (G)") + T_Bonus("Morph (T)", "Piercing Dash dealing Magic Damage (+Agility x " + FormatReal(RaidenTQ_DamageAgiBonus) + ")") + T_Bonus("Morph (TT)", "Piercing Dash dealing Magic Damage (+Agility x " + FormatReal(RaidenTTQ_DamageAgiBonus) + ")")).setDecor(T_Decor(RaidenQ_DecorDamage))
        call SpellData.createUtility(RaidenW_ID, 5, T_PropS("|cff33ccffAttack Bonus Damage", "Agility x <L:" + FormatReal(RaidenW_DamageAgiBase) + "/" + FormatReal(RaidenW_DamageAgiBase+RaidenW_DamageAgiStep) + "/" + FormatReal(RaidenW_DamageAgiBase+RaidenW_DamageAgiStep*2) + "/" + FormatReal(RaidenW_DamageAgiBase+RaidenW_DamageAgiStep*3) + "/" + FormatReal(RaidenW_DamageAgiBase+RaidenW_DamageAgiStep*4) + "> + " + FormatReal(RaidenW_Damage2StaticBase*2)) + T_PropS("|cff33ccffSpell Bonus Damage", "Agility x <L:" + FormatReal(RaidenTW_DamageAgiBase) + "/" + FormatReal(RaidenTW_DamageAgiBase+RaidenTW_DamageAgiStep) + "/" + FormatReal(RaidenTW_DamageAgiBase+RaidenTW_DamageAgiStep*2) + "/" + FormatReal(RaidenTW_DamageAgiBase+RaidenTW_DamageAgiStep*3) + "/" + FormatReal(RaidenTW_DamageAgiBase+RaidenTW_DamageAgiStep*4) + "> + " + FormatReal(RaidenW_Damage2StaticBase)) + T_Dur("Duration", RaidenW_Duration) + T_PropS("Bonus Movement Speed", FormatInt((RaidenW_MoveSpeedBonus - 1.0) * 100.0) + "%") + T_PropS("Mana Restore", FormatInt(RaidenW_ManaRestore) + "% Max Mana over " + FormatInt(RaidenW_ManaRestoreSec) + " sec"), T_Bonus("Synergy (G)", "Reduces required attacks for Thunder Blade to 2") + T_Bonus("Morph (T)", "Converts into periodic AoE lightning strikes") + T_Bonus("Morph (TT)", "+Agility x " + FormatReal(RaidenTTW_DamageAgiBonus) + " Lightning Dmg, " + FormatInt(RaidenTTW_DamageAoeCheck) + " Radius and chaotic Arena Strikes") + T_Bonus("Special", "Buff ends immediately upon entering Morph")).setDecor(T_Decor(RaidenW_DecorDamage)).setCdAfterDuration(true)
        call SpellData.create(RaidenE_ID, 5, 2, 2, RaidenE_DamageAgiBase, RaidenE_DamageAgiStep, RaidenE_Damage2StaticBase, RaidenE_Damage2StaticStep, T_Rad(RaidenE_DamageAoe) + T_CastAuto(RaidenE_CastTime, RaidenE_IsInvul) + T_Slow(RaidenE_Slow, RaidenE_Duration) + T_Push(RaidenE_PushRange), T_Bonus("Morph (T)", "Invulnerable shadow barrage (Radius " + FormatInt(RaidenTE_DamageAoe) + ", +Agility x " + FormatReal(RaidenTE_DamageAgiBonus) + " Dmg)") + T_Bonus("Morph (TT)", "Cataclysmic cleave (+Agility x " + FormatReal(RaidenTTE_DamageAgiBonus) + " Dmg) revealing 3000 range")).setDecor(T_Decor(RaidenE_DecorDamage))
        call SpellData.create(RaidenR_ID, 5, 2, 2, RaidenR_DamageAgiBase, RaidenR_DamageAgiStep, RaidenR_Damage2StaticBase, RaidenR_Damage2StaticStep, T_Rad(RaidenR_DamageAoe) + T_CastAuto(RaidenR_CastTime, RaidenR_IsInvul) + T_Stun(RaidenR_StunTime), T_Bonus("Morph (T)", "Stun increased to " + FormatReal(RaidenTR_StunTime) + " sec (+Agility x " + FormatReal(RaidenTR_DamageAgiBonus) + " Dmg)") + T_Bonus("Morph (TT)", "Cursor-guided strike with teleport, " + FormatReal(RaidenTTR_StunTime) + " sec Stun (+Agility x " + FormatReal(RaidenTTR_DamageAgiBonus) + " Dmg)")).setDecor(T_Decor(RaidenR_DecorDamage))
        call SpellData.createUtility(RaidenT_ID, 1, T_CastAuto(RaidenT_CastTime, RaidenT_IsInvul) + T_DurAuto(RaidenT_Duration, RaidenT_IsInvul) + T_Dur("Cooldown Reduction (W/E/R)", RaidenTT_RemoveCd) + T_Prop("Bonus Attack Damage", RaidenT_AdditionalDmg) + T_PropS("Bonus Attack Speed", "+30%") + T_PropS("Mana Restore Per Hit", FormatReal(RaidenT_AddManaPerHit) + "% Max Mana"), T_Bonus("Morph", "Converts attacks to Magic, enhances basic abilities") + T_Bonus("Requirement (TT)", "Unlocks True God Ascension at Hero Level 35"))
        call SpellData.createUtility(RaidenTT_ID, 1, T_CastAuto(RaidenTT_CastTime, RaidenTT_IsInvul) + T_Dur("Duration Bonus", RaidenTT_AddDuration) + T_PropS("Q Cooldown", "Instantly resets to 0 sec") + T_Dur("Cooldown Reduction (W/E/R)", RaidenTT_RemoveCd), T_Bonus("True God", "Extends Morph, resets Q cooldown and ascends abilities to God tier"))
        call SpellData.createUtility(RaidenF_ID, 1, T_Slow(RaidenF_Slow, RaidenF_SlowDuration) + T_PropS("Range", "Global"), T_Bonus("Trigger Condition", "Becomes available after Thunder Blade (G) triggers"))
        call SpellData.createSimple(RaidenG_ID, 5, 2, 2, RaidenG_AgiDMG, 0.0, T_Prop("Trigger Attacks", RaidenG_CountAtkToTrigger), T_Bonus("Bloodlust Buff", "Grants AS and MS buff on trigger (scales at Lv. 12 / 25 / 35)") + T_Bonus("Synergy (W)", "Required attacks reduced to 2 while Eye of Judgment is active") + T_Bonus("Unlock", "Enables Thunder Step (F) for 1 use"))
        // --- ФОРМА MUSOU SHINSETSU (Form 1) ---
        call SpellData.createAlt(RaidenQ_ID, 1, 5, 2, 2, RaidenQ_DamageAgiBase + RaidenTQ_DamageAgiBonus, RaidenQ_DamageAgiStep, RaidenQ_Damage2StaticBase, RaidenQ_Damage2StaticStep, T_Rad(RaidenQ_DamageAoe) + T_CastAuto(RaidenQ_CastTime, RaidenQ_IsInvul) + T_Stun(RaidenQ_StunTime) + T_Push(RaidenQ_PushRange), T_Bonus("Form", "|cff9933ffMusou Form|r") + T_Bonus("Mechanic", "Pierces through all enemies in the path") + T_Bonus("Morph (TT)", "Increases dash speed and damage (+Agility x " + FormatReal(RaidenTTQ_DamageAgiBonus - RaidenTQ_DamageAgiBonus) + ")")).setDecor(T_Decor(RaidenTQ_DecorDamage))
        call SpellData.createAlt(RaidenW_ID, 1, 5, 2, 2, RaidenTW_DamageAgiBase, RaidenTW_DamageAgiStep, RaidenW_Damage2StaticBase, RaidenW_Damage2StaticStep, T_Rad(RaidenTW_DamageAoeCheck) + T_Dur("Duration", RaidenW_Duration) + T_Dur("Strike Interval", RaidenTW_StrikeInterval), T_Bonus("Form", "|cff9933ffMusou Form (AoE Lightning Strikes)|r") + T_Bonus("Synergy (G)", "Required attacks for G reduced to 2") + T_Bonus("Morph (TT)", "+Agility x " + FormatReal(RaidenTTW_DamageAgiBonus) + " Lightning Dmg, " + FormatInt(RaidenTTW_DamageAoeCheck) + " Radius and chaotic Arena Strikes") + T_Bonus("Special", "Buff ends immediately when Morph expires")).setDecor(T_Decor(RaidenW_DecorDamage)).setCdAfterDuration(true)
        call SpellData.createAlt(RaidenE_ID, 1, 5, 2, 2, RaidenE_DamageAgiBase + RaidenTE_DamageAgiBonus, RaidenE_DamageAgiStep, RaidenE_Damage2StaticBase, RaidenE_Damage2StaticStep, T_Rad(RaidenTE_DamageAoe) + T_CastAuto(RaidenE_CastTime, RaidenE_IsInvul) + T_DurAuto(RaidenTE_Duration, true) + T_Slow(RaidenE_Slow, RaidenE_Duration), T_Bonus("Form", "|cff9933ffMusou Form|r") + T_Bonus("Morph (TT)", "Replaces with a massive dimensional wave (+Agility x " + FormatReal(RaidenTTE_DamageAgiBonus - RaidenTE_DamageAgiBonus) + " Dmg) revealing 3000 range")).setDecor(T_Decor(RaidenTE_DecorDamage))
        call SpellData.createAlt(RaidenR_ID, 1, 5, 2, 2, RaidenR_DamageAgiBase + RaidenTR_DamageAgiBonus, RaidenR_DamageAgiStep, RaidenR_Damage2StaticBase, RaidenR_Damage2StaticStep, T_Rad(RaidenR_DamageAoe) + T_CastAuto(RaidenTR_CastTime, RaidenTR_IsInvul) + T_Stun(RaidenTR_StunTime), T_Bonus("Form", "|cff9933ffMusou Form|r") + T_Bonus("Enhancement", "Stun duration doubled to " + FormatReal(RaidenTR_StunTime) + " sec") + T_Bonus("Morph (TT)", "Cursor-guided strike with teleport, Stun increased to " + FormatReal(RaidenTTR_StunTime) + " sec (+Agility x " + FormatReal(RaidenTTR_DamageAgiBonus - RaidenTR_DamageAgiBonus) + " Dmg)")).setDecor(T_Decor(RaidenTR_DecorDamage))
        // --- ФОРМА TRUE GOD (Form 2) ---
        call SpellData.createAlt(RaidenQ_ID, 2, 5, 2, 2, RaidenQ_DamageAgiBase + RaidenTTQ_DamageAgiBonus, RaidenQ_DamageAgiStep, RaidenQ_Damage2StaticBase, RaidenQ_Damage2StaticStep, T_Rad(RaidenQ_DamageAoe) + T_CastAuto(RaidenQ_CastTime, RaidenQ_IsInvul) + T_Stun(RaidenQ_StunTime) + T_Push(RaidenQ_PushRange), T_Bonus("Form", "|cffFF0000True God Form|r") + T_Bonus("Mechanic", "High-speed piercing lightning dash")).setDecor(T_Decor(RaidenTTQ_DecorDamage))
        call SpellData.createAlt(RaidenW_ID, 2, 5, 2, 2, RaidenTW_DamageAgiBase + RaidenTTW_DamageAgiBonus, RaidenTW_DamageAgiStep, RaidenW_Damage2StaticBase, RaidenW_Damage2StaticStep, T_Rad(RaidenTTW_DamageAoeCheck) + T_CastAuto(RaidenTTW_CastTime, RaidenTTW_IsInvul) + T_Dur("Strike Interval", RaidenTW_StrikeInterval) + T_PropS("|cff33ccffArena Strikes", "Agility x <L:" + FormatReal(RaidenArena_DamageAgiBase) + "/" + FormatReal(RaidenArena_DamageAgiBase+RaidenArena_DamageAgiStep) + "/" + FormatReal(RaidenArena_DamageAgiBase+RaidenArena_DamageAgiStep*2) + "/" + FormatReal(RaidenArena_DamageAgiBase+RaidenArena_DamageAgiStep*3) + "/" + FormatReal(RaidenArena_DamageAgiBase+RaidenArena_DamageAgiStep*4) + "> + <L:" + FormatReal(RaidenArena_StaticBase) + "/" + FormatReal(RaidenArena_StaticBase+RaidenArena_StaticStep) + "/" + FormatReal(RaidenArena_StaticBase+RaidenArena_StaticStep*2) + "/" + FormatReal(RaidenArena_StaticBase+RaidenArena_StaticStep*3) + "/" + FormatReal(RaidenArena_StaticBase+RaidenArena_StaticStep*4) + "> Mag. Damage") + T_Dur("Duration", RaidenW_Duration) + T_PropS("Bonus Movement Speed", FormatInt((RaidenW_MoveSpeedBonus - 1.0) * 100.0) + "%"), T_Bonus("Form", "|cffFF0000True God Form|r") + T_Bonus("Synergy (G)", "Required attacks for Thunder Blade reduced to 2") + T_Bonus("Global Strike", "Rains lightning randomly across the entire arena every " + FormatReal(RaidenTTW_ArenaInterval) + " sec") + T_Bonus("Special", "Buff ends immediately when Morph expires")).setDecor(T_Decor(RaidenTTW_ArenaDecorDamage)).setCdAfterDuration(true)
        call SpellData.createAlt(RaidenE_ID, 2, 5, 2, 2, RaidenE_DamageAgiBase + RaidenTTE_DamageAgiBonus, RaidenE_DamageAgiStep, RaidenE_Damage2StaticBase, RaidenE_Damage2StaticStep, T_Rad(RaidenE_DamageAoe) + T_CastAuto(RaidenE_CastTime, RaidenE_IsInvul) + T_Slow(RaidenE_Slow, RaidenE_Duration) + T_Push(RaidenE_PushRange), T_Bonus("Form", "|cffFF0000True God Form|r") + T_Bonus("Mechanic", "Fires a massive dimensional wave granting vision up to 3000 range")).setDecor(T_Decor(RaidenTTE_DecorDamage))
        call SpellData.createAlt(RaidenR_ID, 2, 5, 2, 2, RaidenR_DamageAgiBase + RaidenTTR_DamageAgiBonus, RaidenR_DamageAgiStep, RaidenR_Damage2StaticBase, RaidenR_Damage2StaticStep, T_Rad(RaidenR_DamageAoe * 1.15) + T_CastAuto(RaidenTTR_CastTime, RaidenTTR_IsInvul) + T_Stun(RaidenTTR_StunTime), T_Bonus("Form", "|cffFF0000True God Form|r") + T_Bonus("Cursor Control", "Reticle follows mouse cursor for 1.2 sec, then teleports Raiden to strike")).setDecor(T_Decor(RaidenTTR_DecorDamage))
        // --- РЕГИСТРАЦИЯ ФОРМ ГЕРОЯ (КАК У БАМБИЕТТЫ) ---
        set form = HeroData.create(Raiden_ID, 0, RaidenQ_ID, RaidenW_ID, RaidenE_ID, RaidenR_ID, RaidenT_ID, RaidenF_ID, RaidenG_ID, RaidenTT_ID, 0, 0)
        set form = HeroData.create(Raiden_ID, 1, RaidenQ_ID, RaidenW_ID, RaidenE_ID, RaidenR_ID, RaidenTT_ID, RaidenF_ID, RaidenG_ID, 0, 0, 0)
        set form = HeroData.create(Raiden_ID, 2, RaidenQ_ID, RaidenW_ID, RaidenE_ID, RaidenR_ID, 0, RaidenF_ID, RaidenG_ID, 0, 0, 0)
        set form = HeroData.create(Raiden_Morph_ID, 2, RaidenQ_ID, RaidenW_ID, RaidenE_ID, RaidenR_ID, 0, RaidenF_ID, RaidenG_ID, 0, 0, 0)
        
        // ===================================
        // 27. Нацу (Natsu_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(NatsuQ_ID, 5, 2, 2, NatsuQ_DamageAgiBase, NatsuQ_DamageAgiStep, NatsuQ_Damage2StaticBase, NatsuQ_Damage2StaticStep, T_Rad(NatsuQ_DamageAoe) + "Range: " + I2S(R2I(NatsuQ_Range)) + " / " + I2S(R2I(NatsuQ_Range2)) + " / " + I2S(R2I(NatsuQ_Range3)), T_Bonus("Raienryuu", "+ Agility x " + FormatReal(NatsuGQ_DamageAgiBonus) + " Damage|nEnhanced Roar: + Agility x " + FormatReal(NatsuGQ2_DamageAgiBonus) + " Damage"))
        call SpellData.create(NatsuW_ID, 5, 1, 2, NatsuW_DamageAgiBase, NatsuW_DamageAgiStep, NatsuW_Damage2StaticBase, NatsuW_Damage2StaticStep, T_Push(NatsuW_PushRange) + T_Stun(NatsuW_Stun), T_Bonus("Raienryuu", "+ Agility x " + FormatReal(NatsuGW_DamageAgiBonus) + " Damage"))
        call SpellData.create(NatsuE_ID, 5, 2, 2, NatsuE_DamageAgiBase, NatsuE_DamageAgiStep, NatsuE_Damage2StaticBase, NatsuE_Damage2StaticStep, T_Rad(NatsuE_DamageAoe) + T_Slow(NatsuE_Slow, NatsuE_Duration), T_Bonus("Raienryuu", "+ Agility x " + FormatReal(NatsuGE_DamageAgiBonus) + " Damage and applies Overload"))
        call SpellData.create(NatsuR_ID, 5, 1, 2, NatsuR_DamageAgiBase, NatsuR_DamageAgiStep, NatsuR_Damage2StaticBase, NatsuR_Damage2StaticStep, T_Push(NatsuR_PushRange), T_Bonus("Raienryuu", "+ Agility x " + FormatReal(NatsuGR_DamageAgiBonus) + " Damage and Stuns for " + FormatReal(NatsuR_Stun) + " sec|nConsecutive Casts: Damage increases by " + FormatReal(NatsuR_BonusAdd) + "% (Max " + FormatReal(NatsuR_BonusMax) + "%)"))
        call SpellData.createSimple(NatsuT_ID, 1, 2, 2, NatsuT_DamageAgiBase, 0.0, T_Rad(NatsuT_DamageAoe) + T_Push(NatsuT_PushRange), T_Bonus("Raienryuu", "+ Agility x " + FormatReal(NatsuGT_DamageAgiBonus) + " Damage"))
        call SpellData.createUtility(NatsuG_ID, 1, T_Rad(NatsuG_Aoe) + "Absorbs nearby fire to restore Mana and reduce ongoing Q/W/E cooldowns by " + FormatReal(NatsuG_CdReduceTime) + " sec per flame", T_Bonus("Lv. 25", "Unlocks Raienryuu Mode (G)"))
        call SpellData.createUtility(NatsuG2_ID, 1, T_Dur("Duration", NatsuG_Duration) + T_Dur("Cooldown", NatsuG_Cd) + "Enters Mode Raienryuu, enhancing Q/W/E/R/T abilities", "")
        call SpellData.createUtility(NatsuF_ID, 1, "Passive (Unlocks at Lv. " + I2S(NatsuF_LvlCheck) + ")|nActivates Flame of Emotion when an ally within " + I2S(R2I(NatsuF_AoeSearch)) + " range takes severe damage (" + FormatReal(NatsuF_AllyDamageHigh) + "% MAX HP or drops below " + FormatReal(NatsuF_AllyDamageLow) + "% HP)|n" + T_Dur("Duration", NatsuF_Duration) + T_Dur("Cooldown", NatsuF_Cd), T_Bonus("Effect", "Replaces R and T with enhanced versions and resets their cooldowns"))
        call SpellData.create(NatsuFR_ID, 5, 1, 2, NatsuFR_DamageAgiBase, NatsuFR_DamageAgiStep, NatsuFR_Damage2StaticBase, NatsuFR_Damage2StaticStep, T_Stun(NatsuFR_Stun), "")
        call SpellData.createSimple(NatsuFT_ID, 1, 2, 2, NatsuFT_DamageAgiBase, 0.0, T_Stun(NatsuFT_Stun), "")
        
        set form = HeroData.create(Natsu_ID, 0, NatsuQ_ID, NatsuW_ID, NatsuE_ID, NatsuR_ID, NatsuT_ID, NatsuF_ID, NatsuG_ID, NatsuG2_ID, NatsuFR_ID, NatsuFT_ID)
        
        // ===================================
        // 28. Кёраку (Kyoraku_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(KyorakuQ_ID, 5, 1, 2, KyorakuQ_DamageAgiBase, KyorakuQ_DamageAgiStep, KyorakuQ_Damage2StaticBase, KyorakuQ_Damage2StaticStep, T_Rad(KyorakuQ_DamageAoe), "")
        call SpellData.create(KyorakuW_ID, 5, 1, 2, KyorakuW_DamageAgiBase, KyorakuW_DamageAgiStep, KyorakuW_Damage2StaticBase, KyorakuW_Damage2StaticStep, T_Rad(KyorakuW_DamageAoe) + "Shadow Area: <L:" + I2S(R2I(KyorakuW_ShadowAoeBase)) + "/" + I2S(R2I(KyorakuW_ShadowAoeBase+KyorakuW_ShadowAoeStep)) + "/" + I2S(R2I(KyorakuW_ShadowAoeBase+KyorakuW_ShadowAoeStep*2)) + "/" + I2S(R2I(KyorakuW_ShadowAoeBase+KyorakuW_ShadowAoeStep*3)) + "/" + I2S(R2I(KyorakuW_ShadowAoeBase+KyorakuW_ShadowAoeStep*4)) + ">|n" + T_Prop("Shadow Duration", KyorakuW_ShadowDuration), T_Bonus("Effect", "Unlocks secondary shadow abilities Q2, W2, and E2"))
        call SpellData.create(KyorakuE_ID, 5, 2, 2, KyorakuE_DamageAgiBase, KyorakuE_DamageAgiStep, KyorakuE_Damage2StaticBase, KyorakuE_Damage2StaticStep, T_Rad(KyorakuE_DamageAoe) + T_Dur("Duration", KyorakuE_DurationBase), "")
        call SpellData.create(KyorakuR_ID, 5, 1, 2, KyorakuR_DamageAgiBase, KyorakuR_DamageAgiStep, KyorakuR_Damage2StaticBase, KyorakuR_Damage2StaticStep, T_Stun(KyorakuR_Stun), "")
        call SpellData.createUtility(KyorakuT_ID, 1, T_Rad(KyorakuT_DamageAoe), "|cFFFFFF00Act 1: Reverses " + FormatReal(KyorakuT_Dan1_Reverse * 100) + "% damage|r|n|cffff0000Act 2: Deals Agility x " + FormatReal(KyorakuT_Dan2_DamageAgi) + " Physical Damage per sec and heals " + FormatReal(KyorakuT_Dan2_KyorakuSelfHealEnter) + "% Max HP per each debuff from act 1|r|n|cFF00BFFFAct 3: Deals Agility x " + FormatReal(KyorakuT_Dan3_Dmg) + " Magical Damage per sec and drains " + FormatReal(KyorakuT_Dan3_ManaBurn) + "% Max Mana per sec|r|nFinal Act: Deals Agility x " + FormatReal(KyorakuT_DanFinal_Dmg) + " Physical Damage and stuns for " + FormatReal(KyorakuT_DanFinal_Stun) + " sec")
        call SpellData.createSimple(KyorakuF_ID, 1, 2, 2, KyorakuF_DamageAgiBase, 0.0, T_Rad(KyorakuF_DamageAoe) + T_Silence(KyorakuF_SilenceDuration), "")
        call SpellData.createSimple(KyorakuQ2_ID, 5, 1, 2, KyorakuQ2_DamageAgiBase, KyorakuQ2_DamageAgiStep, "Shadow Attack", "")
        call SpellData.createUtility(KyorakuW2_ID, 5, "Speed: " + I2S(R2I(KyorakuW2_Speed)) + "|n" + T_Dur("Duration", KyorakuW2_Duration), "")
        call SpellData.create(KyorakuE2_ID, 5, 1, 2, KyorakuE2_DamageAgiBase, KyorakuE2_DamageAgiStep, KyorakuE2_Damage2StaticBase, KyorakuE2_Damage2StaticStep, T_Rad(KyorakuE2_DamageAoe) + T_Stun(KyorakuE2_Stun), "")
        call SpellData.createSimple(KyorakuT4_ID, 1, 1, 2, KyorakuT_DanFinal_Dmg, 0.0, T_Stun(KyorakuT_DanFinal_Stun), "")
        
        set form = HeroData.create(Kyoraku_ID, 0, KyorakuQ_ID, KyorakuW_ID, KyorakuE_ID, KyorakuR_ID, KyorakuT_ID, KyorakuF_ID, KyorakuQ2_ID, KyorakuW2_ID, KyorakuE2_ID, KyorakuT4_ID)
        
        // ===================================
        // 29. Томиока Гию (Tomioka_ID) -> Ловкость (2)
        // ===================================
        call SpellData.create(TomiokaQ_ID, 5, 1, 2, TomiokaQ_DamageAgiBase, TomiokaQ_DamageAgiStep, TomiokaQ_Damage2StaticBase, TomiokaQ_Damage2StaticStep, T_Rad(TomiokaQ_DamageAoe) + T_Stun(TomiokaQ_Stun), T_Bonus("Combo W+Q", "Stun increased to " + FormatReal(TomiokaCombo_WQ_Stun) + " sec"))
        call SpellData.create(TomiokaW_ID, 5, 1, 2, TomiokaW_DamageAgiBase, TomiokaW_DamageAgiStep, TomiokaW_Damage2StaticBase, TomiokaW_Damage2StaticStep, T_Rad(TomiokaW_DamageAoe) + T_Push(TomiokaW_PushRange) + T_Slow(TomiokaW_Slow, TomiokaW_Duration), T_Bonus("Combo Q+W", "Knockback increased by " + I2S(R2I(TomiokaCombo_QW_PushRange))))
        call SpellData.createSimple(TomiokaE_ID, 5, 1, 2, TomiokaE_DamageAgiBase, TomiokaE_DamageAgiStep, T_Rad(TomiokaE_DamageAoe) + "Strikes: <L:" + I2S(TomiokaE_AtkCountBase) + "/" + I2S(TomiokaE_AtkCountBase+TomiokaE_AtkCountStep) + "/" + I2S(TomiokaE_AtkCountBase+TomiokaE_AtkCountStep*2) + "/" + I2S(TomiokaE_AtkCountBase+TomiokaE_AtkCountStep*3) + "/" + I2S(TomiokaE_AtkCountBase+TomiokaE_AtkCountStep*4) + ">", T_Bonus("Combo Q+E", "Each strike stuns for " + FormatReal(TomiokaCombo_QE_Stun) + " sec|nCombo W+E: Strikes slow by " + I2S(TomiokaCombo_WE_Slow) + "% for " + I2S(TomiokaCombo_WE_SlowDuration) + " sec"))
        call SpellData.createSimple(TomiokaR_ID, 5, 1, 2, TomiokaR_DamageAgiBase, TomiokaR_DamageAgiStep, T_Rad(TomiokaR_DamageAoe) + "Pulls enemies towards the center (Duration: 2.62 sec)", "")
        call SpellData.createSimple(TomiokaT_ID, 1, 2, 2, TomiokaT_DamageAgiBase, 0.0, T_Rad(TomiokaT_DamageAoe) + T_Push(350), "")
        call SpellData.createSimple(TomiokaF_ID, 1, 2, 2, TomiokaF_DamageAgiBase, 0.0, T_Rad(TomiokaF_DamageAoe) + T_Dur("Duration", TomiokaF_Duration) + "Grants a Shield", "")
        call SpellData.createUtility(TomiokaG_ID, 1, "Passive|nCasting spells grants stacks (Max " + I2S(Tomioka_G_AddDamageMaxStacks) + ")|n" + T_Dur("Buff Duration", Tomioka_G_BuffDuration), T_Bonus("Bonus Damage", "Agility x " + FormatReal(Tomioka_G_AddDamageBase) + " + " + FormatReal(Tomioka_G_AddDamageStep) + " per additional stack"))
        
        set form = HeroData.create(Tomioka_ID, 0, TomiokaQ_ID, TomiokaW_ID, TomiokaE_ID, TomiokaR_ID, TomiokaT_ID, TomiokaF_ID, TomiokaG_ID, 0, 0, 0)
        
        // ===================================
        // 30. Фрирен (Frieren_ID) -> Интеллект (3)
        // ===================================
        call SpellData.create(FrierenQ_ID, 5, 2, 3, FrierenQ_DamageIntBase, FrierenQ_DamageIntStep, FrierenQ_Damage2StaticBase, FrierenQ_Damage2StaticStep, T_Rad(FrierenQ_DamageAoe) + "Range: <L:" + I2S(R2I(FrierenQ_RangeBase)) + "/" + I2S(R2I(FrierenQ_RangeBase+FrierenQ_RangeStep)) + "/" + I2S(R2I(FrierenQ_RangeBase+FrierenQ_RangeStep*2)) + "/" + I2S(R2I(FrierenQ_RangeBase+FrierenQ_RangeStep*3)) + "/" + I2S(R2I(FrierenQ_RangeBase+FrierenQ_RangeStep*4)) + ">", T_Bonus("Morph (T)", "Replaced by Enhanced Zoltraak (Radius " + I2S(R2I(FrierenQ3_DamageAoe)) + ", Int x " + FormatReal(FrierenQ3_DamageIntBase) + " Damage)"))
        call SpellData.create(FrierenW_ID, 5, 2, 3, FrierenW_DamageIntBase, FrierenW_DamageIntStep, FrierenW_Damage2StaticBase, FrierenW_Damage2StaticStep, T_Rad(FrierenW_DamageAoe) + T_Stun(FrierenW_Stun), T_Bonus("Morph (T)", "Replaced by massive AoE strike (Radius " + I2S(R2I(FrierenW2_DamageAoe)) + ")"))
        call SpellData.create(FrierenE_ID, 5, 2, 3, FrierenE_DamageIntBase, FrierenE_DamageIntStep, FrierenE_Damage2StaticBase, FrierenE_Damage2StaticStep, T_Prop("Pillar Radius", FrierenE_DamageAoe) + "Pillars Count: 8|nSpawn Distance: 275 - 455|n" + T_Slow(FrierenE_Slow, FrierenE_Duration), T_Bonus("Morph (T)", "Spawn Distance 355 - 665, Pillar Radius increased by " + I2S(R2I(FrierenTE_DamageAoeIncrease)) + "% and deals + Int x " + FormatReal(FrierenTE_DamageIncrease) + " Damage"))
        call SpellData.createUtility(FrierenR_ID, 5, "Duration: 8 sec|n" + T_Prop("Cast Range", FrierenR_CloneRangeCast) + "Creates an illusion of Frieren that mirrors your spellcasts", T_Bonus("Morph (T)", "Replaced by a Golem drop (Radius " + I2S(R2I(FrierenTR_DamageAoe)) + ", Stun " + FormatReal(FrierenTR_Stun) + " sec, Golem Duration: " + FormatReal(FrierenTR_Duration) + " sec, Int x " + FormatReal(FrierenTR_DamageIntBase) + " Damage)"))
        call SpellData.createSimple(FrierenT_ID, 1, 1, 3, FrierenT_DamageIntBase, 0.0, T_Rad(FrierenT_DamageAoe) + T_Dur("Duration", FrierenT_Duration) + "Reduces basic abilities cooldowns by " + FormatReal(FrierenT_ReduceCD) + " sec", T_Bonus("Height of Magic", "Enters mode, greatly enhancing all basic abilities"))
        call SpellData.createUtility(FrierenF_ID, 1, "Passive: Gathers magic stacks over time or when allies are nearby", T_Bonus("Morph (T)", "Places a mark that stores " + FormatReal(FrierenTF_RememberDamage) + "% of damage dealt by Frieren, exploding afterwards"))
        call SpellData.createUtility(FrierenG_ID, 1, T_Rad(FrierenG_DamageAoe) + "Consumes Magic Stacks to grant a protective buff|n" + T_Dur("Buff Duration", FrierenG_Duration), "")
        call SpellData.create(FrierenQ2_ID, 5, 2, 3, FrierenQ2_DamageIntBase, FrierenQ2_DamageIntStep, FrierenQ2_Damage2StaticBase, FrierenQ2_Damage2StaticStep, "Secondary Zoltraak attack", "")
        call SpellData.create(FrierenQ3_ID, 5, 2, 3, FrierenQ3_DamageIntBase, FrierenQ3_DamageIntStep, FrierenQ3_Damage2StaticBase, FrierenQ3_Damage2StaticStep, T_Rad(FrierenQ3_DamageAoe), "")
        call SpellData.createSimple(FrierenW2_ID, 5, 2, 3, FrierenW2_DamageIntBase, 0.0, T_Rad(FrierenW2_DamageAoe), "")
        call SpellData.createSimple(FrierenT2_ID, 1, 2, 3, FrierenT2_DamageIntBase, 0.0, T_Rad(FrierenT2_DamageAoe) + T_Slow(FrierenT2_Slow, FrierenT2_SlowDuration), "")
        call SpellData.createSimple(FrierenTF_ID, 1, 2, 3, 0.0, 0.0, "Stores " + FormatReal(FrierenTF_RememberDamage) + "% of Frieren's damage and explodes", "")
        
        set form = HeroData.create(Frieren_ID, 0, FrierenQ_ID, FrierenW_ID, FrierenE_ID, FrierenR_ID, FrierenT_ID, FrierenF_ID, FrierenG_ID, FrierenQ2_ID, FrierenQ3_ID, FrierenW2_ID)
        call form.addExtra(FrierenT2_ID, FrierenTF_ID, 0, 0, 0, 0, 0, 0, 0, 0)
        
            
        // ===========================================================================
        // 31. Тоджи Фушигуро (Toji_ID) -> Ловкость (2)
        // ===========================================================================
        // --- БАЗОВЫЕ СПОСОБНОСТИ ---
        call SpellData.create(TojiQ_ID, 5, 1, 2, TojiQ_DamageAgiBase, TojiQ_DamageAgiStep, TojiQ_Damage2StaticBase, TojiQ_Damage2StaticStep, T_Prop("Attack Range", TojiQ_AttackRange) + T_Prop("Strikes", 2) + T_CastAuto(TojiQ_CastTime, TojiQ_IsInvul) + T_Dur("Chase Max Duration", TojiQ_ChaseMaxDuration), T_Bonus("Arsenal (F)", "Switchable Q|nQ2 unlocks at Lv. " + FormatInt(TojiArsenalQ2HeroLevel) + ", Q3 at Lv. " + FormatInt(TojiArsenalQ3HeroLevel))).setDecor(T_Decor(TojiQ_DecorDamage))
        call SpellData.create(TojiW_ID, 5, 1, 2, TojiW_DamageAgiBase, TojiW_DamageAgiStep, TojiW_Damage2StaticBase, TojiW_Damage2StaticStep, T_Prop("Projectile Radius", TojiW_DamageAoe) + T_PropS("Projectile Range", "<L:" + FormatInt(TojiW_RangeBase) + "/" + FormatInt(TojiW_RangeBase+TojiW_RangeStep) + "/" + FormatInt(TojiW_RangeBase+TojiW_RangeStep*2) + "/" + FormatInt(TojiW_RangeBase+TojiW_RangeStep*3) + "/" + FormatInt(TojiW_RangeBase+TojiW_RangeStep*4) + ">") + T_Dur("Max Chain Duration", TojiW_ChainDuration) + T_Prop("Max Tether Distance", TojiW_ChainMaxRange), T_Bonus("On Hit", "Replaced by Chain Whip (W2) while chain is connected")).setDecor(T_Decor(TojiW_DecorDamage))
        call SpellData.createUtility(TojiE_ID, 5, T_Prop("Charges", TojiE_MaxCharges) + T_PropS("Dash Range", "<L:" + FormatInt(TojiE_RangeBase) + "/" + FormatInt(TojiE_RangeBase+TojiE_RangeStep) + "/" + FormatInt(TojiE_RangeBase+TojiE_RangeStep*2) + "/" + FormatInt(TojiE_RangeBase+TojiE_RangeStep*3) + "/" + FormatInt(TojiE_RangeBase+TojiE_RangeStep*4) + ">") + T_DurAuto(TojiE_DashDuration, TojiE_IsInvul), T_Bonus("Lv. 25 Heavenly Body", "Deals " + FormatReal(TojiE_Level25DamageAtk) + "% ATK + Agility x " + FormatReal(TojiE_Level25DamageAgi) + " damage in " + FormatInt(TojiE_HitAoe) + " AoE, throws enemies " + FormatInt(TojiE_Level25ThrowRange) + " range, and empowers next ability by +Agility x " + FormatReal(TojiE_NextAbilityAgiBonus) + " for " + FormatReal(TojiE_BuffDuration) + " sec")).setDecor(T_Decor(TojiE_DecorDamage))
        call SpellData.create(TojiR_ID, 5, 1, 2, TojiR_DamageAgiBase, TojiR_DamageAgiStep, TojiR_DamageStaticBase, TojiR_DamageStaticStep, T_Rad(TojiR_Aoe) + T_PropS("Duration", "<L:" + FormatReal(TojiR_DurationBase) + "/" + FormatReal(TojiR_DurationBase+TojiR_DurationStep) + "/" + FormatReal(TojiR_DurationBase+TojiR_DurationStep*2) + "/" + FormatReal(TojiR_DurationBase+TojiR_DurationStep*3) + "/" + FormatReal(TojiR_DurationBase+TojiR_DurationStep*4) + "> sec") + T_Dur("Damage Interval", TojiR_DamageInterval) + T_Slow(TojiR_SlowPercent, TojiR_SlowDuration), "").setDecor(T_Decor(TojiR_DecorDamage))
        call SpellData.createSimple(TojiT_ID, 1, 1, 2, TojiT_DamageAgi, 0.0, T_Rad(TojiT_DamageAoe) + T_DurAuto(TojiT_Duration, TojiT_IsInvul) + T_Prop("Strikes", TojiT_HitCount) + T_Dur("Hit Interval", TojiT_HitInterval) + T_PropS("Pierces Shields", "10 sec"), "").setDecor(T_Decor(TojiT_DecorDamage))
        call SpellData.createUtility(TojiF_ID, 1, "Cycles between 3 weapons in inventory curse:|n1. Split Soul Katana (Q)|n2. Playful Cloud (Q2 - Lv. " + FormatInt(TojiArsenalQ2HeroLevel) + ")|n3. Inverted Spear of Heaven (Q3 - Lv. " + FormatInt(TojiArsenalQ3HeroLevel) + ")", "")
        call SpellData.create(TojiG_ID, 1, 1, 2, TojiG_DamageAgiBase, TojiG_DamageAgiStep, TojiG_DamageStaticBase, TojiG_DamageStaticStep, T_Prop("Hit Radius", TojiG_DamageAoe+25.0) + T_CastAuto(TojiG_CastTime, TojiG_IsInvul) + T_Stun(TojiG_StunTime) + T_Dur("Max Flight Time", TojiG_MaxFlightTime), T_Bonus("Cursed Tool Mark", "Applies Mark (10 sec). Each subsequent ability hit on the target adds +1 stack (Max 5)|nEach stack amplifies ability damage by +" + FormatReal(TojiG_DamageIncreasePerStack) + "%") + T_Bonus("Lv. 35 Grade", "Reduces all abilities cooldown by " + FormatReal(TojiG_CdReduce) + "%")).setDecor(T_Decor(TojiG_DecorDamage))
        // --- ДОПОЛНИТЕЛЬНЫЕ И СВЯЗАННЫЕ СПОСОБНОСТИ ---
        call SpellData.create(TojiQ2_ID, 5, 1, 2, TojiQ2_DamageAgiBase, TojiQ2_DamageAgiStep, TojiQ2_Damage2StaticBase, TojiQ2_Damage2StaticStep, T_Rad(TojiQ2_DamageAoe) + T_Prop("Reach Range", TojiQ2_ReachRange) + T_Prop("Strikes", TojiQ2_DamageCount) + T_Dur("Damage Interval", TojiQ2_DamageInterval) + T_Dur("Spin Duration", TojiQ2_ExtraRunDuration) + T_Dur("Mini Stun", TojiQ2_MiniStun), T_Bonus("Arsenal (Lv. 12)", "Damage is split across 4 strikes while dragging the target toward cursor")).setDecor(T_Decor(TojiQ2_DecorDamage))
        call SpellData.create(TojiQ3_ID, 5, 1, 2, TojiQ3_DamageAgiBase, TojiQ3_DamageAgiStep, TojiQ3_DamageStaticBase, TojiQ3_DamageStaticStep, T_CastAuto(TojiQ3_CastTime, TojiQ3_IsInvul) + T_Stun(TojiQ3_Stun), T_Bonus("Arsenal (Lv. 25)", "Teleports behind target and delivers a devastating single pierce")).setDecor(T_Decor(TojiQ3_DecorDamage))
        call SpellData.createUtility(TojiW2_ID, 5, T_Prop("Center Pull", TojiW2_CenterPullRange) + T_Prop("Side Pull", TojiW2_SidePullRange) + T_Prop("Inward Step", TojiW2_SideInwardRange) + T_Dur("Pull Duration", TojiW2_PullDuration), T_Bonus("Chain Pull", "Center click pulls target straight in; Side click whips target sideways")).setDecor(T_Decor(TojiW2_DecorDamage))
        call SpellData.create(TojiG2_ID, 1, 1, 2, TojiG_DamageAgiBase, TojiG_DamageAgiStep, TojiG_DamageStaticBase, TojiG_DamageStaticStep, T_Prop("Hit Radius", TojiG_DamageAoe+25.0) + T_CastAuto(TojiG_CastTime, TojiG_IsInvul) + T_Stun(TojiG_StunTime) + T_Dur("Max Flight Time", TojiG_MaxFlightTime), T_Bonus("Cursed Tool Mark", "Applies Mark (10 sec). Each subsequent ability hit on the target adds +1 stack (Max 5)|nEach stack amplifies ability damage by +" + FormatReal(TojiG_DamageIncreasePerStack) + "%") + T_Bonus("Lv. 35 Grade", "Reduces all abilities cooldown by " + FormatReal(TojiG_CdReduce) + "%")).setDecor(T_Decor(TojiG_DecorDamage))
        // --- РЕГИСТРАЦИЯ НАБОРА СПОСОБНОСТЕЙ ГЕРОЯ ---
        set form = HeroData.create(Toji_ID, 0, TojiQ_ID, TojiW_ID, TojiE_ID, TojiR_ID, TojiT_ID, TojiF_ID, TojiG_ID, TojiQ2_ID, TojiQ3_ID, TojiW2_ID)
        call form.addExtra(TojiG2_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        
        call DestroyTimer(t)
    endfunction
    
    private function InitHeroes_Part5 takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local HeroData form

        // ===================================
        // 31. Эрза Скарлет (Erza_ID) -> Ловкость (2)
        // ===================================

        // --- БАЗОВАЯ ФОРМА (СМЕНА ДОСПЕХОВ) ---
        call SpellData.createUtility(ErzaQ_ID, 1, "Bonus Max HP: <L:" + I2S(ErzaQ_ArmorStatHpBase) + "/" + I2S(ErzaQ_ArmorStatHpBase+ErzaQ_ArmorStatHpStep) + "/" + I2S(ErzaQ_ArmorStatHpBase+ErzaQ_ArmorStatHpStep*2) + "/" + I2S(ErzaQ_ArmorStatHpBase+ErzaQ_ArmorStatHpStep*3) + "/" + I2S(ErzaQ_ArmorStatHpBase+ErzaQ_ArmorStatHpStep*4) + ">", "")
        call SpellData.createUtility(ErzaW_ID, 1, "Grants Bonus HP Regeneration", "")
        call SpellData.createUtility(ErzaE_ID, 1, "Bonus Movement Speed: <L:" + I2S(ErzaE_ArmorMS_LvLBase_ID*10) + "/" + I2S((ErzaE_ArmorMS_LvLBase_ID+ErzaE_ArmorMS_LvLStep_ID)*10) + "/" + I2S((ErzaE_ArmorMS_LvLBase_ID+ErzaE_ArmorMS_LvLStep_ID*2)*10) + "/" + I2S((ErzaE_ArmorMS_LvLBase_ID+ErzaE_ArmorMS_LvLStep_ID*3)*10) + "/" + I2S((ErzaE_ArmorMS_LvLBase_ID+ErzaE_ArmorMS_LvLStep_ID*4)*10) + ">|nBonus Mana Regen: <L:" + FormatReal(ErzaE_ArmorStatMpRegenBase) + "/" + FormatReal(ErzaE_ArmorStatMpRegenBase+ErzaE_ArmorStatMpRegenStep) + "/" + FormatReal(ErzaE_ArmorStatMpRegenBase+ErzaE_ArmorStatMpRegenStep*2) + "/" + FormatReal(ErzaE_ArmorStatMpRegenBase+ErzaE_ArmorStatMpRegenStep*3) + "/" + FormatReal(ErzaE_ArmorStatMpRegenBase+ErzaE_ArmorStatMpRegenStep*4) + "> / sec", "")
        call SpellData.createUtility(ErzaR_ID, 1, "Bonus Max HP: <L:" + I2S(ErzaR_ArmorStatHpBase) + "/" + I2S(ErzaR_ArmorStatHpBase+ErzaR_ArmorStatHpStep) + "/" + I2S(ErzaR_ArmorStatHpBase+ErzaR_ArmorStatHpStep*2) + "/" + I2S(ErzaR_ArmorStatHpBase+ErzaR_ArmorStatHpStep*3) + "/" + I2S(ErzaR_ArmorStatHpBase+ErzaR_ArmorStatHpStep*4) + ">|nBonus Movement Speed: <L:" + I2S(ErzaR_ArmorMS_LvLBase_ID*10) + "/" + I2S((ErzaR_ArmorMS_LvLBase_ID+ErzaR_ArmorMS_LvLStep_ID)*10) + "/" + I2S((ErzaR_ArmorMS_LvLBase_ID+ErzaR_ArmorMS_LvLStep_ID*2)*10) + "/" + I2S((ErzaR_ArmorMS_LvLBase_ID+ErzaR_ArmorMS_LvLStep_ID*3)*10) + "/" + I2S((ErzaR_ArmorMS_LvLBase_ID+ErzaR_ArmorMS_LvLStep_ID*4)*10) + ">|nGrants Bonus Attack Speed and Evasion", "")
        call SpellData.createUtility(ErzaT_ID, 1, "Bonus Max HP: " + I2S(ErzaT_ArmorStatHpBase), "")
        call SpellData.createUtility(ErzaG_ID, 1, "Bonus Max HP: " + I2S(ErzaG1_ArmorStatHpBase) + "|nMagic Resistance: " + FormatReal(Erza6_MagicalDmgResist) + "%|n" + T_Dur("Duration", Erza6_ArmorDuration), "")
        call SpellData.createUtility(ErzaG2_ID, 1, "Bonus Max HP: " + I2S(ErzaG2_ArmorStatHpBase) + "|nPhysical Resistance: " + FormatReal(Erza7_PhysicalDmgResist) + "%", "")

        // --- ФОРМА 1: HEAVEN'S WHEEL (Q) ---
        call SpellData.create(Erza1Q_ID, 5, 1, 2, Erza1Q_DamageAgiBase, Erza1Q_DamageAgiStep, Erza1Q_Damage2StaticBase, Erza1Q_Damage2StaticStep, T_Rad(Erza1Q_DamageAoe), "")
        call SpellData.create(Erza1W_ID, 5, 1, 2, Erza1W_DamageAgiBase, Erza1W_DamageAgiStep, Erza1W_Damage2StaticBase, Erza1W_Damage2StaticStep, T_Rad(Erza1W_DamageAoe), "")
        call SpellData.createSimple(Erza1E_ID, 5, 2, 2, Erza1E_DamageAgiBase, Erza1E_DamageAgiStep, T_Rad(Erza1E_DamageAoe) + "Cooldown: <L:" + FormatReal(Erza1E_CD_TIME_Base) + "/" + FormatReal(Erza1E_CD_TIME_Base-Erza1E_CD_TIME_Step) + "/" + FormatReal(Erza1E_CD_TIME_Base-Erza1E_CD_TIME_Step*2) + "/" + FormatReal(Erza1E_CD_TIME_Base-Erza1E_CD_TIME_Step*3) + "/" + FormatReal(Erza1E_CD_TIME_Base-Erza1E_CD_TIME_Step*4) + "> sec", T_Bonus("Passive", "Casting Q or W triggers an automatic magical explosion around Erza."))
        call SpellData.createSimple(Erza1R_ID, 5, 2, 2, Erza1R_DamageAgiBase, Erza1R_DamageAgiStep, T_Rad(Erza1R_DamageAoe) + T_Dur("Duration", Erza1R_Duration), "|cFFFF4500[Flame Zone]|r Deals damage every 1 sec.|n" + T_Bonus("Synergy", "Summons a Fire Element if Natsu or Gray are nearby."))
        call SpellData.createSimple(Erza1T_ID, 1, 2, 2, Erza1T_DamageAgiBase, 0.0, T_Rad(Erza1T_DamageAoe) + T_Stun(Erza1T_Stun), T_Bonus("Flame Zone Combo", "If cast within R's zone, releases a phoenix dealing Agility x " + FormatReal(Erza1T2_DamageAgiBase) + " Damage."))

        // --- ФОРМА 2: BLACK WING (W) ---
        call SpellData.create(Erza2Q_ID, 5, 1, 2, Erza2Q_DamageAgiBase, Erza2Q_DamageAgiStep, Erza2Q_Damage2StaticBase, Erza2Q_Damage2StaticStep, T_Rad(Erza2Q_DamageAoe), "")
        call SpellData.createUtility(Erza2W_ID, 5, T_Rad(Erza2W_Aoe) + T_Push(Erza2W_PushDistance) + T_Dur("Jump Duration", Erza2W_DurationBase), "Applies Water debuff to enemies.|nGrants nearby allies Bonus Armor, Invisibility, and heals " + FormatReal(Erza2W_AllyBuffHealBase) + " HP over " + FormatReal(Erza2W_AllyBuffDurationBase) + " sec.")
        call SpellData.createUtility(Erza2E_ID, 5, T_Rad(Erza2E_Aoe), "Applies Water debuff to enemies.")
        call SpellData.createSimple(Erza2R_ID, 5, 1, 2, Erza2R_DamageAgiBase, Erza2R_DamageAgiStep, T_Rad(Erza2R_DamageAoe) + T_Prop("Dash Range", Erza2R_Range), "Applies Fire debuff to enemies.")
        call SpellData.createSimple(Erza2T_ID, 1, 2, 2, Erza2T_DamageAgiBase, 0.0, T_Rad(Erza2T_DamageAoe), "Applies Water debuff to enemies.")

        // --- ФОРМА 3: FLIGHT ARMOR (E) ---
        call SpellData.create(Erza3Q_ID, 5, 2, 2, Erza3Q_DamageAgiBase, Erza3Q_DamageAgiStep, Erza3Q_Damage2StaticBase, Erza3Q_Damage2StaticStep, T_Rad(Erza3Q_DamageAoe), "")
        call SpellData.createUtility(Erza3W_ID, 5, T_Rad(Erza3W_Aoe) + "Area Duration: <L:" + FormatReal(Erza3W_AreaDurationBase) + "/" + FormatReal(Erza3W_AreaDurationBase+Erza3W_AreaDurationStep) + "/" + FormatReal(Erza3W_AreaDurationBase+Erza3W_AreaDurationStep*2) + "/" + FormatReal(Erza3W_AreaDurationBase+Erza3W_AreaDurationStep*3) + "/" + FormatReal(Erza3W_AreaDurationBase+Erza3W_AreaDurationStep*4) + "> sec", "After " + FormatReal(Erza3W_AbilityDelay) + " sec, restores <L:" + FormatReal(Erza3W_ManarestoreBase) + "/" + FormatReal(Erza3W_ManarestoreBase+Erza3W_ManarestoreStep) + "/" + FormatReal(Erza3W_ManarestoreBase+Erza3W_ManarestoreStep*2) + "/" + FormatReal(Erza3W_ManarestoreBase+Erza3W_ManarestoreStep*3) + "/" + FormatReal(Erza3W_ManarestoreBase+Erza3W_ManarestoreStep*4) + ">% Max Mana.|n|cFF00BFFFAura:|r Boosts allies' Speed, slows enemies, and summons a Lightning Elemental.")
        call SpellData.createUtility(Erza3E_ID, 5, T_Rad(Erza3E_Aoe), T_Bonus("Mana Shield", "Grants Damage Immunity to nearby allies. Channeling breaks if Mana falls below " + FormatReal(Erza3E_ManaShieldOff) + "%."))
        call SpellData.createSimple(Erza3R_ID, 5, 2, 2, Erza3R_DamageAgiBase, Erza3R_DamageAgiStep, T_Rad(Erza3R_DamageAoe) + T_Stun(Erza3R_Stun) + T_Dur("Duration", 2.12), "Deals damage every 1 sec.")
        call SpellData.createSimple(Erza3T_ID, 1, 2, 2, Erza3T_DamageAgiBase, 0.0, T_Rad(Erza3T_DamageAoe) + T_Prop("Range", Erza3T_Range) + T_Stun(Erza3T_Stun) + T_Push(Erza3T_PushDistance), "")

        // --- ФОРМА 4: LIGHTNING EMPRESS (R) / ELEMENTAL SWORDS ---
        call SpellData.create(Erza4Q_ID, 5, 1, 2, Erza4Q_DamageAgiBase, Erza4Q_DamageAgiStep, Erza4Q_Damage2StaticBase, Erza4Q_Damage2StaticStep, T_Rad(Erza4Q_DamageAoe), "")
        call SpellData.create(Erza4W_ID, 5, 1, 2, Erza4W_DamageAgiBase, Erza4W_DamageAgiStep, Erza4W_DamageStatic, 0.0, T_Rad(Erza4W_DamageAoe), "")
        call SpellData.createSimple(Erza4E_ID, 5, 1, 2, Erza4E_DamageAgiFastBase, Erza4E_DamageAgiFastStep, T_Rad(Erza4E_DamageAoe) + "Stun: " + FormatReal(Erza4E_Stun) + " sec per tick", T_Bonus("Chargeable", "3 Stacks: Casts instantly, grants Invulnerability, and deals Agility x <L:" + FormatReal(Erza4E_DamageAgiLongBase) + "/" + FormatReal(Erza4E_DamageAgiLongBase+Erza4E_DamageAgiLongStep) + "/" + FormatReal(Erza4E_DamageAgiLongBase+Erza4E_DamageAgiLongStep*2) + "/" + FormatReal(Erza4E_DamageAgiLongBase+Erza4E_DamageAgiLongStep*3) + "/" + FormatReal(Erza4E_DamageAgiLongBase+Erza4E_DamageAgiLongStep*4) + ">."))
        call SpellData.createSimple(Erza4R_ID, 5, 2, 2, Erza4R_DamageAgiBase, Erza4R_DamageAgiStep, T_Rad(Erza4R_DamageAoe), "")
        call SpellData.createSimple(Erza4T_ID, 1, 2, 2, Erza4T_DamageAgiBase, 0.0, T_Rad(Erza4T_DamageAoe) + T_Stun(Erza4T_Stun), T_Bonus("Benihizakura Buff", "Duration: " + FormatReal(Erza4TT_Duration) + " sec. Adds Agility x " + FormatReal(Erza4TT_AdditionalAgiDmgPerAtk) + " Magical Damage to auto-attacks."))
        call SpellData.createUtility(Erza4F_ID, 1, T_Dur("Duration", Erza4F_Duration), T_Bonus("Elemental Absorption", "Absorbs ambient elements or Natsu/Gray's magic to imbue swords.|n|cFFFFD7001 Element:|r +" + I2S(Erza4F_AttackDamageAdd_1Element) + " ATK, +" + FormatReal(Erza4F_AddErzaSpellDamage_1Element) + "% Spell DMG|n|cFFFFD7002 Elements:|r +" + I2S(Erza4F_AttackDamageAdd_2Element) + " ATK, +" + FormatReal(Erza4F_AddErzaSpellDamage_2Element) + "% Spell DMG|n|cFFFF4500Natsu + Gray:|r +" + I2S(Erza4F_AttackDamageAdd_NatsuGray) + " ATK, +" + FormatReal(Erza4F_AddErzaSpellDamage_NatsuGray) + "% Spell DMG"))

        // --- ФОРМА 5: NAKAGAMI (T) ---
        call SpellData.createSimple(Erza5Q_ID, 5, 1, 2, Erza5Q_DamageAgiBase, 0.0, T_Rad(Erza5Q_DamageAoe), "")
        call SpellData.createSimple(Erza5W_ID, 5, 1, 2, Erza5W_DamageAgiBase, 0.0, T_Rad(Erza5W_DamageAoe) + T_Prop("Sword Flight Distance", Erza5W_Range), "")
        call SpellData.createSimple(Erza5E_ID, 5, 2, 2, Erza5E_DamageAgiBase, 0.0, T_Rad(Erza5E_DamageAoe), T_Bonus("Nakagami Shield", "Grants Damage Immunity."))
        call SpellData.createSimple(Erza5R_ID, 5, 2, 2, Erza5R_DamageAgiBase, 0.0, T_Rad(Erza5R_DamageAoe), "")
        call SpellData.createSimple(Erza5T_ID, 1, 1, 2, Erza5T_DamageAgiBase, 0.0, T_Rad(Erza5T_DamageAoe) + T_Stun(Erza5T_Stun), "")
        call SpellData.createSimple(Erza5F_ID, 1, 1, 2, Erza5F_DamageAgiBase, 0.0, T_Rad(Erza5F_DamageAoe), "")

        // --- ФОРМА 6: PURGATORY (G1) ---
        call SpellData.createSimple(Erza6Q_ID, 5, 1, 2, Erza6Q_DamageAgiBase, 0.0, T_Rad(Erza6Q_DamageAoe) + T_Prop("Dash Range", Erza6Q_Range), "")
        call SpellData.createSimple(Erza6W_ID, 5, 1, 2, Erza6W_DamageAgiBase, 0.0, T_Rad(Erza6W_DamageAoe), "")
        call SpellData.createSimple(Erza6E_ID, 5, 1, 2, Erza6E_DamageAgiBase, 0.0, T_Rad(Erza6E_DamageAoe), T_Bonus("Passive", "Automatically triggers when an enemy enters " + I2S(R2I(Erza6E_RangePassiveWork)) + " range."))
        call SpellData.createUtility(Erza6R_ID, 5, T_Rad(Erza6R_Aoe) + T_Silence(Erza6R_Silence), "")
        call SpellData.createSimple(Erza6T_ID, 1, 1, 2, Erza6T_DamageAgiBase, 0.0, T_Rad(Erza6T_DamageAoe), "")

        // --- ФОРМА 7: CLEAR HEART CLOTHING (G2) ---
        call SpellData.createSimple(Erza7Q_ID, 5, 2, 2, Erza7Q_DamageAgiBase, 0.0, T_Rad(Erza7Q_DamageAoe) + T_Prop("Dash Range", Erza7Q_Range) + T_Push(Erza7Q_PushRange), "")
        call SpellData.createSimple(Erza7W_ID, 5, 2, 2, Erza7W_DamageAgiBase, 0.0, T_Rad(Erza7W_DamageAoe), "")
        call SpellData.createSimple(Erza7E_ID, 5, 2, 2, Erza7E_DamageAgiBase, 0.0, T_Rad(Erza7E_DamageAoe) + T_Stun(1.50), T_Bonus("Passive", "Automatically triggers when an enemy enters " + I2S(R2I(Erza7E_RangePassiveWork)) + " range."))
        call SpellData.createSimple(Erza7R_ID, 5, 2, 2, Erza7R_DamageAgiBase, 0.0, T_Rad(Erza7R_Aoe) + T_Push(Erza7R_PushRange), "Restores " + I2S(R2I(Erza7R_ManaRestore)) + "% Max Mana.")
        call SpellData.createSimple(Erza7T_ID, 1, 2, 2, Erza7T_DamageAgiBase, 0.0, T_Rad(Erza7T_DamageAoe) + T_Stun(Erza7T_Stun), "")

        // Регистрация всех 44 способностей Эрзы
        set form = HeroData.create(Erza_ID, 0, ErzaQ_ID, ErzaW_ID, ErzaE_ID, ErzaR_ID, ErzaT_ID, ErzaG_ID, ErzaG2_ID, Erza1Q_ID, Erza1W_ID, Erza1E_ID)
        call form.addExtra(Erza1R_ID, Erza1T_ID, Erza2Q_ID, Erza2W_ID, Erza2E_ID, Erza2R_ID, Erza2T_ID, Erza3Q_ID, Erza3W_ID, Erza3E_ID)
        call form.addExtra(Erza3R_ID, Erza3T_ID, Erza4Q_ID, Erza4W_ID, Erza4E_ID, Erza4R_ID, Erza4T_ID, Erza4F_ID, Erza5Q_ID, Erza5W_ID)
        call form.addExtra(Erza5E_ID, Erza5R_ID, Erza5T_ID, Erza5F_ID, Erza6Q_ID, Erza6W_ID, Erza6E_ID, Erza6R_ID, Erza6T_ID, Erza7Q_ID)
        call form.addExtra(Erza7W_ID, Erza7E_ID, Erza7R_ID, Erza7T_ID, 0, 0, 0, 0, 0, 0)
        
        call DestroyTimer(t)
    endfunction
    
    // ===========================================================================
    // Инициализация событий и фонового таймера
    // ===========================================================================
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        local integer i = 0
        
        set HT_DESC = InitHashtable()
        set HT_DATA = InitHashtable()
        set HT_TIMERS = InitHashtable()
        
        call InitTooltipFrameFix()

        set TOOLTIP_DAMAGE_TARGET = CreateUnit(Player(15), 'hfoo', 0.0, 0.0, 0.0)
        call ShowUnit(TOOLTIP_DAMAGE_TARGET, false)
        call PauseUnit(TOOLTIP_DAMAGE_TARGET, true)
        
        call TimerStart(CreateTimer(), 0.0, false, function InitHeroes_Part1)
        call TimerStart(CreateTimer(), 0.0, false, function InitHeroes_Part2)
        call TimerStart(CreateTimer(), 0.0, false, function InitHeroes_Part3)
        call TimerStart(CreateTimer(), 0.0, false, function InitHeroes_Part4)
        call TimerStart(CreateTimer(), 0.0, false, function InitHeroes_Part5)
        
        loop
            exitwhen i > 11
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_SELECTED, null)
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_HERO_LEVEL, null)
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_HERO_SKILL, null)
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_PICKUP_ITEM, null)
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_DROP_ITEM, null)
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_USE_ITEM, null)
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
            set i = i + 1
        endloop
        call TriggerAddAction(t, function OnHeroEvent)

        set POLL_TIMER = CreateTimer()
        call TimerStart(POLL_TIMER, POLL_PERIOD, true, function OnPollTimeout)
    endfunction
        
endlibrary
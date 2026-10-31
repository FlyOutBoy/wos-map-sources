library TooltipBuilder

    globals
        integer TooltipTextRevision = 0
        constant real TOOLTIP_BODY_FONT_SIZE = 0.0105
        constant real TOOLTIP_BODY_WIDTH = 0.270
        // Базовые цвета
        private constant string C_TITLE   = "|cffffcc00"
        private constant string C_LORE    = "|cffcccccc"
        private constant string C_ORANGE  = "|cffffa500" // Оранжевый для заголовков бонусов
        private constant string C_RESET   = "|r"
        
        // Цвета характеристик и урона
        private constant string C_PHYS    = "|cffff3333" // Красный (Физический)
        private constant string C_MAGIC   = "|cff33ccff" // Синий (Магический)
        private constant string C_TRUE    = "|cffffcc00" // Золотой (Чистый)
        private constant string C_STAT    = "|cffffcc00" // Золотой (Рендж, механики, КД)
        private constant string C_DECOR   = "|cffcc9966" // Светло-коричневый (Урон по декорациям)
    endglobals

    // One scan, copy only changed spans. An unchanged tooltip returns its input.
    function TooltipCleanText takes string text returns string
        local integer i = 0
        local integer n = StringLength(text)
        local integer start = 0
        local integer skip
        local string result = ""
        local string replacement
        local string after
        loop
            exitwhen i >= n
            set skip = 0
            if SubString(text, i, i + 1) == " " then
                set replacement = "%"
                if SubString(text, i, i + 4) == " + 0" or SubString(text, i, i + 4) == " - 0" then
                    set after = SubString(text, i + 4, i + 5)
                    if after == "" or after == " " or after == "|" or after == ")" or after == "," then
                        set skip = 4
                        set replacement = ""
                    endif
                elseif SubString(text, i, i + 18) == " percentage points" then
                    set skip = 18
                elseif SubString(text, i, i + 17) == " percentage point" then
                    set skip = 17
                elseif SubString(text, i, i + 8) == " percent" then
                    set after = SubString(text, i + 8, i + 10)
                    if i + 8 == n or SubString(after, 0, 1) == " " or SubString(after, 0, 1) == "." or after == "|n" then
                        set skip = 8
                    endif
                endif
            endif
            if skip > 0 then
                set result = result + SubString(text, start, i) + replacement
                set i = i + skip
                set start = i
            else
                set i = i + 1
            endif
        endloop
        if start == 0 then
            return text
        endif
        return result + SubString(text, start, n)
    endfunction

    // Property labels authored as plain mechanics use the same gold as addRange.
    function TooltipGoldMechanicLine takes string text returns string
        local integer i = 0
        local integer size = StringLength(text)
        if SubString(text, 0, 2) == "|c" or SubString(text, 0, 1) == "[" then
            return text
        endif
        loop
            exitwhen i >= size or i > 40
            if SubString(text, i, i + 1) == ":" then
                return "|cffffcc00" + SubString(text, 0, i + 1) + "|r" + SubString(text, i + 1, size)
            endif
            set i = i + 1
        endloop
        return text
    endfunction

    function TooltipGoldMechanics takes string text returns string
        local integer i = 0
        local integer start = 0
        local integer copied = 0
        local integer size = StringLength(text)
        local string result = ""
        local string line
        local string colored
        loop
            exitwhen i > size
            if i == size or SubString(text, i, i + 2) == "|n" then
                set line = SubString(text, start, i)
                set colored = TooltipGoldMechanicLine(line)
                if colored != line then
                    set result = result + SubString(text, copied, start) + colored
                    set copied = i
                endif
                set i = i + 2
                set start = i
            else
                set i = i + 1
            endif
        endloop
        if copied == 0 then
            return text
        endif
        return result + SubString(text, copied, size)
    endfunction

    struct TooltipBuilder
        private string buffer
        private string normalizedBuffer
        private boolean hasStats

        static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            set this.buffer = ""
            set this.normalizedBuffer = ""
            set this.hasStats = false
            return this
        endmethod

        // Lore colour for free text; inline coloured labels resume it after their |r.
        private static method lore takes string text returns string
            local integer i = 0
            local integer start = 0
            local integer len = StringLength(text)
            local string res = ""
            local string pair
            if text == "" or text == null then
                return ""
            endif
            loop
                exitwhen i >= len
                set pair = SubString(text, i, i + 2)
                if pair == "|r" or pair == "|R" then
                    set res = res + SubString(text, start, i) + "|r" + C_LORE
                    set i = i + 2
                    set start = i
                else
                    set i = i + 1
                endif
            endloop
            if start == 0 then
                return C_LORE + text + C_RESET
            endif
            return C_LORE + res + SubString(text, start, len) + C_RESET
        endmethod

        method addTitle takes string title returns thistype
            set this.buffer = this.buffer + C_TITLE + title + C_RESET
            return this
        endmethod
        
        method addDescription takes string text returns thistype
            if (text != "") then
                if (this.buffer != "") then
                    set this.buffer = this.buffer + "|n"
                endif
                set this.buffer = this.buffer + thistype.lore(text)
            endif
            return this
        endmethod

        method addBonus takes string text returns thistype
            local integer len
            if (text != "" and text != null) then
                set len = StringLength(text)
                loop
                    exitwhen len < 2 or SubString(text, 0, 2) != "|n"
                    set text = SubString(text, 2, len)
                    set len = len - 2
                endloop
                loop
                    exitwhen len < 2 or SubString(text, len - 2, len) != "|n"
                    set text = SubString(text, 0, len - 2)
                    set len = len - 2
                endloop

                if (text != "") then
                    if (this.buffer != "") then
                        set this.buffer = this.buffer + "|n|n" + thistype.lore(text)
                    else
                        set this.buffer = thistype.lore(text)
                    endif
                endif
            endif
            return this
        endmethod

        method addIframe takes string text returns thistype
            if text != "" and text != null then
                if this.buffer != "" then
                    set this.buffer = this.buffer + "|n"
                endif
                set this.buffer = this.buffer + text
            endif
            return this
        endmethod

        private method checkFirstStat takes nothing returns nothing
            if not this.hasStats then
                set this.hasStats = true
                if (this.buffer != "") then
                    set this.buffer = this.buffer + "|n"
                endif
            endif
        endmethod

        method addDamage takes integer dmgType, string value returns thistype
            local string color = ""
            local string name = ""
            
            if (dmgType == 1) then
                set color = C_PHYS
                set name = "Phys. Damage:"
            elseif (dmgType == 2) then
                set color = C_MAGIC
                set name = "Mag. Damage:"
            elseif (dmgType == 3) then
                set color = C_TRUE
                set name = "True Damage:"
            elseif (dmgType == 4) then
                set color = C_PHYS
                set name = "Attack Damage:"
            else
                set color = C_STAT
                set name = "Damage:"
            endif

            call this.checkFirstStat()
            set this.buffer = this.buffer + "|n" + color + name + "|r " + value
            return this
        endmethod

        method addCustomDamage takes integer dmgType, string name, string value returns thistype
            local string color = ""
            
            if (dmgType == 1) then
                set color = C_PHYS
            elseif (dmgType == 2) then
                set color = C_MAGIC
            elseif (dmgType == 3) then
                set color = C_TRUE
            else
                set color = C_STAT
            endif

            call this.checkFirstStat()
            set this.buffer = this.buffer + "|n" + color + name + "|r " + value
            return this
        endmethod

        method addRange takes string rangeValue returns thistype
            if (rangeValue != "" and rangeValue != "0") then
                call this.checkFirstStat()
                set this.buffer = this.buffer + "|n" + C_STAT + "Range:|r " + rangeValue
            endif
            return this
        endmethod

        method addMechanic takes string text returns thistype
            local integer len
            set text = TooltipGoldMechanics(text)
            if (text != "" and text != null) then
                call this.checkFirstStat()
                set len = StringLength(text)
                loop
                    exitwhen len < 2 or SubString(text, len - 2, len) != "|n"
                    set text = SubString(text, 0, len - 2)
                    set len = len - 2
                endloop

                if (text != "") then
                    if StringLength(text) >= 2 and SubString(text, 0, 2) == "|n" then
                        set this.buffer = this.buffer + text
                    else
                        set this.buffer = this.buffer + "|n" + text
                    endif
                endif
            endif
            return this
        endmethod
        
        method addCooldownEx takes string cdValue, boolean afterDur returns thistype
            if (cdValue != "" and cdValue != "0") then
                call this.checkFirstStat()
                if afterDur then
                    set this.buffer = this.buffer + "|n" + C_STAT + "CD:|r " + cdValue + " sec (After duration)"
                else
                    set this.buffer = this.buffer + "|n" + C_STAT + "CD:|r " + cdValue + " sec"
                endif
            endif
            return this
        endmethod

        method addCooldown takes string cdValue returns thistype
            return this.addCooldownEx(cdValue, false)
        endmethod

        method addDecorDamage takes string val returns thistype
            if (val != "" and val != "0") then
                call this.checkFirstStat()
                set this.buffer = this.buffer + "|n" + C_DECOR + "Decor Damage:|r " + val
            endif
            return this
        endmethod

        method addMana takes string manaValue returns thistype
            if (manaValue != "" and manaValue != "0") then
                call this.checkFirstStat()
                set this.buffer = this.buffer + "|n" + C_MAGIC + "Mana:|r " + manaValue
            endif
            return this
        endmethod

        private method normalize takes nothing returns nothing
            if this.buffer != this.normalizedBuffer then
                set this.buffer = TooltipCleanText(this.buffer)
                set this.normalizedBuffer = this.buffer
            endif
        endmethod

        method applyToAbility takes integer abilCode, integer level returns nothing
            call this.normalize()
            if BlzGetAbilityExtendedTooltip(abilCode, level - 1) != this.buffer then
                call BlzSetAbilityExtendedTooltip(abilCode, this.buffer, level - 1)
                set TooltipTextRevision = TooltipTextRevision + 1
            endif
        endmethod
        
        method applyToAbilityLearn takes integer abilCode, integer level returns nothing
            call this.normalize()
            if BlzGetAbilityResearchExtendedTooltip(abilCode, level - 1) != this.buffer then
                call BlzSetAbilityResearchExtendedTooltip(abilCode, this.buffer, level - 1)
                set TooltipTextRevision = TooltipTextRevision + 1
            endif
        endmethod

        method applyToItem takes item it returns nothing
            call this.normalize()
            if BlzGetItemExtendedTooltip(it) != this.buffer then
                call BlzSetItemExtendedTooltip(it, this.buffer)
            endif
        endmethod

        method get takes nothing returns string
            call this.normalize()
            return this.buffer
        endmethod

        method destroy takes nothing returns nothing
            set this.normalizedBuffer = null
            set this.buffer = null
            call this.deallocate()
        endmethod
    endstruct

endlibrary

library TooltipBuilder

    globals
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

    struct TooltipBuilder
        private string buffer
        private boolean hasStats

        static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            set this.buffer = ""
            set this.hasStats = false
            return this
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
                set this.buffer = this.buffer + text
            endif
            return this
        endmethod

        method addBonus takes string text returns thistype
            local integer len
            if (text != "" and text != null) then
                set len = StringLength(text)
                loop
                    exitwhen len < 2 or SubString(text, len - 2, len) != "|n"
                    set text = SubString(text, 0, len - 2)
                    set len = len - 2
                endloop

                if (text != "") then
                    if (this.buffer != "") then
                        set this.buffer = this.buffer + "|n|n" + text
                    else
                        set this.buffer = text
                    endif
                endif
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

        method applyToAbility takes integer abilCode, integer level returns nothing
            call BlzSetAbilityExtendedTooltip(abilCode, this.buffer, level - 1)
        endmethod
        
        method applyToAbilityLearn takes integer abilCode, integer level returns nothing
            call BlzSetAbilityResearchExtendedTooltip(abilCode, this.buffer, level - 1)
        endmethod

        method applyToItem takes item it returns nothing
            call BlzSetItemExtendedTooltip(it, this.buffer)
        endmethod

        method get takes nothing returns string
            return this.buffer
        endmethod

        method destroy takes nothing returns nothing
            set this.buffer = null
            call this.deallocate()
        endmethod
    endstruct



    

endlibrary
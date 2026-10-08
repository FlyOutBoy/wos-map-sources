
function Trig_PhysRes_Actions takes nothing returns nothing
    local string text = GetEventPlayerChatString()
    local integer length = StringLength(text)
    local integer pos = 3
    local integer i = GetPlayerId(GetTriggerPlayer())
    local integer unitHid
    local real r
    local unit d = null

    if TestMode then
        if HeroChosen[i] != null then
            set d = HeroChosen[i]
        else
            set d = Hero[i]
        endif

        if d != null then
            set unitHid = GetHandleId(d)

            // Пропускаем пробелы после -pr.
            loop
                exitwhen pos >= length or SubString(text, pos, pos + 1) != " "
                set pos = pos + 1
            endloop

            if pos < length then
                // Есть значение, включая явный ноль.
                set r = S2R(SubString(text, pos, length))

                if r < 0.0 then
                    set r = 0.0
                elseif r > 100.0 then
                    set r = 100.0
                endif

                call SaveReal(hs, unitHid, KEY_PHYS_RES, r / 100.0)

                call DisplayTimedTextFromPlayer(Player(i),0,0,1, /*
                */ "|c00FF0303Physical resist of|r |c00FFFF00" /*
                */ + GetUnitName(d) /*
                */ + "|r |c002F63FFset to:|r |c00FFFF00" /*
                */ + R2S(r) + "%|r")
            else
                // Просто -mr: удаляем значение полностью.
                call RemoveSavedReal(hs, unitHid, KEY_PHYS_RES)

                call DisplayTimedTextFromPlayer(Player(i),0,0,1, /*
                */ "|c00FF0303Physical resist override removed from|r |c00FFFF00" /*
                */ + GetUnitName(d) + "|r")
            endif
        endif
    endif

    set d = null
endfunction
//===========================================================================
function InitTrig_PhysRes takes nothing returns nothing
    local trigger PR = CreateTrigger( )
    local integer i = 0
    loop
        exitwhen i == 13
        call TriggerRegisterPlayerChatEvent( PR, Player(i), "-pr", false )
       set i = i + 1
    endloop
    call TriggerAddAction( PR, function Trig_PhysRes_Actions )
    set PR = null
endfunction

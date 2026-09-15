library GearSystems2 initializer InitGearSystems2 uses TasAbilityChargeBox
globals
    framehandle array FrameCD_Icon
    framehandle array FrameCD_Cooldown
    unit array FrameCD_Unit
    integer array FrameCD_AbilId
    integer array SlotPosX
    integer array SlotPosY
    timer AllyCD_Timer = CreateTimer()

    integer ItemProcDamageDepth = 0

    // Перед входом в DamageBlock значение копируется в его локальную переменную.
    // Это сохраняет совместимость старой сигнатуры DamageBlock с остальной картой.
    real DamageShieldPierceTriggerDamage = 0.0
    constant integer DAMAGE_SHIELD_TYPE_ALL = -1
    constant integer DAMAGE_SHIELD_TYPE_ATTACK = 0
    constant integer DAMAGE_SHIELD_TYPE_MAGIC = 1
    constant integer DAMAGE_SHIELD_TYPE_PHYSICAL = 2
    constant integer DAMAGE_SHIELD_TYPE_NON_MAGIC = 3

    timer GearTimer03
    timer GearTimer05
    timer GearTimer10
    code GearTimer03Callback
    code GearTimer05Callback
    code GearTimer10Callback
    integer GearTimer03Users
    integer GearTimer05Users
    integer GearTimer10Users

    hashtable hs = InitHashtable()
    unit array DummyPlayer
    integer FakeAbi_ID = 'A06H'
endglobals

function HasCachedItem takes unit u, integer itemId returns integer
    if LoadBoolean(ItemCache, GetHandleId(u), itemId) then
        return 1
    endif

    return 0
endfunction
function RoundReal takes real r, integer digits returns real
    local real factor    
    // Р СџРЎР‚РЎРЏР СР В°РЎРЏ Р С—Р С•Р Т‘РЎРѓРЎвЂљР В°Р Р…Р С•Р Р†Р С”Р В° Р СР Р…Р С•Р В¶Р С‘РЎвЂљР ВµР В»РЎРЏ Р В±РЎвЂ№РЎРѓРЎвЂљРЎР‚Р ВµР Вµ, РЎвЂЎР ВµР С Р Р†РЎвЂ№Р В·Р С•Р Р† Pow
    if digits == 2 then
        set factor = 100.0
    elseif digits == 3 then
        set factor = 1000.0
    elseif digits == 1 then
        set factor = 10.0
    else
        set factor = Pow(10.0, I2R(digits)) // Р СњР В° РЎРѓР В»РЎС“РЎвЂЎР В°Р в„–, Р ВµРЎРѓР В»Р С‘ Р В·Р Р…Р В°Р С”Р С•Р Р† Р В±РЎС“Р Т‘Р ВµРЎвЂљ Р В±Р С•Р В»РЎРЉРЎв‚¬Р Вµ
    endif
    if r >= 0.0 then
    return I2R(R2I(r * factor + 0.5)) / factor
endif
return I2R(R2I(r * factor - 0.5)) / factor
endfunction
 function CheckCoordsInRect takes rect rec, real x, real y returns boolean
        local real c1 = GetRectMinX(rec)
        local real c2 = GetRectMaxX(rec)
        local real c3 = GetRectMinY(rec)
        local real c4 = GetRectMaxY(rec)
        return (c1 <= x) and (x <= c2) and (c3 <= y) and (y <= c4)
    endfunction

  function IsItemInInventory3 takes unit u, integer it1 returns integer
        local integer i = 0
        local item ti
        local integer count = -1
        local integer count2 = 0
        local integer gold = 0
        loop
            exitwhen i > 5 or count != -1
            set ti = UnitItemInSlot(u, i)
            if GetItemTypeId(ti) == it1  then
                set count = i
            endif
            set i = i + 1
        endloop
        set ti = null
        return count
    endfunction

function MakeSound takes string s returns nothing
        local sound snd
        set s = s + ".mp3"
        set snd = CreateSound(s, false, false, false, 0, 0, "DefaultEAXON")
        if BankaiActive  then 
        call SetSoundVolume( snd, 40 )
        else
        call SetSoundVolume( snd, 127 )
        endif
        call StartSound(snd)
        call KillSoundWhenDone(snd)
        set snd = null
    endfunction

 function AinzF_GetBuffStage takes unit whichUnit returns integer
        if whichUnit == null then
            return 0
        endif
        if GetUnitAbilityLevel(whichUnit, AinzF_Buff6_ID) > 0 then
            return 6
        elseif GetUnitAbilityLevel(whichUnit, AinzF_Buff5_ID) > 0 then
            return 5
        elseif GetUnitAbilityLevel(whichUnit, AinzF_Buff4_ID) > 0 then
            return 4
        elseif GetUnitAbilityLevel(whichUnit, AinzF_Buff3_ID) > 0 then
            return 3
        elseif GetUnitAbilityLevel(whichUnit, AinzF_Buff2_ID) > 0 then
            return 2
        elseif GetUnitAbilityLevel(whichUnit, AinzF_Buff1_ID) > 0 then
            return 1
        endif
        return 0
    endfunction

    function AinzF_HasActiveHealBuff takes unit whichUnit returns boolean
        return AinzF_GetBuffStage(whichUnit) >= 4
    endfunction

    function HealTT takes unit c,unit td, real r, real start_height returns nothing
    local real random1 = 80
    local real scale = 0.018
    local integer k = 0
    local real x = GetUnitX(td)
    local real y = GetUnitY(td)
    local real random2 = GetRandomReal(0, 359) * bj_DEGTORAD
    local texttag t
    local boolean b = false 
    
   
    if GetUnitState(td, UNIT_STATE_LIFE) + r < GetUnitState(td, UNIT_STATE_MAX_LIFE) then 
    set b = true
    elseif (GetUnitState(td, UNIT_STATE_MAX_LIFE)-GetUnitState(td, UNIT_STATE_LIFE))>=1 then
    set b = true
    endif
    if IsUnitType(td,UNIT_TYPE_DEAD) then 
    set b = false
    endif
    if b then 
    set t = CreateTextTag()
    call SetTextTagLifespan(t, 0.9) // РЎвЂЎР ВµРЎР‚Р ВµР В· 0.5 РЎРѓР ВµР С” РЎС“Р Т‘Р В°Р В»Р С‘РЎвЂљРЎРѓРЎРЏ
    call SetTextTagFadepoint(t, 0.45) // Р С”Р С•Р С–Р Т‘Р В° Р Р…Р В°РЎвЂЎР Р…Р ВµРЎвЂљ Р С—Р В»Р В°Р Р†Р Р…Р С• Р С‘РЎРѓРЎвЂЎР ВµР В·Р В°РЎвЂљРЎРЉ
    call SetTextTagPos(t, x , y, start_height) // Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎРЏ (Р Р…Р В°Р С—РЎР‚Р С‘Р СР ВµРЎР‚ Р Р…Р В° РЎР‹Р Р…Р С‘РЎвЂљР Вµ)
    call SetTextTagText(t,"|c002EFE01+" + I2S(R2I(r+0.5)), scale) // РЎРѓР В°Р С РЎвЂљР ВµР С”РЎРѓРЎвЂљ Р С‘ РЎР‚Р В°Р В·Р СР ВµРЎР‚
    call SetTextTagPermanent(t, false) // Р Т‘Р ВµР В»Р В°Р ВµР С Р Р…Р ВµР С—Р С•РЎРѓРЎвЂљР С•РЎРЏР Р…Р Р…РЎвЂ№Р С
    call SetTextTagVelocity(t, 0, 0.1)
    call SetTextTagVisibility(t,false)
    /*loop
    exitwhen k >10 
    if IsUnitVisible(c,Player(k)) then 
    if GetLocalPlayer() == Player(k) then 
    call SetTextTagVisibility(t,true)
    endif
    endif
    set k = k + 1
    endloop
    */    
    if GetLocalPlayer() == GetOwningPlayer(c) then 
    call SetTextTagVisibility(t,true)
    endif
    if GetLocalPlayer() == GetOwningPlayer(td) then 
    call SetTextTagVisibility(t,true)
    endif
    endif
    set t = null
    endfunction
    function HealMpTT takes unit c,unit td, real r, real start_height returns nothing
    local real random1 = 80
    local real scale = 0.018
    local integer k = 0
    local real x = GetUnitX(td)+75*Cos(180*bj_DEGTORAD)
    local real y = GetUnitY(td)+75*Sin(180*bj_DEGTORAD)
    local real random2 = GetRandomReal(0, 359) * bj_DEGTORAD
    local texttag t
    local boolean b = false 
    if GetUnitState(td, UNIT_STATE_MANA) + r < GetUnitState(td, UNIT_STATE_MAX_MANA) then 
    set b = true
    elseif r>0 and(GetUnitState(td, UNIT_STATE_MAX_MANA)-GetUnitState(td, UNIT_STATE_MANA))>=1 then
    set b = true
    elseif r<0 then
    set b = true
    endif
    
    if IsUnitType(td,UNIT_TYPE_DEAD) then 
    set b = false
    endif
    if b then 
    set t = CreateTextTag()
    call SetTextTagLifespan(t, 0.9) // РЎвЂЎР ВµРЎР‚Р ВµР В· 0.5 РЎРѓР ВµР С” РЎС“Р Т‘Р В°Р В»Р С‘РЎвЂљРЎРѓРЎРЏ
    call SetTextTagFadepoint(t, 0.45) // Р С”Р С•Р С–Р Т‘Р В° Р Р…Р В°РЎвЂЎР Р…Р ВµРЎвЂљ Р С—Р В»Р В°Р Р†Р Р…Р С• Р С‘РЎРѓРЎвЂЎР ВµР В·Р В°РЎвЂљРЎРЉ
    call SetTextTagPos(t, x , y, start_height) // Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎРЏ (Р Р…Р В°Р С—РЎР‚Р С‘Р СР ВµРЎР‚ Р Р…Р В° РЎР‹Р Р…Р С‘РЎвЂљР Вµ)
    if r<0 then 
    call SetTextTagText(t,"|c004272FF-" + I2S(R2I(r+0.5)), scale) // РЎРѓР В°Р С РЎвЂљР ВµР С”РЎРѓРЎвЂљ Р С‘ РЎР‚Р В°Р В·Р СР ВµРЎР‚
    else
    call SetTextTagText(t,"|c004272FF+" + I2S(R2I(r+0.5)), scale) // РЎРѓР В°Р С РЎвЂљР ВµР С”РЎРѓРЎвЂљ Р С‘ РЎР‚Р В°Р В·Р СР ВµРЎР‚
    endif
    call SetTextTagPermanent(t, false) // Р Т‘Р ВµР В»Р В°Р ВµР С Р Р…Р ВµР С—Р С•РЎРѓРЎвЂљР С•РЎРЏР Р…Р Р…РЎвЂ№Р С
    call SetTextTagVelocity(t, 0, 0.1)
    call SetTextTagVisibility(t,false)
    /*loop
    exitwhen k >10 
    if IsUnitVisible(c,Player(k)) then 
    if GetLocalPlayer() == Player(k) then 
    call SetTextTagVisibility(t,true)
    endif
    endif
    set k = k + 1
    endloop
    */
    if GetLocalPlayer() == GetOwningPlayer(c) then 
    call SetTextTagVisibility(t,true)
    endif
    if GetLocalPlayer() == GetOwningPlayer(td) then 
    call SetTextTagVisibility(t,true)
    endif
    endif
    set t = null
    endfunction
function SetHpCurrent2 takes unit c,unit td, real r returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(c))
    local real hp
    if GetUnitAbilityLevel(td,'B01Q')> 0 then 
        set r = r * (1-(DarkHolyGrail_HpRegenReduce/100))
    endif
    if AinzF_HasActiveHealBuff(td) then
            set r = r * 1.1
        endif
    if GetUnitAbilityLevel(td,'B00K')>0 then  // inori T virus
        set r = r *0.6
        endif
    if GetUnitAbilityLevel(td,'B02F')> 0 then 
    set r =r * 0.51
    elseif GetUnitAbilityLevel(td,'B02E')> 0 then 
    set r =r * 0.58
    elseif GetUnitAbilityLevel(td,'B01W')> 0 then 
    set r =r * 0.65
    elseif GetUnitAbilityLevel(td,'B01V')> 0 then
    set r =r * 0.72
    elseif GetUnitAbilityLevel(td,'B01U')> 0 then
    set r =r * 0.79
    elseif GetUnitAbilityLevel(td,'B01T')> 0 then
    set r =r * 0.86
    elseif GetUnitAbilityLevel(td,'B01S')> 0 then
    set r =r * 0.93
    endif
    // РЎР‚Р ВµР В°Р В»РЎРЉР Р…РЎвЂ№Р в„– Р С—РЎР‚Р С‘РЎР‚Р С•РЎРѓРЎвЂљ РІР‚вЂќ Р Р…Р Вµ Р В±Р С•Р В»РЎРЉРЎв‚¬Р Вµ Р Р…Р ВµР Т‘Р С•РЎРѓРЎвЂљР В°РЎР‹РЎвЂ°Р ВµР С–Р С• HP
    set hp = RMinBJ(r, GetUnitState(td, UNIT_STATE_MAX_LIFE) - GetUnitState(td, UNIT_STATE_LIFE))
    if CheckCoordsInRect(gg_rct_Base,GetUnitX(td),GetUnitY(td)) == false and hp> 0 then 
        call HealTT(c,td,hp,150)
    endif
    set PlayerHeal[i] = PlayerHeal[i] + R2I(hp)
    set PlayerHealAll[i] = PlayerHealAll[i] + R2I(hp)
    call SetUnitState(td, UNIT_STATE_LIFE, GetUnitState(td, UNIT_STATE_LIFE) + r)
endfunction

function SetMpCurrent takes unit c, real r returns nothing
    local real mp
    if GetUnitAbilityLevel(c,'B00K')>0 then  // inori T virus
        set r = r *0.75
        endif
    // РЎР‚Р ВµР В°Р В»РЎРЉР Р…РЎвЂ№Р в„– Р С—РЎР‚Р С‘РЎР‚Р С•РЎРѓРЎвЂљ РІР‚вЂќ Р Р…Р Вµ Р В±Р С•Р В»РЎРЉРЎв‚¬Р Вµ Р Р…Р ВµР Т‘Р С•РЎРѓРЎвЂљР В°РЎР‹РЎвЂ°Р ВµР в„– Р СР В°Р Р…РЎвЂ№
    set mp = RMinBJ(r, GetUnitState(c, UNIT_STATE_MAX_MANA) - GetUnitState(c, UNIT_STATE_MANA))
    if CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c)) == false and mp> 0  then 
        call HealMpTT(c,c,mp,150)
    endif
    call SetUnitState(c, UNIT_STATE_MANA, GetUnitState(c, UNIT_STATE_MANA) + r)
endfunction

    function EffVision takes effect e, unit c returns nothing
        local integer k = 0
        loop
            exitwhen k == bj_MAX_PLAYER_SLOTS
            if IsUnitVisible(c, Player(k)) then
                if GetLocalPlayer() == Player(k) then
                    call BlzSetSpecialEffectAlpha(e, 255)
                endif
            else
                if GetLocalPlayer() == Player(k) then
                    call BlzSetSpecialEffectAlpha(e, 0)
                endif
            endif
            set k = k + 1
        endloop
    endfunction

function GetSlotContext takes integer pid, integer slot returns integer
    return pid * 10 + slot
endfunction

// Р вЂ”Р В°Р Т‘Р В°Р в„– Р Р…РЎС“Р В¶Р Р…РЎвЂ№Р Вµ X/Y РЎРЏРЎвЂЎР ВµР в„–Р С”Р С‘ Р С”Р С•Р СР В°Р Р…Р Т‘Р Р…Р С•Р в„– РЎРѓР ВµРЎвЂљР С”Р С‘ Р С—Р С•Р Т‘ Q W E R T F G
// (РЎвЂљР Вµ Р В¶Р Вµ Р В·Р Р…Р В°РЎвЂЎР ВµР Р…Р С‘РЎРЏ, РЎвЂЎРЎвЂљР С• РЎРѓРЎвЂљР В°Р Р†Р С‘РЎв‚¬РЎРЉ Р Р† Object Editor -> Art - Button Position)
function InitSlotGridPositions takes nothing returns nothing
    set SlotPosX[0] = 0
    set SlotPosY[0] = 0 // Q
    set SlotPosX[1] = 1
    set SlotPosY[1] = 0 // W
    set SlotPosX[2] = 2
    set SlotPosY[2] = 0 // E
    set SlotPosX[3] = 3
    set SlotPosY[3] = 0 // R
    set SlotPosX[4] = 0
    set SlotPosY[4] = 1 // T
    set SlotPosX[5] = 1
    set SlotPosY[5] = 1 // F
    set SlotPosX[6] = 2
    set SlotPosY[6] = 1 // G
endfunction
function GetSlotByXY takes integer x, integer y returns integer
    return y * 4 + x
endfunction
// ---------- Р РЋР С•Р В·Р Т‘Р В°Р Р…Р С‘Р Вµ РЎвЂћРЎР‚Р ВµР в„–Р СР В° Р Т‘Р В»РЎРЏ РЎРѓР В»Р С•РЎвЂљР В° ----------
function CreateAllyCDFrame_Slot takes integer pid, integer slot returns nothing
    local integer ctx = GetSlotContext(pid, slot)
    local integer originSlot = GetSlotByXY(SlotPosX[slot], SlotPosY[slot])
    local framehandle origin = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, originSlot)

    if FrameCD_Icon[ctx] == null then
        // Р ВР С”Р С•Р Р…Р С”Р В° РІР‚вЂќ Р С”Р В»Р С•Р Р… Р С—Р С•Р Т‘РЎвЂљР Р†Р ВµРЎР‚Р В¶Р Т‘РЎвЂР Р…Р Р…Р С• РЎР‚Р В°Р В±Р С•РЎвЂЎР ВµР С–Р С• РЎв‚¬Р В°Р В±Р В»Р С•Р Р…Р В°
        set FrameCD_Icon[ctx] = BlzCreateFrameByType("SIMPLEFRAME", "AllyIcon", origin, "2Face", 0)
        call BlzFrameClearAllPoints(FrameCD_Icon[ctx])
        call BlzFrameSetAllPoints(FrameCD_Icon[ctx], origin) // РЎР‚Р В°РЎРѓРЎвЂљРЎРЏР С–Р С‘Р Р†Р В°Р ВµР С РЎР‚Р С•Р Р†Р Р…Р С• Р Р…Р В° Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎР‹ origin-РЎРѓР В»Р С•РЎвЂљР В°
        call BlzFrameSetVisible(FrameCD_Icon[ctx], false)

        // Р С™РЎС“Р В»Р Т‘Р В°РЎС“Р Р…-РЎРѓР Р†Р В°Р в„–Р С— РІР‚вЂќ Р С”Р В»Р С•Р Р… Р С—Р В°РЎР‚Р Р…Р С•Р С–Р С• РЎв‚¬Р В°Р В±Р В»Р С•Р Р…Р В° "2Cooldown"
        set FrameCD_Cooldown[ctx] = BlzCreateFrameByType("SIMPLEFRAME", "AllyCD", origin, "2Cooldown", 0)
        call BlzFrameClearAllPoints(FrameCD_Cooldown[ctx])
        call BlzFrameSetAllPoints(FrameCD_Cooldown[ctx], origin)
        call BlzFrameSetMinMaxValue(FrameCD_Cooldown[ctx], 0, 1)
        call BlzFrameSetValue(FrameCD_Cooldown[ctx], 0)
        call BlzFrameSetVisible(FrameCD_Cooldown[ctx], false)
    endif
endfunction

// ---------- Р СџР С•Р С”Р В°Р В· РЎРѓР В»Р С•РЎвЂљР В° ----------
function ShowAllyCD_Slot takes integer pid, integer slot, unit u, integer abilId returns nothing
    local integer ctx = GetSlotContext(pid, slot)

    call CreateAllyCDFrame_Slot(pid, slot)

    set FrameCD_Unit[ctx]   = u
    set FrameCD_AbilId[ctx] = abilId

    call BlzFrameSetTexture(FrameCD_Icon[ctx], BlzGetAbilityIcon(abilId), 0, true)
    call BlzFrameSetVisible(FrameCD_Icon[ctx], true)
    call BlzFrameSetVisible(FrameCD_Cooldown[ctx], true)
endfunction

function HideAllyCD_Slot takes integer pid, integer slot returns nothing
    local integer ctx = GetSlotContext(pid, slot)
    if FrameCD_Icon[ctx] != null then
        call BlzFrameSetVisible(FrameCD_Icon[ctx], false)
        call BlzFrameSetVisible(FrameCD_Cooldown[ctx], false)
    endif
    set FrameCD_Unit[ctx] = null
endfunction

// ---------- Р СћР В°Р в„–Р СР ВµРЎР‚ РЎРѓР Р†Р В°Р в„–Р С—Р В° ----------
function Timer_UpdateAllyCD takes nothing returns nothing
    local integer pid = 0
    local integer slot
    local integer ctx
    local unit u
    local real full
    local real left

    loop
        exitwhen pid > 23
        set slot = 0
        loop
            exitwhen slot > 6
            set ctx = GetSlotContext(pid, slot)
            set u = FrameCD_Unit[ctx]
            if u != null then
                set full = BlzGetUnitAbilityCooldown(u, FrameCD_AbilId[ctx], GetUnitAbilityLevel(u, FrameCD_AbilId[ctx]) - 1)
                set left = BlzGetUnitAbilityCooldownRemaining(u, FrameCD_AbilId[ctx])
                if full > 0 and left > 0 then
                    call BlzFrameSetValue(FrameCD_Cooldown[ctx], left / full)
                else
                    call BlzFrameSetValue(FrameCD_Cooldown[ctx], 0)
                endif
            endif
            set slot = slot + 1
        endloop
        set pid = pid + 1
    endloop
endfunction

function InitAllyCDTimer takes nothing returns nothing
    call InitSlotGridPositions()
    call TimerStart(AllyCD_Timer, 0.05, true, function Timer_UpdateAllyCD)
endfunction

    function GetEffX takes effect eff returns real
        return BlzGetLocalSpecialEffectX(eff)
    endfunction
    function GetEffY takes effect eff returns real
        return BlzGetLocalSpecialEffectY(eff)
    endfunction
    function Parabola takes real h, real d, real x returns real
        return (4 * h / d) * (d - x) * (x / d)
    endfunction
    function SR0 takes real x1, real y1, real x2, real y2 returns real //Square root, distance between coords
        return SquareRoot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    endfunction
    function SR2 takes unit c, unit td returns real //Square root, distance between units
        local real x1 = GetUnitX(c)
        local real y1 = GetUnitY(c)
        local real x2 = GetUnitX(td)
        local real y2 = GetUnitY(td)
        return SquareRoot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    endfunction
    function SR3 takes unit c, real x2, real y2 returns real //Square root, distance between unit and coords
        local real x1 = GetUnitX(c)
        local real y1 = GetUnitY(c)
        return SquareRoot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    endfunction
    function SR5 takes effect c, real x2, real y2 returns real //Square root, distance between unit and coords
        local real x1 = GetEffX(c)
        local real y1 = GetEffY(c)
        return SquareRoot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    endfunction
    function GAngle takes unit c, unit d returns real //Angle between units in radians
        return Atan2(GetUnitY(d) - GetUnitY(c), GetUnitX(d) - GetUnitX(c))
    endfunction
    function GAngle2 takes unit c, real x, real y returns real //Angle between unit and coords in radians
        return Atan2(y - GetUnitY(c), x - GetUnitX(c))
    endfunction
    function GAngle3 takes real x, real y, unit c returns real //Angle between coords and unit in radians
        return Atan2( GetUnitY(c) - y, GetUnitX(c) - x)
    endfunction
    function GAngle4 takes real x, real y, real x2, real y2 returns real //Angle between coords in radians
        return Atan2( y2 - y, x2 - x)
    endfunction
    function GAngle5 takes effect eff, real x, real y returns real //Angle between eff and coords in radians
        return Atan2(y - BlzGetLocalSpecialEffectY(eff), x - BlzGetLocalSpecialEffectX(eff))
    endfunction
    //===========================================================================
// KS_Flush РІР‚вЂќ Р С•Р В±РЎвЂ№РЎвЂЎР Р…РЎвЂ№Р в„– integer-РЎвЂћР В»Р В°РЎв‚¬ (Р В±РЎвЂ№Р В»Р С•: MyFlushI_Start c check==0)
// Р ВРЎРѓР С—Р С•Р В»РЎРЉР В·РЎС“Р ВµР СРЎвЂ№Р Вµ Р С—Р ВµРЎР‚Р ВµР СР ВµР Р…Р Р…РЎвЂ№Р Вµ: id, child_id, value, r, rmax
//===========================================================================

// Shared timer scheduler
function GearTimer03Acquire takes nothing returns nothing
    set GearTimer03Users = GearTimer03Users + 1
    if GearTimer03Users == 1 then
        call TimerStart(GearTimer03, 0.03, true, GearTimer03Callback)
    endif
endfunction

function GearTimer03Release takes nothing returns nothing
    set GearTimer03Users = GearTimer03Users - 1
    if GearTimer03Users <= 0 then
        set GearTimer03Users = 0
        call PauseTimer(GearTimer03)
    endif
endfunction

function GearTimer05Acquire takes nothing returns nothing
    set GearTimer05Users = GearTimer05Users + 1
    if GearTimer05Users == 1 then
        call TimerStart(GearTimer05, 0.05, true, GearTimer05Callback)
    endif
endfunction

function GearTimer05Release takes nothing returns nothing
    set GearTimer05Users = GearTimer05Users - 1
    if GearTimer05Users <= 0 then
        set GearTimer05Users = 0
        call PauseTimer(GearTimer05)
    endif
endfunction

function GearTimer10Acquire takes nothing returns nothing
    set GearTimer10Users = GearTimer10Users + 1
    if GearTimer10Users == 1 then
        call TimerStart(GearTimer10, 0.10, true, GearTimer10Callback)
    endif
endfunction

function GearTimer10Release takes nothing returns nothing
    set GearTimer10Users = GearTimer10Users - 1
    if GearTimer10Users <= 0 then
        set GearTimer10Users = 0
        call PauseTimer(GearTimer10)
    endif
endfunction
private struct KS_Flush
    private static integer array m
    private static integer MUI = -1
    real r
    real rmax
    integer child_id
    integer value
    integer id

    public static method Loop takes nothing returns nothing
        local thistype this
        local integer i = 0
        loop
            exitwhen i > MUI
            set this = m[i]
            if r < rmax then
                set r = RoundReal(r + 0.03, 3)
                if LoadInteger(hs, id, child_id) == value then
                    set r = 9999
                endif
            else
                if r != 9999 then
                    call SaveInteger(hs, id, child_id, value)
                endif
                set m[i] = m[MUI]
                set MUI = MUI - 1
                if MUI == -1 then
                    call GearTimer03Release()
                endif
                call destroy()
            endif
            set i = i + 1
        endloop
    endmethod

    public static method Start takes integer NewId, integer NewChild_Id, integer NewValue, real NewRmax returns nothing
        local thistype this = thistype.create()
        set MUI = MUI + 1
        set m[MUI] = this
        set r = 0
        set rmax = NewRmax
        set id = NewId
        set child_id = NewChild_Id
        set value = NewValue
        if MUI == 0 then
            call GearTimer03Acquire()
        endif
    endmethod
endstruct

//===========================================================================
// KS_FlushBuff РІР‚вЂќ РЎвЂћР В»Р В°РЎв‚¬ Р С—Р С• Р Р…Р В°Р В»Р С‘РЎвЂЎР С‘РЎР‹ Р В±Р В°РЎвЂћР В°/Р В°Р В±Р С‘Р В»Р С”Р С‘ (Р В±РЎвЂ№Р В»Р С•: MyFlushI_Start c check!=0)
// Р ВРЎРѓР С—Р С•Р В»РЎРЉР В·РЎС“Р ВµР СРЎвЂ№Р Вµ Р С—Р ВµРЎР‚Р ВµР СР ВµР Р…Р Р…РЎвЂ№Р Вµ: c, check, id, child_id, value, r, b
//===========================================================================
private struct KS_FlushBuff
    private static integer array m
    private static integer MUI = -1
    unit c
    integer check
    integer child_id
    integer value
    integer id
    real r
    boolean b

    public static method Loop takes nothing returns nothing
        local thistype this
        local integer i = 0
        loop
            exitwhen i > MUI
            set this = m[i]
            set b = GetUnitAbilityLevel(c, check) > 0
            if b then
                set r = RoundReal(r + 0.03, 3)
                if LoadInteger(hs, id, child_id) == value then
                    set r = 9999
                endif
            else
                if r != 9999 then
                    call SaveInteger(hs, id, child_id, value)
                endif
                if check == RimuruQ2_Buff_ID then
                    call MakeSound("war3mapimported\\Hero_Rimuru2_Q3")
                endif
                set c = null
                set m[i] = m[MUI]
                set MUI = MUI - 1
                if MUI == -1 then
                    call GearTimer03Release()
                endif
                call destroy()
            endif
            set i = i + 1
        endloop
    endmethod

    public static method Start takes integer NewId, integer NewChild_Id, integer NewValue, unit NewC, integer NewAbiId returns nothing
        local thistype this = thistype.create()
        set MUI = MUI + 1
        set m[MUI] = this
        set r = 0
        set c = NewC
        set id = NewId
        set child_id = NewChild_Id
        set value = NewValue
        set check = NewAbiId
        if MUI == 0 then
            call GearTimer03Acquire()
        endif
    endmethod
endstruct

//===========================================================================
// KS_AddMana РІР‚вЂќ Р С•РЎвЂљР В»Р С•Р В¶Р ВµР Р…Р Р…Р С•Р Вµ Р Р†Р С•РЎРѓРЎРѓРЎвЂљР В°Р Р…Р С•Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Р СР В°Р Р…РЎвЂ№ (Р В±РЎвЂ№Р В»Р С•: MyAddMana_Start)
// Р ВРЎРѓР С—Р С•Р В»РЎРЉР В·РЎС“Р ВµР СРЎвЂ№Р Вµ Р С—Р ВµРЎР‚Р ВµР СР ВµР Р…Р Р…РЎвЂ№Р Вµ: c, r, rmax, r2, b
//===========================================================================
private struct KS_AddMana
    private static integer array m
    private static integer MUI = -1
    unit c
    real r
    real rmax
    real r2
    boolean b

    public static method Loop takes nothing returns nothing
        local thistype this
        local integer i = 0
        loop
            exitwhen i > MUI
            set this = m[i]
            set r = RoundReal(r + 0.03, 3)
            set b = r < rmax
            if b then
            else
                call SetUnitState(c, UNIT_STATE_MANA, GetUnitState(c, UNIT_STATE_MANA) + r2)
                set c = null
                set m[i] = m[MUI]
                set MUI = MUI - 1
                if MUI == -1 then
                    call GearTimer03Release()
                endif
                call destroy()
            endif
            set i = i + 1
        endloop
    endmethod

    public static method Start takes unit NewC, real NewMana, real NewRmax returns nothing
        local thistype this = thistype.create()
        set MUI = MUI + 1
        set m[MUI] = this
        set r = 0
        set c = NewC
        set rmax = NewRmax
        set r2 = NewMana
        if MUI == 0 then
            call GearTimer03Acquire()
        endif
    endmethod
endstruct

//===========================================================================
// KS_FlushReal РІР‚вЂќ real-РЎвЂћР В»Р В°РЎв‚¬ (Р В±РЎвЂ№Р В»Р С•: MyFlushR_Start)
// Р ВРЎРѓР С—Р С•Р В»РЎРЉР В·РЎС“Р ВµР СРЎвЂ№Р Вµ Р С—Р ВµРЎР‚Р ВµР СР ВµР Р…Р Р…РЎвЂ№Р Вµ: id, child_id, r, r2, rmax
//===========================================================================
private struct KS_FlushReal
    private static integer array m
    private static integer MUI = -1
    integer id
    integer child_id
    real r
    real r2
    real rmax

    public static method Loop takes nothing returns nothing
        local thistype this
        local integer i = 0
        loop
            exitwhen i > MUI
            set this = m[i]
            if r < rmax then
                set r = RoundReal(r + 0.03, 3)
                if LoadReal(hs, id, child_id) == r2 then
                    set r = 9999
                endif
            else
                if r != 9999 then
                    call SaveReal(hs, id, child_id, r2)
                endif
                set m[i] = m[MUI]
                set MUI = MUI - 1
                if MUI == -1 then
                    call GearTimer03Release()
                endif
                call destroy()
            endif
            set i = i + 1
        endloop
    endmethod

    public static method Start takes integer NewId, integer NewChild_Id, real NewValue, real NewRmax returns nothing
        local thistype this = thistype.create()
        set MUI = MUI + 1
        set m[MUI] = this
        set r = 0
        set rmax = NewRmax
        set id = NewId
        set child_id = NewChild_Id
        set r2 = NewValue
        if MUI == 0 then
            call GearTimer03Acquire()
        endif
    endmethod
endstruct

//===========================================================================
// Р СџРЎС“Р В±Р В»Р С‘РЎвЂЎР Р…РЎвЂ№Р Вµ Р С•Р В±РЎвЂРЎР‚РЎвЂљР С”Р С‘ РІР‚вЂќ Р Р†РЎвЂ№Р В·Р С•Р Р†РЎвЂ№ Р С—Р ВµРЎР‚Р ВµР Р†Р ВµР Т‘Р ВµР Р…РЎвЂ№ Р Р…Р В° Р Р…Р С•Р Р†РЎвЂ№Р Вµ РЎРѓРЎвЂљРЎР‚РЎС“Р С”РЎвЂљРЎС“РЎР‚РЎвЂ№
//===========================================================================
function MyFlush takes integer id, integer childid, integer value, real r returns nothing
    call KS_Flush.Start(id, childid, value, r)
endfunction

function MyAddMana takes unit c, real mana, real r returns nothing
    call KS_AddMana.Start(c, mana, r)
endfunction

function MyFlushBuff takes integer id, integer childid, integer value, unit c, integer buff_id returns nothing
    call KS_FlushBuff.Start(id, childid, value, c, buff_id)
endfunction

function MyFlushReal takes integer id, integer childid, integer value, real r returns nothing
    call KS_FlushReal.Start(id, childid, value, r)
endfunction

    function StartSpellUnit takes unit c returns nothing
        call IssueImmediateOrder(c, "stop")
        call SetUnitTimeScale(c, 1)
        call UnitAddAbility(c, 'Avul')
        call PauseUnit(c, true)
    endfunction
    function StartSpellUnit2 takes unit c returns nothing
        call IssueImmediateOrder(c, "stop")
        call SetUnitTimeScale(c, 1)
        call PauseUnit(c, true)
    endfunction
    function StopSpellUnit takes unit c returns nothing
        call IssueImmediateOrder(c, "stop")
        call SetUnitTimeScale(c, 1)
        call UnitRemoveAbility(c, 'Avul')
        call PauseUnit(c, false)
        call SaveInteger(hs,GetHandleId(GetOwningPlayer(c)),StringHash("ahk pidor"),1)
        call MyFlush(GetHandleId(GetOwningPlayer(c)),StringHash("ahk pidor"),0,ahk_delay )
    endfunction
    function StopSpellUnit2 takes unit c returns nothing
        call IssueImmediateOrder(c, "stop")
        call SetUnitTimeScale(c, 1)
        call PauseUnit(c, false)
        call SaveInteger(hs,GetHandleId(GetOwningPlayer(c)),StringHash("ahk pidor"),1)
        call MyFlush(GetHandleId(GetOwningPlayer(c)),StringHash("ahk pidor"),0,ahk_delay )
    endfunction
    function SpeedToLevel takes real r returns integer
    local real min = 0.05
    local real step = 0.05
    local integer lvl
    if r <= min then
        return 1
    endif
    if r >= 1.0 then
        return 20
    endif
    set lvl = R2I((r - min) / step) + 1
    if lvl < 1 then
        set lvl = 1
    elseif lvl > 20 then
        set lvl = 20
    endif
    return lvl
endfunction
    function BuffUnitMS takes unit c, unit u, real speed returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = SpeedToLevel(speed)
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A00D')
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A00D') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A00D')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A00D', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "bloodlust", u)
        endif
    endfunction
    function dmgmag takes unit c, unit td , real dmg returns nothing
    if c != null and td != null and GetWidgetLife(td)>1 then 
    call UnitDamageTarget(c, td, dmg, false, false, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_NORMAL, null)
    endif
    endfunction
    function dmgphys takes unit c, unit td , real dmg returns nothing
    if c != null and td != null and GetWidgetLife(td)>1 then 
    call UnitDamageTarget(c,td,dmg, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, null)
    endif
    endfunction
    function dmgatk takes unit c, unit td , real dmg returns nothing
    if c != null and td != null and GetWidgetLife(td)>1 then 
    call UnitDamageTarget(c,td,dmg, true, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL, null)
    endif
    endfunction
    function spelldmg takes unit c , unit td, real dmg returns nothing
        if c != null and td != null and GetWidgetLife(td)>1 then 
        call UnitDamageTarget(c, td, dmg, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_UNIVERSAL, null)
   endif
   endfunction
    function PathableCheck takes real x , real y returns boolean
        return CheckCoordsInRect(gg_rct_Arena,x,y)
    endfunction
    function PathableCheck3 takes real x , real y returns boolean
        return CheckCoordsInRect(gg_rct_Arena,x,y)
    endfunction
    function PathableCheck2 takes real x , real y returns boolean
        return true
    endfunction
    function MoveUnit takes unit c, real sr, real a returns nothing
    local real startX
    local real startY
    local real move=sr
    local real targetX
    local real targetY

    if c == null or move == 0  then
        return
    endif

    set startX = GetUnitX(c)
    set startY = GetUnitY(c)

    /*
     * Система стен может уменьшить разрешённую дистанцию
     * вплоть до нуля.
     */
    
    

    set targetX = startX + move * Cos(a)
    set targetY = startY + move * Sin(a)

    if PathableCheck3(targetX, targetY) then
        call SetUnitX(c, targetX)
        call SetUnitY(c, targetY)
    endif
endfunction
function MoveUnit3 takes unit c, real sr, real a returns nothing
    local real startX
    local real startY
    local real move
    local real targetX
    local real targetY

    if c == null  then
        return
    endif

    set startX = GetUnitX(c)
    set startY = GetUnitY(c)

    /*
     * Система стен может уменьшить разрешённую дистанцию
     * вплоть до нуля.
     */
    set move = UnitMoveWall.GetMoveDistance( c, startX, startY, a, sr)

    if move <= 0.00 then
        return
    endif

    set targetX = startX + move * Cos(a)
    set targetY = startY + move * Sin(a)

    if PathableCheck3(targetX, targetY) then
        call SetUnitX(c, targetX)
        call SetUnitY(c, targetY)
    endif
endfunction
    // Getter is based on index 0 and 1
// Setter is based on index 1 and 2
// WHY BLIZZARD WHYYYYY
function SetUnitRange takes unit u, real newRange returns nothing
        call BlzSetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_RANGE,1,newRange-BlzGetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_RANGE,0)+BlzGetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_RANGE,1))
endfunction
 
// Setting small AoE range for a unit also sets its attack cooldown and the range at index 1...
// Why ? I don't know. Here's a fix.
// Must test with the other types of AoE and indexes
function SetUnitAoESmall takes unit u, integer index, real newAoE returns nothing
    local real r=BlzGetUnitAttackCooldown(u,index)
    local real r2=BlzGetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_RANGE,0)
    call BlzSetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_SMALL_DAMAGE,index,newAoE)
    call BlzSetUnitAttackCooldown(u,r,index)
    call SetUnitRange(u,r2)
endfunction
    function PosUnit takes unit c, real x, real y returns nothing
    local integer k = 0
    local integer steps
    local real angle
    local real distance
    local real step
    local real oldX
    local real oldY

    if c == null then
        return
    endif

    set angle = GAngle2(c, x, y)
    set distance = SR3(c, x, y)

    if distance < 300.00 then
        set steps = 5
    elseif distance < 800.00 then
        set steps = 10
    else
        set steps = 20
    endif

    set step = distance / I2R(steps)

    loop
        exitwhen k >= steps

        set oldX = GetUnitX(c)
        set oldY = GetUnitY(c)

        call MoveUnit(c, step, angle)

        /*
         * Если юнит не сдвинулся, дальнейшие попытки в том же
         * направлении ничего не изменят.
         */
        if GetUnitX(c) == oldX and GetUnitY(c) == oldY then
            return
        endif

        set k = k + 1
    endloop
endfunction
    function MoveEff takes effect e, real sr, real a returns nothing
        if PathableCheck(GetEffX(e) + sr * Cos(a), GetEffY(e) + sr * Sin(a)) then
            call BlzSetSpecialEffectPosition(e, GetEffX(e) + sr * Cos(a), GetEffY(e) + sr * Sin(a),BlzGetLocalSpecialEffectZ(e))
        endif
    endfunction
    function MoveUnit2 takes unit c, real sr, real a returns nothing
        call SetUnitX(c, GetUnitX(c) + sr * Cos(a))
        call SetUnitY(c, GetUnitY(c) + sr * Sin(a))
       endfunction
       struct UnitMoveWall
    private static integer array walls
    private static integer array slot
    private static boolean array active

    private static real array wallX
    private static real array wallY
    private static real array wallAngle
    private static real array wallLength
    private static real array wallCurve
    private static real array wallOffset
    private static real array wallRadius
    private static real array wallCheckStep

    private static integer count = -1

    public static method Add takes integer id, /*
    */ real x, real y, real angle, /*
    */ real length, real curve, real offset, /*
    */ real radius, real checkStep returns nothing

        if not active[id] then
            set count = count + 1
            set walls[count] = id
            set slot[id] = count
            set active[id] = true
        endif

        set wallX[id] = x
        set wallY[id] = y
        set wallAngle[id] = angle
        set wallLength[id] = length
        set wallCurve[id] = curve
        set wallOffset[id] = offset
        set wallRadius[id] = radius
        set wallCheckStep[id] = checkStep
    endmethod

    public static method Remove takes integer id returns nothing
        local integer index
        local integer last

        if not active[id] then
            return
        endif

        set index = slot[id]
        set last = walls[count]

        set walls[index] = last
        set slot[last] = index

        set walls[count] = 0
        set slot[id] = 0
        set active[id] = false

        set wallX[id] = 0.00
        set wallY[id] = 0.00
        set wallAngle[id] = 0.00
        set wallLength[id] = 0.00
        set wallCurve[id] = 0.00
        set wallOffset[id] = 0.00
        set wallRadius[id] = 0.00
        set wallCheckStep[id] = 0.00

        set count = count - 1
    endmethod
        public static method GetMoveDistance takes unit u, /*
    */ real startX, real startY, /*
    */ real angle, real wanted returns real

        local integer i = 0
        local integer id

        local real test
        local real step
        local real px
        local real py
        local real dx
        local real dy

        local real lengthAngle
        local real localLength
        local real localWidth
        local real halfLength
        local real normalized
        local real curveOffset
        local real difference
        local real collisionRadius
        local real closest = wanted

        if u == null or wanted <= 0.00 then
            return 0.00
        endif

        loop
            exitwhen i > count

            set id = walls[i]
            set halfLength = wallLength[id] * 0.50
            set step = wallCheckStep[id]

            if step <= 0.00 then
                set step = 16.00
            endif

            /*
             * Радиус стены плюс collision size юнита.
             * Если получится слишком большой отступ, collision size
             * можно ограничить, например, значением 48.
             */
            set collisionRadius = wallRadius[id] /*
            */ + BlzGetUnitCollisionSize(u)

            set lengthAngle = wallAngle[id] + bj_PI * 0.50
            set test = step

            loop
                exitwhen test > closest

                set px = startX + test * Cos(angle)
                set py = startY + test * Sin(angle)

                set dx = px - wallX[id]
                set dy = py - wallY[id]

                /*
                 * Положение точки вдоль стены.
                 */
                set localLength = dx * Cos(lengthAngle) /*
                */               + dy * Sin(lengthAngle)

                if localLength >= -halfLength - collisionRadius /*
                */ and localLength <= halfLength + collisionRadius then

                    /*
                     * Положение точки поперёк стены.
                     */
                    set localWidth = dx * Cos(wallAngle[id]) /*
                    */              + dy * Sin(wallAngle[id])

                    set normalized = localLength / halfLength

                    set curveOffset = wallOffset[id] /*
                    */ - wallCurve[id] * normalized * normalized

                    set difference = localWidth - curveOffset

                    if difference < 0.00 then
                        set difference = -difference
                    endif

                    if difference <= collisionRadius then
                        /*
                         * Останавливаем юнита перед найденной точкой
                         * столкновения.
                         */
                        set closest = test - step

                        if closest < 0.00 then
                            set closest = 0.00
                        endif
                    endif
                endif

                set test = test + step
            endloop

            set i = i + 1
        endloop

        return closest
    endmethod
endstruct
    function MoveEff2 takes effect e, real sr, real a returns nothing
        call BlzSetSpecialEffectPosition(e, GetEffX(e) + sr * Cos(a), GetEffY(e) + sr * Sin(a), BlzGetLocalSpecialEffectZ(e))
    endfunction
    
    function SetFly takes unit c, real fly returns nothing
    
        if GetUnitAbilityLevel(c, 'Arav') == 0 then
            call UnitAddAbility(c, 'Arav')
            call SetUnitFlyHeight(c, fly, 0)
            call UnitRemoveAbility(c, 'Arav')
        else
            call SetUnitFlyHeight(c, fly, 0)
        endif
    endfunction
    function SetFlyInit takes unit c returns nothing
     
            call UnitAddAbility(c, 'Arav')
            call UnitRemoveAbility(c, 'Arav')
            
            call SetUnitFlyHeight(c, 9999, 0)
            call SetUnitFlyHeight(c, 0, 0)
    endfunction
       
    private struct KS_RemoveUnit
        private static integer array m_1
        private static integer MUI_1 = -1
        real r
        real r3
        real rmax
        string s
        integer check
        integer k
        unit c

        public static method Loop_MyRemoveUnit takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_1
                set this = m_1[i]
                if c != null and r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                else
                    if c != null then 
                    if check == 0 then
                        call RemoveUnit(c)
                    elseif check == 1 then
                        call SetUnitTimeScale(c, r3)
                    elseif check == 2 then
                        call SetUnitAnimationByIndex(c, k)
                    elseif check == 3 then
                        call SetUnitAnimation(c, s)
                    endif
                    endif
                    set c = null
                    set m_1[i] = m_1[MUI_1]
                    set MUI_1 = MUI_1 - 1
                    if MUI_1 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyRemoveUnit_Start takes unit NewC, real NewRmax, integer WhichAction, real AddR, integer AddI, string AddS returns nothing
            local thistype this = thistype.create()
            set MUI_1 = MUI_1 + 1
            set m_1[MUI_1] = this
            set c = NewC
            set check = WhichAction // 0 - remove, 1 - set anim speed, 2 set anim int, 3 - set anim string
            if check == 1 then
                set r3 = AddR
            elseif check == 2 then
                set k = AddI
            elseif check == 3 then
                set s = AddS
            endif
            set r = 0
            set rmax = NewRmax
            if MUI_1 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_RemoveEffect
        private static integer array m_2
        private static integer MUI_2 = -1
        real r
        real r3
        effect e
        real rmax
        string s
        integer check
        integer k

        public static method Loop_MyRemoveEff takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_2
                set this = m_2[i]
                if e != null and r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                else
                    if e != null then 
                    if check == 0 then
                        call DestroyEffect(e)
                    elseif check == 1 then
                        call BlzSetSpecialEffectTimeScale(e, r3)
                    elseif check == 2 then
                        call BlzPlaySpecialEffect(e, ANIM_TYPE_BIRTH)
                    elseif check == 3 then
                        call BlzPlaySpecialEffect(e, ANIM_TYPE_DEATH)
                    endif
                    endif
                    set e = null
                    set m_2[i] = m_2[MUI_2]
                    set MUI_2 = MUI_2 - 1
                    if MUI_2 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyRemoveEff_Start takes effect NewE, real NewRmax, integer WhichAction, real AddR, integer AddI, string AddS returns nothing
            local thistype this = thistype.create()
            set MUI_2 = MUI_2 + 1
            set m_2[MUI_2] = this
            set e = NewE
            set check = WhichAction // 0 - remove, 1 - set anim speed, 2 set anim int, 3 - set anim string
            if check == 1 then
                set r3 = AddR
            elseif check == 2 then
                set k = AddI
            elseif check == 3 then
                set s = AddS
            endif
            set r = 0
            set rmax = NewRmax
            if MUI_2 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_MoveUnit
        private static integer array m_3
        private static integer MUI_3 = -1
        real r
        real a
        real rmax
        integer check
        real move
        unit c

        public static method Loop_MUE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_3
                set this = m_3[i]
                if c != null and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                        if check == 0 then
                            call MoveUnit3(c, move, a)
                          
                        elseif check == 1 then
                            call SetUnitX(c, GetUnitX(c) + move * Cos(a))
                            call SetUnitY(c, GetUnitY(c) + move * Sin(a))
                        else
                            call SetUnitPosition(c, GetUnitX(c) + move * Cos(a), GetUnitY(c) + move * Sin(a))
                        endif
                    else
                    set c = null
                    set m_3[i] = m_3[MUI_3]
                    set MUI_3 = MUI_3 - 1
                    if MUI_3 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MUE_Start takes unit NewC, real NewDist, real NewRmax, real NewA, integer typemove returns nothing
            local thistype this
            if NewC == null then
        return
            endif
            set this = thistype.create()
            set MUI_3 = MUI_3 + 1
            set m_3[MUI_3] = this
            set c = NewC
            set r = 0
            set check = typemove // 0 - Move unit, 1 - set x y, 2 - set position
            set rmax = NewRmax
            set move = (NewDist / (rmax * 100)) * 3
           
            set a = NewA
            if MUI_3 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_UnitHeight
        private static integer array m_4
        private static integer MUI_4 = -1
        real r
        real r2
        real r3
        real r4
        real r5
        real rmax
        integer check
        integer check2
        integer check3
        real f
        unit c

        public static method LoopHeightSet takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_4
                set this = m_4[i]
                set r2 = RoundReal(r2 + 0.03, 3)
                if check == 0 and c != null then
                    if r2 > r5 then
                       if check3 == 0 then 
                    set check3 = 1
                    set f = GetUnitFlyHeight(c)
                if r3 >= f then
                set r4 = ((r3 - f) / (rmax * 100)) * 3
                set check2 = 0
            else
                set r4 = ((f - r3) / (rmax * 100)) * 3
                set check2 = 1
                set f = 0
            endif
                    endif
                 
                    if r <= rmax then
                           set r = RoundReal(r + 0.03, 3)
                            if check2 == 0 then
                                set f = GetUnitFlyHeight(c) + r4
                            else
                                set f = GetUnitFlyHeight(c) - r4
                            endif
                            call SetFly(c, f)
                        else
                            set check = 1
                        endif
                    endif
                else
                    set c = null
                    set m_4[i] = m_4[MUI_4]
                    set MUI_4 = MUI_4 - 1
                    if MUI_4 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HeightSet_Start takes unit NewC, real NewRmax, real NewFly, real NewWait returns nothing
            local thistype this
            if NewC == null then
        return
            endif
            set this = thistype.create()
            set MUI_4 = MUI_4 + 1
            set m_4[MUI_4] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set r3 = NewFly
            set r5 = NewWait
            set check3 = 0
            set f = GetUnitFlyHeight(c)
            set check = 0
            set rmax = NewRmax
            if r3 >= f then
                set r4 = ((r3 - f) / (rmax * 100)) * 3
                set check2 = 0
            else
                set r4 = ((f - r3) / (rmax * 100)) * 3
                set check2 = 1
                set f = 0
            endif
            if MUI_4 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_DamageOverTime
        private static integer array m_5
        private static integer MUI_5 = -1
        real r
        real r2
        real r3
        real dmg
        real rmax
        integer k
        unit td
        unit c

        public static method Loop_DmgPTime takes nothing returns nothing
    local thistype this
    local integer i = 0
    loop
        exitwhen i > MUI_5
        set this = m_5[i]
        if r < rmax and GetWidgetLife(td) > 0.405 then
            set r3 = RoundReal(r3 + 0.05, 3)
            if r3 >= r2 - 0.001 then  // small epsilon avoids float comparison miss
                set r3 = 0
                set r = r + 1          // count ticks as integer
                if k == 0 then
                    call dmgphys(c, td, dmg)
                elseif k == 1 then
                    call dmgmag(c, td, dmg)
                else
                    call dmgatk(c, td, dmg)
                endif
            endif
        else
            set td = null
            set c = null
            set m_5[i] = m_5[MUI_5]
            set MUI_5 = MUI_5 - 1
            if MUI_5 == -1 then
                call GearTimer05Release()
            endif
            call destroy()
                    set i = i - 1
        endif
        set i = i + 1
    endloop
endmethod
    // in struct, replace r/rmax with integers:
// use r = current tick count, rmax = total tick count (integer)
// r3 stays as period accumulator

public static method DmgPTime_Start takes unit NewC, unit NewTd, real NewDmg, real NewDuration, real NewPeriod, integer NewTD returns nothing
    local thistype this = thistype.create()
    local integer totalTicks
    set MUI_5 = MUI_5 + 1
    set m_5[MUI_5] = this
    set c = NewC
    set td = NewTd
    set r = 0        // elapsed time * 100 as integer to avoid float drift
    set r3 = 0       // period accumulator
    set r2 = NewPeriod
    set k = NewTD
    if r2 <= 0 then
        set r2 = 0.05
    endif
    // round to nearest instead of truncating
    set totalTicks = R2I(NewDuration / r2 + 0.5)
    if totalTicks < 1 then
        set totalTicks = 1
    endif
    set rmax = totalTicks  // store as tick count
    set dmg = NewDmg / totalTicks
    if MUI_5 == 0 then
        call GearTimer05Acquire()
    endif
endmethod

    endstruct

    private struct KS_SpellTimer
        private static integer array m_6
        private static integer MUI_6 = -1
        real r
        boolean b
        real rmax
        integer check
        integer k1
        integer k2
        integer k3
        player p
        unit c

        public static method LoopSpellTimer takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_6
                set this = m_6[i]
                if k3 != 0 then 
                set b =   LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(k2))) == 0 and GetUnitAbilityLevel(c, k1) > 0 and GetUnitAbilityLevel(c, k3) > 0
                else
                set b =  r < rmax and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(k2))) == 0 and GetUnitAbilityLevel(c, k1) > 0
                endif
                if b then
                    set r = RoundReal(r + 0.05, 3)
                else
                    if GetUnitAbilityLevel(c, k1) > 0 then
                    call SetPlayerAbilityAvailable(p, k2, true)
                    call SetPlayerAbilityAvailable(p, k1, false)
                    //call BJDebugMsg("1: "+BlzGetAbilityStringLevelField(BlzGetUnitAbility(c,k2),ABILITY_SLF_BASE_ORDER_ID_ANS5,GetUnitAbilityLevel(c,k2)-1))
                    //    call BJDebugMsg("2: "+BlzGetAbilityStringLevelField(BlzGetUnitAbility(c,k2),ABILITY_SLF_BASE_ORDER_ID_NCL6,GetUnitAbilityLevel(c,k1)-1))
                    //call BJDebugMsg("3: "+BlzGetAbilityStringLevelField(BlzGetUnitAbility(c,k2),ABILITY_SLF_BASE_ORDER_ID_SPB5,GetUnitAbilityLevel(c,k2)-1))
                   // call BJDebugMsg("Current order: "+I2S(GetUnitCurrentOrder(c)))
                   //  call BJDebugMsg("Spell order: "+I2S(OrderId(BlzGetAbilityStringLevelField(BlzGetUnitAbility(c,k1),ABILITY_SLF_BASE_ORDER_ID_NCL6,GetUnitAbilityLevel(c,k1)-1))))
                    if GetUnitCurrentOrder(c) ==  OrderId(BlzGetAbilityStringLevelField(BlzGetUnitAbility(c,k1),ABILITY_SLF_BASE_ORDER_ID_NCL6,GetUnitAbilityLevel(c,k1)-1)) then
                    call IssueImmediateOrder(c,"stop")                   
                    endif
                    endif
                    call SaveInteger(hs, GetHandleId(p), StringHash("AHUI swap " + I2S(k2)), 0)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(k2)), 0)
                    set c = null
                    set p = null
                    set m_6[i] = m_6[MUI_6]
                    set MUI_6 = MUI_6 - 1
                    if MUI_6 == -1 then
                        call GearTimer05Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method SpellTimer_Timer_Start takes unit NewC, real NewR, integer NewInt, integer NewInt2,integer NewBuff returns nothing
            local thistype this = thistype.create()
            set MUI_6 = MUI_6 + 1
            set m_6[MUI_6] = this
            set c = NewC
            set r = 0
            set check = 0
            set k1 = NewInt
            set k2 = NewInt2
            set k3 = NewBuff
            set p = GetOwningPlayer(c)
            call SaveInteger(hs, GetHandleId(p), StringHash("AHUI swap " + I2S(k2)), k1)
            set rmax = NewR
            call SetPlayerAbilityAvailable(p, k2, false)
            if GetUnitAbilityLevel(c, k1) == 0 then
                call UnitAddAbility(c, k1)
                call UnitMakeAbilityPermanent(c, true, k1)
                call SetUnitAbilityLevel(c,k1,GetUnitAbilityLevel(c,k2))
            endif
            call SetPlayerAbilityAvailable(p, k1, true)
            if MUI_6 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct KS_UnitColor
        private static integer array m_7
        private static integer MUI_7 = -1
        real r
        real r2
        real r3
        boolean b
        boolean b2
        integer red_i
        integer green_i
        integer blue_i
        real r4
        real rmax
        integer check
        integer check2
        integer k
        unit c

        public static method Loop_ColorDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_7
                set this = m_7[i]
                set r2 = RoundReal(r2 + 0.03, 3)
                if check == 0 and c!= null then
                    if r2 > r3 then
                        if r < rmax then
                            set r = r + 0.03
                            set r = S2R( R2SW( r , 0, 3 ) )
                            set check2 = check2 + R2I(r4)
                            if check2 > k then
                                set check2 = k
                            endif
                            if b2 == true then
                                call SetUnitVertexColor(c, red_i, green_i, blue_i, k - check2)
                            else
                                call SetUnitVertexColor(c, red_i, green_i, blue_i, check2)
                            endif
                        else
                            set check = 1
                        endif
                    endif
                else
                    if b == true then
                        call RemoveUnit(c)
                    endif
                    set c = null
                    set m_7[i] = m_7[MUI_7]
                    set MUI_7 = MUI_7 - 1
                    if MUI_7 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method ColorDummy_Start takes unit NewC, real NewPrepareTime, integer NewRed, integer NewGreen, integer NewBlue, integer NewAlpha , real NewRmax, boolean NewDeleteUnit, boolean CalcNegative returns nothing
            local thistype this = thistype.create()
            set MUI_7 = MUI_7 + 1
            set m_7[MUI_7] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set check2 = 0
            set check = 0
            set k = NewAlpha
            set b2 = CalcNegative
            set b = NewDeleteUnit
            set rmax = NewRmax
            set r3 = NewPrepareTime
            set r4 = ((k / (rmax * 100)) * 3) + 1
            set green_i = NewGreen
            set blue_i = NewBlue
            set red_i = NewRed
            if MUI_7 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_EffectColor
        private static integer array m_8
        private static integer MUI_8 = -1
        real r
        real r2
        real r3
        boolean b
        boolean b2
        effect e
        integer red_i
        integer green_i
        integer blue_i
        real r4
        real rmax
        integer check
        integer check2
        integer k

        public static method Loop_ColorEffDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_8
                set this = m_8[i]
                set r2 = RoundReal(r2 + 0.03, 3)
                if check == 0 then
                    if r2 > r3 then
                        if r < rmax then
                            set r = RoundReal(r + 0.03, 3)
                            set check2 = check2 + R2I(r4)
                            if check2 > k then
                                set check2 = k
                            endif
                            if b2 == true then
                                call BlzSetSpecialEffectColor(e, red_i, green_i, blue_i)
                                call BlzSetSpecialEffectAlpha(e, k - check2)
                            else
                                call BlzSetSpecialEffectColor(e, red_i, green_i, blue_i)
                                call BlzSetSpecialEffectAlpha(e, check2)
                            endif
                        else
                            set check = 1
                        endif
                    endif
                else
                    if b == true then
                        call DestroyEffect(e)
                    endif
                    set e = null
                    set m_8[i] = m_8[MUI_8]
                    set MUI_8 = MUI_8 - 1
                    if MUI_8 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method ColorEffDummy_Start takes effect NewC, real NewPrepareTime, integer NewRed, integer NewGreen, integer NewBlue, integer NewAlpha , real NewRmax, boolean NewDeleteUnit, boolean CalcNegative returns nothing
            local thistype this = thistype.create()
            set MUI_8 = MUI_8 + 1
            set m_8[MUI_8] = this
            set e = NewC
            set r = 0
            set r2 = 0
            set check2 = 0
            set check = 0
            set k = NewAlpha
            set b2 = CalcNegative
            set b = NewDeleteUnit
            set rmax = NewRmax
            set r3 = NewPrepareTime
            set r4 = ((k / (rmax * 100)) * 3) + 1
            set green_i = NewGreen
            set blue_i = NewBlue
            set red_i = NewRed
            if MUI_8 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_RemoveFog
        private static integer array m_9
        private static integer MUI_9 = -1
        real r
        fogmodifier fg
        real rmax

        public static method Loop_MyRemoveFogModifier takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_9
                set this = m_9[i]
                if r < rmax then
                    set r = RoundReal(r + 0.05, 3)
                else
                    call FogModifierStop(fg)
                    call DestroyFogModifier(fg)
                    set fg = null
                    set m_9[i] = m_9[MUI_9]
                    set MUI_9 = MUI_9 - 1
                    if MUI_9 == -1 then
                        call GearTimer05Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyRemoveFogModifier_Start takes fogmodifier NewFG, real NewRmax returns nothing
            local thistype this = thistype.create()
            set MUI_9 = MUI_9 + 1
            set m_9[MUI_9] = this
            set fg = NewFG
            set r = 0
            set rmax = NewRmax
            if MUI_9 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct KS_MoveEffectToUnit
        private static integer array m_10
        private static integer MUI_10 = -1
        real r
        boolean b
        group g
        effect e
        effect e2
        real rmax
        integer id
        integer check
        integer check2
        integer k2
        real f
        unit d
        unit c

        public static method Loop_MoveEffectToUnit takes nothing returns nothing
            local thistype this
            local real rr = 0
            local integer i = 0
            loop
                exitwhen i > MUI_10
                set this = m_10[i]
                if check2 == 0 then
                    set b = r < rmax and IsUnitType(d, UNIT_TYPE_DEAD) == false
                    if check == StringHash("alucard bullet") then
                        set b = r < rmax and e != null and LoadInteger(hs, GetHandleId(d), StringHash("alucard bullet")) > 0 and IsUnitType(d, UNIT_TYPE_DEAD) == false
                
                    endif
                   /* if check == Harribel_Pas1ID then
                        set b = r < rmax and GetUnitAbilityLevel(d, Harribel_Pas1ID) > 0 and IsUnitType(d, UNIT_TYPE_DEAD) == false
                    endif
                    if check == StarrkG_Cap1LvlDamageFrom then
                        set b = r < rmax and GetUnitAbilityLevel(d, StarrkG_Cap1LvlDamageFrom) > 0 and IsUnitType(d, UNIT_TYPE_DEAD) == false
                    endif
                    if check == LoadInteger(hs, GetHandleId(d), StringHash("brandish e")) and LoadInteger(hs, GetHandleId(d), StringHash("brandish e")) > 0 then
                        set b = r < rmax and LoadInteger(hs, GetHandleId(d), StringHash("brandish e")) > 0 and IsUnitType(d, UNIT_TYPE_DEAD) == false
                    endif
                    if check == StringHash("alucard bullet") then
                        set b = r < rmax and LoadInteger(hs, GetHandleId(d), StringHash("alucard bullet")) > 0 and IsUnitType(d, UNIT_TYPE_DEAD) == false
                
                    endif
                    if check == AskinGShield_ID then
                        set b = r < rmax and GetUnitAbilityLevel(d, AskinGShield_ID) > 0 and IsUnitType(d, UNIT_TYPE_DEAD) == false
                    endif*/
                elseif check2 == 1 then
                    set b = r < rmax and e != null 
                endif
                if b then
                    set r = RoundReal(r + 0.03, 3)
                    if check2 == 1 then
                        call BlzSetSpecialEffectPosition(e, GetEffX(e2), GetEffY(e2), BlzGetLocalSpecialEffectZ(e2) + f + rr)
                    else
                      //  call BlzSetSpecialEffectYaw(e, GetUnitFacing(d) * bj_DEGTORAD)
                        if true then // GetUnitTypeId(d) == Brandish_ID and check == LoadInteger(hs, GetHandleId(d), StringHash("brandish e")) then
                            if LoadInteger(hs, GetHandleId(d), StringHash("brandish g ally")) > 0 then
                                set rr = 30
                               // call BlzSetSpecialEffectScale(e, 1.65 * (BrandishG_DamageOutputIncreaseScale / 100) )
                            else
                              //  call BlzSetSpecialEffectScale(e, 1.65 )
                            endif
                        endif
                        call EffVision(e, d)
                        call BlzSetSpecialEffectPosition(e, GetUnitX(d), GetUnitY(d), GetUnitFlyHeight(d) + f + rr)
                    endif
                else
                    if k2 == 1 then
                        // После DestroyEffect handle больше нельзя передавать native-функциям.
                        call BlzSetSpecialEffectAlpha(e, 0)
                        call DestroyEffect(e)
                    endif
                    set d = null
                    set e = null
                    set m_10[i] = m_10[MUI_10]
                    set MUI_10 = MUI_10 - 1
                    if MUI_10 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MoveEffectToUnit_Start takes effect NewE, real NewRmax, real NewFly, unit NewU, integer NewCheck, integer NewDelete, effect NewE2 returns nothing
            local thistype this = thistype.create()
            set MUI_10 = MUI_10 + 1
            set m_10[MUI_10] = this
            set e = NewE
            set r = 0
            set k2 = NewDelete
            set check = NewCheck
            set id = GetPlayerId(GetOwningPlayer(c))
            set rmax = NewRmax
            set check2 = 0
            if NewE2 != null then
                set e2 = NewE2
                set check2 = 1
            endif
            
            set d = NewU
            set f = NewFly
            if MUI_10 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_MoveUnitToUnit
        private static integer array m_11
        private static integer MUI_11 = -1
        real r
        real rmax
        integer id
        integer check
        real f
        unit d
        unit c

        public static method Loop_MoveUnitToUnit takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_11
                set this = m_11[i]
                if r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call SetUnitX(c, GetUnitX(d))
                    call SetUnitY(c, GetUnitY(d))
                    call SetFly(c, GetUnitFlyHeight(d) + f)
                else
                    set d = null
                    set c = null
                    set m_11[i] = m_11[MUI_11]
                    set MUI_11 = MUI_11 - 1
                    if MUI_11 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MoveUnitToUnit_Start takes unit NewC, real NewRmax, real NewFly, unit NewU, integer NewCheck returns nothing
            local thistype this = thistype.create()
            set MUI_11 = MUI_11 + 1
            set m_11[MUI_11] = this
            set c = NewC
            set r = 0
            set check = NewCheck
            set id = GetPlayerId(GetOwningPlayer(c))
            set rmax = NewRmax
            set d = NewU
            set f = NewFly
            if MUI_11 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_DelayedDamage
        private static integer array m_12
        private static integer MUI_12 = -1
        real r
        real dmg
        real rmax
        integer check
        unit td
        unit c

        public static method Loop_NextDmg takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_12
                set this = m_12[i]
                if r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                else
                    if check == 0 then
    call dmgmag(c, td, dmg)
elseif check == 1 then
    call dmgphys(c, td, dmg)
elseif check == 3 then
    set ItemProcDamageDepth = ItemProcDamageDepth + 1
    set QuincyCrossDamageActive = true
    call dmgphys(c, td, dmg)
    set QuincyCrossDamageActive = false
    set ItemProcDamageDepth = ItemProcDamageDepth - 1
elseif check == 4 then
    set ItemProcDamageDepth = ItemProcDamageDepth + 1
    call dmgmag(c, td, dmg)
    set ItemProcDamageDepth = ItemProcDamageDepth - 1
else
    call dmgatk(c, td, dmg)
endif
                    set c = null
                    set td = null
                    set m_12[i] = m_12[MUI_12]
                    set MUI_12 = MUI_12 - 1
                    if MUI_12 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method NextDmg_Start takes unit NewC, unit NewTd, real NewDmg, integer NewType, real NewR returns nothing
            local thistype this = thistype.create()
            set MUI_12 = MUI_12 + 1
            set m_12[MUI_12] = this
            set c = NewC
            set dmg = NewDmg
            set rmax = NewR
            set r = 0
            set td = NewTd
            set check = NewType
            if MUI_12 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_BlockRegen
        private static integer array m_13
        private static integer MUI_13 = -1
        real r
        real r2
        real r3
        real r4
        real r5
        real rmax
        unit c

        public static method Loop_BlockHpRegen takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_13
                set this = m_13[i]
                if r < rmax and IsUnitType(c, UNIT_TYPE_DEAD) == false then
                    set r = RoundReal(r + 0.05, 3)
                    set r3 = GetUnitState(c, UNIT_STATE_LIFE)            
                    if r3 > r4 then
                        set r2 = (r3 - r4) * r5
                        set r4 = r4 + r2
                        call SetUnitState(c, UNIT_STATE_LIFE, r4)
                    else
                        set r4 = r3
                    endif
                else
                    set c = null
                    set m_13[i] = m_13[MUI_13]
                    set MUI_13 = MUI_13 - 1
                    if MUI_13 == -1 then
                        call GearTimer05Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BlockHpRegen_Start takes unit NewC, real NewR, real NewBlockHeal returns nothing
            local thistype this = thistype.create()
            set MUI_13 = MUI_13 + 1
            set m_13[MUI_13] = this
            set c = NewC
            set r3 = 0
            set rmax = NewR
            set r5 = 1 - NewBlockHeal
            set r4 = GetUnitState(c, UNIT_STATE_LIFE)
            set r = 0
            if MUI_13 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct KS_RemoveAbility
        private static integer array m_14
        private static integer MUI_14 = -1
        real r
        boolean b
        boolean b2
        real rmax
        integer id
        integer check2
        integer k
        unit c

        public static method Loop_RemoveAbility takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_14
                set this = m_14[i]
                set b = r < rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false
                if k == 1 then
                    set b = r < rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false and GetUnitAbilityLevel(c, id) > 0
                endif
                if id == 'A07Q' then 
                set b2 = GetUnitAbilityLevel(c,'A01W')>0 and  BlzGetUnitAbilityCooldownRemaining(c,'A01W')>0 
                endif
                if b and b2 then
                if id == 'A07Q' then
                if IsUnitType(c,UNIT_TYPE_DEAD) == false then 
                    set r = r + 0.1
                 endif   
                    else
                     set r = r + 0.1
                    endif
                else
                    if k == 0 then
                    if id == 'A07Q' then 
                    if GetUnitAbilityLevel(c,'A01W')>0  then 
                    call UnitAddAbility(c, id)
                    else
                    endif
                    else
                        call UnitAddAbility(c, id)
                    endif
                    else
                        if GetUnitAbilityLevel(c, id) > 0 and GetUnitAbilityLevel(c, id) == check2 then
                            call UnitRemoveAbility(c, id)
                            if id == 'A010' or id == 'A011' or id == 'A012' or id == 'A013' or id == 'A014' or id == 'A015' then 
                            call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')))-1)
                        endif
                        if id == 'A07H' or id == 'A07I' or id == 'A07J' or id == 'A07K' or id == 'A07F' or id == 'A07G' then 
                            call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')))-1)
                        endif
                        endif
                    endif
                    set c = null
                    set m_14[i] = m_14[MUI_14]
                    set MUI_14 = MUI_14 - 1
                    if MUI_14 == -1 then
                        call GearTimer10Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RemoveAbility_Start takes unit NewC, real NewRmax, integer NewId, integer NewAdd_or_delete returns nothing
            local thistype this = thistype.create()
            set MUI_14 = MUI_14 + 1
            set m_14[MUI_14] = this
            set c = NewC
            set r = 0
            set id = NewId
            set k = NewAdd_or_delete
            set rmax = NewRmax
            set b = false
            set b2= true 
            set check2 = GetUnitAbilityLevel(c, id)
            if IsUnitType(c, UNIT_TYPE_HERO) then
                set b = true
            endif
            if MUI_14 == 0 then
                call GearTimer10Acquire()
            endif
        endmethod

    endstruct
   private struct KS_RemoveAbility2
    private static integer array m_14
    private static integer MUI_14 = -1
    real r
    boolean b
    boolean b2
    real rmax
    integer id
    integer id_main
    integer check2
    integer k
    integer startDelayTicks
    unit c

    public static method Loop_RemoveAbility takes nothing returns nothing
        local thistype this
        local integer i = 0

        loop
            exitwhen i > MUI_14
            set this = m_14[i]

            // GearTimer10 срабатывает раз в 0.1 сек.
            // Первые две итерации только отсчитывают задержку,
            // поэтому первая проверка b выполняется через 0.2 сек.
            if startDelayTicks > 0 then
                set startDelayTicks = startDelayTicks - 1
            endif

            if startDelayTicks == 0 then
                set b = r < rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false and GetUnitAbilityLevel(c, id_main) > 0

                if k == 1 then
                    set b = r < rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false and GetUnitAbilityLevel(c, id) > 0 and GetUnitAbilityLevel(c, id_main) > 0
                endif

                if id == 'A07Q' then
                    set b2 = GetUnitAbilityLevel(c, 'A01W') > 0 and BlzGetUnitAbilityCooldownRemaining(c, 'A01W') > 0
                endif

                if b and b2 then
                    if id == 'A07Q' then
                        if IsUnitType(c, UNIT_TYPE_DEAD) == false then
                            set r = r + 0.1
                        endif
                    else
                        set r = r + 0.1
                    endif
                else
                    if k == 0 then
                        if id == 'A07Q' then
                            if GetUnitAbilityLevel(c, 'A01W') > 0 then
                                call UnitAddAbility(c, id)
                            endif
                        else
                            call UnitAddAbility(c, id)
                        endif
                    else
                        if GetUnitAbilityLevel(c, id) > 0 and GetUnitAbilityLevel(c, id) == check2 then
                            call UnitRemoveAbility(c, id)

                            if id == 'A010' or id == 'A011' or id == 'A012' or id == 'A013' or id == 'A014' or id == 'A015' then
                                call SetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I00H')), GetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I00H'))) - 1)
                            endif

                            if id == 'A07H' or id == 'A07I' or id == 'A07J' or id == 'A07K' or id == 'A07F' or id == 'A07G' then
                                call SetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I01I')), GetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I01I'))) - 1)
                            endif
                        endif
                    endif

                    set c = null
                    set m_14[i] = m_14[MUI_14]
                    set MUI_14 = MUI_14 - 1

                    if MUI_14 == -1 then
                        call GearTimer10Release()
                    endif

                    call destroy()
                    set i = i - 1
                endif
            endif

            set i = i + 1
        endloop
    endmethod

    public static method RemoveAbility_Start takes unit NewC, integer NewId, integer NewAdd_or_delete, integer id_abi returns nothing
        local thistype this = thistype.create()

        set MUI_14 = MUI_14 + 1
        set m_14[MUI_14] = this
        set c = NewC
        set r = 0
        set id_main = id_abi
        set id = NewId
        set k = NewAdd_or_delete
        set rmax = 900
        set b = false
        set b2 = true
        set check2 = GetUnitAbilityLevel(c, id)
        set startDelayTicks = 2

        if IsUnitType(c, UNIT_TYPE_HERO) then
            set b = true
        endif

        if MUI_14 == 0 then
            call GearTimer10Acquire()
        endif
    endmethod
endstruct


    private struct KS_DelayedSound
        private static integer array m_15
        private static integer MUI_15 = -1
        real r
        real rmax
        string s

        public static method Loop_NextSound takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_15
                set this = m_15[i]
                if r < rmax then
                    set r = r + 0.1
                else
                    call MakeSound(s)
                    set s = null
                    set m_15[i] = m_15[MUI_15]
                    set MUI_15 = MUI_15 - 1
                    if MUI_15 == -1 then
                        call GearTimer10Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method NextSound_Start takes string NewS, real NewRmax returns nothing
            local thistype this = thistype.create()
            set MUI_15 = MUI_15 + 1
            set m_15[MUI_15] = this
            set r = 0
            set rmax = NewRmax
            set s = NewS
            if MUI_15 == 0 then
                call GearTimer10Acquire()
            endif
        endmethod

    endstruct
    private struct KS_UnitScale
        private static integer array m_16
        private static integer MUI_16 = -1
        real r
        real r2
        real r3
        real scale
        real scale2
        real r4
        real rmax
        integer check
        integer check2
        unit c

        public static method Loop_ScaleDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_16
                set this = m_16[i]
                set r2 = RoundReal(r2 + 0.03, 3)
                if check == 0 then
    if r2 > r3 then
        set r = RoundReal(r + 0.03, 3)
        if r <= rmax then
            if check2 == 0 then
                set scale = scale + r4
            else
                set scale = scale - r4
            endif
            call SetUnitScale(c, scale, scale, scale)
        else
            // Clamp to exact target on finish
            call SetUnitScale(c, scale2, scale2, scale2)
            set check = 1
        endif
    endif
else
                    set c = null
                    set m_16[i] = m_16[MUI_16]
                    set MUI_16 = MUI_16 - 1
                    if MUI_16 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method ScaleDummy_Start takes unit NewC, real NewPrepareTime, real ScaleBase, real ScaleTarget, real NewRmax returns nothing
            local thistype this = thistype.create()
            set MUI_16 = MUI_16 + 1
            set m_16[MUI_16] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set r3 = NewPrepareTime
            set scale = ScaleBase
            set check = 0
            call SetUnitScale(c, scale, scale, scale)
            set scale2 = ScaleTarget
            set rmax = NewRmax
            if rmax < 0.06 then
                set rmax = 0.06
            endif
            if scale2 >= scale then
                set r4 = ((scale2 - scale) / (rmax * 100)) * 3
                set check2 = 0
            else
                set r4 = ((scale - scale2) / (rmax * 100)) * 3
                set check2 = 1
            endif
            if MUI_16 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_MoveEffect
        private static integer array m_17
        private static integer MUI_17 = -1
        real r
        effect e
        real a
        real rmax
        integer check
        real move

        public static method Loop_EMUE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_17
                set this = m_17[i]
                if r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call MoveEff2(e, move , a)
                else
                    set e = null
                    set m_17[i] = m_17[MUI_17]
                    set MUI_17 = MUI_17 - 1
                    if MUI_17 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method EMUE_Start takes effect NewE, real NewDist, real NewRmax, real NewA, integer typemove returns nothing
            local thistype this
            if NewE == null then
        return
            endif
            set this = thistype.create()
            
            set MUI_17 = MUI_17 + 1
            set m_17[MUI_17] = this
            set e = NewE
            set r = 0
            set check = typemove // 0 - Move unit, 1 - set x y, 2 - set position
            set rmax = NewRmax
            set move = (NewDist / (rmax * 100)) * 3
            set a = NewA
            if MUI_17 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_EffectScale
        private static integer array m_18
        private static integer MUI_18 = -1
        real r
        real r2
        real r3
        real scale
        real scale2
        effect e
        real r4
        real rmax
        integer check
        integer check2

        public static method Loop_ScaleEffDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_18
                set this = m_18[i]
                set r2 = RoundReal(r2 + 0.03, 3)
                if check == 0 then
                    if r2 > r3 then
                        if r <= rmax then
                            set r = RoundReal(r + 0.03, 3)
                            if check2 == 0 then
                                set scale = scale + r4
                            else
                                set scale = scale - r4
                            endif
                            call BlzSetSpecialEffectScale(e, scale)
                        else
                            set check = 1
                        endif
                    endif
                else
                    set e = null
                    set m_18[i] = m_18[MUI_18]
                    set MUI_18 = MUI_18 - 1
                    if MUI_18 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method ScaleEffDummy_Start takes effect NewE, real NewPrepareTime, real ScaleBase, real ScaleTarget, real NewRmax returns nothing
            local thistype this = thistype.create()
            set MUI_18 = MUI_18 + 1
            set m_18[MUI_18] = this
            set e = NewE
            set r = 0
            set r2 = 0
            set r3 = NewPrepareTime
            set scale = ScaleBase
            set check = 0
            call BlzSetSpecialEffectScale(e, scale)
            set scale2 = ScaleTarget
            set rmax = NewRmax
            if rmax < 0.06 then
                set rmax = 0.06
            endif
            if scale2 >= scale then
                set r4 = ((scale2 - scale) / (rmax * 100)) * 3
                set check2 = 0
            else
                set r4 = ((scale - scale2) / (rmax * 100)) * 3
                set check2 = 1
            endif
            if MUI_18 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_HealOverTime
        private static integer array m_19
        private static integer MUI_19 = -1
        real r
        real r2
        real r3
        real rmax
        integer check
        unit td
        unit c

        public static method Loop_HpS takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rer
            loop
                exitwhen i > MUI_19
                set this = m_19[i]
                if r <= rmax  then
                    set r = RoundReal(r + 0.05, 3)
                    if r2>0.95 then 
                    set r2 = 0.05
                    if check == 0 then
                        if (GetUnitState(td,UNIT_STATE_LIFE)+r3)> GetUnitState(td,UNIT_STATE_MAX_LIFE)  then 
                        set rer = GetUnitState(td,UNIT_STATE_MAX_LIFE) - GetUnitState(td,UNIT_STATE_LIFE)
                        else
                        set rer = r3
                        endif
                        if rer >0 then 
                        call SetHpCurrent2(c,td, r3)
                        endif
                    else
                        call SetMpCurrent(c, r3)
                    endif
                        else
                        set r2 = r2 + 0.05
                        endif
                    else
                    set c = null
                    set td = null
                    set m_19[i] = m_19[MUI_19]
                    set MUI_19 = MUI_19 - 1
                    if MUI_19 == -1 then
                        call GearTimer05Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HPS_Start takes unit NewC,unit NewTd, integer NewCheck, real NewHeal, real NewMax returns nothing
            local thistype this = thistype.create()
            set MUI_19 = MUI_19 + 1
            set m_19[MUI_19] = this
            set r = 0
            set c = NewC
            set td = NewTd
            set r2 = 0
            set check = NewCheck
            set r3 = (NewHeal / (NewMax ))
            set rmax = NewMax
            if MUI_19 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct KS_LightningColor
        private static integer array m_20
        private static integer MUI_20 = -1
        real r
        real r2
        real r3
        boolean b
        lightning light
        real red_r
        real green_r
        real blue_r
        real r4
        real r5
        real rmax
        integer check

        public static method Loop_ColorLightning takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_20
                set this = m_20[i]
                set r2 = RoundReal(r2 + 0.03, 3)
                if check == 0 then
                    if r2 > r3 then
                        if r < rmax then
                            set r = RoundReal(r + 0.03, 3)
                            set r5 = r5 + r4
                            if r5 > 1 then
                                set r5 = 1
                            endif
                            if b == false then
                                call SetLightningColor(light, red_r, green_r, blue_r, 1 - r5)
                            else
                                call SetLightningColor(light, red_r, green_r, blue_r, r5)
                            endif
                        else
                            set check = 1
                        endif
                    endif
                else
                    if b == false then
                        call DestroyLightning(light)
                    endif
                    set light = null
                    set m_20[i] = m_20[MUI_20]
                    set MUI_20 = MUI_20 - 1
                    if MUI_20 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method ColorLightning_Start takes lightning NewLight, real NewR3, real NewRed, real NewGreen, real NewBlue, real NewRmax , boolean NewCond returns nothing
            local thistype this = thistype.create()
            set MUI_20 = MUI_20 + 1
            set m_20[MUI_20] = this
            set light = NewLight
            set r = 0
            set check = 0
            set rmax = NewRmax
            set red_r = NewRed
            set green_r = NewGreen
            set blue_r = NewBlue
            set r2 = 0
            set r5 = 0
            set r3 = NewR3
            set r4 = ((1 / (rmax * 100)) * 3)
            set b = NewCond
            if MUI_20 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_TextTagDelay
        private static integer array m_21
        private static integer MUI_21 = -1
        real r
        real scale
        integer red_i
        integer green_i
        integer blue_i
        real rmax
        string s
        integer check
        unit c

        public static method Loop_TT_DELAY takes nothing returns nothing
            local thistype this
            local integer i = 0
            local texttag l__txt
            local integer loopPlayers = 0
            loop
                exitwhen i > MUI_21
                set this = m_21[i]
                if r < rmax then
                    set r = RoundReal(r + 0.05, 3)
                else
                    set l__txt = CreateTextTag()
                    call SetTextTagVisibility(l__txt, false)
                    loop
                        exitwhen loopPlayers >= 11
                        if IsUnitVisible(c, Player(loopPlayers)) then
                            if GetLocalPlayer() == Player(loopPlayers) then
                                call SetTextTagVisibility(l__txt, true)
                            endif
                        endif
                        set loopPlayers = loopPlayers + 1
                    endloop
                    call SetTextTagText(l__txt, s, scale)
                    call SetTextTagPosUnit(l__txt, c, 20)
                    call SetTextTagColor(l__txt, red_i, green_i, blue_i, check)
                    call SetTextTagVelocity(l__txt, 0.1 * Cos(1.571), 0.1 * Sin(1.571))
                    call SetTextTagFadepoint(l__txt, .5)
                    call SetTextTagLifespan(l__txt, 0.85)
                    call SetTextTagPermanent(l__txt, false)
                    set c = null
                    set s = null
                    set m_21[i] = m_21[MUI_21]
                    set MUI_21 = MUI_21 - 1
                    if MUI_21 == -1 then
                        call GearTimer05Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
            set l__txt = null
        endmethod

        public static method TexttagDelay_Start takes string NewS, unit NewC, integer NewRed, integer NewGreen, integer NewBlue, integer NewAlpha, real NewScale, real NewRmax returns nothing
            local thistype this = thistype.create()
            set MUI_21 = MUI_21 + 1
            set m_21[MUI_21] = this
            set s = NewS
            set c = NewC
            set r = 0
            set rmax = NewRmax
            set red_i = NewRed
            set green_i = NewGreen
            set blue_i = NewBlue
            set check = NewAlpha
            set scale = NewScale
            set rmax = NewRmax
            if MUI_21 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct KS_Fear
        private static integer array m_22
        private static integer MUI_22 = -1
        real r
        real r2
        effect e
        real a
        real rmax
        real move
        unit td
        unit c

        public static method Loop_Fear takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rer
            loop
                exitwhen i > MUI_22
                set this = m_22[i]
                if r < rmax and GetWidgetLife(c) > 1 and GetUnitAbilityLevel(c, 'A15H') == 0 then
                    set r = RoundReal(r + 0.03, 3)
                    call EffVision(e, c)
                    call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), GetUnitFlyHeight(c))
                    if r2 > 0.12 then
                        set r2 = 0
                        call IssuePointOrder(c, "move", GetUnitX(c) + 600 * Cos(a), GetUnitY(c) + 600 * Sin(a))
                        call UnitAddAbility(c, 'Abun')
                        if GetLocalPlayer() == GetOwningPlayer(c) then
                            call EnableUserControl(false)
                        endif
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call EnableUserControl(true)
                    endif
                    call IssueImmediateOrder(c, "stop")
                    call UnitRemoveAbility(c, 'Abun')
                    call UnitRemoveAbility(c, 'B0A5')
                    call DestroyEffect(e)
                    call SaveInteger(hs, GetHandleId(c) , StringHash("AsNodt pas"), 0)
                    set c = null
                    set e = null
                    set m_22[i] = m_22[MUI_22]
                    set MUI_22 = MUI_22 - 1
                    if MUI_22 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method Fear_Start takes unit NewC, real NewAngle, real NewMax returns nothing
            local thistype this = thistype.create()
            set MUI_22 = MUI_22 + 1
            set m_22[MUI_22] = this
            set r = 0
            set c = NewC
            set a = NewAngle
            set r2 = 0
            set rmax = NewMax
            call UnitAddAbility(c, 'Abun')
            set e = AddSpecialEffect("war3mapimported\\Gear_0233.mdl", GetUnitX(c), GetUnitY(c))
            call BlzSetSpecialEffectTimeScale(e, 1)
            call BlzSetSpecialEffectZ(e, 0)
            call BlzSetSpecialEffectScale(e, 2)
            call BlzSetSpecialEffectYaw(e, GetUnitFacing(c) * bj_DEGTORAD)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call EnableUserControl(false)
            endif
            if MUI_22 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_AbilityLevel
        private static integer array m_23
        private static integer MUI_23 = -1
        real r
        boolean b
        real rmax
        integer id
        integer check
        unit c

        public static method Loop_SetAbilityLevel takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_23
                set this = m_23[i]
                if r < rmax then
                    set r = RoundReal(r + 0.1, 3)
                else
                    if b == true then
                        set check = GetUnitAbilityLevel(c, id) - 1
                    endif
                    call SetUnitAbilityLevel(c, id, check)
                    if b == true and GetUnitAbilityLevel(c, id) == 1 then
                        set b = false
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("spell and " + I2S(id)), 0)
                    endif
                    if b == false then
                        set c = null
                        set m_23[i] = m_23[MUI_23]
                        set MUI_23 = MUI_23 - 1
                        if MUI_23 == -1 then
                            call GearTimer10Release()
                        endif
                        call destroy()
                    set i = i - 1
                    else
                        if GetUnitAbilityLevel(c, id) > 1 then
                            set r = 0
                            set check = GetUnitAbilityLevel(c, id) - 1
                        endif
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method SetAbilityLevel_Start takes unit NewC, real NewRmax, integer NewId, integer NewLvl, boolean infinity returns nothing
            local thistype this = thistype.create()
            set MUI_23 = MUI_23 + 1
            set m_23[MUI_23] = this
            set c = NewC
            set rmax = NewRmax
            set b = infinity
            set r = 0
            set id = NewId
            if b == false then
                set check = NewLvl
            else
                set check = GetUnitAbilityLevel(c, id) - 1
            endif
            if MUI_23 == 0 then
                call GearTimer10Acquire()
            endif
        endmethod

    endstruct

    private struct KS_Cooldown
        private static integer array m_24
        private static integer MUI_24 = -1
        real r
        real r4
        real rmax
        integer check
        unit c

        public static method Loop_NextCD takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_24
                set this = m_24[i]
                if r < rmax then
                    set r = RoundReal(r + 0.05, 3)                  
                else
                    if BlzGetUnitAbilityCooldownRemaining(c,check)>r4 then 
                   call BlzStartUnitAbilityCooldown(c,check,r4)
                   endif
                        set c = null
                        set m_24[i] = m_24[MUI_24]
                        set MUI_24 = MUI_24 - 1
                        if MUI_24 == -1 then
                            call GearTimer05Release()
                        endif
                        call destroy()
                    set i = i - 1
                    endif
                set i = i + 1
            endloop
        endmethod   

        public static method CD_Start takes unit NewC, real NewRmax,integer NewAbi,real NewCd returns nothing
            local thistype this = thistype.create()
            set MUI_24 = MUI_24 + 1
            set m_24[MUI_24] = this
            set c = NewC
            set rmax = NewRmax
            set r = 0
            set r4 = NewCd
            set check = NewAbi
            if MUI_24 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct KS_FakeCooldown
        private static integer array m_25
        private static integer MUI_25 = -1
        real r
        boolean b
        real r4
        real rmax
        integer check
        integer check2
        integer k2
        integer k3
        integer count
        unit c

         public static method Loop_NextFakeCD takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_25
                set this = m_25[i]
                if check2 != 0 then 
                set b = LoadInteger(hs,GetHandleId(c),check2) != k2
                else
                set b = true
                endif
                if r < rmax and BlzGetUnitAbilityCooldownRemaining(c,k3)>0 and b and GetUnitAbilityLevel(c,k3)>0 then
                    set r = RoundReal(r + 0.05, 3)
                else                
                if check2 != 0 then 
                call SaveInteger(hs,GetHandleId(c),check2,k2)
                if LoadInteger(hs,GetHandleId(c),StringHash("pas cd")) == 0 then 
                endif
                endif             
                   if check == InoriE_ID and LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
                   
                   elseif check == AlterSaberW_ID and LoadInteger(hs, GetHandleId(c), StringHash("mode r")) == 1 then
                  
                  else
                  // decrement counter
call SaveInteger(hs, GetHandleId(c), StringHash("fake cd count"), LoadInteger(hs, GetHandleId(c), StringHash("fake cd count")) - 1)

// only remove FakeAbi if no other instance is using it
if LoadInteger(hs, GetHandleId(c), StringHash("fake cd count")) <= 0 then
    call SaveInteger(hs, GetHandleId(c), StringHash("fake cd count"), 0)
    call UnitRemoveAbility(c, k3)
    call SetPlayerAbilityAvailable(GetOwningPlayer(c), check, true)
else
    // another instance still running, just restore this ability
    //call SetPlayerAbilityAvailable(GetOwningPlayer(c), check, true)
endif
                      endif
                      set c = null
                        set m_25[i] = m_25[MUI_25]
                        set MUI_25 = MUI_25 - 1
                        if MUI_25 == -1 then
                            call GearTimer05Release()
                        endif
                        call destroy()
                    set i = i - 1
                    endif
                set i = i + 1
            endloop
        endmethod   

        public static method FakeCD_Start1 takes unit NewC,integer NewAbi,real NewCd, integer NewStringHash, integer NewValue returns nothing
            local thistype this = thistype.create()
            set MUI_25 = MUI_25 + 1
            set m_25[MUI_25] = this
            set c = NewC
           //  if GetUnitAbilityLevel(NewC, FakeAbi_ID) > 0 then
           // set k3 = FakeAbi2_ID
       // else
            set k3 = FakeAbi_ID
          //  endif
            set rmax = NewCd
            set r = 0.05
            set b = true
            set check2 = NewStringHash
            set k2 = NewValue
            set r4 = NewCd
            set check = NewAbi
            // In FakeCD_Start1, before adding FakeAbi:
call SaveInteger(hs, GetHandleId(c), StringHash("fake cd count"), LoadInteger(hs, GetHandleId(c), StringHash("fake cd count")) + 1)
if LoadInteger(hs, GetHandleId(c), StringHash("fake cd count")) == 1 then
call UnitAddAbility(NewC, k3)
endif
// ... rest of setup
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),check,false)
            if GetLocalPlayer() == GetOwningPlayer(c) then
            call BlzSetAbilityPosX(k3,BlzGetAbilityPosX(check))
            call BlzSetAbilityPosY(k3,BlzGetAbilityPosY(check))
            call BlzSetAbilityIcon(k3, BlzGetAbilityIcon(check))
            call BlzSetAbilityTooltip(k3,BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, check), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(c,check)-1),0)
            call BlzSetAbilityExtendedTooltip(k3,BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, check), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(c,check)-1),0)
            endif
            if  HasCachedItem(c,'I011')>0 and  BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
             call BlzStartUnitAbilityCooldown(c,k3,r4*(1-OkarunEggReduceCD/100))
            else
             call BlzStartUnitAbilityCooldown(c,k3,r4)
            endif
            if MUI_25 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct KS_EffectHeight
        private static integer array m_26
        private static integer MUI_26 = -1
        real r
        real r2
        real r3
        effect e
        real r4
        real r5
        real rmax
        integer check
        integer check2
        integer check3
        real f

        public static method ELoopHeightSet takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_26
                set this = m_26[i]
                set r2 = RoundReal(r2 + 0.03, 3)
                if check == 0 then
                    if r2 > r5 then
                    if check3 == 0 then 
                    set check3 = 1
                    set f = BlzGetLocalSpecialEffectZ(e)
                if r3 >= f then
                set r4 = ((r3 - f) / (rmax * 100)) * 3
                set check2 = 0
            else
                set r4 = ((f - r3) / (rmax * 100)) * 3
                set check2 = 1
                set f = 0
            endif
                    endif
                        if r <= rmax then
                            set r = RoundReal(r + 0.03, 3)
                            if check2 == 0 then
                                set f = BlzGetLocalSpecialEffectZ(e) + r4
                            else
                                set f = BlzGetLocalSpecialEffectZ(e) - r4
                            endif
                            call BlzSetSpecialEffectHeight(e, f)
                        else
                            set check = 1
                        endif
                    endif
                else
                    set e = null
                    set m_26[i] = m_26[MUI_26]
                    set MUI_26 = MUI_26 - 1
                    if MUI_26 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method EHeightSet_Start takes effect NewC, real NewRmax, real NewFly, real NewWait returns nothing
            local thistype this = thistype.create()
            set MUI_26 = MUI_26 + 1
            set m_26[MUI_26] = this
            set e = NewC
            set r = 0
            set r2 = 0
            set r3 = NewFly
            set r5 = NewWait
            set f = BlzGetLocalSpecialEffectZ(e)
            set check = 0
            set check3 = 0
            set rmax = NewRmax
            if r3 >= f then
                set r4 = ((r3 - f) / (rmax * 100)) * 3
                set check2 = 0
            else
                set r4 = ((f - r3) / (rmax * 100)) * 3
                set check2 = 1
                set f = 0
            endif
            if MUI_26 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_RemoveDestructable
        private static integer array m_27
        private static integer MUI_27 = -1
        real r
        real r3
        destructable ds
        real rmax
        string s
        integer check
        integer k
        unit c

        public static method Loop_MyRemoveDest takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_27
                set this = m_27[i]
                if r < rmax and  GetDestructableLife(ds)>2 then
                    set r = RoundReal(r + 0.03, 3)
                    if CondArena == 0 then 
                    set r = 99999
                    endif
                else
                    if check == 0 then
                        call RemoveDestructable(ds)
                    elseif check == 1 then
                    if GetDestructableLife(ds)>2 then 
                       call SetDestructableAnimation(ds,"death")
                    endif
                    elseif check == 2 then
                      //  call SetUnitAnimationByIndex(c, k)
                    elseif check == 3 then
                      //  call SetUnitAnimation(c, s)
                    endif
                    set ds = null
                    set m_27[i] = m_27[MUI_27]
                    set MUI_27 = MUI_27 - 1
                    if MUI_27 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyRemoveDest_Start takes destructable NewDS, real NewRmax, integer WhichAction, real AddR, integer AddI, string AddS returns nothing
            local thistype this = thistype.create()
            set MUI_27 = MUI_27 + 1
            set m_27[MUI_27] = this
            set ds = NewDS
            set check = WhichAction // 0 - remove, 1 - set anim speed, 2 set anim int, 3 - set anim string
            if check == 1 then
                set r3 = AddR
            elseif check == 2 then
                set k = AddI
            elseif check == 3 then
                set s = AddS
            endif
            set r = 0
            set rmax = NewRmax
            if MUI_27 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct KS_BuffTimer
        private static integer array m_28
        private static integer MUI_28 = -1
        private static framehandle array frame0_pas1
        private static framehandle array frame0_pas2
        private static framehandle array frame0_pas3
        private static framehandle array frame0_pas4
        real r
        boolean b
        boolean b2
        real rmax
        string s
        integer id
        integer check
        integer check2
        integer k
        integer k2
        integer k3
        integer count
        unit c

        public static method Loop_MyBuffTime takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_28
                set this = m_28[i]
                if check2 == 1 then 
                set b2 = r < rmax
                else
                set b2 =  r < rmax and GetUnitAbilityLevel(c,id)>0
                endif
                if b2 then
                    if b == false or IsUnitPaused(c)== false then 
                    set r = RoundReal(r + 0.1, 3)
                    endif
                    call BlzFrameSetValue(frame0_pas3[k2], r)
                    call BlzFrameSetText(frame0_pas4[k2], "" + R2SW(rmax+0.1-r,0,1) + "|r")
                    if check != 0 then 
                    
                    endif
                  //  call BlzFrameSetValue(frame0_pas2[k2], rmax-r)
                    if CondArena == 0 then 
                    set r = 99999
                    endif
                else
                    call UnitRemoveAbility(c,id)
                    if GetLocalPlayer() == Player(k) then 
                    call BlzFrameSetVisible(frame0_pas1[k2],false)
                    call BlzFrameSetVisible(frame0_pas4[k2],false)
                    endif
                    set c = null
                    set m_28[i] = m_28[MUI_28]
                    set MUI_28 = MUI_28 - 1
                    if MUI_28 == -1 then
                        call GearTimer10Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyBuffTime_Start takes unit NewC,integer NewId, real NewRmax, string NewS,boolean NewPauseCount, integer NewPlayerId, integer IgnoreBuff, integer NewSh, integer count  returns nothing
            local thistype this = thistype.create()
            local real tmp_x = 0
            local real tmp_y = 0
            set MUI_28 = MUI_28 + 1
            set m_28[MUI_28] = this
            set c = NewC
            set id = NewId
            set s = NewS
            set k3 = count
            set check = NewSh
            set check2 = IgnoreBuff
            set rmax = NewRmax
            set b = NewPauseCount
            if NewPlayerId == -1 then 
            set k2 = GetPlayerId(GetOwningPlayer(c))
            else
            set k2 = NewPlayerId
            endif
            set k = k2
            // 24 позиции на слот исключают пересечение игроков 10+ с соседним UI-слотом.
            set k2 = k2 + (k3*24)+1
            set tmp_x = 0.26875 +(0.0265*k3) //* 0.0225
                set tmp_y = 0.17
                if frame0_pas1[k2] == null then 
                set frame0_pas1[k2] = BlzCreateFrameByType("SIMPLEFRAME", "2Face", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
                call BlzFrameClearAllPoints(frame0_pas1[k2])
                    call BlzFrameSetVisible(frame0_pas1[k2],false)
                if GetLocalPlayer() == Player(k) then 
                    call BlzFrameSetVisible(frame0_pas1[k2],true)
                    endif
                set frame0_pas2[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceBackGround", frame0_pas1[k2], "", 0)
                set frame0_pas3[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceForeGround", frame0_pas2[k2], "", 0)
                call BlzFrameClearAllPoints(frame0_pas2[k2])
                call BlzFrameClearAllPoints(frame0_pas3[k2])
                call BlzFrameSetAllPoints(frame0_pas2[k2], frame0_pas1[k2])
                call BlzFrameSetAllPoints(frame0_pas3[k2], frame0_pas1[k2])
                call BlzFrameSetSize(frame0_pas1[k2], 0.025, 0.025)
                set frame0_pas4[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
                //call BlzFrameSetPoint(frame0_pas4[k2], FRAMEPOINT_TOP, frame0_pas1[k2], FRAMEPOINT_BOTTOM, 0, -0.005)
                //call BlzFrameSetPoint(frame0_pas4[k2], FRAMEPOINT_BOTTOMLEFT,frame0_pas1[k2],FRAMEPOINT_BOTTOMLEFT, tmp_x-0.0265, tmp_y-0.335)
                
                call BlzFrameSetAbsPoint(frame0_pas4[k2], FRAMEPOINT_CENTER, tmp_x+0.0925, tmp_y-0.075)
                call BlzFrameSetScale(frame0_pas4[k2], 1)
                call BlzFrameSetSize(frame0_pas4[k2], 0.2, 0.2)
                 call BlzFrameSetVisible(frame0_pas4[k2],false)
                if GetLocalPlayer() == Player(k) then 
                    call BlzFrameSetVisible(frame0_pas4[k2],true)
                    endif
                else
                 if GetLocalPlayer() == Player(k) then 
                    call BlzFrameSetVisible(frame0_pas1[k2],true)
                    call BlzFrameSetVisible(frame0_pas4[k2],true)
                    endif
                endif
                call BlzFrameSetMinMaxValue(frame0_pas3[k2], 0, rmax)
                call BlzFrameSetValue(frame0_pas2[k2], 100)
                call BlzFrameSetValue(frame0_pas3[k2], 0)
                call BlzFrameSetText(frame0_pas4[k2], "" + R2SW(rmax,0,1) + "|r")
                call BlzFrameSetAbsPoint(frame0_pas1[k2], FRAMEPOINT_CENTER, tmp_x, tmp_y)
                call BlzFrameSetTexture(frame0_pas2[k2], "ReplaceableTextures\\CommandButtons\\"+s+".blp", 0, false)
                call BlzFrameSetTexture(frame0_pas3[k2], "ReplaceableTextures\\CommandButtonsDisabled\\DIS"+s+".blp", 0, false)
                
                    call BlzFrameSetEnable(frame0_pas1[k2],false)
                    call BlzFrameSetEnable(frame0_pas2[k2],false)
                    call BlzFrameSetEnable(frame0_pas3[k2],false)
                    call BlzFrameSetEnable(frame0_pas4[k2],false)
                set r = 0
            if MUI_28 == 0 then
                call GearTimer10Acquire()
            endif
        endmethod

    endstruct

    private struct KS_BuffEffect
        private static integer array m_29
        private static integer MUI_29 = -1
        real r
        effect e
        real rmax
        integer id
        integer k2
        unit c

        public static method Loop_MyBuffEff takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_29
                set this = m_29[i]
                if r < rmax and GetUnitAbilityLevel(c,id)>0 then
                    set r = RoundReal(r + 0.1, 3)
                    else
                    call DestroyEffect(e)
                    set e = null
                    set c = null
                    set m_29[i] = m_29[MUI_29]
                    set MUI_29 = MUI_29 - 1
                    if MUI_29 == -1 then
                        call GearTimer10Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyBuffEff_Start takes unit NewC,integer NewId, effect NewE returns nothing
            local thistype this = thistype.create()
            local real tmp_x = 0
            local real tmp_y = 0
            set MUI_29 = MUI_29 + 1
            set m_29[MUI_29] = this
            set c = NewC
            set id = NewId
            set e = NewE
            set rmax = 125
            set k2 = GetPlayerId(GetOwningPlayer(c))
                set r = 0
            if MUI_29 == 0 then
                call GearTimer10Acquire()
            endif
        endmethod

    endstruct

    private struct KS_FlushInteger
        private static integer array m_30
        private static integer MUI_30 = -1
        real r
        boolean b
        real rmax
        integer child_id
        integer value
        integer id
        unit c

        public static method Loop_MyFlushIntegerC takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_30
                set this = m_30[i]
                if r < rmax then
                    if b == true then
                    set r = RoundReal(r + 0.03, 3)
                    elseif IsUnitPaused(c) == false then 
                    set r = RoundReal(r + 0.03, 3)
                    endif
                    if LoadInteger(hs, id, child_id) == value then
                        set r = 9999
                    endif
                else
                    if r != 9999 then
                        call SaveInteger(hs, id, child_id, value)
                    endif
                    set c = null
                    set m_30[i] = m_30[MUI_30]
                    set MUI_30 = MUI_30 - 1
                    if MUI_30 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyFlushIC_Start takes  unit NewC, integer NewChild_Id, integer NewValue, real NewRmax,boolean CountInPause returns nothing
            local thistype this = thistype.create()
            set MUI_30 = MUI_30 + 1
            set m_30[MUI_30] = this
            set r = 0
            set c = NewC
            set b = CountInPause
            set rmax = NewRmax
            set id = GetHandleId(c)
            set child_id = NewChild_Id
            set value = NewValue
            if MUI_30 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct

    
// Фрагмент для замены KS_ItemStacks/KS_SpellStacks внутри GearSystems.
// В заголовок GearSystems добавьте: requires TasAbilityChargeBox

    private struct KS_ItemStacks
        private static integer array m_31
        private static integer MUI_31 = -1
        real r
        boolean b
        real rmax
        integer id
        integer check
        unit c

        public static method Loop_AddStacks takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer itemSlot
            local item stackItem
            loop
                exitwhen i > MUI_31
                set this = m_31[i]
                if r < rmax then
                    set r = RoundReal(r + 0.05, 3)
                else
                    // За время таймера предмет могли выбросить или передать.
                    set itemSlot = -1
                    set stackItem = null
                    if c != null then
                        set itemSlot = IsItemInInventory3(c, id)
                    endif
                    if itemSlot >= 0 then
                        set stackItem = UnitItemInSlot(c, itemSlot)
                        if stackItem != null then
                            if b == true then
                                call SetItemCharges(stackItem, GetItemCharges(stackItem) + check)
                            else
                                call SetItemCharges(stackItem, GetItemCharges(stackItem) - check)
                            endif
                            if id == 'I01W' and GetItemCharges(stackItem) > 0 then
                                call BlzEndUnitAbilityCooldown(c, 'A07O')
                            endif
                        endif
                    endif
                    set stackItem = null
                    set c = null
                    set m_31[i] = m_31[MUI_31]
                    set MUI_31 = MUI_31 - 1
                    if MUI_31 == -1 then
                        call GearTimer05Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MyAddStacks_Start takes  unit NewC, integer NewItem_Id, integer NewStackAmount, real NewRmax,boolean AddOrRemove returns nothing
            local thistype this = thistype.create()
            set MUI_31 = MUI_31 + 1
            set m_31[MUI_31] = this
            set r = 0
            set c = NewC
            set b = AddOrRemove
            set rmax = NewRmax
            set id = NewItem_Id
            set check = NewStackAmount
            if MUI_31 == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

    endstruct
    
        struct KS_SpellStacks
        private static integer array instances
        private static integer lastInstance = -1

        // Минимальная пауза между применениями, пока у способности еще есть заряды.
        // Меняется в одном месте для всех экземпляров KS_SpellStacks.
        public static real STACK_USE_COOLDOWN = 0.25

        real r
        real rmax
        integer maxStacks
        integer frameAbilityId
        integer cooldownAbilityId
        unit c
        boolean regenEnabled
        boolean frameSuppressed
        boolean instantRecharge

        // Поля оставлены ради совместимости со старыми сохранениями структуры.
        // Визуал теперь полностью рисует TasAbilityChargeBox.
        framehandle frameRoot
        framehandle frameIcon

        private static method FindByUnit takes unit whichUnit returns thistype
            local integer i = 0
            local thistype data
            loop
                exitwhen i > lastInstance
                set data = instances[i]
                if data.c == whichUnit then
                    return data
                endif
                set i = i + 1
            endloop
            return 0
        endmethod

        public static method GetSlotByXY takes integer x, integer y returns integer
            return y * 4 + x
        endmethod

        private method CreateStackFrame takes nothing returns nothing
            // TasAbilityChargeBox сам создаёт и привязывает нужные фреймы.
        endmethod
        private method RefreshStackFrameVisibility takes integer stackNum returns nothing
            if frameSuppressed or stackNum <= 0 then
                call TasAbilityChargeBox_Clear(c)
            endif
        endmethod

        private method DestroyStackFrame takes nothing returns nothing
            call TasAbilityChargeBox_Clear(c)
            if frameAbilityId != 0 and c != null then
                call BlzUnitDisableAbility(c, frameAbilityId, false, false)
            endif
            set frameIcon = null
            set frameRoot = null
        endmethod

        // The public signature stays unit + stack count. It finds that hero's
        // own structure instance and never touches another hero's frames.
        public static method UpdateStackFrame takes unit cu, integer stackNum returns nothing
            local thistype data = thistype.FindByUnit(cu)
            local integer hid = GetHandleId(cu)

            if data == 0 then
                return
            endif

            if stackNum <= 0 then
                set stackNum = 0
                call SaveInteger(hs, hid, StringHash("stack_count"), 0)
                call TasAbilityChargeBox_Clear(cu)
                if data.frameAbilityId != 0 then
                    // Нулевой счётчик скрываем, но саму кнопку не выключаем.
                    // Доступность способности регулирует её настоящий cooldown.
                    call BlzUnitDisableAbility(cu, data.frameAbilityId, false, false)
                endif
            else
                if stackNum > data.maxStacks then
                    set stackNum = data.maxStacks
                    call SaveInteger(hs, hid, StringHash("stack_count"), stackNum)
                endif
                if data.frameAbilityId != 0 then
                    call BlzUnitDisableAbility(cu, data.frameAbilityId, false, false)
                endif
            endif
            if data.frameSuppressed then
                call TasAbilityChargeBox_Clear(cu)
            elseif data.frameAbilityId != 0 and stackNum > 0 then
                call TasAbilityChargeBox_SetValue(cu, data.frameAbilityId, I2S(stackNum))
            endif
            // Clear удаляет запись, а Update сразу скрывает сам FrameBox.
            // При первом положительном стаке эта же перерисовка возвращает окно.
            call TasAbilityChargeBox_Update()
        endmethod

        private static method RemoveAt takes integer index returns nothing
            local thistype data = instances[index]

            call data.DestroyStackFrame()
            call SaveInteger(hs, GetHandleId(data.c), StringHash("stack_count"), 0)
            set data.c = null

            set instances[index] = instances[lastInstance]
            set lastInstance = lastInstance - 1
            if lastInstance == -1 then
                call GearTimer05Release()
            endif
            call deallocate(data)
        endmethod

        public static method Loop_AddSpellStacks takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer curStack

            loop
                exitwhen i > lastInstance
                set this = instances[i]

                if GetUnitTypeId(c) == 0 or LoadInteger(hs, GetHandleId(c), StringHash("morph_end")) == 1 then
                    call thistype.RemoveAt(i)
                    set i = i - 1
                else
                    set curStack = LoadInteger(hs, GetHandleId(c), StringHash("stack_count"))

                    if not regenEnabled then
                        set r = 0.00
                    elseif curStack == 0 and frameAbilityId != 0 and BlzGetUnitAbilityCooldownRemaining(c, frameAbilityId) <= 0.00 then
                        // Если движок не запустил cooldown, не оставляем героя
                        // навсегда с нулевым счётчиком: сразу возвращаем 1 заряд.
                        set r = 0.00
                        set curStack = 1
                        call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
                        call thistype.UpdateStackFrame(c, curStack)
                    elseif curStack < maxStacks then
                        if instantRecharge then
                            set r = 0.00
                            set curStack = maxStacks
                            call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
                            call thistype.UpdateStackFrame(c, curStack)
                        else
                            set r = RoundReal(r + 0.05, 3)
                            if r >= rmax then
                                set r = r - rmax
                                set curStack = curStack + 1
                                call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
                                if cooldownAbilityId != 0 then
                                    call BlzStartUnitAbilityCooldown(c, cooldownAbilityId, 0.2)
                                endif
                                // Снимаем ожидание восстановления только когда
                                // появился первый заряд. Если заряд уже был,
                                // не прерываем 0.25 между применениями.
                                if curStack == 1 and frameAbilityId != 0 then
                                    call BlzEndUnitAbilityCooldown(c, frameAbilityId)
                                endif
                                call thistype.UpdateStackFrame(c, curStack)
                            endif
                        endif
                    else
                        set r = 0.00
                        if curStack != maxStacks then
                            set curStack = maxStacks
                            call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
                        endif
                    endif

                    // This also switches UI correctly when the player selects
                    // another hero whose stack icon occupies the same slot.
                    call this.RefreshStackFrameVisibility(curStack)
                endif

                set i = i + 1
            endloop
        endmethod

        // frameAbilityId: ability whose command-card button receives the icon.
        // cooldownAbilityId: ability refreshed on charge gain; pass 0 if unused.
        public static method MyAddSpellStacks_Start takes unit NewC, integer NewFrameAbilityId, integer NewCooldownAbilityId, integer NewMaxStacks, real NewRmax returns nothing
            local thistype this = thistype.FindByUnit(NewC)
            local integer curStack
            local integer oldAbilityId

            // Reconfigure an existing tracker instead of creating a duplicate.
            if this != 0 then
                set oldAbilityId = frameAbilityId
                if oldAbilityId != 0 and oldAbilityId != NewFrameAbilityId then
                    call BlzUnitDisableAbility(c, oldAbilityId, false, false)
                endif
                set frameAbilityId = NewFrameAbilityId
                set cooldownAbilityId = NewCooldownAbilityId
                set maxStacks = NewMaxStacks
                if maxStacks < 1 then
                    set maxStacks = 1
                endif
                set rmax = NewRmax
                set instantRecharge = rmax <= 0.00
                if rmax < 0.05 then
                    set rmax = 0.05
                endif
                if r > rmax then
                    set r = rmax
                endif
                set regenEnabled = true
                set frameSuppressed = false
                call this.DestroyStackFrame()
                set curStack = LoadInteger(hs, GetHandleId(c), StringHash("stack_count"))
                if instantRecharge and curStack < maxStacks then
                    set curStack = maxStacks
                    call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
                endif
                call thistype.UpdateStackFrame(c, curStack)
                call SaveInteger(hs, GetHandleId(c), StringHash("morph_end"), 0)
                return
            endif

            set this = thistype.create()
            set c = NewC
            set r = 0.00
            set rmax = NewRmax
            set instantRecharge = rmax <= 0.00
            if rmax < 0.05 then
                set rmax = 0.05
            endif
            set maxStacks = NewMaxStacks
            if maxStacks < 1 then
                set maxStacks = 1
            endif
            set frameAbilityId = NewFrameAbilityId
            set cooldownAbilityId = NewCooldownAbilityId
            set regenEnabled = true
            set frameSuppressed = false
            set frameRoot = null
            set frameIcon = null

            set lastInstance = lastInstance + 1
            set instances[lastInstance] = this

            call SaveInteger(hs, GetHandleId(c), StringHash("morph_end"), 0)
            set curStack = LoadInteger(hs, GetHandleId(c), StringHash("stack_count"))
            // Новая система зарядов начинает работу заполненной.
            if curStack <= 0 then
                set curStack = maxStacks
                call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
            elseif curStack > maxStacks then
                set curStack = maxStacks
                call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
            endif
            call thistype.UpdateStackFrame(c, curStack)

            if lastInstance == 0 then
                call GearTimer05Acquire()
            endif
        endmethod

        private static method DelayedCooldownResetCallback takes nothing returns nothing
            local timer resetTimer = GetExpiredTimer()
            local integer timerId = GetHandleId(resetTimer)
            local unit resetUnit = LoadUnitHandle(hs, timerId, StringHash("KS_SpellStacks_ResetUnit"))
            local integer abilityId = LoadInteger(hs, timerId, StringHash("KS_SpellStacks_ResetAbility"))
            local real cooldown = LoadReal(hs, timerId, StringHash("KS_SpellStacks_ResetCooldown"))

            // Движок назначает cooldown после spell-event, поэтому меняем его с задержкой.
            if resetUnit != null and GetUnitTypeId(resetUnit) != 0 and abilityId != 0 then
                if LoadInteger(hs, GetHandleId(resetUnit), StringHash("stack_count")) > 0 then
                    // cooldown > 0 означает паузу между двумя оставшимися зарядами.
                    // cooldown == 0 используется при выдаче/полном сбросе зарядов.
                    if cooldown > 0.00 then
                        call BlzStartUnitAbilityCooldown(resetUnit, abilityId, cooldown)
                    else
                        call BlzEndUnitAbilityCooldown(resetUnit, abilityId)
                    endif
                else
                    if cooldown < thistype.STACK_USE_COOLDOWN then
                        set cooldown = thistype.STACK_USE_COOLDOWN
                    endif
                    call BlzStartUnitAbilityCooldown(resetUnit, abilityId, cooldown)
                endif
            endif

            call FlushChildHashtable(hs, timerId)
            call PauseTimer(resetTimer)
            call DestroyTimer(resetTimer)
            set resetUnit = null
            set resetTimer = null
        endmethod

        private static method ScheduleCooldownReset takes unit cu, integer abilityId, real cooldown returns nothing
            local timer resetTimer = CreateTimer()
            local integer timerId = GetHandleId(resetTimer)

            call SaveUnitHandle(hs, timerId, StringHash("KS_SpellStacks_ResetUnit"), cu)
            call SaveInteger(hs, timerId, StringHash("KS_SpellStacks_ResetAbility"), abilityId)
            call SaveReal(hs, timerId, StringHash("KS_SpellStacks_ResetCooldown"), cooldown)
            call TimerStart(resetTimer, 0.03, false, function thistype.DelayedCooldownResetCallback)
            set resetTimer = null
        endmethod

        public static method MyRemoveStack takes unit cu returns nothing
            local thistype data = thistype.FindByUnit(cu)
            local integer hid = GetHandleId(cu)
            local integer curStack = LoadInteger(hs, hid, StringHash("stack_count"))

            if data == 0 or curStack <= 0 then
                return
            endif

            set curStack = curStack - 1
            if data.instantRecharge then
                set curStack = curStack + 1
                set data.r = 0.00
            endif
            call SaveInteger(hs, hid, StringHash("stack_count"), curStack)
            call thistype.UpdateStackFrame(cu, curStack)

            // Пока остались заряды, ставим короткую общую паузу между применениями.
            // На нуле показываем остаток до ближайшего восстановленного заряда.
            if data.frameAbilityId != 0 then
                if curStack > 0 then
                    call thistype.ScheduleCooldownReset(cu, data.frameAbilityId, thistype.STACK_USE_COOLDOWN)
                else
                    call thistype.ScheduleCooldownReset(cu, data.frameAbilityId, data.rmax - data.r)
                endif
            endif
        endmethod

        public static method GetStackCount takes unit cu returns integer
            return LoadInteger(hs, GetHandleId(cu), StringHash("stack_count"))
        endmethod

        public static method GetMaxStackCount takes unit cu returns integer
            local thistype data = thistype.FindByUnit(cu)
            if data == 0 then
                return 0
            endif
            return data.maxStacks
        endmethod

        // Sets the current amount and clamps it to 0..maxStacks.
        public static method SetStackCount takes unit cu, integer newAmount returns nothing
            local thistype data = thistype.FindByUnit(cu)
            local integer hid = GetHandleId(cu)
            local integer oldAmount = LoadInteger(hs, hid, StringHash("stack_count"))

            if data == 0 then
                return
            endif
            if newAmount < 0 then
                set newAmount = 0
            elseif newAmount > data.maxStacks then
                set newAmount = data.maxStacks
            endif

            call SaveInteger(hs, hid, StringHash("stack_count"), newAmount)
            call thistype.UpdateStackFrame(cu, newAmount)

            // Первый выданный заряд снимает ожидание восстановления. Добавление
            // зарядов поверх уже имеющихся не прерывает паузу между применениями.
            if oldAmount <= 0 and newAmount > 0 and data.frameAbilityId != 0 then
                call thistype.ScheduleCooldownReset(cu, data.frameAbilityId, 0.00)
            endif
        endmethod

        public static method AddStacks takes unit cu, integer amount returns nothing
            call thistype.SetStackCount(cu, thistype.GetStackCount(cu) + amount)
        endmethod

        // Меняет время восстановления, не сбрасывая уже накопленный прогресс.
        public static method SetRechargeTime takes unit cu, real newRechargeTime returns nothing
            local thistype data = thistype.FindByUnit(cu)
            if data == 0 then
                return
            endif
            set data.instantRecharge = newRechargeTime <= 0.00
            if newRechargeTime < 0.05 then
                set newRechargeTime = 0.05
            endif
            set data.rmax = newRechargeTime
            if data.r > data.rmax then
                set data.r = data.rmax
            endif
            if data.instantRecharge then
                call thistype.SetStackCount(cu, data.maxStacks)
            endif
        endmethod

        // grantDifference=true immediately grants every newly added max charge.
        // false only increases capacity; new charges then regenerate normally.
        public static method SetMaxStackCount takes unit cu, integer newMaximum, boolean grantDifference returns nothing
            local thistype data = thistype.FindByUnit(cu)
            local integer oldMaximum
            local integer newAmount

            if data == 0 then
                return
            endif
            if newMaximum < 1 then
                set newMaximum = 1
            endif

            set oldMaximum = data.maxStacks
            set newAmount = thistype.GetStackCount(cu)
            set data.maxStacks = newMaximum

            if newAmount > newMaximum then
                set newAmount = newMaximum
            elseif grantDifference and newMaximum > oldMaximum then
                set newAmount = newAmount + newMaximum - oldMaximum
            endif

            call thistype.SetStackCount(cu, newAmount)
        endmethod

        public static method ChangeMaxStackCount takes unit cu, integer amount, boolean grantDifference returns nothing
            local thistype data = thistype.FindByUnit(cu)
            if data == 0 then
                return
            endif
            call thistype.SetMaxStackCount(cu, data.maxStacks + amount, grantDifference)
        endmethod

        public static method ClearStacks takes unit cu returns nothing
            call thistype.SetStackCount(cu, 0)
        endmethod

        public static method RestoreAllStacks takes unit cu returns nothing
            local thistype data = thistype.FindByUnit(cu)
            if data == 0 then
                return
            endif

            set data.r = 0.00
            call thistype.SetStackCount(cu, data.maxStacks)

            // Для Escape полный сброс всегда должен сразу разрешать применение,
            // в том числе если до вызова уже оставался хотя бы один заряд.
            if data.maxStacks > 0 and data.frameAbilityId != 0 then
                call thistype.ScheduleCooldownReset(cu, data.frameAbilityId, 0.00)
            endif
        endmethod

        // Stops regeneration. clearCurrent=true also removes existing charges.
        public static method PauseStacks takes unit cu, boolean clearCurrent returns nothing
    local thistype data = thistype.FindByUnit(cu)
    local integer curStack
    if data == 0 then
        return
    endif
    set data.regenEnabled = false
    set data.frameSuppressed = true
    // Убирает накопленный прогресс текущего восстановления, как и раньше.
    set data.r = 0.00
    if clearCurrent then
        call thistype.SetStackCount(cu, 0)
    else
        set curStack = LoadInteger(hs, GetHandleId(cu), StringHash("stack_count"))
        call data.RefreshStackFrameVisibility(curStack)
    endif
endmethod

        // Starts regeneration again. restoreFull=true immediately fills charges.
       public static method ResumeStacks takes unit cu, boolean restoreFull returns nothing
    local thistype data = thistype.FindByUnit(cu)
    local integer curStack
    if data == 0 then
        return
    endif
    set data.regenEnabled = true
    set data.frameSuppressed = false
    set data.r = 0.00
    if restoreFull then
        call thistype.SetStackCount(cu, data.maxStacks)
    else
        set curStack = LoadInteger(hs, GetHandleId(cu), StringHash("stack_count"))
        call thistype.UpdateStackFrame(cu, curStack)
    endif
endmethod

        public static method Stop takes unit cu returns nothing
            local integer i = 0
            local thistype data
            loop
                exitwhen i > lastInstance
                set data = instances[i]
                if data.c == cu then
                    call thistype.RemoveAt(i)
                    return
                endif
                set i = i + 1
            endloop
        endmethod
    endstruct

    // Backward-compatible Bambietta wrapper. Hero-specific IDs stay outside
    // KS_SpellStacks, so the structure itself remains reusable.
    function MySpellStacks takes unit c, integer stack_amount, real rechargeTime returns nothing
        call KS_SpellStacks.MyAddSpellStacks_Start(c, BambiettaG_ID, FakeAbi_ID, stack_amount, rechargeTime)
    endfunction

    // Generic entry point for every other hero.
    function MySpellStacksForAbility takes unit c, integer frameAbilityId, integer cooldownAbilityId, integer stack_amount, real rechargeTime returns nothing
        call KS_SpellStacks.MyAddSpellStacks_Start(c, frameAbilityId, cooldownAbilityId, stack_amount, rechargeTime)
    endfunction

    function MyRemoveStack takes unit c returns nothing
        call KS_SpellStacks.MyRemoveStack(c)
    endfunction

    // -------------------------------------------------------------------------
    // Simple public API. Use these functions from any hero/spell library.
    // -------------------------------------------------------------------------
    function SpellStacksStart takes unit c, integer abilityId, integer cooldownId, integer maximum, real rechargeTime returns nothing
        call KS_SpellStacks.MyAddSpellStacks_Start(c, abilityId, cooldownId, maximum, rechargeTime)
    endfunction

    function SpellStacksGet takes unit c returns integer
        return KS_SpellStacks.GetStackCount(c)
    endfunction

    function SpellStacksGetMax takes unit c returns integer
        return KS_SpellStacks.GetMaxStackCount(c)
    endfunction

    function SpellStacksSet takes unit c, integer amount returns nothing
        call KS_SpellStacks.SetStackCount(c, amount)
    endfunction

    function SpellStacksAdd takes unit c, integer amount returns nothing
        call KS_SpellStacks.AddStacks(c, amount)
    endfunction

    function SpellStacksSetRechargeTime takes unit c, real rechargeTime returns nothing
        call KS_SpellStacks.SetRechargeTime(c, rechargeTime)
    endfunction

    // Use this after a successful cast. Returns false when no charge is available.
    function SpellStacksTryUse takes unit c returns boolean
        if KS_SpellStacks.GetMaxStackCount(c) <= 0 or KS_SpellStacks.GetStackCount(c) <= 0 then
            return false
        endif
        call KS_SpellStacks.MyRemoveStack(c)
        return true
    endfunction

    function SpellStacksSetMax takes unit c, integer maximum, boolean grantDifference returns nothing
        call KS_SpellStacks.SetMaxStackCount(c, maximum, grantDifference)
    endfunction

    function SpellStacksChangeMax takes unit c, integer amount, boolean grantDifference returns nothing
        call KS_SpellStacks.ChangeMaxStackCount(c, amount, grantDifference)
    endfunction

    function SpellStacksIncreaseMax takes unit c returns nothing
        call KS_SpellStacks.ChangeMaxStackCount(c, 1, true)
    endfunction

    function SpellStacksDecreaseMax takes unit c returns nothing
        call KS_SpellStacks.ChangeMaxStackCount(c, -1, false)
    endfunction

    // Clears current charges, but normal regeneration continues.
    function SpellStacksClear takes unit c returns nothing
        call KS_SpellStacks.ClearStacks(c)
    endfunction

    function SpellStacksFill takes unit c returns nothing
        call KS_SpellStacks.RestoreAllStacks(c)
    endfunction

    // Вызывать из Escape: восстанавливает максимум зарядов, обнуляет прогресс
    // текущего восстановления и снимает оставшийся cooldown способности.
    function SpellStacksResetForEscape takes unit c returns nothing
        call KS_SpellStacks.RestoreAllStacks(c)
    endfunction

    // clearCurrent=true also removes every current charge.
    function SpellStacksPause takes unit c, boolean clearCurrent returns nothing
        call KS_SpellStacks.PauseStacks(c, clearCurrent)
    endfunction

    // restoreFull=true immediately restores every charge.
    function SpellStacksResume takes unit c, boolean restoreFull returns nothing
        call KS_SpellStacks.ResumeStacks(c, restoreFull)
    endfunction

    function SpellStacksStop takes unit c returns nothing
        call KS_SpellStacks.Stop(c)
    endfunction
    function SpellStacksHideAndPause takes unit c returns nothing
    call KS_SpellStacks.PauseStacks(c, false)
endfunction
function SpellStacksShowAndResume takes unit c returns nothing
    call KS_SpellStacks.ResumeStacks(c, false)
endfunction

function GetStackCount takes unit c returns integer
    return LoadInteger(hs, GetHandleId(c), StringHash("stack_count"))
endfunction


    function MyItemStacks takes unit c, integer item_id, integer stack_amount, real r ,boolean add_or_remove returns nothing
        call KS_ItemStacks.MyAddStacks_Start(c, item_id, stack_amount, r,add_or_remove)
    endfunction
    function LustSin takes unit c, unit td, real triggerDmg, real shieldDmg returns real
    local real pierce = 0.0
    local boolean useLastSin = false
    local integer itemSlot = -1
    local integer charges = 0
    local item lastSinItem = null

    if c == null or shieldDmg <= 0.0 then
        return 0.0
    endif

    // Бонус Фрирен
    if GetUnitTypeId(c) == Frieren_ID or GetUnitTypeId(c) == FrierenTR_unitid then
        set pierce = pierce + FrierenTF_PierceShield
    endif

    // Частичное пробивание B01R; отдельные shieldPen-ветки обходятся полностью.
    if GetUnitAbilityLevel(c, 'B01R') > 0 then
        set pierce = pierce + WrathSin_IgnoreAmountAdd
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("toji q3")) > 0 then
        set pierce = pierce + 100.0
    endif
    
    // Полное пробивание от эффекта Toji на цели.
    if td != null and GetUnitAbilityLevel(td, TojiT_ShieldPierceBuff_ID) > 0 then
        set pierce = pierce + 100.0
    endif

    // Постоянное частичное пробивание от предметов.
    
    if shieldDmg > 1 and HasCachedItem(c, 'I02E') > 0 then
        set pierce = pierce + WrathSin_IgnoreAmount
        else
        if shieldDmg > 1 and HasCachedItem(c, 'I02D') > 0 then
        set pierce = pierce + EnvySin_IgnoreAmount
    endif
    endif

    // Каждый полный щит вызывает функцию отдельно и расходует один заряд.
    // Если постоянные эффекты уже дают 100%, заряд Last Sin не тратится.
    if pierce < 100.0 and triggerDmg >= LustSin_MinDmg and GetUnitAbilityLevel(c, 'A07O') > 0 and BlzGetUnitAbilityCooldownRemaining(c, 'A07O') == 0.0 then
        set itemSlot = IsItemInInventory3(c, 'I01W')
        if itemSlot >= 0 then
            set lastSinItem = UnitItemInSlot(c, itemSlot)
            if lastSinItem != null then
                set charges = GetItemCharges(lastSinItem)
                set useLastSin = charges > 0
            endif
        else
            // Вариант способности без предмета использует обычный cooldown.
            set useLastSin = true
        endif

        if useLastSin then
            set pierce = pierce + LustSin_IgnoreAmount
            if lastSinItem != null then
                set charges = charges - 1
                call SetItemCharges(lastSinItem, charges)
                call MyItemStacks(c, 'I01W', 1, LustSin_CD, true)
                if charges == 0 then
                    call BlzStartUnitAbilityCooldown(c, 'A07O', LustSin_CD)
                endif
            else
                call BlzStartUnitAbilityCooldown(c, 'A07O', LustSin_CD)
            endif

            if td != null then
                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_firefly-rq-sfx-5.mdl", td, "chest"))
                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_0706Red.mdl", td, "chest"))
            endif
        endif
    endif

    // Общий лимит игнорирования щита
    if pierce > 100.0 then
        set pierce = 100.0
    endif

    set lastSinItem = null
    // Процент считается от урона, поступившего в конкретный щит. Для ранних
    // щитов обычные резисты применятся ниже по цепочке, для поздних уже учтены.
    return shieldDmg * pierce / 100.0
endfunction

function DamageShieldAllowsType takes integer typedmg, integer allowedType returns boolean
    if allowedType == DAMAGE_SHIELD_TYPE_ALL then
        return true
    endif
    if allowedType == DAMAGE_SHIELD_TYPE_NON_MAGIC then
        return typedmg == DAMAGE_SHIELD_TYPE_ATTACK or typedmg == DAMAGE_SHIELD_TYPE_PHYSICAL
    endif
    return typedmg == allowedType
endfunction

// Единая точка полного щита. Каждый отдельный вызов считается отдельным
// щитом: Last Sin расходует по одному заряду, а постоянные эффекты работают
// на каждом вызове без зарядов. Неподходящий тип урона щит не активирует.
function ApplyFullDamageShield takes unit c, unit td, real dmg, real triggerDmg, integer typedmg, integer allowedType returns real
    if not DamageShieldAllowsType(typedmg, allowedType) then
        return dmg
    endif
    return LustSin(c, td, triggerDmg, dmg)
endfunction

    function MyFlush2 takes unit c, integer childid, integer value, real r,boolean countinpause returns nothing
        call KS_FlushInteger.MyFlushIC_Start(c, childid, value, r,countinpause)
    endfunction
    function MyEffBuff takes unit c,integer buff_id, effect e returns nothing
        call KS_BuffEffect.MyBuffEff_Start(c,buff_id,e)
    endfunction
    function MyFrame takes unit c,real rmax, string icon_path, boolean pauseunitcount,integer numberframe returns nothing
        call KS_BuffTimer.MyBuffTime_Start(c,0,rmax,icon_path,pauseunitcount,-1,1,0,numberframe)
    endfunction
    function MyFrameBuff takes unit c,integer buff_id,real rmax, string icon_path, boolean pauseunitcount returns nothing
        call KS_BuffTimer.MyBuffTime_Start(c,buff_id,rmax,icon_path,pauseunitcount,-1,0,0,0)
    endfunction
    function MyFrameBuffSlot takes unit c,integer buff_id,real rmax, string icon_path, boolean pauseunitcount, integer numberframe returns nothing
        call KS_BuffTimer.MyBuffTime_Start(c,buff_id,rmax,icon_path,pauseunitcount,-1,0,0,numberframe)
    endfunction
    function MyFrameBuff2 takes unit c,integer buff_id,real rmax, string icon_path, boolean pauseunitcount, integer player_id returns nothing
        call KS_BuffTimer.MyBuffTime_Start(c,buff_id,rmax,icon_path,pauseunitcount,player_id,0,0,0)
    endfunction
    function MyRemoveDest takes destructable ds, real r returns nothing
        call KS_RemoveDestructable.MyRemoveDest_Start(ds, r, 0, -1, -1, "")
    endfunction
    function MyAnimDest takes destructable ds, real r returns nothing
        call KS_RemoveDestructable.MyRemoveDest_Start(ds, r, 1, -1, -1, "")
    endfunction
    function FakeCD_Start takes unit NewC,integer NewAbi,real NewCD, integer New_Sh, integer New_Value returns nothing
        call KS_FakeCooldown.FakeCD_Start1(NewC,NewAbi,NewCD,New_Sh,New_Value)
    endfunction
    function CD_Start takes unit NewC, real NewRmax,integer NewAbi,real NewCD returns nothing
        call KS_Cooldown.CD_Start(NewC,NewRmax,NewAbi,NewCD)
    endfunction
    function AllTextTagPartialDelay takes string ls, unit u, integer r, integer g, integer b, integer lv, real size, real delay returns nothing
        call KS_TextTagDelay.TexttagDelay_Start(ls, u, r, g, b, lv, size, delay)
    endfunction
    function FearUnit takes unit c, real angle, real rmax returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
        endif
        call UnitAddAbility(DummyPlayer[i], 'APP2')
        call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], c) * bj_RADTODEG)
        call IssueTargetOrder(DummyPlayer[i], "curse", c)
        call KS_Fear.Fear_Start(c, angle, rmax)
    endfunction
    function ColorLightning takes lightning c, real r, real red, real green, real blue, real rmax, boolean b returns nothing
        call KS_LightningColor.ColorLightning_Start(c, r, red, green, blue, rmax, b)
    endfunction
    function HPS takes unit c,unit td, real heal, real max returns nothing
        call KS_HealOverTime.HPS_Start(c,td, 0, heal, max)
    endfunction
    function MPS takes unit c, real heal, real max returns nothing
        call KS_HealOverTime.HPS_Start(c,c, 1, heal, max)
    endfunction
    function ScaleEffDummy takes effect e, real r, real scale1, real scale2 returns nothing
        call KS_EffectScale.ScaleEffDummy_Start(e, 0, scale1, scale2, r)
    endfunction
    function ScaleEffDummy2 takes effect e, real prepare, real r, real scale1, real scale2 returns nothing
        call KS_EffectScale.ScaleEffDummy_Start(e, prepare, scale1, scale2, r)
    endfunction
    function EMUE takes effect e, real dist, real rmax, real a returns nothing
    if e != null then 
        call KS_MoveEffect.EMUE_Start(e, dist, rmax, a, 0)
    endif
    endfunction    
    function ScaleDummy takes unit c, real r, real scale1, real scale2 returns nothing
        if c != null then
        call KS_UnitScale.ScaleDummy_Start(c, 0, scale1, scale2, r)
        endif
    endfunction
    function ScaleDummy2 takes unit c, real prepare, real r, real scale1, real scale2 returns nothing
        call KS_UnitScale.ScaleDummy_Start(c, prepare, scale1, scale2, r)
    endfunction
    function NextSound takes string s, real r returns nothing
        call KS_DelayedSound.NextSound_Start(s, r)
    endfunction
    function MyRemoveAbility takes unit c, real r, integer id, integer add_or_delete returns nothing
        call KS_RemoveAbility.RemoveAbility_Start(c, r, id, add_or_delete)
    endfunction
    function MyRemoveAbility2 takes unit c,  integer id, integer add_or_delete, integer abilitycheckid returns nothing
        call KS_RemoveAbility2.RemoveAbility_Start(c, id, add_or_delete,abilitycheckid)
    endfunction
    function BlockRegen takes unit c, real rmax, real blockheal returns nothing
        call KS_BlockRegen.BlockHpRegen_Start(c, rmax, blockheal)
    endfunction
    function NextDmg takes unit c, unit td, real dmg, integer typedmg, real rmax returns nothing
        call KS_DelayedDamage.NextDmg_Start(c, td, dmg, typedmg, rmax)
    endfunction
    function MUTU2 takes unit c, real r, real f, unit t returns nothing
        call KS_MoveUnitToUnit.MoveUnitToUnit_Start(c, r, f, t, 0)
    endfunction
    function MUTU3 takes unit c, real r, real f, unit t returns nothing
        call KS_MoveUnitToUnit.MoveUnitToUnit_Start(c, r, f, t, 1)
    endfunction
    function EUTU2 takes effect e, real r, real f, unit t returns nothing
        call KS_MoveEffectToUnit.MoveEffectToUnit_Start(e, r, f, t, 0, 1, null)
    endfunction
    function EUTU2_2 takes effect e, real r, real f, unit t returns nothing
        call KS_MoveEffectToUnit.MoveEffectToUnit_Start(e, r, f, t, 0, 0, null)
    endfunction
    function EUTU2_3 takes effect e, real r, real f, unit t returns nothing
        // Effect remains alive: MoveEffectToUnit_Start owns its lifetime.
        //call DestroyEffect(e)
        call KS_MoveEffectToUnit.MoveEffectToUnit_Start(e, r, f, t, 0, 1, null)
    endfunction
    function EUTU3 takes effect e, real r, real f, unit t, integer ability_id returns nothing
        call KS_MoveEffectToUnit.MoveEffectToUnit_Start(e, r, f, t, ability_id, 1, null)
    endfunction
    function EUTU4 takes effect e, real r, real f, effect e2 returns nothing
        call KS_MoveEffectToUnit.MoveEffectToUnit_Start(e, r, f, null, 0, 1, e2)
    endfunction
    function MyRemoveFog takes fogmodifier fg, real r returns nothing
        call KS_RemoveFog.MyRemoveFogModifier_Start(fg, r)
    endfunction
    function VisionTimed takes player p, real x, real y, real vision, real time returns nothing
        local fogmodifier fm = CreateFogModifierRadius(p, FOG_OF_WAR_VISIBLE, x, y, vision, true, false)
        call FogModifierStart(fm)
        call MyRemoveFog(fm, time)
        set fm = null
    endfunction
    function MyRemoveUnit takes unit c, real r returns nothing
        call KS_RemoveUnit.MyRemoveUnit_Start(c, r, 0, -1, -1, "")
    endfunction
    function AnimDummy takes unit c, real r, real r2 returns nothing
        call KS_RemoveUnit.MyRemoveUnit_Start(c, r, 1, r2, -1, "")
    endfunction
    function SetAnim takes unit c, real r, string s returns nothing
        call KS_RemoveUnit.MyRemoveUnit_Start(c, r, 3, -1, -1, s)
    endfunction
    function SetAnimIndex takes unit c, real r, integer i returns nothing
        call KS_RemoveUnit.MyRemoveUnit_Start(c, r, 2, -1, i, "")
    endfunction
    function MyRemoveEff takes effect c, real r returns nothing
        call KS_RemoveEffect.MyRemoveEff_Start(c, r, 0, -1, -1, "")
    endfunction
    function AnimDummyEff takes effect c, real r, real r2 returns nothing
        call KS_RemoveEffect.MyRemoveEff_Start(c, r, 1, r2, -1, "")
    endfunction
    function SetAnimEffBirth takes effect c, real r returns nothing
        call KS_RemoveEffect.MyRemoveEff_Start(c, r, 2, -1, -1, "")
    endfunction
    function SetAnimEffDeath takes effect c, real r returns nothing
        call KS_RemoveEffect.MyRemoveEff_Start(c, r, 3, -1, 0, "")
    endfunction
    function DmgPTime takes unit c, unit td, real dmg, real rmax, real period, integer typedmg returns nothing
        call KS_DamageOverTime.DmgPTime_Start(c, td, dmg, rmax, period, typedmg)
    endfunction
    function HeightSet takes unit c, real time, real fly returns nothing
        call KS_UnitHeight.HeightSet_Start(c, time, fly, 0)
    endfunction
    function HeightSet2 takes unit c, real time, real fly, real wait returns nothing
    if c != null then 
        call KS_UnitHeight.HeightSet_Start(c, time, fly, wait)
        endif
    endfunction
    function EHeightSet takes effect c, real time, real fly returns nothing
    if c != null then 
    call KS_EffectHeight.EHeightSet_Start(c, time, fly, 0)
    endif
    endfunction
    function EHeightSet2 takes effect c, real time, real fly, real wait returns nothing
    if c != null then 
     call KS_EffectHeight.EHeightSet_Start(c, time, fly, wait)
   endif
   endfunction
   function ImmuneToPushDebuff takes unit c returns nothing
   local integer hid
   if GetUnitTypeId(c) == Patriot_ID then 
   set hid = GetHandleId(c)
   call SaveInteger(hs, hid, KEY_IMM_F,1)
   call MyFlush(hid,KEY_IMM_F,0,0.15)
   endif
   endfunction
    function MUE takes unit c, real move, real rmax, real angle returns nothing
    local integer hid
    local integer level

    // Р В Р В°Р Р…Р Р…Р С‘Р в„– Р Р†РЎвЂ№РЎвЂ¦Р С•Р Т‘ РІР‚вЂќ Р Т‘Р В°Р В»РЎРЉРЎв‚¬Р Вµ Р Р…Р С‘РЎвЂЎР ВµР С–Р С• Р Р…Р Вµ Р Р†РЎвЂ№РЎвЂЎР С‘РЎРѓР В»РЎРЏР ВµР С.
    if c == null or GetWidgetLife(c) <= 5.0 then
        return
    endif

    set hid = GetHandleId(c)

    // Р С›Р В±РЎвЂ°Р С‘Р Вµ РЎРѓР С•РЎРѓРЎвЂљР С•РЎРЏР Р…Р С‘РЎРЏ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘РЎРЏ Р С—Р ВµРЎР‚Р ВµР СР ВµРЎвЂ°Р ВµР Р…Р С‘РЎР‹.
    if LoadInteger(hs, hid, KEY_RT) == 1 /*
    */ or LoadInteger(hs, hid, KEY_DEF_T) == 1 then
        set move = move * 0.50
    endif

    // Р СџР В°РЎРѓРЎРѓР С‘Р Р†Р Р…Р С•Р Вµ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Patriot.
    if GetUnitTypeId(c) == Patriot_ID /*
    */ and LoadInteger(hs, hid, KEY_IMM_F) == 0 then

        set level = GetHeroLevel(c)

        if level >= 35 then
            set move = move * 0.20
        elseif level >= 25 then
            set move = move * 0.40
        elseif level >= 12 then
            set move = move * 0.60
        else
            set move = move * 0.80
        endif
    endif

    call KS_MoveUnit.MUE_Start(c, move, rmax, angle, 0)
endfunction
    function MUE2 takes unit c, real dist, real rmax, real a returns nothing
    if c != null then 
        call KS_MoveUnit.MUE_Start(c, dist, rmax, a, 1)
    endif
    endfunction
    function MUE3 takes unit c, real dist, real rmax, real a returns nothing
       if c != null then 
     call KS_MoveUnit.MUE_Start(c, dist, rmax, a, 2)
    endif
    endfunction
    function ColorDummy4 takes unit c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
       if c != null then 
     call KS_UnitColor.ColorDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, false)
    endif
    endfunction
    function ColorDummy3 takes unit c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
       if c != null then 
     call KS_UnitColor.ColorDummy_Start(c, preare_time, red, green, blue, 255, rmax, true, true)
    endif
    endfunction
    function ColorDummy32 takes unit c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
      if c != null then 
      call KS_UnitColor.ColorDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, true)
    endif
    endfunction
    function ColorDummy2 takes unit c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
      if c != null then 
      call KS_UnitColor.ColorDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, true)
    endif
    endfunction
    function ColorDummy2_2 takes unit c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
      if c != null then 
      call KS_UnitColor.ColorDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, false)
    endif
    endfunction  
    function ColorEffDummy4 takes effect c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        if c != null then 
    call KS_EffectColor.ColorEffDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, false)
   endif
   endfunction
    function ColorEffDummy3 takes effect c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
      if c != null then 
      call KS_EffectColor.ColorEffDummy_Start(c, preare_time, red, green, blue, 255, rmax, true, true)
    endif
    endfunction
    function ColorEffDummy32 takes effect c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        if c != null then 
        call KS_EffectColor.ColorEffDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, true)
    endif
    endfunction
    function ColorEffDummy2 takes effect c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
       if c != null then 
     call KS_EffectColor.ColorEffDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, true)
   endif
   endfunction
    function ColorEffDummy2_2 takes effect c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
       if c != null then 
     call KS_EffectColor.ColorEffDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, false)
    endif
    endfunction
    function MyRemoveLevelAbility takes unit c, real r, integer id returns nothing
    if c != null then 
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("spell and " + I2S(id))) == 0 then
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("spell and " + I2S(id)), 1)
            call KS_AbilityLevel.SetAbilityLevel_Start(c, r, id, GetUnitAbilityLevel(c, id), true)
        endif
        endif
    endfunction

    function GetScale takes unit c returns real
        return BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE)
    endfunction
    function SetScale takes unit c, real scale returns nothing
        if scale != 0 then
            call SetUnitScale(c, scale, scale, scale)
        endif
    endfunction
    function EffectSpawn2 takes string name, real x, real y, real facing, real timescale, real scale, real height, real time returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call MyRemoveEff(e, time)
        return e
    endfunction
    function EffectSpawnScale takes string name, real x, real y, real facing, real timescale, real scale, real height, real time,real scale1,real scale2 returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call ScaleEffDummy(e,time,scale1,scale2)
        return e
    endfunction
    function EffectSpawnTarget takes string name, unit c, string attach, real facing, real timescale, real scale, real height, real time returns effect
        local effect e = AddSpecialEffectTarget(name, c, attach)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call MyRemoveEff(e, time)
        return e
    endfunction
    function EffectSpawn3 takes string name, real x, real y, real facing, real timescale, real scale, real height, real pitch returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call BlzSetSpecialEffectPitch(e, pitch * bj_DEGTORAD)
        return e
    endfunction
    function EffectSpawn4 takes string name, real x, real y, real facing, real timescale, real scale, real height, real roll returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call BlzSetSpecialEffectRoll(e, roll * bj_DEGTORAD)
        return e
    endfunction
    function EffectSpawn3_2 takes string name, real x, real y, real facing, real timescale, real scale, real height, real roll returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call BlzSetSpecialEffectRoll(e, roll * bj_DEGTORAD)
        return e
    endfunction
    function EffectSpawnColor3 takes string name, real x, real y, real facing, real timescale, real scale, real height, real pitch, integer red, integer green, integer blue, integer alpha returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call BlzSetSpecialEffectPitch(e, pitch * bj_DEGTORAD)
        call BlzSetSpecialEffectColor(e, red, green, blue)
        call BlzSetSpecialEffectAlpha(e, alpha)
        return e
    endfunction
    function EffectSpawnColor2 takes string name, real x, real y, real facing, real timescale, real scale, real height, real time, integer red, integer green, integer blue, integer alpha returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call BlzSetSpecialEffectColor(e, red, green, blue)
        call BlzSetSpecialEffectAlpha(e, alpha)
        call MyRemoveEff(e, time)
        return e
    endfunction
    function EffectSpawn takes string name, real x, real y, real facing, real timescale, real scale, real height returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        return e
    endfunction
    function EffectSpawnColor takes string name, real x, real y, real facing, real timescale, real scale, real height, integer red, integer green, integer blue, integer alpha returns effect
        local effect e = AddSpecialEffect(name, x, y)
        call BlzSetSpecialEffectTimeScale(e, timescale)
        call BlzSetSpecialEffectHeight(e,BlzGetLocalSpecialEffectZ(e)+height)
        call BlzSetSpecialEffectScale(e, scale)
        call BlzSetSpecialEffectYaw(e, facing * bj_DEGTORAD)
        call BlzSetSpecialEffectColor(e, red, green, blue)
        call BlzSetSpecialEffectAlpha(e, alpha)
        return e
    endfunction
    function SwapAbility takes unit c, real r, integer id_new , integer id_old returns nothing
        call KS_SpellTimer.SpellTimer_Timer_Start(c, r, id_new, id_old,0)
    endfunction    
    function SwapAbilityBuff takes unit c,  integer id_new , integer id_old, integer buff_id returns nothing
        call KS_SpellTimer.SpellTimer_Timer_Start(c, 0, id_new, id_old,buff_id)
    endfunction
    function UnitSpawn takes player p, integer id, real x, real y, real facing, real timescale, real scale, real height, real timeexpire returns unit
        local unit u = CreateUnit(p, id, x, y, facing)
        call SetUnitTimeScale(u, timescale)
        call SetFly(u, height)
        call SetScale(u, scale)
        call MyRemoveUnit(u, timeexpire)
        return u
    endfunction
    function UnitSpawn0 takes player p, integer id, real x, real y, real facing, real timescale, real scale, real height returns unit
        local unit u = CreateUnit(p, id, x, y, facing)
        call SetUnitTimeScale(u, timescale)
        call SetFly(u, height)
        call SetScale(u, scale)
        return u
    endfunction
    function UnitSpawnColor takes player p, integer id, real x, real y, real facing, real timescale, real scale, real height, real timeexpire, integer red, integer green, integer blue, integer alpha returns unit
        local unit u = CreateUnit(p, id, x, y, facing)
        call SetUnitTimeScale(u, timescale)
        call SetFly(u, height)
        call SetScale(u, scale)
        call MyRemoveUnit(u, timeexpire)
        call SetUnitVertexColor(u, red, green, blue, alpha)
        return u
    endfunction
    function UnitSpawn2 takes player p, integer id, real x, real y, real facing, real timescale, real scale, real height, real timedelay, real timeexpire, integer red, integer green, integer blue, integer alpha returns unit
        local unit u = CreateUnit(p, id, x, y, facing)
        call SetUnitTimeScale(u, timescale)
        call SetFly(u, height)
        call SetScale(u, scale)
        call SetUnitVertexColor(u, red, green, blue, alpha)
        call ColorDummy3(u, timedelay, red, green, blue, timeexpire)
        return u
    endfunction
    function ReduceCooldown takes unit u, integer abilId, real amount returns nothing
        local real cd = BlzGetUnitAbilityCooldownRemaining(u, abilId) 
        local real cd2 = cd - amount
        if cd2 < 0.00 then
            set cd2 = 0.01
        endif
        if cd>0 then 
        call BlzStartUnitAbilityCooldown(u, abilId, cd2)
        endif
    endfunction
    function IntegerCd takes unit c, string s, real cd returns boolean
    local boolean b = false
    if LoadInteger(hs,GetHandleId(c),StringHash(s)) == 0 then
    set b = true
    call SaveInteger(hs,GetHandleId(c),StringHash(s),1)
    call MyFlush(GetHandleId(c),StringHash(s),0,cd)
    endif
    return b
    endfunction

private function GearTimer03Loop takes nothing returns nothing
    call KS_Flush.Loop()
    call KS_FlushBuff.Loop()
    call KS_AddMana.Loop()
    call KS_FlushReal.Loop()
    call KS_RemoveUnit.Loop_MyRemoveUnit()
    call KS_RemoveEffect.Loop_MyRemoveEff()
    call KS_MoveUnit.Loop_MUE()
    call KS_UnitHeight.LoopHeightSet()
    call KS_UnitColor.Loop_ColorDummy()
    call KS_EffectColor.Loop_ColorEffDummy()
    call KS_MoveEffectToUnit.Loop_MoveEffectToUnit()
    call KS_MoveUnitToUnit.Loop_MoveUnitToUnit()
    call KS_DelayedDamage.Loop_NextDmg()
    call KS_UnitScale.Loop_ScaleDummy()
    call KS_MoveEffect.Loop_EMUE()
    call KS_EffectScale.Loop_ScaleEffDummy()
    call KS_LightningColor.Loop_ColorLightning()
    call KS_Fear.Loop_Fear()
    call KS_EffectHeight.ELoopHeightSet()
    call KS_RemoveDestructable.Loop_MyRemoveDest()
    call KS_FlushInteger.Loop_MyFlushIntegerC()
endfunction

private function GearTimer05Loop takes nothing returns nothing
    call KS_DamageOverTime.Loop_DmgPTime()
    call KS_SpellTimer.LoopSpellTimer()
    call KS_RemoveFog.Loop_MyRemoveFogModifier()
    call KS_BlockRegen.Loop_BlockHpRegen()
    call KS_HealOverTime.Loop_HpS()
    call KS_TextTagDelay.Loop_TT_DELAY()
    call KS_Cooldown.Loop_NextCD()
    call KS_FakeCooldown.Loop_NextFakeCD()
    call KS_ItemStacks.Loop_AddStacks()
    call KS_SpellStacks.Loop_AddSpellStacks()
endfunction

private function GearTimer10Loop takes nothing returns nothing
    call KS_RemoveAbility.Loop_RemoveAbility()
    call KS_RemoveAbility2.Loop_RemoveAbility()
    call KS_DelayedSound.Loop_NextSound()
    call KS_AbilityLevel.Loop_SetAbilityLevel()
    call KS_BuffTimer.Loop_MyBuffTime()
    call KS_BuffEffect.Loop_MyBuffEff()
endfunction

private function InitGearSystems2 takes nothing returns nothing
    set GearTimer03Callback = function GearTimer03Loop
    set GearTimer05Callback = function GearTimer05Loop
    set GearTimer10Callback = function GearTimer10Loop
    set GearTimer03Users = 0
    set GearTimer05Users = 0
    set GearTimer10Users = 0
    set GearTimer03 = CreateTimer()
    set GearTimer05 = CreateTimer()
    set GearTimer10 = CreateTimer()
endfunction

endlibrary

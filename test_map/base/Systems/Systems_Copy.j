library GearSystems initializer Init
    globals
        hashtable hs = InitHashtable()
        unit array DummyPlayer
        unit array DummyPlayer2
        unit array DummyPlayer3
        boolean ShowDmgTestText = true
        rect dummyrect 
        real decordmg
        unit decorunit
        effect array DBGEFFCLONE 
        integer array level_id
        integer Fire_ID = 'h008'
        integer FakeAbi_ID = 'A06H'
        integer DummyE_ID = 'h00E'
        integer DummyR_ID = 'h00D'
        real decor_x 
        real decor_y 
        real decor_aoe 
        real str_hpregen = 0.2
        real int_mpregen = 0.2       
        real agi_as = 0.01 
        real agi_ms = 1.00 
        real agi_def = 0.1
        real armor_resist = 0
        integer LetterCheck = 7
        rect REC        
        string array Hero_q1_N
        string array Hero_q1_E
        string array Hero_q2_N
        string array Hero_q2_E
        string array Hero_q3_N
        string array Hero_q3_E
        string array Hero_q4_N
        string array Hero_q4_E
        string array Hero_w1_N
        string array Hero_w1_E
        string array Hero_w2_N
        string array Hero_w2_E
        string array Hero_w3_N
        string array Hero_w3_E
        string array Hero_w4_N
        string array Hero_w4_E
        string array Hero_e1_N
        string array Hero_e1_E
        string array Hero_e2_N
        string array Hero_e2_E
        string array Hero_e3_N
        string array Hero_e3_E
        string array Hero_e4_N
        string array Hero_e4_E
        string array Hero_r1_N
        string array Hero_r1_E
        string array Hero_r2_N
        string array Hero_r2_E
        string array Hero_r3_N
        string array Hero_r3_E
        string array Hero_r4_N
        string array Hero_r4_E
        string array Hero_t1_N
        string array Hero_t1_E
        string array Hero_t2_N
        string array Hero_t2_E        
        string array Hero_t3_N
        string array Hero_t3_E        
        string array Hero_t4_N
        string array Hero_t4_E        
        string array Hero_f1_N
        string array Hero_f1_E        
        string array Hero_f2_N
        string array Hero_f2_E                
        string array Hero_g1_N
        string array Hero_g1_E                
        string array Hero_g2_N
        string array Hero_g2_E
        string array PlayerColor
    endglobals
   function HideBottomUI takes player p, boolean b returns nothing
    if GetLocalPlayer() == p then
    call BlzHideOriginFrames(b)
    endif
endfunction

    function NoDecor_Filter takes nothing returns boolean
        return GetWidgetLife(GetFilterUnit()) > 0.405 and IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) == false and IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and GetUnitAbilityLevel(GetFilterUnit(), 'Avul') == 0
    endfunction
  function IsItemInInventory3 takes unit u, integer it1 returns integer
        local integer i = 0
        local item ti
        local integer count = -1
        local integer count2 = 0
        local integer gold = 0
        loop
            set ti = UnitItemInSlot(u, i)
            exitwhen i > 5 or count != -1
            if GetItemTypeId(ti) == it1  then
                set count = i
            endif
            set i = i + 1
        endloop
        set ti = null
        return count
    endfunction
    function HealTT takes unit c, real r, real start_height returns nothing
    local real random1 = 80
    local real scale = 0.018
    local integer k = 0
    local real x = GetUnitX(c)
    local real y = GetUnitY(c)
    local real random2 = GetRandomReal(0, 359) * bj_DEGTORAD
    local texttag t = CreateTextTag()
    call SetTextTagLifespan(t, 0.9) // через 0.5 сек удалится
    call SetTextTagFadepoint(t, 0.45) // когда начнет плавно исчезать
    call SetTextTagPos(t, x , y, start_height) // позиция (например на юните)
    call SetTextTagText(t,"|c002EFE01+" + I2S(R2I(r)), scale) // сам текст и размер
    call SetTextTagPermanent(t, false) // делаем непостоянным
    call SetTextTagVelocity(t, 0, 0.1)
    call SetTextTagVisibility(t,false)
    loop
    exitwhen k >10 
    if IsUnitVisible(c,Player(k)) then 
    if GetLocalPlayer() == Player(k) then 
    call SetTextTagVisibility(t,true)
    endif
    endif
    set k = k + 1
    endloop
    set t = null
    endfunction
function IsItemInInventory takes unit u, integer it returns integer
        local integer i = 0
        local item ti
        local integer count = 0
        loop
            set ti = UnitItemInSlot(u, i)
            exitwhen i > 5
            if GetItemTypeId(ti) == it then
               set count = count + 1
            endif
            set i = i + 1
        endloop
        set ti = null
        return count
    endfunction 
function GetShopId2 takes integer id returns integer
local integer i = 0
if id == 0 then 
set i = Natsu_ID
elseif id == 1 then 
set i = Raiden_ID
elseif id == 2 then 
set i = Neuvillette_ID
elseif id == 3 then 
set i = Akainu_ID
elseif id == 4 then 
set i = Kyoraku_ID
elseif id == 5 then 
set i = Erza_ID
elseif id == 6 then 
set i = Gojo_ID
elseif id == 7 then 
set i = Tomioka_ID
elseif id == 8 then 
set i = AlterSaber_ID
elseif id == 9 then 
set i = Kenjaku_ID
elseif id == 10 then 
set i = Inori_ID
elseif id == 11 then 
set i = Okarun_ID
elseif id == 12 then 
set i = Tsuna_ID
elseif id == 13 then 
set i = BazzB_ID
elseif id == 14 then 
set i = Takeshi_ID
elseif id == 15 then 
set i = DarkShiki_ID
endif
return i
endfunction
function GetShopId takes integer id returns integer
local integer i = 0
if id == Natsu_ID then 
set i = 0
elseif id == Raiden_ID then 
set i = 1
elseif id == Neuvillette_ID then 
set i = 2
elseif id == Akainu_ID then 
set i = 3
elseif id == Kyoraku_ID then 
set i = 4
elseif id == Erza_ID then 
set i = 5
elseif id == Gojo_ID then 
set i = 6
elseif id == Tomioka_ID then 
set i = 7
elseif id == AlterSaber_ID then 
set i = 8
elseif id == Kenjaku_ID then 
set i = 9
elseif id == Inori_ID then 
set i = 10
elseif id == Okarun_ID then 
set i = 11
elseif id == Tsuna_ID then 
set i = 12
elseif id == BazzB_ID then 
set i = 13
elseif id == Takeshi_ID then 
set i = 14
elseif id == DarkShiki_ID then 
set i = 15
endif
return i
endfunction
function AddGold takes player p, integer gold, boolean b returns nothing
    if b then 
     call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+gold)
     else
     call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)-gold)
     endif
    endfunction 
function GetGold takes player p returns integer
return GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)
endfunction 

function VIPCheckLvl1 takes string s returns boolean 
return s == "ThunderGear" or s == "MYM" or s == "Hansel" or s == "Cosmos" or s == "Chuck" or s == "TheRazul" or s == "ChungaBunga" or s == "ChungaBunga"  or s == "Holyteal" 
endfunction
function VIPCheckLvl2 takes string s returns boolean 
return s == "ThunderGear"  or s == "Unmasked" 
endfunction
function VIPCheckLvl3 takes string s returns boolean 
return s == "ThunderGear" or s == "Zesu" or s == "LuXun" or s == "MaSeTeR" or s == "Uriska" or s == "DSPK" or s == "Bunny" or s == "Morpheus" or s == "head" or s == "Knox0x1" or s == "Tiny"  
endfunction
function MouseOn takes player p returns nothing
local integer i = GetPlayerId(p)
call EnableTrigger(MouseTrig[i])
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
    function MakeSound3 takes string s returns nothing
        local sound snd
        set s = s + ".mp3"
        set snd = CreateSound(s, false, false, false, 0, 0, "DefaultEAXON")
        call SetSoundVolume( snd, 127 )
        call StartSound(snd)
        call KillSoundWhenDone(snd)
        set snd = null
    endfunction
    function MakeSoundLocal takes string s, player p returns nothing
        local sound snd
        set s = s + ".mp3"
        set snd = CreateSound(s, false, false, false, 0, 0, "DefaultEAXON")
        call SetSoundVolume( snd, 0 )
        if GetLocalPlayer() == p then 
        call SetSoundVolume( snd, 127 )
        endif 
        call StartSound(snd)
        call KillSoundWhenDone(snd)
        set snd = null
    endfunction
function DebuffClear takes unit c returns nothing
call UnitRemoveAbility(c,'BEer')
                    call UnitRemoveAbility(c,'B00Y')
                    call UnitRemoveAbility(c,'Bslo')
                    call UnitRemoveAbility(c,'BNsi')
                    call UnitRemoveAbility(c,'BPSE')
                    call UnitRemoveAbility(c,'B002')
                    call UnitRemoveAbility(c,'B003')
                    call UnitRemoveAbility(c,'B00F')
                    call UnitRemoveAbility(c,'B00S')                    
                    call UnitRemoveAbility(c,'B00R')
                    call UnitRemoveAbility(c,'B00K')
                    call UnitRemoveAbility(c,'B00B')
                    call UnitRemoveAbility(c,'B006')
                    call UnitRemoveAbility(c,'B00T')
                    call UnitRemoveAbility(c,'B008')
                    call UnitRemoveAbility(c,'B00E')
                    call UnitRemoveAbility(c,'B00D')
                    call UnitRemoveAbility(c,'B00K')
                    call UnitRemoveAbility(c,'B00A')
                    call UnitRemoveAbility(c,'B00H')
                    call UnitRemoveAbility(c,'B009')
                    call UnitRemoveAbility(c,'B007')
                    call UnitRemoveBuffsEx(c,false,true,true,true,true,true,true)
endfunction
function MouseOff takes player p returns nothing
local integer i = GetPlayerId(p)
call DisableTrigger(MouseTrig[i])
endfunction
function GetMouseX takes player p returns real
local integer i = GetPlayerId(p)
return MouseX[i]
endfunction
function GetMouseY takes player p returns real
local integer i = GetPlayerId(p)
return MouseY[i]
endfunction
function GetLevelPas3Check takes unit c returns integer
local integer k = 0
local integer lvl = GetHeroLevel(c)
if lvl >= 35 then 
set k = 3
elseif lvl >= 25 then 
set k = 2
elseif lvl >= 12 then 
set k = 1
endif
return k
endfunction
function RoundReal takes real r, integer digits returns real
    local real factor    
    // Прямая подстановка множителя быстрее, чем вызов Pow
    if digits == 2 then
        set factor = 100.0
    elseif digits == 3 then
        set factor = 1000.0
    elseif digits == 1 then
        set factor = 10.0
    else
        set factor = Pow(10.0, I2R(digits)) // На случай, если знаков будет больше
    endif
    // Математически корректное округление
    return I2R(R2I(r * factor + 0.5)) / factor
endfunction

function HeroTooltip takes player p returns nothing
    local integer i = GetPlayerId(p)
    local integer id = GetUnitTypeId(Hero[i])
    local integer q1 = 0
    local integer q2 = 0
    local integer q3 = 0
    local integer q4 = 0
    local integer w1 = 0
    local integer w2 = 0
    local integer w3 = 0
    local integer w4 = 0
    local integer e1 = 0
    local integer e2 = 0
    local integer e3 = 0
    local integer e4 = 0
    local integer r1 = 0
    local integer r2 = 0
    local integer r3 = 0
    local integer r4 = 0
    local integer t1 = 0
    local integer t2 = 0
    local integer t3 = 0
    local integer t4 = 0
    local integer f1 = 0
    local integer f2 = 0
    local integer g1 = 0
    local integer g2 = 0
    if id == Inori_ID then
        set q1 = InoriQ_ID
        set q2 = InoriQ2_ID
        set q3 = InoriQ3_ID
        set w1 = InoriW_ID
        set w2 = InoriW2_ID
        set w3 = InoriW3_ID
        set e1 = InoriE_ID
        set e2 = InoriE2_ID
        set r1 = InoriR_ID
        set r2 = InoriER_ID
        set r3 = InoriR2_ID
        set t1 = InoriT_ID
        set t2 = InoriT2_ID
        set t3 = InoriT3_ID
        set f1 = InoriF_ID
        set g1 = InoriG_ID
    endif
    if id == AlterSaber_ID then
        set q1 = AlterSaberQ_ID
        set w1 = AlterSaberW_ID
        set w2 = AlterSaberW2_ID
        set e1 = AlterSaberE_ID
        set e2 = AlterSaberComboE_ID 
        set r1 = AlterSaberR_ID
        set r2 = AlterSaberRR_ID
        set t1 = AlterSaberT_ID
        set f1 = AlterSaberF_ID
    endif
    if id == Kenjaku_ID then
        set q1 = KenjakuQ_ID
        set q2 = KenjakuQ2_ID
        set q3 = KenjakuQ3_ID        
        set w1 = KenjakuW_ID        
        set w2 = KenjakuW2_ID        
        set w3 = KenjakuW3_ID
        set e1 = KenjakuE_ID  
        set e2 = KenjakuE2_ID 
        set e3 = KenjakuE2_ID  
        set r1 = KenjakuR_ID  
        set r2 = KenjakuR2_ID
        set t1 = KenjakuT_ID
        set f1 = KenjakuF_ID
        set f2 = KenjakuF2_ID
        set g1 = KenjakuG_ID
    endif
    if id == Raiden_ID then
        set q1 = RaidenQ_ID
        set w1 = RaidenW_ID
        set e1 = RaidenE_ID  
        set r1 = RaidenR_ID
        set t1 = RaidenT_ID
        set t2 = RaidenTT_ID
    endif
    if id == Gojo_ID then
        set q1 = GojoQ_ID
        set q2 = GojoQ2_ID
        set q3 = GojoRQ_ID
        set w1 = GojoW_ID
        set w2 = GojoW2_ID
        set w3 = GojoRW_ID
        set e1 = GojoE_ID
        set e2 = GojoE2_ID  
        set r1 = GojoR_ID  
        set r2 = GojoRR_ID
        set t1 = GojoT_ID
        set t2 = GojoT2_ID
        set g1 = GojoG_ID
    endif
    if id == Natsu_ID then
        set q1 = NatsuQ_ID
        set w1 = NatsuW_ID
        set e1 = NatsuE_ID  
        set r1 = NatsuR_ID  
        set r2 = NatsuFR_ID
        set t1 = NatsuT_ID
        set t2 = NatsuFT_ID
        set f1 = NatsuF_ID
        set g1 = NatsuG_ID
        set g2 = NatsuG2_ID
    endif
    if id == Kyoraku_ID then
        set q1 = KyorakuQ_ID
        set q2 = KyorakuQ2_ID
        set w1 = KyorakuW_ID
        set w2 = KyorakuW2_ID
        set e1 = KyorakuE_ID
        set e2 = KyorakuE2_ID
        set r1 = KyorakuR_ID
        set t1 = KyorakuT_ID
        set f1 = KyorakuF_ID
    endif
    if id == Tomioka_ID then
        set q1 = TomiokaQ_ID
        set w1 = TomiokaW_ID
        set e1 = TomiokaE_ID
        set r1 = TomiokaR_ID
        set t1 = TomiokaT_ID
        set f1 = TomiokaF_ID
        set g1 = TomiokaG_ID
    endif
    if id == Erza_ID then
        set q1 = ErzaQ_ID
        set w1 = ErzaW_ID
        set e1 = ErzaE_ID
        set r1 = ErzaR_ID
        set t1 = ErzaT_ID
        set f1 = ErzaF_ID
        set g1 = ErzaG_ID
        set g2 = ErzaG2_ID
    endif
    if id == Erza_ID then
        set q1 = ErzaQ_ID
        set w1 = ErzaW_ID
        set e1 = ErzaE_ID
        set r1 = ErzaR_ID
        set t1 = ErzaT_ID
        set f1 = ErzaF_ID
        set g1 = ErzaG_ID
        set g2 = ErzaG2_ID
    endif
    
    if id == Erza_ID then
    if LoadInteger(hs, GetHandleId(Hero[i]), StringHash("q armor active")) == 1 then
        set q1 = Erza1Q_ID
        set w1 = Erza1W_ID
        set e1 = Erza1E_ID
        set r1 = Erza1R_ID
        set t1 = Erza1T_ID
    elseif LoadInteger(hs, GetHandleId(Hero[i]), StringHash("w armor active")) == 1 then
        set q1 = Erza2Q_ID
        set w1 = Erza2W_ID
        set e1 = Erza2E_ID
        set r1 = Erza2R_ID
        set t1 = Erza2T_ID
    elseif LoadInteger(hs, GetHandleId(Hero[i]), StringHash("e armor active")) == 1 then
        set q1 = Erza3Q_ID
        set w1 = Erza3W_ID
        set e1 = Erza3E_ID
        set r1 = Erza3R_ID
        set t1 = Erza3T_ID
    elseif LoadInteger(hs, GetHandleId(Hero[i]), StringHash("r armor active")) == 1 then
        set q1 = Erza4Q_ID
        set w1 = Erza4W_ID
        set e1 = Erza4E_ID
        set r1 = Erza4R_ID
        set t1 = Erza4T_ID
        set g1 = Erza4F_ID
    elseif LoadInteger(hs, GetHandleId(Hero[i]), StringHash("t armor active")) == 1 then
        set q1 = Erza5Q_ID
        set w1 = Erza5W_ID
        set e1 = Erza5E_ID
        set r1 = Erza5R_ID
        set t1 = Erza5T_ID
        set g1 = Erza5F_ID    
    elseif LoadInteger(hs, GetHandleId(Hero[i]), StringHash("g armor active")) == 1 then
    if LoadInteger(hs, GetHandleId(Hero[i]), StringHash("erza g2 type")) == 1 then
        set q1 = Erza6Q_ID
        set w1 = Erza6W_ID
        set e1 = Erza6E_ID
        set r1 = Erza6R_ID
        set t1 = Erza6T_ID
    else
        set q1 = Erza7Q_ID
        set w1 = Erza7W_ID
        set e1 = Erza7E_ID
        set r1 = Erza7R_ID
        set t1 = Erza7T_ID
    endif    
    endif
    endif
    
    if FRAME_StatusHeroStringPlayerShowBoolean[i] == false then
        if q1 != 0 then
            if Hero_q1_N[i] == null then
                set Hero_q1_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q1), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], q1) - 1)
                set Hero_q1_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], q1) - 1)
            endif
           //  call BlzSetAbilityTooltip(q1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q1), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], q1) - 1), GetUnitAbilityLevel(Hero[i], q1) - 1)
            call BlzSetAbilityExtendedTooltip(q1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q1), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], q1) - 1), GetUnitAbilityLevel(Hero[i], q1) - 1)
        endif
        if q2 != 0 then
            if Hero_q2_N[i] == null then
                set Hero_q2_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q2), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], q2) - 1)
                set Hero_q2_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], q2) - 1)
            endif
           //  call BlzSetAbilityTooltip(q2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q2), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], q2) - 1), GetUnitAbilityLevel(Hero[i], q2) - 1)
            call BlzSetAbilityExtendedTooltip(q2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q2), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], q2) - 1), GetUnitAbilityLevel(Hero[i], q2) - 1)
        endif
        if q3 != 0 then
            if Hero_q3_N[i] == null then
                set Hero_q3_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q3), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], q3) - 1)
                set Hero_q3_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q3), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], q3) - 1)
            endif
           //  call BlzSetAbilityTooltip(q3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q3), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], q3) - 1), GetUnitAbilityLevel(Hero[i], q3) - 1)
            call BlzSetAbilityExtendedTooltip(q3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q3), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], q3) - 1), GetUnitAbilityLevel(Hero[i], q3) - 1)
        endif
        if q4 != 0 then
            if Hero_q4_N[i] == null then
                set Hero_q4_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q4), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], q4) - 1)
                set Hero_q4_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q4), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], q4) - 1)
            endif
           //  call BlzSetAbilityTooltip(q4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q4), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], q4) - 1), GetUnitAbilityLevel(Hero[i], q4) - 1)
            call BlzSetAbilityExtendedTooltip(q4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], q4), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], q4) - 1), GetUnitAbilityLevel(Hero[i], q4) - 1)
        endif
        if w1 != 0 then
            if Hero_w1_N[i] == null then
                set Hero_w1_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w1), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], w1) - 1)
                set Hero_w1_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], w1) - 1)
            endif
           //  call BlzSetAbilityTooltip(w1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w1), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], w1) - 1), GetUnitAbilityLevel(Hero[i], w1) - 1)
            call BlzSetAbilityExtendedTooltip(w1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w1), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], w1) - 1), GetUnitAbilityLevel(Hero[i], w1) - 1)
        endif
        if w2 != 0 then
            if Hero_w2_N[i] == null then
                set Hero_w2_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w2), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], w2) - 1)
                set Hero_w2_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], w2) - 1)
            endif
           //  call BlzSetAbilityTooltip(w2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w2), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], w2) - 1), GetUnitAbilityLevel(Hero[i], w2) - 1)
            call BlzSetAbilityExtendedTooltip(w2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w2), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], w2) - 1), GetUnitAbilityLevel(Hero[i], w2) - 1)
        endif
        if w3 != 0 then
            if Hero_w3_N[i] == null then
                set Hero_w3_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w3), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], w3) - 1)
                set Hero_w3_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w3), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], w3) - 1)
            endif
           //  call BlzSetAbilityTooltip(w3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w3), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], w3) - 1), GetUnitAbilityLevel(Hero[i], w3) - 1)
            call BlzSetAbilityExtendedTooltip(w3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w3), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], w3) - 1), GetUnitAbilityLevel(Hero[i], w3) - 1)
        endif
        if w4 != 0 then
            if Hero_w4_N[i] == null then
                set Hero_w4_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w4), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], w4) - 1)
                set Hero_w4_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w4), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], w4) - 1)
            endif
           //  call BlzSetAbilityTooltip(w4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w4), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], w4) - 1), GetUnitAbilityLevel(Hero[i], w4) - 1)
            call BlzSetAbilityExtendedTooltip(w4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], w4), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], w4) - 1), GetUnitAbilityLevel(Hero[i], w4) - 1)
        endif
        if e1 != 0 then
            if Hero_e1_N[i] == null then
                set Hero_e1_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e1), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], e1) - 1)
                set Hero_e1_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], e1) - 1)
            endif
           //  call BlzSetAbilityTooltip(e1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e1), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], e1) - 1), GetUnitAbilityLevel(Hero[i], e1) - 1)
            call BlzSetAbilityExtendedTooltip(e1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e1), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], e1) - 1), GetUnitAbilityLevel(Hero[i], e1) - 1)
        endif
        if e2 != 0 then
            if Hero_e2_N[i] == null then
                set Hero_e2_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e2), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], e2) - 1)
                set Hero_e2_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], e2) - 1)
            endif
           //  call BlzSetAbilityTooltip(e2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e2), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], e2) - 1), GetUnitAbilityLevel(Hero[i], e2) - 1)
            call BlzSetAbilityExtendedTooltip(e2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e2), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], e2) - 1), GetUnitAbilityLevel(Hero[i], e2) - 1)
        endif
        if e3 != 0 then
            if Hero_e3_N[i] == null then
                set Hero_e3_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e3), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], e3) - 1)
                set Hero_e3_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e3), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], e3) - 1)
            endif
           //  call BlzSetAbilityTooltip(e3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e3), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], e3) - 1), GetUnitAbilityLevel(Hero[i], e3) - 1)
            call BlzSetAbilityExtendedTooltip(e3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e3), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], e3) - 1), GetUnitAbilityLevel(Hero[i], e3) - 1)
        endif
        if e4 != 0 then
            if Hero_e4_N[i] == null then
                set Hero_e4_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e4), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], e4) - 1)
                set Hero_e4_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e4), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], e4) - 1)
            endif
           //  call BlzSetAbilityTooltip(e4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e4), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], e4) - 1), GetUnitAbilityLevel(Hero[i], e4) - 1)
            call BlzSetAbilityExtendedTooltip(e4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], e4), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], e4) - 1), GetUnitAbilityLevel(Hero[i], e4) - 1)
        endif
        if r1 != 0 then
            if Hero_r1_N[i] == null then
                set Hero_r1_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r1), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], r1) - 1)
                set Hero_r1_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], r1) - 1)
            endif
           //  call BlzSetAbilityTooltip(r1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r1), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], r1) - 1), GetUnitAbilityLevel(Hero[i], r1) - 1)
            call BlzSetAbilityExtendedTooltip(r1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r1), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], r1) - 1), GetUnitAbilityLevel(Hero[i], r1) - 1)
        endif
        if r2 != 0 then
            if Hero_r2_N[i] == null then
                set Hero_r2_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r2), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], r2) - 1)
                set Hero_r2_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], r2) - 1)
            endif
           //  call BlzSetAbilityTooltip(r2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r2), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], r2) - 1), GetUnitAbilityLevel(Hero[i], r2) - 1)
            call BlzSetAbilityExtendedTooltip(r2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r2), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], r2) - 1), GetUnitAbilityLevel(Hero[i], r2) - 1)
        endif
        if r3 != 0 then
            if Hero_r3_N[i] == null then
                set Hero_r3_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r3), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], r3) - 1)
                set Hero_r3_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r3), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], r3) - 1)
            endif
           //  call BlzSetAbilityTooltip(r3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r3), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], r3) - 1), GetUnitAbilityLevel(Hero[i], r3) - 1)
            call BlzSetAbilityExtendedTooltip(r3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r3), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], r3) - 1), GetUnitAbilityLevel(Hero[i], r3) - 1)
        endif
        if r4 != 0 then
            if Hero_r4_N[i] == null then
                set Hero_r4_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r4), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], r4) - 1)
                set Hero_r4_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r4), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], r4) - 1)
            endif
           //  call BlzSetAbilityTooltip(r4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r4), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], r4) - 1), GetUnitAbilityLevel(Hero[i], r4) - 1)
            call BlzSetAbilityExtendedTooltip(r4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], r4), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], r4) - 1), GetUnitAbilityLevel(Hero[i], r4) - 1)
        endif
        if t1 != 0 then
            if Hero_t1_N[i] == null then
                set Hero_t1_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t1), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], t1) - 1)
                set Hero_t1_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], t1) - 1)
            endif
           //  call BlzSetAbilityTooltip(t1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t1), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], t1) - 1), GetUnitAbilityLevel(Hero[i], t1) - 1)
            call BlzSetAbilityExtendedTooltip(t1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t1), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], t1) - 1), GetUnitAbilityLevel(Hero[i], t1) - 1)
        endif
        if t2 != 0 then
            if Hero_t2_N[i] == null then
                set Hero_t2_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t2), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], t2) - 1)
                set Hero_t2_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], t2) - 1)
            endif
           //  call BlzSetAbilityTooltip(t2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t2), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], t2) - 1), GetUnitAbilityLevel(Hero[i], t2) - 1)
            call BlzSetAbilityExtendedTooltip(t2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t2), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], t2) - 1), GetUnitAbilityLevel(Hero[i], t2) - 1)
        endif
        if t3 != 0 then
            if Hero_t3_N[i] == null then
                set Hero_t3_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t3), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], t3) - 1)
                set Hero_t3_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t3), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], t3) - 1)
            endif
           //  call BlzSetAbilityTooltip(t3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t3), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], t3) - 1), GetUnitAbilityLevel(Hero[i], t3) - 1)
            call BlzSetAbilityExtendedTooltip(t3, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t3), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], t3) - 1), GetUnitAbilityLevel(Hero[i], t3) - 1)
        endif
        if t4 != 0 then
            if Hero_t4_N[i] == null then
                set Hero_t4_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t4), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], t4) - 1)
                set Hero_t4_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t4), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], t4) - 1)
            endif
           //  call BlzSetAbilityTooltip(t4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t4), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], t4) - 1), GetUnitAbilityLevel(Hero[i], t4) - 1)
            call BlzSetAbilityExtendedTooltip(t4, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], t4), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], t4) - 1), GetUnitAbilityLevel(Hero[i], t4) - 1)
        endif
        if f1 != 0 then
            if Hero_f1_N[i] == null then
                set Hero_f1_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f1), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], f1) - 1)
                set Hero_f1_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], f1) - 1)
            endif
           //  call BlzSetAbilityTooltip(f1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f1), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], f1) - 1), GetUnitAbilityLevel(Hero[i], f1) - 1)
            call BlzSetAbilityExtendedTooltip(f1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f1), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], f1) - 1), GetUnitAbilityLevel(Hero[i], f1) - 1)
        endif
        if f2 != 0 then
            if Hero_f2_N[i] == null then
                set Hero_f2_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f2), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], f2) - 1)
                set Hero_f2_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], f2) - 1)
            endif
           //  call BlzSetAbilityTooltip(f2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f2), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], f2) - 1), GetUnitAbilityLevel(Hero[i], f2) - 1)
            call BlzSetAbilityExtendedTooltip(f2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], f2), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], f2) - 1), GetUnitAbilityLevel(Hero[i], f2) - 1)
        endif
        if g1 != 0 then
            if Hero_g1_N[i] == null then
                set Hero_g1_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g1), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], g1) - 1)
                set Hero_g1_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], g1) - 1)
            endif
           //  call BlzSetAbilityTooltip(g1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g1), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], g1) - 1), GetUnitAbilityLevel(Hero[i], g1) - 1)
            call BlzSetAbilityExtendedTooltip(g1, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g1), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], g1) - 1), GetUnitAbilityLevel(Hero[i], g1) - 1)
        endif
        if g2 != 0 then
            if Hero_g2_N[i] == null then
                set Hero_g2_N[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g2), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(Hero[i], g2) - 1)
                set Hero_g2_E[i] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(Hero[i], g2) - 1)
            endif
           //  call BlzSetAbilityTooltip(g2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g2), ABILITY_SLF_TOOLTIP_TURN_OFF, GetUnitAbilityLevel(Hero[i], g2) - 1), GetUnitAbilityLevel(Hero[i], g2) - 1)
            call BlzSetAbilityExtendedTooltip(g2, BlzGetAbilityStringLevelField(BlzGetUnitAbility(Hero[i], g2), ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED, GetUnitAbilityLevel(Hero[i], g2) - 1), GetUnitAbilityLevel(Hero[i], g2) - 1)
        endif
    else
        if q1 != 0 then
           //  call BlzSetAbilityTooltip(q1, Hero_q1_N[i], GetUnitAbilityLevel(Hero[i], q1) - 1)
            call BlzSetAbilityExtendedTooltip(q1, Hero_q1_E[i], GetUnitAbilityLevel(Hero[i], q1) - 1)
        endif
        if q2 != 0 then
           //  call BlzSetAbilityTooltip(q2, Hero_q2_N[i], GetUnitAbilityLevel(Hero[i], q2) - 1)
            call BlzSetAbilityExtendedTooltip(q2, Hero_q2_E[i], GetUnitAbilityLevel(Hero[i], q2) - 1)
        endif
        if q3 != 0 then
           //  call BlzSetAbilityTooltip(q3, Hero_q3_N[i], GetUnitAbilityLevel(Hero[i], q3) - 1)
            call BlzSetAbilityExtendedTooltip(q3, Hero_q3_E[i], GetUnitAbilityLevel(Hero[i], q3) - 1)
        endif
        if q4 != 0 then
           //  call BlzSetAbilityTooltip(q4, Hero_q4_N[i], GetUnitAbilityLevel(Hero[i], q4) - 1)
            call BlzSetAbilityExtendedTooltip(q4, Hero_q4_E[i], GetUnitAbilityLevel(Hero[i], q4) - 1)
        endif
        if w1 != 0 then
           //  call BlzSetAbilityTooltip(w1, Hero_w1_N[i], GetUnitAbilityLevel(Hero[i], w1) - 1)
            call BlzSetAbilityExtendedTooltip(w1, Hero_w1_E[i], GetUnitAbilityLevel(Hero[i], w1) - 1)
        endif
        if w2 != 0 then
           //  call BlzSetAbilityTooltip(w2, Hero_w2_N[i], GetUnitAbilityLevel(Hero[i], w2) - 1)
            call BlzSetAbilityExtendedTooltip(w2, Hero_w2_E[i], GetUnitAbilityLevel(Hero[i], w2) - 1)
        endif
        if w3 != 0 then
           //  call BlzSetAbilityTooltip(w3, Hero_w3_N[i], GetUnitAbilityLevel(Hero[i], w3) - 1)
            call BlzSetAbilityExtendedTooltip(w3, Hero_w3_E[i], GetUnitAbilityLevel(Hero[i], w3) - 1)
        endif
        if w4 != 0 then
           //  call BlzSetAbilityTooltip(w4, Hero_w4_N[i], GetUnitAbilityLevel(Hero[i], w4) - 1)
            call BlzSetAbilityExtendedTooltip(w4, Hero_w4_E[i], GetUnitAbilityLevel(Hero[i], w4) - 1)
        endif
        if e1 != 0 then
           //  call BlzSetAbilityTooltip(e1, Hero_e1_N[i], GetUnitAbilityLevel(Hero[i], e1) - 1)
            call BlzSetAbilityExtendedTooltip(e1, Hero_e1_E[i], GetUnitAbilityLevel(Hero[i], e1) - 1)
        endif
        if e2 != 0 then
           //  call BlzSetAbilityTooltip(e2, Hero_e2_N[i], GetUnitAbilityLevel(Hero[i], e2) - 1)
            call BlzSetAbilityExtendedTooltip(e2, Hero_e2_E[i], GetUnitAbilityLevel(Hero[i], e2) - 1)
        endif
        if e3 != 0 then
           //  call BlzSetAbilityTooltip(e3, Hero_e3_N[i], GetUnitAbilityLevel(Hero[i], e3) - 1)
            call BlzSetAbilityExtendedTooltip(e3, Hero_e3_E[i], GetUnitAbilityLevel(Hero[i], e3) - 1)
        endif
        if e4 != 0 then
           //  call BlzSetAbilityTooltip(e4, Hero_e4_N[i], GetUnitAbilityLevel(Hero[i], e4) - 1)
            call BlzSetAbilityExtendedTooltip(e4, Hero_e4_E[i], GetUnitAbilityLevel(Hero[i], e4) - 1)
        endif
        if r1 != 0 then
           //  call BlzSetAbilityTooltip(r1, Hero_r1_N[i], GetUnitAbilityLevel(Hero[i], r1) - 1)
            call BlzSetAbilityExtendedTooltip(r1, Hero_r1_E[i], GetUnitAbilityLevel(Hero[i], r1) - 1)
        endif
        if r2 != 0 then
           //  call BlzSetAbilityTooltip(r2, Hero_r2_N[i], GetUnitAbilityLevel(Hero[i], r2) - 1)
            call BlzSetAbilityExtendedTooltip(r2, Hero_r2_E[i], GetUnitAbilityLevel(Hero[i], r2) - 1)
        endif
        if r3 != 0 then
           //  call BlzSetAbilityTooltip(r3, Hero_r3_N[i], GetUnitAbilityLevel(Hero[i], r3) - 1)
            call BlzSetAbilityExtendedTooltip(r3, Hero_r3_E[i], GetUnitAbilityLevel(Hero[i], r3) - 1)
        endif
        if r4 != 0 then
           //  call BlzSetAbilityTooltip(r4, Hero_r4_N[i], GetUnitAbilityLevel(Hero[i], r4) - 1)
            call BlzSetAbilityExtendedTooltip(r4, Hero_r4_E[i], GetUnitAbilityLevel(Hero[i], r4) - 1)
        endif
        if t1 != 0 then
           //  call BlzSetAbilityTooltip(t1, Hero_t1_N[i], GetUnitAbilityLevel(Hero[i], t1) - 1)
            call BlzSetAbilityExtendedTooltip(t1, Hero_t1_E[i], GetUnitAbilityLevel(Hero[i], t1) - 1)
        endif
        if t2 != 0 then
           //  call BlzSetAbilityTooltip(t2, Hero_t2_N[i], GetUnitAbilityLevel(Hero[i], t2) - 1)
            call BlzSetAbilityExtendedTooltip(t2, Hero_t2_E[i], GetUnitAbilityLevel(Hero[i], t2) - 1)
        endif
        if t3 != 0 then
           //  call BlzSetAbilityTooltip(t3, Hero_t3_N[i], GetUnitAbilityLevel(Hero[i], t3) - 1)
            call BlzSetAbilityExtendedTooltip(t3, Hero_t3_E[i], GetUnitAbilityLevel(Hero[i], t3) - 1)
        endif
        if t4 != 0 then
           //  call BlzSetAbilityTooltip(t4, Hero_t4_N[i], GetUnitAbilityLevel(Hero[i], t4) - 1)
            call BlzSetAbilityExtendedTooltip(t4, Hero_t4_E[i], GetUnitAbilityLevel(Hero[i], t4) - 1)
        endif
        if f1 != 0 then
           //  call BlzSetAbilityTooltip(f1, Hero_f1_N[i], GetUnitAbilityLevel(Hero[i], f1) - 1)
            call BlzSetAbilityExtendedTooltip(f1, Hero_f1_E[i], GetUnitAbilityLevel(Hero[i], f1) - 1)
        endif
        if f2 != 0 then
           //  call BlzSetAbilityTooltip(f2, Hero_f2_N[i], GetUnitAbilityLevel(Hero[i], f2) - 1)
            call BlzSetAbilityExtendedTooltip(f2, Hero_f2_E[i], GetUnitAbilityLevel(Hero[i], f2) - 1)
        endif
        if g1 != 0 then
           //  call BlzSetAbilityTooltip(g1, Hero_g1_N[i], GetUnitAbilityLevel(Hero[i], g1) - 1)
            call BlzSetAbilityExtendedTooltip(g1, Hero_g1_E[i], GetUnitAbilityLevel(Hero[i], g1) - 1)
        endif
        if g2 != 0 then
           //  call BlzSetAbilityTooltip(g2, Hero_g2_N[i], GetUnitAbilityLevel(Hero[i], g2) - 1)
            call BlzSetAbilityExtendedTooltip(g2, Hero_g2_E[i], GetUnitAbilityLevel(Hero[i], g2) - 1)
        endif
    endif
endfunction

function CreateTT_perm takes real x,real y ,real z ,real size, string s returns nothing
set bj_lastCreatedTextTag = CreateTextTag()
   // call SetTextTagLifespan(bj_lastCreatedTextTag, 0.9) // через 0.5 сек удалится
   // call SetTextTagFadepoint(bj_lastCreatedTextTag, 0.45) // когда начнет плавно исчезать
    call SetTextTagPos(bj_lastCreatedTextTag, x,y, z) // позиция (например на юните)
    call SetTextTagText(bj_lastCreatedTextTag, s, size/1000) // сам текст и размер
    call SetTextTagPermanent(bj_lastCreatedTextTag, true) // делаем непостоянным
    call SetTextTagVisibility(bj_lastCreatedTextTag,true)
endfunction
function GetHpRegen takes unit c returns real
local real result = BlzGetUnitRealField(c,UNIT_RF_HIT_POINTS_REGENERATION_RATE)+GetHeroStr(c,true)*str_hpregen
if GetUnitAbilityLevel(c,'A048')> 0 then //erza w armor hp regen
set result = result + 4
endif
if GetUnitAbilityLevel(c,'B013')>0 then // holy grail item
set result = result + HolyGrail_HpRegen
endif
if GetUnitAbilityLevel(c,'A046')> 0 then //erza w armor hp regen
set result = result + 8
endif
if GetUnitAbilityLevel(c,'A043')> 0 then //erza w armor hp regen
set result = result + 12
endif
if GetUnitAbilityLevel(c,'A044')> 0 then //erza w armor hp regen
set result = result + 16
endif
if GetUnitAbilityLevel(c,'A047')> 0 then //erza w armor hp regen
set result = result + 20
endif
if GetUnitAbilityLevel(c,AlterSaberR_Regen0)> 0 then //erza w armor hp regen
set result = result + 15
endif
if GetUnitAbilityLevel(c,AlterSaberR_Regen1)> 0 then //erza w armor hp regen
set result = result + 20
endif
if GetUnitAbilityLevel(c,AlterSaberR_Regen2)> 0 then //erza w armor hp regen
set result = result + 25
endif
if GetUnitAbilityLevel(c,AlterSaberR_Regen3)> 0 then //erza w armor hp regen
set result = result + 30
endif
if GetUnitAbilityLevel(c,AlterSaberR_Regen4)> 0 then //erza w armor hp regen
set result = result + 35
endif
if GetUnitAbilityLevel(c,InoriE_Regen1_ID)> 0 then //erza w armor hp regen
set result = result + 5
endif
if GetUnitAbilityLevel(c,InoriE_Regen2_ID)> 0 then //erza w armor hp regen
set result = result + 10
endif
if GetUnitAbilityLevel(c,InoriE_Regen3_ID)> 0 then //erza w armor hp regen
set result = result + 15
endif
if GetUnitAbilityLevel(c,InoriE_Regen4_ID)> 0 then //erza w armor hp regen
set result = result + 20
endif
if GetUnitAbilityLevel(c,InoriE_Regen5_ID)> 0 then //erza w armor hp regen
set result = result + 25
endif

return result 
endfunction
function GetMpRegen takes unit c returns real
 return BlzGetUnitRealField(c,UNIT_RF_MANA_REGENERATION)+GetHeroInt(c,true)*int_mpregen
endfunction
function GetAS takes unit c returns real
local real base = BlzGetUnitWeaponRealField(c, UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN, 0)
local real ias  = GetHeroAgi(c, true) * agi_as   // agi_as = 0.01
if ias > 4.0 then
    set ias = 4.0
endif
return base / (1.0 + ias)
endfunction
function GetAttack takes unit c returns real
local real base = BlzGetUnitBaseDamage(c,0)
if GetUnitAbilityLevel(c,'A02J') > 0 then 
set base = base + (25*GetUnitAbilityLevel(c,'A02J')  )
endif
return base 
endfunction
function AddHpRegen takes unit c, real r, boolean b returns nothing
if b == true then 
call BlzSetUnitRealField(c,UNIT_RF_HIT_POINTS_REGENERATION_RATE,BlzGetUnitRealField(c,UNIT_RF_HIT_POINTS_REGENERATION_RATE)+r)
else
call BlzSetUnitRealField(c,UNIT_RF_HIT_POINTS_REGENERATION_RATE,BlzGetUnitRealField(c,UNIT_RF_HIT_POINTS_REGENERATION_RATE)-r)
endif
endfunction
function GetAllStat takes unit c, boolean b returns integer
local integer s1 = GetHeroStr(c,b)
local integer s2 = GetHeroAgi(c,b)
local integer s3 = GetHeroInt(c,b)
local integer result = s1+s2+s3
return result
endfunction
function HasShieldPen takes unit c, unit td returns boolean
return false
endfunction
function AddSpellLevel takes unit c, integer id, integer lvl, boolean b returns nothing
if b == true then 
call SetUnitAbilityLevel(c,id,GetUnitAbilityLevel(c,id)+lvl)
else
call SetUnitAbilityLevel(c,id,GetUnitAbilityLevel(c,id)-lvl)
endif
endfunction
function IsRussianLetter1 takes string c returns boolean
    return c=="А" or c=="Б" or c=="В" or c=="Г" or c=="Д" or c=="Е" or c=="Ё" or c=="Ж" or c=="З" or c=="И" or c=="Й" or c=="К" or c=="Л" or c=="М" or c=="Н" or c=="О" or c=="П" or c=="Р" or c=="С" or c=="Т" or c=="У" or c=="Ф" or c=="Х" or c=="Ц" or c=="Ч" or c=="Ш" or c=="Щ" or c=="Ъ" or c=="Ы" or c=="Ь" or c=="Э" or c=="Ю" or c=="Я"
endfunction
function IsRussianLetter2 takes string c returns boolean
    return c=="а" or c=="б" or c=="в" or c=="г" or c=="д" or c=="е" or c=="ё" or c=="ж" or c=="з" or c=="и" or c=="й" or c=="к" or c=="л" or c=="м" or c=="н" or c=="о" or c=="п" or c=="р" or c=="с" or c=="т" or c=="у" or c=="ф" or c=="х" or c=="ц" or c=="ч" or c=="ш" or c=="щ" or c=="ъ" or c=="ы" or c=="ь" or c=="э" or c=="ю" or c=="я"
endfunction
function IsRussianLetter takes string c returns boolean
    return IsRussianLetter1(c) or  IsRussianLetter2(c)
endfunction
function GetVisualLength takes string s returns integer
    local integer i = 0
    local integer len = StringLength(s)
    local integer visual = len
    local string c
    loop
        exitwhen i >= len
        set c = SubString(s, i, i + 1)
        if IsRussianLetter(c) then
            set visual = visual - 1
        endif
        set i = i + 1
    endloop
    return visual
endfunction
function SplitName takes string s returns string
    local integer i = 0
    local integer len = StringLength(s)
    local integer visual = 0
    local boolean ignore = false
    local string c

    loop
        exitwhen i >= len

        // начало цветового блока
        if not ignore and i + 2 <= len and SubString(s,i,i+2) == "|c" then
            set ignore = true
            set i = i + 10
         
        // конец цветового блока
        elseif ignore and i + 2 <= len and SubString(s,i,i+2) == "|r" then
            set ignore = false
            set i = i + 2

        // если внутри |c ... |r — просто пропускаем
        elseif ignore then
            set i = i + 1

        else
            // обычный подсчёт символов
            if i + 2 <= len then
                set c = SubString(s,i,i+2)

                if IsRussianLetter(c) then
                    set visual = visual + 1
                    set i = i + 2
                else
                    set visual = visual + 1
                    set i = i + 1
                endif
            else
                set visual = visual + 1
                set i = i + 1
            endif

            if visual == LetterCheck then
                return SubString(s,0,i) + "|n" + SubString(s,i,len)
            endif

        endif
    endloop

    return s
endfunction
function SplitName2 takes string s returns string
    local integer i = 0
    local integer len = StringLength(s)
    local integer visual = 0
    local string c
    loop
        exitwhen i >= len
        // пробуем взять 2 байта
        if i + 2 <= len then
            set c = SubString(s, i, i + 2)
            if IsRussianLetter(c) then
                set visual = visual + 1
                set i = i + 2
            else
                set visual = visual + 1
                set i = i + 1
            endif
        else
            set visual = visual + 1
            set i = i + 1
        endif
        if visual == 15 then
            return SubString(s, 0, i) + "|n" + SubString(s, i, len)
        endif
    endloop
    return s
endfunction
function SplitNameCheck takes string s returns boolean
    return GetVisualLength(s) > LetterCheck
endfunction
function AddMpRegen takes unit c, real r, boolean b returns nothing
if b == true then 
call BlzSetUnitRealField(c,UNIT_RF_MANA_REGENERATION,BlzGetUnitRealField(c,UNIT_RF_MANA_REGENERATION)+r)
else
call BlzSetUnitRealField(c,UNIT_RF_MANA_REGENERATION,BlzGetUnitRealField(c,UNIT_RF_MANA_REGENERATION)-r)
endif
endfunction
function GetMainStatValue takes unit c, boolean b returns integer
            local integer value = 0
            if BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 1 then
            set value = GetHeroStr(c,b)
            elseif BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 3 then
            set value = GetHeroAgi(c,b)
            elseif BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
            set value = GetHeroInt(c,b)
            endif
            return value 
endfunction

    function OkarunEggCd takes unit c, integer id, real cd returns nothing 
    if  IsItemInInventory(c,'I011')>0 and  BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
             call BlzStartUnitAbilityCooldown(c, id, cd*(1-OkarunEggReduceCD/100))
            else
             call BlzStartUnitAbilityCooldown(c, id, cd)
            endif
    endfunction
function LearnHeroSpells takes unit c returns nothing
local integer id = GetUnitTypeId(c)
local integer i = 0
local integer q = 0
local integer w = 0
local integer e = 0
local integer r = 0
local integer t = 0
local integer check = 0
if id == Raiden_ID then
set q = RaidenQ_ID
set w = RaidenW_ID
set e = RaidenE_ID
set r = RaidenR_ID
set t = RaidenT_ID
elseif id == Natsu_ID then
set q = NatsuQ_ID
set w = NatsuW_ID
set e = NatsuE_ID
set r = NatsuR_ID
set t = NatsuT_ID
elseif id == Tsuna_ID then
set q = TsunaQ_ID
set w = TsunaW_ID
set e = TsunaE_ID
set r = TsunaR_ID
set t = TsunaT_ID
elseif id == Takeshi_ID then
set q = TakeshiQ_ID
set w = TakeshiW_ID
set e = TakeshiE_ID
set r = TakeshiR_ID
set t = TakeshiT_ID
if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("style")) == 1 then
call SetPlayerAbilityAvailable(GetOwningPlayer(c),q,true)
call SetPlayerAbilityAvailable(GetOwningPlayer(c),w,true)
call SetPlayerAbilityAvailable(GetOwningPlayer(c),e,true)
call SetPlayerAbilityAvailable(GetOwningPlayer(c),r,true)
endif
elseif id == Neuvillette_ID then
set q = NeuvilletteQ_ID
set w = NeuvilletteW_ID
set e = NeuvilletteE_ID
set r = NeuvilletteR_ID
set t = NeuvilletteT_ID
elseif id == DarkShiki_ID then
set q = DarkShikiQ_ID
set w = DarkShikiW_ID
set e = DarkShikiE_ID
set r = DarkShikiR_ID
set t = DarkShikiT_ID
elseif id == Gojo_ID then
set q = GojoQ_ID
set w = GojoW_ID
set e = GojoE_ID
set r = GojoR_ID
set t = GojoT2_ID
elseif id == Tomioka_ID then
set q = TomiokaQ_ID
set w = TomiokaW_ID
set e = TomiokaE_ID
set r = TomiokaR_ID
set t = TomiokaT_ID
elseif id == AlterSaber_ID then
set q = AlterSaberQ_ID
set w = AlterSaberW_ID
set e = AlterSaberE_ID
set r = AlterSaberR_ID
set t = AlterSaberT_ID
elseif id == BazzB_ID then
set q = BazzBQ_ID
set w = BazzBW_ID
set e = BazzBE_ID
set r = BazzBR_ID
set t = BazzBT_ID
elseif id == Erza_ID then
set q = ErzaQ_ID
set w = ErzaW_ID
set e = ErzaE_ID
set r = ErzaR_ID
set t = ErzaT_ID
elseif id == Okarun_ID then
set q = OkarunQ_ID
set w = OkarunW_ID
set e = OkarunE_ID
set r = OkarunR_ID
set t = OkarunT_ID
elseif id == Akainu_ID then
set q = AkainuQ_ID
set w = AkainuW_ID
set e = AkainuE_ID
set r = AkainuR_ID
set t = AkainuT_ID
elseif id == Kyoraku_ID then
   call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuQ_ID, true)
   call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuW_ID, true)
   call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuE_ID, true)
   call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuQ2_ID, false)
   call SetPlayerAbilityAvailable(GetOwningPlayer(c), KyorakuW2_ID, false)
   call SetPlayerAbilityAvailable(GetOwningPlayer( c), KyorakuE2_ID, false)
set q = KyorakuQ_ID
set w = KyorakuW_ID
set e = KyorakuE_ID
set r = KyorakuR_ID
set t = KyorakuT_ID
elseif id == Inori_ID then
set q = InoriQ_ID
set w = InoriW_ID
set e = InoriE_ID
set r = InoriR_ID
set t = InoriT_ID
elseif id == Kenjaku_ID then
set q = KenjakuQ_ID
set w = KenjakuW_ID
set e = KenjakuE_ID
set r = KenjakuR_ID
set t = KenjakuT_ID
if LoadInteger(hs, GetHandleId(c), StringHash("kit type")) == 1 then 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),q,true) 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),w,true) 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),e,true) 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),r,true) 
endif
endif
loop
exitwhen i == 5  
if t != 0 and GetUnitAbilityLevel(c,t)<5 then
call SelectHeroSkill(c, t)
endif
if r != 0 and GetUnitAbilityLevel(c,r)<5 then
call SelectHeroSkill(c, r)
endif
if e != 0 and GetUnitAbilityLevel(c,e)<5 then
call SelectHeroSkill(c, e)
endif
if w != 0 and GetUnitAbilityLevel(c,w)<5 then
call SelectHeroSkill(c, w)
endif  
if q != 0 and GetUnitAbilityLevel(c,q)<5 then
call SelectHeroSkill(c, q)
endif  
set i = i + 1
endloop
if id == Kenjaku_ID then
set q = KenjakuQ_ID
set w = KenjakuW_ID
set e = KenjakuE_ID
set r = KenjakuR_ID
set t = KenjakuT_ID
if LoadInteger(hs, GetHandleId(c), StringHash("kit type")) == 1 then 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),q,false) 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),w,false) 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),e,false) 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),r,false)
if GetUnitAbilityLevel(c,e)>0 then 
call UnitAddAbility(c,KenjakuE2_ID)
endif
if GetUnitAbilityLevel(c,r)>0 then 
call UnitAddAbility(c,KenjakuR2_ID)
endif
call SetUnitAbilityLevel(c,KenjakuQ2_ID,GetUnitAbilityLevel(c,q))
call SetUnitAbilityLevel(c,KenjakuQ3_ID,GetUnitAbilityLevel(c,q))
call SetUnitAbilityLevel(c,KenjakuW2_ID,GetUnitAbilityLevel(c,w))
call SetUnitAbilityLevel(c,KenjakuW3_ID,GetUnitAbilityLevel(c,w))
call SetUnitAbilityLevel(c,KenjakuE2_ID,GetUnitAbilityLevel(c,e))
call SetUnitAbilityLevel(c,KenjakuE3_ID,GetUnitAbilityLevel(c,e))
call SetUnitAbilityLevel(c,KenjakuR2_ID,GetUnitAbilityLevel(c,r))
endif
endif
if id == Takeshi_ID then 
if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("style")) == 1 then
call SetPlayerAbilityAvailable(GetOwningPlayer(c),q,false)
call SetPlayerAbilityAvailable(GetOwningPlayer(c),w,false)
call SetPlayerAbilityAvailable(GetOwningPlayer(c),e,false)
call SetPlayerAbilityAvailable(GetOwningPlayer(c),r,false)
if GetUnitAbilityLevel(c,e)>0 then 
call UnitAddAbility(c,TakeshiE2_ID)
endif
if GetUnitAbilityLevel(c,r)>0 then 
call UnitAddAbility(c,TakeshiR2_ID)
endif
call SetUnitAbilityLevel(c,TakeshiQ2_ID,GetUnitAbilityLevel(c,q))
call SetUnitAbilityLevel(c,TakeshiQ3_ID,GetUnitAbilityLevel(c,q))
call SetUnitAbilityLevel(c,TakeshiW2_ID,GetUnitAbilityLevel(c,w))
call SetUnitAbilityLevel(c,TakeshiE2_ID,GetUnitAbilityLevel(c,e))
call SetUnitAbilityLevel(c,TakeshiR2_ID,GetUnitAbilityLevel(c,r))
endif
endif
if id == Inori_ID then 
    call SetUnitAbilityLevel(c,InoriEAlt2_ID,GetUnitAbilityLevel(c,InoriE_ID))
endif
if IsItemInInventory(c, 'I00Q') > 0 and GetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I00Q'))) > 0 then
        call SetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I00Q')), 0)
endif
 if IsItemInInventory(c, 'I01K') > 0 and GetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I01K'))) > 0 then
        call SetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I01K')), 0)
endif
endfunction
function RecommenedItems takes player p returns nothing
local integer i =GetPlayerId(p)
local integer i2 =GetPlayerId(p)*35
local integer id = GetUnitTypeId(Hero[i])
if id == Natsu_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00G' // funny barrel
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I006' // tome of agility
    set ItemsPage0_ID[i2+7] = 'I010' // pochita
    set ItemsPage0_ID[i2+8] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+9] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+10] = 'I00B' // Oken
    set ItemsPage0_ID[i2+11] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+12] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+13] = 'I00Y' // angel blessing
    set ItemsPage0_ID[i2+14] = 'I01Q' // ryujin jakka
    
    set ItemsPage0_ID[i2+28] = 'I00J' // kansho and bakuya    
    set ItemsPage0_ID[i2+29] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I00B' // Oken
    set ItemsPage0_ID[i2+32] = 'I01Q' // ryujin jakka
    set ItemsPage0_ID[i2+33] = 'I013' // black clover
endif 
if id == DarkShiki_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00G' // funny barrel
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I006' // tome of agility
    set ItemsPage0_ID[i2+7] = 'I010' // pochita
    set ItemsPage0_ID[i2+8] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+9] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+10] = 'I00B' // Oken
    set ItemsPage0_ID[i2+11] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+12] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+13] = 'I00Y' // angel blessing
    set ItemsPage0_ID[i2+14] = 'I01Q' // ryujin jakka
    
    set ItemsPage0_ID[i2+28] = 'I00J' // kansho and bakuya    
    set ItemsPage0_ID[i2+29] = 'I00T' // raikage set
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I00B' // Oken
    set ItemsPage0_ID[i2+32] = 'I01Q' // ryujin jakka
    set ItemsPage0_ID[i2+33] = 'I012' // fairy tail emblem
endif 
if id == Neuvillette_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00G' // funny barrel
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I00H' // black heart
    set ItemsPage0_ID[i2+7] = 'I01P' // Gonryomaru
    set ItemsPage0_ID[i2+8] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+9] = 'I00B' // Oken
    set ItemsPage0_ID[i2+10] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+11] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+12] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I01P' // Gonryomaru
    set ItemsPage0_ID[i2+29] = 'I00B' // Oken
    set ItemsPage0_ID[i2+30] = 'I01Q' // ryujin jakka
    set ItemsPage0_ID[i2+31] = 'I00R' // kazekage hat
    set ItemsPage0_ID[i2+32] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+33] = 'I00L' // witch sin
endif 
if id == Kyoraku_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00G' // funny barrel
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I006' // tome of agility
    set ItemsPage0_ID[i2+7] = 'I010' // pochita
    set ItemsPage0_ID[i2+8] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+9] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+10] = 'I00B' // Oken
    set ItemsPage0_ID[i2+11] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+12] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+13] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+29] = 'I00B' // Oken
    set ItemsPage0_ID[i2+30] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+31] = 'I012' // fairy tail emblem
    set ItemsPage0_ID[i2+32] = 'I019' // earth power
    set ItemsPage0_ID[i2+33] = 'I00L' // witch sin
endif 
if id == Kenjaku_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00E' // incursio
    set ItemsPage0_ID[i2+3] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+4] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+5] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+6] = 'I00H' // black heart
    set ItemsPage0_ID[i2+7] = 'I00B' // Oken
    set ItemsPage0_ID[i2+8] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+9] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+10] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+29] = 'I00B' // Oken
    set ItemsPage0_ID[i2+30] = 'I013' // black clover
    set ItemsPage0_ID[i2+31] = 'I00R' // kazekage hat
    set ItemsPage0_ID[i2+32] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+33] = 'I00L' // witch sin
endif 
if id == Okarun_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00E' // incursio
    set ItemsPage0_ID[i2+3] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+4] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+5] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+6] = 'I00H' // black heart
    set ItemsPage0_ID[i2+7] = 'I00B' // Oken
    set ItemsPage0_ID[i2+8] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+9] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+10] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I013' // black clover
    set ItemsPage0_ID[i2+29] = 'I00B' // Oken
    set ItemsPage0_ID[i2+30] = 'I01M' // nichirin
    set ItemsPage0_ID[i2+31] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+32] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+33] = 'I00L' // witch sin
endif 
if id == Inori_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I014' // rock lee weights
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I017' // chogurt
    set ItemsPage0_ID[i2+7] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+8] = 'I00B' // Oken
    set ItemsPage0_ID[i2+9] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+10] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I00B' // Oken
    set ItemsPage0_ID[i2+29] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I013' // black clover
    set ItemsPage0_ID[i2+32] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+33] = 'I00R' // kazekage hat
endif 
if id == AlterSaber_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00P' // tsuchikage hat
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+7] = 'I00U' // hokage hat
    set ItemsPage0_ID[i2+8] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+9] = 'I019' // earth power
    set ItemsPage0_ID[i2+10] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+11] = 'I00B' // Oken
    set ItemsPage0_ID[i2+12] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+13] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+29] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I00B' // Oken
    set ItemsPage0_ID[i2+32] = 'I019' // earth hand
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif 
if id == Takeshi_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00P' // tsuchikage hat
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+7] = 'I00U' // hokage hat
    set ItemsPage0_ID[i2+8] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+9] = 'I019' // earth power
    set ItemsPage0_ID[i2+10] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+11] = 'I00B' // Oken
    set ItemsPage0_ID[i2+12] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+13] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+29] = 'I012' // fairy emblem
    set ItemsPage0_ID[i2+30] = 'I00T' // raikage hat
    set ItemsPage0_ID[i2+31] = 'I00B' // Oken
    set ItemsPage0_ID[i2+32] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+33] = 'I01P' // gonryuomaru
endif 
if id == Tsuna_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00E' // incursio
    set ItemsPage0_ID[i2+3] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+4] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+5] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+6] = 'I01L' // true zangetsu
    set ItemsPage0_ID[i2+7] = 'I01Q' // ryujin
    set ItemsPage0_ID[i2+8] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+9] = 'I00B' // Oken
    set ItemsPage0_ID[i2+10] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+11] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I01L' // true zangetsu
    set ItemsPage0_ID[i2+29] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I00B' // Oken
    set ItemsPage0_ID[i2+32] = 'I012' // fairy tail emblem
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif 
if id == Raiden_ID then
    set ItemsPage0_ID[i2+0] = 'I00G' // funny barrel
    set ItemsPage0_ID[i2+1] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+2] = 'I00E' // incursio
    set ItemsPage0_ID[i2+3] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+4] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+5] = 'I006' // tome of agility
    set ItemsPage0_ID[i2+6] = 'I010' // pochita
    set ItemsPage0_ID[i2+7] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+8] = 'I00B' // Oken
    set ItemsPage0_ID[i2+9] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+10] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+11] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I00B' // Oken
    set ItemsPage0_ID[i2+29] = 'I01L' // true zangetsu
    set ItemsPage0_ID[i2+30] = 'I01B' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I013' // black clover
    set ItemsPage0_ID[i2+32] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif 
if id == BazzB_ID then
    set ItemsPage0_ID[i2+0] = 'I00G' // funny barrel
    set ItemsPage0_ID[i2+1] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+2] = 'I00E' // incursio
    set ItemsPage0_ID[i2+3] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+4] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+5] = 'I006' // tome of agility
    set ItemsPage0_ID[i2+6] = 'I010' // pochita
    set ItemsPage0_ID[i2+7] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+8] = 'I00B' // Oken
    set ItemsPage0_ID[i2+9] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+10] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+11] = 'I00Y' // angel blessing
    
    set ItemsPage0_ID[i2+28] = 'I00B' // Oken
    set ItemsPage0_ID[i2+29] = 'I01L' // true zangetsu
    set ItemsPage0_ID[i2+30] = 'I01B' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I013' // black clover
    set ItemsPage0_ID[i2+32] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif 

if id == Gojo_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I009' // cap of agility
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+7] = 'I00H' // black heart
    set ItemsPage0_ID[i2+8] = 'I00B' // Oken
    set ItemsPage0_ID[i2+9] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+10] = 'I00W' // kurikara
    
    set ItemsPage0_ID[i2+28] = 'I00B' // Oken
    set ItemsPage0_ID[i2+29] = 'I00R' // kazekage hat
    set ItemsPage0_ID[i2+30] = 'I01B' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+32] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif 
if id == Erza_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I00G' // funny barrel
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+7] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+8] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+9] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+10] = 'I00T' // raikage hat
    set ItemsPage0_ID[i2+11] = 'I00B' // Oken
    set ItemsPage0_ID[i2+12] = 'I010' // Pochita
    set ItemsPage0_ID[i2+13] = 'I00M' // cup of tea
    
    set ItemsPage0_ID[i2+28] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+29] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I00B' // Oken
    set ItemsPage0_ID[i2+32] = 'I019' // earth hand
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif
if id == Tomioka_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I009' // cap of agility
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+7] = 'I006' // tome of agility
    set ItemsPage0_ID[i2+8] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+9] = 'I010' // Pochita
    set ItemsPage0_ID[i2+10] = 'I00B' // Oken
    set ItemsPage0_ID[i2+11] = 'I00T' // raikage hat
    set ItemsPage0_ID[i2+12] = 'I00M' // cup of tea
    
    set ItemsPage0_ID[i2+28] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+29] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I00B' // Oken
    set ItemsPage0_ID[i2+32] = 'I019' // earth hand
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif
if id == Akainu_ID then
    set ItemsPage0_ID[i2+0] = 'I007' // sonic boots
    set ItemsPage0_ID[i2+1] = 'I00S' // funny present
    set ItemsPage0_ID[i2+2] = 'I009' // cap of agility
    set ItemsPage0_ID[i2+3] = 'I00E' // incursio
    set ItemsPage0_ID[i2+4] = 'I00N' // urahara cane
    set ItemsPage0_ID[i2+5] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+6] = 'I012' // fairy tail ebmlem
    set ItemsPage0_ID[i2+7] = 'I006' // tome of agility
    set ItemsPage0_ID[i2+8] = 'I00J' // kansho and bakuya
    set ItemsPage0_ID[i2+9] = 'I010' // Pochita
    set ItemsPage0_ID[i2+10] = 'I00B' // Oken
    set ItemsPage0_ID[i2+11] = 'I00T' // raikage hat
    set ItemsPage0_ID[i2+12] = 'I00M' // cup of tea
    
    set ItemsPage0_ID[i2+28] = 'I00B' // Oken
    set ItemsPage0_ID[i2+29] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+30] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+31] = 'I00Y' // angel blessing
    set ItemsPage0_ID[i2+32] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+33] = 'I01Q' // ryujin jakka
endif
set ItemsFrameCurrentPage_ID[i] = 0
set ItemsCraftPlayerDebug_ID[i] = -1

endfunction
function GetPlayerColorString takes player p returns string
    local integer id = GetPlayerId(p)
    if id == 0 then
        return "|c00FF0303" // Красный
    elseif id == 1 then
        return "|c000042FF" // Синий
    elseif id == 2 then
        return "|c001CE6B9" // Бирюзовый
    elseif id == 3 then
        return "|c0054007F" // Фиолетовый
    elseif id == 4 then
        return "|c00FFFC01" // Желтый
    elseif id == 5 then
        return "|c00FF8401" // Оранжевый
    elseif id == 6 then
        return "|c0020C000" // Зеленый
    elseif id == 7 then
        return "|c00E55BB0" // Розовый
    elseif id == 8 then
        return "|c00959697" // Серый
    elseif id == 9 then
        return "|c007EBFF1" // Светло-синий
    elseif id == 10 then
        return "|c00106246" // Темно-зеленый
    elseif id == 11 then
        return "|c004E2A04" // Коричневый
    endif
    return "|c00FFFFFF" // дефолт белый
endfunction
    
    function FrameEnable takes framehandle f,boolean b returns nothing
    call BlzFrameSetEnable(f,b)
    call BlzFrameSetVisible(f,b)
    endfunction
     
    function CheckAllow1 takes unit c returns boolean
        local integer i = GetUnitTypeId(c)
        return true//return i == Zaraki_ID or i == Barragan_ID or i == Kyoraku_ID or i == Kirito_ID or i == Harribel_ID or i == Starrk_ID or i == Brandish_ID or i == Askin_ID or i == DarkShiki_ID or i == Erza_ID or i == Ulquiorra_ID or i == AsNodt_ID or i == Alucard_ID or i == BazzB_ID or i == Tomioka_ID or i == Grimmjow_ID
    endfunction
    function CheckAllow2 takes unit c returns boolean
        local integer i = GetUnitTypeId(c)
        return i == Raiden_ID or i == Natsu_ID or i == Tomioka_ID  or i == Kenjaku_ID 
    endfunction
    function MissHp takes unit c, real r returns real
        return (((1 - (GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE))) * r) * GetUnitState(c, UNIT_STATE_MAX_LIFE))
    endfunction
    function SetHpCurrent takes unit c, real r returns nothing
        call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) + r)
    endfunction
    function SetHpCurrent2 takes unit c,unit td, real r returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(c))
    if GetUnitState(td, UNIT_STATE_LIFE) + r < GetUnitState(td, UNIT_STATE_MAX_LIFE) then 
    set PlayerHeal[i] = PlayerHeal[i]+ R2I(r)
    else
    set PlayerHeal[i] = PlayerHeal[i]+ R2I(GetUnitState(td, UNIT_STATE_MAX_LIFE)-GetUnitState(td, UNIT_STATE_LIFE))
    endif
    call SetUnitState(td, UNIT_STATE_LIFE, GetUnitState(td, UNIT_STATE_LIFE) + r)
    endfunction
    function SetMpCurrent takes unit c, real r returns nothing
        call SetUnitState(c, UNIT_STATE_MANA, GetUnitState(c, UNIT_STATE_MANA) + r)
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
    endfunction
    function StopSpellUnit2 takes unit c returns nothing
        call IssueImmediateOrder(c, "stop")
        call SetUnitTimeScale(c, 1)
        call PauseUnit(c, false)
    endfunction
    function DebugUnit takes unit c returns nothing
        if GetUnitAbilityLevel(c, 'Avul') == 0 then
            call UnitAddAbility(c, 'Avul')
        endif
        if IsUnitPaused(c) == false then
            call PauseUnit(c, true)
        endif
    endfunction
    
    function DebugUnit2 takes unit c returns nothing
        if IsUnitPaused(c) == false then
            call PauseUnit(c, true)
        endif
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
    function EffVision2 takes effect e, unit c returns nothing
        local integer k = 0
        loop
            exitwhen k == bj_MAX_PLAYER_SLOTS
            if IsUnitVisible(c, Player(k)) and IsPlayerAlly(Player(k),GetOwningPlayer(c)) then
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
       
    function Init takes nothing returns nothing
        local integer i = 0
        loop
            exitwhen i == 13
            set DummyPlayer[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1OA')
            call UnitAddAbility(DummyPlayer[i], 'A1OT')
            call UnitAddAbility(DummyPlayer[i], 'A1OB')
            call UnitAddAbility(DummyPlayer[i], 'A1P1')
            call UnitAddAbility(DummyPlayer[i], 'A01V')
            call UnitAddAbility(DummyPlayer[i], 'A1QY')
            set DummyPlayer2[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            //set DummyPlayer2[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'e003', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            set i = i + 1
        endloop
    endfunction
    function IsUnitDebuffed1 takes unit c returns boolean
        return GetUnitAbilityLevel(c, 'BUsp') > 0 or GetUnitAbilityLevel(c, 'BUsl') > 0 or GetUnitAbilityLevel(c, 'Bust') > 0 or GetUnitAbilityLevel(c, 'BPSE') > 0
    endfunction
    function CheckCoordsInRect takes rect rec, real x, real y returns boolean
        local real c1 = GetRectMinX(rec)
        local real c2 = GetRectMaxX(rec)
        local real c3 = GetRectMinY(rec)
        local real c4 = GetRectMaxY(rec)
        return (c1 <= x) and (x <= c2) and (c3 <= y) and (y <= c4)
    endfunction
    function SpellBoolCaster takes unit c returns boolean
        return GetWidgetLife(c) > 0.405 and GetUnitAbilityLevel(c, KenjakuF2_Prison_Abi_ID) == 0
    endfunction
    function SpellBool takes unit c returns boolean // enemy unit check before damage
        return GetWidgetLife(c) > 0.405 and GetUnitAbilityLevel(c, 'Avul') == 0 and GetUnitAbilityLevel(c, KenjakuF2_Prison_Abi_ID) == 0
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
    private struct KS_Base
        private static timer t_2 = CreateTimer()
        private static integer array m_2
        private static integer MUI_2 = -1
        private static timer t_4 = CreateTimer()
        private static integer array m_4
        private static integer MUI_4 = -1
        sound snd
        real r
        unit c
        real r2
        real rmax
        integer check
        integer child_id
        integer value
        boolean b 
        integer id
        private static method Loop_MyFlushInteger takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_2
                set this = m_2[i]
                if check == 0 then 
                set b = r<rmax 
                else
                set b = GetUnitAbilityLevel(c,check)>0
                endif
                if b then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
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
                    set m_2[i] = m_2[MUI_2]
                    set MUI_2 = MUI_2 - 1
                    if MUI_2 == -1 then
                        call PauseTimer(t_2)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MyFlushI_Start takes integer NewId, integer NewChild_Id, integer NewValue, real NewRmax, unit NewC,integer NewAbiId returns nothing
            local thistype this = thistype.create()
            set MUI_2 = MUI_2 + 1
            set m_2[MUI_2] = this
            set r = 0
            set c = NewC
            set rmax = NewRmax
            set id = NewId
            set child_id = NewChild_Id
            set value = NewValue
            set check = NewAbiId
            if MUI_2 == 0 then
                call TimerStart(t_2, 0.03, true, function thistype.Loop_MyFlushInteger)
            endif
        endmethod
        private static method Loop_MyFlushReal takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_4
                set this = m_4[i]
                if r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if LoadReal(hs, id, child_id) == r2 then
                        set r = 9999
                    endif
                else
                    if r != 9999 then
                        call SaveReal(hs, id, child_id, r2)
                    endif
                    set m_4[i] = m_4[MUI_4]
                    set MUI_4 = MUI_4 - 1
                    if MUI_4 == -1 then
                        call PauseTimer(t_4)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MyFlushR_Start takes integer NewId, integer NewChild_Id, real NewValue, real NewRmax returns nothing
            local thistype this = thistype.create()
            set MUI_4 = MUI_4 + 1
            set m_4[MUI_4] = this
            set r = 0
            set rmax = NewRmax
            set id = NewId
            set child_id = NewChild_Id
            set r2 = NewValue
            if MUI_4 == 0 then
                call TimerStart(t_4, 0.03, true, function thistype.Loop_MyFlushReal)
            endif
        endmethod
        
    endstruct
    function MyFlush takes integer id, integer childid, integer value, real r returns nothing
        call KS_Base.MyFlushI_Start(id, childid, value, r,null,0)
    endfunction
    function MyFlushBuff takes integer id, integer childid, integer value, unit c, integer buff_id returns nothing
        call KS_Base.MyFlushI_Start(id, childid, value, 0,c,buff_id)
    endfunction
    function MyFlushReal takes integer id, integer childid, integer value, real r returns nothing
        call KS_Base.MyFlushR_Start(id, childid, value, r)
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
    call UnitDamageTarget(c, td, dmg, true, false, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_NORMAL, null)
    endfunction
    function dmgphys takes unit c, unit td , real dmg returns nothing
     local real def = BlzGetUnitArmor(td)
     local real armor 
call UnitDamageTarget(c,td,dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, null)
    endfunction
    function dmgatk takes unit c, unit td , real dmg returns nothing
call UnitDamageTarget(c,td,dmg, true, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL, null)
    endfunction
    function spelldmg takes unit c , unit td, real dmg returns nothing
        call UnitDamageTarget(c, td, dmg, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_UNIVERSAL, null)
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
        if PathableCheck3(GetUnitX(c) + sr * Cos(a), GetUnitY(c) + sr * Sin(a)) then
            call SetUnitX(c, GetUnitX(c) + sr * Cos(a))
            call SetUnitY(c, GetUnitY(c) + sr * Sin(a))
        endif
    endfunction
    function PosUnit takes unit c, real x, real y returns nothing
        local integer k = 0
        local integer k2 = 0
        local real a = GAngle2(c,x,y)
        local real sr = SR3(c,x,y)
        if sr< 300 then 
        set k2 = 5 
        elseif sr>= 300 and sr < 800 then 
        set k2 = 10
        else
        set k2 = 20
        endif
        set sr = sr/ k2
        loop
        exitwhen k == k2
        if PathableCheck3(GetUnitX(c) + sr * Cos(a), GetUnitY(c) + sr * Sin(a)) then
            call SetUnitX(c, GetUnitX(c) + sr * Cos(a))
            call SetUnitY(c, GetUnitY(c) + sr * Sin(a))
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
        if PathableCheck3(GetUnitX(c) + sr * Cos(a), GetUnitY(c) + sr * Sin(a)) then
        call SetUnitX(c, GetUnitX(c) + sr * Cos(a))
        call SetUnitY(c, GetUnitY(c) + sr * Sin(a))
        endif
    endfunction
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
    
    private struct KS
        private static timer t_Timer = CreateTimer()
        private static integer array m_Timer
        private static integer MUI_Timer = -1
        private static timer t_1 = CreateTimer()
        private static integer array m_1
        private static integer MUI_1 = -1
        private static timer t_2 = CreateTimer()
        private static integer array m_2
        private static integer MUI_2 = -1
        private static timer t_3 = CreateTimer()
        private static integer array m_3
        private static integer MUI_3 = -1
        private static timer t_4 = CreateTimer()
        private static integer array m_4
        private static integer MUI_4 = -1
        private static timer t_5 = CreateTimer()
        private static integer array m_5
        private static integer MUI_5 = -1
        private static timer t_6 = CreateTimer()
        private static integer array m_6
        private static integer MUI_6 = -1
        private static timer t_7 = CreateTimer()
        private static integer array m_7
        private static integer MUI_7 = -1
        private static timer t_8 = CreateTimer()
        private static integer array m_8
        private static integer MUI_8 = -1
        private static timer t_9 = CreateTimer()
        private static integer array m_9
        private static integer MUI_9 = -1
        private static timer t_10 = CreateTimer()
        private static integer array m_10
        private static integer MUI_10 = -1
        private static timer t_11 = CreateTimer()
        private static integer array m_11
        private static integer MUI_11 = -1
        private static timer t_12 = CreateTimer()
        private static integer array m_12
        private static integer MUI_12 = -1
        private static timer t_13 = CreateTimer()
        private static integer array m_13
        private static integer MUI_13 = -1
        private static timer t_14 = CreateTimer()
        private static integer array m_14
        private static integer MUI_14 = -1
        private static timer t_15 = CreateTimer()
        private static integer array m_15
        private static integer MUI_15 = -1
        private static timer t_16 = CreateTimer()
        private static integer array m_16
        private static integer MUI_16 = -1
        private static timer t_17 = CreateTimer()
        private static integer array m_17
        private static integer MUI_17 = -1
        private static timer t_18 = CreateTimer()
        private static integer array m_18
        private static integer MUI_18 = -1
        private static timer t_19 = CreateTimer()
        private static integer array m_19
        private static integer MUI_19 = -1
        private static timer t_20 = CreateTimer()
        private static integer array m_20
        private static integer MUI_20 = -1
        private static timer t_21 = CreateTimer()
        private static integer array m_21
        private static integer MUI_21 = -1
        private static timer t_22 = CreateTimer()
        private static integer array m_22
        private static integer MUI_22 = -1
        private static timer t_23 = CreateTimer()
        private static integer array m_23
        private static integer MUI_23 = -1
        private static timer t_24 = CreateTimer()
        private static integer array m_24
        private static integer MUI_24 = -1
        private static timer t_25 = CreateTimer()
        private static integer array m_25
        private static integer MUI_25 = -1
        private static timer t_26 = CreateTimer()
        private static integer array m_26
        private static integer MUI_26 = -1
        private static timer t_27 = CreateTimer()
        private static integer array m_27
        private static integer MUI_27 = -1
        private static timer t_28 = CreateTimer()
        private static integer array m_28
        private static integer MUI_28 = -1
        private static timer t_29 = CreateTimer()
        private static integer array m_29
        private static integer MUI_29 = -1
        private static timer t_30 = CreateTimer()
        private static integer array m_30
        private static integer MUI_30 = -1
        private static timer t_31 = CreateTimer()
        private static integer array m_31
        private static integer MUI_31 = -1
        private static timer t_32 = CreateTimer()
        private static integer array m_32
        private static integer MUI_32 = -1
        private static timer t_33 = CreateTimer()
        private static integer array m_33
        private static integer MUI_33 = -1
        private static timer t_34 = CreateTimer()
        private static integer array m_34
        private static integer MUI_34 = -1
        private static timer t_35 = CreateTimer()
        private static integer array m_35
        private static integer MUI_35 = -1
        private static timer t_36 = CreateTimer()
        private static integer array m_36
        private static integer MUI_36 = -1
        private static timer t_37 = CreateTimer()
        private static integer array m_37
        private static integer MUI_37 = -1
        private static timer t_38 = CreateTimer()
        private static integer array m_38
        private static integer MUI_38 = -1
        private static timer t_39 = CreateTimer()
        private static integer array m_39
        private static integer MUI_39 = -1
        private static timer t_40 = CreateTimer()
        private static integer array m_40
        private static integer MUI_40 = -1
        framehandle array frame0_pas1 [10]
        framehandle array frame0_pas2 [10]
        framehandle array frame0_pas3 [10]
        framehandle array frame0_pas4 [10]
        real r
        texttag tg
        real r2
        real r3
        boolean b
        boolean b2
        group g
        destructable ds
        real aoe
        real scale
        real scale2
        real dmg
        lightning light
        fogmodifier fg
        unit u
        effect e
        effect e2
        real red_r
        real green_r
        real a
        real blue_r
        integer red_i
        integer green_i
        integer blue_i
        real r4
        real r5
        real r6
        real rmax
        string s
        string s2
        real dmgmax
        integer child_id
        integer value
        integer id
        integer check
        integer check1
        integer check2
        integer check3
        real move
        integer k
        integer k1
        integer k2
        integer k3
        integer count
        real x1
        real y1
        real x2
        real y2
        player p
        real f
        real time
        real x
        real y
        unit d
        unit td
        unit c
        private static method Loop_MyRemoveUnit takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_1
                set this = m_1[i]
                if r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                else
                    if check == 0 then
                        call RemoveUnit(c)
                    elseif check == 1 then
                        call SetUnitTimeScale(c, r3)
                    elseif check == 2 then
                        call SetUnitAnimationByIndex(c, k)
                    elseif check == 3 then
                        call SetUnitAnimation(c, s)
                    endif
                    set c = null
                    set m_1[i] = m_1[MUI_1]
                    set MUI_1 = MUI_1 - 1
                    if MUI_1 == -1 then
                        call PauseTimer(t_1)
                    endif
                    call destroy()
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
                call TimerStart(t_1, 0.03, true, function thistype.Loop_MyRemoveUnit)
            endif
        endmethod
        private static method Loop_MyRemoveEff takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_2
                set this = m_2[i]
                if r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                else
                    if check == 0 then
                        call DestroyEffect(e)
                    elseif check == 1 then
                        call BlzSetSpecialEffectTimeScale(e, r3)
                    elseif check == 2 then
                        call BlzPlaySpecialEffect(e, ANIM_TYPE_BIRTH)
                    elseif check == 3 then
                        call BlzPlaySpecialEffect(e, ANIM_TYPE_DEATH)
                    endif
                    set e = null
                    set m_2[i] = m_2[MUI_2]
                    set MUI_2 = MUI_2 - 1
                    if MUI_2 == -1 then
                        call PauseTimer(t_2)
                    endif
                    call destroy()
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
                call TimerStart(t_2, 0.03, true, function thistype.Loop_MyRemoveEff)
            endif
        endmethod
        private static method Loop_MUE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_3
                set this = m_3[i]
                if r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        call MoveUnit(c, move , a)
                    elseif check == 1 then
                        call SetUnitX(c, GetUnitX(c) + move * Cos(a))
                        call SetUnitY(c, GetUnitY(c) + move * Sin(a))
                    elseif check == 2 then
                        call SetUnitPosition(c, GetUnitX(c) + move * Cos(a), GetUnitY(c) + move * Sin(a))
                    endif
                else
                    set c = null
                    set m_3[i] = m_3[MUI_3]
                    set MUI_3 = MUI_3 - 1
                    if MUI_3 == -1 then
                        call PauseTimer(t_3)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MUE_Start takes unit NewC, real NewDist, real NewRmax, real NewA, integer typemove returns nothing
            local thistype this = thistype.create()
            set MUI_3 = MUI_3 + 1
            set m_3[MUI_3] = this
            set c = NewC
            set r = 0
            set check = typemove // 0 - Move unit, 1 - set x y, 2 - set position
            set rmax = NewRmax
            set move = (NewDist / (rmax * 100)) * 3
            if LoadInteger(hs,GetHandleId(c),StringHash("rt")) == 1 or LoadInteger(hs,GetHandleId(c),StringHash("def t")) == 1 then 
            set move = move * 0.5
            endif
            set a = NewA
            if MUI_3 == 0 then
                call TimerStart(t_3, 0.03, true, function thistype.Loop_MUE)
            endif
        endmethod
        private static method LoopHeightSet takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_4
                set this = m_4[i]
                set r2 = r2 + 0.03
                set r2 = S2R( R2SW( r2 , 0, 3 ) )
                if check == 0 then
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
                            set r = r + 0.03
                            set r = S2R( R2SW( r , 0, 3 ) )
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
                        call PauseTimer(t_4)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method HeightSet_Start takes unit NewC, real NewRmax, real NewFly, real NewWait returns nothing
            local thistype this = thistype.create()
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
                call TimerStart(t_4, 0.03, true, function thistype.LoopHeightSet)
            endif
        endmethod
        private static method Loop_DmgPTime takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_5
                set this = m_5[i]
                if r <= rmax and GetWidgetLife(td) > 0.405 then
                    set r = r + 0.05
                    if r3 > r2 then
                        set r3 = 0
                        if k == 0 then
                            call dmgphys(c, td, dmg)
                        elseif k == 1 then
                        call dmgmag(c,td,dmg)
                        else
                        call dmgatk(c,td,dmg)
                        endif
                    else
                        set r3 = r3 + 0.05
                    endif
                else
                    set td = null
                    set c = null
                    set m_5[i] = m_5[MUI_5]
                    set MUI_5 = MUI_5 - 1
                    if MUI_5 == -1 then
                        call PauseTimer(t_5)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DmgPTime_Start takes unit NewC, unit NewTd, real NewR, real NewRmax, real NewPeriod, integer NewTD returns nothing
            local thistype this = thistype.create()
            set MUI_5 = MUI_5 + 1
            set m_5[MUI_5] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r3 = 999
            set rmax = NewRmax + NewPeriod
            set r2 = NewPeriod
            set dmg = NewR
            set k = NewTD
            if r2 <= 0 then
                set r2 = 1
            endif
            set dmg = dmg / (rmax / r2)
            if MUI_5 == 0 then
                call TimerStart(t_5, 0.05, true, function thistype.Loop_DmgPTime)
            endif
        endmethod
        private static method LoopSpellTimer takes nothing returns nothing
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
                    set r = r + 0.05
                else
                    if GetUnitAbilityLevel(c, k1) > 0 then
                    call SetPlayerAbilityAvailable(p, k2, true)
                        call SetPlayerAbilityAvailable(p, k1, false)
                    endif
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(k2)), 0)
                    set c = null
                    set p = null
                    set m_6[i] = m_6[MUI_6]
                    set MUI_6 = MUI_6 - 1
                    if MUI_6 == -1 then
                        call PauseTimer(t_6)
                    endif
                    call destroy()
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
            set rmax = NewR
            call SetPlayerAbilityAvailable(p, k2, false)
            if GetUnitAbilityLevel(c, k1) == 0 then
                call UnitAddAbility(c, k1)
                call UnitMakeAbilityPermanent(c, true, k1)
            endif
            call SetPlayerAbilityAvailable(p, k1, true)
            if MUI_6 == 0 then
                call TimerStart(t_6, 0.05, true, function thistype.LoopSpellTimer)
            endif
        endmethod
        private static method Loop_ColorDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_7
                set this = m_7[i]
                set r2 = r2 + 0.03
                set r2 = S2R( R2SW( r2 , 0, 3 ) )
                if check == 0 then
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
                        call PauseTimer(t_7)
                    endif
                    call destroy()
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
                call TimerStart(t_7, 0.03, true, function thistype.Loop_ColorDummy)
            endif
        endmethod
        private static method Loop_ColorEffDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_8
                set this = m_8[i]
                set r2 = r2 + 0.03
                set r2 = S2R( R2SW( r2 , 0, 3 ) )
                if check == 0 then
                    if r2 > r3 then
                        if r < rmax then
                            set r = r + 0.03
                            set r = S2R( R2SW( r , 0, 3 ) )
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
                        call PauseTimer(t_8)
                    endif
                    call destroy()
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
                call TimerStart(t_8, 0.03, true, function thistype.Loop_ColorEffDummy)
            endif
        endmethod
        private static method Loop_MyRemoveFogModifier takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_9
                set this = m_9[i]
                if r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                else
                    call FogModifierStop(fg)
                    call DestroyFogModifier(fg)
                    set fg = null
                    set m_9[i] = m_9[MUI_9]
                    set MUI_9 = MUI_9 - 1
                    if MUI_9 == -1 then
                        call PauseTimer(t_9)
                    endif
                    call destroy()
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
                call TimerStart(t_9, 0.03, true, function thistype.Loop_MyRemoveFogModifier)
            endif
        endmethod
        private static method Loop_MoveEffectToUnit takes nothing returns nothing
            local thistype this
            local real rr = 0
            local integer i = 0
            loop
                exitwhen i > MUI_10
                set this = m_10[i]
                if check2 == 0 then
                    set b = r < rmax and IsUnitType(d, UNIT_TYPE_DEAD) == false
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
                    set b = r < rmax
                endif
                if b then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
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
                        call DestroyEffect(e)
                    endif
                    set d = null
                    set e = null
                    set m_10[i] = m_10[MUI_10]
                    set MUI_10 = MUI_10 - 1
                    if MUI_10 == -1 then
                        call PauseTimer(t_10)
                    endif
                    call destroy()
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
                call TimerStart(t_10, 0.03, true, function thistype.Loop_MoveEffectToUnit)
            endif
        endmethod
        private static method Loop_MoveUnitToUnit takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_11
                set this = m_11[i]
                if r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call SetUnitX(c, GetUnitX(d))
                    call SetUnitY(c, GetUnitY(d))
                    call SetFly(c, GetUnitFlyHeight(d) + f)
                else
                    set d = null
                    set c = null
                    set m_11[i] = m_11[MUI_11]
                    set MUI_11 = MUI_11 - 1
                    if MUI_11 == -1 then
                        call PauseTimer(t_11)
                    endif
                    call destroy()
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
                call TimerStart(t_11, 0.03, true, function thistype.Loop_MoveUnitToUnit)
            endif
        endmethod
        private static method Loop_NextDmg takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_12
                set this = m_12[i]
                if r < rmax then
                    set r = r + 0.03
                else
                    if check == 0 then
                        call dmgmag(c, td, dmg)
                    elseif check == 1 then
                       call dmgphys(c, td, dmg)
                    else
                    call dmgatk(c, td, dmg)
                    endif
                    set c = null
                    set td = null
                    set m_12[i] = m_12[MUI_12]
                    set MUI_12 = MUI_12 - 1
                    if MUI_12 == -1 then
                        call PauseTimer(t_12)
                    endif
                    call destroy()
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
                call TimerStart(t_12, 0.03, true, function thistype.Loop_NextDmg)
            endif
        endmethod
        private static method Loop_BlockHpRegen takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_13
                set this = m_13[i]
                if r < rmax and IsUnitType(c, UNIT_TYPE_DEAD) == false then
                    set r = r + 0.05
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
                        call PauseTimer(t_13)
                    endif
                    call destroy()
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
                call TimerStart(t_13, 0.05, true, function thistype.Loop_BlockHpRegen)
            endif
        endmethod
        private static method Loop_RemoveAbility takes nothing returns nothing
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
                        call PauseTimer(t_14)
                    endif
                    call destroy()
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
                call TimerStart(t_14, 0.1, true, function thistype.Loop_RemoveAbility)
            endif
        endmethod
        private static method Loop_NextSound takes nothing returns nothing
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
                        call PauseTimer(t_15)
                    endif
                    call destroy()
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
                call TimerStart(t_15, 0.1, true, function thistype.Loop_NextSound)
            endif
        endmethod
        private static method Loop_ScaleDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_16
                set this = m_16[i]
                set r2 = r2 + 0.03
                set r2 = S2R( R2SW( r2 , 0, 3 ) )
                if check == 0 then
                    if r2 > r3 then
                        if r < rmax then
                            set r = r + 0.03
                            set r = S2R( R2SW( r , 0, 3 ) )
                            if check2 == 0 then
                                set scale = scale + r4
                            else
                                set scale = scale - r4
                            endif
                            call SetUnitScale(c, scale, scale, scale)
                        else
                            set check = 1
                        endif
                    endif
                else
                    set c = null
                    set m_16[i] = m_16[MUI_16]
                    set MUI_16 = MUI_16 - 1
                    if MUI_16 == -1 then
                        call PauseTimer(t_16)
                    endif
                    call destroy()
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
                call TimerStart(t_16, 0.03, true, function thistype.Loop_ScaleDummy)
            endif
        endmethod
        private static method Loop_EMUE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_17
                set this = m_17[i]
                if r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call MoveEff2(e, move , a)
                else
                    set e = null
                    set m_17[i] = m_17[MUI_17]
                    set MUI_17 = MUI_17 - 1
                    if MUI_17 == -1 then
                        call PauseTimer(t_17)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method EMUE_Start takes effect NewE, real NewDist, real NewRmax, real NewA, integer typemove returns nothing
            local thistype this = thistype.create()
            set MUI_17 = MUI_17 + 1
            set m_17[MUI_17] = this
            set e = NewE
            set r = 0
            set check = typemove // 0 - Move unit, 1 - set x y, 2 - set position
            set rmax = NewRmax
            set move = (NewDist / (rmax * 100)) * 3
            set a = NewA
            if MUI_17 == 0 then
                call TimerStart(t_17, 0.03, true, function thistype.Loop_EMUE)
            endif
        endmethod
        private static method Loop_ScaleEffDummy takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_18
                set this = m_18[i]
                set r2 = r2 + 0.03
                set r2 = S2R( R2SW( r2 , 0, 3 ) )
                if check == 0 then
                    if r2 > r3 then
                        if r <= rmax then
                            set r = r + 0.03
                            set r = S2R( R2SW( r , 0, 3 ) )
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
                        call PauseTimer(t_18)
                    endif
                    call destroy()
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
                call TimerStart(t_18, 0.03, true, function thistype.Loop_ScaleEffDummy)
            endif
        endmethod
        private static method Loop_HpS takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rer
            loop
                exitwhen i > MUI_19
                set this = m_19[i]
                if r < rmax  then
                    set r = r + 0.25
                    if check == 0 then
                        call SetHpCurrent2(c,td, r3)
                    else
                        call SetMpCurrent(c, r3)
                    endif
                else
                    set c = null
                    set td = null
                    set m_19[i] = m_19[MUI_19]
                    set MUI_19 = MUI_19 - 1
                    if MUI_19 == -1 then
                        call PauseTimer(t_19)
                    endif
                    call destroy()
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
            set r3 = (NewHeal / (NewMax * 4))
            set rmax = NewMax
            if MUI_19 == 0 then
                call TimerStart(t_19, 0.25, true, function thistype.Loop_HpS)
            endif
        endmethod
        private static method Loop_ColorLightning takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_20
                set this = m_20[i]
                set r2 = r2 + 0.03
                set r2 = S2R( R2SW( r2 , 0, 3 ) )
                if check == 0 then
                    if r2 > r3 then
                        if r < rmax then
                            set r = r + 0.03
                            set r = S2R( R2SW( r , 0, 3 ) )
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
                        call PauseTimer(t_20)
                    endif
                    call destroy()
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
                call TimerStart(t_20, 0.03, true, function thistype.Loop_ColorLightning)
            endif
        endmethod
        private static method Loop_TT_DELAY takes nothing returns nothing
            local thistype this
            local integer i = 0
            local texttag l__txt
            local integer loopPlayers = 0
            loop
                exitwhen i > MUI_21
                set this = m_21[i]
                if r < rmax then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
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
                        call PauseTimer(t_21)
                    endif
                    call destroy()
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
                call TimerStart(t_21, 0.05, true, function thistype.Loop_TT_DELAY)
            endif
        endmethod
        private static method Loop_Fear takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rer
            loop
                exitwhen i > MUI_22
                set this = m_22[i]
                if r < rmax and GetWidgetLife(c) > 1 and GetUnitAbilityLevel(c, 'A15H') == 0 then
                    set r = r + 0.03
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
                        call PauseTimer(t_22)
                    endif
                    call destroy()
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
            set e = AddSpecialEffect("war3mapimported\\Gear_0233.mdl", GetUnitX(td), GetUnitY(td))
            call BlzSetSpecialEffectTimeScale(e, 1)
            call BlzSetSpecialEffectZ(e, 0)
            call BlzSetSpecialEffectScale(e, 2)
            call BlzSetSpecialEffectYaw(e, GetUnitFacing(td) * bj_DEGTORAD)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call EnableUserControl(false)
            endif
            if MUI_22 == 0 then
                call TimerStart(t_22, 0.03, true, function thistype.Loop_Fear)
            endif
        endmethod
        private static method Loop_SetAbilityLevel takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_23
                set this = m_23[i]
                if r < rmax then
                    set r = r + 0.1
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
                            call PauseTimer(t_23)
                        endif
                        call destroy()
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
                call TimerStart(t_23, 0.1, true, function thistype.Loop_SetAbilityLevel)
            endif
        endmethod
        private static method Loop_NextCD takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_24
                set this = m_24[i]
                if r < rmax then
                    set r = r + 0.05                    
                else
                    if BlzGetUnitAbilityCooldownRemaining(c,check)>r4 then 
                   call BlzStartUnitAbilityCooldown(c,check,r4)
                   endif
                        set c = null
                        set m_24[i] = m_24[MUI_24]
                        set MUI_24 = MUI_24 - 1
                        if MUI_24 == -1 then
                            call PauseTimer(t_24)
                        endif
                        call destroy()
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
                call TimerStart(t_24, 0.05, true, function thistype.Loop_NextCD)
            endif
        endmethod
         private static method Loop_NextFakeCD takes nothing returns nothing
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
                if r < rmax and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)>0 and b then
                    set r = r + 0.05  
                else
                if r>= rmax then 
                endif
                if BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)<=0 then 
                endif
                if b == false then 
                endif
                if check2 != 0 then 
                call SaveInteger(hs,GetHandleId(c),check2,k2)
                if LoadInteger(hs,GetHandleId(c),StringHash("pas cd")) == 0 then 
                else
                endif
                endif
                call UnitRemoveAbility(c,FakeAbi_ID)
                   if check == InoriE_ID and LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
                   
                   elseif check == AlterSaberW_ID and LoadInteger(hs, GetHandleId(c), StringHash("mode r")) == 1 then
                  
                  else
                  
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),check,true)
                      endif
                      set c = null
                        set m_25[i] = m_25[MUI_25]
                        set MUI_25 = MUI_25 - 1
                        if MUI_25 == -1 then
                            call PauseTimer(t_25)
                        endif
                        call destroy()
                    endif
                set i = i + 1
            endloop
        endmethod   
        public static method FakeCD_Start1 takes unit NewC,integer NewAbi,real NewCd, integer NewStringHash, integer NewValue returns nothing
            local thistype this = thistype.create()
            set MUI_25 = MUI_25 + 1
            set m_25[MUI_25] = this
            set c = NewC
            set rmax = NewCd
            set r = 0
            set b = true
            set check2 = NewStringHash
            set k2 = NewValue
            set r4 = NewCd
            set check = NewAbi
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),check,false)
            call UnitAddAbility(c,FakeAbi_ID)
            if GetLocalPlayer() == GetOwningPlayer(c) then
            call BlzSetAbilityPosX(FakeAbi_ID,BlzGetAbilityPosX(check))
            call BlzSetAbilityPosY(FakeAbi_ID,BlzGetAbilityPosY(check))
            call BlzSetAbilityIcon(FakeAbi_ID, BlzGetAbilityIcon(check))
            call BlzSetAbilityTooltip(FakeAbi_ID,BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, check), ABILITY_SLF_TOOLTIP_NORMAL, GetUnitAbilityLevel(c,check)-1),0)
            call BlzSetAbilityExtendedTooltip(FakeAbi_ID,BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, check), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, GetUnitAbilityLevel(c,check)-1),0)
            endif
            if  IsItemInInventory(c,'I011')>0 and  BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
             call BlzStartUnitAbilityCooldown(c,FakeAbi_ID,r4*(1-OkarunEggReduceCD/100))
            else
             call BlzStartUnitAbilityCooldown(c,FakeAbi_ID,r4)
            endif
            if MUI_25 == 0 then
                call TimerStart(t_25, 0.05, true, function thistype.Loop_NextFakeCD)
            endif
        endmethod
        private static method ELoopHeightSet takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_26
                set this = m_26[i]
                set r2 = r2 + 0.03
                set r2 = S2R( R2SW( r2 , 0, 3 ) )
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
                            set r = r + 0.03
                            set r = S2R( R2SW( r , 0, 3 ) )
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
                        call PauseTimer(t_26)
                    endif
                    call destroy()
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
                call TimerStart(t_26, 0.03, true, function thistype.ELoopHeightSet)
            endif
        endmethod
        private static method Loop_MyRemoveDest takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_27
                set this = m_27[i]
                if r < rmax and  GetDestructableLife(ds)>2 then
                    set r = r + 0.03
                    set r = RoundReal(r,3)
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
                        call PauseTimer(t_27)
                    endif
                    call destroy()
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
                call TimerStart(t_27, 0.03, true, function thistype.Loop_MyRemoveDest)
            endif
        endmethod
        private static method Loop_MyBuffTime takes nothing returns nothing
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
                    set r = r + 0.1
                    set r = RoundReal(r,3)
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
                    if GetLocalPlayer() == Player(k2) then 
                    call BlzFrameSetVisible(frame0_pas1[k2],false)
                    call BlzFrameSetVisible(frame0_pas4[k2],false)
                    endif
                    set c = null
                    set m_28[i] = m_28[MUI_28]
                    set MUI_28 = MUI_28 - 1
                    if MUI_28 == -1 then
                        call PauseTimer(t_28)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MyBuffTime_Start takes unit NewC,integer NewId, real NewRmax, string NewS,boolean NewPauseCount, integer NewPlayerId, integer IgnoreBuff, integer NewSh returns nothing
            local thistype this = thistype.create()
            local real tmp_x = 0
            local real tmp_y = 0
            set MUI_28 = MUI_28 + 1
            set m_28[MUI_28] = this
            set c = NewC
            set id = NewId
            set s = NewS
            set check = NewSh
            set check2 = IgnoreBuff
            set rmax = NewRmax
            set b = NewPauseCount
            if NewPlayerId == -1 then 
            set k2 = GetPlayerId(GetOwningPlayer(c))
            else
            set k2 = NewPlayerId
            endif
            set tmp_x = 0.26875 //* 0.0225
                set tmp_y = 0.17
                if frame0_pas1[k2] == null then 
                set frame0_pas1[k2] = BlzCreateFrameByType("SIMPLEFRAME", "2Face", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
                call BlzFrameClearAllPoints(frame0_pas1[k2])
                    call BlzFrameSetVisible(frame0_pas1[k2],false)
                if GetLocalPlayer() == Player(k2) then 
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
                call BlzFrameSetPoint(frame0_pas4[k2], FRAMEPOINT_BOTTOMLEFT,frame0_pas1[k2],FRAMEPOINT_BOTTOMLEFT, tmp_x-0.265, tmp_y-0.335)
                call BlzFrameSetText(frame0_pas4[k2], "" + R2SW(rmax,0,1) + "|r")
                call BlzFrameSetScale(frame0_pas4[k2], 1)
                call BlzFrameSetSize(frame0_pas4[k2], 0.2, 0.2)
                 call BlzFrameSetVisible(frame0_pas4[k2],false)
                if GetLocalPlayer() == Player(k2) then 
                    call BlzFrameSetVisible(frame0_pas4[k2],true)
                    endif
                else
                 if GetLocalPlayer() == Player(k2) then 
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
                set r = 0
            if MUI_28 == 0 then
                call TimerStart(t_28, 0.1, true, function thistype.Loop_MyBuffTime)
            endif
        endmethod
        private static method Loop_MyBuffEff takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_29
                set this = m_29[i]
                if r < rmax and GetUnitAbilityLevel(c,id)>0 then
                    set r = r + 0.1
                    set r = RoundReal(r,3)
                    else
                    call DestroyEffect(e)
                    set e = null
                    set c = null
                    set m_29[i] = m_29[MUI_29]
                    set MUI_29 = MUI_29 - 1
                    if MUI_29 == -1 then
                        call PauseTimer(t_29)
                    endif
                    call destroy()
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
                call TimerStart(t_29, 0.1, true, function thistype.Loop_MyBuffEff)
            endif
        endmethod
        private static method Loop_MyFlushIntegerC takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_30
                set this = m_30[i]
                if r < rmax then
                    if b == true then
                    set r = r + 0.03 
                    elseif IsUnitPaused(c) == false then 
                    set r = r + 0.03 
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
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
                        call PauseTimer(t_30)
                    endif
                    call destroy()
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
                call TimerStart(t_30, 0.03, true, function thistype.Loop_MyFlushIntegerC)
            endif
        endmethod
        private static method Loop_AddStacks takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_31
                set this = m_31[i]
                if r < rmax then
                    set r = r + 0.03 
                    set r = S2R( R2SW( r , 0, 3 ) )
                else
                    if b == true then
                    call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,id)),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,id)))+check)
                    else
                    call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,id)),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,id)))-check)                    
                    endif
                    set c = null
                    set m_31[i] = m_31[MUI_31]
                    set MUI_31 = MUI_31 - 1
                    if MUI_31 == -1 then
                        call PauseTimer(t_31)
                    endif
                    call destroy()
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
                call TimerStart(t_31, 0.03, true, function thistype.Loop_AddStacks)
            endif
        endmethod
    endstruct
    
    function MyItemStacks takes unit c, integer item_id, integer stack_amount, real r ,boolean add_or_remove returns nothing
        call KS.MyAddStacks_Start(c, item_id, stack_amount, r,add_or_remove)
    endfunction
    function LustSin takes unit c, unit td, real dmg returns real 
local integer check = 0
if dmg >= LustSin_MinDmg and GetUnitAbilityLevel(c,'A07O')>0 and BlzGetUnitAbilityCooldownRemaining(c,'A07O')==0 then 
        set dmg = dmg * (LustSin_IgnoreAmount/100) 
        if IsItemInInventory(c,'I01W') >0 then 
        if GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W')))>0 then 
        call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W')))-1)
        endif
        if GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W')))== 0 then 
        call BlzStartUnitAbilityCooldown(c,'A07O',LustSin_CD)
        endif
        call MyItemStacks(c,'I01W',1,10,true)
        else
        call BlzStartUnitAbilityCooldown(c,'A07O',LustSin_CD)
        endif
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_firefly-rq-sfx-5.mdl",td,"chest"))
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_0706Red.mdl",td,"chest"))
        set check = 1
        endif
        if check == 0 then 
        set dmg = 0 
        endif
        return dmg
endfunction
    function MyFlush2 takes unit c, integer childid, integer value, real r,boolean countinpause returns nothing
        call KS.MyFlushIC_Start(c, childid, value, r,countinpause)
    endfunction
    function MyEffBuff takes unit c,integer buff_id, effect e returns nothing
        call KS.MyBuffEff_Start(c,buff_id,e)
    endfunction
    function MyFrame takes unit c,real rmax, string icon_path, boolean pauseunitcount returns nothing
        call KS.MyBuffTime_Start(c,0,rmax,icon_path,pauseunitcount,-1,1,0)
    endfunction
    function MyFrameBuff takes unit c,integer buff_id,real rmax, string icon_path, boolean pauseunitcount returns nothing
        call KS.MyBuffTime_Start(c,buff_id,rmax,icon_path,pauseunitcount,-1,0,0)
    endfunction
    function MyFrameBuff2 takes unit c,integer buff_id,real rmax, string icon_path, boolean pauseunitcount, integer player_id returns nothing
        call KS.MyBuffTime_Start(c,buff_id,rmax,icon_path,pauseunitcount,player_id,0,0)
    endfunction
    function MyRemoveDest takes destructable ds, real r returns nothing
        call KS.MyRemoveDest_Start(ds, r, 0, -1, -1, "")
    endfunction
    function MyAnimDest takes destructable ds, real r returns nothing
        call KS.MyRemoveDest_Start(ds, r, 1, -1, -1, "")
    endfunction
    function FakeCD_Start takes unit NewC,integer NewAbi,real NewCD, integer New_Sh, integer New_Value returns nothing
        call KS.FakeCD_Start1(NewC,NewAbi,NewCD,New_Sh,New_Value)
    endfunction
    function CD_Start takes unit NewC, real NewRmax,integer NewAbi,real NewCD returns nothing
        call KS.CD_Start(NewC,NewRmax,NewAbi,NewCD)
    endfunction
    function AllTextTagPartialDelay takes string ls, unit u, integer r, integer g, integer b, integer lv, real size, real delay returns nothing
        call KS.TexttagDelay_Start(ls, u, r, g, b, lv, size, delay)
    endfunction
    function FearUnit takes unit c, real angle, real rmax returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
        endif
        call UnitAddAbility(DummyPlayer[i], 'APP2')
        call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], c) * bj_RADTODEG)
        call IssueTargetOrder(DummyPlayer[i], "curse", c)
        call KS.Fear_Start(c, angle, rmax)
    endfunction
    function ColorLightning takes lightning c, real r, real red, real green, real blue, real rmax, boolean b returns nothing
        call KS.ColorLightning_Start(c, r, red, green, blue, rmax, b)
    endfunction
    function HPS takes unit c,unit td, real heal, real max returns nothing
        call KS.HPS_Start(c,td, 0, heal, max)
    endfunction
    function MPS takes unit c, real heal, real max returns nothing
        call KS.HPS_Start(c,c, 1, heal, max)
    endfunction
    function ScaleEffDummy takes effect e, real r, real scale1, real scale2 returns nothing
        call KS.ScaleEffDummy_Start(e, 0, scale1, scale2, r)
    endfunction
    function ScaleEffDummy2 takes effect e, real prepare, real r, real scale1, real scale2 returns nothing
        call KS.ScaleEffDummy_Start(e, prepare, scale1, scale2, r)
    endfunction
    function EMUE takes effect e, real dist, real rmax, real a returns nothing
        call KS.EMUE_Start(e, dist, rmax, a, 0)
    endfunction    
    function ScaleDummy takes unit c, real r, real scale1, real scale2 returns nothing
        call KS.ScaleDummy_Start(c, 0, scale1, scale2, r)
    endfunction
    function ScaleDummy2 takes unit c, real prepare, real r, real scale1, real scale2 returns nothing
        call KS.ScaleDummy_Start(c, prepare, scale1, scale2, r)
    endfunction
    function NextSound takes string s, real r returns nothing
        call KS.NextSound_Start(s, r)
    endfunction
    function MyRemoveAbility takes unit c, real r, integer id, integer add_or_delete returns nothing
        call KS.RemoveAbility_Start(c, r, id, add_or_delete)
    endfunction
    function BlockRegen takes unit c, real rmax, real blockheal returns nothing
        call KS.BlockHpRegen_Start(c, rmax, blockheal)
    endfunction
    function NextDmg takes unit c, unit td, real dmg, integer typedmg, real rmax returns nothing
        call KS.NextDmg_Start(c, td, dmg, typedmg, rmax)
    endfunction
    function MUTU2 takes unit c, real r, real f, unit t returns nothing
        call KS.MoveUnitToUnit_Start(c, r, f, t, 0)
    endfunction
    function MUTU3 takes unit c, real r, real f, unit t returns nothing
        call KS.MoveUnitToUnit_Start(c, r, f, t, 1)
    endfunction
    function EUTU2 takes effect e, real r, real f, unit t returns nothing
        call KS.MoveEffectToUnit_Start(e, r, f, t, 0, 1, null)
    endfunction
    function EUTU2_2 takes effect e, real r, real f, unit t returns nothing
        call KS.MoveEffectToUnit_Start(e, r, f, t, 0, 0, null)
    endfunction
    function EUTU2_3 takes effect e, real r, real f, unit t returns nothing
        call DestroyEffect(e)
        call KS.MoveEffectToUnit_Start(e, r, f, t, 0, 0, null)
    endfunction
    function EUTU3 takes effect e, real r, real f, unit t, integer ability_id returns nothing
        call KS.MoveEffectToUnit_Start(e, r, f, t, ability_id, 1, null)
    endfunction
    function EUTU4 takes effect e, real r, real f, effect e2 returns nothing
        call KS.MoveEffectToUnit_Start(e, r, f, null, 0, 1, e2)
    endfunction
    function MyRemoveFog takes fogmodifier fg, real r returns nothing
        call KS.MyRemoveFogModifier_Start(fg, r)
    endfunction
    function VisionTimed takes player p, real x, real y, real vision, real time returns nothing
        local fogmodifier fm = CreateFogModifierRadius(p, FOG_OF_WAR_VISIBLE, x, y, vision, true, false)
        call FogModifierStart(fm)
        call MyRemoveFog(fm, time)
        set fm = null
    endfunction
    function MyRemoveUnit takes unit c, real r returns nothing
        call KS.MyRemoveUnit_Start(c, r, 0, -1, -1, "")
    endfunction
    function AnimDummy takes unit c, real r, real r2 returns nothing
        call KS.MyRemoveUnit_Start(c, r, 1, r2, -1, "")
    endfunction
    function SetAnim takes unit c, real r, string s returns nothing
        call KS.MyRemoveUnit_Start(c, r, 3, -1, -1, s)
    endfunction
    function SetAnimIndex takes unit c, real r, integer i returns nothing
        call KS.MyRemoveUnit_Start(c, r, 2, -1, i, "")
    endfunction
    function MyRemoveEff takes effect c, real r returns nothing
        call KS.MyRemoveEff_Start(c, r, 0, -1, -1, "")
    endfunction
    function AnimDummyEff takes effect c, real r, real r2 returns nothing
        call KS.MyRemoveEff_Start(c, r, 1, r2, -1, "")
    endfunction
    function SetAnimEffBirth takes effect c, real r returns nothing
        call KS.MyRemoveEff_Start(c, r, 2, -1, -1, "")
    endfunction
    function SetAnimEffDeath takes effect c, real r returns nothing
        call KS.MyRemoveEff_Start(c, r, 3, -1, 0, "")
    endfunction
    function DmgPTime takes unit c, unit td, real dmg, real rmax, real period, integer typedmg returns nothing
        call KS.DmgPTime_Start(c, td, dmg, rmax, period, typedmg)
    endfunction
    function HeightSet takes unit c, real time, real fly returns nothing
        call KS.HeightSet_Start(c, time, fly, 0)
    endfunction
    function HeightSet2 takes unit c, real time, real fly, real wait returns nothing
        call KS.HeightSet_Start(c, time, fly, wait)
    endfunction
    function EHeightSet takes effect c, real time, real fly returns nothing
        call KS.EHeightSet_Start(c, time, fly, 0)
    endfunction
    function EHeightSet2 takes effect c, real time, real fly, real wait returns nothing
        call KS.EHeightSet_Start(c, time, fly, wait)
    endfunction
    function MUE takes unit c, real dist, real rmax, real a returns nothing
        call KS.MUE_Start(c, dist, rmax, a, 0)
    endfunction
    function MUE2 takes unit c, real dist, real rmax, real a returns nothing
        call KS.MUE_Start(c, dist, rmax, a, 1)
    endfunction
    function MUE3 takes unit c, real dist, real rmax, real a returns nothing
        call KS.MUE_Start(c, dist, rmax, a, 2)
    endfunction
    function ColorDummy4 takes unit c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        call KS.ColorDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, false)
    endfunction
    function ColorDummy3 takes unit c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        call KS.ColorDummy_Start(c, preare_time, red, green, blue, 255, rmax, true, true)
    endfunction
    function ColorDummy32 takes unit c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        call KS.ColorDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, true)
    endfunction
    function ColorDummy2 takes unit c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
        call KS.ColorDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, true)
    endfunction
    function ColorDummy2_2 takes unit c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
        call KS.ColorDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, false)
    endfunction  
    function ColorEffDummy4 takes effect c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        call KS.ColorEffDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, false)
    endfunction
    function ColorEffDummy3 takes effect c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        call KS.ColorEffDummy_Start(c, preare_time, red, green, blue, 255, rmax, true, true)
    endfunction
    function ColorEffDummy32 takes effect c, real preare_time, integer red, integer green, integer blue, real rmax returns nothing
        call KS.ColorEffDummy_Start(c, preare_time, red, green, blue, 255, rmax, false, true)
    endfunction
    function ColorEffDummy2 takes effect c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
        call KS.ColorEffDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, true)
    endfunction
    function ColorEffDummy2_2 takes effect c, real preare_time, integer red, integer green, integer blue, integer alpha, real rmax returns nothing
        call KS.ColorEffDummy_Start(c, preare_time, red, green, blue, alpha, rmax, false, false)
    endfunction
    function MyRemoveLevelAbility takes unit c, real r, integer id returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("spell and " + I2S(id))) == 0 then
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("spell and " + I2S(id)), 1)
            call KS.SetAbilityLevel_Start(c, r, id, GetUnitAbilityLevel(c, id), true)
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
        call KS.SpellTimer_Timer_Start(c, r, id_new, id_old,0)
    endfunction    
    function SwapAbilityBuff takes unit c,  integer id_new , integer id_old, integer buff_id returns nothing
        call KS.SpellTimer_Timer_Start(c, 0, id_new, id_old,buff_id)
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
    function decorcheck1 takes destructable d returns boolean
        local integer i = GetDestructableTypeId(d)
        return i == 'B012' or i == 'B013' or i == 'B014' or i == 'B015' or i == 'B016' or i == 'B017' or i == 'B018' or i == 'B019' or i == 'B01A' or i == 'B01B' or i == 'B01C' or i == 'B01D' or i == 'B01E' or i == 'B024' or i == 'B025' or i == 'B026' or i == 'B027' or i == 'B028' or i == 'B029' or i == 'B030'
    endfunction
    function decordustcheck takes destructable d returns boolean
        local integer i = GetDestructableTypeId(d)
        return i == 'B001' or i == 'B002' or i == 'B00G' or i == 'B00H' or i == 'B00P' or i == 'B000' or i == 'B007' or i == 'B009' or i == 'B00F' or i == 'B00U' or i == 'B00V' or i == 'B00W' or i == 'B00X'
    endfunction
    function decorcheck takes destructable d returns boolean
        local boolean b = false
        local integer i = GetDestructableTypeId(d)
        if decorcheck1(d)  or i == 'B00H' or i == 'B00I' or i == 'B00J' or i == 'B006' or i == 'B00C' or i == 'B007' or i == 'B00B' or i == 'B004' or i == 'B010' or i == 'B00C' then
            set b = true
        endif
        return b
    endfunction    
    function decordrevive takes nothing returns nothing
          call DestructableRestoreLife(GetEnumDestructable(), GetDestructableMaxLife(GetEnumDestructable()), true )
    endfunction
    function GetPlayerTakenPhys takes player p returns real 
    local integer id = GetPlayerId(p)
    local real dmg1 = PlayerDamageTakenMag[id]+1
    local real dmg2 = PlayerDamageTakenPhys[id]+1
    local real dmg = dmg1+dmg2
    local real result = (dmg2/dmg)*100    
    return result
    endfunction
    function GetPlayerTakenMag takes player p returns real 
    local integer id = GetPlayerId(p)
    local real dmg1 = PlayerDamageTakenMag[id]+1
    local real dmg2 = PlayerDamageTakenPhys[id]+1
    local real dmg = dmg1+dmg2
    local real result = (dmg1/dmg)*100    
    return result
    endfunction
    function GroupDmg takes unit c, real x,real y,real aoe,real dmg  returns nothing
    local group g = CreateGroup()
    local unit u 
    call GroupEnumUnitsInRange( g , x , y , aoe , Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null 
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call NextDmg(c, u, dmg,0,0.12)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                call DestroyGroup(g)
                                set u = null
                                set g = null
    endfunction
    
    
    function GetItemValue takes integer i returns integer
    local item a
    local integer g1 = GetPlayerState(Player(12), PLAYER_STATE_RESOURCE_GOLD)
    local integer g2 = 0
    local integer check = LoadInteger(hs, GetHandleId(Player(PLAYER_NEUTRAL_PASSIVE)), StringHash(I2S(i)))
    if i != 0 then
        if check == 0then
            set a = UnitAddItemByIdSwapped(i, pricesell)
            call UnitDropItemTarget(pricesell, a, priceshop)
            set g2 = GetPlayerState(Player(12), PLAYER_STATE_RESOURCE_GOLD) - g1
            call SaveInteger(hs, GetHandleId(Player(PLAYER_NEUTRAL_PASSIVE)), StringHash(I2S(i)), g2)
            call SetPlayerState(Player(12), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(12), PLAYER_STATE_RESOURCE_GOLD) - g2)
        else
            set g2 = check
        endif
    endif
    set a = null
    return R2I(g2)
endfunction     
    function IsItemInInventory4 takes unit u, integer it1 returns integer
        local integer i = 0
        local item ti
        local integer count = 0
        local integer count2 = 0
        local integer gold = 0
        loop
            set ti = UnitItemInSlot(u, i)
            exitwhen i > 5
            if GetItemTypeId(ti) == it1  then
                set count = count + 1
                if count > 1 then
                    if count2 == 0 then
                        call DisplayTimedTextToPlayer(GetOwningPlayer(u), 0, 0, 3, "|c00F20000You cant own more than 1 item of same type!|r")
                        set count2 = count2 + 1
                    endif
                    set gold = GetItemValue(GetItemTypeId(ti))
                    call AddGold(GetOwningPlayer(u),gold,true)
                    call UnitRemoveItem(u, ti)
                    call RemoveItem(ti)
                    set count = count - 1
                endif
            endif
            set i = i + 1
        endloop
        set ti = null
        return count
    endfunction    
      function IsItemInInventory42 takes unit u, integer it1, integer it2, integer it3 returns integer
        local integer i = 0
        local item ti
        local integer count = 0
        local integer count2 = 0
        local integer gold = 0
        loop
            set ti = UnitItemInSlot(u, i)
            exitwhen i > 5
            if GetItemTypeId(ti) == it1 or GetItemTypeId(ti) == it2 or GetItemTypeId(ti) == it3 then
                set count = count + 1
                if count > 1 then
                    if count2 == 0 then
                        call DisplayTimedTextToPlayer(GetOwningPlayer(u), 0, 0, 3, "|c00F20000You cant own more than 1 item of same type!|r")
                        set count2 = count2 + 1
                    endif
                    set gold = GetItemValue(GetItemTypeId(ti))
                    call AddGold(GetOwningPlayer(u),gold,true)
                    call UnitRemoveItem(u, ti)
                    call RemoveItem(ti)
                    set count = count - 1
                endif
            endif
            set i = i + 1
        endloop
        set ti = null
        return count
        endfunction
    function DebuffImmune_Start takes unit c, integer level returns integer
local integer k = level 
if GetUnitTypeId(c) == Rimuru_ID then 
if BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID) == 0 then 
set k = 0
call BJDebugMsg("S"+I2S(level))
if GetRandomInt(1,2) == 1 then 
call MakeSound("war3mapimported\\Hero_Rimuru_F")
else
call MakeSound("war3mapimported\\Hero_Rimuru_F2")
endif
call FakeCD_Start(c, RimuruF_ID, RimuruF_CD, 0, 0)
endif
endif
return k 
endfunction
     function BuffUnit01 takes unit c, unit u, integer id,string s, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local unit d = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(d, id)
            call SetUnitAbilityLevel(d, id, level)
            call SetUnitFacing(d, GAngle(d, u) * bj_RADTODEG)
            call IssueTargetOrder(d, s, u)
      call MyRemoveUnit(d,0.2)
      set d = null
    endfunction
    function SilenceUnit takes unit c, unit u, real time returns nothing // min 0.5 , max 5.0 sec
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = R2I(time / 0.5)
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A01V')
        endif
        if GetUnitAbilityLevel(u,'B00K')>0 then  // inori T virus
        set level = level +2
        endif
        if level < 1 then
            set level = 1
        elseif level > 10 then
            set level = 10
        endif
        if GetUnitAbilityLevel(u,'B00J')>0 then  // inori R immune
        set level = 0
        endif
        set level = DebuffImmune_Start(u,level)  
        if LoadInteger(hs,GetHandleId(u),StringHash("erza g2 active")) >0 and LoadInteger(hs,GetHandleId(u),StringHash("erza g2 type")) == 1 then
        set level = 0
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("naofumi shield")) == 1 then 
        set level = 0
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A01V') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A01V')
            endif
            
            call SetUnitAbilityLevel(DummyPlayer[i], 'A01V', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "drunkenhaze", u)
        endif
    endfunction
    function DecreaseArmorUnit takes unit c, unit u, integer level returns nothing // min 0.1 , max 3.0 sec
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A01H')
        endif
        if level < 1 then
            set level = 1
        elseif level > 30 then
            set level = 30
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A01H') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A01H')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A01H', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "faeriefire", u)
        endif
    endfunction
    function StunUnit takes unit c, unit u, real time returns nothing // min 0.1 , max 3.0 sec
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = R2I(time * 10 )
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1OA')
        endif
        if GetUnitAbilityLevel(u,'B00K')>0 then  // inori T virus
        set level = level +2
        endif
        if level < 1 then
            set level = 1
        elseif level > 30 then
            set level = 30
        endif
        set level = DebuffImmune_Start(u,level)  
        if GetUnitAbilityLevel(u,'B00J')>0 then  // inori R immune
        set level = 0
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("naofumi shield")) == 1 then 
        set level = 0
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("erza g2 active")) >0 and LoadInteger(hs,GetHandleId(u),StringHash("erza g2 type")) == 1 then
        set level = 0
        endif
        if IsItemInInventory(u,'I00L') >0 and BlzGetUnitAbilityCooldownRemaining(u,'A01D')==0 then // IntegerCd(u,"witch sin cd",25) then
        set level = 0
        call DebuffClear(u)
        call UnitAddAbility(u,'A019')
        call MyRemoveAbility(u,5,'A019',1)
        call BuffUnit01(u,u,'A01E',"innerfire",1)
        //call BlzSetItemBooleanField(UnitItemInSlot(u,IsItemInInventory3(u,'I00L')),ITEM_BF_ACTIVELY_USED,true)
        call BlzStartUnitAbilityCooldown(u,'A01D',25)
        //call BlzSetItemBooleanField(UnitItemInSlot(u,IsItemInInventory3(u,'I00L')),ITEM_BF_ACTIVELY_USED,false)
        call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_[tx]_sishu_d.mdl",u,"origin"),5)
        endif
        if GetUnitTypeId(u) == Erza_ID and GetHeroLevel(u)>=12 then 
        if GetHeroLevel(u)>=35 then
        set level= level - 5
        elseif GetHeroLevel(u)>=24 then
        set level= level - 4
        else
        set level= level - 3
        endif
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A1OA') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A1OA')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A1OA', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "thunderbolt", u)
        endif
    endfunction
    function DoomUnit takes unit c, unit u, real time returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = R2I(time / 0.5)
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1QY')
        endif
        if level < 1 then
            set level = 1
        elseif level > 30 then
            set level = 30
        endif
        set level = DebuffImmune_Start(u,level)  
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A1QY') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A1QY')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A1QY', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "doom", u)
        endif
    endfunction
    function RootUnit takes unit c, unit u, real time returns nothing // min 0.5 , max 5.0 sec
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = R2I(time / 0.5)
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'APPP')
        endif
        if GetUnitAbilityLevel(u,'B00K')>0 then  // inori T virus
        set level = level +2
        endif
        if level < 1 then
            set level = 1
        elseif level > 30 then
            set level = 30
        endif
        set level = DebuffImmune_Start(u,level)  
        if GetUnitAbilityLevel(u,'B00J')>0 then  // inori R immune
        set level = 0
        endif
        if IsItemInInventory(u,'I020') >0 and BlzGetUnitAbilityCooldownRemaining(u,'A09U')==0 then // IntegerCd(u,"witch sin cd",25) then
        set level = 0        
        call DebuffClear(u)
        call SetHpCurrent2(c,c,350)
        call BlzStartUnitAbilityCooldown(u,'A09U',25)
        call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_[tx]_sishu_d.mdl",u,"origin"),5)
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("erza g2 active")) >0 and LoadInteger(hs,GetHandleId(u),StringHash("erza g2 type")) == 1 then
        set level = 0
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("naofumi shield")) == 1 then 
        set level = 0
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'APPP') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'APPP')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'APPP', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "entanglingroots", u)
        endif
    endfunction
    function GetSlowAbilityLevel takes integer slowPercent, integer duration returns integer
        local integer baseIndex = (slowPercent - 10) / 10
        local integer levelGroupStart = baseIndex * 3 + 1
        local integer durationOffset = duration - 2
        return levelGroupStart + durationOffset
    endfunction
    function SlowUnit takes unit c, unit u, integer percent, integer time returns nothing // percent - from 10 to 80( all percentage, example 10, 20, 30, 40, 50, 60, 70, 80), time choose prefered time 2, 3, 4 sec only
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = GetSlowAbilityLevel(percent, time)
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1OT')
        endif
        if GetUnitAbilityLevel(u,'B00K')>0 then  // inori T virus
        set level = level +3
        endif
        if level < 1 then
            set level = 1
        elseif level > 24 then
            set level = 24
        endif
        set level = DebuffImmune_Start(u,level)  
        if GetUnitAbilityLevel(u,'B00J')>0 then  // inori R immune
        set level = 0
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("erza g2 active")) > 0 and LoadInteger(hs,GetHandleId(u),StringHash("erza g2 type")) == 1 then
        set level = 0
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("naofumi shield")) == 1 then 
        set level = 0
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A1OT') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A1OT')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A1OT', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "slow", u)
        endif
    endfunction
    function CurseUnit takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1OB')
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("erza g2 active")) >0 and LoadInteger(hs,GetHandleId(u),StringHash("erza g2 type")) == 1 then
        set level = 0
        endif
        
        if LoadInteger(hs,GetHandleId(u),StringHash("naofumi shield")) == 1 then 
        set level = 0
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A1OB') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A1OB')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A1OB', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "curse", u)
        endif
    endfunction
    function CurseUnit2 takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer3[i] == null or GetWidgetLife(DummyPlayer3[i]) < 1 then
            set DummyPlayer3[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer3[i], 'A07L')
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("erza g2 active")) >0 and LoadInteger(hs,GetHandleId(u),StringHash("erza g2 type")) == 1 then
        set level = 0
        endif
        if LoadInteger(hs,GetHandleId(u),StringHash("naofumi shield")) == 1 then 
        set level = 0
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer3[i], 'A07L') == 0 then
                call UnitAddAbility(DummyPlayer3[i], 'A07L')
            endif
            call SetUnitAbilityLevel(DummyPlayer3[i], 'A07L', level)
            call SetUnitFacing(DummyPlayer3[i], GAngle(DummyPlayer3[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer3[i], "curse", u)
        endif
    endfunction
    function BuffUnit1 takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1P1')
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A1P1') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A1P1')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A1P1', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "innerfire", u)
        endif
    endfunction
    function BuffUnit2 takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer3[i] == null or GetWidgetLife(DummyPlayer3[i]) < 1 then
            set DummyPlayer3[i] = CreateUnit( Player(  i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer3[i], 'A07D')
        endif
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer3[i], 'A07D') == 0 then
                call UnitAddAbility(DummyPlayer3[i], 'A07D')
            endif
            call SetUnitAbilityLevel(DummyPlayer3[i], 'A07D', level)
            call SetUnitFacing(DummyPlayer3[i], GAngle(DummyPlayer3[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer3[i], "innerfire", u)
        endif
    endfunction
function BlinkEff takes unit c returns nothing
call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), GetUnitFacing(c), 1, 1.8, GetUnitFlyHeight(c)))
endfunction
function BlinkEff2 takes unit c returns nothing
call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), GetUnitFacing(c)+90, 3, 1, GetUnitFlyHeight(c), 0, 0, 0, 125))
endfunction
private function Sign takes real px, real py, real ax, real ay, real bx, real by returns real
    return (px - bx)*(ay - by) - (ax - bx)*(py - by)
endfunction
private function PointInTriangle takes real px, real py, real ax, real ay, real bx, real by, real cx, real cy returns boolean
    local real s1 = Sign(px, py, ax, ay, bx, by)
    local real s2 = Sign(px, py, bx, by, cx, cy)
    local real s3 = Sign(px, py, cx, cy, ax, ay)
    return (s1 >= 0 and s2 >= 0 and s3 >= 0) or (s1 <= 0 and s2 <= 0 and s3 <= 0)
endfunction
function PlayerMsg takes string s, real r returns nothing
local integer i = 0
loop
exitwhen i == 10 
call DisplayTimedTextToPlayer(Player(i),0,0,r,s)
set i = i + 1
endloop
endfunction
function DamageTriangle takes unit c, real ax, real ay, real bx, real by, real cx, real cy, real dmg, integer dmgtype  returns nothing
    local group g = CreateGroup()
    local unit u
    local real minx = RMinBJ(ax, RMinBJ(bx, cx))
    local real maxx = RMaxBJ(ax, RMaxBJ(bx, cx))
    local real miny = RMinBJ(ay, RMinBJ(by, cy))
    local real maxy = RMaxBJ(ay, RMaxBJ(by, cy))
    set REC = Rect(minx, miny, maxx, maxy)
    call GroupEnumUnitsInRect(g, REC,  Condition(function NoDecor_Filter))
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        call GroupRemoveUnit(g, u)
        if SpellBool(u) and PointInTriangle(GetUnitX(u), GetUnitY(u), ax, ay, bx, by, cx, cy) and IsUnitEnemy(u,GetOwningPlayer(c)) then
        if dmgtype == 1 then 
        call dmgmag(c,u,dmg)
        elseif dmgtype == 0 then 
        call dmgphys(c,u,dmg)
        elseif dmgtype == 2 then 
        call dmgatk(c,u,dmg)
        elseif dmgtype == 3 then 
        call dmgmag(c,u,dmg)
        call SlowUnit(c,u,KenjakuE_SlowPercent,KenjakuE_SlowTime)
        endif
        endif
    endloop
    call DestroyGroup(g)
endfunction
//=====================================================DMG SYSY====================================================================
function DamageBlock takes unit c, unit td, real dmg,integer typedmg, boolean test returns real
local real dmgbase = dmg 
local real d1 = 0
local integer k = 0
local real def =0
local real rr = 0
if GetUnitTypeId(td) == Erza_ID and LoadInteger(hs, GetHandleId(td), StringHash("t armor active")) == 1 and HasShieldPen(c, td) == false then
//set dmg = dmg - (dmg * (ErzaT_ArmorStatResistance / 100))
endif
if dmg> 2 and (typedmg == 2 or typedmg == 1) and  IsItemInInventory(td,'I013') > 0 then 
if GetUnitAbilityLevel(td,'B00U') == 1 then 
set k = 6
elseif GetUnitAbilityLevel(td,'B00Q') == 1 then 
set k = 6 
call UnitRemoveAbility(td,'B00Q')
elseif GetUnitAbilityLevel(td,'B00P') == 1 then
set k = 5 
call UnitRemoveAbility(td,'B00P')
elseif GetUnitAbilityLevel(td,'B00O') == 1 then
set k = 4 
call UnitRemoveAbility(td,'B00O')
elseif GetUnitAbilityLevel(td,'B00N') == 1 then
set k = 3 
call UnitRemoveAbility(td,'B00N')
elseif GetUnitAbilityLevel(td,'B00M') == 1 then
set k = 2
call UnitRemoveAbility(td,'B00M')
else
set k = 1
endif
call BuffUnit2(td,td,k)
endif
set k = 0
if GetUnitTypeId(td) == Takeshi_ID and LoadInteger(hs, GetHandleId(td), StringHash("mode g"))==1 then 
set dmg = dmg * (0.85)
endif
if IsItemInInventory(td,'I00B') >0 then 
if test == false then
call HPS(td,td,dmg*0.12,10)
endif
set dmg = dmg * (0.93)
endif
if typedmg != 1 then
set def = BlzGetUnitArmor(td)/100
if def< 0 then 
set def = 0
endif
set dmg = dmg * (1 / (1 + def))
if LoadReal(hs,GetHandleId(td),StringHash("phys res"))>0 then 
set d1 = LoadReal(hs,GetHandleId(td),StringHash("phys res"))
if d1>1 then 
set d1 = 1
endif
set dmg = dmg * (1-d1)
endif
if LoadInteger(hs,GetHandleId(td),StringHash("blue emperor res")) == 1 then 
set dmg = dmg *(0.75)
endif
if dmg>=200 and IsItemInInventory(td,'I00X') > 0 and BlzGetUnitAbilityCooldownRemaining(td,'A04Q')==0 then
if test == false then
set dmg = dmg *(0.7)
call SaveInteger(hs,GetHandleId(td),StringHash("blue emperor res"),1)
call MyFlush(GetHandleId(td),StringHash("blue emperor res"),0,5)
call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_sacred guard blue.mdl",td,"chest"),5)
call BlzStartUnitAbilityCooldown(td,'A04Q',25)
endif
endif
if GetUnitTypeId(td) == KenjakuE2_Dummy_ID and GetUnitAbilityLevel(Hero[GetPlayerId(GetOwningPlayer(td))],KenjakuE_ID)>=5 then 
set dmg = dmg *(1 / (1 + 0.35))
endif
if GetUnitTypeId(td) == KenjakuQ2_Dummy_ID and GetUnitAbilityLevel(Hero[GetPlayerId(GetOwningPlayer(td))],KenjakuQ_ID)>=5 then 
set dmg = dmg *(1 / (1 + 0.35))
endif
if Akainu_ID == GetUnitTypeId(td)  and GetHeroLevel(td)>= 12 then 
set dmg = dmg * 0.85
endif
if (GetUnitAbilityLevel(td,'B002') >0 or GetUnitAbilityLevel(td,'B00S') >0)  and dmg <dmgbase then
set d1 = (dmg/dmgbase)
set rr = 0.1
if d1>= 1-rr then 
set dmg = dmgbase
else
set dmg = dmgbase* (d1+rr)
endif
endif
endif
if typedmg == 1 then
if GetUnitAbilityLevel(td,'B00U') == 1 then 
set dmg = dmg * 0.82 
elseif GetUnitAbilityLevel(td,'B00Q') == 1 then 
set dmg = dmg * 0.85 
elseif GetUnitAbilityLevel(td,'B00P') == 1 then
set dmg = dmg * 0.88
elseif GetUnitAbilityLevel(td,'B00O') == 1 then
set dmg = dmg * 0.91
elseif GetUnitAbilityLevel(td,'B00N') == 1 then
set dmg = dmg * 0.94
elseif GetUnitAbilityLevel(td,'B00M') == 1 then
set dmg = dmg * 0.97
endif
if LoadReal(hs,GetHandleId(td),StringHash("mag res"))>0 then 
set d1 = LoadReal(hs,GetHandleId(td),StringHash("mag res"))
if d1>1 then 
set d1 = 1
endif
set dmg = dmg * (1-d1)
endif
if GetHeroLevel(td) >= 35 then 
set dmg = dmg * 0.9
elseif GetHeroLevel(td) >= 24 then
set dmg = dmg * 0.9333
elseif GetHeroLevel(td) >= 12 then
set dmg = dmg * 0.9666
endif
if GetUnitAbilityLevel(td,InoriE_Aura_ID) > 0 then 
set dmg = dmg * (1-(InoriE_DmgMagResistFromPas/100))
endif
if GetUnitTypeId(td) == KenjakuE2_Dummy_ID and GetUnitAbilityLevel(Hero[GetPlayerId(GetOwningPlayer(td))],KenjakuE_ID)>=5 then 
set dmg = dmg * 0.65
endif
if GetUnitTypeId(td) == KenjakuW2_Dummy_ID and GetUnitAbilityLevel(Hero[GetPlayerId(GetOwningPlayer(td))],KenjakuW_ID)>=5 then 
set dmg = dmg * 0.65
endif
if GetUnitAbilityLevel(c,'B00E') >0 then
set dmg = dmg * 0.65
endif
if GetUnitAbilityLevel(td,'B00C') >0 then
set dmg = dmg * 0.6
endif
if GetUnitTypeId(td) == Natsu_ID and GetUnitCurrentOrder(td)== OrderId("creepheal") then 
set dmg = dmg * 0.75
endif
if IsItemInInventory(td,'I00K') >0 then
set dmg = dmg * 0.9
endif
if IsItemInInventory(td,'I00L') >0 then
set dmg = dmg * 0.85
endif
if IsItemInInventory(td,'I020') >0 then
set dmg = dmg * 0.82
endif
if GetUnitAbilityLevel(td,'A019') >0 then
set dmg = dmg * 0.85
endif
if GetUnitAbilityLevel(td,'B003') >0 or GetUnitAbilityLevel(td,'B00R') >0  and dmg <dmgbase then
set d1 = (dmg/dmgbase)
set rr = 0.1
if d1>= 1-rr then 
set dmg = dmgbase
else
set dmg = dmgbase* (d1+rr)
endif
endif

endif
if GetUnitTypeId(td) == Erza_ID and LoadInteger(hs,GetHandleId(td),StringHash("erza g2 type")) >0 and LoadInteger(hs,GetHandleId(td),StringHash("erza g2 active")) >0 then
if LoadInteger(hs,GetHandleId(td),StringHash("erza g2 type")) == 1 and typedmg == 1 then 
set dmg = dmg * ((100-Erza6_MagicalDmgResist)/100)
endif
if LoadInteger(hs,GetHandleId(td),StringHash("erza g2 type")) == 2 and typedmg != 1 then 
set dmg = dmg * ((100-Erza7_PhysicalDmgResist)/100)
endif
endif
if GetUnitTypeId(td) == Tomioka_ID and LoadInteger(hs, GetHandleId(GetOwningPlayer(td)), StringHash("tomioka f invul")) == 1 then
if test == false then
set dmg = LustSin(c,td,dmg)
call SaveInteger(hs, GetHandleId(td), StringHash("tomioka f dmg act"), 1)
else
set dmg = 0
endif
endif
if IsItemInInventory(td,'I00M') >0 and BlzGetUnitAbilityCooldownRemaining(td,'A01W')==0 and LoadInteger(hs, GetHandleId(GetOwningPlayer(td)), StringHash("zero kai")) == 0 and dmg>=GetItemCharges(UnitItemInSlot(td,IsItemInInventory3(td,'I00M')))  then
set dmg = LustSin(c,td,dmg)
if test == false then
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_teaeff.mdl",td,"chest"))
call BlzStartUnitAbilityCooldown(td,'A01W',CupOfTea_CD)
call UnitRemoveAbility(td,'A07Q')
call MyRemoveAbility(td,CupOfTea_CD,'A07Q',0)
endif
endif


return dmg
endfunction
function GetPhysRes takes unit c returns real
local real result = 0
local real check = 0
set check = 1-DamageBlock(null,c,1.00,2,true)
set result = (check) * 100
 return result
endfunction
function GetMagRes takes unit c returns real
local real result = 0
local real check = 0
set check = 1-DamageBlock(null,c,1.00,1,true)
set result = (check) * 100
 return result
endfunction
function DamageCheck takes unit c, unit td, real dmg,integer typedmg returns real
local real x = GetUnitX(td)
local real y = GetUnitY(td)
local real a
local integer i
local real dmg2

if typedmg == 2 then
if IsItemInInventory(c,'I010') >0 and BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 3 then
set dmg = dmg * 1.09
endif
if IsItemInInventory(c,'I01C') >0 then
set dmg = dmg * 1.09
endif
if IsItemInInventory(c,'I00T') >0 then
set dmg = dmg * 1.14
endif
endif
if typedmg == 0 or typedmg == 2 then
if GetUnitAbilityLevel(td,ErzaWape_ID)>0 then 
set dmg = dmg + (dmg * (ErzaWape_IncreaseDmg/100))
endif
endif
if typedmg == 1 then 
if IsItemInInventory(c,'I01C') >0 and BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
set dmg = dmg * 1.09
endif
if IsItemInInventory(c,'I01B') >0 then
set dmg = dmg * 1.14
endif
if IsItemInInventory(c,'I010') >0 then
set dmg = dmg * 1.09
endif
endif
if (GetUnitAbilityLevel(td,'B009')>0 or GetUnitAbilityLevel(td,'B007')>0 or GetUnitAbilityLevel(td,'B00B')>0) and  GetUnitTypeId(c) == Neuvillette_ID  then 
if GetHeroLevel(c)>= 35 then 
set dmg2 = (1+((NeuvilletteF_DamageAdd+NeuvilletteF_DamageAdd35)/100))
else
set dmg2 = (1+(NeuvilletteF_DamageAdd/100))
endif
set dmg = dmg * (1+(NeuvilletteF_DamageAdd/100))
endif 
return dmg 
endfunction

function FixAura2 takes unit c returns nothing
local integer i = GetPlayerId(GetOwningPlayer(c))
local integer id = 0
local integer k = 0
if c != Hero[i] then 
if AttachDonat1[i] != null or AttachDonat2[i] != null or AttachDonat3[i] != null or AttachDonat4[i] != null then 
if AttachDonat1[i] != null then 
set k = 1 
elseif AttachDonat2[i] != null then
set k = 2 
elseif AttachDonat3[i] != null then
set k = 3
elseif AttachDonat4[i] != null then
set k = 4
endif
 if k == 0 then
            return  // hero has nothing active, illusion gets nothing
        endif
if k == 1 then 
if VIPCheckLvl2(FramePlayerFirstName[i]) or VIPCheckLvl3(FramePlayerFirstName[i]) then
set id = LoadInteger(hs,GetHandleId(Player(i)),StringHash("donat up"))-1
if id == -1 then 
set id = 1
endif
if id == 0 then 
call AddSpecialEffectTarget("war3mapimported\\wos_scghmx (6).mdx",c,"origin")
elseif id == 1 then 
call AddSpecialEffectTarget("war3mapimported\\wos_scghmx (9).mdx",c,"origin")
endif
elseif VIPCheckLvl1(FramePlayerFirstName[i]) then
call  AddSpecialEffectTarget("war3mapImported\\wos_scghmx (9).mdl",c,"origin")
endif
elseif k == 2 then 
if VIPCheckLvl3(FramePlayerFirstName[i]) then
set id = LoadInteger(hs,GetHandleId(Player(i)),StringHash("donat left"))-1
if id == -1 then 
set id = 3
endif
if id == 0 then 
call AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san01.mdx",c,"origin")
elseif id == 1 then 
call  AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san02.mdx",c,"origin")
elseif id == 2 then 
call  AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san03.mdx",c,"origin")
elseif id == 3 then 
call  AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san04.mdx",c,"origin")
endif
elseif VIPCheckLvl2(FramePlayerFirstName[i])  then
call  AddSpecialEffectTarget("war3mapImported\\wos_scghmx (6).mdl",c,"origin")
endif
elseif k == 3 then 


if VIPCheckLvl3(FramePlayerFirstName[i])  then
set id = LoadInteger(hs,GetHandleId(Player(i)),StringHash("donat right"))-1
if id == -1 then 
set id = 4
endif
if id == 0 then 
call AddSpecialEffectTarget("war3mapImported\\wos_ncow_sfx_sharingan3tomoe.mdx",c,"origin")
elseif id == 1 then 
call AddSpecialEffectTarget("war3mapimported\\wos_sharin_mad.mdx",c,"origin")
elseif id == 2 then 
call AddSpecialEffectTarget("war3mapimported\\wos_sharin_ita.mdx",c,"origin")
elseif id == 3 then 
call AddSpecialEffectTarget("war3mapimported\\wos_sharin_sas.mdx",c,"origin")
elseif id == 4 then 
call AddSpecialEffectTarget("war3mapimported\\wos_sharin_kak.mdx",c,"origin")
endif
else
call AddSpecialEffectTarget("war3mapImported\\wos_ncow_sfx_sharingan3tomoe.mdx",c,"origin")
endif
elseif k == 4 then 
call  AddSpecialEffectTarget("war3mapImported\\wos_raidensymbol.mdx",c,"origin")
endif
endif

else
if AttachDonat1[i] != null or AttachDonat2[i] != null or AttachDonat3[i] != null or AttachDonat4[i] != null then 
if AttachDonat1[i] != null then 
set k = 1 
elseif AttachDonat2[i] != null then
set k = 2 
elseif AttachDonat3[i] != null then
set k = 3
elseif AttachDonat4[i] != null then
set k = 4
endif
 if k == 0 then
return  // hero has nothing active, illusion gets nothing
endif
call DestroyEffect(AttachDonat1[i])
call DestroyEffect(AttachDonat2[i])
call DestroyEffect(AttachDonat3[i])
call DestroyEffect(AttachDonat4[i])
set AttachDonat1[i] = null
set AttachDonat2[i] = null
set AttachDonat3[i] = null
set AttachDonat4[i] = null
if k == 1 then 
if VIPCheckLvl2(FramePlayerFirstName[i]) or VIPCheckLvl3(FramePlayerFirstName[i]) then
set id = LoadInteger(hs,GetHandleId(Player(i)),StringHash("donat up"))-1
if id == 0 then 
set AttachDonat1[i] = AddSpecialEffectTarget("war3mapimported\\wos_scghmx (6).mdx",Hero[i],"origin")
elseif id == 1 then 
set AttachDonat1[i] = AddSpecialEffectTarget("war3mapimported\\wos_scghmx (9).mdx",Hero[i],"origin")
endif
elseif VIPCheckLvl1(FramePlayerFirstName[i]) then
set AttachDonat1[i] = AddSpecialEffectTarget("war3mapImported\\wos_scghmx (9).mdl",Hero[i],"origin")
endif
elseif k == 2 then 
if VIPCheckLvl3(FramePlayerFirstName[i]) then
set id = LoadInteger(hs,GetHandleId(Player(i)),StringHash("donat left"))-1
if id == -1 then 
set id = 3
endif
if id == 0 then 
set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san01.mdx",Hero[i],"origin")
elseif id == 1 then 
set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san02.mdx",Hero[i],"origin")
elseif id == 2 then 
set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san03.mdx",Hero[i],"origin")
elseif id == 3 then 
set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san04.mdx",Hero[i],"origin")
endif
elseif VIPCheckLvl2(FramePlayerFirstName[i])  then
set AttachDonat2[i] = AddSpecialEffectTarget("war3mapImported\\wos_scghmx (6).mdl",Hero[i],"origin")
endif
elseif k == 3 then 
set AttachDonat3[i] = AddSpecialEffectTarget("war3mapImported\\wos_ncow_sfx_sharingan3tomoe.mdx",Hero[i],"origin")
elseif k == 4 then 
set AttachDonat4[i] = AddSpecialEffectTarget("war3mapImported\\wos_raidensymbol.mdx",Hero[i],"origin")
endif
endif
endif
endfunction
function SetIllusionColor takes unit illusion, player owner returns nothing
    local integer i = 0
    loop
        exitwhen i > 11
        if GetLocalPlayer() == Player(i) then
            if Player(i) == owner or IsPlayerAlly(Player(i), owner) then
                call SetUnitVertexColor(illusion, 100, 200, 255, 100)
            else
                call SetUnitVertexColor(illusion, 255, 255, 255, 255)
            endif
        endif
        set i = i + 1
    endloop
endfunction
function FixHeroPas takes unit c returns nothing
    local integer id = GetUnitTypeId(c)
    local effect e
    local integer i = GetPlayerId(GetOwningPlayer(c))
    local integer check = 0
    local real x = GetUnitX(c)
    local real y = GetUnitY(c)
    local unit u = Hero[i]
    if u != null then 
    if id == Okarun_ID and GetHeroLevel(u) >= 6 then
        call AddSpecialEffectTarget("war3mapimported\\wos_windwalk blood.mdx", c, "origin")
    elseif id == Inori_ID and GetHeroLevel(u) >= 6 then
    if LoadInteger(hs, GetHandleId(u), StringHash("mode t")) == 0 then 
    if LoadInteger(hs, GetHandleId(u), StringHash("Inori E Active")) == 0 then 
        set e = AddSpecialEffectTarget("war3mapImported\\wos_Inori_Bar.mdl", c, "origin")
        set check = LoadInteger(hs, GetHandleId(u), StringHash("Inori E"))
        if check == 0 then
            call BlzPlaySpecialEffect(e, ANIM_TYPE_DEATH)
        elseif check == 1 then
            call BlzPlaySpecialEffect(e, ANIM_TYPE_ATTACK)
        elseif check == 2 then
            call BlzPlaySpecialEffect(e, ANIM_TYPE_DECAY)
        elseif check == 3 then
            call BlzPlaySpecialEffect(e, ANIM_TYPE_DISSIPATE)
        elseif check == 4 then
            call BlzPlaySpecialEffect(e, ANIM_TYPE_MORPH)
        endif
        else
       call AddSpecialEffectTarget("war3mapimported\\Wos_InoriCrystall_atch.mdx", c, "hand right")
       call AddSpecialEffectTarget("war3mapimported\\Wos_InoriCrystall_atch.mdx", c, "hand left")
        endif
        else
       call AddSpecialEffectTarget("war3mapImported\\wos_file00002900.mdl", c, "origin")
        endif    
    elseif id == AlterSaber_ID then
    if LoadInteger(hs, GetHandleId(u), StringHash("saber w")) == 1 then
    call AddSpecialEffectTarget("war3mapImported\\wos_saber_attach.mdl", c, "weapon")
    endif
    if LoadInteger(hs, GetHandleId(u), StringHash("mode r")) == 1 then  
   call AddSpecialEffectTarget("war3mapImported\\wos_BDEF (2313).mdx", c, "origin")
    endif
    elseif id == Tsuna_ID and LoadInteger(hs, GetHandleId(u), StringHash("mode g")) == 1 then    
        call AddSpecialEffectTarget("war3mapImported\\wos_tsunaaura.mdl", c, "origin")
    elseif id == Raiden_ID and LoadInteger(hs, GetHandleId(u), StringHash("raiden t")) == 1 then
        call AddSpecialEffectTarget("war3mapImported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdl", c, "origin")
        call AddUnitAnimationProperties(c, "alternate", true)
    elseif id == Natsu_ID then
        if LoadInteger(hs, GetHandleId(u), StringHash("mode g")) == 1 then
        call EUTU2(EffectSpawn("war3mapImported\\wos_Raienryuu no Houkou.mdl", x, y, 1, 1, 1.35, 125),15,125,c)
        call EUTU2(EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, 1, 0.35, 0.5, 15),15,15,c)
        call EUTU2(EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, 90, 0.35, 0.4, 125),125,1,c)
          //  call AddSpecialEffectTarget("war3mapImported\\wos_Raienryuu no Houkou.mdl", c, "origin")
         //   call AddSpecialEffectTarget("war3mapImported\\wos_lb_hg2-E12B5.mdl", c, "origin")
          //  call AddSpecialEffectTarget("war3mapImported\\wos_lb_hg2-E12B5.mdl", c, "chest")
        endif
        if GetUnitAbilityLevel(u, NatsuF_Stats_ID) > 0 then
            call AddSpecialEffectTarget("war3mapImported\\wos_by_wood_effect_order_dange_dbz_chaosaiguanghuan_1_3.mdl", c, "origin")
        endif
        elseif id == Erza_ID then 
         if  LoadInteger(hs, GetHandleId(u), StringHash("q armor active")) == 1 then
                    if LoadInteger(hs, GetHandleId(u), StringHash("fire armor pas")) == 1  then
                        call AddSpecialEffectTarget("war3mapImported\\wos_buff_fire_big2.mdx", c, "weapon")
                        endif
                        endif
    elseif id == Gojo_ID and LoadInteger(hs, GetHandleId(u), StringHash("gojo e")) == 1 then
        if GetUnitAbilityLevel(u, GojoE_ID) >= 3 then
            call EUTU2(EffectSpawn("war3mapimported\\wos_obr08 (479).mdl", x, y, GetRandomReal(0, 359), 0.5, 1.55, 1),15,3,c)
        endif
        call AddSpecialEffectTarget("war3mapimported\\wos_GojoEye1.mdl", c, "origin")
            
    elseif id == Tomioka_ID and LoadInteger(hs, GetHandleId(u), StringHash("tomioka add dmg")) == 1 then
        call AddSpecialEffectTarget("war3mapImported\\wos_aurapartblue.mdl", c, "origin")
    endif
    endif
    set u = null
    set e = null
endfunction
function FixModel takes unit c returns nothing
local integer i = GetPlayerId(GetOwningPlayer(c))
local integer id = 0
local integer k = 0
local group g = CreateGroup()
local real x = GetUnitX(c)
local real y = GetUnitY(c)
local integer k1 = BlzGetUnitSkin(c)
local integer k2
local unit u = null
                            call GroupEnumUnitsInRange( g ,x,y , 1000 , Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if GetOwningPlayer( c ) == GetOwningPlayer(u) then 
                                if c != u and IsUnitIllusion(u) and GetUnitUserData(u)!= 100 and GetUnitTypeId(c) == GetUnitTypeId(u)  then
                               // call SetUnitUserData(u,100)
                               set k2 = BlzGetUnitSkin(u)
                               call BlzSetUnitSkin(u,BlzGetUnitSkin(c))
                                call SetIllusionColor(u,GetOwningPlayer(c))
                                call FixAura2(u)
                                call FixHeroPas(u)
                                else
                                if c != u then 
                                if IsUnitIllusion(u) == false then 
                                endif
                                if GetUnitUserData(u)== 100 then 
                                endif
                                if GetUnitTypeId(c) != GetUnitTypeId(u) then 
                                endif
                                if GetOwningPlayer( c ) != GetOwningPlayer(u) then 
                                endif
                                endif
                                endif
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            call DestroyGroup(g)
                            set g = null
endfunction
function FixAura takes unit c returns nothing
local integer i = GetPlayerId(GetOwningPlayer(c))
local integer id = 0
call FixAura2(c)
call FixModel(c)
endfunction
//================================================================================================================================
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com

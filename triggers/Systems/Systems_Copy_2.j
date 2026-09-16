library GearSystems initializer Init
globals
    framehandle array FrameCD_Icon
    framehandle array FrameCD_Cooldown
    unit       array FrameCD_Unit
    integer    array FrameCD_AbilId

    integer array SlotPosX
    integer array SlotPosY
integer ItemProcDamageDepth = 0
    timer AllyCD_Timer = CreateTimer()

endglobals

globals
    group TransformCloneEnumGroup = CreateGroup()
    boolexpr TransformCloneFilterExpr = null
    unit TransformFilterHero = null
    integer TransformFilterHeroId = 0
endglobals

globals
    // UTF-8: complete Russian and Ukrainian alphabets, upper- and lowercase.
    string PlayerNameCyrillic = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯЄІЇҐабвгдеёжзийклмнопрстуфхцчшщъыьэюяєіїґ"
endglobals
globals
    timer GearTimer03
    timer GearTimer05
    timer GearTimer10
    code GearTimer03Callback
    code GearTimer05Callback
    code GearTimer10Callback
    integer GearTimer03Users
    integer GearTimer05Users
    integer GearTimer10Users
endglobals
    globals
        hashtable hs = InitHashtable()
        unit array DummyPlayer
        unit array DummyPlayer2
        unit array DummyPlayer3
        unit array DummyDebuff1
        boolean ShowDmgTestText = true
        rect dummyrect 
        real decordmg
        unit decorunit
        boolexpr NoDecor_Cond
        effect array DBGEFFCLONE 
        integer array level_id
        integer Fire_ID = 'h008'
        integer FakeAbi_ID = 'A06H'
        integer FakeAbi2_ID = 'A01S'
        integer DummyE_ID = 'h00E'
        integer DummyR_ID = 'h00D'
        real decor_x 
        real decor_y 
        real decor_aoe 
        real str_hpregen = 0.2
        real int_mpregen = 0.2    
        real agi_as = 0.007 
        real agi_ms = 0.75 
        real agi_def = 0.1
        real armor_resist = 0

        // Глобальная эффективность брони в процентах.
        // Менять силу всей брони в карте нужно только здесь:
        //   100.0 = текущая эффективность: 1 броня даёт +1% физического эффективного здоровья;
        //   125.0 = броня на 25% сильнее: 1 броня даёт +1.25% физического эффективного здоровья;
        //    75.0 = броня на 25% слабее: 1 броня даёт +0.75% физического эффективного здоровья;
        //     0.0 = броня не уменьшает физический урон.
        // Рекомендуемый диапазон для баланса: 75.0-150.0. Отрицательное значение ниже
        // безопасно считается как 0.0. Значения выше 200.0 делают броню очень сильной.
        // Ориентир для 21.1 брони (6.1 базовой + бафф 15):
        //   100.0 = 17.42% физического сопротивления;
        //   125.0 = 20.87% физического сопротивления;
        //   150.0 = 24.04% физического сопротивления.
        real ARMOR_EFFECTIVENESS_PERCENT = 105.0

        integer LetterCheck = 7
        rect REC     
       
        string array PlayerColor
    endglobals
    globals
    integer array HeroShopRegistry
    integer array HeroPickPage
    integer array HeroPickSlot
    integer HeroShopCount = 0
    boolean HeroShopRegistryReady = false
endglobals
   function HideBottomUI takes player p, boolean b returns nothing
    if GetLocalPlayer() == p then
    call BlzHideOriginFrames(b)
    endif
    if b == false then 
    
    endif
endfunction
function HideUIExceptTopMenu takes player p, boolean b returns nothing
    if GetLocalPlayer() == p then
        // Скрывает или возвращает стандартный интерфейс.
        call BlzHideOriginFrames(b)

        // Верхняя панель с кнопками меню остаётся видимой.
        call BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarMenuButton", 0), true)
    endif
endfunction
function GetStr takes unit c returns integer
local integer i
local integer id = GetPlayerId(GetOwningPlayer(c))
if c != Hero[id] then 
set i = GetHeroStr(Hero[id],true)
else
set i = GetHeroStr(c,true)
endif
return i
endfunction 
function GetAgi takes unit c returns integer
local integer i
local integer id = GetPlayerId(GetOwningPlayer(c))
if c != Hero[id] then 
set i = GetHeroAgi(Hero[id],true)
else
set i = GetHeroAgi(c,true)
endif
return i
endfunction 
function GetInt takes unit c returns integer
local integer i
local integer id = GetPlayerId(GetOwningPlayer(c))
if c != Hero[id] then 
set i = GetHeroInt(Hero[id],true)
else
set i = GetHeroInt(c,true)
endif
return i
endfunction 
function ConvertBTNtoDISBTN takes string path returns string
        local integer len = StringLength(path)
        local integer i = len - 1
        local string name = ""
    // Р СњР В°РЎвЂ¦Р С•Р Т‘Р С‘Р С Р С—Р С•РЎРѓР В»Р ВµР Т‘Р Р…Р С‘Р в„– РЎРѓР В»РЎРЊРЎв‚¬ '\'
        loop
            exitwhen i < 0 or SubString(path, i, i + 1) == "\\"
            set i = i - 1
        endloop
        if i >= 0 then
            set name = SubString(path, i + 1, len) // Р С‘Р СРЎРЏ РЎвЂћР В°Р в„–Р В»Р В° (Р Р…Р В°Р С—РЎР‚Р С‘Р СР ВµРЎР‚ "BTNAttack" Р С‘Р В»Р С‘ "DISBTNAttack")
        else
            set name = path
        endif
    // Р вЂўРЎРѓР В»Р С‘ Р С‘Р СРЎРЏ РЎС“Р В¶Р Вµ Р Р…Р В°РЎвЂЎР С‘Р Р…Р В°Р ВµРЎвЂљРЎРѓРЎРЏ РЎРѓ "DIS", Р Р…Р Вµ Р Т‘Р С•Р В±Р В°Р Р†Р В»РЎРЏР ВµР С Р Р†РЎвЂљР С•РЎР‚Р С•Р в„– РЎР‚Р В°Р В·
        if StringLength(name) >= 3 and SubString(name, 0, 3) == "DIS" then
            return "ReplaceableTextures\\CommandButtonsDisabled\\" + name
        endif
        return "ReplaceableTextures\\CommandButtonsDisabled\\DIS" + name
    endfunction
function IsActivePlayerSlot takes integer pid returns boolean
    return pid >= 0 and pid < 10 and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(pid)) == MAP_CONTROL_USER
endfunction
function GetStatusColorBySlot takes integer slot returns string
    if slot == 0 then
        return "|c00FF0303"
    elseif slot == 1 then
        return "|c000042FF"
    elseif slot == 2 then
        return "|c001CE6B9"
    elseif slot == 3 then
        return "|c0054007F"
    elseif slot == 4 then
        return "|c00FFFC01"
    elseif slot == 5 then
        return "|c00FF8401"
    elseif slot == 6 then
        return "|c0020C000"
    elseif slot == 7 then
        return "|c00E55BB0"
    elseif slot == 8 then
        return "|c00959697"
    elseif slot == 9 then
        return "|c007EBFF1"
    endif
    return "|c00FFFFFF"
endfunction

function GetPlayerVisualColorString takes player p returns string
    local integer pid = GetPlayerId(p)

    if CaptainMode and CapPickPhase >= 4 then
        return GetStatusColorBySlot(PlayerVisualSlot[pid])
    endif

    return GetStatusColorBySlot(pid)
endfunction
function GetItemById takes unit u, integer itemId returns item
    local integer slot = 0
    local item it

    loop
        exitwhen slot > 5

        set it = UnitItemInSlot(u, slot)

        if GetItemTypeId(it) == itemId then
            return it
        endif

        set slot = slot + 1
    endloop

    return null
endfunction
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
function IsPlaying takes player p returns boolean 
return GetPlayerSlotState( p ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( p ) == MAP_CONTROL_USER 
endfunction
function IsAllyExist takes player p returns boolean 
local boolean b = false
local integer id = GetPlayerId(p)
local integer k = 0
set k = 0
loop
exitwhen k>10
if IsPlayerAlly(Player(k),p) and Player(k) != p and IsPlaying(Player(k)) then 
set b = true 
endif
set k = k + 1
endloop
return b 
endfunction
function IsPlaying2 takes player p returns boolean 
return GetPlayerSlotState( p ) == PLAYER_SLOT_STATE_PLAYING 
endfunction
function IsPlaying3 takes player p returns boolean 
return Hero[GetPlayerId(p)] != null 
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
    
function IsItemInInventory takes unit u, integer it returns integer
        local integer i = 0
        local item ti
        local integer count = 0
        loop
            exitwhen i > 5
            set ti = UnitItemInSlot(u, i)
            if GetItemTypeId(ti) == it then
               set count = count + 1
            endif
            set i = i + 1
        endloop
        set ti = null
        return count
    endfunction 

function RegisterShopHero takes integer heroId, integer page, integer slot returns nothing
    if heroId == 0 then
        return
    endif

    set HeroShopRegistry[HeroShopCount] = heroId
    set HeroPickPage[HeroShopCount] = page
    set HeroPickSlot[HeroShopCount] = slot
    set HeroShopCount = HeroShopCount + 1
endfunction

function InitHeroShopRegistry takes nothing returns nothing
    if HeroShopRegistryReady then
        return
    endif

    set HeroShopRegistryReady = true
    set HeroShopCount = 0

    // Keep this order stable: it is used by BuildItem and SellItem indexes.
    // Arguments: heroId, pick page, pick slot.
    call RegisterShopHero(Natsu_ID,       3, 0)  // shop 0
    call RegisterShopHero(Raiden_ID,      1, 0)  // shop 1
    call RegisterShopHero(Neuvillette_ID, 1, 1)  // shop 2
    call RegisterShopHero(Akainu_ID,      4, 0)  // shop 3
    call RegisterShopHero(Kyoraku_ID,     2, 0)  // shop 4
    call RegisterShopHero(Erza_ID,        3, 1)  // shop 5
    call RegisterShopHero(Gojo_ID,        5, 0)  // shop 6
    call RegisterShopHero(Tomioka_ID,     6, 0)  // shop 7
    call RegisterShopHero(AlterSaber_ID,  6, 1)  // shop 8
    call RegisterShopHero(Kenjaku_ID,     5, 1)  // shop 9
    call RegisterShopHero(Inori_ID,       6, 2)  // shop 10
    call RegisterShopHero(Okarun_ID,      6, 3)  // shop 11
    call RegisterShopHero(Tsuna_ID,       6, 4)  // shop 12
    call RegisterShopHero(BazzB_ID,       2, 1)  // shop 13
    call RegisterShopHero(Takeshi_ID,     6, 5)  // shop 14
    call RegisterShopHero(DarkShiki_ID,   6, 6)  // shop 15
    call RegisterShopHero(Rimuru_ID,      6, 7)  // shop 16
    call RegisterShopHero(Harribel_ID,    2, 2)  // shop 17
    call RegisterShopHero(Barragan_ID,    2, 3)  // shop 18
    call RegisterShopHero(Starrk_ID,      2, 4)  // shop 19
    call RegisterShopHero(Alucard_ID,     6, 8) // shop 20
    call RegisterShopHero(Mahoraga_ID,    5, 2) // shop 21
    call RegisterShopHero(Kirito_ID,      6, 9) // shop 22
    call RegisterShopHero(Bambietta_ID,   2, 5)  // shop 23
    call RegisterShopHero(Asta_ID,        6, 10) // shop 24
    call RegisterShopHero(Patriot_ID,     1, 2)  // shop 25
    call RegisterShopHero(Brandish_ID,    3, 2)  // shop 26    
    call RegisterShopHero(Laxus_ID,    3, 3)  // shop 27    
    call RegisterShopHero(Ainz_ID,    6, 11)  // shop 28      
    call RegisterShopHero(Frieren_ID,    6, 12)  // shop 29
endfunction

function SetHeroId takes integer page, integer slot, integer heroId returns nothing
    if page == 1 then
        set Hero_ID0[slot] = heroId
    elseif page == 2 then
        set Hero_ID1[slot] = heroId
    elseif page == 3 then
        set Hero_ID2[slot] = heroId
    elseif page == 4 then
        set Hero_ID3[slot] = heroId
    elseif page == 5 then
        set Hero_ID4[slot] = heroId
    elseif page == 6 then
        set Hero_ID5[slot] = heroId
    endif
endfunction
function GetRegisteredShopHero takes integer shopId returns integer
    call InitHeroShopRegistry()

    if shopId < 0 or shopId >= HeroShopCount then
        return 0
    endif

    return HeroShopRegistry[shopId]
endfunction

function FindRegisteredHeroShopId takes integer heroId returns integer
    local integer shopId = 0

    call InitHeroShopRegistry()

    loop
        exitwhen shopId >= HeroShopCount
        if HeroShopRegistry[shopId] == heroId then
            return shopId
        endif
        set shopId = shopId + 1
    endloop

    return -1
endfunction

// Compatibility wrapper for old index -> hero calls.
function GetShopId2 takes integer shopId returns integer
    return GetRegisteredShopHero(shopId)
endfunction

// Compatibility wrapper for old hero -> index calls.
// Unlike the old implementation, an unknown hero returns -1 instead of Natsu's index.
function GetShopId takes integer heroId returns integer
    return FindRegisteredHeroShopId(heroId)
endfunction

function RestoreHeroToPick takes integer heroId returns nothing
    local integer shopId = FindRegisteredHeroShopId(heroId)

    if shopId == -1 then
        return
    endif

    call SetHeroId(HeroPickPage[shopId], HeroPickSlot[shopId], heroId)
endfunction

// Compatibility wrapper for the old repick call.
function GetMainId takes integer heroId returns nothing
    call RestoreHeroToPick(heroId)
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
elseif id == Frieren_ID then
set q = FrierenQ_ID
set w = FrierenW_ID
set e = FrierenE_ID
set r = FrierenR_ID
set t = FrierenT_ID
elseif id == Harribel_ID then
set q = HarribelQ_ID
set w = HarribelW_ID
set e = HarribelE_ID
set r = HarribelR_ID
set t = HarribelT_ID
elseif id == Mahoraga_ID then
set q = MahoragaQ_ID
set w = MahoragaW_ID
set e = MahoragaE_ID
set r = MahoragaR_ID
set t = MahoragaT_ID
elseif id == Laxus_ID then
set q = LaxusQ_ID
set w = LaxusW_ID
set e = LaxusE_ID
set r = LaxusR_ID
set t = LaxusT_ID
elseif id == Bambietta_ID then
set q = BambiettaQ_ID
set w = BambiettaW_ID
set e = BambiettaE_ID
set r = BambiettaR_ID
set t = BambiettaT_ID
elseif id == Starrk_ID then
set q = StarrkQ_ID
set w = StarrkW_ID
set e = StarrkE_ID
set r = StarrkR_ID
set t = StarrkT_ID
elseif id == Ainz_ID then
set q = AinzQ_ID
set w = AinzW_ID
set e = AinzE_ID
set r = AinzR_ID
set t = AinzT_ID
elseif id == Barragan_ID then
set q = BarraganQ_ID
set w = BarraganW_ID
set e = BarraganE_ID
set r = BarraganR_ID
set t = BarraganT_ID
elseif id == Asta_ID then
set q = AstaQ_ID
set w = AstaW_ID
set e = AstaE_ID
set r = AstaR_ID
set t = AstaT_ID
elseif id == Brandish_ID then
set q = BrandishQ_ID
set w = BrandishW_ID
set e = BrandishE_ID
set r = BrandishR_ID
set t = BrandishT_ID
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
elseif id == Patriot_ID then
set q = PatriotQ_ID
set w = PatriotW_ID
set e = PatriotE_ID
set r = PatriotR_ID
set t = PatriotT_ID
if LoadInteger(hs, GetHandleId(c), StringHash("patriot e"))== 1 then 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),t,true)
endif
elseif id == DarkShiki_ID then
set q = DarkShikiQ_ID
set w = DarkShikiW_ID
set e = DarkShikiE_ID
set r = DarkShikiR_ID
set t = DarkShikiT_ID
elseif id == Kirito_ID then
set q = KiritoQ_ID
set w = KiritoW_ID
set e = KiritoE_ID
set r = KiritoR_ID
set t = KiritoT_ID
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
elseif id == Alucard_ID then
set q = AlucardQ_ID
set w = AlucardW_ID
set e = AlucardE_ID
set r = AlucardR_ID
set t = AlucardT_ID
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
elseif id == Rimuru_ID then
set q = RimuruQ_ID
set w = RimuruW_ID
set e = RimuruE_ID
set r = RimuruR_ID
set t = RimuruT_ID
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
if id == Patriot_ID and GetUnitLevel(c)>=25 then
set t = PatriotT_ID
if LoadInteger(hs, GetHandleId(c), StringHash("patriot e"))== 1 then 
call SetPlayerAbilityAvailable(GetOwningPlayer(c),t,false)
if GetUnitAbilityLevel(c,PatriotT2_ID) == 0 then 
call UnitAddAbility(c,PatriotT2_ID)
endif
endif
endif
if id == Inori_ID then 
    call SetUnitAbilityLevel(c,InoriEAlt2_ID,GetUnitAbilityLevel(c,InoriE_ID))
endif
if HasCachedItem(c, 'I00Q') > 0 and GetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I00Q'))) > 0 then
        call SetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I00Q')), 0)
endif
 if HasCachedItem(c, 'I01K') > 0 and GetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I01K'))) > 0 then
        call SetItemCharges(UnitItemInSlot(c, IsItemInInventory3(c, 'I01K')), 0)
endif
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
return s == "ThunderGear"  
endfunction
function VIPCheckLvl2 takes string s returns boolean 
return s == "ThunderGear" 
endfunction
function VIPCheckLvl3 takes string s returns boolean 
return s == "ThunderGear" or s == "Zesu" or s == "Alphamalle" or s == "LuXun"  or s == "MaSeTeR" or s == "Uriska" or s == "DSPK" or s == "Bunny"  or s == "Knox0x1" or s == "Tiny" or s == "Hansel"  or s == "Soul"  
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
/*
call UnitRemoveAbility(c,'B01S')
call UnitRemoveAbility(c,'B01T')
call UnitRemoveAbility(c,'B02E')
call UnitRemoveAbility(c,'B02F')
call UnitRemoveAbility(c,'B01U')
call UnitRemoveAbility(c,'B01V')
call UnitRemoveAbility(c,'B01W')*/

                    call UnitRemoveAbility(c,'B02R')
                    call UnitRemoveAbility(c,'B01G')
                    call UnitRemoveAbility(c,'B00T')
                    call UnitRemoveAbility(c,'B02U')
                    call UnitRemoveAbility(c,'B01H')
                    call UnitRemoveAbility(c,'B01I')
                    call UnitRemoveAbility(c,'B01J')
                    call UnitRemoveAbility(c,'B01K')
                    call UnitRemoveAbility(c,'B01L')
                    call UnitRemoveAbility(c,'B01M')
                    call UnitRemoveAbility(c,'B01N')
                    call UnitRemoveAbility(c,'B01E')
                    call UnitRemoveAbility(c,'B01F')
                    call UnitRemoveAbility(c,'B01D')
                    call UnitRemoveAbility(c,'B017')
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
function SetMouseX takes player p, real x returns nothing
local integer i = GetPlayerId(p)
set MouseX[i] = x
endfunction
function SetMouseY takes player p ,real y returns nothing
local integer i = GetPlayerId(p)
set MouseY[i] = y
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



function CreateTT_perm takes real x,real y ,real z ,real size, string s returns nothing
set bj_lastCreatedTextTag = CreateTextTag()
   // call SetTextTagLifespan(bj_lastCreatedTextTag, 0.9) // РЎвЂЎР ВµРЎР‚Р ВµР В· 0.5 РЎРѓР ВµР С” РЎС“Р Т‘Р В°Р В»Р С‘РЎвЂљРЎРѓРЎРЏ
   // call SetTextTagFadepoint(bj_lastCreatedTextTag, 0.45) // Р С”Р С•Р С–Р Т‘Р В° Р Р…Р В°РЎвЂЎР Р…Р ВµРЎвЂљ Р С—Р В»Р В°Р Р†Р Р…Р С• Р С‘РЎРѓРЎвЂЎР ВµР В·Р В°РЎвЂљРЎРЉ
    call SetTextTagPos(bj_lastCreatedTextTag, x,y, z) // Р С—Р С•Р В·Р С‘РЎвЂ Р С‘РЎРЏ (Р Р…Р В°Р С—РЎР‚Р С‘Р СР ВµРЎР‚ Р Р…Р В° РЎР‹Р Р…Р С‘РЎвЂљР Вµ)
    call SetTextTagText(bj_lastCreatedTextTag, s, size/1000) // РЎРѓР В°Р С РЎвЂљР ВµР С”РЎРѓРЎвЂљ Р С‘ РЎР‚Р В°Р В·Р СР ВµРЎР‚
    call SetTextTagPermanent(bj_lastCreatedTextTag, true) // Р Т‘Р ВµР В»Р В°Р ВµР С Р Р…Р ВµР С—Р С•РЎРѓРЎвЂљР С•РЎРЏР Р…Р Р…РЎвЂ№Р С
    call SetTextTagVisibility(bj_lastCreatedTextTag,true)
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
    // Стадия 1 и выше: +20% к скорости передвижения.
    function AinzF_HasMoveSpeedBuff takes unit whichUnit returns boolean
        return AinzF_GetBuffStage(whichUnit) >= 1
    endfunction

    // Стадия 2 и выше: +8% к магическому урону.
    function AinzF_HasMagicDamageBuff takes unit whichUnit returns boolean
        return AinzF_GetBuffStage(whichUnit) >= 2
    endfunction

    // Стадия 3 и выше: -8% получаемого урона.
    function AinzF_HasDamageReductionBuff takes unit whichUnit returns boolean
        return AinzF_GetBuffStage(whichUnit) >= 3
    endfunction

    // Стадия 4 и выше: +10% к получаемому активному лечению.
    function AinzF_HasActiveHealBuff takes unit whichUnit returns boolean
        return AinzF_GetBuffStage(whichUnit) >= 4
    endfunction

    // Стадия 5 и выше: +15 здоровья в секунду.
    function AinzF_HasHpRegenBuff takes unit whichUnit returns boolean
        return AinzF_GetBuffStage(whichUnit) >= 5
    endfunction

    // Стадия 6: +15 ко всем характеристикам.
    function AinzF_HasAllStatsBuff takes unit whichUnit returns boolean
        return AinzF_GetBuffStage(whichUnit) >= 6
    endfunction
function GetHpRegen takes unit c returns real
local real result = BlzGetUnitRealField(c,UNIT_RF_HIT_POINTS_REGENERATION_RATE)+GetHeroStr(c,true)*str_hpregen
if GetUnitAbilityLevel(c,'A048')> 0 then //erza w armor hp regen
set result = result + 2
endif
if AinzF_HasHpRegenBuff(c) then //erza w armor hp regen
set result = result + 15
endif
if GetUnitAbilityLevel(c,'B01P')>0 then // holy grail item
set result = result + DarkHolyGrail_HpRegen
elseif GetUnitAbilityLevel(c,'B013')>0 then // holy grail item
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
if GetUnitAbilityLevel(c,HarribelE_Regen1_ID)> 0 then //hari
set result = result + 3
endif
if GetUnitAbilityLevel(c,HarribelE_Regen2_ID)> 0 then //hari
set result = result + 6
endif
if GetUnitAbilityLevel(c,HarribelE_Regen3_ID)> 0 then //hari
set result = result + 9
endif
if GetUnitAbilityLevel(c,HarribelE_Regen4_ID)> 0 then //hari
set result = result + 12
endif
if GetUnitAbilityLevel(c,HarribelE_Regen5_ID)> 0 then //hari
set result = result + 15
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

if AinzF_HasActiveHealBuff(c) then //erza w armor hp regen
set result = result *1.1
endif
return result 
endfunction
function GetMpRegen takes unit c returns real
 return BlzGetUnitRealField(c,UNIT_RF_MANA_REGENERATION)+GetHeroInt(c,true)*int_mpregen
endfunction
function GetAS takes unit c returns real
local real base = BlzGetUnitWeaponRealField(c, UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN, 0)
local real ias  = GetHeroAgi(c, true) * agi_as   // agi_as = 0.01
if GetUnitAbilityLevel(c,'A0BY')>0 then 
set ias = ias + (0.05*GetUnitAbilityLevel(c,'A0BY')  )
endif
if ias > 4.0 then
    set ias = 4.0
endif
return base/ (1.0 + ias)
endfunction
function GetAttack takes unit c returns real
local real base = BlzGetUnitBaseDamage(c,0)
if GetUnitAbilityLevel(c,'A02J') > 0 then 
set base = base + (25*GetUnitAbilityLevel(c,'A02J')  )
endif
if GetUnitAbilityLevel(c,'A05X') > 0 then 
set base = base + (20*(GetUnitAbilityLevel(c,'A05X')-1)  )
endif
if GetUnitAbilityLevel(c,'A0BX') > 0 then 
set base = base + (20*GetUnitAbilityLevel(c,'A0BX')  )
endif
if GetUnitAbilityLevel(c,'A06N') > 0 then 
set base = base + (20*GetUnitAbilityLevel(c,'A06N')  )
endif
if GetUnitAbilityLevel(c,'A0DX') > 0 then 
set base = base + 200
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
return c != null and GetUnitAbilityLevel(c,'B01R') > 0
endfunction
function AddSpellLevel takes unit c, integer id, integer lvl, boolean b returns nothing
if b == true then 
call SetUnitAbilityLevel(c,id,GetUnitAbilityLevel(c,id)+lvl)
else
call SetUnitAbilityLevel(c,id,GetUnitAbilityLevel(c,id)-lvl)
endif
endfunction


function IsRussianLetter takes string c returns boolean
    local integer i = 0
    local integer len = StringLength(PlayerNameCyrillic)

    if StringLength(c) != 2 then
        return false
    endif

    loop
        exitwhen i + 2 > len
        if SubString(PlayerNameCyrillic, i, i + 2) == c then
            return true
        endif
        set i = i + 2
    endloop

    return false
endfunction

function GetVisualLength takes string s returns integer
    local integer i = 0
    local integer len = StringLength(s)
    local integer visual = 0
    local string c

    loop
        exitwhen i >= len

        // Skip |cAARRGGBB without skipping the colored name itself.
        if i + 10 <= len and SubString(s, i, i + 2) == "|c" then
            set i = i + 10

        // Skip color reset.
        elseif i + 2 <= len and SubString(s, i, i + 2) == "|r" then
            set i = i + 2

        // Treat an existing line break as zero-width control code.
        elseif i + 2 <= len and SubString(s, i, i + 2) == "|n" then
            set i = i + 2

        elseif i + 2 <= len then
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
    endloop

    return visual
endfunction

function SplitName takes string s returns string
    local integer i = 0
    local integer len = StringLength(s)
    local integer visual = 0
    local string c

    if GetVisualLength(s) <= LetterCheck then
        return s
    endif

    loop
        exitwhen i >= len

        if i + 10 <= len and SubString(s, i, i + 2) == "|c" then
            set i = i + 10

        elseif i + 2 <= len and SubString(s, i, i + 2) == "|r" then
            set i = i + 2

        elseif i + 2 <= len and SubString(s, i, i + 2) == "|n" then
            set i = i + 2

        elseif i + 2 <= len then
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

        if visual == LetterCheck and i < len then
            return SubString(s, 0, i) + "|n" + SubString(s, i, len)
        endif
    endloop

    return s
endfunction

function SplitName2 takes string s returns string
    local integer i = 0
    local integer len = StringLength(s)
    local integer visual = 0
    local string c

    if GetVisualLength(s) <= 15 then
        return s
    endif

    loop
        exitwhen i >= len

        if i + 10 <= len and SubString(s, i, i + 2) == "|c" then
            set i = i + 10

        elseif i + 2 <= len and SubString(s, i, i + 2) == "|r" then
            set i = i + 2

        elseif i + 2 <= len and SubString(s, i, i + 2) == "|n" then
            set i = i + 2

        elseif i + 2 <= len then
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

        if visual == 15 and i < len then
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
function GetMainStatAgi takes unit c returns boolean
    local boolean b = false
    local integer value = 0
    if BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 3 then // agi
        set b = true
    endif
    if LoadInteger(hs, GetHandleId(c), StringHash("rimuru evol 2")) == 1 then
        set b = true
    endif
    return b
endfunction
function GetMainStatStr takes unit c returns boolean
    local boolean b = false
    local integer value = 0
    if BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 1 then //str
        set b = true
    endif
   return b
endfunction
function GetMainStatInt takes unit c returns boolean
    local boolean b = false
    local integer value = 0
    if BlzGetUnitIntegerField(c, UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then // int
        set b = true
    endif
    return b
endfunction
function OkarunEggCd takes unit c, integer id, real cd returns nothing 
    local real r2 = 0
    local integer check = 0
    if (GetMainStatInt(c) and HasCachedItem(c,'I011')>0) then
             set r2 = r2+(OkarunEggReduceCD/100)
            endif
            if GetMainStatAgi(c) and BlzGetUnitAbilityCooldownRemaining(c,'A0BZ')==0 and HasCachedItem(c,'I024')>0 then 
            set r2 = r2+(PrisonRealmReduceCD/100)
            set check = 1
            endif
            if r2>1 then 
            set r2 = 1
            endif
            if r2>0 then             
             call BlzStartUnitAbilityCooldown(c, id, cd*(1-r2))
             if check == 1 then              
             call BlzStartUnitAbilityCooldown(c, 'A0BZ', PrisonRealmCD )
             endif
             else
             call BlzStartUnitAbilityCooldown(c, id, cd)
            endif
    endfunction
     function OkarunEggCdReal takes unit c, real cd returns real
     local real r = cd
     local real r2 = 0
    if (GetMainStatInt(c) and HasCachedItem(c,'I011')>0) then
             set r2 = r2+(OkarunEggReduceCD/100)
            endif
            if GetMainStatAgi(c) and BlzGetUnitAbilityCooldownRemaining(c,'A0BZ')==0 and HasCachedItem(c,'I024')>0 then 
            set r2 = r2+(PrisonRealmReduceCD/100)
            endif
            if r2>1 then 
            set r2 = 1
            endif
            if (GetMainStatInt(c) and HasCachedItem(c,'I011')>0) or (GetMainStatAgi(c) and BlzGetUnitAbilityCooldownRemaining(c,'A0BZ')==0 and HasCachedItem(c,'I024')>0)   then
             set r = cd * (1-r2)
             else
            set r =  cd
            endif
           
            return r
    endfunction
    function RecommenedItems takes player p returns nothing
local integer i =GetPlayerId(p)
local integer i2 =GetPlayerId(p)*35
local integer id = GetUnitTypeId(Hero[i])
 if CaptainMode == true and CapPickPhase < 4  then 
    call PauseUnit(Hero[i],true)
    endif
    call BlzFrameSetVisible(lmpOpenButton,true)
    call BlzFrameSetVisible(lmpLinkButton,true)

// Clear the old hero's queue before writing the six new recommendations.
set ItemsPage0_ID[i2+0] = 0
set ItemsPage0_ID[i2+1] = 0
set ItemsPage0_ID[i2+2] = 0
set ItemsPage0_ID[i2+3] = 0
set ItemsPage0_ID[i2+4] = 0
set ItemsPage0_ID[i2+5] = 0

if id == Natsu_ID  then
    
    set ItemsPage0_ID[i2+0] = 'I01V' // tusk barrel    
    set ItemsPage0_ID[i2+1] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I00B' // Oken
    set ItemsPage0_ID[i2+4] = 'I024' // prison realm
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
if id == Patriot_ID then
    
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set    
    set ItemsPage0_ID[i2+1] = 'I024' // urahara set
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I00T' // Oken
    set ItemsPage0_ID[i2+4] = 'I01Q' // ryujin jakka
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
if id == Laxus_ID  then
   
    
    set ItemsPage0_ID[i2+0] = 'I02G' // urahara set   
    set ItemsPage0_ID[i2+1] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+2] = 'I02J' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I02L' // cup of tea
    set ItemsPage0_ID[i2+4] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
if id == Alucard_ID or id == Asta_ID then
    
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set    
    set ItemsPage0_ID[i2+1] = 'I00T' // raikage set
    set ItemsPage0_ID[i2+2] = 'I01I' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I01M' // Oken
    set ItemsPage0_ID[i2+4] = 'I01Q' // ryujin jakka
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
if id == Mahoraga_ID then
    
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set    
    set ItemsPage0_ID[i2+1] = 'I00T' // raikage set
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I00B' // Oken
    set ItemsPage0_ID[i2+4] = 'I00Y' // ryujin jakka
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
if id == DarkShiki_ID then
    
    
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set    
    set ItemsPage0_ID[i2+1] = 'I00T' // raikage set
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I010' // Oken
    set ItemsPage0_ID[i2+4] = 'I024' // ryujin jakka
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Neuvillette_ID then
       
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I01P' // Oken
    set ItemsPage0_ID[i2+2] = 'I00H' // ryujin jakka
    set ItemsPage0_ID[i2+3] = 'I01L' // kazekage hat
    set ItemsPage0_ID[i2+4] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Barragan_ID then
       
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00H' // Oken
    set ItemsPage0_ID[i2+2] = 'I023' // ryujin jakka
    set ItemsPage0_ID[i2+3] = 'I01L' // kazekage hat
    set ItemsPage0_ID[i2+4] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Rimuru_ID then
        
  set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00H' // kazekage hat
    set ItemsPage0_ID[i2+2] = 'I01B' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+4] = 'I01L' // kazekage hat
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Kyoraku_ID then
        
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I01I' // kansho and bakuya
    set ItemsPage0_ID[i2+2] = 'I024' // kansho and bakuya
    set ItemsPage0_ID[i2+3] = 'I00Y' // fairy tail emblem
    set ItemsPage0_ID[i2+4] = 'I019' // earth power
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Kenjaku_ID then
       
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00H' // nichirin
    set ItemsPage0_ID[i2+2] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+3] = 'I01L' // kazekage hat
    set ItemsPage0_ID[i2+4] = 'I00Y' // kazekage hat
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Okarun_ID or id == Brandish_ID then
       
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00H' // nichirin
    set ItemsPage0_ID[i2+2] = 'I01M' // nichirin
    set ItemsPage0_ID[i2+3] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+4] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Inori_ID or id == Frieren_ID then
        
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00H' // kazekage hat
    set ItemsPage0_ID[i2+2] = 'I01B' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+4] = 'I01L' // kazekage hat
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == AlterSaber_ID then
        
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I02C' // fairy emblem
    set ItemsPage0_ID[i2+2] = 'I00T' // raikage hat
    set ItemsPage0_ID[i2+3] = 'I01I' // cup of tea  
    set ItemsPage0_ID[i2+4] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Kirito_ID then
        
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I02C' // fairy emblem
    set ItemsPage0_ID[i2+2] = 'I00T' // raikage hat
    set ItemsPage0_ID[i2+3] = 'I01I' // cup of tea  
    set ItemsPage0_ID[i2+4] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Takeshi_ID then
       
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I012' // fairy emblem
    set ItemsPage0_ID[i2+2] = 'I00T' // raikage hat
    set ItemsPage0_ID[i2+3] = 'I01I' // cup of tea  
    set ItemsPage0_ID[i2+4] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Tsuna_ID then
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set    
    set ItemsPage0_ID[i2+1] = 'I01I' // cup of tea  
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I01L' // true zangetsu
    set ItemsPage0_ID[i2+4] = 'I00W' // true zangetsu
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Raiden_ID or id == Starrk_ID then
        
    set ItemsPage0_ID[i2+0] = 'I00E' // urahara set
    set ItemsPage0_ID[i2+1] = 'I024' // true zangetsu
    set ItemsPage0_ID[i2+2] = 'I01I' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I01L' // black clover
    set ItemsPage0_ID[i2+4] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == BazzB_ID or id == Bambietta_ID then
        
    set ItemsPage0_ID[i2+0] = 'I00E' // urahara set
    set ItemsPage0_ID[i2+1] = 'I012' // true zangetsu
    set ItemsPage0_ID[i2+2] = 'I01I' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I01L' // black clover
    set ItemsPage0_ID[i2+4] = 'I00W' // kurikara
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Harribel_ID then
        
    set ItemsPage0_ID[i2+0] = 'I02B' // d gr
    set ItemsPage0_ID[i2+1] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+2] = 'I01L' // true zangetsu
    set ItemsPage0_ID[i2+3] = 'I01B' // cup of tea
    set ItemsPage0_ID[i2+4] = 'I01P' // cup of tea
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 

if id == Gojo_ID or id == Ainz_ID then
       
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00H' // kazekage hat
    set ItemsPage0_ID[i2+2] = 'I01B' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I011' // okarun egg
    set ItemsPage0_ID[i2+4] = 'I01L' // kazekage hat
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif 
if id == Erza_ID then
      
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I02G' // witch sin
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I01M' // Oken
    set ItemsPage0_ID[i2+4] = 'I019' // earth hand
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
if id == Tomioka_ID then
   
    set ItemsPage0_ID[i2+0] = 'I00O' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00E' // witch sin
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I00B' // Oken
    set ItemsPage0_ID[i2+4] = 'I019' // earth hand
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
if id == Akainu_ID then
       
    set ItemsPage0_ID[i2+0] = 'I02B' // urahara set
    set ItemsPage0_ID[i2+1] = 'I00L' // witch sin
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I00Y' // angel blessing
    set ItemsPage0_ID[i2+4] = 'I019' // kurikara
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
set ItemsFrameCurrentPage_ID[i] = 0
set ItemsCraftPlayerDebug_ID[i] = -1

// A new recommendation list always starts a new sequential autobuy queue.
set AutoBuyRecommendedIndex[i] = 0
set AutoBuyRecommendedUnitId[i] = GetHandleId(Hero[i])
set AutoBuyRecommendedDone[i] = false

endfunction

    
function GetPlayerColorString takes player p returns string
    local integer id = GetPlayerId(p)
    if id == 0 then
        return "|c00FF0303" // Р С™РЎР‚Р В°РЎРѓР Р…РЎвЂ№Р в„–
    elseif id == 1 then
        return "|c000042FF" // Р РЋР С‘Р Р…Р С‘Р в„–
    elseif id == 2 then
        return "|c001CE6B9" // Р вЂР С‘РЎР‚РЎР‹Р В·Р С•Р Р†РЎвЂ№Р в„–
    elseif id == 3 then
        return "|c0054007F" // Р В¤Р С‘Р С•Р В»Р ВµРЎвЂљР С•Р Р†РЎвЂ№Р в„–
    elseif id == 4 then
        return "|c00FFFC01" // Р вЂ“Р ВµР В»РЎвЂљРЎвЂ№Р в„–
    elseif id == 5 then
        return "|c00FF8401" // Р С›РЎР‚Р В°Р Р…Р В¶Р ВµР Р†РЎвЂ№Р в„–
    elseif id == 6 then
        return "|c0020C000" // Р вЂ”Р ВµР В»Р ВµР Р…РЎвЂ№Р в„–
    elseif id == 7 then
        return "|c00E55BB0" // Р В Р С•Р В·Р С•Р Р†РЎвЂ№Р в„–
    elseif id == 8 then
        return "|c00959697" // Р РЋР ВµРЎР‚РЎвЂ№Р в„–
    elseif id == 9 then
        return "|c007EBFF1" // Р РЋР Р†Р ВµРЎвЂљР В»Р С•-РЎРѓР С‘Р Р…Р С‘Р в„–
    elseif id == 10 then
        return "|c00106246" // Р СћР ВµР СР Р…Р С•-Р В·Р ВµР В»Р ВµР Р…РЎвЂ№Р в„–
    elseif id == 11 then
        return "|c004E2A04" // Р С™Р С•РЎР‚Р С‘РЎвЂЎР Р…Р ВµР Р†РЎвЂ№Р в„–
    endif
    return "|c00FFFFFF" // Р Т‘Р ВµРЎвЂћР С•Р В»РЎвЂљ Р В±Р ВµР В»РЎвЂ№Р в„–
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

    function SetHpCurrent takes unit c, real r returns nothing
    call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) + r)
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
      
    function IsUnitDebuffed1 takes unit c returns boolean
        return GetUnitAbilityLevel(c, 'BUsp') > 0 or GetUnitAbilityLevel(c, 'BUsl') > 0 or GetUnitAbilityLevel(c, 'Bust') > 0 or GetUnitAbilityLevel(c, 'BPSE') > 0
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

    if c == null or sr <= 0.00 then
        return
    endif

    set startX = GetUnitX(c)
    set startY = GetUnitY(c)

    /*
     * Система стен может уменьшить разрешённую дистанцию
     * вплоть до нуля.
     */
    
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
function MoveUnit3 takes unit c, real sr, real a returns nothing
    local real startX
    local real startY
    local real move
    local real targetX
    local real targetY

    if c == null or sr <= 0.00 then
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
     if GetUnitAbilityLevel(c, 'BEer') == 1 then
     call UnitRemoveAbility(c, 'BEer')
     endif
        if GetUnitAbilityLevel(c, 'Arav') == 0 then
            call UnitAddAbility(c, 'Arav')
            call SetUnitFlyHeight(c, fly, 0)
            call UnitRemoveAbility(c, 'Arav')
        else
            call SetUnitFlyHeight(c, fly, 0)
        endif
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
                        call DestroyEffect(e)
                        call BlzSetSpecialEffectAlpha(e,0)
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
        private static framehandle array frame0_pas1 [10]
        private static framehandle array frame0_pas2 [10]
        private static framehandle array frame0_pas3 [10]
        private static framehandle array frame0_pas4 [10]
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
            set k2 = k2 + (k3*10)+1
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
            loop
                exitwhen i > MUI_31
                set this = m_31[i]
                if r < rmax then
                    set r = RoundReal(r + 0.05, 3)
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

        real r
        real rmax
        integer maxStacks
        integer frameAbilityId
        integer cooldownAbilityId
        unit c
        boolean regenEnabled
        boolean frameSuppressed

        // These frames belong to this exact hero instance, not to a player.
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
            local framehandle abilityButton

            if frameRoot != null or frameAbilityId == 0 then
                return
            endif

            set abilityButton = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, GetSlotByXY(BlzGetAbilityPosX(frameAbilityId), BlzGetAbilityPosY(frameAbilityId)))
            if abilityButton == null then
                return
            endif

            // Empty frame names prevent different heroes from replacing a frame by name.
            set frameRoot = BlzCreateFrameByType("SIMPLEFRAME", "", abilityButton, "", 0)
            call BlzFrameClearAllPoints(frameRoot)
            call BlzFrameSetSize(frameRoot, 0.015, 0.015)
            call BlzFrameSetPoint(frameRoot, FRAMEPOINT_BOTTOMRIGHT, abilityButton, FRAMEPOINT_BOTTOMRIGHT, 0.00, 0.00)
            call BlzFrameSetVisible(frameRoot, false)

            set frameIcon = BlzCreateFrameByType("SIMPLESTATUSBAR", "", frameRoot, "", 0)
            call BlzFrameClearAllPoints(frameIcon)
            call BlzFrameSetAllPoints(frameIcon, frameRoot)
            call BlzFrameSetValue(frameIcon, 100.00)

            set abilityButton = null
        endmethod

        private method RefreshStackFrameVisibility takes integer stackNum returns nothing
    local boolean show = false
    if frameRoot == null then
        return
    endif
    if GetLocalPlayer() == GetOwningPlayer(c) then
        set show = not frameSuppressed and stackNum > 0 and IsUnitSelected(c, GetLocalPlayer())
        call BlzFrameSetVisible(frameRoot, show)
    endif
endmethod

        private method DestroyStackFrame takes nothing returns nothing
            if frameIcon != null then
                call BlzDestroyFrame(frameIcon)
                set frameIcon = null
            endif
            if frameRoot != null then
                call BlzDestroyFrame(frameRoot)
                set frameRoot = null
            endif
        endmethod

        // The public signature stays unit + stack count. It finds that hero's
        // own structure instance and never touches another hero's frames.
        public static method UpdateStackFrame takes unit cu, integer stackNum returns nothing
            local thistype data = thistype.FindByUnit(cu)
            local integer hid = GetHandleId(cu)

            if data == 0 then
                return
            endif

            if data.frameRoot == null then
                call data.CreateStackFrame()
            endif
            if data.frameRoot == null then
                return
            endif

            if stackNum <= 0 then
                set stackNum = 0
                call SaveInteger(hs, hid, StringHash("stack_count"), 0)
            else
                if stackNum > data.maxStacks then
                    set stackNum = data.maxStacks
                    call SaveInteger(hs, hid, StringHash("stack_count"), stackNum)
                endif
                call BlzFrameSetTexture(data.frameIcon, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack" + I2S(stackNum) + ".blp", 0, false)
            endif

            call data.RefreshStackFrameVisibility(stackNum)
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
                    elseif curStack < maxStacks then
                        set r = RoundReal(r + 0.05, 3)
                        if r >= rmax then
                            set r = 0.00
                            set curStack = curStack + 1
                            call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), curStack)
                            if cooldownAbilityId != 0 then
                                call BlzStartUnitAbilityCooldown(c, cooldownAbilityId, 0.01)
                            endif
                            // This is outside a cast event, so an immediate reset
                            // cannot be overwritten by the Warcraft III engine.
                            if frameAbilityId != 0 then
                                call BlzEndUnitAbilityCooldown(c, frameAbilityId)
                            endif
                            call thistype.UpdateStackFrame(c, curStack)
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

            // Reconfigure an existing tracker instead of creating a duplicate.
            if this != 0 then
                set frameAbilityId = NewFrameAbilityId
                set cooldownAbilityId = NewCooldownAbilityId
                set maxStacks = NewMaxStacks
                if maxStacks < 1 then
                    set maxStacks = 1
                endif
                set rmax = NewRmax
                if rmax < 0.05 then
                    set rmax = 0.05
                endif
                set r = 0.00
                set regenEnabled = true
                set frameSuppressed = false
                call this.DestroyStackFrame()
                set curStack = LoadInteger(hs, GetHandleId(c), StringHash("stack_count"))
                call thistype.UpdateStackFrame(c, curStack)
                call SaveInteger(hs, GetHandleId(c), StringHash("morph_end"), 0)
                return
            endif

            set this = thistype.create()
            set c = NewC
            set r = 0.00
            set rmax = NewRmax
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

            // A stack may have been removed by another system during the delay.
            if resetUnit != null and GetUnitTypeId(resetUnit) != 0 and abilityId != 0 and LoadInteger(hs, GetHandleId(resetUnit), StringHash("stack_count")) > 0 then
                call BlzEndUnitAbilityCooldown(resetUnit, abilityId)
            endif

            call FlushChildHashtable(hs, timerId)
            call PauseTimer(resetTimer)
            call DestroyTimer(resetTimer)
            set resetUnit = null
            set resetTimer = null
        endmethod

        private static method ScheduleCooldownReset takes unit cu, integer abilityId returns nothing
            local timer resetTimer = CreateTimer()
            local integer timerId = GetHandleId(resetTimer)

            call SaveUnitHandle(hs, timerId, StringHash("KS_SpellStacks_ResetUnit"), cu)
            call SaveInteger(hs, timerId, StringHash("KS_SpellStacks_ResetAbility"), abilityId)
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
            call SaveInteger(hs, hid, StringHash("stack_count"), curStack)
            call thistype.UpdateStackFrame(cu, curStack)

            // Cooldown is assigned by the engine after the spell-event finishes.
            // Reset it 0.03 sec later only when at least one charge remains.
            if curStack > 0 and data.frameAbilityId != 0 then
                call thistype.ScheduleCooldownReset(cu, data.frameAbilityId)
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

            // A newly granted stack makes the ability available again.
            if newAmount > oldAmount and newAmount > 0 and data.frameAbilityId != 0 then
                call thistype.ScheduleCooldownReset(cu, data.frameAbilityId)
            endif
        endmethod

        public static method AddStacks takes unit cu, integer amount returns nothing
            call thistype.SetStackCount(cu, thistype.GetStackCount(cu) + amount)
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
            call thistype.SetStackCount(cu, data.maxStacks)
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
    function LustSin takes unit c, unit td, real dmg returns real
local integer check = 0
if c == null then
return 0.0
endif
if GetUnitAbilityLevel(c,'B01R') > 0 then
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_firefly-rq-sfx-5.mdl",td,"chest"))
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_0706Red.mdl",td,"chest"))
set check = 1
elseif (GetUnitTypeId(c) == Frieren_ID or GetUnitTypeId(c) == FrierenTR_unitid )  then
set check = 1
set dmg = dmg*(FrierenTF_PierceShield/100)
elseif dmg >= LustSin_MinDmg and GetUnitAbilityLevel(c,'A07O') > 0 and BlzGetUnitAbilityCooldownRemaining(c,'A07O') == 0 then
set dmg = dmg*(LustSin_IgnoreAmount/100)
if HasCachedItem(c,'I01W') > 0 then
if GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W'))) > 0 then
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W')))-1)
endif
if GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01W'))) == 0 then
call BlzStartUnitAbilityCooldown(c,'A07O',LustSin_CD)
endif
call MyItemStacks(c,'I01W',1,LustSin_CD,true)
else
call BlzStartUnitAbilityCooldown(c,'A07O',LustSin_CD)
endif
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_firefly-rq-sfx-5.mdl",td,"chest"))
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_0706Red.mdl",td,"chest"))
set check = 1
if DamagePenDepth > 0 then
set LustSinUsedInDamage[DamagePenDepth] = true
endif
elseif dmg > 1 and HasCachedItem(c,'I02D') > 0 then
set dmg = dmg*(LustSin_IgnoreAmount/100)
set check = 1
endif
if check == 0 then
set dmg = 0.0
endif
return dmg
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
    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
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
            exitwhen i > 5
            set ti = UnitItemInSlot(u, i)
            if GetItemTypeId(ti) == it1  then
                set count = count + 1
                if count > 1 then
                    if count2 == 0 then
                        call DisplayTimedTextToPlayer(GetOwningPlayer(u), 0, 0, 3, "|c00F20000You cant own more than 1 item of same type!|r")
                        set count2 = count2 + 1
                    endif
                    set gold = GetItemValue(GetItemTypeId(ti))
                    call AddGold(GetOwningPlayer(u),R2I(gold*0.75),true)
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
            exitwhen i > 5
            set ti = UnitItemInSlot(u, i)
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
local real cd = 0
if LoadInteger(hs,GetHandleId(c),StringHash("erza g2 active")) >0 and LoadInteger(hs,GetHandleId(c),StringHash("erza g2 type")) == 1 then
        set k = 0
        endif
        if GetUnitAbilityLevel(c,'B00J')> 0 then 
        set k = 0
        endif
        if GetUnitAbilityLevel(c,'A0E0')> 0 then 
        set k = 0
        endif
        if GetUnitAbilityLevel(c,'A0E1')> 0 then 
        set k = 0
        endif
        if GetUnitAbilityLevel(c,'B005')> 0 then 
        set k = 0
        endif
        if LoadInteger(hs,GetHandleId(c),StringHash("naofumi shield")) == 1 then 
        set k = 0
        endif
if GetUnitTypeId(c) == Rimuru_ID then 
if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 1")) == 1 or LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 1 then
if IntegerCd(c,"rimuru f cd",OkarunEggCdReal(c,RimuruF2_CD)) then
if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 1   then
call MyFrame(c,OkarunEggCdReal(c,RimuruF2_CD),"BTNHero_Rimuru3_F",false,0)
else
call MyFrame(c,OkarunEggCdReal(c,RimuruF2_CD),"BTNHero_Rimuru_F",false,0)
endif
if GetRandomInt(1,2) == 1 then 
call MakeSound("war3mapimported\\Hero_Rimuru_F")
else
call MakeSound("war3mapimported\\Hero_Rimuru_F2")
endif
set k = 0
endif
else
if BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID) == 0 then 
set k = 0
if GetRandomInt(1,2) == 1 then 
call MakeSound("war3mapimported\\Hero_Rimuru_F")
else
call MakeSound("war3mapimported\\Hero_Rimuru_F2")
endif
call FakeCD_Start(c, RimuruF_ID, RimuruF_CD, 0, 0)
endif
endif
endif
if LoadInteger(hs,GetHandleId(c),StringHash("debuff immune")) == 1 then 
set k = 0
endif
return k 
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
    function BuffUnit02 takes unit c, unit u, integer id,integer s, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local unit d = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(d, id)
            call SetUnitAbilityLevel(d, id, level)
            call SetUnitFacing(d, GAngle(d, u) * bj_RADTODEG)
            call IssueTargetOrderById(d, s, u)
      call MyRemoveUnit(d,0.2)
      set d = null
    endfunction
    function SilenceUnit takes unit c, unit u, real time returns nothing // min 0.5 , max 5.0 sec
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level
        if time > 0 then 
        set level= R2I(time / 0.5)
        if u != null and GetWidgetLife(u)>5 then
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A01V')
        endif
        
        if level < 1 then
            set level = 1
        elseif level > 10 then
            set level = 10
        endif
        if HasCachedItem(u,'I020') >0 and BlzGetUnitAbilityCooldownRemaining(u,'A09U')==0 then // IntegerCd(u,"witch sin cd",25) then
        set level = 0        
        call DebuffClear(u)        
        call UnitAddAbility(u,'A0E1')
        call MyRemoveAbility(u,1.5,'A0E1',1)
        call SetHpCurrent2(c,c,500)
        call BlzStartUnitAbilityCooldown(u,'A09U',18)
        call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_[tx]_sishu_d.mdl",u,"origin"),5)
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
        endif
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
        if u != null and GetWidgetLife(u)>5 then
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1OA')
        endif
      
        if level > 30 then
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
        if HasCachedItem(u,'I00L') >0 and BlzGetUnitAbilityCooldownRemaining(u,'A01D')==0 then // IntegerCd(u,"witch sin cd",25) then
        set level = 0
        call DebuffClear(u)
        call UnitAddAbility(u,'A0E0')
        call MyRemoveAbility(u,1.5,'A0E0',1)
        
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
        set level= level - 3
        elseif GetHeroLevel(u)>=24 then
        set level= level - 2
        else
        set level= level - 1
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
        endif
    endfunction
    function DoomUnit takes unit c, unit u, real time returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = R2I(time / 0.5)
        if u != null and GetWidgetLife(u)>5 then
        
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
        endif
    endfunction
    function RootUnit takes unit c, unit u, real time returns nothing // min 0.5 , max 5.0 sec
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer level = R2I(time / 0.25)
        if u != null and GetWidgetLife(u)>5 then
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'APPP')
        endif
        
        if level > 30 then
            set level = 30
        endif
        set level = DebuffImmune_Start(u,level)  
        if GetUnitAbilityLevel(u,'B00J')>0 then  // inori R immune
        set level = 0
        endif
        if HasCachedItem(u,'I020') >0 and BlzGetUnitAbilityCooldownRemaining(u,'A09U')==0 then // IntegerCd(u,"witch sin cd",25) then
        set level = 0        
        call DebuffClear(u)        
        call UnitAddAbility(u,'A0E1')
        call MyRemoveAbility(u,1.5,'A0E1',1)
        call SetHpCurrent2(c,c,500)
        call BlzStartUnitAbilityCooldown(u,'A09U',18)
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
        endif
    endfunction
    // Percent: 5 to 95 in steps of 5 (19 tiers)
// Duration: 1, 2, 3, 4 seconds (4 options)
// Level mapping: level = (percentTier - 1) * 4 + durationIndex
//   percentTier  = (slowPercent / 5)        -> 1..19
//   durationIndex = duration                -> 1..4
// Example: 5% for 1s = level 1, 5% for 4s = level 4, 10% for 1s = level 5 ...

function GetSlowAbilityLevel takes integer slowPercent, integer duration returns integer
    local integer percentTier = slowPercent / 5       // e.g. 5->1, 10->2, 50->10
    local integer durationIndex = duration            // 1, 2, 3, or 4
    return (percentTier - 1) * 4 + durationIndex
endfunction

function SlowUnit takes unit c, unit u, integer percent, integer time returns nothing
    // percent: 5 to 95 in multiples of 5 (5, 10, 15 ... 95)
    // time:    1, 2, 3, or 4 seconds
    local integer i = GetPlayerId(GetOwningPlayer(c))
    local integer level = GetSlowAbilityLevel(percent, time)

    if u != null and GetWidgetLife(u)>5 then
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
        set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
        call UnitAddAbility(DummyPlayer[i], 'A1OT')
    endif

    
    if level < 1 then
        set level = 1
    elseif level > 76 then
        set level = 76
    endif

    set level = DebuffImmune_Start(u, level)

    if GetUnitAbilityLevel(u, 'B00J') > 0 then  // inori R immune
        set level = 0
    endif
    if LoadInteger(hs, GetHandleId(u), StringHash("erza g2 active")) > 0 and LoadInteger(hs, GetHandleId(u), StringHash("erza g2 type")) == 1 then
        set level = 0
    endif
    if LoadInteger(hs, GetHandleId(u), StringHash("naofumi shield")) == 1 then
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
    endif
endfunction
    function CurseUnit takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if u != null and GetWidgetLife(u)>5 then
        if DummyPlayer[i] == null or GetWidgetLife(DummyPlayer[i]) < 1 then
            set DummyPlayer[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer[i], 'A1OB')
        endif
        set level = DebuffImmune_Start(u, level)
      
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer[i], 'A1OB') == 0 then
                call UnitAddAbility(DummyPlayer[i], 'A1OB')
            endif
            call SetUnitAbilityLevel(DummyPlayer[i], 'A1OB', level)
            call SetUnitFacing(DummyPlayer[i], GAngle(DummyPlayer[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer[i], "curse", u)
        endif
        endif
    endfunction
    function CurseUnit2 takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if u != null and GetWidgetLife(u)>5 then
        if DummyPlayer3[i] == null or GetWidgetLife(DummyPlayer3[i]) < 1 then
            set DummyPlayer3[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer3[i], 'A07L')
        endif
       set level = DebuffImmune_Start(u, level)
        if level > 0 then
            if GetUnitAbilityLevel(DummyPlayer3[i], 'A07L') == 0 then
                call UnitAddAbility(DummyPlayer3[i], 'A07L')
            endif
            call SetUnitAbilityLevel(DummyPlayer3[i], 'A07L', level)
            call SetUnitFacing(DummyPlayer3[i], GAngle(DummyPlayer3[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer3[i], "curse", u)
        endif
        endif
    endfunction
    function CurseUnitHellBlaze takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyDebuff1[i] == null or GetWidgetLife(DummyDebuff1[i]) < 1 then
            set DummyDebuff1[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyDebuff1[i], 'A0E6')
        endif
        set level = DebuffImmune_Start(u, level)
        if level > 0 then
            if GetUnitAbilityLevel(DummyDebuff1[i], 'A0E6') == 0 then
                call UnitAddAbility(DummyDebuff1[i], 'A0E6')
            endif
            call SetUnitAbilityLevel(DummyDebuff1[i], 'A0E6', level)
            call SetUnitFacing(DummyDebuff1[i], GAngle(DummyDebuff1[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyDebuff1[i], "curse", u)
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
    call GroupEnumUnitsInRect(g, REC,  NoDecor_Cond)
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

 function AstaG_MagRes takes unit c returns real
   local integer i = GetHeroLevel(c)
   local real r = AstaG_MagRes6
   if i >=35 then 
   set r = AstaG_MagRes35
   elseif i >= 25 then 
   set r = AstaG_MagRes25
   elseif i >=12 then 
   set r = AstaG_MagRes12
   endif
   set r = 1-(r/100)
   return r
   endfunction
//=====================================================DMG SYSY====================================================================
function DamageBlock takes unit c, unit td, real dmg, integer typedmg, boolean test returns real
    local real dmgbase = dmg
    local real value
    local real armor
    // Суммарный магический резист только от предметов, в процентных пунктах.
    local real itemMagRes = 0.0
    local real maxHp
    local real missingHp
    local real bonus
    local integer level
    local integer stacks
    local integer targetId = GetUnitTypeId(td)
    local integer targetHid = GetHandleId(td)
    local player targetOwner = GetOwningPlayer(td)
    local integer targetPid = GetPlayerId(targetOwner)
    local integer ownerHid = GetHandleId(targetOwner)
    local integer itemSlot
    local integer erzaType
    local boolean isMagic = typedmg == 1
    local boolean isPhysical = typedmg != 1

    // Patriot E РІР‚вЂќ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Р В·Р В° Р Р…Р ВµР Т‘Р С•РЎРѓРЎвЂљР В°РЎР‹РЎвЂ°Р ВµР Вµ Р В·Р Т‘Р С•РЎР‚Р С•Р Р†РЎРЉР Вµ
    if targetId == Patriot_ID and LoadInteger(hs, targetHid, KEY_PATRIOT_E) == 0 then
        set level = GetUnitAbilityLevel(td, PatriotE_ID)

        if level > 0 then
            set maxHp = GetUnitState(td, UNIT_STATE_MAX_LIFE)

            if maxHp > 0.0 then
                set missingHp = 100.0 * (maxHp - GetUnitState(td, UNIT_STATE_LIFE)) / maxHp
                set stacks = R2I(missingHp / PatriotE_MissHpCountPercent)
                set bonus = PatriotE_DmgReductBase + PatriotE_DmgReductStep * (level - 1)
                set dmg = dmg * (1.0 - stacks * bonus / 100.0)
            endif
        endif
    endif

    // Р С›Р В±РЎвЂ°Р С‘Р Вµ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘РЎРЏ Р С•РЎвЂљ Р В±Р В°РЎвЂћРЎвЂћР С•Р Р†
    if GetUnitAbilityLevel(td, 'B02C') > 0 then
        set dmg = dmg * 0.60
    endif
    if GetUnitAbilityLevel(td, RimuruW3_Buff_ID ) > 0 then
        set dmg = dmg * 0.5 
    endif
    if GetUnitAbilityLevel(td, 'B005' ) > 0 then
        set dmg = dmg * 0.9 
    endif
     if AinzF_HasDamageReductionBuff(td)  then
            set dmg = dmg * 0.92
        endif

    // Brandish E
    if GetUnitAbilityLevel(td, BrandishE_Buff1_ID) > 0 then
        set dmg = dmg * 0.92
    elseif GetUnitAbilityLevel(td, BrandishE_Buff2_ID) > 0 then
        set dmg = dmg * 0.90
    elseif GetUnitAbilityLevel(td, BrandishE_Buff3_ID) > 0 then
        set dmg = dmg * 0.88
    elseif GetUnitAbilityLevel(td, BrandishE_Buff4_ID) > 0 then
        set dmg = dmg * 0.86
    elseif GetUnitAbilityLevel(td, BrandishE_Buff5_ID) > 0 then
        set dmg = dmg * 0.84
    endif

    // Patriot F
    if GetUnitAbilityLevel(td, PatriotF_Buff1_ID) > 0 then
        set dmg = dmg * (1.0 - PatriotF_Buff1_Resist / 100.0)
    endif

    if GetUnitAbilityLevel(td, PatriotF_Buff2_ID) > 0 then
        set dmg = dmg * (1.0 - PatriotF_Buff2_Resist / 100.0)
    endif

    // Erza T РІР‚вЂќ Р В±Р В»Р С•Р С” Р С•РЎРѓРЎвЂљР В°Р Р†Р В»Р ВµР Р… Р Т‘Р В»РЎРЏ Р В±РЎС“Р Т‘РЎС“РЎвЂ°Р ВµР С–Р С• РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘РЎРЏ
    if targetId == Erza_ID /*
    */ and LoadInteger(hs, targetHid, KEY_T_ARMOR_ACTIVE) == 1 /*
    */ and not HasShieldPen(c, td) then
        // set dmg = dmg * (1.0 - ErzaT_ArmorStatResistance / 100.0)
    endif

    // Hell Blaze
    // Р вЂ™ РЎР‚Р ВµР В¶Р С‘Р СР Вµ test Р Р…Р ВµР В»РЎРЉР В·РЎРЏ Р Р…Р В°Р С”Р В»Р В°Р Т‘РЎвЂ№Р Р†Р В°РЎвЂљРЎРЉ Р С‘Р В»Р С‘ Р С•Р В±Р Р…Р С•Р Р†Р В»РЎРЏРЎвЂљРЎРЉ Р Т‘Р ВµР В±Р В°РЎвЂћРЎвЂћ.
    if not test  and c != null and HasCachedItem(c, 'I02F') > 0 then
        if GetUnitAbilityLevel(td, 'B02F') > 0 then
            set stacks = 7
        elseif GetUnitAbilityLevel(td, 'B02E') > 0 then
            set stacks = 7
            call UnitRemoveAbility(td, 'B02E')
        elseif GetUnitAbilityLevel(td, 'B01W') > 0 then
            set stacks = 6
            call UnitRemoveAbility(td, 'B01W')
        elseif GetUnitAbilityLevel(td, 'B01V') > 0 then
            set stacks = 5
            call UnitRemoveAbility(td, 'B01V')

        elseif GetUnitAbilityLevel(td, 'B01U') > 0 then
            set stacks = 4
            call UnitRemoveAbility(td, 'B01U')

        elseif GetUnitAbilityLevel(td, 'B01T') > 0 then
            set stacks = 3
            call UnitRemoveAbility(td, 'B01T')

        elseif GetUnitAbilityLevel(td, 'B01S') > 0 then
            set stacks = 2
            call UnitRemoveAbility(td, 'B01S')

        else
            set stacks = 1
        endif

        call CurseUnitHellBlaze(c, td, stacks)
    endif

    // Р РЋРЎвЂљР В°Р С”Р С‘ Р С—РЎР‚Р ВµР Т‘Р СР ВµРЎвЂљР В° I013
    // Р вЂ™ РЎР‚Р ВµР В¶Р С‘Р СР Вµ test Р Р…Р ВµР В»РЎРЉР В·РЎРЏ Р С‘Р В·Р СР ВµР Р…РЎРЏРЎвЂљРЎРЉ РЎС“РЎР‚Р С•Р Р†Р ВµР Р…РЎРЉ Р В±Р В°РЎвЂћРЎвЂћР В°.
    if not test /*
    */ and dmg > 1.0 /*
    */ and (typedmg == 1 or typedmg == 2) /*
    */ and HasCachedItem(td, 'I013') > 0 then

        if GetUnitAbilityLevel(td, 'B00U') > 0 then
            set stacks = 6

        elseif GetUnitAbilityLevel(td, 'B00Q') > 0 then
            set stacks = 6
            call UnitRemoveAbility(td, 'B00Q')

        elseif GetUnitAbilityLevel(td, 'B00P') > 0 then
            set stacks = 5
            call UnitRemoveAbility(td, 'B00P')

        elseif GetUnitAbilityLevel(td, 'B00O') > 0 then
            set stacks = 4
            call UnitRemoveAbility(td, 'B00O')

        elseif GetUnitAbilityLevel(td, 'B00N') > 0 then
            set stacks = 3
            call UnitRemoveAbility(td, 'B00N')

        elseif GetUnitAbilityLevel(td, 'B00M') > 0 then
            set stacks = 2
            call UnitRemoveAbility(td, 'B00M')

        else
            set stacks = 1
        endif

        call BuffUnit2(td, td, stacks)
    endif

    // Р СџР ВµРЎР‚РЎРѓР С•Р Р…Р В°Р В»РЎРЉР Р…РЎвЂ№Р Вµ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘РЎРЏ Р С–Р ВµРЎР‚Р С•Р ВµР Р†
    if targetId == Alucard_ID then
        if LoadInteger(hs, targetHid, KEY_ALUCARD_G3) == 1 then
            set dmg = dmg * 0.95
        endif

    elseif targetId == Takeshi_ID then
        if LoadInteger(hs, targetHid, KEY_MODE_G) == 1 then
            set dmg = dmg * 0.85
        endif
    endif

    // Harribel G2
    if LoadInteger(hs, targetHid, KEY_HARI_G2) == 1 then
        set dmg = dmg * (1.0 - Harribel_Pas_DmgReduct / 100.0)
    endif

    // Р вЂ™Р В°Р СР С—Р С‘РЎР‚Р С‘Р В·Р С Р С‘ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Р С—РЎР‚Р ВµР Т‘Р СР ВµРЎвЂљР В° I00B
    if HasCachedItem(td, 'I00B') > 0 then
        if not test then
            call HPS(td, td, dmg * 0.10, 5.0)
        endif

        // Для магического урона предметный резист войдёт в общий пул ниже.
        // Для физического урона старое поведение предмета сохраняется.
        if isMagic then
            set itemMagRes = itemMagRes + 10.0
        else
            set dmg = dmg * 0.90
        endif
    endif

    // Р В¤Р С‘Р В·Р С‘РЎвЂЎР ВµРЎРѓР С”Р В°РЎРЏ Р Р†Р ВµРЎвЂљР С”Р В°
    if isPhysical then
        set armor = BlzGetUnitArmor(td)

        if armor < 0.0 then
            set armor = 0.0
        endif

        // Формула после применения глобальной эффективности:
        // effectiveArmor = armor * ARMOR_EFFECTIVENESS_PERCENT / 100.0
        // resistance = effectiveArmor / (100.0 + effectiveArmor)
        // damage = damage / (1.0 + effectiveArmor / 100.0)
        // Деление на 10000.0 объединяет два процента:
        // armor / 100.0 и ARMOR_EFFECTIVENESS_PERCENT / 100.0.
        set value = ARMOR_EFFECTIVENESS_PERCENT

        if value < 0.0 then
            set value = 0.0
        endif

        set armor = armor * value / 10000.0
        set dmg = dmg / (1.0 + armor)

        // Р вЂќР С•Р С—Р С•Р В»Р Р…Р С‘РЎвЂљР ВµР В»РЎРЉР Р…Р С•Р Вµ РЎвЂћР С‘Р В·Р С‘РЎвЂЎР ВµРЎРѓР С”Р С•Р Вµ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ
        set value = LoadReal(hs, targetHid, KEY_PHYS_RES)

        if value > 0.0 then
            if value > 1.0 then
                set value = 1.0
            endif

            set dmg = dmg * (1.0 - value)
        endif

        // Р С’Р С”РЎвЂљР С‘Р Р†Р Р…Р С•Р Вµ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Blue Emperor
        if LoadInteger(hs, targetHid, KEY_BLUE_EMPEROR_RES) == 1 then
            set dmg = dmg * 0.75
        endif

        // Р С’Р С”РЎвЂљР С‘Р Р†Р В°РЎвЂ Р С‘РЎРЏ Blue Emperor
        if not test /*
        */ and dmg >= 200.0 /*
        */ and HasCachedItem(td, 'I00X') > 0 /*
        */ and BlzGetUnitAbilityCooldownRemaining(td, 'A04Q') == 0.0 then

            set dmg = dmg * 0.70

            call SaveInteger(hs, targetHid, KEY_BLUE_EMPEROR_RES, 1)
            call MyFlush(targetHid, KEY_BLUE_EMPEROR_RES, 0, 5.0)
            call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_sacred guard blue.mdl", td, "chest"), 5.0)
            call BlzStartUnitAbilityCooldown(td, 'A04Q', 25.0)
        endif

        // Р вЂ”Р В°РЎвЂ°Р С‘РЎвЂљР В° dummy-РЎР‹Р Р…Р С‘РЎвЂљР С•Р Р† Kenjaku
        if targetId == KenjakuE2_Dummy_ID then
            if GetUnitAbilityLevel(Hero[targetPid], KenjakuE_ID) >= 5 then
                set dmg = dmg * 0.60
            endif

        elseif targetId == KenjakuQ2_Dummy_ID then
            if GetUnitAbilityLevel(Hero[targetPid], KenjakuQ_ID) >= 5 then
                set dmg = dmg * 0.60
            endif

        elseif targetId == KenjakuW2_Dummy_ID then
            if GetUnitAbilityLevel(Hero[targetPid], KenjakuW_ID) >= 5 then
                set dmg = dmg * 0.80
            endif
        endif

        // Akainu
        if targetId == Akainu_ID and GetHeroLevel(td) >= 12 then
            set dmg = dmg * 0.85
        endif

        // I00J: РїСЂРѕР±РёРІР°РµС‚ РІСЃРµ С„РёР·РёС‡РµСЃРєРёРµ СЂРµР·РёСЃС‚С‹, СЂР°СЃСЃС‡РёС‚Р°РЅРЅС‹Рµ РІС‹С€Рµ,
// РЅРѕ B00S РїСЂРёРјРµРЅСЏРµС‚СЃСЏ СѓР¶Рµ РїРѕСЃР»Рµ РїСЂРѕР±РёС‚РёСЏ.
if c != null and HasCachedItem(c, 'I00J') > 0 and dmg < dmgbase then
    set dmg = dmg + (dmgbase - dmg) * (KanshoandBakuya_Decrease / 100.0)
endif

// Дебафф Ainz T уменьшает итоговое физическое сопротивление цели на 30%.

        if (GetUnitAbilityLevel(td, 'B00S') > 0) /*
        */ and dmg < dmgbase then

            set value = dmg / dmgbase

            if value >= (1-(Nichirin_Decrease /100) )   then
                set dmg = dmgbase
            else
                set dmg = dmgbase * (value + (Nichirin_Decrease /100))
            endif
        endif
    if GetUnitAbilityLevel(td, AinzT_Debuff_ID) > 0 and dmg < dmgbase then
         set value = dmg / dmgbase

            if value >= (1-(AinzT_ResistReduce/100) ) then
                set dmg = dmgbase
            else
                set dmg = dmgbase * (value + (AinzT_ResistReduce/100))
            endif
    endif
    endif

    // Р СљР В°Р С–Р С‘РЎвЂЎР ВµРЎРѓР С”Р В°РЎРЏ Р Р†Р ВµРЎвЂљР С”Р В°
    if isMagic then
        // Asta G
        if targetId == Asta_ID and GetHeroLevel(td) >= 6 then
            set dmg = dmg * AstaG_MagRes(td)
        endif
            if GetUnitAbilityLevel(td, 'B02Y') > 0 then
            set dmg = dmg * (1-(ChogurtEvolved_DmgReduct/100))
            elseif GetUnitAbilityLevel(td, 'B02Q') > 0 then
            set dmg = dmg * (1-(Chogurt_DmgReduct/100))
            endif
        // Harribel E
        if GetUnitAbilityLevel(td, HarribelE_Regen1_ID) > 0 then
            set dmg = dmg * 0.96
        elseif GetUnitAbilityLevel(td, HarribelE_Regen2_ID) > 0 then
            set dmg = dmg * 0.94
        elseif GetUnitAbilityLevel(td, HarribelE_Regen3_ID) > 0 then
            set dmg = dmg * 0.92
        elseif GetUnitAbilityLevel(td, HarribelE_Regen4_ID) > 0 then
            set dmg = dmg * 0.90
        elseif GetUnitAbilityLevel(td, HarribelE_Regen5_ID) > 0 then
            set dmg = dmg * 0.88
        endif

        // Р РЋР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Р С•РЎвЂљ РЎРѓРЎвЂљР В°Р С”Р С•Р Р† I013
        if GetUnitAbilityLevel(td, 'B00U') > 0 then
            set itemMagRes = itemMagRes + 24.0
        elseif GetUnitAbilityLevel(td, 'B00Q') > 0 then
            set itemMagRes = itemMagRes + 20.0
        elseif GetUnitAbilityLevel(td, 'B00P') > 0 then
            set itemMagRes = itemMagRes + 16.0
        elseif GetUnitAbilityLevel(td, 'B00O') > 0 then
            set itemMagRes = itemMagRes + 12.0
        elseif GetUnitAbilityLevel(td, 'B00N') > 0 then
            set itemMagRes = itemMagRes + 8.0
        elseif GetUnitAbilityLevel(td, 'B00M') > 0 then
            set itemMagRes = itemMagRes + 4.0
        endif

        // Р вЂќР С•Р С—Р С•Р В»Р Р…Р С‘РЎвЂљР ВµР В»РЎРЉР Р…Р С•Р Вµ Р СР В°Р С–Р С‘РЎвЂЎР ВµРЎРѓР С”Р С•Р Вµ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ
        set value = LoadReal(hs, targetHid, KEY_MAG_RES)

        if value > 0.0 then
            if value > 1.0 then
                set value = 1.0
            endif

            set dmg = dmg * (1.0 - value)
        endif

        // Р С›Р В±РЎвЂ°Р ВµР Вµ Р СР В°Р С–Р С‘РЎвЂЎР ВµРЎРѓР С”Р С•Р Вµ РЎРѓР С•Р С—РЎР‚Р С•РЎвЂљР С‘Р Р†Р В»Р ВµР Р…Р С‘Р Вµ Р С•РЎвЂљ РЎС“РЎР‚Р С•Р Р†Р Р…РЎРЏ
        set level = GetHeroLevel(td)

        if level >= 35 then
            set dmg = dmg * 0.85
        elseif level >= 24 then
            set dmg = dmg * 0.9
        elseif level >= 12 then
            set dmg = dmg * 0.95
        endif

        // Inori E
        if GetUnitAbilityLevel(td, InoriE_Aura_ID) > 0 then
            set dmg = dmg * (1.0 - InoriE_DmgMagResistFromPas / 100.0)
        endif

        // Р вЂ”Р В°РЎвЂ°Р С‘РЎвЂљР В° dummy-РЎР‹Р Р…Р С‘РЎвЂљР С•Р Р† Kenjaku
        if targetId == KenjakuE2_Dummy_ID then
            if GetUnitAbilityLevel(Hero[targetPid], KenjakuE_ID) >= 5 then
                set dmg = dmg * 0.60
            endif

        elseif targetId == KenjakuW2_Dummy_ID then
            if GetUnitAbilityLevel(Hero[targetPid], KenjakuW_ID) >= 5 then
                set dmg = dmg * 0.60
            endif

        elseif targetId == KenjakuQ2_Dummy_ID then
            if GetUnitAbilityLevel(Hero[targetPid], KenjakuQ_ID) >= 5 then
                set dmg = dmg * 0.80
            endif
        endif

        // Р СџРЎР‚Р С•РЎвЂЎР С‘Р Вµ Р СР В°Р С–Р С‘РЎвЂЎР ВµРЎРѓР С”Р С‘Р Вµ Р СР С•Р Т‘Р С‘РЎвЂћР С‘Р С”Р В°РЎвЂљР С•РЎР‚РЎвЂ№
        if c != null and GetUnitAbilityLevel(c, 'B00E') > 0 then
            set dmg = dmg * 0.65
        endif
        
         
        if GetUnitAbilityLevel(td, 'B00C') > 0 then
            set dmg = dmg * 0.60
        endif

        if targetId == Natsu_ID and GetUnitCurrentOrder(td) == OrderId("creepheal") then
            set dmg = dmg * 0.75
        endif

        if HasCachedItem(td, 'I00K') > 0 then
            set itemMagRes = itemMagRes + 10.0
        endif

        if HasCachedItem(td, 'I00L') > 0 then
            set itemMagRes = itemMagRes + 20.0
        endif

        if HasCachedItem(td, 'I020') > 0 then
            set itemMagRes = itemMagRes + 20.0
        endif

        // Та же модель убывающей полезности, что и у брони:
        // damage = damage / (1.0 + totalItemMagicResistance / 100.0)
        // Итоговое снижение = R / (100.0 + R), где R — сумма предметного магрезиста.
        if itemMagRes > 0.0 then
            set dmg = dmg / (1.0 + itemMagRes / 100.0)
        endif

        if GetUnitAbilityLevel(td, 'A019') > 0 then
            set dmg = dmg * 0.82
        endif

       // I00R: РїСЂРѕР±РёРІР°РµС‚ РІСЃРµ РјР°РіРёС‡РµСЃРєРёРµ СЂРµР·РёСЃС‚С‹, СЂР°СЃСЃС‡РёС‚Р°РЅРЅС‹Рµ РІС‹С€Рµ,
// РЅРѕ B00R РїСЂРёРјРµРЅСЏРµС‚СЃСЏ СѓР¶Рµ РїРѕСЃР»Рµ РїСЂРѕР±РёС‚РёСЏ.
if c != null and HasCachedItem(c, 'I00R') > 0 and dmg < dmgbase then
    set dmg = dmg + (dmgbase - dmg) * (KazekageHat_Decrease / 100.0)
endif

// Дебафф Ainz T уменьшает итоговое магическое сопротивление цели на 30%.

        if (GetUnitAbilityLevel(td, 'B00R') > 0) /*
        */ and dmg < dmgbase then

            set value = dmg / dmgbase

            if value >= (1-(TrueZangetsu_Decrease/100) ) then
                set dmg = dmgbase
            else
                set dmg = dmgbase * (value + (TrueZangetsu_Decrease/100))
            endif
        endif
         if GetUnitAbilityLevel(td, AinzT_Debuff_ID) > 0 and dmg < dmgbase then
         set value = dmg / dmgbase

            if value >= (1-(AinzT_ResistReduce/100) ) then
                set dmg = dmgbase
            else
                set dmg = dmgbase * (value + (AinzT_ResistReduce/100))
            endif
    endif
    endif
   
    // Erza G2
    if targetId == Erza_ID and LoadInteger(hs, targetHid, KEY_ERZA_G2_ACTIVE) > 0 then
        set erzaType = LoadInteger(hs, targetHid, KEY_ERZA_G2_TYPE)

        if erzaType == 1 and isMagic then
            set dmg = dmg * (1.0 - Erza6_MagicalDmgResist / 100.0)

        elseif erzaType == 2 and isPhysical then
            set dmg = dmg * (1.0 - Erza7_PhysicalDmgResist / 100.0)
        endif
    endif

   
    
    // Tomioka F
    if  LoadInteger(hs, ownerHid, KEY_TOMIOKA_F_INVUL) == 1 then
        if test then
            set dmg = 0.0
        else
            set dmg = LustSin(c, td, dmg)
            call SaveInteger(hs, targetHid, KEY_TOMIOKA_F_DMG_ACT, 1)
        endif
    endif
    if GetUnitAbilityLevel(td,'B02G')>0 then
        if test then
            set dmg = 0.0
        else
            set dmg = LustSin(c, td, dmg)
        endif
    endif

    // Turbo Neko
    if GetUnitAbilityLevel(td, TurboNeko_Invul_ID) > 0 then
        if test then
            set dmg = 0.0
        else
            set dmg = LustSin(c, td, dmg)
        endif
    endif

    // Cup of Tea
    set itemSlot = IsItemInInventory3(td, 'I00M')

    if itemSlot >= 0 /*
    */ and BlzGetUnitAbilityCooldownRemaining(td, 'A01W') == 0.0 /*
    */ and LoadInteger(hs, ownerHid, KEY_ZERO_KAI) == 0 /*
    */ and dmg >= GetItemCharges(UnitItemInSlot(td, itemSlot)) then

        if test then
            set dmg = 0.0
        else
            set dmg = LustSin(c, td, dmg)

            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_teaeff.mdl", td, "chest"))
            call BlzStartUnitAbilityCooldown(td, 'A01W', CupOfTea_CD)
            call UnitRemoveAbility(td, 'A07Q')
            call MyRemoveAbility(td, CupOfTea_CD, 'A07Q', 0)
        endif
    endif

    set targetOwner = null

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
function GetAinzItemGoldCost takes unit c returns real
    if c == null then
        return 0.00
    endif
    return goldcost[GetPlayerId(GetOwningPlayer(c))]
endfunction

function DamageCheck takes unit c, unit td, real dmg, integer typedmg returns real
    local integer sourceId = GetUnitTypeId(c)
    local integer sourceHid = GetHandleId(c)
    local integer level
    local integer stacks = 0
    local real maxHp
    local real missingHp
    local real value
    local real bonus
    local real multiplier
    local integer targetId = GetUnitTypeId(td)
    local integer i = GetPlayerId(GetOwningPlayer(c))
    // Patriot E РІР‚вЂќ РЎС“Р Р†Р ВµР В»Р С‘РЎвЂЎР ВµР Р…Р С‘Р Вµ РЎС“РЎР‚Р С•Р Р…Р В° Р В·Р В° Р Р…Р ВµР Т‘Р С•РЎРѓРЎвЂљР В°РЎР‹РЎвЂ°Р ВµР Вµ Р В·Р Т‘Р С•РЎР‚Р С•Р Р†РЎРЉР Вµ
    if sourceId == Patriot_ID and LoadInteger(hs, sourceHid, KEY_PATRIOT_E) == 1 then
        set level = GetUnitAbilityLevel(c, PatriotE_ID)

        if level > 0 then
            set maxHp = GetUnitState(c, UNIT_STATE_MAX_LIFE)

            if maxHp > 0.0 then
                set missingHp = 100.0 * (maxHp - GetUnitState(c, UNIT_STATE_LIFE)) / maxHp
                set stacks = R2I(missingHp / PatriotE_MissHpCountPercent)
                set value = PatriotE_DmgBonusBase + PatriotE_DmgBonusStep * (level - 1)
                set dmg = dmg * (1.0 + stacks * value / 100.0)
            endif
        endif
    endif
    if GetUnitAbilityLevel(c,BrandishF_Buff_ID)>0 then //LoadInteger(hs, sourceHid, StringHash("brandish g ally")) > 0 then
        set dmg = dmg + (dmg * (BrandishF_DamageOutputIncrease / 100))
    endif
    if GetUnitAbilityLevel(c,BrandishF_Debuff_ID)>0 then//LoadInteger(hs, sourceHid, StringHash("brandish g enemy")) > 0 then
        set dmg = dmg - (dmg * (BrandishF_DamageOutputDecrease / 100))
    endif
     if sourceId == Ainz_ID and  GetAinzItemGoldCost(c) > 20000.00 then
   set bonus = I2R(R2I((goldcost[i] - 20000.00) / 1000.00)) * 0.01
   set dmg = dmg + (dmg*bonus)
    endif
    // Alucard T
    if sourceId == Alucard_ID then
        if GetUnitAbilityLevel(td, AlucardT_Buff_ID) > 0 then
            set dmg = dmg * (1.0 + AlucardT_AdditionalDamageToTarget / 100.0)
        endif

        if GetUnitAbilityLevel(td, AlucardT2_Buff_ID) > 0 then
            set multiplier = AlucardT_AdditionalDamageToTarget * AlucardT2_PercentageCrumwell / 10000.0
            set dmg = dmg * (1.0 + multiplier)
        endif

        // Alucard G2 РЎР‚Р В°Р В±Р С•РЎвЂљР В°Р ВµРЎвЂљ РЎвЂљР С•Р В»РЎРЉР С”Р С• Р Т‘Р В»РЎРЏ typedmg == 2
        if typedmg == 2 and LoadInteger(hs, sourceHid, KEY_ALUCARD_G2) == 1 then
            set dmg = dmg * 1.05
        endif
    endif

    // Р В¤Р С‘Р В·Р С‘РЎвЂЎР ВµРЎРѓР С”Р С‘Р в„– РЎС“РЎР‚Р С•Р Р… typedmg == 2
    if typedmg == 2 then
        if HasCachedItem(c, 'I010') > 0 and GetMainStatAgi(c) then
            set dmg = dmg * 1.1
        endif

        if HasCachedItem(c, 'I01C') > 0 then
            set dmg = dmg * 1.1
        endif

        if HasCachedItem(c, 'I00T') > 0 then
            set dmg = dmg * 1.15
        endif
    endif

    // Р СљР С•Р Т‘Р С‘РЎвЂћР С‘Р С”Р В°РЎвЂљР С•РЎР‚РЎвЂ№ Р С•Р В±РЎвЂ№РЎвЂЎР Р…Р С•Р С–Р С•/РЎвЂћР С‘Р В·Р С‘РЎвЂЎР ВµРЎРѓР С”Р С•Р С–Р С• РЎС“РЎР‚Р С•Р Р…Р В°
    if typedmg == 0 or typedmg == 2 then
        if GetUnitAbilityLevel(c, PatriotW_Buff21_ID) > 0 then
            set dmg = dmg * 1.04
        endif

        if GetUnitAbilityLevel(c, PatriotW_Buff22_ID) > 0 then
            set dmg = dmg * 1.06
        endif

        if GetUnitAbilityLevel(c, PatriotW_Buff23_ID) > 0 then
            set dmg = dmg * 1.08
        endif

        if GetUnitAbilityLevel(c, PatriotW_Buff24_ID) > 0 then
            set dmg = dmg * 1.10
        endif

        if GetUnitAbilityLevel(c, PatriotW_Buff25_ID) > 0 then
            set dmg = dmg * 1.12
        endif

        if GetUnitAbilityLevel(td, ErzaWape_ID) > 0 then
            set dmg = dmg * (1.0 + ErzaWape_IncreaseDmg / 100.0)
        endif
    endif

    // Р СљР В°Р С–Р С‘РЎвЂЎР ВµРЎРѓР С”Р С‘Р в„– РЎС“РЎР‚Р С•Р Р…
    if typedmg == 1 then
        if HasCachedItem(c, 'I01C') > 0 and GetMainStatInt(c) then
            set dmg = dmg * 1.1
        endif
        if AinzF_HasMagicDamageBuff (c) then
            set dmg = dmg * 1.08
        endif
        if HasCachedItem(c, 'I01B') > 0 then
            set dmg = dmg * 1.15
        endif

        if HasCachedItem(c, 'I010') > 0 then
            set dmg = dmg * 1.1
        endif
    endif

    // Neuvillette F
    if sourceId == Neuvillette_ID then
        if GetUnitAbilityLevel(td, 'B009') > 0 or GetUnitAbilityLevel(td, 'B007') > 0 or GetUnitAbilityLevel(td, 'B00B') > 0 then
            set multiplier = NeuvilletteF_DamageAdd

            if GetHeroLevel(c) >= 35 then
                set multiplier = multiplier + NeuvilletteF_DamageAdd35
            endif

            set dmg = dmg * (1.0 + multiplier / 100.0)
        endif
    endif

    // Mahoraga T
// td РІР‚вЂќ Р С—Р С•Р В»РЎС“РЎвЂЎР В°РЎР‹РЎвЂ°Р С‘Р в„– РЎС“РЎР‚Р С•Р Р… Mahoraga.
// c РІР‚вЂќ Р В°РЎвЂљР В°Р С”РЎС“РЎР‹РЎвЂ°Р С‘Р в„–, Р Р…Р В° Р С”Р С•РЎвЂљР С•РЎР‚Р С•Р С Р Р…Р В°РЎвЂ¦Р С•Р Т‘РЎРЏРЎвЂљРЎРѓРЎРЏ РЎРѓРЎвЂљР В°Р С”Р С‘ Р Т‘Р ВµР В±Р В°РЎвЂћРЎвЂћР В°.

if targetId == Mahoraga_ID then
    set stacks = 0

    if GetUnitAbilityLevel(c, MahoragaT_Abi_ID8) > 0 then
        set stacks = 8
    elseif GetUnitAbilityLevel(c, MahoragaT_Abi_ID7) > 0 then
        set stacks = 7
    elseif GetUnitAbilityLevel(c, MahoragaT_Abi_ID6) > 0 then
        set stacks = 6
    elseif GetUnitAbilityLevel(c, MahoragaT_Abi_ID5) > 0 then
        set stacks = 5
    elseif GetUnitAbilityLevel(c, MahoragaT_Abi_ID4) > 0 then
        set stacks = 4
    elseif GetUnitAbilityLevel(c, MahoragaT_Abi_ID3) > 0 then
        set stacks = 3
    elseif GetUnitAbilityLevel(c, MahoragaT_Abi_ID2) > 0 then
        set stacks = 2
    elseif GetUnitAbilityLevel(c, MahoragaT_Abi_ID1) > 0 then
        set stacks = 1
    endif

    if stacks > 0 then
        set dmg = dmg * (1.0 - stacks * MahoragaT_DamageReductionPerStack / 100.0)
    endif
endif

    return dmg
endfunction

function SetActiveDonat takes integer pid, integer donatType, integer variant returns nothing
    set ActiveDonatType[pid] = donatType
    set ActiveDonatVariant[pid] = variant
endfunction

function DestroyHeroDonatEffects takes integer pid returns nothing
    call DestroyEffect(AttachDonat1[pid])
    call DestroyEffect(AttachDonat2[pid])
    call DestroyEffect(AttachDonat3[pid])
    call DestroyEffect(AttachDonat4[pid])
    set AttachDonat1[pid] = null
    set AttachDonat2[pid] = null
    set AttachDonat3[pid] = null
    set AttachDonat4[pid] = null
endfunction

function ClearCloneDonatEffect takes unit u returns nothing
    local integer hid = GetHandleId(u)
    local effect e = LoadEffectHandle(CloneVisualCache, hid, 0)
    if e != null then
        call DestroyEffect(e)
        call RemoveSavedHandle(CloneVisualCache, hid, 0)
    endif
    set e = null
endfunction

function ClearClonePassiveEffects takes unit u returns nothing
    local integer hid = GetHandleId(u)
    local integer count = LoadInteger(CloneVisualCache, hid, 1)
    local integer index = 0
    local effect e
    loop
        exitwhen index >= count
        set e = LoadEffectHandle(CloneVisualCache, hid, 10 + index)
        if e != null then
            call DestroyEffect(e)
            call RemoveSavedHandle(CloneVisualCache, hid, 10 + index)
        endif
        set index = index + 1
    endloop
    call SaveInteger(CloneVisualCache, hid, 1, 0)
    set e = null
endfunction

function ClearCloneVisualEffects takes unit u returns nothing
    call ClearCloneDonatEffect(u)
    call ClearClonePassiveEffects(u)
endfunction

function AddTrackedCloneEffect takes unit u, string model, string attach returns effect
    local integer hid = GetHandleId(u)
    local integer count = LoadInteger(CloneVisualCache, hid, 1)
    local effect e = AddSpecialEffectTarget(model, u, attach)
    call SaveEffectHandle(CloneVisualCache, hid, 10 + count, e)
    call SaveInteger(CloneVisualCache, hid, 1, count + 1)
    return e
endfunction

function CreateDonatEffect takes unit u, integer pid, integer donatType, integer variant returns effect
    if donatType == 1 then
        if VIPCheckLvl2(FramePlayerFirstName[pid]) or VIPCheckLvl3(FramePlayerFirstName[pid]) then
            if variant == 0 then
                return AddSpecialEffectTarget("war3mapimported\\wos_scghmx (6).mdx", u, "origin")
            elseif variant == 1 then
                return AddSpecialEffectTarget("war3mapimported\\wos_scghmx (9).mdx", u, "origin")
            elseif variant == 2 then
                return AddSpecialEffectTarget("war3mapimported\\wos_firet1_aura.mdl", u, "origin")
            endif
        elseif VIPCheckLvl1(FramePlayerFirstName[pid]) then
            return AddSpecialEffectTarget("war3mapImported\\wos_scghmx (9).mdl", u, "origin")
        endif
    elseif donatType == 2 then
        if VIPCheckLvl3(FramePlayerFirstName[pid]) then
            if variant == 0 then
                return AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san01.mdx", u, "origin")
            elseif variant == 1 then
                return AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san02.mdx", u, "origin")
            elseif variant == 2 then
                return AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san03.mdx", u, "origin")
            elseif variant == 3 then
                return AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san04.mdx", u, "origin")
            endif
        elseif VIPCheckLvl2(FramePlayerFirstName[pid]) then
            return AddSpecialEffectTarget("war3mapImported\\wos_scghmx (6).mdl", u, "origin")
        endif
    elseif donatType == 3 then
        if VIPCheckLvl3(FramePlayerFirstName[pid]) then
            if variant == 0 then
                return AddSpecialEffectTarget("war3mapImported\\wos_ncow_sfx_sharingan3tomoe.mdx", u, "origin")
            elseif variant == 1 then
                return AddSpecialEffectTarget("war3mapimported\\wos_sharin_mad.mdx", u, "origin")
            elseif variant == 2 then
                return AddSpecialEffectTarget("war3mapimported\\wos_sharin_ita.mdx", u, "origin")
            elseif variant == 3 then
                return AddSpecialEffectTarget("war3mapimported\\wos_sharin_sas.mdx", u, "origin")
            elseif variant == 4 then
                return AddSpecialEffectTarget("war3mapimported\\wos_sharin_kak.mdx", u, "origin")
            endif
        else
            return AddSpecialEffectTarget("war3mapImported\\wos_ncow_sfx_sharingan3tomoe.mdx", u, "origin")
        endif
    elseif donatType == 4 then
        return AddSpecialEffectTarget("war3mapImported\\wos_raidensymbol.mdx", u, "origin")
    endif
    return null
endfunction

function FixAura2 takes unit c returns nothing
    local integer pid
    local integer hid
    local integer donatType
    local integer variant
    local effect e
    if c == null then
        return
    endif
    set pid = GetPlayerId(GetOwningPlayer(c))
    set hid = GetHandleId(c)
    set donatType = ActiveDonatType[pid]
    set variant = ActiveDonatVariant[pid]
    if c == Hero[pid] then
        call DestroyHeroDonatEffects(pid)
        if donatType > 0 then
            set e = CreateDonatEffect(c, pid, donatType, variant)
            if donatType == 1 then
                set AttachDonat1[pid] = e
            elseif donatType == 2 then
                set AttachDonat2[pid] = e
            elseif donatType == 3 then
                set AttachDonat3[pid] = e
            elseif donatType == 4 then
                set AttachDonat4[pid] = e
            endif
        endif
    else
        call ClearCloneDonatEffect(c)
        if donatType > 0 then
            set e = CreateDonatEffect(c, pid, donatType, variant)
            if e != null then
                call SaveEffectHandle(CloneVisualCache, hid, 0, e)
            endif
        endif
    endif
    set e = null
endfunction

function FixHeroPas takes unit c returns nothing
    local integer id = GetUnitTypeId(c)
    local integer pid = GetPlayerId(GetOwningPlayer(c))
    local integer check = 0
    local integer heroHid
    local real x = GetUnitX(c)
    local real y = GetUnitY(c)
    local unit hero = Hero[pid]
    local effect e
    if hero == null then
        return
    endif
    set heroHid = GetHandleId(hero)
    if id == Okarun_ID and GetHeroLevel(hero) >= 6 then
        call AddTrackedCloneEffect(c, "war3mapimported\\wos_windwalk blood.mdx", "origin")
    elseif id == Inori_ID and GetHeroLevel(hero) >= 6 then
        if LoadInteger(hs, heroHid, StringHash("mode t")) == 0 then
            if LoadInteger(hs, heroHid, StringHash("Inori E Active")) == 0 then
                set e = AddTrackedCloneEffect(c, "war3mapImported\\wos_Inori_Bar.mdl", "origin")
                set check = LoadInteger(hs, heroHid, StringHash("Inori E"))
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
                call AddTrackedCloneEffect(c, "war3mapimported\\Wos_InoriCrystall_atch.mdx", "hand right")
                call AddTrackedCloneEffect(c, "war3mapimported\\Wos_InoriCrystall_atch.mdx", "hand left")
            endif
        else
            call AddTrackedCloneEffect(c, "war3mapImported\\wos_file00002900.mdl", "origin")
        endif
    elseif id == AlterSaber_ID and LoadInteger(hs, heroHid, StringHash("saber w")) == 1 then
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_saber_attach.mdl", "weapon")
    elseif id == Harribel_ID and GetUnitAbilityLevel(hero, 'A0B0') > 0 then
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_Shio_Super_Saiyan_JN_SS-2_2.mdl", "origin")
    elseif id == Kirito_ID and GetUnitAbilityLevel(hero, KiritoR_AS) > 0 then
        call AddUnitAnimationProperties(c, "alternate", true)
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_aurapartblue.mdx", "origin")
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_JN_22blue.mdx", "chest")
    elseif id == Tsuna_ID and LoadInteger(hs, heroHid, StringHash("mode g")) == 1 then
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_tsunaaura.mdl", "origin")
    elseif id == Rimuru_ID and (GetUnitAbilityLevel(c, RimuruG3_AgiBonus_ID) > 0 or GetUnitAbilityLevel(c, RimuruG3_IntBonus_ID) > 0) then
        call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_BDEF (2313).mdx", c, "origin"), 15)
        call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_blackwhiteaura_3.mdx", c, "origin"), 15)
    elseif id == Raiden_ID and LoadInteger(hs, heroHid, StringHash("raiden t")) == 1 then
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdl", "origin")
        call AddUnitAnimationProperties(c, "alternate", true)
    elseif id == Natsu_ID then
        if LoadInteger(hs, heroHid, StringHash("mode g")) == 1 then
            call EUTU2(EffectSpawn("war3mapImported\\wos_Raienryuu no Houkou.mdl", x, y, 1, 1, 1.35, 125), 15, 125, c)
            call EUTU2(EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, 1, 0.35, 0.5, 15), 15, 15, c)
            call EUTU2(EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, 90, 0.35, 0.4, 125), 125, 1, c)
        endif
        if GetUnitAbilityLevel(hero, NatsuF_Stats_ID) > 0 then
            call AddTrackedCloneEffect(c, "war3mapImported\\wos_by_wood_effect_order_dange_dbz_chaosaiguanghuan_1_3.mdl", "origin")
        endif
    elseif id == Erza_ID and LoadInteger(hs, heroHid, StringHash("q armor active")) == 1 and LoadInteger(hs, heroHid, StringHash("fire armor pas")) == 1 then
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_buff_fire_big2.mdx", "weapon")
    elseif id == Gojo_ID and LoadInteger(hs, heroHid, StringHash("gojo e")) == 1 then
        if GetUnitAbilityLevel(hero, GojoE_ID) >= 3 then
            call EUTU2(EffectSpawn("war3mapimported\\wos_obr08 (479).mdl", x, y, GetRandomReal(0, 359), 0.5, 1.55, 1), 15, 3, c)
        endif
        call AddTrackedCloneEffect(c, "war3mapimported\\wos_GojoEye1.mdl", "origin")
    elseif id == Tomioka_ID and LoadInteger(hs, heroHid, StringHash("tomioka add dmg")) == 1 then
        call AddTrackedCloneEffect(c, "war3mapImported\\wos_aurapartblue.mdl", "origin")
    endif
    set hero = null
    set e = null
endfunction

function GetCloneSkin takes unit hero returns integer
    if GetUnitTypeId(hero) == Rimuru_ID then
        if GetUnitAbilityLevel(hero, RimuruQ3_ID) > 0 then
            return Rimuru3_ID
        elseif GetUnitAbilityLevel(hero, RimuruW2_ID) > 0 then
            return Rimuru2_ID
        endif
    endif
    return BlzGetUnitSkin(hero)
endfunction





function TransformCloneFilter takes nothing returns boolean
    local unit u = GetFilterUnit()
    local boolean result = u != TransformFilterHero /*
    */ and GetUnitTypeId(u) == TransformFilterHeroId /*
    */ and IsUnitIllusion(u)
    set u = null
    return result
endfunction
function TransformPreloadUnit takes integer unitId returns nothing
    local unit u = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), unitId, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 0.0)
    call ShowUnit(u, false)
    call RemoveUnit(u)
    set u = null
endfunction

// Creates/removes temporary units during loading. This moves the first
// model/texture load away from the first combat transformation.
function PreloadTransformSkins takes nothing returns nothing
    // Erza base + Q/W/E/R/T/G1/G2 armors.
    call TransformPreloadUnit('H00H')
    call TransformPreloadUnit('H00I')
    call TransformPreloadUnit('H00J')
    call TransformPreloadUnit('H00K')
    call TransformPreloadUnit('H00L')
    call TransformPreloadUnit('H00M')
    call TransformPreloadUnit('H00Q')
    call TransformPreloadUnit('H00R')

    // Barragan base/E morph.
    call TransformPreloadUnit('H01R')
    call TransformPreloadUnit('H01S')

    // Starrk base/E morph.
    call TransformPreloadUnit('H01X')
    call TransformPreloadUnit('H01Y')

    // Common effects created/recreated by transforms and FixAura.
    call Preload("war3mapimported\\wos_[dz.spell]002_blue5.mdl")
    call Preload("war3mapimported\\wos_dustwave222.mdx")
    call Preload("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdx")

    // Donation attachments recreated by FixAura2.
    call Preload("war3mapimported\\wos_scghmx (6).mdx")
    call Preload("war3mapimported\\wos_scghmx (9).mdx")
    call Preload("war3mapimported\\wos_firet1_aura.mdl")
    call Preload("war3mapimported\\wos_qpanda_putong_san01.mdx")
    call Preload("war3mapimported\\wos_qpanda_putong_san02.mdx")
    call Preload("war3mapimported\\wos_qpanda_putong_san03.mdx")
    call Preload("war3mapimported\\wos_qpanda_putong_san04.mdx")
    call Preload("war3mapimported\\wos_ncow_sfx_sharingan3tomoe.mdx")
    call Preload("war3mapimported\\wos_sharin_mad.mdx")
    call Preload("war3mapimported\\wos_sharin_ita.mdx")
    call Preload("war3mapimported\\wos_sharin_sas.mdx")
    call Preload("war3mapimported\\wos_sharin_kak.mdx")
    call Preload("war3mapimported\\wos_raidensymbol.mdx")
endfunction

function InitTransformVisualOptimization takes nothing returns nothing
    if TransformCloneFilterExpr == null then
        set TransformCloneFilterExpr = Condition(function TransformCloneFilter)
    endif
    call PreloadTransformSkins()
endfunction

// Replace SetIllusionColor. The original loops over 12 players although only
// GetLocalPlayer matters on each client.
function SetIllusionColor takes unit illusion, player owner returns nothing
    local player viewer = GetLocalPlayer()
    if viewer == owner or IsPlayerAlly(viewer, owner) then
        call SetUnitVertexColor(illusion, 100, 200, 255, 100)
    else
        call SetUnitVertexColor(illusion, 255, 255, 255, 255)
    endif
    set viewer = null
endfunction

// Replace FixModel. One permanent group and one cached filter replace
// CreateGroup/DestroyGroup plus enumeration of every owned summon.
function FixModel takes unit hero returns nothing
    local integer pid
    local integer revision
    local integer skin
    local integer cloneHid
    local player owner
    local unit clone

    if hero == null then
        return
    endif

    set owner = GetOwningPlayer(hero)
    set pid = GetPlayerId(owner)
    set revision = HeroCloneRevision[pid]
    set skin = GetCloneSkin(hero)
    set TransformFilterHero = hero
    set TransformFilterHeroId = GetUnitTypeId(hero)

    call GroupClear(TransformCloneEnumGroup)
    call GroupEnumUnitsOfPlayer(TransformCloneEnumGroup, owner, TransformCloneFilterExpr)

    loop
        set clone = FirstOfGroup(TransformCloneEnumGroup)
        exitwhen clone == null
        call GroupRemoveUnit(TransformCloneEnumGroup, clone)
        set cloneHid = GetHandleId(clone)

        if not LoadBoolean(CloneVisualCache, cloneHid, 2) /*
        */ or LoadInteger(CloneVisualCache, cloneHid, 3) != revision then
            call ClearCloneVisualEffects(clone)

            if BlzGetUnitSkin(clone) != skin then
                call BlzSetUnitSkin(clone, skin)
            endif

            call SetIllusionColor(clone, owner)
            call FixAura2(clone)
            call FixHeroPas(clone)
            call SaveBoolean(CloneVisualCache, cloneHid, 2, true)
            call SaveInteger(CloneVisualCache, cloneHid, 3, revision)
        endif
    endloop

    set TransformFilterHero = null
    set TransformFilterHeroId = 0
    set clone = null
    set owner = null
endfunction









function FixAura takes unit c returns nothing
    local integer pid
    local integer hid
    if c == null then
        return
    endif
    set pid = GetPlayerId(GetOwningPlayer(c))
    if c == Hero[pid] then
        set HeroCloneRevision[pid] = HeroCloneRevision[pid] + 1
        call FixAura2(c)
        call FixModel(c)
    else
        set hid = GetHandleId(c)
        call ClearCloneVisualEffects(c)
        call FixAura2(c)
        call FixHeroPas(c)
        call SaveBoolean(CloneVisualCache, hid, 2, true)
        call SaveInteger(CloneVisualCache, hid, 3, HeroCloneRevision[pid])
    endif
endfunction

function CleanupCloneVisuals takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer hid = GetHandleId(u)
    if LoadBoolean(CloneVisualCache, hid, 2) then
        call ClearCloneVisualEffects(u)
        call FlushChildHashtable(CloneVisualCache, hid)
    endif
    set u = null
endfunction

function InitCloneVisualCleanup takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(t, function CleanupCloneVisuals)
    set t = null
endfunction

    function GetUnitsCountInGroup takes group g3,real x,real y returns integer
    local group g = CreateGroup()
    local integer count = 0
    local unit u

    call GroupEnumUnitsInRange(g, x,y,5000, null)

    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if IsUnitInGroup(u,g3) then 
        set count = count + 1
        endif
        call GroupRemoveUnit(g, u)
    endloop

    call DestroyGroup(g)
    set g = null
    set u = null

    return count
endfunction



//================================================================================================================================
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com



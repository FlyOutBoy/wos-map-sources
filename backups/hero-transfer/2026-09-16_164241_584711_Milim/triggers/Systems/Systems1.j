library GearSystems initializer Init uses GearSystems2

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

    // Общая test-mode логика размещена до Shop и Hero Pick.
    // 0 — обычный выбор, 1 — вражеский TestUnit, 2 — союзный TestAllyUnit.
    unit TestUnit = null
    unit TestAllyUnit = null
    integer array TestUnitPickMode
    player TestUnitController = null
    player TestAllyUnitController = null
    integer TestUnitPlayerId = 6
    integer TestAllyUnitPlayerId = 1
    integer TestUnitPickEnemy = 1
    integer TestUnitPickAlly = 2
endglobals
// Возвращает героя, с которым сейчас должны работать магазин и тестовые клавиши.
// В обычном режиме всегда возвращает Hero[pid].
// Чужие обычные герои и не-герои игнорируются.
function GetSelectedHeroForPlayer takes player p returns unit
    local integer pid = GetPlayerId(p)
    local unit selected = HeroChosen[pid]

    if TestMode and selected != null and IsUnitType(selected, UNIT_TYPE_HERO) then
        if selected == Hero[pid] or selected == TestUnit or selected == TestAllyUnit then
            return selected
        endif
    endif

    return Hero[pid]
endfunction

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
    call RegisterShopHero(Toji_ID,    5, 3) // shop 21
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
elseif id == Toji_ID then
set q = TojiQ_ID
set w = TojiW_ID
set e = TojiE_ID
set r = TojiR_ID
set t = TojiT_ID
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

                    call UnitRemoveAbility(c,'B02Z')
                    call UnitRemoveAbility(c,'B030')
                    call UnitRemoveAbility(c,'B031')
                    call UnitRemoveAbility(c,'B032')
                    call UnitRemoveAbility(c,'B033')
                    call UnitRemoveAbility(c,'B034')
                    call UnitRemoveAbility(c,'B035')
                    call UnitRemoveAbility(c,TojiW_Debuff_ID)
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
return false
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

if id == Toji_ID  then
    
    set ItemsPage0_ID[i2+0] = 'I00E' // tusk barrel    
    set ItemsPage0_ID[i2+1] = 'I01I' // incursio
    set ItemsPage0_ID[i2+2] = 'I00M' // cup of tea
    set ItemsPage0_ID[i2+3] = 'I00B' // Oken
    set ItemsPage0_ID[i2+4] = 'I024' // prison realm
    set ItemsPage0_ID[i2+5] = 'I03T' // hogyoku
endif
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
    set ItemsPage0_ID[i2+1] = 'I01I' // witch sin
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

    function SetHpCurrent takes unit c, real r returns nothing
    call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) + r)
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

// Полные щиты GearSystems отделены от обычных сопротивлений. typedmg всегда
// передаётся в общую функцию; сейчас эти четыре щита принимают все типы урона,
// как и в исходной логике. Для щита с ограничением достаточно заменить ALL.
function ApplyGearSystemFullShields takes unit c, unit td, real dmg, real triggerDmg, integer typedmg, boolean test returns real
    local player targetOwner = null
    local integer ownerHid = 0
    local integer itemSlot = -1

    if test then
        return dmg
    endif

    set targetOwner = GetOwningPlayer(td)
    set ownerHid = GetHandleId(targetOwner)

    // Tomioka F: все типы урона.
    if LoadInteger(hs, ownerHid, KEY_TOMIOKA_F_INVUL) == 1 then
        set dmg = ApplyFullDamageShield(c, td, dmg, triggerDmg, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        call SaveInteger(hs, GetHandleId(td), KEY_TOMIOKA_F_DMG_ACT, 1)
    endif

    // B02G: все типы урона.
    if GetUnitAbilityLevel(td, 'B02G') > 0 then
        set dmg = ApplyFullDamageShield(c, td, dmg, triggerDmg, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif

    // Turbo Neko: все типы урона.
    if GetUnitAbilityLevel(td, TurboNeko_Invul_ID) > 0 then
        set dmg = ApplyFullDamageShield(c, td, dmg, triggerDmg, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif

    // Cup of Tea: все типы урона. Может работать одновременно с Tsuna G.
    set itemSlot = IsItemInInventory3(td, 'I00M')
    if itemSlot >= 0 /*
    */ and BlzGetUnitAbilityCooldownRemaining(td, 'A01W') == 0.0 /*
    */ and dmg >= GetItemCharges(UnitItemInSlot(td, itemSlot)) then
        set dmg = ApplyFullDamageShield(c, td, dmg, triggerDmg, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_teaeff.mdl", td, "chest"))
        call BlzStartUnitAbilityCooldown(td, 'A01W', CupOfTea_CD)
        call UnitRemoveAbility(td, 'A07Q')
        call MyRemoveAbility(td, CupOfTea_CD, 'A07Q', 0)
    endif

    set targetOwner = null
    return dmg
endfunction

function DamageBlock takes unit c, unit td, real dmg, integer typedmg, boolean test returns real
    local real dmgbase = dmg
    // Копия защищена от вложенных событий урона, которые могут изменить global.
    local real shieldTriggerDmg = DamageShieldPierceTriggerDamage
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
    local integer erzaType
    local boolean isMagic = typedmg == 1
    local boolean isPhysical = typedmg != 1

    // Mahoraga T.
    // Баффы находятся на атакующем c, а их сопротивление действует,
    // только когда получатель урона td является Махорагой.
    // Блок должен выполняться после сохранения исходного dmgbase и до
    // предметного пробития, чтобы I00J/I00R и дебаффы снижения резистов
    // могли пробивать накопленное сопротивление Махораги.
    if targetId == Mahoraga_ID and c != null then
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
    if LoadInteger(hs,GetHandleId(td),StringHash("asta e"))==1 then 
    set dmg = dmg * 0.65
    endif
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
    
    if targetId == Toji_ID then
    set dmg = dmg * (1.00 - RMinBJ(TojiG_ResMax,(GetHeroAgi(td,true) / TojiG_ResPerAgi) * TojiG_Res) / 100.00)
endif
    
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
            
        if TestMode == true and HaveSavedReal(hs, targetHid, KEY_PHYS_RES) then
    set value = LoadReal(hs, targetHid, KEY_PHYS_RES)

    if value < 0.0 then
        set value = 0.0
    elseif value > 1.0 then
        set value = 1.0
    endif

    set dmg = dmgbase * (1.0 - value)
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
        
        set level = GetHeroLevel(td)
        if TestMode == false or (GetPlayerId(GetOwningPlayer(td)) != TestUnitPlayerId and GetPlayerId(GetOwningPlayer(td)) != TestAllyUnitPlayerId) then  
        if level >= 35 then
            set dmg = dmg * 0.85
        elseif level >= 24 then
            set dmg = dmg * 0.9
        elseif level >= 12 then
            set dmg = dmg * 0.95
        endif
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

     if TestMode == true and HaveSavedReal(hs, targetHid, KEY_MAG_RES) then
    set value = LoadReal(hs, targetHid, KEY_MAG_RES)

    if value < 0.0 then
        set value = 0.0
    elseif value > 1.0 then
        set value = 1.0
    endif

    set dmg = dmgbase * (1.0 - value)
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

   
    
    set dmg = ApplyGearSystemFullShields(c, td, dmg, shieldTriggerDmg, typedmg, test)

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
            set dmg = dmg * 1.2
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
            set dmg = dmg * 1.2
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



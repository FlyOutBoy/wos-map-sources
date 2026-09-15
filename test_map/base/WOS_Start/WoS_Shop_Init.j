globals
    trigger FrameClick2 
    trigger FrameGuideEnter2
    trigger FrameGuideLeave2
    framehandle FRAME_ShopMAIN
    framehandle array FRAME_ShopSection
    framehandle FRAME_ShopItemList
    framehandle FRAME_ShopItemInventory
    framehandle FRAME_ShopItemInventoryName
    framehandle FRAME_ShopItemCraft
    framehandle FRAME_ShopItemCraftSprite
    framehandle FRAME_ShopItemCraftSprite2
    framehandle FRAME_ShopItemDescription
    framehandle FRAME_ShopItemDescriptionName
    framehandle FRAME_ShopItemDescriptionName2
    framehandle FRAME_ShopItemCraftGoldSlot
    framehandle array FRAME_ShopItemInventorySlot
    framehandle array FRAME_ShopItemInventorySlotBack
    framehandle array FRAME_ShopItemInventorySlotCost
    framehandle array FRAME_ShopItem
    framehandle array FRAME_ShopItemBack
    framehandle array FRAME_ShopItemCost
    boolean array Shop_Active
    integer array ItemsFrameCurrentPage_ID
    integer array ItemsCurrentItemCraft_ID
    integer array ItemsFrameCurrentItem_ID
    integer array ItemsCurrentItem_ID
    integer array ItemsCurrentItem_ID_BACKUP
    integer array ItemsCurrentItemBag_ID
    integer array ItemsCurrentItemBagDescription_ID0
    integer array ItemsCurrentItemBagDescription_ID1
    integer array ItemsCurrentItemBagDescription_ID2
    integer array ItemsCurrentItemBagDescription_ID3
    integer array ItemsCurrentItemBagDescription_ID4
    integer array ItemsCurrentItemBagDescription_ID5
    integer array ItemsPage0_ID
    integer array ItemsPage1_ID
    integer array ItemsPage2_ID
    integer array ItemsPage3_ID
    integer array ItemsPage4_ID
    integer array ItemsPage5_ID
    integer array ItemsPage6_ID
    integer array ItemsCraft_ID
    integer array ItemsCraftLeft_ID
    integer array ItemsCraftBottom_ID
    integer array ItemsCraftRight_ID
    integer array ItemsCraftUpperLeft_ID
    integer array ItemsCraftUpperTop_ID
    integer array ItemsCraftUpperRight_ID
    integer array ItemsCraftCenter_ID
    integer array ItemsCraftPlayerDebug_ID
    integer array ItemsCraftPlayerDebug2_ID
    unit priceshop = null
    unit pricesell = null
endglobals

function MyItemsIdInit takes nothing returns nothing
    local item a
    local integer k = 0
    local real x = GetRectCenterX(gg_rct_Caster)
    local real y = GetRectCenterY(gg_rct_Caster)
    local integer i2 = 12
    local integer g1 = GetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD)
    local integer g2 = 0
//=========Recomended==============
//=========Base====================
    set ItemsPage1_ID[0] = 'I007' // sonic boots
    set ItemsPage1_ID[1] = 'I000' // jade
    set ItemsPage1_ID[2] = 'I00G' // funny barrel
    set ItemsPage1_ID[3] = 'I00S' // funny present
    set ItemsPage1_ID[4] = 'I00C' // seal
    set ItemsPage1_ID[5] = 'I00D' // urahara hat
    set ItemsPage1_ID[6] = 'I00F' // Shinigami certificate
    set ItemsPage1_ID[7] = 'I00N' // urahara cane
    set ItemsPage1_ID[14] = 'I00E' // incursio
    set ItemsPage1_ID[15] = 'I00O' // urahara set
//==========Str====================
    set ItemsPage2_ID[0] = 'I004' // talisman
    set ItemsPage2_ID[1] = 'I005' // tome of strength
    set ItemsPage2_ID[14] = 'I003' // horn of strength
    set ItemsPage2_ID[15] = 'I00B' // oken
    set ItemsPage2_ID[16] = 'I00U' // Hokage Hat
    set ItemsPage2_ID[17] = 'I00Y' // Angel's Blessing
//==========Agi====================    
    set ItemsPage3_ID[0] = 'I008' // rune
    set ItemsPage3_ID[1] = 'I006' // tome of agility
    set ItemsPage3_ID[14] = 'I009' // cap of agility
    set ItemsPage3_ID[15] = 'I00J' // kanso and bakuya
    set ItemsPage3_ID[16] = 'I00T' // raikage hat
    set ItemsPage3_ID[17] = 'I010' // pochita
//==========Int====================
    set ItemsPage4_ID[0] = 'I001' // rune
    set ItemsPage4_ID[1] = 'I00A' // tome of intelligence
    set ItemsPage4_ID[14] = 'I002' // hollow soul
    set ItemsPage4_ID[15] = 'I00H' // black heart
    set ItemsPage4_ID[16] = 'I00R' // kazekage hat
    set ItemsPage4_ID[17] = 'I011' // okarun egg
//==========Universal==============
    set ItemsPage5_ID[0] = 'I00Q' // hungry sin
    set ItemsPage5_ID[1] = 'I00P' // tsuchikage hat
    set ItemsPage5_ID[2] = 'I00V' // bunshin scroll
    set ItemsPage5_ID[3] = 'I00Z' // naofumi shield
    set ItemsPage5_ID[4] = 'I012' // fairy tail emblem
    set ItemsPage5_ID[5] = 'I00W' // kurikara
    set ItemsPage5_ID[6] = 'I00M' // cup of tea
//==========Defensive==============
    set ItemsPage6_ID[0] = 'I00I' // midnight cloack
    set ItemsPage6_ID[1] = 'I00K' // mizukage hat
    set ItemsPage6_ID[14] = 'I00L' // witch sin
    set ItemsPage6_ID[15] = 'I00X' //Emperor's Blue Armor

//===============Первое создание магазов даммиков для проверки цены предметы, один раз на всю игру + инициализация==============================
    if priceshop == null then
        set priceshop = CreateUnit(Player(i2), 'ngme', x, y, 0)
    endif
    if pricesell == null then
        set pricesell = CreateUnit(Player(i2), 'Hpal', x, y - 100, 90)
    endif
    call SetUnitVertexColor(priceshop, 0, 0, 0, 0)
    call SetUnitVertexColor(pricesell, 0, 0, 0, 0)
    call UnitAddAbility(priceshop, 'Apiv')
    call UnitAddAbility(pricesell, 'Apiv')
    call UnitAddAbility(priceshop, 'Avul')
    call UnitAddAbility(pricesell, 'Avul')
    call SetScale(pricesell, 0.01)
    call SetScale(priceshop, 0.01)
    set a = UnitAddItemByIdSwapped('I000', pricesell)
    call UnitDropItemTarget(pricesell, a, priceshop)
    set g2 = GetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD) - g1
    call SetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(i2), PLAYER_STATE_RESOURCE_GOLD) - g2)
    set a = null
    set k = 0
    loop
    exitwhen k> 30
    if ItemsPage1_ID[k] != 0 then 
    call GetItemValue(ItemsPage1_ID[k])
    endif
    if ItemsPage2_ID[k] != 0 then 
    call GetItemValue(ItemsPage2_ID[k])
    endif
    if ItemsPage3_ID[k] != 0 then 
    call GetItemValue(ItemsPage3_ID[k])
    endif
    if ItemsPage4_ID[k] != 0 then 
    call GetItemValue(ItemsPage4_ID[k])
    endif
    if ItemsPage5_ID[k] != 0 then 
    call GetItemValue(ItemsPage5_ID[k])
    endif
    if ItemsPage6_ID[k] != 0 then 
    call GetItemValue(ItemsPage6_ID[k])
    endif
    set k = k + 1
    endloop
    set k = 0
//==============================
endfunction
function CheckItemsReduceCostCraft2 takes unit c, integer cost, integer it1, integer it2, integer it3, boolean b returns integer
    local integer i = 0
    local integer check1 = 0
    local integer check2 = 0
    local integer check3 = 0
    loop
        exitwhen i == 6
        if it1 != null and check1 == 0 then
            if GetItemTypeId(UnitItemInSlot(c, i)) == it1 then
                set check1 = 1
                set cost = cost - GetItemValue(it1)
                if b then
                    call RemoveItem(UnitItemInSlot(c, i))
                endif
            endif
        endif
        if it2 != null and check2 == 0 then
            if GetItemTypeId(UnitItemInSlot(c, i)) == it2 then
                set check2 = 1
                set cost = cost - GetItemValue(it2)
                if b then
                    call RemoveItem(UnitItemInSlot(c, i))
                endif
            endif
        endif
        if it3 != null and check3 == 0 then
            if GetItemTypeId(UnitItemInSlot(c, i)) == it3 then
                set check3 = 1
                set cost = cost - GetItemValue(it3)
                if b then
                    call RemoveItem(UnitItemInSlot(c, i))
                endif
            endif
        endif
        set i = i + 1
    endloop
    return cost
endfunction
function CheckItemsRelatives0 takes integer id returns integer
    local integer i = 0
    if id == 'I003' or id == 'I009' or id == 'I002' or id == 'I000' or id == 'I00E' or id == 'I00J' or id == 'I00H' or id == 'I00B' or id == 'I00O'  or id == 'I00L' or id == 'I00R' or id == 'I00T' or id == 'I00U' or id == 'I012'  then
        set i = 3
    endif
    if id == 'I010' or id == 'I00W' then 
    set i = 1
    endif
    return i
endfunction
function CheckItemsRelatives1 takes integer id returns integer
    local integer i = 0
    if id == 'I003' then
        set i = 'I004'
    endif
    if id == 'I009' then
        set i = 'I008'
    endif
    if id == 'I002' then
        set i = 'I001'
    endif
    if id == 'I00E' then
        set i = 'I007'
    endif
    if id == 'I00H' then
        set i = 'I00A'
    endif
    if id == 'I00B' then
        set i = 'I005'
    endif
    if id == 'I00J' then
        set i = 'I006'
    endif
    if id == 'I00R' then
        set i = 'I00A'
    endif
    if id == 'I00O' then
        set i = 'I00D'
    endif
    if id == 'I00L' then
        set i = 'I00K'
    endif
    if id == 'I00T' then
        set i = 'I006'
    endif
    if id == 'I00U' then
        set i = 'I005'
    endif
    if id == 'I00W' then
        set i = 'I00A'
    endif
    if id == 'I010' then
        set i = 'I006'
    endif
    if id == 'I012' then
        set i = 'I009'
    endif
    return i
endfunction
function CheckItemsRelatives2 takes integer id returns integer
    local integer i = 0
    if id == 'I003' or id == 'I009' or id == 'I002' then
        set i = 'I000'
    endif
    if id == 'I00H' then
        set i = 'I00C'
    endif
    if id == 'I00T' then
        set i = 'I00D'
    endif    
    if id == 'I012' then
        set i = 'I002'
    endif
    return i
endfunction
function CheckItemsRelatives3 takes integer id returns integer
    local integer i = 0
    if id == 'I003' or id == 'I009' or id == 'I002' then
        set i = 0
    endif   
    if id == 'I00E' then
        set i = 'I00F'
    endif
    if id == 'I00H' then
        set i = 'I00F'
    endif
    if id == 'I00B' then
        set i = 'I00I'
    endif
    if id == 'I00J' then
        set i = 'I009'
    endif
    if id == 'I00R' then
        set i = 'I00F'
    endif
    if id == 'I00O' then
        set i = 'I00N'
    endif
    if id == 'I00L' then
        set i = 'I002'
    endif
    if id == 'I00T' then
        set i = 'I00N'
    endif
    if id == 'I00U' then
        set i = 'I003'
    endif    
    if id == 'I00W' then
        set i = 'I00G'
    endif    
    if id == 'I012' then
        set i = 'I003'
    endif
    return i
endfunction
function CheckItemsReduceCostCraft takes unit c, integer cost, integer id , boolean b returns integer
    local integer i = 0
    local integer check1 = 0
    local integer check2 = 0
    local integer check3 = 0
    set i = CheckItemsRelatives0(id)
    if i > 0 then
        if i == 1 then
            set cost = CheckItemsReduceCostCraft2(c, cost, CheckItemsRelatives1(id), 0, 0, b)
        elseif i == 2 then
            set cost = CheckItemsReduceCostCraft2(c, cost, CheckItemsRelatives1(id), CheckItemsRelatives2(id), 0, b)
        elseif i == 3 then
            set cost = CheckItemsReduceCostCraft2(c, cost, CheckItemsRelatives1(id), CheckItemsRelatives2(id), CheckItemsRelatives3(id), b)
        endif
    endif
    
    return cost
endfunction
function CraftItemCheck takes integer id, player p, integer page returns nothing
    local framehandle craft_left = FRAME_ShopItemBack[36]
    local framehandle craft_left_button = FRAME_ShopItem[36]
    local framehandle craft_left_cost = FRAME_ShopItemCost[36]
    local framehandle craft_center = FRAME_ShopItemBack[37]
    local framehandle craft_center_button = FRAME_ShopItem[37]
    local framehandle craft_center_cost = FRAME_ShopItemCost[37]
    local framehandle craft_right = FRAME_ShopItemBack[38]
    local framehandle craft_right_button = FRAME_ShopItem[38]
    local framehandle craft_right_cost = FRAME_ShopItemCost[38]
    local framehandle sborka_left = FRAME_ShopItemBack[39]
    local framehandle sborka_left_button = FRAME_ShopItem[39]
    local framehandle sborka_left_cost = FRAME_ShopItemCost[39]
    local framehandle sborka_center = FRAME_ShopItemBack[40]
    local framehandle sborka_center_button = FRAME_ShopItem[40]
    local framehandle sborka_center_cost = FRAME_ShopItemCost[40]
    local framehandle sborka_right = FRAME_ShopItemBack[41]
    local framehandle sborka_right_button = FRAME_ShopItem[41]
    local framehandle sborka_right_cost = FRAME_ShopItemCost[41]
    local integer craft_left_number = 36
    local integer craft_center_number = 37
    local integer craft_right_number = 38
    local integer sborka_left_number = 39
    local integer sborka_center_number = 40
    local integer sborka_right_number = 41
    local integer check = 0
    local integer i = 0
    local integer pid = GetPlayerId(p)
    local integer id_next = 0
    local integer id_next2 = 0
    local integer id_next3 = 0
    local boolean b = false
    local integer value1 = 0
    local integer value2 = 0
    local integer value3 = 0
    local unit d 
    set d = Hero[pid]
        if TestMode == true and TestUnit != null then
        set d = TestUnit 
        endif
    set ItemsCraftLeft_ID[pid] = 0
    set ItemsCraftBottom_ID[pid] = 0
    set ItemsCraftRight_ID[pid] = 0
    set ItemsCraftUpperLeft_ID[pid] = 0
    set ItemsCraftUpperTop_ID[pid] = 0
    set ItemsCraftUpperRight_ID[pid] = 0
    if GetLocalPlayer() == p then
        call FrameEnable(sborka_left_button, b )
//call FrameEnable(sborka_left,b)
        call FrameEnable(sborka_center_button, b)
//call FrameEnable(sborka_center,b)
        call FrameEnable(sborka_right_button, b)
//call FrameEnable(sborka_right,b)
        call FrameEnable(craft_left_button, b)
//call FrameEnable(craft_left,b)
        call FrameEnable(craft_center_button, b)
//call FrameEnable(craft_center,b)
        call FrameEnable(craft_right_button, b)
//call FrameEnable(craft_right,b)
    endif
    if id == 'I009' then 
    set ItemsCraftPlayerDebug_ID[pid] = 42
    endif    
    if id == 'I000' then
        set ItemsCraftPlayerDebug_ID[pid] = -1
        set ItemsCraftUpperLeft_ID[pid] = 'I003'
        set ItemsCraftUpperTop_ID[pid] = 'I009'
        set ItemsCraftUpperRight_ID[pid] = 'I002'
        set id_next = ItemsCraftUpperLeft_ID[pid]
        set id_next2 = ItemsCraftUpperTop_ID[pid]
        set id_next3 = ItemsCraftUpperRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        set value3 = CheckItemsReduceCostCraft(d, GetItemValue(id_next3), id_next3, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call FrameEnable(craft_right_button, true)
            call FrameEnable(craft_right, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value2) + "|r")
            call BlzFrameSetTexture(craft_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(craft_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    if id == 'I00U' then // hokage hat
        set ItemsCraftPlayerDebug_ID[pid] = -1
        set ItemsCraftLeft_ID[pid] = 'I005'
        set ItemsCraftRight_ID[pid] = 'I003'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next3 = ItemsCraftRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)        
        set value3 = CheckItemsReduceCostCraft(d, GetItemValue(id_next3), id_next3, false)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    if id == 'I012' then // fairy tail emblem
        set ItemsCraftPlayerDebug_ID[pid] = -1
        set ItemsCraftLeft_ID[pid] = 'I003'
        set ItemsCraftBottom_ID[pid] = 'I009'
        set ItemsCraftRight_ID[pid] = 'I002'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftBottom_ID[pid]
        set id_next3 = ItemsCraftRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)        
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)        
        set value3 = CheckItemsReduceCostCraft(d, GetItemValue(id_next3), id_next3, false)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_center_button, true)
            call FrameEnable(sborka_center, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_center, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_center_cost, "|c00FFFF00" + I2S(value2) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    if false then //id == 'I00W' then  pochita
        set ItemsCraftPlayerDebug_ID[pid] = -1
        set ItemsCraftLeft_ID[pid] = 'I00C'
        set ItemsCraftRight_ID[pid] = 'I00G'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next3 = ItemsCraftRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)        
        set value3 = CheckItemsReduceCostCraft(d, GetItemValue(id_next3), id_next3, false)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    if id == 'I010' then // pochita
        set ItemsCraftPlayerDebug_ID[pid] = -1
        set ItemsCraftBottom_ID[pid] = 'I006'
        set id_next = ItemsCraftBottom_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)  
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_center_button, true)
            call FrameEnable(sborka_center, true)
            call BlzFrameSetTexture(sborka_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I00W' then // pochita
        set ItemsCraftPlayerDebug_ID[pid] = -1
        set ItemsCraftBottom_ID[pid] = 'I00A'
        set id_next = ItemsCraftBottom_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)  
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_center_button, true)
            call FrameEnable(sborka_center, true)
            call BlzFrameSetTexture(sborka_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    
    if id == 'I00T' then // raikage hat
        set ItemsCraftPlayerDebug_ID[pid] = -1
        set ItemsCraftLeft_ID[pid] = 'I006'
        set ItemsCraftBottom_ID[pid] = 'I00N'
        set ItemsCraftRight_ID[pid] = 'I00D'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftBottom_ID[pid]
        set id_next3 = ItemsCraftRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        set value3 = CheckItemsReduceCostCraft(d, GetItemValue(id_next3), id_next3, false)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_center_button, true)
            call FrameEnable(sborka_center, true)
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_center, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_center_cost, "|c00FFFF00" + I2S(value2) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    if id == 'I00D' or id == 'I00N' then // urahara hat and cane
        set ItemsCraftUpperTop_ID[pid] = 'I00O'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I00D' or id == 'I00N' then // urahara hat and cane
        set ItemsCraftUpperLeft_ID[pid] = 'I00T'
        set id_next = ItemsCraftUpperLeft_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I002' then // 
        set ItemsCraftUpperLeft_ID[pid] = 'I012'
        set id_next2 = ItemsCraftUpperLeft_ID[pid]
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I00K' or id == 'I002' then // midnight cloack
        set ItemsCraftUpperTop_ID[pid] = 'I00L'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I00I' or id == 'I005' then // midnight cloack
        set ItemsCraftUpperTop_ID[pid] = 'I00B'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I005' then // 
        set ItemsCraftUpperLeft_ID[pid] = 'I00U'
        set id_next = ItemsCraftUpperLeft_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I003' then // 
        set ItemsCraftUpperTop_ID[pid] = 'I00U'
        set ItemsCraftUpperLeft_ID[pid] = 'I012'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set id_next2 = ItemsCraftUpperLeft_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I009' then // 
        set ItemsCraftUpperLeft_ID[pid] = 'I012'
        set id_next2 = ItemsCraftUpperLeft_ID[pid]
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I006' or id == 'I009' then // midnight cloack
        set ItemsCraftUpperTop_ID[pid] = 'I00J'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I006' then // tome agility ot raikage
        set ItemsCraftUpperLeft_ID[pid] = 'I00T'
        set id_next = ItemsCraftUpperLeft_ID[pid]
        set ItemsCraftUpperRight_ID[pid] = 'I010'
        set id_next2 = ItemsCraftUpperRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call FrameEnable(craft_right_button, true)
            call FrameEnable(craft_right, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(craft_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(craft_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I004' or id == 'I008' or id == 'I001' then
        if id == 'I004' then
            set ItemsCraftUpperTop_ID[pid] = 'I003'
        elseif id == 'I008' then
            set ItemsCraftUpperTop_ID[pid] = 'I009'
        elseif id == 'I001' then
            set ItemsCraftUpperTop_ID[pid] = 'I002'
        endif
        set id_next = ItemsCraftUpperTop_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I00O'  then // urahara set
        set ItemsCraftLeft_ID[pid] = 'I00D' 
        set ItemsCraftRight_ID[pid] = 'I00N' 
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftRight_ID[pid]
        set value1 = GetItemValue(id_next)
        set value2 = GetItemValue(id_next2)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
     if id == 'I00L'  then
        set ItemsCraftLeft_ID[pid] = 'I00K' 
        set ItemsCraftRight_ID[pid] = 'I002' 
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftRight_ID[pid]
        set value1 = GetItemValue(id_next)
        set value2 = GetItemValue(id_next2)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I007'  then
        set ItemsCraftUpperTop_ID[pid] = 'I00E'
        set id_next = ItemsCraftUpperTop_ID[pid]        
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I00F' then
        set ItemsCraftUpperTop_ID[pid] = 'I00E'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set value1 = GetItemValue(id_next)
         set ItemsCraftUpperLeft_ID[pid] = 'I00H'
        set id_next2 = ItemsCraftUpperLeft_ID[pid]
         set ItemsCraftUpperRight_ID[pid] = 'I00R'
        set id_next3 = ItemsCraftUpperRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        set value3 = CheckItemsReduceCostCraft(d, GetItemValue(id_next3), id_next3, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value2) + "|r")
            call FrameEnable(craft_right_button, true)
            call FrameEnable(craft_right, true)
            call BlzFrameSetTexture(craft_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(craft_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    if id == 'I003' or id == 'I009' or id == 'I002' then
        if id == 'I003' then
            set ItemsCraftLeft_ID[pid] = 'I004'
        elseif id == 'I009' then
            set ItemsCraftLeft_ID[pid] = 'I008'
        elseif id == 'I002' then
            set ItemsCraftLeft_ID[pid] = 'I001'
        endif
        set ItemsCraftRight_ID[pid] = 'I000'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
    
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if  id == 'I00C'  then
        set ItemsCraftUpperTop_ID[pid] = 'I00H'
       // set ItemsCraftUpperLeft_ID[pid] = 'I00W'
        set id_next = ItemsCraftUpperTop_ID[pid]
       // set id_next2 = ItemsCraftUpperLeft_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
      //  set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
          //  call FrameEnable(craft_left_button, true)
          //  call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
          //  call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next2), 0, false)
          //  call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if false then  // id == 'I00G'  then
        set ItemsCraftUpperTop_ID[pid] = 'I00W'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
        endif
    endif
    if id == 'I00A'  then
        set ItemsCraftUpperTop_ID[pid] = 'I00H'
        set id_next = ItemsCraftUpperTop_ID[pid]
        set ItemsCraftUpperLeft_ID[pid] = 'I00R'
        set id_next2 = ItemsCraftUpperLeft_ID[pid]
        set ItemsCraftUpperRight_ID[pid] = 'I00W'
        set id_next3 = ItemsCraftUpperRight_ID[pid]
        set value1 = CheckItemsReduceCostCraft(d, GetItemValue(id_next), id_next, false)
        set value2 = CheckItemsReduceCostCraft(d, GetItemValue(id_next2), id_next2, false)
        set value3 = CheckItemsReduceCostCraft(d, GetItemValue(id_next3), id_next3, false)
        if GetLocalPlayer() == p then
            call FrameEnable(craft_center_button, true)
            call FrameEnable(craft_center, true)
            call BlzFrameSetTexture(craft_center, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(craft_center_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call FrameEnable(craft_left_button, true)
            call FrameEnable(craft_left, true)
            call BlzFrameSetTexture(craft_left, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(craft_left_cost, "|c00FFFF00" + I2S(value2) + "|r")
            call FrameEnable(craft_right_button, true)
            call FrameEnable(craft_right, true)
            call BlzFrameSetTexture(craft_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(craft_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    if id == 'I00E' then
        set ItemsCraftLeft_ID[pid] = 'I007'
        set ItemsCraftRight_ID[pid] = 'I00F'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftRight_ID[pid]
        set value1 = GetItemValue(id_next)
        set value2 = GetItemValue(id_next2)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I00B' then
        set ItemsCraftLeft_ID[pid] = 'I005'
        set ItemsCraftRight_ID[pid] = 'I00I'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftRight_ID[pid]
        set value1 = GetItemValue(id_next)
        set value2 = GetItemValue(id_next2)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I00J' then
        set ItemsCraftLeft_ID[pid] = 'I006'
        set ItemsCraftRight_ID[pid] = 'I009'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftRight_ID[pid]
        set value1 = GetItemValue(id_next)
        set value2 = GetItemValue(id_next2)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I00R' then
        set ItemsCraftLeft_ID[pid] = 'I00A'
        set ItemsCraftRight_ID[pid] = 'I00F'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftRight_ID[pid]
        set value1 = GetItemValue(id_next)
        set value2 = GetItemValue(id_next2)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value2) + "|r")
        endif
    endif
    if id == 'I00H' then
        set ItemsCraftLeft_ID[pid] = 'I00A'
        set ItemsCraftBottom_ID[pid] = 'I00F'
        set ItemsCraftRight_ID[pid] = 'I00C'
        set id_next = ItemsCraftLeft_ID[pid]
        set id_next2 = ItemsCraftBottom_ID[pid]
        set id_next3 = ItemsCraftRight_ID[pid]
        set value1 = GetItemValue(id_next)
        set value2 = GetItemValue(id_next2)
        set value3 = GetItemValue(id_next3)
        if GetLocalPlayer() == p then
            call FrameEnable(sborka_left_button, true)
            call FrameEnable(sborka_left, true)
            call FrameEnable(sborka_center_button, true)
            call FrameEnable(sborka_center, true)
            call FrameEnable(sborka_right_button, true)
            call FrameEnable(sborka_right, true)
            call BlzFrameSetTexture(sborka_left, BlzGetAbilityIcon(id_next), 0, false)
            call BlzFrameSetText(sborka_left_cost, "|c00FFFF00" + I2S(value1) + "|r")
            call BlzFrameSetTexture(sborka_center, BlzGetAbilityIcon(id_next2), 0, false)
            call BlzFrameSetText(sborka_center_cost, "|c00FFFF00" + I2S(value2) + "|r")
            call BlzFrameSetTexture(sborka_right, BlzGetAbilityIcon(id_next3), 0, false)
            call BlzFrameSetText(sborka_right_cost, "|c00FFFF00" + I2S(value3) + "|r")
        endif
    endif
    set sborka_left_button = null
    set sborka_center_button = null
    set sborka_left = null
    set sborka_center = null
    set sborka_right = null
    set craft_left_button = null
    set craft_center_button = null
    set craft_right_button = null
    set craft_left = null
    set craft_center = null
    set craft_right = null
    set d = null
endfunction
function ReloadItemPage takes integer page, player p returns nothing
    local boolean b
    local boolean b2
    local integer i = 0
    local integer id = 0
    local integer value
    if GetLocalPlayer() == p then
        if CondArena == 0 or TestMode == true then
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], true)
        endif
    endif
    loop
        exitwhen i == 43
        if GetLocalPlayer() == p then
            if i >= 36 then
                //call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
                if i != 42 then
                //    call BlzFrameSetVisible(FRAME_ShopItem[i], false)
                else
                call BlzFrameSetEnable(FRAME_ShopItem[i], false)
                endif
            else
                call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
            endif
        endif
        if page == 0 then
            set b = ItemsPage0_ID[i] != 0
            set id = ItemsPage0_ID[i]
        elseif page == 1 then
            set b = ItemsPage1_ID[i] != 0
            set id = ItemsPage1_ID[i]
        elseif page == 2 then
            set b = ItemsPage2_ID[i] != 0
            set id = ItemsPage2_ID[i]
        elseif page == 3 then
            set b = ItemsPage3_ID[i] != 0
            set id = ItemsPage3_ID[i]
        elseif page == 4 then
            set b = ItemsPage4_ID[i] != 0
            set id = ItemsPage4_ID[i]
        elseif page == 5 then
            set b = ItemsPage5_ID[i] != 0
            set id = ItemsPage5_ID[i]
        elseif page == 6 then
            set b = ItemsPage6_ID[i] != 0
            set id = ItemsPage6_ID[i]
        endif
        call BlzFrameSetAlpha(FRAME_ShopItemBack[i],255)
        if i <36 then 
        if b then
            set value = GetItemValue(id)
            if GetLocalPlayer() == p then
                call BlzFrameSetTexture(FRAME_ShopItemBack[i], BlzGetAbilityIcon(id), 0, false)
                call BlzFrameSetEnable(FRAME_ShopItem[i], true)
                call BlzFrameSetText(FRAME_ShopItemCost[i], "|c00FFFF00" + I2S(value) + "|r")
            endif
        else
            if GetLocalPlayer() == p then
                call BlzFrameSetEnable(FRAME_ShopItem[i], false)
                call BlzFrameSetText(FRAME_ShopItemCost[i], "|c00FFFF00" + "" + "|r")
            endif
        endif
        endif
        set i = i + 1
    endloop
endfunction
function GuideEnterItem takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer i2 = 0
    local string s
    local string s_name
    local integer id = 0
    local integer end = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer number_hero
    local item temp_item
    local real x = 0.025
    local real y = -0.05
    local integer k = 0
    if (clicked == FRAME_ShopItem[36]) and (ItemsCraftUpperLeft_ID[pid] != 0) then
        set temp_item = CreateItem(ItemsCraftUpperLeft_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
        endif
        call RemoveItem(temp_item)
    endif
    if (clicked == FRAME_ShopItem[37]) and (ItemsCraftUpperTop_ID[pid] != 0) then
        set temp_item = CreateItem(ItemsCraftUpperTop_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
        endif
        call RemoveItem(temp_item)
    endif
    if (clicked == FRAME_ShopItem[38]) and (ItemsCraftUpperRight_ID[pid] != 0) then
        set temp_item = CreateItem(ItemsCraftUpperRight_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
        endif
        call RemoveItem(temp_item)
    endif
    if (clicked == FRAME_ShopItem[39]) and (ItemsCraftLeft_ID[pid] != 0) then
        set temp_item = CreateItem(ItemsCraftLeft_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
        endif
        call RemoveItem(temp_item)
    endif
    if (clicked == FRAME_ShopItem[40]) and (ItemsCraftBottom_ID[pid] != 0) then
        set temp_item = CreateItem(ItemsCraftBottom_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
        endif
        call RemoveItem(temp_item)
    endif
    if (clicked == FRAME_ShopItem[41]) and (ItemsCraftRight_ID[pid] != 0) then
        set temp_item = CreateItem(ItemsCraftRight_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
        endif
        call RemoveItem(temp_item)
    endif
    if (clicked == FRAME_ShopItem[42]) and (ItemsCraftCenter_ID[pid] != 0) then
        set temp_item = CreateItem(ItemsCraftCenter_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
        endif
        call RemoveItem(temp_item)
    endif
    set p = null
    set temp_item = null
endfunction
function GuideLeaveItem takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer i2 = 0
    local string s
    local string s_name
    local integer id = 0
    local item temp_item
    local integer end = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer number_hero
    local real x = 0.025
    local real y = -0.05
    local integer k = 0
    set i = 36
    loop
        exitwhen i == 43
        if clicked == FRAME_ShopItem[i] then
            set temp_item = CreateItem(ItemsCurrentItem_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
            if GetLocalPlayer() == p then
                call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
                call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
            endif
            call RemoveItem(temp_item)
        endif
        set i = i + 1
    endloop
    set i = 0
    set p = null
    set temp_item = null
endfunction
function CheckSlotAvailable takes unit c returns boolean
    local integer i = 0
    local integer check = 0
    loop
        exitwhen i == 6
        if UnitItemInSlot(c, i) == null then
            set check = check + 1
        endif
        set i = i + 1
    endloop
    return check > 0
endfunction

function OnClickItem takes nothing returns nothing
    local framehandle clicked = BlzGetTriggerFrame()
    local integer i = 0
    local integer i2 = 0
    local string s
    local string s_name
    local integer id = 0
    local integer k2 = 0
    local unit d 
    local integer k3 = 0
    local integer end = 0
    local integer check = 0
    local integer value = 0
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local item temp_item = null
    local integer number_hero
    local real x = 0.025
    local real y = -0.05
    local integer k = 0
    if clicked == FRAME_ShopSection[0] or clicked == FRAME_ShopSection[1] or clicked == FRAME_ShopSection[2] or clicked == FRAME_ShopSection[3] or clicked == FRAME_ShopSection[4] or clicked == FRAME_ShopSection[5] or clicked == FRAME_ShopSection[6] then
        if clicked == FRAME_ShopSection[0] then
            set ItemsFrameCurrentPage_ID[pid] = 0 // Recommended
        elseif clicked == FRAME_ShopSection[1] then
            set ItemsFrameCurrentPage_ID[pid] = 1 // Base
        elseif clicked == FRAME_ShopSection[2] then
            set ItemsFrameCurrentPage_ID[pid] = 2 // Str
        elseif clicked == FRAME_ShopSection[3] then
            set ItemsFrameCurrentPage_ID[pid] = 3 // Agi
        elseif clicked == FRAME_ShopSection[4] then
            set ItemsFrameCurrentPage_ID[pid] = 4 // Int
        elseif clicked == FRAME_ShopSection[5] then
            set ItemsFrameCurrentPage_ID[pid] = 5 // Universal
        elseif clicked == FRAME_ShopSection[6] then
            set ItemsFrameCurrentPage_ID[pid] = 6 // Defensive
        endif
        set ItemsCraftPlayerDebug_ID[pid] = -1
        call ReloadItemPage(ItemsFrameCurrentPage_ID[pid], p)
    else
    if GetLocalPlayer() == p then
        call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + "Item name" + "|r")
        call BlzFrameSetText(FRAME_ShopItemDescriptionName2, "|c00FFFF00" + "" + "|r")
    endif
    endif
        set d = Hero[pid]
        if TestMode == true and TestUnit != null then
        set d = TestUnit 
        endif
    if ItemsFrameCurrentPage_ID[pid] < 7 then // Str
        set i = 0
        set check = ItemsFrameCurrentPage_ID[pid]
        set k2 = 0
        loop
            exitwhen i == 43
            if clicked == FRAME_ShopItem[i] and i != 42 and ItemsCraftPlayerDebug_ID[pid] != i then
                set k2 = k2 + 1
                set ItemsCurrentItemBag_ID[pid] = 0
                set ItemsCraftPlayerDebug_ID[pid] = i
                if i >= 36 then
                    if i == 36 then
                        set ItemsCurrentItem_ID[pid] = ItemsCraftUpperLeft_ID[pid]
                    elseif i == 37 then
                        set ItemsCurrentItem_ID[pid] = ItemsCraftUpperTop_ID[pid]
                    elseif i == 38 then
                        set ItemsCurrentItem_ID[pid] = ItemsCraftUpperRight_ID[pid]
                    elseif i == 39 then
                        set ItemsCurrentItem_ID[pid] = ItemsCraftLeft_ID[pid]
                    elseif i == 40 then
                        set ItemsCurrentItem_ID[pid] = ItemsCraftBottom_ID[pid]
                    elseif i == 41 then
                        set ItemsCurrentItem_ID[pid] = ItemsCraftRight_ID[pid]
                    elseif i == 42 then
                        set ItemsCurrentItem_ID[pid] = ItemsCraftCenter_ID[pid]
                    endif                    
                    set ItemsCurrentItem_ID_BACKUP[pid] = ItemsCurrentItem_ID[pid]
                  //  call BJDebugMsg(I2S(i))
                else
                    if check == 0 then
                        set ItemsCurrentItem_ID[pid] = ItemsPage0_ID[i]
                        set ItemsCurrentItem_ID_BACKUP[pid] = ItemsPage0_ID[i]
                    elseif check == 1 then
                        set ItemsCurrentItem_ID[pid] = ItemsPage1_ID[i]
                        set ItemsCurrentItem_ID_BACKUP[pid] = ItemsPage1_ID[i]
                    elseif check == 2 then
                        set ItemsCurrentItem_ID[pid] = ItemsPage2_ID[i]
                        set ItemsCurrentItem_ID_BACKUP[pid] = ItemsPage2_ID[i]
                    elseif check == 3 then
                        set ItemsCurrentItem_ID[pid] = ItemsPage3_ID[i]
                        set ItemsCurrentItem_ID_BACKUP[pid] = ItemsPage3_ID[i]
                    elseif check == 4 then
                        set ItemsCurrentItem_ID[pid] = ItemsPage4_ID[i]
                        set ItemsCurrentItem_ID_BACKUP[pid] = ItemsPage4_ID[i]
                    elseif check == 5 then
                        set ItemsCurrentItem_ID[pid] = ItemsPage5_ID[i]
                        set ItemsCurrentItem_ID_BACKUP[pid] = ItemsPage5_ID[i]
                    elseif check == 6 then
                        set ItemsCurrentItem_ID[pid] = ItemsPage6_ID[i]
                        set ItemsCurrentItem_ID_BACKUP[pid] = ItemsPage6_ID[i]
                    endif
                endif
                set temp_item = CreateItem(ItemsCurrentItem_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
                //if i >=36 then 
                set value = CheckItemsReduceCostCraft(d, GetItemValue(ItemsCurrentItem_ID[pid]), ItemsCurrentItem_ID[pid], false)
                //else 
                //set value = GetItemValue(ItemsCurrentItem_ID[pid])
                //endif
                if GetLocalPlayer() == p then
                    if CondArena == 0 or TestMode == true then
                        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
                        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
                    endif
                    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
                    call BlzFrameSetTexture(FRAME_ShopItemBack[42], BlzGetAbilityIcon(ItemsCurrentItem_ID[pid]), 0, false)
                    call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
                    call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
                    
                    call BlzFrameSetText(FRAME_ShopItemCost[42], "|c00FFFF00" + I2S(value) + "|r")
                endif
                call RemoveItem(temp_item)
                call CraftItemCheck(ItemsCurrentItem_ID[pid], p, ItemsFrameCurrentPage_ID[pid])
            endif
            set i = i + 1
        endloop
    endif
   
    set y = 0.08
    set x = -0.025
    set k2 = 0
    set k = 0
    set i = 0
    loop
        exitwhen i == 6
        if clicked == FRAME_ShopItemInventorySlot[i] then
            set k = k + 1
            set d = Hero[pid]
        if TestMode == true and TestUnit != null then
        set d = TestUnit 
        endif
            if UnitItemInSlot(d, i) != null then
                if i == 0 then
                    set id = ItemsCurrentItemBagDescription_ID0[pid]
                elseif i == 1 then
                    set id = ItemsCurrentItemBagDescription_ID1[pid]
                elseif i == 2 then
                    set id = ItemsCurrentItemBagDescription_ID2[pid]
                elseif i == 3 then
                    set id = ItemsCurrentItemBagDescription_ID3[pid]
                elseif i == 4 then
                    set id = ItemsCurrentItemBagDescription_ID4[pid]
                elseif i == 5 then
                    set id = ItemsCurrentItemBagDescription_ID5[pid]
                endif
                set k2 = k2 + 1
                set ItemsCurrentItem_ID[pid] = id
                set ItemsCurrentItemBag_ID[pid] = i + 1
                set temp_item = CreateItem(id, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
                set value = GetItemValue(id)
                if GetLocalPlayer() == p then
                    if CondArena == 0 or TestMode == true then
                        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], true)
                        call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], false)
                    endif
                    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, false)
                    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, true)
                    call BlzFrameSetTexture(FRAME_ShopItemBack[42], BlzGetAbilityIcon(id), 0, false)
                    call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
                    call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
                    call BlzFrameSetText(FRAME_ShopItemCost[42], "|c00FFFF00" + I2S(value) + "|r")
                    if i == 0 then
                        call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, 0.08)
                    elseif i == 1 then
                        call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025 + 0.0525, 0.08)
                    elseif i == 2 then
                        call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, 0.025)
                    elseif i == 3 then
                        call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025 + 0.0525, 0.025)
                    elseif i == 4 then
                        call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, -0.03)
                    elseif i == 5 then
                        call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025 + 0.0525, -0.03)
                    endif
                endif
                call CraftItemCheck(id, p, ItemsFrameCurrentPage_ID[pid])
                call RemoveItem(temp_item)
            endif
        endif
        set i = i + 1
    endloop
    if k2 == 0 then
    //call BlzFrameSetVisible(FRAME_ShopItemCraftSprite,true)
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)
        endif
    endif
    set id = 0
    if clicked == FRAME_ShopItemInventorySlot[6] then // BUY
        set k = 0
        set d = Hero[pid]
        if TestMode == true and TestUnit != null then
        set d = TestUnit 
        endif
        set k2 = GetItemValue(ItemsCurrentItem_ID[pid])
        set k3 = CheckItemsReduceCostCraft(d, k, ItemsCurrentItem_ID[pid], false)
        set k = k2 + k3
        if k3 < 0 or CheckSlotAvailable(d) then
            if GetGold(p) >= k then
                call CheckItemsReduceCostCraft(d, k, ItemsCurrentItem_ID[pid], true)
                call AddGold(p, k, false)
                call UnitAddItemById(d, ItemsCurrentItem_ID[pid])
                set temp_item = CreateItem(ItemsCurrentItem_ID[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
                set value = GetItemValue(ItemsCurrentItem_ID[pid])
                if GetLocalPlayer() == p then
                    call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
                    call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
                    call BlzFrameSetText(FRAME_ShopItemCost[42], "|c00FFFF00" + I2S(k2) + "|r")
                endif
                call RemoveItem(temp_item)
                if GetLocalPlayer() == p then
                    call StopSound(gg_snd_AlchemistTransmuteDeath1, false, false)
                    call StartSound(gg_snd_AlchemistTransmuteDeath1)
                    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
                endif
            else
                if GetLocalPlayer() == p then
                    call StopSound(gg_snd_SadTrombone, false, false)
                    call StartSound(gg_snd_SadTrombone)
                endif
                call DisplayTimedTextToPlayer(p, 0, 0, 1, "|c00FF0303Not enough gold|r")
            endif
        elseif CheckSlotAvailable(Hero[pid]) == false then
            if GetLocalPlayer() == p then
                call StopSound(gg_snd_Error, false, false)
                call StartSound(gg_snd_Error)
            endif
        endif
    if GetLocalPlayer() == p then 
       call BlzFrameSetText(FRAME_ShopItemCost[36], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftUpperLeft_ID[pid]), ItemsCraftUpperLeft_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[37], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftUpperTop_ID[pid]), ItemsCraftUpperTop_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[38], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftUpperRight_ID[pid]), ItemsCraftUpperRight_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[39], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftLeft_ID[pid]), ItemsCraftLeft_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[40], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftBottom_ID[pid]), ItemsCraftBottom_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[41], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftRight_ID[pid]), ItemsCraftRight_ID[pid], false)) + "|r")     
        endif
    endif
    set d = Hero[pid]
        if TestMode == true and TestUnit != null then
        set d = TestUnit 
        endif
    if clicked == FRAME_ShopItemInventorySlot[7] and ItemsCurrentItemBag_ID[pid] != 0 and UnitItemInSlot(d, ItemsCurrentItemBag_ID[pid] - 1) != null then //SOLD
        set k = GetItemValue(ItemsCurrentItem_ID[pid])
        set value = GetItemValue(ItemsCurrentItem_ID_BACKUP[pid])
        call SaveInteger(hs,GetHandleId(d),StringHash("sold cd"),1)
        call MyFlush(GetHandleId(d),StringHash("sold cd"),1,0.1)
        call AddGold(p, R2I(k * 0.75), true)
        call RemoveItem(UnitItemInSlot(d, ItemsCurrentItemBag_ID[pid] - 1))
        set temp_item = CreateItem(ItemsCurrentItem_ID_BACKUP[pid], GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster))
        if GetLocalPlayer() == p then
            call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + BlzGetItemTooltip(temp_item) + "|r")
            call BlzFrameSetText(FRAME_ShopItemDescriptionName2, BlzGetItemExtendedTooltip(temp_item))
            call BlzFrameSetText(FRAME_ShopItemCost[42], "|c00FFFF00" + I2S(value) + "|r")
        endif
        call RemoveItem(temp_item)
        set ItemsCurrentItem_ID[pid] = ItemsCurrentItem_ID_BACKUP[pid]
        if GetLocalPlayer() == p then
            call BlzFrameSetTexture(FRAME_ShopItemBack[42], BlzGetAbilityIcon(ItemsCurrentItem_ID[pid]), 0, false)
        endif
        call CraftItemCheck(ItemsCurrentItem_ID[pid], p, ItemsFrameCurrentPage_ID[pid])
        if GetLocalPlayer() == p then 
       call BlzFrameSetText(FRAME_ShopItemCost[36], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftUpperLeft_ID[pid]), ItemsCraftUpperLeft_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[37], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftUpperTop_ID[pid]), ItemsCraftUpperTop_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[38], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftUpperRight_ID[pid]), ItemsCraftUpperRight_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[39], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftLeft_ID[pid]), ItemsCraftLeft_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[40], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftBottom_ID[pid]), ItemsCraftBottom_ID[pid], false)) + "|r")
       call BlzFrameSetText(FRAME_ShopItemCost[41], "|c00FFFF00" + I2S(CheckItemsReduceCostCraft(d, GetItemValue(ItemsCraftRight_ID[pid]), ItemsCraftRight_ID[pid], false)) + "|r")   
        endif
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[7], false)
            call BlzFrameSetVisible(FRAME_ShopItemInventorySlot[6], true)
            call StopSound(gg_snd_ReceiveGold, false, false)
            call StartSound(gg_snd_ReceiveGold)
            call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, true)
        endif
    endif
    set d = null  
    set s = null
    set s_name = null
    set p = null
    set temp_item = null
endfunction
function PlayerInventoryPeriodic takes nothing returns nothing
    local integer i = 0
    local integer i2 = 0
    local integer id = 0
    local integer k = 0
    local unit d 
    loop
        exitwhen i == 10
        if Shop_Active[i] == true then
            set i2 = 0
            loop
                exitwhen i2 == 6
                set d = Hero[i]
                if TestMode == true and TestUnit != null  then
                set d = TestUnit 
                endif
                set id = GetItemTypeId(UnitItemInSlot(d, i2))
                if i2 == 0 then
                    set ItemsCurrentItemBagDescription_ID0[i] = id
                elseif i2 == 1 then
                    set ItemsCurrentItemBagDescription_ID1[i] = id
                elseif i2 == 2 then
                    set ItemsCurrentItemBagDescription_ID2[i] = id
                elseif i2 == 3 then
                    set ItemsCurrentItemBagDescription_ID3[i] = id
                elseif i2 == 4 then
                    set ItemsCurrentItemBagDescription_ID4[i] = id
                elseif i2 == 5 then
                    set ItemsCurrentItemBagDescription_ID5[i] = id
                endif
                if GetLocalPlayer() == Player(i) then
                    if id != 0 then
                        call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i2], BlzGetAbilityIcon(id), 0, false)
                    else
                        call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i2], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
                    endif
                endif
                set k = GetItemValue(id)
                if k > 0 then
                    if GetLocalPlayer() == Player(i) then
                        call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i2], "|c00FFFF00" + I2S(R2I(k * 0.75)) + "|r")
                    endif
                else
                    if GetLocalPlayer() == Player(i) then
                        call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i2], "|c00FFFF00" + "" + "|r")
                    endif
                endif
                set i2 = i2 + 1
            endloop
        endif
        set i = i + 1
    endloop
    set d = null
endfunction
function CreateItemUI takes nothing returns nothing
    local integer i = 0
    local integer i2 = 0
    local integer k = 0
    local real x = 0.015
    local real y = -0.05
    local framehandle border
    local timer t = CreateTimer()
    set FrameClick2 = CreateTrigger()
    set FrameGuideEnter2 = CreateTrigger()
    set FrameGuideLeave2 = CreateTrigger()
    call MyItemsIdInit()
    // === Главный контейнер ===
    set FRAME_ShopMAIN = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopMAIN, FRAMEPOINT_CENTER, 0.42, 0.33)
    call BlzFrameSetSize(FRAME_ShopMAIN, 0.96, 0.36)
    set FRAME_ShopItemList = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemList, FRAMEPOINT_CENTER, 0.31, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemList, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemList, 155)
    call BlzFrameSetSize(FRAME_ShopItemList, 0.38, 0.28)
    set FRAME_ShopItemCraft = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemCraft, FRAMEPOINT_CENTER, 0.5775, 0.405)
    call BlzFrameSetTexture(FRAME_ShopItemCraft, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemCraft, 155)
    call BlzFrameSetSize(FRAME_ShopItemCraft, 0.18, 0.18)
    set FRAME_ShopItemDescription = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemDescription, FRAMEPOINT_CENTER, 0.5775, 0.2725)
    call BlzFrameSetTexture(FRAME_ShopItemDescription, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemDescription, 155)
    call BlzFrameSetSize(FRAME_ShopItemDescription, 0.18, 0.115)
    set FRAME_ShopItemDescriptionName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)
    call BlzFrameSetPoint(FRAME_ShopItemDescriptionName, FRAMEPOINT_BOTTOM, FRAME_ShopItemDescription, FRAMEPOINT_TOP, 0, -0.0225 )// - 0.03 * i)
    call BlzFrameSetText(FRAME_ShopItemDescriptionName, "|c00FFFF00" + "Item name" + "|r")
    set FRAME_ShopItemDescriptionName2 = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemDescription, "", 0)
    call BlzFrameSetSize(FRAME_ShopItemDescriptionName2, 0.15, 0.08)
    call BlzFrameSetPoint(FRAME_ShopItemDescriptionName2, FRAMEPOINT_BOTTOM, FRAME_ShopItemDescription, FRAMEPOINT_CENTER, 0, -0.045 )// - 0.03 * i)
    call BlzFrameSetText(FRAME_ShopItemDescriptionName2, "|c00FFFF00" + "" + "|r")
    set FRAME_ShopItemInventory = BlzCreateFrame("EscMenuBackdrop", FRAME_ShopMAIN, 1, 0)
    call BlzFrameSetAbsPoint(FRAME_ShopItemInventory, FRAMEPOINT_CENTER, 0.7225, 0.355)
    call BlzFrameSetTexture(FRAME_ShopItemInventory, "textures\\black32.blp", 0, true)
    call BlzFrameSetAlpha(FRAME_ShopItemInventory, 155)
    call BlzFrameSetSize(FRAME_ShopItemInventory, 0.135, 0.28)
    set FRAME_ShopItemInventoryName = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventory, "", 0)
    call BlzFrameSetPoint(FRAME_ShopItemInventoryName, FRAMEPOINT_BOTTOM, FRAME_ShopItemInventory, FRAMEPOINT_TOP, 0, -0.025 )// - 0.03 * i)
    call BlzFrameSetText(FRAME_ShopItemInventoryName, "|c00FFFF00" + "Inventory" + "|r")
    set FRAME_ShopItemCraftSprite = BlzCreateFrameByType("SPRITE", "justAName", FRAME_ShopItemCraft, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemCraft, FRAMEPOINT_CENTER, 0.0, 0.0)
    call BlzFrameSetSize(FRAME_ShopItemCraftSprite, 1., 1.)
    call BlzFrameSetScale(FRAME_ShopItemCraftSprite, 1.)
    call BlzFrameSetModel(FRAME_ShopItemCraftSprite, "Pick\\selecter5.mdx", 0)
    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite, false)
    set FRAME_ShopItemCraftSprite2 = BlzCreateFrameByType("SPRITE", "justAName", FRAME_ShopItemInventory, "WarCraftIIILogo", 0)
    call BlzFrameSetPoint(FRAME_ShopItemCraftSprite2, FRAMEPOINT_BOTTOMLEFT, FRAME_ShopItemInventory, FRAMEPOINT_CENTER, -0.025, 0.08)
    call BlzFrameSetSize(FRAME_ShopItemCraftSprite2, 1., 1.)
    call BlzFrameSetScale(FRAME_ShopItemCraftSprite2, 1.)
    call BlzFrameSetModel(FRAME_ShopItemCraftSprite2, "Pick\\selecter5.mdx", 0)
    call BlzFrameSetVisible(FRAME_ShopItemCraftSprite2, false)
    set y = 0.47
    set x = 0.075
    set i = 0
    loop
        exitwhen i == 7
        // Кликабельный фрейм (кнопка)
        set FRAME_ShopSection[i] = BlzCreateFrameByType("GLUETEXTBUTTON", "MyHeroNameButton", FRAME_ShopMAIN, "ScriptDialogButton", 0)
        call BlzFrameSetAbsPoint(FRAME_ShopSection[i], FRAMEPOINT_CENTER, x, y)
        call BlzFrameSetSize(FRAME_ShopSection[i], 0.11, 0.03)
        if i == 0 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Recommended")
        elseif i == 1 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Base")
        elseif i == 2 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Strength")
        elseif i == 3 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Agility")
        elseif i == 4 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Intelligence")
        elseif i == 5 then
            call BlzFrameSetText(FRAME_ShopSection[i], "Universal")
        else
            call BlzFrameSetText(FRAME_ShopSection[i], "Defensive")
        endif
    // Клик
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopSection[i], FRAMEEVENT_CONTROL_CLICK)
        set i = i + 1
        set y = y - 0.03
    endloop
    set i = 0
    set x = 0.02
    set y = -0.039
    loop
        exitwhen i == 35
        // Кликабельный фрейм (кнопка)
        set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemList, "ScoreScreenTabButtonTemplate", 0)
        set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        call BlzFrameSetAllPoints(FRAME_ShopItemBack[i], FRAME_ShopItem[i])
        call BlzFrameSetPoint(FRAME_ShopItem[i], FRAMEPOINT_LEFT, FRAME_ShopItemList, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )// - 0.03 * i)
    //call BlzFrameSetAbsPoint(FRAME_ICON[i], FRAMEPOINT_CENTER, -0.11, 0.21)
        call BlzFrameSetSize(FRAME_ShopItem[i], 0.04, 0.04)
        set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemList, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.03 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_ShopItemCost[i], "|c00FFFF00" + "" + "|r")
        //call BlzFrameSetAbsPoint(FRAME_ICON[i], FRAMEPOINT_CENTER, -0.11, 0.21)
       // call BlzFrameSetSize(FRAME_ShopItem[i], 0.04, 0.04)
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItem[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetAlpha(FRAME_ShopItemBack[i],255)
        set k = k + 1
        set i = i + 1
        if i == 7 or i == 14 or i == 21 or i == 28 or i == 35 then
            set k = 0
            set y = y - 0.05
        endif
    endloop
    set y = y + 0.25
    set x = x + 0.00
    set i = 36
    loop
        exitwhen i == 43
        if i == 42 then
            set k = 0
            set x = x + 0.05
            set y = y + 0.05
        endif
        set FRAME_ShopItem[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemCraft, "ScoreScreenTabButtonTemplate", 0)
        set FRAME_ShopItemBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetAllPoints(FRAME_ShopItemBack[i], FRAME_ShopItem[i])
        call BlzFrameSetPoint(FRAME_ShopItem[i], FRAMEPOINT_LEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )// - 0.03 * i)
        call BlzFrameSetSize(FRAME_ShopItem[i], 0.04, 0.04)
        set FRAME_ShopItemCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItem[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.03 )// - 0.03 * i)
        call BlzFrameSetText(FRAME_ShopItemCost[i], "|c00FFFF00" + "" + "|r")
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItem[i], FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(FrameGuideEnter2, FRAME_ShopItem[i], FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(FrameGuideLeave2, FRAME_ShopItem[i], FRAMEEVENT_MOUSE_LEAVE)
        if i == 42 then
            set FRAME_ShopItemCraftGoldSlot = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItemCraft, "", 0)
            call BlzFrameSetTexture(FRAME_ShopItemCraftGoldSlot, "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder2", 0, false)
        //call BlzFrameSetPoint(FRAME_ShopItemCraftGoldSlot, FRAMEPOINT_LEFT, FRAME_ShopItemCraft, FRAMEPOINT_TOPLEFT, x + 0.05 * k, y )
            call BlzFrameSetAllPoints(FRAME_ShopItemCraftGoldSlot, FRAME_ShopItem[42])
            call BlzFrameSetLevel(FRAME_ShopItemCraftGoldSlot, 5)
        else
            call BlzFrameSetVisible(FRAME_ShopItemBack[i], false)
        endif
        call BlzFrameSetAlpha(FRAME_ShopItemBack[i],255)
        call BlzFrameSetTexture(FRAME_ShopItemBack[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn", 0, false)
        set k = k + 1
        set i = i + 1
        if i == 39 then
            set k = 0
            set y = y - 0.1
        endif
    endloop
    set y = -0.06
    set x = 0.0225
    set i = 0
    set k = 0
    loop
        exitwhen i == 8
        set FRAME_ShopItemInventorySlot[i] = BlzCreateFrameByType("BUTTON", "MyIconButton", FRAME_ShopItemInventory, "ScoreScreenTabButtonTemplate", 0)
        set FRAME_ShopItemInventorySlotBack[i] = BlzCreateFrameByType("BACKDROP", "MyIconButtonIcon", FRAME_ShopItemInventorySlot[i], "", 0)
        call BlzFrameSetAllPoints(FRAME_ShopItemInventorySlotBack[i], FRAME_ShopItemInventorySlot[i])
        call BlzFrameSetPoint(FRAME_ShopItemInventorySlot[i], FRAMEPOINT_LEFT, FRAME_ShopItemInventory, FRAMEPOINT_TOPLEFT, x + 0.0525 * k, y )// - 0.03 * i)
        call BlzFrameSetSize(FRAME_ShopItemInventorySlot[i], 0.04, 0.04)
        call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "ReplaceableTextures\\CommandButtons\\BTNHero_Placeholder", 0, false)
        set FRAME_ShopItemInventorySlotCost[i] = BlzCreateFrameByType("TEXT", "MyIconButtonCost", FRAME_ShopItemInventorySlot[i], "", 0)
        call BlzFrameSetPoint(FRAME_ShopItemInventorySlotCost[i], FRAMEPOINT_BOTTOM, FRAME_ShopItemInventory, FRAMEPOINT_TOPLEFT, (x + 0.02) + 0.05 * k, y - 0.032 )// - 0.03 * i)
        if i == 6 then
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "")
            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "Pick\\BuyButton", 0, true)
            call BlzFrameSetAlpha(FRAME_ShopItemInventorySlotBack[i], 255)
        elseif i == 7 then
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "")
       // call BlzFrameSetAlpha(FRAME_ShopItemInventorySlotBack[i],125)
            call BlzFrameSetTexture(FRAME_ShopItemInventorySlotBack[i], "Pick\\SellButton", 0, true)
        else
            call BlzFrameSetText(FRAME_ShopItemInventorySlotCost[i], "|c00FFFF00" + "" + "|r")
        endif
        call BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItemInventorySlot[i], FRAMEEVENT_CONTROL_CLICK)
        set k = k + 1
        set i = i + 1
        if i == 2 or i == 4 or i == 6 then
            set k = 0
            set y = y - 0.055
        endif
    endloop
    call TriggerAddAction(FrameClick2, function OnClickItem)
    call TriggerAddAction(FrameGuideEnter2, function GuideEnterItem)
    call TriggerAddAction(FrameGuideLeave2, function GuideLeaveItem)
    call TimerStart(t, 0.1, true, function PlayerInventoryPeriodic)
    call BlzFrameSetVisible(FRAME_ShopMAIN, false)
    set t = null
endfunction
//===========================================================================
function InitTrig_WoS_Shop_Init takes nothing returns nothing
    set gg_trg_WoS_Shop_Init = CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_WoS_Shop_Init, 8, false)
    call TriggerAddAction( gg_trg_WoS_Shop_Init, function CreateItemUI )
endfunction


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com

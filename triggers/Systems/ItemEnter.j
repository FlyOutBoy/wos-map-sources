globals
    hashtable ItemCache = InitHashtable()
endglobals
function debugcditem takes integer i returns boolean 
return i == 'I012' or i == 'I01P' or i == 'I01O' or i == 'I01Q' or i == 'I00M' or i == 'I00X' or i == 'I00L' or i == 'I01I' or i == 'I00H' or i == 'I020' or i == 'I023' or i == 'I024'
endfunction

function RefreshItemCache takes unit u returns nothing
    local integer unitHid = GetHandleId(u)
    local integer slot = 0
    local item it

    // Удаляем старые данные об инвентаре этого юнита.
    call FlushChildHashtable(ItemCache, unitHid)

    loop
        exitwhen slot > 5

        set it = UnitItemInSlot(u, slot)

        if it != null then
            call SaveBoolean(ItemCache,unitHid,GetItemTypeId(it),true)
        endif

        set slot = slot + 1
    endloop

    set it = null
endfunction
function getdebugcditem_abi_id takes integer i returns integer
local integer id = 0
if i == 'I012' then 
set id = 'A04Y'
endif
if i == 'I01P' then 
set id = 'A081'
endif
if i == 'I01O' then 
set id = 'A07O'
endif
if i == 'I01Q' then 
set id = 'A080'
endif
if i == 'I00M' then 
set id = 'A01W'
endif
if i == 'I00X' then 
set id = 'A04Q'
endif
if i == 'I00L' then 
set id = 'A01D'
endif
if i == 'I01I' then 
set id = 'A07E'
endif
if i == 'I01I' then 
set id = 'A07E'
endif
if i == 'I00H' then 
set id = 'A01I'
endif
if i == 'I020' then 
set id = 'A09U'
endif
if i == 'I023' then 
set id = 'A0BY'
endif
if i == 'I024' then 
set id = 'A0BZ'
endif
return id
endfunction
function Trig_ItemEnter_Actions takes nothing returns nothing
local unit c = GetTriggerUnit()
local item ti = GetManipulatedItem()
local integer id = GetItemTypeId(ti)
local integer i = GetPlayerId(GetOwningPlayer(c))
local integer k = 0
local real r = 0
local integer owner = GetItemUserData(ti)
local integer p = i+1
local integer check = 0
if id == 'I00C' then
call AddHpRegen(c,5,true) 
endif
if id == 'I03I' then
call AddHpRegen(c,10,true) 
endif
if id == 'I03J' then
call AddHpRegen(c,15,true) 
endif
if id == 'I03O' then
call AddHpRegen(c,20,true) 
endif
if id == 'I03P' then
call AddHpRegen(c,25,true) 
endif
if debugcditem(id) then 
set r = LoadReal(hs,GetHandleId(c),StringHash(I2S(id)))
set k = getdebugcditem_abi_id(id)
if r > 0 then 
if k == 'A01W' then 
call UnitRemoveAbility(c,'A07Q')
call MyRemoveAbility(c,r,'A07Q',0)
endif
call BlzStartUnitAbilityCooldown(c,k,r)
endif
endif

if id == 'I00Y' then
call AddHpRegen(c,20,true) 
endif
if id == 'I027' then
call AddHpRegen(c,2,true) 
endif
if id == 'I026' then
call AddMpRegen(c,2,true) 
endif
if id == 'I028' then
call AddMpRegen(c,4,true)
call AddHpRegen(c,5,true) 
endif
if id == 'I00H' then
//call AddHpRegen(c,5,true) 
endif
if id == 'I01I' then
endif
if id == 'I01B' then
endif
if id == 'I011' then
call AddHpRegen(c,20,true) 
endif
if id == 'I020' then
call AddHpRegen(c,15,true) 
endif
if id == 'I021' then
//call AddMpRegen(c,4,true) 
endif
if id == 'I024' then
call AddHpRegen(c,20,true) 
endif
if id == 'I025' then
call AddHpRegen(c,20,true) 
endif
if id == 'I00D' then
call AddMpRegen(c,2,true) 
endif
if id == 'I03K' then
call AddMpRegen(c,4,true) 
endif
if id == 'I03L' then
call AddMpRegen(c,6,true) 
endif
if id == 'I03M' then
call AddMpRegen(c,8,true) 
endif
if id == 'I03N' then
call AddMpRegen(c,10,true) 
endif
if id == 'I00O' then
call AddMpRegen(c,4,true) 
call AddSpellLevel(c,'A01C',7,true)
    endif
    if id == 'I01N' then
call AddHpRegen(c,10,true)
call AddSpellLevel(c,'A01C',7,true)
    endif
    if id == 'I00G' then
    call AddMpRegen(c,1,true) 
    endif
if id == 'I00T' then
endif
if id == 'I00E' then 
call AddSpellLevel(c,'A01C',10,true)
endif
if id == 'I007' then 
call AddSpellLevel(c,'A01C',5,true)
endif
if id == 'I018' then
call AddMpRegen(c,4,true)
endif
if id == 'I017' then
call AddMpRegen(c,4,true)
call AddHpRegen(c,5,true) 
call AddSpellLevel(c,'A01C',2,true)
endif
if id == 'I03U' then
call AddMpRegen(c,6,true)
call AddHpRegen(c,15,true) 
call AddSpellLevel(c,'A01C',3,true)
endif
if id == 'I00N'  then
call AddSpellLevel(c,'A01C',4,true)
endif
if id == 'I00M' or id == 'I043' then 
set k = GetItemCharges(UnitItemInSlot(Hero[i],IsItemInInventory3(Hero[i],'I00M')))
    if k== 0 then 
    set k = 1000
    endif
    if k> 9999 then 
    set k = 9999
    endif
    call SetItemCharges(UnitItemInSlot(Hero[i],IsItemInInventory3(Hero[i],'I00M')),k)
    endif
if i<10 and TestMode == false then 
//call SetItemDroppable(ti,false)
endif
    if owner == 0 then
        call SetItemUserData(ti,p)
    elseif owner != p then
    set check = 1
        call UnitRemoveItem(c,ti)
        call SetItemPosition(ti,GetUnitX(c),GetUnitY(c))
    endif
    if check == 0 then 
// Учёт статистики использует уже существующий ItemEnter-триггер.
// Вызов идёт после проверки владельца: отклонённый чужой предмет не считается.
//call SaveSystem_OnItemAcquired(c, ti)
call IsItemInInventory4(c,id)
call IsItemInInventory42(c,'I01Q','I01Y','I01X')
call IsItemInInventory42(c,'I024','I025','ZZZZ')
call IsItemInInventory42(c,'I00E','I00O','I01N')
call IsItemInInventory42(c,'I00J','I01M','ZZZZ')
call IsItemInInventory42(c,'I00R','I01L','ZZZZ')
call IsItemInInventory42(c,'I02T','I03F','I03E')

 call AddAinzItemGoldCost(c, ti)
endif
call RefreshItemCache(c)
set ti = null
set c = null
endfunction

//=================================================================================
function InitTrig_ItemEnter takes nothing returns nothing
    set gg_trg_ItemEnter = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ItemEnter, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddAction( gg_trg_ItemEnter, function Trig_ItemEnter_Actions )
endfunction


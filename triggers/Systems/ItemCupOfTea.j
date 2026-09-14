function ItemCupOfTeaActions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer())
    local integer r = S2I(SubString(GetEventPlayerChatString(), 5, 9))
    if IsItemInInventory(Hero[i],'I00M') > 0 then 
    if r< 200 then 
    set r = 200
    endif
    if r> 9999 then 
    set r = 9999
    endif
    call SetItemCharges(UnitItemInSlot(Hero[i],IsItemInInventory3(Hero[i],'I00M')),r)
    endif
    set r = 0
endfunction
//===========================================================================
function InitTrig_ItemCupOfTea takes nothing returns nothing
    local trigger ItemCupOfTea  = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i == 10
        call TriggerRegisterPlayerChatEvent(ItemCupOfTea , Player(i), "-cup", false)
        set i = i + 1
    endloop
    call TriggerAddAction(ItemCupOfTea , function ItemCupOfTeaActions)
    set ItemCupOfTea  = null
endfunction



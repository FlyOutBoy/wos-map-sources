function DDDeathAlly_Actions takes nothing returns nothing
local unit c = GetKillingUnit()
local unit td = GetDyingUnit()
local integer i = GetPlayerId(GetOwningPlayer(td))
local integer k = 0
local real r1 = 0
loop
exitwhen k==12
if IsPlayerAlly(Player(i),Player(k)) and GetUnitTypeId(Hero[k]) == Harribel_ID and IsUnitIllusion(td) == false and IsUnitType(td,UNIT_TYPE_HERO) and GetUnitAbilityLevel(td,'Aloc')== 0 and GetUnitTypeId(td)!= 'H035' and td != Hero[k] then 
call HarribelPas(Hero[k])
endif
set k = k + 1
endloop
if LoadInteger(hs,GetHandleId(GetOwningPlayer(c)),StringHash("t immun time")) == 1 and LoadInteger(hs,GetHandleId(GetOwningPlayer(td)),StringHash("t immun time target")) ==1 then // alucard t
   if GetUnitState(c,UNIT_STATE_LIFE) <= (GetUnitState(c,UNIT_STATE_MAX_LIFE)*(AlucardT_HpToHealCondition/100)) then 
   set r1 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("t immun add heal"))
   call SetHpCurrent(c,r1*GetUnitState(c,UNIT_STATE_MAX_LIFE))
   endif 
   call MakeSound("war3mapimported\\HeroAlucard_Kill")
   endif 
set c = null
set td = null
endfunction

//===========================================================================
function InitTrig_AllyDie takes nothing returns nothing
    local trigger DeathAlly = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( DeathAlly, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddAction( DeathAlly, function DDDeathAlly_Actions )
    set DeathAlly = null
endfunction


function Trig_Death_Conditions takes nothing returns boolean
   return true
endfunction

function Trig_Death_Actions takes nothing returns nothing
    local unit c = GetKillingUnit()
    local unit td = GetDyingUnit()
    local integer id = GetPlayerId(GetOwningPlayer(c))
    local integer id2 = GetPlayerId(GetOwningPlayer(td))
    local integer c_id = GetUnitTypeId(c)
    local integer td_id = GetUnitTypeId(td)
    if IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true  and IsUnitIllusion(GetTriggerUnit())== false then 
    if c != null and c!= td and IsUnitAlly(td,Player(id)) == false then
    set PlayerKill[id] = PlayerKill[id] + 1
    endif
    set PlayerDeath[id2] = PlayerDeath[id2] + 1
    if VIPCheckLvl3(FramePlayerFirstName[id2]) or VIPCheckLvl2(FramePlayerFirstName[id2]) or VIPCheckLvl1(FramePlayerFirstName[id2])  then
    call DestroyEffect(EffectSpawn("war3mapImported\\wos_58.mdl",GetUnitX(td),GetUnitY(td),270,0.5,2,25))
    else
    call DestroyEffect(EffectSpawn("war3mapImported\\wos_dead.mdl",GetUnitX(td),GetUnitY(td),270,1,2,1))
    endif
    if td_id == Raiden_ID then 
    if GetRandomInt(1,2) == 1 then 
    call MakeSound("war3mapimported\\Hero_Raiden_Death")
    else
    call MakeSound("war3mapimported\\Hero_Raiden_Death2")
    endif
    elseif td_id == Natsu_ID then
    call MakeSound("war3mapimported\\Hero_Natsu_Death")
    elseif td_id == Gojo_ID or td_id ==  Tomioka_ID or td_id ==  Erza_ID  or td_id ==  Kyoraku_ID or td_id ==  DarkShiki_ID then
    call MakeSound("war3mapimported\\Hero_Gojo_RW3")
    elseif td_id == AlterSaber_ID then
    call MakeSound("war3mapimported\\Hero_AlterSaber_Death")  
    elseif td_id == Kenjaku_ID then
    call MakeSound("war3mapimported\\Hero_Kenjaku_Death")  
    elseif td_id == Inori_ID then
    call MakeSound("war3mapimported\\Hero_Inori_Death")  
    elseif td_id == Akainu_ID then
    call MakeSound("war3mapimported\\Hero_Akainu_Death")  
    elseif td_id == Okarun_ID then
    call MakeSound("war3mapimported\\Hero_Okarun_Death")  
    elseif td_id == Neuvillette_ID then
    call MakeSound("war3mapimported\\Hero_Neuvillette_Death") 
    elseif td_id == Tsuna_ID then
    call MakeSound("war3mapimported\\Hero_Tsuna_Death")  
    elseif td_id == BazzB_ID then
    call MakeSound("war3mapimported\\Hero_BazzB_Death")  
    elseif td_id == Takeshi_ID then
    call MakeSound("war3mapimported\\Hero_Takeshi_Death")  
    endif
    if c != null and c!= td then
    call PlayersMsg(GetPlayerColorString(Player(id))+GetPlayerName(Player(id))+"|r killed "+GetPlayerColorString(Player(id))+GetPlayerName(Player(id2))+"|r",2)
    if GetUnitTypeId(td) == Patriot_ID and GetHeroLevel(td)>=35 then 
    call PatriotEE_Start(td,c)
    endif
    endif
    elseif IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == false  and IsUnitIllusion(GetTriggerUnit())== false then
    if GetUnitTypeId(td) == KenjakuQ2_Dummy_ID  or GetUnitTypeId(td) == KenjakuW2_Dummy_ID  or GetUnitTypeId(td) == KenjakuE2_Dummy_ID then
call MyRemoveUnit(td,6)
call PauseUnit(td,true)
    if GetUnitTypeId(td) == KenjakuQ2_Dummy_ID  then 
    call RemoveSavedHandle(hs,GetHandleId(Player(id2)),StringHash("kenjaku unit q"))
    call SetPlayerAbilityAvailable(Player(id2),KenjakuQ2_ID,true)
    call SetPlayerAbilityAvailable(Player(id2),KenjakuQ3_ID,false)
    if GetUnitUserData(td) != 10 then 
    call BlzStartUnitAbilityCooldown(Hero[id2],KenjakuQ2_ID, BlzGetUnitAbilityCooldown(Hero[id2],KenjakuQ2_ID,GetUnitAbilityLevel(Hero[id2],KenjakuQ2_ID)-1))
    endif
 elseif GetUnitTypeId(td) == KenjakuW2_Dummy_ID  then    
 call RemoveSavedHandle(hs,GetHandleId(Player(id2)),StringHash("kenjaku unit w"))
    call SetPlayerAbilityAvailable(Player(id2),KenjakuW2_ID,true)
    call SetPlayerAbilityAvailable(Player(id2),KenjakuW3_ID,false)
    if GetUnitUserData(td) != 10 then
    call BlzStartUnitAbilityCooldown(Hero[id2],KenjakuW2_ID, BlzGetUnitAbilityCooldown(Hero[id2],KenjakuW2_ID,GetUnitAbilityLevel(Hero[id2],KenjakuW2_ID)-1))
    endif
 elseif GetUnitTypeId(td) == KenjakuE2_Dummy_ID  then    
 call RemoveSavedHandle(hs,GetHandleId(Player(id2)),StringHash("kenjaku unit e"))
    call SetPlayerAbilityAvailable(Player(id2),KenjakuE2_ID,true)
    call SetPlayerAbilityAvailable(Player(id2),KenjakuE3_ID,false)
    if GetUnitUserData(td) != 10 then
    call BlzStartUnitAbilityCooldown(Hero[id2],KenjakuE2_ID, BlzGetUnitAbilityCooldown(Hero[id2],KenjakuE2_ID,GetUnitAbilityLevel(Hero[id2],KenjakuE2_ID)-1))
    endif
    endif
endif
    endif
    set c = null
    set td = null
endfunction

//===========================================================================
function InitTrig_Death takes nothing returns nothing
    set gg_trg_Death = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Death, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Death, Condition( function Trig_Death_Conditions ) )
    call TriggerAddAction( gg_trg_Death, function Trig_Death_Actions )
endfunction


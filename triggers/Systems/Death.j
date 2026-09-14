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
    local integer k = 0
    local integer k2 = 0
    local boolean death = true 
    if IsUnitType(td, UNIT_TYPE_HERO) == true  and IsUnitIllusion(td)== false then 
    
    if IsUnitEnemy(td,GetOwningPlayer(c)) then 
    set k = 0
    loop
    exitwhen k == 10 
    if GetUnitTypeId(Hero[k]) == Rimuru_ID and td != Hero[k] and LoadInteger(hs, GetHandleId(Hero[k]), StringHash("evol kill")) < RimuruEvol2_Counter and LoadInteger(hs,GetHandleId(Hero[k]),StringHash("rimuru evol 2")) == 0 and LoadInteger(hs,GetHandleId(Hero[k]),StringHash("rimuru evol 1")) == 1 then 
    set k2 = LoadInteger(hs, GetHandleId(Hero[k]), StringHash("evol kill"))+1 
    call SaveInteger(hs,GetHandleId(Hero[k]), StringHash("evol kill") ,k2)
    call BlzFrameSetValue(frameRimuru2_pas3[k], I2R(k2))
    call BlzFrameSetText(frameRimuru2_pas6[k], "|c00FFFF00" + I2S(k2)+"/" + I2S(RimuruEvol2_Counter) + "|r")
    endif
    set k = k + 1
    endloop
    else
    set k = 0
    loop
exitwhen k==10
if IsPlayerAlly(Player(id2),Player(k)) and GetUnitTypeId(Hero[k]) == Harribel_ID and GetUnitAbilityLevel(td,'Aloc')== 0 and td != Hero[k] then 
call HarribelPas(Hero[k])
endif
set k = k + 1
endloop
    endif
    if GetUnitTypeId(td) == Patriot_ID and GetHeroLevel(td)>=35 and LoadInteger(hs,GetHandleId(td),StringHash("deathcheck"))== 0 then 
    call PatriotEE_Start(td,c)
    call SaveInteger(hs,GetHandleId(td),StringHash("deathcheck"),1)
    call MyFlush(GetHandleId(td),StringHash("deathcheck"),0,15)
    set death = false
    endif
    if c != null and c!= td and IsUnitAlly(td,Player(id)) == false then
    set PlayerKill[id] = PlayerKill[id] + 1
    endif
    if death == true then
    set PlayerDeath[id2] = PlayerDeath[id2] + 1
    
    if VIPCheckLvl3(FramePlayerFirstName[id2]) or VIPCheckLvl2(FramePlayerFirstName[id2]) or VIPCheckLvl1(FramePlayerFirstName[id2])  then
    call DestroyEffect(EffectSpawn("war3mapImported\\wos_58.mdl",GetUnitX(td),GetUnitY(td),270,0.5,2,25))
    else
    call DestroyEffect(EffectSpawn("war3mapImported\\wos_dead.mdl",GetUnitX(td),GetUnitY(td),270,1,2,1))
    endif
    endif
    if death then 
    if td_id == Raiden_ID then 
    if GetRandomInt(1,2) == 1 then 
    call MakeSound("war3mapimported\\Hero_Raiden_Death")
    else
    call MakeSound("war3mapimported\\Hero_Raiden_Death2")
    endif
    elseif td_id == Natsu_ID then
    call MakeSound("war3mapimported\\Hero_Natsu_Death")
    elseif td_id == AlterSaber_ID then
    call MakeSound("war3mapimported\\Hero_AlterSaber_Death")  
    elseif td_id == Kenjaku_ID then
    call MakeSound("war3mapimported\\Hero_Kenjaku_Death")  
    elseif td_id == Rimuru_ID then
    call MakeSound("war3mapimported\\Hero_Rimuru_Death")  
    elseif td_id == Inori_ID then
    call MakeSound("war3mapimported\\Hero_Inori_Death")  
    elseif td_id == Akainu_ID then
    call MakeSound("war3mapimported\\Hero_Akainu_Death")  
    elseif td_id == Okarun_ID then
    call MakeSound("war3mapimported\\Hero_Okarun_Death")
    elseif td_id == Patriot_ID then
    call MakeSound("war3mapimported\\Hero_Patriot_Death")
    elseif td_id == Toji_ID then
    call MakeSound("war3mapimported\\Hero_Toji_Death")
    elseif td_id == Neuvillette_ID then
    call MakeSound("war3mapimported\\Hero_Neuvillette_Death") 
    elseif td_id == Tsuna_ID then
    call MakeSound("war3mapimported\\Hero_Tsuna_Death")  
    elseif td_id == Mahoraga_ID then
    call MakeSound("war3mapimported\\Hero_Mahoraga_Death")
    elseif td_id == Bambietta_ID then
    call MakeSound("war3mapimported\\Hero_Bambietta_Death")  
    elseif td_id == BazzB_ID then
    call MakeSound("war3mapimported\\Hero_BazzB_Death")  
    elseif td_id == Takeshi_ID then
    call MakeSound("war3mapimported\\Hero_Takeshi_Death")  
    else
    call MakeSound("war3mapimported\\Hero_Gojo_RW3")
    endif
    if td_id == Gojo_ID and c_id == Toji_ID then 
    call MakeSound("war3mapimported\\Hero_Toji_GojoKill")
    endif
    if c != null and c!= td then
    call PlayersMsg(GetPlayerVisualColorString(Player(id))+GetPlayerName(Player(id))+"|r killed "+GetPlayerVisualColorString(Player(id2))+GetPlayerName(Player(id2))+"|r",2)
    endif
    endif
    
    elseif IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == false  and IsUnitIllusion(GetTriggerUnit())== false then
    if GetUnitTypeId(td)== FrierenTR_unitid then 
    call RemoveUnit(td)
    endif
    if GetUnitTypeId(td) == KenjakuQ2_Dummy_ID  or GetUnitTypeId(td) == KenjakuW2_Dummy_ID  or GetUnitTypeId(td) == KenjakuE2_Dummy_ID then
call MyRemoveUnit(td,6)
call PauseUnit(td,true)
    if GetUnitTypeId(td) == KenjakuQ2_Dummy_ID  then 
    call RemoveSavedHandle(hs,GetHandleId(Player(id2)),StringHash("kenjaku unit q"))
    if LoadInteger(hs, GetHandleId(Hero[id2]), StringHash("kit type"))  == 1 then 
    call SetPlayerAbilityAvailable(Player(id2),KenjakuQ2_ID,true)
    call SetPlayerAbilityAvailable(Player(id2),KenjakuQ3_ID,false)
    endif
    if GetUnitUserData(td) != 10 then 
    call BlzStartUnitAbilityCooldown(Hero[id2],KenjakuQ2_ID, BlzGetUnitAbilityCooldown(Hero[id2],KenjakuQ2_ID,GetUnitAbilityLevel(Hero[id2],KenjakuQ2_ID)-1))
    endif
 elseif GetUnitTypeId(td) == KenjakuW2_Dummy_ID  then    
 call RemoveSavedHandle(hs,GetHandleId(Player(id2)),StringHash("kenjaku unit w"))
    if LoadInteger(hs, GetHandleId(Hero[id2]), StringHash("kit type"))  == 1 then 
    call SetPlayerAbilityAvailable(Player(id2),KenjakuW2_ID,true)
    call SetPlayerAbilityAvailable(Player(id2),KenjakuW3_ID,false)
    endif
    if GetUnitUserData(td) != 10 then
    call BlzStartUnitAbilityCooldown(Hero[id2],KenjakuW2_ID, BlzGetUnitAbilityCooldown(Hero[id2],KenjakuW2_ID,GetUnitAbilityLevel(Hero[id2],KenjakuW2_ID)-1))
    endif
 elseif GetUnitTypeId(td) == KenjakuE2_Dummy_ID  then    
 call RemoveSavedHandle(hs,GetHandleId(Player(id2)),StringHash("kenjaku unit e"))
 if LoadInteger(hs, GetHandleId(Hero[id2]), StringHash("kit type"))  == 1 then 
    call SetPlayerAbilityAvailable(Player(id2),KenjakuE2_ID,true)
    call SetPlayerAbilityAvailable(Player(id2),KenjakuE3_ID,false)
    endif
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


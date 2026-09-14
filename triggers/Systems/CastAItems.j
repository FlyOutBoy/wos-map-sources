globals 
timer array clonetimer
unit array castitem1 
endglobals
function FixCloneModel takes nothing returns nothing
local timer t = GetExpiredTimer()
local integer h = GetHandleId(t)
local unit c = LoadUnitHandle(hs,h,0)
call FixModel(c)
call PauseTimer(t)
call FlushChildHashtable(hs,h)
set c = null
set t = null
endfunction
function BuffUnitOnce takes unit c, unit u, integer id,integer level, string order returns nothing
            local integer i = GetPlayerId(GetOwningPlayer(c))
            if castitem1[i] == null or GetWidgetLife(castitem1[i]) < 1 then
                set castitem1[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
                call UnitAddAbility(castitem1[i], id)
            endif
            if level > 0 then
                call SetUnitAbilityLevel(castitem1[i], 'A06F', level)
                call SetUnitFacing(castitem1[i], GAngle(castitem1[i], u) * bj_RADTODEG)
                call IssueTargetOrder(castitem1[i], order, u)
            endif
        endfunction
function ItemsCast takes unit c, unit td, real x,real y, integer id returns nothing
local real r = 0
local real x1 = 0
local real y1 = 0
local real sr = 0
local real cd 
local real r1 = 0
local integer i = GetPlayerId(GetOwningPlayer(c))
local real a = GAngle2(c,x,y)
if GetUnitAbilityLevel(c,'B00D')>0 then 
call SilenceUnit(c,c,Erza6R_Silence)
call UnitRemoveAbility(c,'B00D')
endif
/*if id == 'A0GH' then 
if IsItemInInventory(c,'I00T')>0 then 
call RemoveItem(UnitItemInSlot(c,IsItemInInventory3(c,'I00T')))
call UnitAddItemById(c,'I03U')
elseif IsItemInInventory(c,'I03U')>0 then
call RemoveItem(UnitItemInSlot(c,IsItemInInventory3(c,'I03U')))
call UnitAddItemById(c,'I00T')
endif
endif*/
if id == 'A0BZ' then 
if IsItemInInventory(c,'I024')>0 then 
call RemoveItem(UnitItemInSlot(c,IsItemInInventory3(c,'I024')))
call UnitAddItemById(c,'I025')
elseif IsItemInInventory(c,'I025')>0 then
call RemoveItem(UnitItemInSlot(c,IsItemInInventory3(c,'I025')))
call UnitAddItemById(c,'I024')
endif
endif
if id == 'A0G0' or  id == 'A0G1'  or  id == 'A0FD' then 
if IsItemInInventory(c,'I02T')>0 then 
call RemoveItem(UnitItemInSlot(c,IsItemInInventory3(c,'I02T')))
call UnitAddItemById(c,'I03E')
elseif IsItemInInventory(c,'I03E')>0 then
call RemoveItem(UnitItemInSlot(c,IsItemInInventory3(c,'I03E')))
call UnitAddItemById(c,'I03F')
elseif IsItemInInventory(c,'I03F')>0 then
call RemoveItem(UnitItemInSlot(c,IsItemInInventory3(c,'I03F')))
call UnitAddItemById(c,'I02T')
endif
endif
if id == 'A0E4' then 
call BuffUnitOnce(c,c,'A0E5',1,"innerfire")
endif
if id == 'A02I' then 
if clonetimer[i] == null then 
set clonetimer[i] = CreateTimer()
endif
call SaveUnitHandle(hs,GetHandleId(clonetimer[i]),0,c)
call TimerStart(clonetimer[i],1.3,false, function FixCloneModel)
endif
if id == 'A0AL' then 
call DebuffClear(c)
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_manaimpact.mdl",c,"origin"))
endif
// --- Heal Angel ---
if id == 'A02U' then
call HPS(c,c,(GetUnitState(c, UNIT_STATE_MAX_LIFE) * (AngelBlessing_Heal/100)),3)
//call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) + (GetUnitState(c, UNIT_STATE_MAX_LIFE) * 0.15))
call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_jntx-guangzhuyellow.mdl",c,"origin"),3)
endif
if id == NaofumiShield_ID then 
call Naofumi_Start(c)
endif 
if id == TurboNeko_ID then 
call TurboNeko_Start(c,td)
endif 
if id == Raijin_Wrath_ID then 
call RaijinWrath_Start(c,x,y)
endif
if id == Rhitta_ID then 
call Rhitta_Start(c,x,y)
endif
if id == TuskBarrel_ID then 
call TuskBarrel_Start(c,x,y)
endif
if id == Shark_Trail_ID then 
call SharkTrail_Start(c,td)
endif
if id == RedFlower_ID then 
call RedFlower_Start(c,td)
endif
if id == RockleeWeights_ID then 
call RockleeWeight_Start(c,x,y)
endif
if id == Chogurt_ID then 
call Chogurt_Start(c,x,y)
endif
if id == RedCup_ID then 
call RedCup_Start(c,x,y)
endif
if id == HokageHat_ID then
call SetMpCurrent(td,-HokageHat_Manaburn)
call RootUnit(c,td,HokageHat_RootTime)
if GetUnitTypeId(c) == Bambietta_ID and IsUnitEnemy(td,GetOwningPlayer(c)) and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
call BambiettaG_Start(c)
call BambiettaG2_Start(c,GetUnitX(td),GetUnitY(td))
endif
call EUTU2(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl",GetUnitX(td),GetUnitY(td),1,1,1,1),HokageHat_RootTime,1,td)
call EUTU2(EffectSpawn("war3mapImported\\wos_s225.mdl",GetUnitX(td),GetUnitY(td),1,1,1,1),HokageHat_RootTime,1,td)
endif
if id == HokageHatEvolved_ID then
if GetUnitTypeId(c) == Bambietta_ID and IsUnitEnemy(td,GetOwningPlayer(c)) and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
call BambiettaG_Start(c)
call BambiettaG2_Start(c,x,y)
endif
call HokageHatEvolved_Start(c,x,y)
endif
if id == Hiraishin_ID then
call BlinkEff(c)
call MakeSound("war3mapimported\\Item_Hiraishin")
call DestroyEffect(EffectSpawn("war3mapImported\\wos_1jinse_94.mdl",GetUnitX(c),GetUnitY(c),1,1,1,1))
call DestroyEffect(EffectSpawn("war3mapImported\\wos_0713.mdl",GetUnitX(c),GetUnitY(c),1,1,1,125))
call PosUnit(c,GetUnitX(td)+50*Cos(GAngle(c,td)),GetUnitY(td)+50*Sin(GAngle(c,td)))
if GetUnitTypeId(c) == Bambietta_ID and IsUnitEnemy(td,GetOwningPlayer(c)) and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
call BambiettaG_Start(c)
call BambiettaG2_Start(c,GetUnitX(td),GetUnitY(td))
endif
set cd = BlzGetUnitAbilityCooldown(c,'A076',GetUnitAbilityLevel(c,'A076')-1)/2
if IsUnitEnemy(td,GetOwningPlayer(c)) then 
call dmgatk(c,td,Hiraishin_DamageBase+(Hiraishin_Damage *GetMainStatValue(c,true) ))
if GetUnitAbilityLevel(td,'B02R')>0 then 
call BlzStartUnitAbilityCooldown(c,'A076',cd)
call CD_Start(c,0.03,'A076',cd)
endif
call BuffUnit01(c, td, 'A0GC', "curse", 1)
else
call CD_Start(c,0.03,'A076',cd)
call SetMpCurrent(td,200)
call SetMpCurrent(c,200)
endif
call BlinkEff(c)
call SetUnitX(c,GetUnitX(c))
call SetUnitY(c,GetUnitY(c))
call IssueTargetOrder(c,"attack",td)
call DestroyEffect(EffectSpawn("war3mapImported\\wos_1jinse_94.mdl",GetUnitX(c),GetUnitY(c),1,1,1,1))
call DestroyEffect(EffectSpawn("war3mapImported\\wos_0713.mdl",GetUnitX(c),GetUnitY(c),1,1,1,125))
call DestroyEffect(EffectSpawn("war3mapImported\\wos_1daji_4.mdl",GetUnitX(td),GetUnitY(td),1,1,1,125))
endif
/*
if BlzGetUnitAbilityCooldown(c,id,GetUnitAbilityLevel(c,id)-1)>=3 and IsItemInInventory(c,'I00U')>0 and BlzGetUnitAbilityCooldownRemaining(c,'A05H')==0  then 
call SetHpCurrent(c,GetUnitState(c,UNIT_STATE_MAX_LIFE)*0.025)
call BlzStartUnitAbilityCooldown(c,'A05H',2.5)
call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl",c,"origin"))
endif*/
if IsItemInInventory(c,'I012')>0 and BlzGetUnitAbilityCooldown(c,id,GetUnitAbilityLevel(c,id)-1)>=3  and BlzGetUnitAbilityCooldownRemaining(c,'A04Y')==0 and GetUnitState(c, UNIT_STATE_MANA) <= GetUnitState(c, UNIT_STATE_MAX_MANA) * 0.95 then
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_az_siwenpf1_w1.mdl",c,"origin"))
set r1 = FairyTailEmblem_ManaRestoreStatic + (GetUnitState(c,UNIT_STATE_MAX_MANA)*(FairyTailEmblem_ManaRestorePercent/100))
call SetMpCurrent(c,r1)
call SetHpCurrent2(c,c,FairyTailEmblem_HpRestoreStatic)
call BlzStartUnitAbilityCooldown(c,'A04Y',FairyTailEmblem_CD )
endif   
if IsItemInInventory(c,'I00H')>0 and BlzGetUnitAbilityCooldown(c,id,GetUnitAbilityLevel(c,id)-1)>=3  and BlzGetUnitAbilityCooldownRemaining(c,'A01I')==0  then
set r = 35
call BlzStartUnitAbilityCooldown(c,'A01I',2)
if GetUnitAbilityLevel(c,'A010') == 0 then 
call UnitAddAbility(c,'A010')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')))+1)
call MyRemoveAbility(c,r,'A010',1)
elseif GetUnitAbilityLevel(c,'A011') == 0 then 
call UnitAddAbility(c,'A011')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')))+1)
call MyRemoveAbility(c,r,'A011',1)
elseif GetUnitAbilityLevel(c,'A012') == 0 then 
call UnitAddAbility(c,'A012')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')))+1)
call MyRemoveAbility(c,r,'A012',1)
elseif GetUnitAbilityLevel(c,'A013') == 0 then 
call UnitAddAbility(c,'A013')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')))+1)
call MyRemoveAbility(c,r,'A013',1)
elseif GetUnitAbilityLevel(c,'A014') == 0 then 
call UnitAddAbility(c,'A014')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')))+1)
call MyRemoveAbility(c,r,'A014',1)
elseif GetUnitAbilityLevel(c,'A015') == 0 then 
call UnitAddAbility(c,'A015')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I00H')))+1)
call MyRemoveAbility(c,r,'A015',1)
endif
endif
if IsItemInInventory(c,'I01I')>0 and BlzGetUnitAbilityCooldown(c,id,GetUnitAbilityLevel(c,id)-1)>=3  and BlzGetUnitAbilityCooldownRemaining(c,'A07E')==0 then
set r = 35
call BlzStartUnitAbilityCooldown(c,'A07E',2)
if GetUnitAbilityLevel(c,'A07H') == 0 then 
call UnitAddAbility(c,'A07H')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')))+1)
call MyRemoveAbility(c,r,'A07H',1)
elseif GetUnitAbilityLevel(c,'A07I') == 0 then 
call UnitAddAbility(c,'A07I')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')))+1)
call MyRemoveAbility(c,r,'A07I',1)
elseif GetUnitAbilityLevel(c,'A07J') == 0 then 
call UnitAddAbility(c,'A07J')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')))+1)
call MyRemoveAbility(c,r,'A07J',1)
elseif GetUnitAbilityLevel(c,'A07F') == 0 then 
call UnitAddAbility(c,'A07F')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')))+1)
call MyRemoveAbility(c,r,'A07F',1)
elseif GetUnitAbilityLevel(c,'A07G') == 0 then 
call UnitAddAbility(c,'A07G')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')))+1)
call MyRemoveAbility(c,r,'A07G',1)
elseif GetUnitAbilityLevel(c,'A07K') == 0 then 
call UnitAddAbility(c,'A07K')
call SetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')),GetItemCharges(UnitItemInSlot(c,IsItemInInventory3(c,'I01I')))+1)
call MyRemoveAbility(c,r,'A07K',1)
endif
endif
 if id == 'A00Y' then 
 call ImmuneToPushDebuff(c)
 call MUE(c,625,0.175,GetUnitFacing(c)*bj_DEGTORAD)
 call BuffUnitMS(c,c,0.2)
 elseif id == FunnyBarrel_ID then 
 call FunnyBarrel_Start(c,x,y)
  elseif id == TsuchikageHat_ID then 
 call TsuchikageHat_Start(c,td)
 elseif id == TsuchikageHatEvolve_ID then 
 call TsuchikageHatEvolve_Start(c,td)
 elseif id == FunnyPresent_ID then 
 call FunnyPresent_Start(c,x,y)
 endif 
  if id == 'A02T' then 
  
 endif 
 if id == 'A01B' then
 if SR3(c,x,y) > 800 then 
 set sr = 800
 else
 set sr = SR3(c,x,y)
 endif
 set x = GetUnitX(c)+sr*Cos(a)
 set y = GetUnitY(c)+sr*Sin(a)
 call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx",GetUnitX(c),GetUnitY(c), GetUnitFacing(c), 1.5, 1.8, 0))
call PosUnit(c,x,y)
 call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx",GetUnitX(c),GetUnitY(c), GetUnitFacing(c), 1.5, 1.8, 0))
 endif
endfunction

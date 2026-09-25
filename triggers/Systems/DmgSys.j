globals 
boolean I02H_ReflectActive = false
boolean QuincyCrossDamageActive = false
boolean MurasameTrigger = false
boolean KurikaraTrigger = false
endglobals
function checkdmgsys takes nothing returns boolean
    return GetEventDamage() >= 1 and GetUnitAbilityLevel(GetTriggerUnit(), 'Avul') == 0
endfunction
function AttackCheck takes unit c, unit td, real dmg returns real
    local real x = GetUnitX(td)
    local real y = GetUnitY(td)
    local real a
    local integer i
    local integer k = 0
    local real dmg2
    local integer atk
    local integer sourceId = GetUnitTypeId(c)
    local integer sourceHid = GetHandleId(c)
    local integer sourceOwnerHid = GetHandleId(GetOwningPlayer(c))
      
   
    if sourceId == Erza_ID and IsUnitPaused(c) == false and LoadInteger(hs, sourceHid, KEY_ERZA_G2_ACTIVE) > 0 and LoadInteger(hs, sourceHid, KEY_ERZA_G2_TYPE) == 1 and SR2(c, td) <= Erza6E_RangePassiveWork and BlzGetUnitAbilityCooldownRemaining(c, Erza6E_ID) == 0 then
        call Erza6E_Start(c, td)
        call BlzStartUnitAbilityCooldown(c, Erza6E_ID, BlzGetUnitAbilityCooldown(c, Erza6E_ID, GetUnitAbilityLevel(c, Erza6E_ID) - 1))
    endif
    if dmg> 0 then 
    
    if MurasameTrigger == false and HasCachedItem(c, 'I03Y') > 0 then
    call Murasame_Start(c, td)
endif
    if GetUnitTypeId(c) == AinzW_Unit_ID then 
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
    endif
    if GetUnitTypeId(c) == Raiden_ID then 
    call RaidenAtk_Start(c,td)
    //call BJDebugMsg("S")
    endif
    if GetUnitAbilityLevel(c, TakeshiW2_Buff_ID) > 0 and SR2(c, td) < TakeshiW2_Range then
        call UnitRemoveAbility(c, TakeshiW2_Buff_ID)
        call TakeshiW2_Act(c, td)
    endif
    if GetUnitAbilityLevel(c, KiritoR_AS) > 0  then //and LoadInteger(hs, sourceOwnerHid, StringHash("r atk count")) < 13 then // Kirito R
        call KiritoR_Attack(c, td, dmg)
    endif
    if GetUnitAbilityLevel(c, TsunaW_Buff_ID) > 0 then
        call RootUnit(c, td, TsunaW_Root)
        set dmg2 = GetHeroAgi( c , true) * ( TsunaW_DamageAgiBase + ( TsunaW_DamageAgiStep * ( GetUnitAbilityLevel( c , TsunaW_ID) - 1 ) ) )
        set dmg2 = dmg2 + TsunaW_Damage2StaticBase + ( TsunaW_Damage2StaticStep * ( GetUnitAbilityLevel( c , TsunaW_ID) - 1 ) )
        call NextDmg(c, td, dmg2, 0, 0.05)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_file00003436.mdl", td, "chest"))
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_az_nevermoreice_x.mdl", td, "origin"))
    endif
    if sourceId == KenjakuQ2_Dummy_ID then
        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdx", x, y, GetRandomReal(0, 359), 1, 1.25, 1))
    endif
    if GetUnitAbilityLevel(c, MahoragaE2_Buff_ID) > 0 and sourceId == Mahoraga_ID then
        call MahoragaE2Act_Start(c, td)
    endif
    if GetUnitAbilityLevel(c, PatriotG_ID) > 0 and BlzGetUnitAbilityCooldownRemaining(c,PatriotG_ID)==0 then
        call PatriotPas(c,td)
    endif
    if sourceId == Takeshi_ID and LoadInteger(hs, sourceHid, KEY_MODE_G) == 1 then
        call ErzaPassive(c, td, 2)
    endif
    if sourceId == Barragan_ID and LoadInteger(hs, sourceOwnerHid, StringHash("morph e")) > 0 then 
     call BarraganPassiveBurn(c, td)
    if LoadInteger(hs, sourceHid, StringHash("barragan t")) > 0 then
        call BarraganPassiveBurn(c, td)
        call NextDmg(c,td,BarraganT_AtkDmg*GetHeroInt(c,true),0,0.1)
        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_Ldeff (262)", td, "chest"))
    endif
    endif
    if sourceId == Bambietta_ID and GetHeroLevel(c)>=BambiettaG_Lvl_CD and SR2(c,td)<175 and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0  then 
    call BambiettaG_Start(c)
    call BambiettaG2_Start(c,x,y)
    endif
    
    if sourceId == Erza_ID then
        if LoadInteger(hs, sourceHid, StringHash("type sword")) > 0 then
            set k = LoadInteger(hs, sourceHid, StringHash("type sword"))
            if k < 4 then
                call ErzaPassive(c, td, k)
            elseif k == 4 then
                if LoadInteger(hs, sourceHid, StringHash("atk count")) == 0 then
                    call ErzaPassive(c, td, 1)
                    call SaveInteger(hs, sourceHid, StringHash("atk count"), 1)
                else
                    call ErzaPassive(c, td, 2)
                    call SaveInteger(hs, sourceHid, StringHash("atk count"), 0)
                endif
            elseif k == 5 then
                if LoadInteger(hs, sourceHid, StringHash("atk count")) == 0 then
                    call ErzaPassive(c, td, 1)
                    call SaveInteger(hs, sourceHid, StringHash("atk count"), 1)
                else
                    call ErzaPassive(c, td, 3)
                    call SaveInteger(hs, sourceHid, StringHash("atk count"), 0)
                endif
            elseif k == 6 then
                if LoadInteger(hs, sourceHid, StringHash("atk count")) == 0 then
                    call ErzaPassive(c, td, 3)
                    call SaveInteger(hs, sourceHid, StringHash("atk count"), 1)
                else
                    call ErzaPassive(c, td, 2)
                    call SaveInteger(hs, sourceHid, StringHash("atk count"), 0)
                endif
            endif
        endif
        if LoadInteger(hs, sourceHid, StringHash("erza 4 tt")) == 1 and IsUnitPaused(c) == false then
            call NextDmg(c, td, Erza4TT_AdditionalAgiDmgPerAtk * GetHeroAgi(c, true), 0, 0.15)
            call DestroyEffect(EffectSpawn("war3mapImported\\Gear_nanaya2skill06dred.mdl", GetUnitX(td), GetUnitY(td), 1.45, 1, 1.1, 125))
            call DestroyEffect(EffectSpawn("war3mapImported\\Gear_OPm (434)4.mdl", GetUnitX(td), GetUnitY(td), 0, 2, 0.6, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\Gear_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), GAngle(c, td) * bj_RADTODEG, 1, 1.8, 0))
            call SetUnitX(c, x + 130 * Cos(GAngle(c, td)))
            call SetUnitY(c, y + 130 * Sin(GAngle(c, td)))
            call BlzSetUnitFacingEx(c, GAngle(c, td) * bj_RADTODEG)
            call IssueTargetOrder(c, "attack", td)
            call DestroyEffect(EffectSpawnColor("war3mapImported\\Gear_blackblink.mdx", GetUnitX(c), GetUnitY(c), GAngle(c, td) * bj_RADTODEG, 2.5, 1.35, 0, 0, 0, 0, 255))
        endif
    endif
    if sourceId == Alucard_ID and LoadInteger(hs, sourceOwnerHid, StringHash("morph r")) == 0 then
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_qqqqq.mdl", GetUnitX(td), GetUnitY(td), 0, 1, 1, 100))
    endif
    if LoadInteger(hs, sourceHid, StringHash("raiden t")) > 0 then
        set a = GetRandomReal(0, 359)
        call EUTU2(EffectSpawn("war3mapimported\\wos_ld2209 (199).mdl", x, y, a, 0.85, 2.5, 90), 0.36, 90, td)
        call EUTU2(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_DaJi_1_3Purple.mdl", x, y, a, 1.25, 2.15, 135), 0.36, 135, td)
        set i = GetRandomInt(1, 3)
        call SetMpCurrent(c, RaidenT_AddManaPerHit / 100 * GetUnitState(c, UNIT_STATE_MAX_MANA))
        call StopSound(gg_snd_Hero_Raiden_T_Atk1, false, false)
        call StopSound(gg_snd_Hero_Raiden_T_Atk2, false, false)
        call StopSound(gg_snd_Hero_Raiden_T_Atk3, false, false)
        if i == 1 then
            call StartSound(gg_snd_Hero_Raiden_T_Atk1)
        elseif i == 2 then
            call StartSound(gg_snd_Hero_Raiden_T_Atk2)
        elseif i == 3 then
            call StartSound(gg_snd_Hero_Raiden_T_Atk3)
        endif
    endif
  
    if sourceId == AlterSaber_ID then
        set a = GAngle(c, td)
        if LoadInteger(hs, sourceHid, StringHash("mode r")) > 0 then
            set dmg = dmg + GetUnitState(c, UNIT_STATE_MANA) * (AlterSaberF_DamageFromCurrentManaMorph / 100)
        else
            set dmg = dmg + GetUnitState(c, UNIT_STATE_MANA) * (AlterSaberF_DamageFromCurrentManaBase / 100)
        endif
        if GetHeroLevel(c) >= 35 and BlzGetUnitAbilityCooldownRemaining(c, AlterSaberQ_ID) > 0 then
            call BlzStartUnitAbilityCooldown(c, AlterSaberQ_ID, BlzGetUnitAbilityCooldownRemaining(c, AlterSaberQ_ID) - 1)
        endif
        call EUTU2_3(EffectSpawn("war3mapImported\\wos_Satsu-WWSFX-1.mdx", x, y, a * bj_RADTODEG, 1.25, 2., 75), 0.76, 75, td)
    endif
    endif
     
    call AlterSaberW_PasTrigger(c, td)
    return dmg
endfunction
function I02HReflect takes unit source, unit target, real dmg, integer typedmg returns nothing
if I02H_ReflectActive or source == null or target == null or source == target or dmg <= 1.0 or GetWidgetLife(source) <= 0.405 then
return
endif
set I02H_ReflectActive = true
if IntegerCd(target,"I02H reflect sfx",0.15) then
call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_Opdef (571)2.mdx",source,"chest"))
endif
if typedmg == 1 then
call dmgmag(target,source,dmg*(YataMirror_ReversedDmg/100))
else
call dmgphys(target,source,dmg*(YataMirror_ReversedDmg/100))
endif
set I02H_ReflectActive = false
endfunction
function Trig_DmgSys_Actions takes nothing returns nothing
    local unit c = GetEventDamageSource()
    local unit td = GetTriggerUnit()
    local player sourceOwner = GetOwningPlayer(c)
    local player targetOwner = GetOwningPlayer(td)
    local integer sourceId = GetUnitTypeId(c)
    local integer targetId = GetUnitTypeId(td)
    local integer sourceHid = GetHandleId(c)
    local integer targetHid = GetHandleId(td)
    local integer sourceOwnerHid = GetHandleId(sourceOwner)
    local integer targetOwnerHid = GetHandleId(targetOwner)
    local integer id = GetPlayerId(sourceOwner)
    local integer id2 = GetPlayerId(targetOwner)
    local real dmg = GetEventDamage()
    local real dmg_base = dmg
    local real hpblock1
    local real shieldInput = 0.0
    local real random1
    local real random2
    local integer rr1
    local real block = dmg
    local integer k = 0
    local real x1
    local real y1
    
    local real rand1 = 0
    local real targetX = GetUnitX(td)
    local real targetY = GetUnitY(td)
    local string s = ""
    local string s2 = ""
    // Сила исходного удара нужна для порога Last Sin. Само пробивание
    // вызывается отдельно на каждом полном щите.
    local real penetrationTrigger = dmg
    local real ang = 0
    local integer typedmg = 0 // 0 - atk, 1 - mag dmg, 2 - phys dmg
    local boolean isEnemy = not IsUnitAlly(c, targetOwner)
    local boolean sourceIsHero = IsUnitType(c, UNIT_TYPE_HERO)
    local boolean targetIsHero = IsUnitType(td, UNIT_TYPE_HERO)
    local boolean targetIsIllusion = IsUnitIllusion(td)
    local boolean shieldPen = HasShieldPen(c, td)
    if BlzGetEventAttackType() == ATTACK_TYPE_MAGIC then
        set typedmg = 1
    elseif BlzGetEventAttackType() == ATTACK_TYPE_NORMAL and BlzGetEventDamageType() == DAMAGE_TYPE_FIRE then
        set typedmg = 2
    elseif BlzGetEventAttackType() == ATTACK_TYPE_HERO or BlzGetEventAttackType() == ATTACK_TYPE_MELEE then
        set typedmg = 0
    endif
        
    if BlzGetEventIsAttack() or typedmg == 0 then // for attacks only
    if HasCachedItem(c,'I03X') > 0 and BlzGetUnitAbilityCooldownRemaining(c, 'A0HT') == 0 and GetUnitAbilityLevel(c, 'A0HT') > 0 then
    call NextDmg(c,td,GetAttack(c),2,0.5)
    call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_daoguang_blue_hitsword.mdx",td,"origin"))
    call BlzStartUnitAbilityCooldown(c,'A0HT',1)
    endif
    if BlzGetEventIsAttack() and sourceId == Starrk_ID and LoadInteger(hs, sourceOwnerHid, StringHash("morph e")) == 1 then
        call StarrkE_Attack_Start(c, GetUnitX(td), GetUnitY(td))
        set dmg = 0
        else        
        set dmg = AttackCheck(c, td, dmg)
    endif
    endif
    if isEnemy and sourceIsHero and LoadInteger(hs, targetHid, StringHash("naofumi shield")) == 0 then
        if typedmg == 0 or typedmg == 2 then
            if HasCachedItem(c, 'I01M') > 0 then
                call DecreaseArmorUnit(c, td, 2)
            endif
        endif
        if typedmg == 0 or typedmg == 1 then
           
            if HasCachedItem(c, 'I01L') > 0 then
                call CurseUnit2(c, td, 1)
            endif
        endif
    endif
    
    
    // Предварительный урон со всеми усилениями атакующего, но ещё без резистов цели.
    // DamageCheck в текущей реализации не изменяет состояние.
    set penetrationTrigger = DamageCheck(c, td, dmg, typedmg)
    if sourceId == Alucard_ID and LoadInteger(hs, targetHid, StringHash("Alucard pas")) == 1 then
        set penetrationTrigger = penetrationTrigger * 1.07
    endif
  //  if LoadInteger(hs, targetHid, StringHash("brandish e")) > 0 and not shieldPen then
   //     set dmg = dmg - (dmg * (BrandishE_DamageDecrease / 100))
   // endif
    if LoadInteger(hs, sourceHid, StringHash("raiden w")) > 0 then
        if IntegerCd(td, "raiden w atk cd", RaidenW_AtkCd) then
            call RaidenW_Strike_Start(c, td, typedmg)
        endif
    endif
    if typedmg == 0 or typedmg == 2 then
if targetId == Erza_ID and IsUnitPaused(td) == false and LoadInteger(hs,targetHid,KEY_ERZA_G2_ACTIVE) > 0 and LoadInteger(hs,targetHid,KEY_ERZA_G2_TYPE) == 2 and SR2(c,td) <= Erza7E_RangePassiveWork and BlzGetUnitAbilityCooldownRemaining(td,Erza7E_ID) == 0 then
call Erza7E_Start(td,c)
set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_NON_MAGIC)
call BlzStartUnitAbilityCooldown(td,Erza7E_ID,BlzGetUnitAbilityCooldown(td,Erza7E_ID,GetUnitAbilityLevel(td,Erza7E_ID)-1))
endif
endif
   
    if GetUnitAbilityLevel(td,AinzF_Buff0_ID)>0 and dmg >150  then //LoadInteger(hs, sourceHid, StringHash("brandish g ally")) > 0 then
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        call UnitRemoveAbility(td,AinzF_Buff0_ID)
        set ang = GetUnitFacing(td)*bj_DEGTORAD
        set x1 = GetUnitX(td)-150*Cos(ang)
        set y1 = GetUnitY(td)-150*Sin(ang)
        call BlinkEff(td)
        call PosUnit(td,x1,y1)
        call BlinkEff(td)
        call MakeSound("war3mapimported\\Hero_Ainz_F01")
        call MakeSound("war3mapimported\\Hero_Ainz_F02")
    endif
     if LoadInteger(hs, targetHid, KEY_INVUL) == 1 then
    set dmg = ApplyFullDamageShield(c, td, dmg, 0.1, typedmg, DAMAGE_SHIELD_TYPE_ALL)
endif

if LoadInteger(hs, targetHid, KEY_SHIELD) == 1 then
    set dmg = ApplyFullDamageShield(c, td, dmg, 0.1, typedmg, DAMAGE_SHIELD_TYPE_ALL)
endif

    if isEnemy and GetUnitAbilityLevel(td, AlterSaberEBuff_ID) > 0 and not shieldPen then
        call UnitRemoveAbility(td, AlterSaberEBuff_ID)
        call AlterSaberE_Act_Start(td, c)
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif
    if isEnemy and c != td and GetUnitAbilityLevel(td, KyorakuR_BuffId) > 0 and dmg >= 150 then
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        call UnitRemoveAbility(td, KyorakuR_BuffId)
        call KyorakuRAct_Start(td, c)
    endif
    if targetId == Gojo_ID and LoadInteger(hs, targetHid, StringHash("gojo e")) == 1 and not shieldPen then
        if GetUnitAbilityLevel(td, GojoE_ID) > 3 then
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        else
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_NON_MAGIC)
        endif
        if GetUnitAbilityLevel(td, GojoE_ID) == 1 and typedmg != 1 then
            call MUE(td, 195, 0.15, GAngle(td, c) + GetRandomReal( -30, 30) * bj_DEGTORAD)
        elseif GetUnitAbilityLevel(td, GojoE_ID) >= 2 then
            if SR2(td, c) < 350 then
                call MUE(c, 155, 0.15, GAngle(td, c) + GetRandomReal( -30, 30) * bj_DEGTORAD)
            endif
        endif
    endif
    if isEnemy and GetUnitAbilityLevel(td, TakeshiQ3_Buff_ID) > 0 and targetId == Takeshi_ID and SR2(td, c) < TakeshiQ3_Range and dmg > 249 then
        call UnitRemoveAbility(td, TakeshiQ3_Buff_ID)
        call TakeshiQ3_Act(td, c)
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif
    if dmg > 0 and GetUnitAbilityLevel(td, TakeshiW2_Buff_ID) > 0 and targetId == Takeshi_ID and typedmg == 0 and SR2(td, c) < TakeshiW2_Range then
        call UnitRemoveAbility(td, TakeshiW2_Buff_ID)
        call TakeshiW2_Act(td, c)
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ATTACK)
    endif
    if targetId == Takeshi_ID and dmg > 0 then
        if LoadInteger(hs, targetOwnerHid, StringHash("yamamoto fr")) == 1 then
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
            call DecorRemove(td, targetX, targetY, 500, 20)
            call SetUnitAnimationByIndex( td , 8)
            call SetUnitTimeScale(td, 3)
            if IntegerCd(td, "r sound", 0.3) then
                call MakeSound("war3mapimported\\Hero_Takeshi_FR4")
                if SR2(c, td) <= 300 then
                    call MUE(c, 330, 0.2, GAngle(td, c))
                endif
            endif
        else
            if GetUnitAbilityLevel(c, TakeshiE2_Buff_ID) > 0 and targetId == Takeshi_ID then
                call TakeshiE2_Act(td, c)
                set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
            endif
        endif
    endif
    
   
    if LoadInteger(hs, GetHandleId(td), StringHash("patriot ee")) == 1 then 
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif
    if GetUnitCurrentOrder(td) == OrderId("autoharvestlumber") and LoadInteger(hs, targetHid, StringHash("e armor active")) == 1 and not shieldPen and LoadReal(hs, targetHid, StringHash("dmg b e")) > 0 then
        set block = LoadReal(hs, targetHid, StringHash("dmg b e"))
        set hpblock1 = block * 2
        if dmg > block then
            set shieldInput = dmg
            set dmg = dmg - hpblock1
            call SetMpCurrent(td, -block)
            call IssueImmediateOrder(td, "stop")
            set block = 0
            if dmg <= 0.0 then
                set dmg = ApplyFullDamageShield(c, td, shieldInput, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
            endif
        else
            set hpblock1 = dmg / 2
            call SetMpCurrent(td, -(hpblock1))
            set block = block - (hpblock1)
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        endif
        call SaveReal(hs, targetHid, StringHash("dmg b e"), block)
    endif
    if GetUnitAbilityLevel(td, Erza3E_DamageImmune_ID) > 0 and not shieldPen then
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif
        if not QuincyCrossDamageActive and dmg > 1 and isEnemy and dmg < QuincyCross_MaxDmg and HasCachedItem(c, QuincyCross_Item_ID) > 0 then
       set dmg = dmg + QuincyCross_DamageBase
       // call QuincyCross_Start(c, td)
    endif
    if targetId == Mahoraga_ID and GetUnitAbilityLevel(td, MahoragaT_ID) > 0 then
        call MahoragaT_Start(td, c, dmg)
    endif    
    set dmg = DamageCheck(c, td, dmg, typedmg)    
    if sourceId == Alucard_ID and LoadInteger(hs, targetHid , StringHash("Alucard pas")) == 1 then
        set dmg = dmg * 1.07
    endif
    if dmg > 1 and GetUnitAbilityLevel(td, 'B01E') > 0 and sourceId == Alucard_ID then
        call SetHpCurrent2(c, c, dmg * (AlucardT_Heal / 100))
    endif
    if dmg > 1 and GetUnitAbilityLevel(td, 'B01F') > 0 and sourceId == Alucard_ID then
        call SetHpCurrent2(c, c, dmg * (AlucardT2_Heal / 100))
    endif
    // Обычные резисты применяются к части урона, прошедшей ранние щиты.
    // Полные щиты внутри DamageBlock вызывают LustSin непосредственно.
    set DamageShieldPierceTriggerDamage = penetrationTrigger
    set dmg = DamageBlock(c, td, dmg, typedmg, false)
    set DamageShieldPierceTriggerDamage = 0.0
    if GetUnitAbilityLevel(td,AinzW_Buff_ID)>0 then 
    set shieldInput = dmg
    set dmg = dmg - 500
    call UnitRemoveAbility(td,AinzW_Buff_ID)
    call AinzW2Alternative_Start(td,c)
    if dmg <= 0.0 and shieldInput > 0.0 then 
    set dmg = ApplyFullDamageShield(c, td, shieldInput, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif
    endif
      if dmg>= 1000 and HasCachedItem(c,'I040') > 0 and BlzGetUnitAbilityCooldownRemaining(c, 'A0HV') == 0 and GetUnitAbilityLevel(c, 'A0HV') > 0 then
    call BlzStartUnitAbilityCooldown(c, 'A0HV', 3 )
    call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_blink_red.mdx",c,"chest"))
    call SetHpCurrent2(c,c,dmg*0.33)
    endif
    if dmg>= DemonDwellerSword_MinDmg  and HasCachedItem(c,DemonDwellerSword_ID ) > 0 and BlzGetUnitAbilityCooldownRemaining(c, DemonDwellerSword_Abi_CD_ID) == 0 and GetUnitAbilityLevel(c, DemonDwellerSword_Abi_CD_ID) > 0 then
    if typedmg == 1 then 
    call BuffUnit01(c,c,DemonDwellerSword_Abi_ID ,"innerfire",2)
    else
    call BuffUnit01(c,c,DemonDwellerSword_Abi_ID ,"innerfire",1)
    endif
    call BlzStartUnitAbilityCooldown(c, DemonDwellerSword_Abi_CD_ID, DemonDwellerSword_CD  )
    endif
    if dmg> 1 and HasCachedItem(td,SusanooShield_Item_ID) > 0 and BlzGetUnitAbilityCooldownRemaining(td, 'A0F7') == 0 and GetUnitAbilityLevel(td, 'A0F7') > 0 then
    set k = GetItemCharges(UnitItemInSlot(td, IsItemInInventory3(td, SusanooShield_Item_ID)))
     if k < SusanooShield_TresholdDamage then 
     set k = k + R2I(dmg)
    call SetItemCharges(UnitItemInSlot(td, IsItemInInventory3(td, SusanooShield_Item_ID)), k)
    endif
    
  
    
    if k>SusanooShield_TresholdDamage then 
    set k = SusanooShield_TresholdDamage
    call SetItemCharges(UnitItemInSlot(td, IsItemInInventory3(td, SusanooShield_Item_ID)), SusanooShield_TresholdDamage)
    endif
    if k>= SusanooShield_TresholdDamage and GetUnitState(td,UNIT_STATE_MANA)>= SusanooShield_Manacost then 
    call BlzStartUnitAbilityCooldown(td, 'A0F7', SusanooShield_CD )
    call SetItemCharges(UnitItemInSlot(td, IsItemInInventory3(td, SusanooShield_Item_ID)), 0)
    call BuffUnit01(td,td,'A0F6',"innerfire",1)
    call SetUnitState(td,UNIT_STATE_MANA,GetUnitState(td,UNIT_STATE_MANA)-SusanooShield_Manacost)
    endif
    endif
    if targetId == Tsuna_ID and dmg > 1 then
        set x1 = LoadReal(hs, targetHid, StringHash("instinct")) * 100
        set y1 = GetRandomReal(0, 100)
        if LoadInteger(hs, targetOwnerHid, KEY_ZERO_KAI) == 0 then
            if LoadInteger(hs, targetHid, StringHash("mode def")) == 1 then
                set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
            elseif BlzGetUnitAbilityCooldownRemaining(td, FakeAbi_ID) == 0 and y1 <= x1 and SR2(c, td) <= TsunaF_Aoe then
                set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
                call TsunaDodge(td, c)
            endif
        endif
    endif
    if targetId == Alucard_ID and BlzGetUnitAbilityCooldownRemaining(td, FakeAbi_ID) == 0 and GetHeroLevel(td) >= 12 and LoadInteger(hs, targetHid , StringHash("Alucard pas vision")) == 0 then
        call SaveInteger(hs, targetHid , StringHash("Alucard pas vision"), 1)
        call AlucardF_Start(td, c)
    endif
    if GetUnitAbilityLevel(c, AlucardW_Buff_ID) > 0 and not shieldPen then // alucard w
        set dmg = dmg * 0.75
    endif
    if GetUnitAbilityLevel(c, AlucardT_Buff_ID) > 0 and targetId == Alucard_ID and not shieldPen then // alucard t
        set dmg = dmg * (1 - 0.75)
    endif
    if GetUnitAbilityLevel(c, AlucardT2_Buff_ID) > 0 and targetId == Alucard_ID and not shieldPen then // alucard t
        set dmg = dmg * (1 - 0.3)
    endif
    if targetId == Takeshi_ID and LoadInteger(hs, targetHid, StringHash("def t")) == 1 then
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif
    if targetId == Rimuru_ID and dmg > 0 then
        if LoadInteger(hs, targetHid, StringHash("rimuru f")) == 1 then
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        elseif dmg >= RimuruQ2_MinDamage and (GetUnitAbilityLevel(td, RimuruQ2_Buff_ID) > 0 or GetUnitAbilityLevel(td, RimuruF3_Buff_ID) > 0 ) then
            call Rimuru2Q_Dodge(td, c, dmg)
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        else
            if dmg >= RimuruG_MinDmg then
                call RimuruG_Start(td, dmg)
            endif
        endif
    endif
    if BankaiActive and c != td and dmg > 5 and GetUnitAbilityLevel(td, KyorakuT_BankaiBuff) > 0 and GetUnitAbilityLevel(c, KyorakuT_BankaiBuff) > 0 and LoadInteger(hs, sourceHid, StringHash("naofumi shield")) == 0 and LoadInteger(hs, targetHid, StringHash("naofumi shield")) == 0 then
        if sourceIsHero == false then
            call SaveInteger(hs, GetHandleId(Hero[id]), StringHash("bankai 1-st activated"), 1)
        else
            call SaveInteger(hs, sourceHid, StringHash("bankai 1-st activated"), 1)
        endif
        set rand1 = KyorakuT_Dan1_Reverse * dmg
        if rand1 >= GetUnitState(c, UNIT_STATE_LIFE) then
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * (KyorakuT_Dan1_MinHp / 100))
        else
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) - rand1)
        endif
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_YC_Shockwave_b_red.mdl", c, "chest"))
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_mh_tx-ba-symh-hit11Red.mdl", c, "origin"))
        if dmg >= GetUnitState(td, UNIT_STATE_LIFE) then
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
            call SetUnitState(td, UNIT_STATE_LIFE, GetUnitState(td, UNIT_STATE_MAX_LIFE) * (KyorakuT_Dan1_MinHp / 100))
        endif
    endif
    if IsUnitIllusion(c) == false and GetUnitAbilityLevel(td,DeathNote_Buff_ID)==0 and dmg>=DeathNote_MinDmg and typedmg == 1 and isEnemy and HasCachedItem(c, DeathNote_ID ) > 0  and BlzGetUnitAbilityCooldownRemaining(c, DeathNote_CD_ID ) == 0 and GetUnitAbilityLevel(c, DeathNote_CD_ID ) > 0 then
        call BlzStartUnitAbilityCooldown(c, DeathNote_CD_ID , DeathNote_CD  )
        call DeathNote_Start(c,td,dmg)
    endif
    if ItemProcDamageDepth == 0 then


    if dmg > 1 and GetUnitAbilityLevel(td, 'B008') > 0 and isEnemy and HasCachedItem(c, 'I02S') > 0 then
        call Tachikaze_Start(c, td)
    endif

    if typedmg == 1 then
        if KurikaraTrigger == false and isEnemy and HasCachedItem(c, 'I00W') > 0 and dmg >= Kurikara_MinDmg then
            call KurikaraFlame(c, td)
        endif
    endif
endif
    
    if typedmg == 1 then
        
    else
        if isEnemy and dmg >= Earth_Power_MinDmg and HasCachedItem(c, 'I019') > 0 and IntegerCd(td, "dmg stop punch", Earth_Power_CD) then //and GetUnitAbilityLevel(td, 'B00F') == 0 then
            call EarthPower(c, td)
        endif
    endif
    if dmg > 0.0 and NatsuPicked and targetIsHero and not targetIsIllusion and targetId != Natsu_ID then
    if GetUnitState(td, UNIT_STATE_LIFE) <= GetUnitState(td, UNIT_STATE_MAX_LIFE) * (NatsuF_AllyDamageLow / 100.0) or dmg >= GetUnitState(td, UNIT_STATE_MAX_LIFE) * (NatsuF_AllyDamageHigh / 100.0) then
        call NatsuF_Start(td)
    endif
endif

if LaxusPicked and targetIsHero and not targetIsIllusion and targetId != Laxus_ID and dmg >= LaxusF_DmgPorog then
    call LaxusFCheck_Start(td)
endif
    
    if dmg > 1 and isEnemy and HasCachedItem(td, 'I045') > 0 then //and GetUnitAbilityLevel(td, 'B00F') == 0 then
        call SetHpCurrent2(td, td,AvalonEvolved_HpRestore)
        elseif dmg > 1 and isEnemy and HasCachedItem(td, 'I02K') > 0 then //and GetUnitAbilityLevel(td, 'B00F') == 0 then
        call SetHpCurrent2(td, td,Avalon_HpRestore)
    
    endif
    
    if isEnemy and dmg >= GutsArmor_DmgTreshold  and BlzGetUnitAbilityCooldownRemaining(td, 'A0F4') == 0 and GetUnitAbilityLevel(td, 'A0F4') > 0 then
        call BlzStartUnitAbilityCooldown(td, 'A0F4', GutsArmor_CD )
       call BuffUnit01(td,td,'A0F3',"innerfire",1)
    endif
    if isEnemy and dmg>1 and GetUnitAbilityLevel(c, GutsArmor_Buff_ID) > 0 then
        call UnitRemoveAbility(c,GutsArmor_Buff_ID)
        call NextDmg(c, td, GutsArmor_DamageBase  * GetHeroStr(c, true), 0, 0.05)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", td, "chest"))
    endif
    if dmg > 1 and GetUnitAbilityLevel(td, 'B018') > 0 and targetIsHero and not targetIsIllusion then
        call HarribelG2_Start(td, dmg)
    endif
    if GetUnitAbilityLevel(td, InoriE_Aura_ID) > 0 and targetIsHero and not targetIsIllusion and LoadInteger(hs, targetHid, StringHash("mode t")) == 0 then
        if dmg > InoriE_DmgCap then
            call InoriEPas_Start(td)
        endif
    endif
    if dmg > InoriE_DmgCap and targetIsHero  and not targetIsIllusion  and GetUnitAbilityLevel(td, InoriE_Aura_ID) > 0  and LoadInteger(hs, targetHid, StringHash("mode t")) == 0 then
    call InoriEPas_Start(td)
endif
    if dmg > 1 and GetUnitAbilityLevel(td,'A0F9')>0  then
    call BlzStartUnitAbilityCooldown(td,'A0F9',ElixirOfLife_CD)
    endif
    if dmg> 1 and HasCachedItem(td,'I02R') > 0 and BlzGetUnitAbilityCooldownRemaining(td, 'A0FB') == 0 and GetUnitAbilityLevel(td, 'A0FB') > 0 then
    call BlzStartUnitAbilityCooldown(td, 'A0FB', 15 )
    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_Eff (134).mdl",td,"origin"))
    set dmg = dmg - 200
    endif
    if typedmg != 1 and isEnemy and GetUnitAbilityLevel(c, 'A0FA') > 0  and SR2(c,td) <= ShikiKnife_RangeCheck  and BlzGetUnitAbilityCooldownRemaining(c, 'A0FA') == 0  then
        call BlzStartUnitAbilityCooldown(c, 'A0FA', ShikiKnife_CD )
        call NextDmg(c, td, ShikiKnife_DmgBase +(ShikiKnife_DmgAgi  * GetHeroAgi(c, true)), 1, 0.05)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_corpse explosion.mdl", td, "origin"))
    endif
    if  typedmg != 1 and isEnemy and GetUnitAbilityLevel(c, 'A0HY') > 0  and SR2(c,td) <= ShikiKnifeEvolved_RangeCheck  and BlzGetUnitAbilityCooldownRemaining(c, 'A0HY') == 0  then
        call BlzStartUnitAbilityCooldown(c, 'A0HY', ShikiKnifeEvolved_CD )
        call NextDmg(c, td, ShikiKnifeEvolved_DmgBase +(ShikiKnifeEvolved_DmgAgi  * GetHeroAgi(c, true)), 1, 0.05)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_corpse explosion.mdl", td, "origin"))
    endif
    if isEnemy and dmg >= RyijinJakka_MinDmg and BlzGetUnitAbilityCooldownRemaining(c, 'A080') == 0 and GetUnitAbilityLevel(c, 'A080') > 0 then
        call BlzStartUnitAbilityCooldown(c, 'A080', RyijinJakka_CD)
        call NextDmg(c, td, RyijinJakka_DamageBase * GetMainStatValue(c, true), 0, 0.05)
        call ErzaPassive(c, td, 1)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_fire explosion.mdl", td, "chest"))
    endif
    if isEnemy and dmg >= 1 and BlzGetUnitAbilityCooldownRemaining(c, 'A0FD') == 0 and GetUnitAbilityLevel(c, 'A0FD') > 0 then
        call BlzStartUnitAbilityCooldown(c, 'A0FD', 10)
        call ErzaPassive(c, td, 3)
    endif
    if isEnemy and dmg >= 1 and BlzGetUnitAbilityCooldownRemaining(c, 'A0G1') == 0 and GetUnitAbilityLevel(c, 'A0G1') > 0 then
        call BlzStartUnitAbilityCooldown(c, 'A0G1', 10)
        call ErzaPassive(c, td, 2)
    endif
    if isEnemy and dmg >= 1 and BlzGetUnitAbilityCooldownRemaining(c, 'A0G0') == 0 and GetUnitAbilityLevel(c, 'A0G0') > 0 then
        call BlzStartUnitAbilityCooldown(c, 'A0G0', 10)
        call ErzaPassive(c, td, 1)
    endif
    if isEnemy and dmg >= Nejibana_MinDmg and BlzGetUnitAbilityCooldownRemaining(c, 'A09P') == 0 and GetUnitAbilityLevel(c, 'A09P') > 0 then
        call BlzStartUnitAbilityCooldown(c, 'A09P', Nejibana_CD)
        call ErzaPassive(c, td, 2)
        call NextDmg(c, td, Nejibana_DamageBase * GetMainStatValue(c, true), 0, 0.05)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_waterexplosion.mdl", td, "chest"))
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_yc_shockwave_b.mdl", td, "chest"))
    endif
    if isEnemy and dmg >= Gonryomaru_MinDmg and BlzGetUnitAbilityCooldownRemaining(c, 'A081') == 0 and GetUnitAbilityLevel(c, 'A081') > 0 then
        call BlzStartUnitAbilityCooldown(c, 'A081', Gonryomaru_CD)
        call NextDmg(c, td, Gonryomaru_DamageBase * GetMainStatValue(c, true), 0, 0.05)
        call ErzaPassive(c, td, 3)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_SasukeYh-41.mdl", td, "chest"))
    endif
    if targetId == Tsuna_ID and dmg > 1 then
        if LoadInteger(hs, targetOwnerHid, KEY_ZERO_KAI) == 1 and not shieldPen then
            set rand1 = LoadReal(hs, targetHid, StringHash("zero kai dmg"))
            call SaveReal(hs, targetHid, StringHash("zero kai dmg"), rand1 + dmg)
            set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        endif
    endif
    if sourceId == Frieren_ID and IsUnitIllusion(c) then 
    set dmg = dmg * (FrierenR_CloneDamageMultiplier1/100)
    set penetrationTrigger = penetrationTrigger * (FrierenR_CloneDamageMultiplier1/100)
    endif
    if sourceId == FrierenTR_unitid  then 
    set dmg = dmg * (FrierenR_CloneDamageMultiplier2/100)
    set penetrationTrigger = penetrationTrigger * (FrierenR_CloneDamageMultiplier2/100)
    endif
    if dmg > 1 and GetUnitAbilityLevel(td,FrierenG_BuffID1)>0 then 
    set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    call UnitRemoveAbility(td,FrierenG_BuffID1)
    endif
    if dmg > 1 and (GetUnitAbilityLevel(td,FrierenG_BuffID2)>0 or GetUnitAbilityLevel(td,FrierenG_BuffID3)>0) then
        set dmg = ApplyFullDamageShield(c, td, dmg, penetrationTrigger, typedmg, DAMAGE_SHIELD_TYPE_ALL)
    endif
   if dmg>1 and  GetUnitAbilityLevel(td,FrierenTF_BuffID)>0 and (sourceId == Frieren_ID or sourceId == FrierenTR_unitid ) then
   set hpblock1 = LoadReal(hs,GetHandleId(td),StringHash("frieren f dmg"))+ dmg*(FrierenTF_RememberDamage/100)
   
   call SaveReal(hs,GetHandleId(td),StringHash("frieren f dmg"),hpblock1)
   endif
    if dmg != dmg_base then
        call BlzSetEventDamage(dmg)
    endif
    if (targetId == Milim_ID or targetId == Milim2_ID) and targetIsHero and not targetIsIllusion and dmg > 0 then
        call MilimGAddDmg(td, dmg)
    endif
    if not I02H_ReflectActive and dmg > 1.0 and c != null and c != td and HasCachedItem(td,'I02H') > 0 and SR2(c,td) < YataMirror_Range then
call I02HReflect(c,td,dmg,typedmg)
endif
    if dmg > 0 then
        if typedmg == 0 or typedmg == 2 then
            set s2 = "|cffff0000"
            if targetIsIllusion==false and targetIsHero then
                set PlayerDamagePhys[id] = PlayerDamagePhys[id] + R2I(dmg)
                set PlayerDamageTakenPhys[id2] = PlayerDamageTakenPhys[id2] + R2I(dmg)
                set PlayerDamagePhysAll[id] = PlayerDamagePhysAll[id] + R2I(dmg)
                set PlayerDamageTakenPhysAll[id2] = PlayerDamageTakenPhysAll[id2] + R2I(dmg)
                if sourceId == Erza_ID then
                    set rr1 = LoadInteger(hs, sourceHid, StringHash("Erza G2 phys")) + R2I(dmg)
                    call SaveInteger(hs, sourceHid, StringHash("Erza G2 phys"), rr1)
                endif
            endif
        endif
        if typedmg == 1 then
            set s2 = "|c002F63FF"
            if  targetIsIllusion== false and targetIsHero then
                set PlayerDamageMag[id] = PlayerDamageMag[id] + R2I(dmg)
                set PlayerDamageTakenMag[id2] = PlayerDamageTakenMag[id2] + R2I(dmg)
                set PlayerDamageMagAll[id] = PlayerDamageMagAll[id] + R2I(dmg)
                set PlayerDamageTakenMagAll[id2] = PlayerDamageTakenMagAll[id2] + R2I(dmg)
                if sourceId == Erza_ID then
                    set rr1 = LoadInteger(hs, sourceHid, StringHash("Erza G2 mag")) + R2I(dmg)
                    call SaveInteger(hs, sourceHid, StringHash("Erza G2 mag"), rr1)
                endif
            endif
        endif
    endif
    if ShowDmgTestText and dmg > 0 then
        set s = I2S(R2I(dmg))
        set random1 = 185
        set random2 = GetRandomReal(0, 359) * bj_DEGTORAD
        set bj_lastCreatedTextTag = CreateTextTag()
        call SetTextTagLifespan(bj_lastCreatedTextTag, 0.9) // С‡РµСЂРµР· 0.5 СЃРµРє СѓРґР°Р»РёС‚СЃСЏ
        call SetTextTagFadepoint(bj_lastCreatedTextTag, 0.45) // РєРѕРіРґР° РЅР°С‡РЅРµС‚ РїР»Р°РІРЅРѕ РёСЃС‡РµР·Р°С‚СЊ
        set ang = GAngle(c, td)
        if typedmg == 0 or typedmg == 2 then
            set x1 = 0.01725
            call SetTextTagPos(bj_lastCreatedTextTag, targetX + random1 * Cos(ang + 45 * bj_DEGTORAD), targetY + random1 * Sin(ang + 45 * bj_DEGTORAD), 160) // РїРѕР·РёС†РёСЏ (РЅР°РїСЂРёРјРµСЂ РЅР° СЋРЅРёС‚Рµ)
        else
            set x1 = 0.01825
            call SetTextTagPos(bj_lastCreatedTextTag, targetX + random1 * Cos(ang + 315 * bj_DEGTORAD), targetY - random1 * Sin(ang + 315 * bj_DEGTORAD), 160) // РїРѕР·РёС†РёСЏ (РЅР°РїСЂРёРјРµСЂ РЅР° СЋРЅРёС‚Рµ)
        endif
        call SetTextTagText(bj_lastCreatedTextTag, s2 + s, 0.01725) // СЃР°Рј С‚РµРєСЃС‚ Рё СЂР°Р·РјРµСЂ
        call SetTextTagPermanent(bj_lastCreatedTextTag, false) // РґРµР»Р°РµРј РЅРµРїРѕСЃС‚РѕСЏРЅРЅС‹Рј
        call SetTextTagVelocity(bj_lastCreatedTextTag, 0, 0.1)
        call SetTextTagVisibility(bj_lastCreatedTextTag, false)
        set k = 0
        loop
            exitwhen k > 10
            if IsUnitVisible(td, Player(k)) then
                if GetLocalPlayer() == Player(k) then
                    call SetTextTagVisibility(bj_lastCreatedTextTag, true)
                endif
            endif
            set k = k + 1
        endloop
    endif
    set c = null
    set td = null
    set sourceOwner = null
    set targetOwner = null
    set s = null
    set s2 = null
endfunction


//===========================================================================
function InitTrig_DmgSys takes nothing returns nothing
    set gg_trg_DmgSys = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DmgSys, EVENT_PLAYER_UNIT_DAMAGING )
    call TriggerAddCondition(gg_trg_DmgSys, Condition(function checkdmgsys))
    call TriggerAddAction( gg_trg_DmgSys, function Trig_DmgSys_Actions )
endfunction


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com


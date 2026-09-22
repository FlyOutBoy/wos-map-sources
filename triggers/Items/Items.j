library ItemsSpells uses GearSystems
    globals
//----------------------Chogurt----------------------------------------------
        integer Chogurt_ID = 'A06R'
        real Chogurt_MpRestore = 3 //how much % of max mana restored every second
        real Chogurt_Duration = 5 //how long area live
        real Chogurt_Aoe = 705 // how fast barrel will land after cast
        real Chogurt_MpRestoreStatic = 20
        real Chogurt_DmgReduct = 7.5
        real ChogurtEvolved_DmgReduct = 12.5
//----------------------ItachiSet----------------------------------------------
        integer ItachiSet_ID = 'I01B'        
        real ItachiSet_Bonus = 17.5
//----------------------RaikageHat----------------------------------------------
        integer RaikageHat_ID = 'I00T'        
        real RaikageHat_Bonus = 17.5
//----------------------DemonDwellerSword----------------------------------------------
        integer DemonDwellerSword_ID = 'I041'
        integer DemonDwellerSword_Abi_ID = 'A0HX'
        integer DemonDwellerSword_Abi_CD_ID = 'A0HW'
        integer DemonDwellerSword_Phys_ID = 'B03A'
        integer DemonDwellerSword_Mag_ID = 'B039'
        real DemonDwellerSword_Bonus = 25
        real DemonDwellerSword_MinDmg = 500
        real DemonDwellerSword_CD = 10
//----------------------RockleeWeights----------------------------------------------
        integer RockleeWeights_ID = 'A06Q'
        real RockleeWeights_Range = 1100 // how far wind move
        real RockleeWeights_Time = 0.85 //how long wind move
        real RockleeWeights_Aoe = 280 // how fast barrel will land after cast
        real RockleeWeights_DMG = 25 // how fast barrel will land after cast
//----------------------RedCup----------------------------------------------
        integer RedCup_ID = 'A09L'
        real RedCup_Range = 1820 // how far wind move
        real RedCup_Time = 0.81 //how long wind move
        real RedCup_Aoe = 400 // how fast barrel will land after cast       
        real RedCup_Damage = 5.5// how much damage dealt x mainstat 
//----------------------MeraMera no mi----------------------------------------------
        real MeraMera_Aoe = 850       
        real MeraMera_Damage = 50     
        real MeraMera_MaxDamage = 250   
        real MeraMera_MaxHpDamage = 1.5//% of max owner hp
        unit array MeraMeraDummy
//----------------------Yata Mirror----------------------------------------------
        real YataMirror_Range = 1000       
        real YataMirror_ReversedDmg = 30// %
//----------------------FairyTailEmblem----------------------------------------------
        real FairyTailEmblem_CD = 18
        real FairyTailEmblem_ManaRestoreStatic = 250
        real FairyTailEmblem_ManaRestorePercent = 18 // of max mana
        real FairyTailEmblem_HpRestoreStatic = 350 // of max mana
//----------------------RedFlower----------------------------------------------
        integer RedFlower_ID = 'A09M'
        real RedFlower_DamageBase = 5.5// how much damage dealt x agi
        real RedFlower_Time = 1.8 // max travel time
        real RedFlower_Speed = 2100 // traveled for 1 sec     
//----------------------Avalon----------------------------------------------
        real Avalon_HpRestore = 20 // traveled for 1 sec   
//----------------------Urahara Set----------------------------------------------
        real UraharaSet_Range = 900 // traveled for 1 sec  
//----------------------Incursio----------------------------------------------
        real Incursio_Range = 750 // traveled for 1 sec   
//----------------------Funny_Barrel----------------------------------------------
        integer Raijin_Wrath_ID = 'A06O'
        real Raijin_Wrath_Damage = 5.5// how much damage dealt x mainstat
        real Raijin_Wrath_Aoe = 600 // how fast barrel will land after cast
//----------------------Sacred_Gear_Booster----------------------------------------------
        integer SacredGearBooster_Item_ID = 'I02M'
        integer SacredGearBooster_CDAbility_ID = 'A0GB'
        real SacredGearBooster_Damage = 3// how much damage dealt x mainstat added to active dmg items
        real SacredGearBooster_CD = 1// how much damage dealt x mainstat added to active dmg items
//----------------------Susanoo Shield----------------------------------------------
        integer SusanooShield_Item_ID = 'I02N'
        integer SusanooShield_TresholdDamage = 2000// how much damage dealt x mainstat added to active dmg items
        real SusanooShield_CD = 10// how much damage dealt x mainstat added to active dmg items
        real SusanooShield_Manacost = 125// how much damage dealt x mainstat added to active dmg items
//----------------------Funny_Barrel----------------------------------------------
        integer Rhitta_ID = 'A0F5'
        real Rhitta_Damage = 5.5// how much damage dealt x mainstat
        real Rhitta_Aoe = 600 // how fast barrel will land after cast
//----------------------TurboNeko----------------------------------------------
        integer TurboNeko_ID = 'A0CX'
        integer TurboNeko_Invul_ID = 'A0D0'
        real TurboNeko_Time = 2 // how fast barrel will land after cast        
//----------------------Hokage_Hat----------------------------------------------
        integer HokageHat_ID = 'A06S'
        real HokageHat_RootTime = 2// how long root
        real HokageHat_Manaburn = 100// how long root
//----------------------Hokage_Hat_Evolved----------------------------------------------
        integer HokageHatEvolved_ID = 'A0GX'
        real HokageHatEvolved_RootTime = 2.5// how long root
        real HokageHatEvolved_Manaburn = 250// how long root
        real HokageHatEvolved_AoEBegin = 150// how long root
        real HokageHatEvolved_AoE = 500// how long root
        real HokageHatEvolved_ExpandTime = 0.99// how long root
        real HokageHatEvolved_Time = 4// how long root
//----------------------Shark_Trail----------------------------------------------
        integer Shark_Trail_ID = 'A06P'
        real Shark_Trail_DamageBase = 5.5// how much damage dealt x agi
        real Shark_Trail_Time = 1.8 // max travel time
        real Shark_Trail_Speed = 1500 // traveled for 1 sec   
//----------------------Earth_Power----------------------------------------------
        real Earth_Power_DamageBase = 2 // how much damage dealt x agi
        real Earth_Power_CD = 3 // how much damage dealt x agi
        real Earth_Power_Time = 0.42 // max travel time
        real Earth_Power_MinDmg = 200 // 5 = 5%, deal dmg each sec 5 
//----------------------Guts_Armor----------------------------------------------
        integer GutsArmor_Buff_ID = 'B02D'
        real GutsArmor_DamageBase = 2.2 // how much damage dealt x str
        real GutsArmor_CD = 2 // how much damage dealt x agi
        real GutsArmor_DmgTreshold = 400 // max travel time
//----------------------QuincyCross----------------------------------------------
        real QuincyCross_DamageBase = 40 // how much damage static
        real QuincyCross_MaxDmg = 99999 // from which dmg amount it will work
        real QuincyCross_CD = 0 // how much damage dealt x main
        integer QuincyCross_MaxStacks = 0
        integer QuincyCross_Item_ID = 'I023'
        boolean QuincyCross_ReduceEffects = true
//----------------------Tachikaze----------------------------------------------
        real Tachikaze_DamageBase = 0.5 // how much damage dealt x main
        real Tachikaze_CD = 0.3 // how much damage dealt x main
//----------------------RyijinJakka----------------------------------------------
        real RyijinJakka_DamageBase = 2 // how much damage dealt x main
        real RyijinJakka_MinDmg = 200 // from which dmg amount it will work
        real RyijinJakka_CD = 7 // how much damage dealt x main
//----------------------Nejibana----------------------------------------------
        real Nejibana_DamageBase = 2 // how much damage dealt x main
        real Nejibana_MinDmg = 200 // from which dmg amount it will work
        real Nejibana_CD = 7 // how much damage dealt x main
//----------------------Gonryomaru----------------------------------------------
        real Gonryomaru_DamageBase = 2 // how much damage dealt x main
        real Gonryomaru_MinDmg = 200 // from which dmg amount it will work
        real Gonryomaru_CD = 7 // how much damage dealt x main
//----------------------Gonryomaru----------------------------------------------
        real SogyoNoKotowari_CD = 4 // how much damage dealt x main
//----------------------Cup of Tea----------------------------------------------
        integer CupOfTea_CD = 25 
        integer CupOfTeaEvolved_CD = 20 
//----------------------Holy Grail----------------------------------------------
        real HolyGrail_HpRegen = 10
        real HolyGrail_MpRegen = 4
//----------------------DarkHoly Grail----------------------------------------------
        real DarkHolyGrail_HpRegen = 20
        real DarkHolyGrail_MpRegen = 6
        real DarkHolyGrail_HpRegenReduce = 30 //% of active heal reducing
//----------------------Angel Blessing----------------------------------------------
        real AngelBlessing_Heal = 15  
//----------------------Elixir of Life----------------------------------------------
        real ElixirOfLife_HpRegen = 20
        real ElixirOfLife_CD = 7
//----------------------Shiki Knife----------------------------------------------
        real ShikiKnife_DmgBase = 80
        real ShikiKnife_DmgAgi = 1
        real ShikiKnife_CD = 4
        real ShikiKnife_RangeCheck = 650
//----------------------Shiki Knife Evolved----------------------------------------------
        real ShikiKnifeEvolved_DmgBase = 125
        real ShikiKnifeEvolved_DmgAgi = 1.5
        real ShikiKnifeEvolved_Multiplier = 1.5
        real ShikiKnifeEvolved_CD = 4
        real ShikiKnifeEvolved_RangeCheck = 650
        real ShikiKnifeEvolved_Range = 2100
        real ShikiKnifeEvolved_Aoe = 150
//----------------------Hungry Sin----------------------------------------------
        real HungrySin_hp = 25
        real HungrySin_mp = 10
        integer HungrySin_stack = 10
        real HungrySin_cd = 10
//----------------------Frozen Heart----------------------------------------------
        real FrozenHeart_hp = 100
        real FrozenHeart_mp = 25
        integer FrozenHeart_stack = 15
        real FrozenHeart_cd = 4
//----------------------Lust_Sin----------------------------------------------
        real LustSin_CD = 5
        real LustSin_MinDmg = 400 // from which dmg amount it will work
        real LustSin_IgnoreAmount = 90 // ignore 90% of shield
//----------------------Envy_Sin----------------------------------------------
        real EnvySin_IgnoreAmount = 25 // ignore 90% of shield
//----------------------Wrath_Sin----------------------------------------------
        real WrathSin_IgnoreAmount = 25 // ignore 90% of shield
        real WrathSin_IgnoreAmountAdd = 40 // ignore 90% of shield
//----------------------Funny_Barrel----------------------------------------------
        integer FunnyBarrel_ID = 'A00Z'
        real FunnyBarrel_Damage = 175.00// how much damage dealt
        real FunnyBarrel_DamageLvlMultiplier = 0.00// how much damage dealt
        real FunnyBarrel_FireExist = 9 // how long fire after explosion lives
        real FunnyBarrel_Time = 1.02 // how fast barrel will land after cast
        real FunnyBarrel_Aoe = 375 // how fast barrel will land after cast  
//----------------------Tusk_Barrel----------------------------------------------
        integer TuskBarrel_ID = 'A09N'
        real TuskBarrel_Range = 1800
        real TuskBarrel_PushRange = 600
        real TuskBarrel_Damage = 225.00// how much damage dealt
        real TuskBarrel_DamageStat = 4// how much damage dealt
        real TuskBarrel_DamageLvlMultiplier = 0.00// how much damage dealt
        real TuskBarrel_FireExist = 9 // how long fire after explosion lives
        real TuskBarrel_Time = 1 // how fast barrel will land after cast
        real TuskBarrel_Aoe = 400 // how fast barrel will land after cast          
//----------------------Tsuchikage_Hat_Evolved----------------------------------------------
        integer TsuchikageHatEvolve_ID = 'A0DD'
        real TsuchikageHatEvolve_Damage = 1.25 // x atk
        real TsuchikageHatEvolve_DamageBase = 100 // static
        real TsuchikageHatEvolve_DamageBaseMain = 2.25 // x mainstat
        real TsuchikageHatEvolve_DamageReducePerBounce = 15 // 20%
        integer TsuchikageHatEvolve_BounceTimes = 5 // 
        real TsuchikageHatEvolve_Time = 2.1 // max travel time
        real TsuchikageHatEvolve_AoeFindToBounce = 800 // max travel time
        real TsuchikageHatEvolve_Speed = 1600 // traveled for 1 sec   
        integer TsuchikageHatEvolve_Slow = 50 // slow percent
        integer TsuchikageHatEvolve_SlowTime = 4 // slow time   
//----------------------Tsuchikage_Hat----------------------------------------------
        integer TsuchikageHat_ID = 'A01Z'
        real TsuchikageHat_Damage = 1.25 // x atk
        real TsuchikageHat_DamageBase = 100 // static
        real TsuchikageHat_Time = 2.1 // max travel time
        real TsuchikageHat_Speed = 1600 // traveled for 1 sec   
        integer TsuchikageHat_Slow = 25 // slow percent
        integer TsuchikageHat_SlowTime = 4 // slow time   
//----------------------Hiraishin----------------------------------------------
        integer Hiraishin_ID = 'A076'
        real Hiraishin_Damage = 1.25 // x mainstat
        real Hiraishin_DamageBase = 100 // static          
//----------------------Funny_Present----------------------------------------------
        integer FunnyPresent_ID = 'A02G'
        real FunnyPresent_Damage = 150.00 // how much damage dealt
        real FunnyPresent_AoE = 160.00 // how large damage area dealt
        real FunnyPresent_Time = 1 // max travel time
        real FunnyPresent_Speed = 1600 // traveled for 1 sec   
        real FunnyPresent_Push = 220  
        real FunnyPresent_PushTime = 0.51         
//----------------------Naofumi_Shield----------------------------------------------
        integer NaofumiShield_ID = 'A02T'
        real NaofumiShield_Duration = 4   
//----------------------Nichirin----------------------------------------------
        real Nichirin_Decrease = 14   
//----------------------TrueZangetsu----------------------------------------------
        real TrueZangetsu_Decrease = 14  
//----------------------DeathNote----------------------------------------------
        integer DeathNote_ID = 'I044'
        integer DeathNote_CD_ID = 'A0I1'
        integer DeathNote_Abi_ID = 'A0I0'
        integer DeathNote_Buff_ID = 'B03B'
        real DeathNote_Damage = 30 // % of dealt dmg
        real DeathNote_CD = 7 // % of dealt dmg
        real DeathNote_MinDmg = 800 // % of dealt dmg
        real DeathNote_Time = 2.01 // max travel time
//----------------------KazekageHat----------------------------------------------
        real KazekageHat_Decrease = 50
//----------------------KanshoandBakuya----------------------------------------------
        real KanshoandBakuya_Decrease = 50  
//----------------------Okarun Egg----------------------------------------------
        real OkarunEggReduceCD = 15 // 15 = 15%   
//----------------------Prison Realm----------------------------------------------
        real PrisonRealmReduceCD = 25 // 15 = 15% 
        real PrisonRealmCD = 4 // 15 = 15% 
//----------------------Kurikara----------------------------------------------
        real Kurikara_MaxManaDmg = 4.5 // 5 = 5%, deal dmg each sec 5 
        real Kurikara_MinDmg = 200 // 5 = 5%, deal dmg each sec 5 
//---------------W ability-----------------------------------------------------
    endglobals
    function SacredGearBooster takes unit c, real dmg returns real 
    if HasCachedItem(c,SacredGearBooster_Item_ID ) > 0 and GetUnitAbilityLevel(c,SacredGearBooster_CDAbility_ID)>0 and BlzGetUnitAbilityCooldownRemaining(c,SacredGearBooster_CDAbility_ID) == 0  then 
            set dmg = dmg + ( GetMainStatValue(c,true)*SacredGearBooster_Damage )
            call BlzStartUnitAbilityCooldown(c,SacredGearBooster_CDAbility_ID,SacredGearBooster_CD)
            endif
            return dmg 
    endfunction
    private struct ItemsSpells_FunnyBarrel
        private static timer t_Item1 = CreateTimer()
        private static integer array m_Item1
        private static integer MUI_Item1 = -1
        unit c
        real x
        real y
        real r2
        integer k3
        real r3
        real sr
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_FunnyBarrel takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item1
                set this = m_Item1[i]
                if r <= rmax then
                    set r = r + 0.03
                    call MoveEff(e, move, a)
                    set r3 = r3 + move
                    set r2 = r2 + 9
                    call BlzSetSpecialEffectHeight(e,Parabola(800,sr,r3))
                    call BlzSetSpecialEffectRoll(e,r2*bj_DEGTORAD)
                    if k3 == 1 then 
                    call MoveEff(e2, move, a)
                    call BlzSetSpecialEffectHeight(e2,Parabola(800,sr,r3))
                    endif
                else
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call dmgmag(c, u, dmg)
                            call ErzaPassive(c, u, 1)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    call DecorRemove(c,x,y,aoe,20)
                     if k3 == 1 then 
                    call DestroyEffect(e2)
                    call BambiettaG2_Start(c,x,y)
		    set k3 = 0
                    endif

                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_GZ_jntxn (11)_R1-200.mdl",x,y,1,1,0.65,1))
                    call UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE),Fire_ID,x,y,1,1,1.75,45,FunnyBarrel_FireExist)
                    call ColorEffDummy3(e,0,255,255,255,1)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set u = null
                    set e = null
                    set m_Item1[i] = m_Item1[ MUI_Item1]
                    set MUI_Item1 = MUI_Item1 - 1
                    if MUI_Item1 == -1 then
                        call PauseTimer( t_Item1)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method FunnyBarrel_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item1 = MUI_Item1 + 1
            set m_Item1[ MUI_Item1] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set rmax = FunnyBarrel_Time
            set sr = SR3(c, x, y)
            set move = SR3(c, x, y) / (rmax * 100 / 3)
            set dmg = FunnyBarrel_Damage + GetHeroLevel(c)*FunnyBarrel_DamageLvlMultiplier
            set aoe = FunnyBarrel_Aoe
            set dmg = SacredGearBooster(c,dmg)
            set r = 0
            set r2 = 0
            set r3 = 0
            call SetUnitAnimation(c, "attack")
            set e = EffectSpawnScale("land_wos\\Barrel Explosive.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG+90, 1, 0.01, 100, 0.15, 0.01, 1.74)
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item1 == 0 then
                call TimerStart( t_Item1, 0.03, true, function thistype.Loop_FunnyBarrel)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TsuchikageHat
        private static timer t_Item2 = CreateTimer()
        private static integer array m_Item2
        private static integer MUI_Item2 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k3
        real r3
        real dmg
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_TsuchikageHat takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item2
                set this = m_Item2[i]
                if  SpellBoolCaster(td) and r <= rmax and SR5(e,GetUnitX(td),GetUnitY(td))>move then
                    set r = r + 0.03
                    set a = GAngle5(e,GetUnitX(td),GetUnitY(td))
                    call BlzSetSpecialEffectYaw(e,a)
                    call MoveEff(e, move, a)
                    if k3 == 1 then 
                    call MoveEff(e2, move, a)
                    endif
                else
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BambiettaG2_Start(c,x,y)
                    endif
                    call DestroyEffect(e)
                    call MUE(td,125,0.51,a)
                    call dmgatk(c, td, dmg)
                    call SlowUnit(c,td,TsuchikageHat_Slow,TsuchikageHat_SlowTime)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl",GetUnitX(td),GetUnitY(td),1,1,1,1))
                    set c = null
                    set td = null
                    set e = null
                    set m_Item2[i] = m_Item2[ MUI_Item2]
                    set MUI_Item2 = MUI_Item2 - 1
                    if MUI_Item2 == -1 then
                        call PauseTimer( t_Item2)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TsuchikageHat_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_Item2 = MUI_Item2 + 1
            set m_Item2[ MUI_Item2] = this
            set c = NewC
            set td = NewTd
            set a = GAngle(c,td)
            set rmax = TsuchikageHat_Time 
            set move = TsuchikageHat_Speed  / 33
            set dmg = TsuchikageHat_DamageBase+(TsuchikageHat_Damage *GetAttack(c) )
            set dmg = SacredGearBooster(c,dmg)
            
            set r = 0
            set r2 = 0
            set r3 = 0
            set k3 = 0
            call SetUnitAnimation(c, "attack")
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif
            set e = EffectSpawnScale("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 1.5)
            if MUI_Item2 == 0 then
                call TimerStart( t_Item2, 0.03, true, function thistype.Loop_TsuchikageHat)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_FunnyPresent
        private static timer t_Item3 = CreateTimer()
        private static integer array m_Item3
        private static integer MUI_Item3 = -1
        unit c
        real x
        real y
        real r2
        integer k3
        real r3
        group g
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_FunnyPresent takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item3
                set this = m_Item3[i]
                if r <= rmax then
                    set r = r + 0.03
                    call BlzSetSpecialEffectYaw(e,a)
                    call MoveEff(e, move, a)
                      if k3 == 1 then 
                    call MoveEff(e2, move, a)
                    endif

                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null or check >0
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                    call MUE(u,FunnyPresent_Push,FunnyPresent_PushTime,a)
                    call dmgmag(c, u, dmg)
                    set check = 1 
                    set r = 999
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                else  
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    call BambiettaG2_Start(c,x,y)
                    set k3 = 0
                    endif

                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdl",x,y,1,1,0.65,125))
                    call DestroyEffect(EffectSpawn("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl",x,y,1,1.1,4,5))
                    call DestroyEffect(EffectSpawn("Abilities\\Spells\\Other\\StrongDrink\\BrewmasterMissile.mdl",x,y,1,1.1,3,1))
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    set c = null
                    set g = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_Item3[i] = m_Item3[ MUI_Item3]
                    set MUI_Item3 = MUI_Item3 - 1
                    if MUI_Item3 == -1 then
                        call PauseTimer( t_Item3)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method FunnyPresent_Start takes unit NewC, real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item3 = MUI_Item3 + 1
            set m_Item3[ MUI_Item3] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set check = 0
            set a = GAngle2(c,x,y)
            set g = CreateGroup()
            set u = null
            set rmax = FunnyPresent_Time 
            set move = FunnyPresent_Speed  / 33
            set dmg = FunnyPresent_Damage
            set dmg = SacredGearBooster(c,dmg)
            
            set aoe = FunnyPresent_AoE
            set r = 0
            set r2 = 0
            set r3 = 0
            call SetUnitAnimation(c, "attack")
            set e = EffectSpawnScale("war3mapImported\\wos_PoopMissile.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.21, 0.01, 1.5)
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item3 == 0 then
                call TimerStart( t_Item3, 0.03, true, function thistype.Loop_FunnyPresent)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_NaofumiShield
        private static timer t_Item4 = CreateTimer()
        private static integer array m_Item4
        private static integer MUI_Item4 = -1
        unit c
        unit u
        real r
        effect e
        real rmax

         private static method Loop_NaofumiShield takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item4
                set this = m_Item4[i]
                if SpellBoolCaster(c) and GetUnitAbilityLevel(c,'B005')>0 and r<rmax  then //r <= rmax then
                if IsUnitPaused(c) == false then 
                    set r = r + 0.03
                    endif
                    call DebuffClear(c)
                    else  
                    call UnitRemoveAbility(c,'B005')
                    call SaveInteger(hs,GetHandleId(c),StringHash("naofumi shield"),0)
                    //call DestroyEffect(e)
                    set c = null
                    set u = null
                    set m_Item4[i] = m_Item4[ MUI_Item4]
                    set MUI_Item4 = MUI_Item4 - 1
                    if MUI_Item4 == -1 then
                        call PauseTimer( t_Item4)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method NaofumiShield_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_Item4 = MUI_Item4 + 1
            set m_Item4[ MUI_Item4] = this
            set c = NewC
            set r = 0
            set rmax = NaofumiShield_Duration 
                    call UnitRemoveBuffsEx(c,false,true,true,true,true,true,true)
        set u = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(u, 'A07P')
            call BlzSetUnitFacingEx(u, GAngle(u, c) * bj_RADTODEG)
            call IssueTargetOrder(u, "bloodlust", c)
            call MyRemoveUnit(u,0.1)
            set u = null
            call SaveInteger(hs,GetHandleId(c),StringHash("naofumi shield"),1)
           // set e = AddSpecialEffectTarget("war3mapImported\\wos_mei-torb.mdl", c, "origin")
            if MUI_Item4 == 0 then
                call TimerStart( t_Item4, 0.03, true, function thistype.Loop_NaofumiShield)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RaijinWrath
        private static timer t_Item5 = CreateTimer()
        private static integer array m_Item5
        private static integer MUI_Item5 = -1
        unit c
        real x
        real y
        integer k3
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_RaijinWrath takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item5
                set this = m_Item5[i]
                if  r <= rmax then
                    set r = r + 0.05
                    else  
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call dmgmag(c, u, dmg)
                            call ErzaPassive(c, u, 3)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                     if k3 == 1 then 
                    call DestroyEffect(e2)
                    call BambiettaG2_Start(c,x,y)
		    set k3 = 0
                    endif

                    call DecorRemove(c,x,y,aoe,50)
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    set c = null
                    set g = null
                    set u = null
                    set m_Item5[i] = m_Item5[ MUI_Item5]
                    set MUI_Item5 = MUI_Item5 - 1
                    if MUI_Item5 == -1 then
                        call PauseTimer( t_Item5)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaijinWrath_Start takes unit NewC,real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item5 = MUI_Item5 + 1
            set m_Item5[ MUI_Item5] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set g = CreateGroup()
            set u = null
            set dmg = Raijin_Wrath_Damage * GetHeroAgi(c,true) 
            set aoe = Raijin_Wrath_Aoe
            set dmg = SacredGearBooster(c,dmg)
            
            set r = 0
            set rmax = 0.4 
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            endif
            set k3 = 1
            endif

           call DestroyEffect(EffectSpawn("war3mapImported\\wos_lightningStomp.mdl",x,y,GetRandomReal(0,359),1.15,1.35,1))
            if MUI_Item5 == 0 then
                call TimerStart( t_Item5, 0.05, true, function thistype.Loop_RaijinWrath)
            endif
        endmethod

    endstruct
    private struct ItemsSpells_Rhitta
        private static timer t_Item5 = CreateTimer()
        private static integer array m_Item5
        private static integer MUI_Item5 = -1
        unit c
        real x
        real y
        integer k3
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_Rhitta takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item5
                set this = m_Item5[i]
                if  r <= rmax then
                    set r = r + 0.05
                    else  
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call dmgphys(c, u, dmg)
                            call ErzaPassive(c, u, 1)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                     if k3 == 1 then 
                    call DestroyEffect(e2)
                    call BambiettaG2_Start(c,x,y)
		    set k3 = 0
                    endif
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 2.85, 1))
                    call DecorRemove(c,x,y,aoe,50)
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    set c = null
                    set g = null
                    set u = null
                    set m_Item5[i] = m_Item5[ MUI_Item5]
                    set MUI_Item5 = MUI_Item5 - 1
                    if MUI_Item5 == -1 then
                        call PauseTimer( t_Item5)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method Rhitta_Start takes unit NewC,real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item5 = MUI_Item5 + 1
            set m_Item5[ MUI_Item5] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set g = CreateGroup()
            set u = null
            set dmg = Rhitta_Damage * GetHeroStr(c,true) 
            set aoe = Rhitta_Aoe
            set dmg = SacredGearBooster(c,dmg)
            
            set r = 0
            set rmax = 0.4
            set k3 = 0
            set a = GAngle2(c,x,y)
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            endif
            set k3 = 1  
            endif
           call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_item_rhita.mdl",x-650*Cos(a),y-650*Sin(a),a*bj_RADTODEG,0.8,4,100),0.5,255,255,255,1)
            if MUI_Item5 == 0 then
                call TimerStart( t_Item5, 0.05, true, function thistype.Loop_Rhitta)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_SharkTrail
        private static timer t_Item6 = CreateTimer()
        private static integer array m_Item6
        private static integer MUI_Item6 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k3
        real r3
        real dmg
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_SharkTrail takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item6
                set this = m_Item6[i]
                if SpellBoolCaster(td) and r <= rmax and SR5(e,GetUnitX(td),GetUnitY(td))>move then
                    set r = r + 0.03
                    set a = GAngle5(e,GetUnitX(td),GetUnitY(td))
                    call BlzSetSpecialEffectYaw(e,a)
                    call MoveEff(e, move, a)
                     if k3 == 1 then 
                    call MoveEff(e2, move, a)
                    endif

                else
                    call DestroyEffect(e)
                    call dmgphys(c, td, dmg)
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BambiettaG2_Start(c,x,y)
		    set k3 = 0
                    endif

                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call ErzaPassive(c, td, 2)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", x, y, GetRandomReal(0, 359), 2.5, 2, 80))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BrightBlueSlash.mdl", x, y, GetRandomReal(0, 359), 0.4, 2.5, 25))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_Shockwave_b.mdl", x, y, GetRandomReal(0, 359), 2, 2, 125))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK_ZL_BS_Arthur.mdl", x, y, 1, 2, 2, 125))
                    set c = null
                    set td = null
                    set e = null
                    set m_Item6[i] = m_Item6[ MUI_Item6]
                    set MUI_Item6 = MUI_Item6 - 1
                    if MUI_Item6 == -1 then
                        call PauseTimer( t_Item6)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method SharkTrail_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_Item6 = MUI_Item6 + 1
            set m_Item6[ MUI_Item6] = this
            set c = NewC
            set td = NewTd
            set a = GAngle(c,td)
            set rmax = Shark_Trail_Time 
            set move = Shark_Trail_Speed  / 33
            set dmg = Shark_Trail_DamageBase *GetHeroAgi(c,true)
            set dmg = SacredGearBooster(c,dmg)
            
            set r = 0
            set r2 = 0
            set r3 = 0
            call SetUnitAnimation(c, "attack")
             set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_Cz14_1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 0.66)
            if MUI_Item6 == 0 then
                call TimerStart( t_Item6, 0.03, true, function thistype.Loop_SharkTrail)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RockleeWeight
        private static timer t_Item7 = CreateTimer()
        private static integer array m_Item7
        private static integer MUI_Item7 = -1
        unit c
        real x
        real y
        real r2
        integer k3
        real r3
        real r5
        real sr
        group g
        group g2
        unit u
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_RockleeWeight takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item7
                set this = m_Item7[i]
                if r <= rmax then
                    set r = r + 0.03
                    call MoveEff(e, move, a)
                    if k3 == 1 then 
                    call MoveEff(e2, move, a)
                    endif
                    set r3 = r3 + move
                    call GroupClear(g)
                    call GroupEnumUnitsInRange( g , GetEffX(e) ,GetEffY(e) , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u,g2)== false then
                        call MUE(u,((rmax-r)/0.03)*move,rmax-r,a)
                        call dmgphys(c,u,RockleeWeights_DMG)
                        call GroupAddUnit(g2,u)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    if r2>=0.09 then
                    set r2 = 0.03
                    call GroupClear(g)
                    call GroupEnumUnitsInRange( g , GetEffX(e) ,GetEffY(e) , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                        call dmgphys(c,u,RockleeWeights_DMG)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    else
                    set r2 = r2 + 0.03
                    endif
                else
                    call ColorEffDummy3(e,0,255,255,255,0.66)
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    call BambiettaG2_Start(c,GetEffX(e) ,GetEffY(e))
                    set k3 = 0
                    endif

                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set m_Item7[i] = m_Item7[ MUI_Item7]
                    set MUI_Item7 = MUI_Item7 - 1
                    if MUI_Item7 == -1 then
                        call PauseTimer( t_Item7)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RockleeWeight_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item7 = MUI_Item7 + 1
            set m_Item7[ MUI_Item7] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set rmax = RockleeWeights_Time 
            set sr = RockleeWeights_Range 
            set move = sr / (rmax * 100 / 3)
            set aoe = RockleeWeights_Aoe
            set r5 = aoe/235
            set r = 0
            set r2 = 0
            set r3 = 0
            call SetUnitAnimation(c, "attack")
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 200)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 200)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_AirEssence.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG+90, 1, 0.01, 100, 0.15, 0.01, 4*r5)
            if MUI_Item7 == 0 then
                call TimerStart( t_Item7, 0.03, true, function thistype.Loop_RockleeWeight)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_Chogurt
        private static timer t_Item8 = CreateTimer()
        private static integer array m_Item8
        private static integer MUI_Item8 = -1
        unit c
        real x
        real y
        real r2
        real scale
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        integer check
        private static method Loop_Chogurt takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer k = 0
            loop
                exitwhen i > MUI_Item8
                set this = m_Item8[i]
                if r <= rmax then
                    set r = r + 0.03
                    set a = a - 5*bj_DEGTORAD
                    call BlzSetSpecialEffectYaw(e,a)
                    if r == 0.51 then 
                    set k = 0
                    loop
                    exitwhen k == 10 
                    if IsPlayerAlly(Player(k),GetOwningPlayer(c)) == false then 
                    if GetLocalPlayer() == Player(k) then 
                    call BlzSetSpecialEffectColor(e,255,15,15)
                    endif
                    else
                    if GetLocalPlayer() == Player(k) then 
                    call BlzSetSpecialEffectColor(e,255,255,255)
                    endif
                    endif
                    set k = k + 1
                    endloop
                    endif
                    if r2>0.92 then 
                    set r2 = 0
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitAlly( u , GetOwningPlayer( c )) then
                        set dmg = Chogurt_MpRestoreStatic+(GetUnitState(u,UNIT_STATE_MAX_MANA)*(Chogurt_MpRestore /100))
                        if check == 1 then 
                        if GetUnitState(u,UNIT_STATE_MANA)>=GetUnitState(u,UNIT_STATE_MAX_MANA) then 
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_HealGreen.mdl",u,"origin"))
                        call SetHpCurrent2(c,u, dmg)
                        else
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_HealBlue.mdl",u,"origin"))
                        call SetMpCurrent(u, dmg)
                        endif
                        else                        
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_HealBlue.mdl",u,"origin"))
                        call SetMpCurrent(u, dmg)
                        endif                            
                            call BuffUnitMS(u,u,0.2)                            
                    call UnitRemoveAbility(c,'B00T')
                    if check == 1 then 
                            call BuffUnit01(c, u, 'A0G2', "innerfire", 2)
                            else
                            call BuffUnit01(c, u, 'A0G2', "innerfire", 1)
                            endif
                            call UnitRemoveAbility(u,'Bslo')
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    else
                    set r2 = r2 + 0.03
                    endif
                    else  
                    call DestroyGroup(g)
                    call ColorEffDummy3(e,0,255,255,255,0.5)
                    set c = null
                    set g = null
                    set u = null
                    set m_Item8[i] = m_Item8[ MUI_Item8]
                    set MUI_Item8 = MUI_Item8 - 1
                    if MUI_Item8 == -1 then
                        call PauseTimer( t_Item8)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method Chogurt_Start takes unit NewC,real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item8 = MUI_Item8 + 1
            set m_Item8[ MUI_Item8] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set a = 1
            set r2 = 10
            set g = CreateGroup()
            set u = null
            set aoe = Chogurt_Aoe 
            set scale = aoe/590
            set a = GetRandomReal(0,359)
            set r = 0
            set check = 0
            if HasCachedItem(c, 'I03U') > 0 then 
            set check = 1 
            endif
            set rmax = Chogurt_Duration 
           set e = EffectSpawnScale("war3mapImported\\wos_blue energy aura.mdl",x,y,a,1,1,1,0.6,1,4*scale)
           set a = a*bj_DEGTORAD
           call ColorEffDummy4(e,0,255,255,255,0.4)
            if MUI_Item8 == 0 then
                call TimerStart( t_Item8, 0.03, true, function thistype.Loop_Chogurt)
            endif
        endmethod

    endstruct
    private struct ItemsSpells_HokageHatEvolved
        private static timer t_Item8 = CreateTimer()
        private static integer array m_Item8
        private static integer MUI_Item8 = -1
        unit c
        real x
        real y
        real r2
        real r3
        real scale
        real scale2
        group g
        group g2
        unit u
        real dmg
        real aoe
        integer k2 
        real aoe2
        real aoe3
        real r
        effect e
        real a
        real a2
        real rmax
        integer check
        private static method Loop_HokageHatEvolved takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer k = 0
            local real rr
            loop
                exitwhen i > MUI_Item8
                set this = m_Item8[i]
                if r <= rmax then
                    set r = r + 0.03
                    set a = a - 5*bj_DEGTORAD
                  //  call BlzSetSpecialEffectYaw(e,a)
                    if r<=HokageHatEvolved_ExpandTime  then
                    set aoe = aoe + aoe3
                    if r3>0.12 then 
                    set r3 = 0
                    set k = 0
                    if k2< 10 then 
                    set k2 = k2 + 1
                    set scale2 = scale2 -0.025
                    endif
                    set rr = aoe-85
                    set a2 = a2 + 9
                    loop
                    exitwhen k == k2
                    call EffectSpawn2("war3mapImported\\wos_shulao.mdl",x+rr*Cos(k*((360/k2)+a2)*bj_DEGTORAD),y+rr*Sin(k*((360/k2)+a2)*bj_DEGTORAD),GetRandomReal(0,359),1,scale*scale2,0,rmax-r)
                    set k = k + 1
                    endloop
                    else
                    set r3 = r3 + 0.03
                    endif
                    endif
                    if r2>0.12 then 
                    set r2 = 0
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u,g2)==false then
                        call SetMpCurrent(u, -HokageHatEvolved_Manaburn )
                        call GroupAddUnit(g2,u)
                        call RootUnit(c,u,HokageHatEvolved_RootTime )
                        call EUTU2(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl",GetUnitX(u),GetUnitY(u),1,1,1,1),HokageHatEvolved_RootTime,1,u)
                        call EUTU2(EffectSpawn("war3mapImported\\wos_s225.mdl",GetUnitX(u),GetUnitY(u),1,1,1,1),HokageHatEvolved_RootTime,1,u)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    else
                    set r2 = r2 + 0.03
                    endif
                    else  
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call ColorEffDummy3(e,0,255,255,255,0.5)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_Item8[i] = m_Item8[ MUI_Item8]
                    set MUI_Item8 = MUI_Item8 - 1
                    if MUI_Item8 == -1 then
                        call PauseTimer( t_Item8)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HokageHatEvolved_Start takes unit NewC,real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item8 = MUI_Item8 + 1
            set m_Item8[ MUI_Item8] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set a = 1
            set r2 = 0
            set k2 =6
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set aoe = HokageHatEvolved_AoEBegin 
            set aoe2 = HokageHatEvolved_AoE 
            set aoe3 = (aoe2 - aoe) / (HokageHatEvolved_ExpandTime / 0.03)
            set scale = aoe2/550
            set scale2 = 0.575
            set a = GetRandomReal(0,359)
            set r = 0
            set a2 = 0
            set rmax = HokageHatEvolved_Time  
          // set e = EffectSpawnScale("war3mapImported\\wos_blue energy aura.mdl",x,y,a,1,1,1,0.6,1,4*scale)
           set a = a*bj_DEGTORAD
           call EffectSpawn2("war3mapImported\\wos_shulao.mdl",x,y,GetRandomReal(0,359),1,scale*0.65,0,rmax-r)
            if MUI_Item8 == 0 then
                call TimerStart( t_Item8, 0.03, true, function thistype.Loop_HokageHatEvolved)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_EarthPower
        private static timer t_Item9 = CreateTimer()
        private static integer array m_Item9
        private static integer MUI_Item9 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k3
        real r3
        real dmg
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_EarthPower takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item9
                set this = m_Item9[i]
                if SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    set a = GAngle5(e,GetUnitX(td),GetUnitY(td))
                    if r< 0.42 then 
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BlzSetSpecialEffectYaw(e,a)
                    call BlzSetSpecialEffectPosition(e,x,y,0)
                    if k3 == 1 then 
                    call BlzSetSpecialEffectPosition(e2,x,y,100)
                    endif

                    endif
                else
                    call ColorEffDummy3(e,0,255,255,255,0.5)
                    if SR0(x,y,GetUnitX(td),GetUnitY(td))<250 then 
                    call dmgphys(c, td, dmg)
                    endif
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BambiettaG2_Start(c,x,y)
                    set k3 = 0
                    endif
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_wfile00009065.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl",x,y,1,1,1.75,1))
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set m_Item9[i] = m_Item9[ MUI_Item9]
                    set MUI_Item9 = MUI_Item9 - 1
                    if MUI_Item9 == -1 then
                        call PauseTimer( t_Item9)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method EarthPower_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_Item9 = MUI_Item9 + 1
            set m_Item9[ MUI_Item9] = this
            set c = NewC
            set td = NewTd            
            set a = GAngle(c,td)
            set rmax = Earth_Power_Time 
            set dmg = Earth_Power_DamageBase *GetMainStatValue(c,true)
            set r = 0
            set r2 = 0
            set r3 = 0
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x, y, a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_obr08 (698)2.mdl", x,y, a * bj_RADTODEG, 0.43, 0.01, 0, 0.15, 0.01, 0.5)
            if MUI_Item9 == 0 then
                call TimerStart( t_Item9, 0.03, true, function thistype.Loop_EarthPower)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RedCup
        private static timer t_Item10 = CreateTimer()
        private static integer array m_Item10
        private static integer MUI_Item10 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k3
        real r3
        real r5
        real sr
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax

         private static method Loop_RedCup takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item10
                set this = m_Item10[i]
                if  r <= rmax then
                    set r = r + 0.03
                    set x1 = x1+ move*Cos(a)
                    set y1 = y1+ move*Sin(a)
                    call MoveEff(e, move*0.03, a)
                    call MoveEff(e2, move, a)
                     if k3 == 1 then 
                    call MoveEff(e3, move, a)
                    endif
                    set r3 = r3 + move
                    call GroupClear(g)
                    if r2>0.0 then 
                    set r2 = 0
                    call DecorRemove(c,x1,y1,aoe+80,20)
                    call VisionTimed(GetOwningPlayer(c),x1,y1,aoe+300,1)
                    else
                    set r2 = r2 + 0.03
                    endif
                    call GroupEnumUnitsInRange( g , x1,y1 , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u,g2)== false then
                        call MUE(u,((rmax-r)/0.03)*move,rmax-r,a)
                        call ErzaPassive(c,u,2)
                        call dmgmag(c,u,dmg)
                        if k3 == 1 then 
                    call DestroyEffect(e3)
                    set x = GetUnitX(u)
                    set y = GetUnitY(u)
                    call BambiettaG2_Start(c,x,y)
                    set k3 = 0
                    endif

                        call GroupAddUnit(g2,u)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                else
                        if k3 == 1 then 
                    call DestroyEffect(e3)
                    call BambiettaG2_Start(c,x1,y1)
                    set k3 = 0
                    endif

                    call ColorEffDummy3(e,0,255,255,255,0.66)                    
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle3.mdl", x1, y1, GetRandomReal(0, 359), 1, 1.5, 1))
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyEffect(e3)
                    call MyRemoveEff(e2,0.35)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_Item10[i] = m_Item10[ MUI_Item10]
                    set MUI_Item10 = MUI_Item10 - 1
                    if MUI_Item10 == -1 then
                        call PauseTimer( t_Item10)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RedCup_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item10 = MUI_Item10 + 1
            set m_Item10[ MUI_Item10] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r2 = 0
            set dmg = GetHeroInt(c,true)*RedCup_Damage
            set dmg = SacredGearBooster(c,dmg)
            
            set g = CreateGroup()
            set g2 = CreateGroup()
            set x1 = GetUnitX(c)+100*Cos(a)
            set y1 = GetUnitY(c)+100*Sin(a)
            set u = null
            set a = GAngle2(c, x, y)
            set rmax = RedCup_Time 
            set sr = RedCup_Range 
            set aoe = RedCup_Aoe
            set r5 = aoe/335
            set move = (sr) / (rmax * 100 / 3)
            set r = 0
            set r2 = 0
            set r3 = 0
            call SetUnitAnimation(c, "attack")
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 250)
            else
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 250)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_watertornado.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.6*r5, 0.01, 100, 0.15, 0.01, 1.265*r5)
            set e2 = EffectSpawnScale("war3mapImported\\wos_Bubbles2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.75, 0.01, 100, 0.15, 0.01, 9*r5)
            if MUI_Item10 == 0 then
                call TimerStart( t_Item10, 0.03, true, function thistype.Loop_RedCup)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RedFlower
        private static timer t_Item11 = CreateTimer()
        private static integer array m_Item11
        private static integer MUI_Item11 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k3
        real r3
        real dmg
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        effect e6
        real a
        real rmax

        private static method Loop_RedFlower takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item11
                set this = m_Item11[i]
                if  SpellBoolCaster(td) and r <= rmax and SR5(e,GetUnitX(td),GetUnitY(td))>move then
                    set r = r + 0.03
                    set a = GAngle5(e,GetUnitX(td),GetUnitY(td))
                    call BlzSetSpecialEffectYaw(e,a)
                    call BlzSetSpecialEffectYaw(e2,a)
                    call MoveEff2(e, move, a+45*bj_DEGTORAD)
                    call MoveEff2(e2, move, a+45*bj_DEGTORAD)
                    if k3 == 1 then 
                    call MoveEff2(e5, move, a+45*bj_DEGTORAD)
                    endif
                    set a = GAngle5(e3,GetUnitX(td),GetUnitY(td))
                    call BlzSetSpecialEffectYaw(e3,a)
                    call BlzSetSpecialEffectYaw(e4,a)                    
                    call MoveEff2(e3, move, a-45*bj_DEGTORAD)
                    call MoveEff2(e4, move, a-45*bj_DEGTORAD)
                    if k3 == 1 then 
                    call MoveEff2(e6, move, a-45*bj_DEGTORAD)
                    endif

                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyEffect(e4)
                    call dmgmag(c, td, dmg)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call ErzaPassive(c, td, 3)
                    if k3 == 1 then 
                    call DestroyEffect(e5)
                    call DestroyEffect(e6)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BambiettaG2_Start(c,x,y)
		    set k3 = 0
                    endif

                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 0))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 3, 75))
                  
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set e6 = null
                    set m_Item11[i] = m_Item11[ MUI_Item11]
                    set MUI_Item11 = MUI_Item11 - 1
                    if MUI_Item11 == -1 then
                        call PauseTimer( t_Item11)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RedFlower_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_Item11 = MUI_Item11 + 1
            set m_Item11[ MUI_Item11] = this
            set c = NewC
            set td = NewTd
            set a = GAngle(c,td)
            set rmax = RedFlower_Time 
            set move = RedFlower_Speed  / 33
            set dmg = RedFlower_DamageBase *GetHeroInt(c,true)
            set r = 0
            set r2 = 0
            set r3 = 0
            set dmg = SacredGearBooster(c,dmg)
            
            call SetUnitAnimation(c, "attack")
            set e = EffectSpawnScale("war3mapImported\\wos_lightningprojectile.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 2.1)
            set e3 = EffectSpawnScale("war3mapImported\\wos_lightningprojectile.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 2.1)
            set e2 = EffectSpawnScale("war3mapImported\\wos_Windwalk Blue Soul.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 1)
            set e4 = EffectSpawnScale("war3mapImported\\wos_Windwalk Blue Soul.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 1)
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e5 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            set e6 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e5 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            set e6 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item11 == 0 then
                call TimerStart( t_Item11, 0.03, true, function thistype.Loop_RedFlower)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TuskBarrel
        private static timer t_Item12 = CreateTimer()
        private static integer array m_Item12
        private static integer MUI_Item12 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k3
        real r3
        real r4
        real r5
        real sr
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_TuskBarrel takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item12
                set this = m_Item12[i]
                if  r <= rmax then
                    set r = r + 0.03
                    if r>=0.3 then 
                    set x1 = x1+ move*Cos(a)
                    set y1 = y1+ move*Sin(a)
                    call MoveEff(e, move, a)
                    if k3 == 1 then 
                    call MoveEff(e2, move, a)
                    endif
                    //call MoveEff(e2, move, a)
                    set r3 = r3 + move
                    call GroupClear(g)
                    if r4>0.24 then 
                    set r4 = 0
                    call UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE),Fire_ID,x1,y1,1,1,1.75,45,FunnyBarrel_FireExist)
                    else
                    set r4 = r4 + 0.03
                    endif
                    if r2>0.0 then 
                    set r2 = 0
                    call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_Order_MuZhiBenYing_Fir_Huo_DiMianss2.mdl", x1, y1, GetRandomReal(0, 359), 2, 1.35, 1, 0.51)
                    call DecorRemove(c,x1,y1,aoe+80,20)
                    call VisionTimed(GetOwningPlayer(c),x1,y1,aoe+300,1)
                    else
                    set r2 = r2 + 0.03
                    endif
                    call GroupEnumUnitsInRange( g , x1,y1 , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u,g2)== false then
                        call MUE(u,TuskBarrel_PushRange,rmax-r,a)
                        call ErzaPassive(c,u,1)
                        call dmgmag(c,u,dmg)
                        if k3 == 1 then 
                    call DestroyEffect(e2)
                    set x = GetUnitX(u)
                    set y = GetUnitY(u)
                    call BambiettaG2_Start(c,x,y)
                    set k3 = 0
                    endif
                        call GroupAddUnit(g2,u)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    endif
                else
                    call GroupEnumUnitsInRange( g , x1,y1 , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u,g2)== false then
                        call ErzaPassive(c,u,1)
                        call MUE(u,TuskBarrel_PushRange,rmax-r,GAngle3(x1,y1,u))
                        call dmgmag(c,u,dmg)
                        call GroupAddUnit(g2,u)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    call BambiettaG2_Start(c,x1,y1)
                    set k3 = 0
                    endif
                    call ColorEffDummy3(e,0,255,255,255,0.21)                    
                     call DecorRemove(c,x1,y1,aoe,40)
                    set x1 = x1 + 50*Cos(a)
                    set y1 = y1 + 50*Sin(a)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_GZ_jntxn (11)_R1-200.mdl",x1,y1,1,1,0.65,1))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_chargeorange2.mdl",x1,y1,1,1,10,50))
                    call EffectSpawn2("war3mapimported\\wos_Opdef (1054).mdl",x1,y1,1,1.35,1,55,0.05)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set m_Item12[i] = m_Item12[ MUI_Item12]
                    set MUI_Item12 = MUI_Item12 - 1
                    if MUI_Item12 == -1 then
                        call PauseTimer( t_Item12)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TuskBarrel_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item12 = MUI_Item12 + 1
            set m_Item12[ MUI_Item12] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r2 = 0
            set r3 = 0
            set dmg = TuskBarrel_Damage + GetHeroLevel(c)*TuskBarrel_DamageLvlMultiplier+ TuskBarrel_DamageStat*GetMainStatValue(c,true)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set x1 = GetUnitX(c)+100*Cos(a)
            set y1 = GetUnitY(c)+100*Sin(a)
            set u = null
            set a = GAngle2(c, x, y)
            set dmg = SacredGearBooster(c,dmg)
            
            set rmax = TuskBarrel_Time+0.3 
            set sr = TuskBarrel_Range 
            set aoe = TuskBarrel_Aoe
            set r5 = aoe/330
            set move = (sr) / (rmax * 100 / 3)
            set r = 0
            set r4 = 0
            set r2 = 0
            set r3 = 0
            call SetUnitAnimation(c, "attack")
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_jntxa_30a.mdl", GetUnitX(c)+110*Cos(a), GetUnitY(c)+110*Sin(a), a * bj_RADTODEG, 0.75, 0.01, 100, 0.3, 0.01, 1.15*r5)
            //set e2 = EffectSpawnScale("war3mapImported\\wos_Bubbles2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.75, 0.01, 100, 0.15, 0.01, 9*r5)
            if MUI_Item12 == 0 then
                call TimerStart( t_Item12, 0.03, true, function thistype.Loop_TuskBarrel)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TurboNeko
        private static timer t_Item13 = CreateTimer()
        private static integer array m_Item13
        private static integer MUI_Item13 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k3
        real r3
        unit u
        real r
        effect e
        effect e2
        effect e3
        effect e4
        real a
        real rmax

        private static method Loop_TurboNeko takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item13
                set this = m_Item13[i]
                if  DebuffImmune_Start(td,1) == 1 and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(td)
                    call UnitAddAbility(td,TurboNeko_Invul_ID)
                    call BlzSetUnitFacingEx(td,GetUnitFacing(td)+28)
                    if r2 > 0.03  then 
                    set r2 = 0
                     if IsUnitAlly(td,GetOwningPlayer(c)) then 
                    call DebuffClear(td)
                    endif
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BlzSetSpecialEffectPosition(e,x,y,1)
                    call BlzSetSpecialEffectPosition(e2,x,y,1)
                    if k3 == 1 then 
                    call BlzSetSpecialEffectPosition(e3,x,y,GetUnitFacing(td)+35)
                    endif
                    else
                    set r2 = r2 + 0.03
                    endif
                    if r3 > 0.3 and r<rmax-0.36 then 
                    set r3 = 0
                     call HeightSet(td,0.33,GetRandomReal(650,1050))
                   else
                   set r3 = r3 + 0.03
                    endif
                else
                    if IsUnitAlly(td,GetOwningPlayer(c)) then 
                    call DebuffClear(td)
                    endif
                    call StopSpellUnit(td)
                    call HeightSet(td,0.3,0)
                    if k3 == 1 then 
                    call DestroyEffect(e4)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BambiettaG2_Start(c,x,y)
                    set k3 = 0
                    endif

                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call UnitRemoveAbility(td,TurboNeko_Invul_ID)
                    call BlzSetSpecialEffectTimeScale(e3,0.45)
                    call ScaleEffDummy(e3,0.45,1.2,0.6)
                    call MyRemoveEff(e3,0.48)
                    set c = null
                    set td = null
                    set e3 = null
                    set e2 = null
                    set e = null
                  //  set e2 = null
                    set m_Item13[i] = m_Item13[ MUI_Item13]
                    set MUI_Item13 = MUI_Item13 - 1
                    if MUI_Item13 == -1 then
                        call PauseTimer( t_Item13)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TurboNeko_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_Item13 = MUI_Item13 + 1
            set m_Item13[ MUI_Item13] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r2 = 0
            set r =0
            set r3 = 0
            set u = null
                    call StartSpellUnit(td)
            set a = GAngle2(c, x, y)
            set rmax = TurboNeko_Time 
            set e = EffectSpawnScale("war3mapImported\\wos_BY_Wood_Eff_Wid_XuanFeng.mdl", x, y, a * bj_RADTODEG, 1.25, 0.01, 1, 0.2, 0.01, 10)
            set e2 = EffectSpawnScale("war3mapImported\\wos_BY_Wood_Eff_Wid_XuanFeng.mdl", x, y, a * bj_RADTODEG+180, 1.25, 0.01, 1, 0.2, 0.01, 11)
            set e3 = EffectSpawnScale("war3mapImported\\wos_az_bujingdule03512.mdl", x, y, a * bj_RADTODEG+180, 0.5, 0.01, 1, 0.81, 0.01, 1.25)
            call BlzSetSpecialEffectAlpha(e,185)
            call BlzSetSpecialEffectAlpha(e2,185)
            call BlzSetSpecialEffectAlpha(e3,105)
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and IsUnitEnemy(td,GetOwningPlayer(c)) and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e4 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x, y, a * bj_RADTODEG, 1, 1, 100)
            else
            set e4 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x, y, a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif
                    call UnitAddAbility(td,TurboNeko_Invul_ID)
                    call HeightSet(td,0.3,950)
                    call SetSoundPosition(gg_snd_TornadoLoop,x,y,300)
                    call StartSound(gg_snd_TornadoLoop)
            if MUI_Item13 == 0 then
                call TimerStart( t_Item13, 0.03, true, function thistype.Loop_TurboNeko)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TsuchikageHatEvolve
        private static timer t_Item14 = CreateTimer()
        private static integer array m_Item14
        private static integer MUI_Item14 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        integer k3
        real r3
        group g
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax

         private static method Loop_TsuchikageHatEvolve takes nothing returns nothing
            local integer this
            local integer i = 0
            local real kkk =0
            loop
                exitwhen i > MUI_Item14
                set this = m_Item14[i]
                if  SpellBoolCaster(td) and r <= rmax and SR5(e,GetUnitX(td),GetUnitY(td))>move  then
                    set r = r + 0.03
                    
                    if (r> 0.15 and check >0) or check == 0 then 
                    set a = GAngle5(e,GetUnitX(td),GetUnitY(td))
                    call BlzSetSpecialEffectYaw(e,a)
                    call MoveEff(e, move, a)
                    call MoveEff(e2, move, a)
                    if k3 == 1 then 
                    call MoveEff(e3, move, a)
                    endif

                    endif
                else
                    if check != 99999 then 
                    call MUE(td,11,0.51,a)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call SlowUnit(c,td,TsuchikageHatEvolve_Slow,TsuchikageHatEvolve_SlowTime)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl",GetUnitX(td),GetUnitY(td),1,1,1,1))
                    if k3 == 1 then 
                    call DestroyEffect(e3)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BambiettaG2_Start(c,x,y)
                    endif                    
                    call dmgatk(c, td, dmg)
                    endif
                    if check< check2 then
                    set k = 0                    
                    call GroupEnumUnitsInRange( g , x,y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null or k > 0
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and u != td then
                        set td = u 
                        set r = 0
                        set k = k + 1
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    if k>0 then 
                    set check = check + 1
                    set dmg = dmg * (1-(TsuchikageHatEvolve_DamageReducePerBounce/100))
                    set k3 = 0
                    if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x,y, a * bj_RADTODEG, 1, 1, 100)
            else
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif
                    else
                    set check = 99999
                    endif
                    else
                    call BlzSetSpecialEffectScale(e2,0.01)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    set u = null
                    set g = null
                    set c = null
                    set td = null
                    set e = null
                    set m_Item14[i] = m_Item14[ MUI_Item14]
                    set MUI_Item14 = MUI_Item14 - 1
                    if MUI_Item14 == -1 then
                        call PauseTimer( t_Item14)
                    endif
                    call deallocate(this)
                    set i = i - 1                
                    endif
                    endif
                set i = i + 1
            endloop
        endmethod

        public static method TsuchikageHatEvolve_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_Item14 = MUI_Item14 + 1
            set m_Item14[ MUI_Item14] = this
            set c = NewC
            set td = NewTd
            set a = GAngle(c,td)
            set rmax = TsuchikageHatEvolve_Time 
            set move = TsuchikageHatEvolve_Speed  / 33
            set dmg = TsuchikageHatEvolve_DamageBase+(TsuchikageHatEvolve_Damage *GetAttack(c) )+(TsuchikageHatEvolve_DamageBaseMain *GetMainStatValue(c,true) )
            set r = 0
            set g = CreateGroup()
            set u = null
            set check = 0
            set k3 = 0
            set aoe = TsuchikageHatEvolve_AoeFindToBounce
            set check2 = TsuchikageHatEvolve_BounceTimes 
            set r2 = 0
            set r3 = 0
            set dmg = SacredGearBooster(c,dmg)
            
            call SetUnitAnimation(c, "attack")
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif
            set e = EffectSpawnScale("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 1.5)
            set e2 = EffectSpawnScale("war3mapImported\\wos_Windwalk.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 80, 0.15, 0.01, 1.5)
            if MUI_Item14 == 0 then
                call TimerStart( t_Item14, 0.03, true, function thistype.Loop_TsuchikageHatEvolve)
            endif
        endmethod

    endstruct
    private struct ItemsSpells_ShikiKnifeEvolved
        private static timer t_Item3 = CreateTimer()
        private static integer array m_Item3
        private static integer MUI_Item3 = -1
        unit c
        real x
        real y
        real r2
        integer k3
        real r3
        group g
        real r5
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_ShikiKnifeEvolved takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item3
                set this = m_Item3[i]
                if r <= rmax then
                    set r = r + 0.03
                    call BlzSetSpecialEffectYaw(e,a)
                    call MoveEff(e, move, a)
                      if k3 == 1 then 
                    call MoveEff(e2, move, a)
                    endif
                    set r5 = r5 + move
                    if r5>r3 then 
                    set r = 999
                    endif
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null or check >0
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                    call dmgatk(c, u, dmg)
                    set check = 1
                    call BlzSetSpecialEffectPosition(e,GetUnitX(u),GetUnitY(u),200)
                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_corpse explosion.mdl", u, "origin"))
                            call DestroyEffect( EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, a * bj_RADTODEG, 0.35, 3, 145))
                    set r = 999
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                else  
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    call BambiettaG2_Start(c,x,y)
                    set k3 = 0
                    endif
                    
                    call DestroyGroup(g)
                    call ColorEffDummy3(e,0,255,255,255,0.15)
                    set c = null
                    set g = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_Item3[i] = m_Item3[ MUI_Item3]
                    set MUI_Item3 = MUI_Item3 - 1
                    if MUI_Item3 == -1 then
                        call PauseTimer( t_Item3)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method ShikiKnifeEvolved_Start takes unit NewC, real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Item3 = MUI_Item3 + 1
            set m_Item3[ MUI_Item3] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set check = 0
            set a = GAngle2(c,x,y)
            set g = CreateGroup()
            set u = null
            set rmax = 4 
            set r5 = 0
            set move = 90
            set dmg = ShikiKnifeEvolved_DmgBase + GetHeroAgi(c,true)*ShikiKnifeEvolved_DmgAgi
            set dmg = dmg * ShikiKnifeEvolved_DmgAgi
            set dmg = SacredGearBooster(c,dmg)
            
            set aoe = ShikiKnifeEvolved_Aoe 
            set r = 0
            set r2 = 0
            set r3 =ShikiKnifeEvolved_Range 
            call SetUnitAnimation(c, "attack")
            set e = EffectSpawn("war3mapimported\\wos_mh_nanaya_xd.mdl", GetUnitX(c) + 140 * Cos(a), GetUnitY(c) + 140 * Sin(a), a * bj_RADTODEG, 1, 2, 195)
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item3 == 0 then
                call TimerStart( t_Item3, 0.03, true, function thistype.Loop_ShikiKnifeEvolved)
            endif
        endmethod

    endstruct
private struct ItemsSpells_DeathNote
        private static timer t_Item9 = CreateTimer()
        private static integer array m_Item9
        private static integer MUI_Item9 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k3
        real r3
        real dmg
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_DeathNote takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item9
                set this = m_Item9[i]
                if r< 0.06 then 
                set r = r + 0.03
                endif
                if r> 0.03 then 
                if SpellBoolCaster(td) and r <= rmax and GetUnitAbilityLevel(td,DeathNote_Buff_ID )>0 then
                if GetUnitAbilityLevel(td,'Avul')==0 then 
                set r = r + 0.03
                endif 
                    set a = GAngle5(e,GetUnitX(td),GetUnitY(td))
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BlzSetSpecialEffectYaw(e,a)
                    call BlzSetSpecialEffectPosition(e,x,y,0)
                    if k3 == 1 then 
                    call BlzSetSpecialEffectPosition(e2,x,y,100)
                    endif

                    else
                    call ColorEffDummy3(e,0,255,255,255,0.5)
                    if GetUnitAbilityLevel(td,DeathNote_Buff_ID )>0 then 
                    call dmgmag(c, td, dmg)
                    if k3 == 1 then 
                    call DestroyEffect(e2)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call BambiettaG2_Start(c,x,y)
                    set k3 = 0
                    endif
                     call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, a * bj_RADTODEG + 90, 2.5, 1.5, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 1.475, 125))
                    call UnitRemoveAbility(td,DeathNote_Buff_ID)
                    endif
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set m_Item9[i] = m_Item9[ MUI_Item9]
                    set MUI_Item9 = MUI_Item9 - 1
                    if MUI_Item9 == -1 then
                        call PauseTimer( t_Item9)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method DeathNote_Start takes unit NewC, unit NewTd, real NewDmg returns nothing
            local thistype this = thistype.create( )
            set MUI_Item9 = MUI_Item9 + 1
            set m_Item9[ MUI_Item9] = this
            set c = NewC
            set td = NewTd            
            set a = GAngle(c,td)
            set rmax = DeathNote_Time  
            set dmg = NewDmg
            set r = 0
            set r2 = 0
            set r3 = 0
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x, y, a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_.mdl", x,y, a * bj_RADTODEG, 0.43, 0.01, 0, 0.15, 0.01, 1.5)
            if MUI_Item9 == 0 then
                call TimerStart( t_Item9, 0.03, true, function thistype.Loop_DeathNote)
            endif
        endmethod

    endstruct

    function DeathNote_Start takes unit c, unit td, real dmg  returns nothing
    call BuffUnit01(c,td,DeathNote_Abi_ID,"curse",1)
        call ItemsSpells_DeathNote.DeathNote_Start( c, td, dmg*(DeathNote_Damage/100 ) )
    endfunction  
    function ShikiKnifeEvolved_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_ShikiKnifeEvolved.ShikiKnifeEvolved_Start( c, x, y )
    endfunction
    function Naofumi_Start takes unit c returns nothing
        call ItemsSpells_NaofumiShield.NaofumiShield_Start( c )
    endfunction
    function Chogurt_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_Chogurt.Chogurt_Start( c, x, y )
    endfunction
    function FunnyBarrel_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_FunnyBarrel.FunnyBarrel_Start( c, x, y )
    endfunction
    function TuskBarrel_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_TuskBarrel.TuskBarrel_Start( c, x, y )
    endfunction
    function RockleeWeight_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_RockleeWeight.RockleeWeight_Start( c, x, y )
    endfunction    
    function RedCup_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_RedCup.RedCup_Start( c, x, y )
    endfunction
    function RaijinWrath_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_RaijinWrath.RaijinWrath_Start( c, x, y )
    endfunction
    function Rhitta_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_Rhitta.Rhitta_Start( c, x, y )
    endfunction
    function FunnyPresent_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_FunnyPresent.FunnyPresent_Start( c, x, y )
    endfunction
    function TsuchikageHat_Start takes unit c, unit td returns nothing
        call ItemsSpells_TsuchikageHat.TsuchikageHat_Start( c, td )
    endfunction
    function TsuchikageHatEvolve_Start takes unit c, unit td returns nothing
        call ItemsSpells_TsuchikageHatEvolve.TsuchikageHatEvolve_Start( c, td )
    endfunction
    function SharkTrail_Start takes unit c, unit td returns nothing
        call ItemsSpells_SharkTrail.SharkTrail_Start( c, td )
    endfunction
    function RedFlower_Start takes unit c, unit td returns nothing
        call ItemsSpells_RedFlower.RedFlower_Start( c, td )
    endfunction
    function EarthPower takes unit c, unit td returns nothing
        call ItemsSpells_EarthPower.EarthPower_Start( c, td )
    endfunction      
    function HokageHatEvolved_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_HokageHatEvolved.HokageHatEvolved_Start( c, x, y )
    endfunction
    function TurboNeko_Start takes unit c, unit td returns nothing
    if DebuffImmune_Start(td,1) == 1 then 
        call ItemsSpells_TurboNeko.TurboNeko_Start( c, td )
        endif
    endfunction    
    function QuincyCross_Start takes unit c, unit td returns nothing 
    local item cross
    local integer stacks
    local boolean completed = false

    // The damage hook also checks this, but keeping the guard makes the
    // public function safe when called from another place later.
    if c == null or td == null or BlzGetUnitAbilityCooldownRemaining(c, 'A0BY') > 0.0 then
        return
    endif

    // One inventory scan instead of three scans per proc.
    //set cross = GetItemById(c, QuincyCross_Item_ID)
   // if cross == null then
    //    return
  //  endif

   // set stacks = GetItemCharges(cross) + 1

   // if stacks >= QuincyCross_MaxStacks then
     //   set stacks = 0
     //   set completed = true
        call BlzStartUnitAbilityCooldown(c, 'A0BY', QuincyCross_CD)
    //endif

    //call SetItemCharges(cross, stacks)

    // Original damage, type and 0.06 delay are preserved.
    call NextDmg(c, td, QuincyCross_DamageBase * GetMainStatValue(c, true), 3, 0.06)

    // Item charges already display stacks. In reduced mode the expensive
    // particle model is shown once per completed four-hit cycle.
    if not QuincyCross_ReduceEffects or completed then
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (198)1.mdl", td, "chest"))
    endif

    set cross = null
endfunction
    function Tachikaze_Start takes unit c, unit td returns nothing
    if BlzGetUnitAbilityCooldownRemaining(c,'A0FC') == 0 then 
    call BlzStartUnitAbilityCooldown(c,'A0FC',Tachikaze_CD )
    call NextDmg(c,td,Tachikaze_DamageBase*GetMainStatValue(c,true),4,0.06)
    call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_dianjishanghai.mdx", td, "chest"))
    endif
    endfunction
    endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com

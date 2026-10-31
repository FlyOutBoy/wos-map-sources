library ItemsSpells initializer ItemsAnime_Init uses GearSystems
    globals
        // One hero tick replaces the per-ability 0.03 timers (runs only while any is active).
        private timer ItemsTick_Timer = CreateTimer()
        private boolean array ItemsTick_Active
        private integer ItemsTick_Users = 0
        private code ItemsTick_Callback = null
    endglobals

    private function ItemsTick_On takes integer k returns nothing
        if not ItemsTick_Active[k] then
            set ItemsTick_Active[k] = true
            set ItemsTick_Users = ItemsTick_Users + 1
            if ItemsTick_Users == 1 then
                call TimerStart(ItemsTick_Timer, 0.03, true, ItemsTick_Callback)
            endif
        endif
    endfunction

    private function ItemsTick_Off takes integer k returns nothing
        if ItemsTick_Active[k] then
            set ItemsTick_Active[k] = false
            set ItemsTick_Users = ItemsTick_Users - 1
            if ItemsTick_Users <= 0 then
                set ItemsTick_Users = 0
                call PauseTimer(ItemsTick_Timer)
            endif
        endif
    endfunction

    globals
        // One hero tick replaces the per-ability 0.05 timers (runs only while any is active).
        private timer ItemsTick05_Timer = CreateTimer()
        private boolean array ItemsTick05_Active
        private integer ItemsTick05_Users = 0
        private code ItemsTick05_Callback = null
    endglobals

    private function ItemsTick05_On takes integer k returns nothing
        if not ItemsTick05_Active[k] then
            set ItemsTick05_Active[k] = true
            set ItemsTick05_Users = ItemsTick05_Users + 1
            if ItemsTick05_Users == 1 then
                call TimerStart(ItemsTick05_Timer, 0.05, true, ItemsTick05_Callback)
            endif
        endif
    endfunction

    private function ItemsTick05_Off takes integer k returns nothing
        if ItemsTick05_Active[k] then
            set ItemsTick05_Active[k] = false
            set ItemsTick05_Users = ItemsTick05_Users - 1
            if ItemsTick05_Users <= 0 then
                set ItemsTick05_Users = 0
                call PauseTimer(ItemsTick05_Timer)
            endif
        endif
    endfunction

    globals
        // Hashed once at map load (was StringHash(...) on every call).
        private integer SH_MORPH_T = StringHash("morph t")
        private integer SH_NAOFUMI_SHIELD = StringHash("naofumi shield")
    endglobals
    globals
//----------------------Chogurt----------------------------------------------
        integer Chogurt_ID = 'A06R'
        real Chogurt_MpRestore = 3 //how much % of max mana restored every second
        real Chogurt_Duration = 5 //how long area live
        real Chogurt_Aoe = 705 // how fast barrel will land after cast
        real Chogurt_MpRestoreStatic = 20
        real Chogurt_DmgReduct = 7.5
        real ChogurtEvolved_DmgReduct = 12.5
//----------------------Murasame----------------------------------------------
        real Murasame_AttackDamage = 0.45
        real Murasame_Duration = 5 // ticks, one per second
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
        real DemonDwellerSword_Bonus = 33
        real DemonDwellerSword_MinDmg = 250
        real DemonDwellerSword_CD = 5
//----------------------RockleeWeights----------------------------------------------
        integer RockleeWeights_ID = 'A06Q'
        real RockleeWeights_Range = 1100 // how far wind move
        real RockleeWeights_Time = 0.85 //how long wind move
        real RockleeWeights_Aoe = 280 // how fast barrel will land after cast
        real RockleeWeights_DMG = 25 // how fast barrel will land after cast
//----------------------RedCup----------------------------------------------
        integer RedCup_ID = 'A09L'
        real RedCup_Range = 1820 // how far wind move
        real RedCup_Time = 0.9 //how long wind move
        real RedCup_Aoe = 400 // how fast barrel will land after cast       
        real RedCup_Damage = 5.5// how much damage dealt x mainstat 
        real RedCup_GrowTime = 0.35 // wave grows from tiny to full scale (frozen animation) before moving
//----------------------MeraMera no mi----------------------------------------------
        real MeraMera_Aoe = 850       
        real MeraMera_Damage = 40     
        real MeraMera_MaxDamage = 250   
        real MeraMera_MaxHpDamage = 1.15//% of max owner hp
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
        real RedFlower_DamageBase = 6// how much damage dealt x agi
        real RedFlower_Time = 1.8 // max travel time
        real RedFlower_Speed = 2400 // traveled for 1 sec     
//----------------------Avalon----------------------------------------------
        real Avalon_HpRestore = 20 // traveled for 1 sec      
//----------------------Avalon Evolved----------------------------------------------
        real AvalonEvolved_HpRestore = 50 // traveled for 1 sec   
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
        real SacredGearBooster_Damage = 2.5// how much damage dealt x mainstat added to active dmg items
        real SacredGearBooster_CD = 1// how much damage dealt x mainstat added to active dmg items
        real SacredGearBooster_ItemCDReduce = 5 // proc reduces the cooldown of the cast item active by this many seconds
        integer SacredGearBooster_CastAbil = 0 // item active being cast right now (set by ItemsCast)
        boolean SacredGearBooster_Proc = false // proc during an item cast; CastCheck shortens that item's CD
//----------------------Susanoo Shield----------------------------------------------
        integer SusanooShield_Item_ID = 'I02N'
        integer SusanooShield_TresholdDamage = 2000// how much damage dealt x mainstat added to active dmg items
        real SusanooShield_CD = 8// how much damage dealt x mainstat added to active dmg items
        real SusanooShield_Manacost = 150// how much damage dealt x mainstat added to active dmg items
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
        real HokageHatEvolved_RootTime = 3// how long root
        real HokageHatEvolved_Manaburn = 250// how long root
        real HokageHatEvolved_AoEBegin = 150// how long root
        real HokageHatEvolved_AoE = 600// how long root
        real HokageHatEvolved_ExpandTime = 0.99// how long root
        real HokageHatEvolved_Time = 4// how long root
//----------------------Shark_Trail----------------------------------------------
        integer Shark_Trail_ID = 'A06P'
        real Shark_Trail_DamageBase = 6// how much damage dealt x agi
        real Shark_Trail_Time = 1.8 // max travel time
        real Shark_Trail_Speed = 1900 // traveled for 1 sec   
//----------------------Earth_Power----------------------------------------------
        real Earth_Power_DamageBase = 2 // how much damage dealt x agi
        real Earth_Power_CD = 3 // how much damage dealt x agi
        real Earth_Power_Time = 0.42 // max travel time
        real Earth_Power_MinDmg = 200 // 5 = 5%, deal dmg each sec 5 
//----------------------Guts_Armor----------------------------------------------
        integer GutsArmor_Buff_ID = 'B02D'
        real GutsArmor_DamageBase = 2.2 // how much damage dealt x str
        real GutsArmor_CD = 2 // how much damage dealt x agi
        real GutsArmor_DmgTreshold = 200 // max travel time
//----------------------QuincyCross----------------------------------------------
        real QuincyCross_DamageBase = 45 // how much damage static
        real QuincyCross_MaxDmg = 99999 // from which dmg amount it will work
        real QuincyCross_CD = 0 // how much damage dealt x main
        integer QuincyCross_MaxStacks = 0
        integer QuincyCross_Item_ID = 'I023'
        boolean QuincyCross_ReduceEffects = true
//----------------------Tachikaze----------------------------------------------
        real Tachikaze_DamageBase = 0.8 // how much damage dealt x main
        real Tachikaze_CD = 0.95 // how much damage dealt x main
//----------------------RyijinJakka----------------------------------------------
        real RyijinJakka_DamageBase = 2 // how much damage dealt x main
        real RyijinJakka_MinDmg = 200 // from which dmg amount it will work
        real RyijinJakka_CD = 6 // how much damage dealt x main
//----------------------Nejibana----------------------------------------------
        real Nejibana_DamageBase = 2 // how much damage dealt x main
        real Nejibana_MinDmg = 200 // from which dmg amount it will work
        real Nejibana_CD = 6 // how much damage dealt x main
//----------------------Gonryomaru----------------------------------------------
        real Gonryomaru_DamageBase = 2 // how much damage dealt x main
        real Gonryomaru_MinDmg = 200 // from which dmg amount it will work
        real Gonryomaru_CD = 6 // how much damage dealt x main
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
        real ShikiKnife_CD = 6
        real ShikiKnife_RangeCheck = 650
//----------------------Shiki Knife Evolved----------------------------------------------
        real ShikiKnifeEvolved_DmgBase = 125
        real ShikiKnifeEvolved_DmgAgi = 1.5
        real ShikiKnifeEvolved_Multiplier = 1.5
        real ShikiKnifeEvolved_CD = 6
        real ShikiKnifeEvolved_RangeCheck = 650
        real ShikiKnifeEvolved_Range = 2100
        real ShikiKnifeEvolved_Aoe = 190
//----------------------Defensive passives----------------------------------------------
        real PhilosopherStone_Lifesteal = 18 // % of final damage dealt restored as HP
        real BlackClover_StackReduce = 1 // % damage reduction per resist stack (max 6)
        real Incursio_HpRegen = 5
        real Incursio_MpRegen = 2.5
        real WitchSin_MagicReduce = 21 // % magic damage reduction for 5 sec after the stun proc
        real BlueEmperor_PhysReduce = 23 // % physical damage reduction of Emperor's Patience
        real Jewel_HpRestore = 500 // static heal of the root/silence proc
        real Jewel_HpRestorePercent = 3 // + % of the holder's max HP
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
        real LustSin_CD = 7
        real LustSin_MinDmg = 400 // from which dmg amount it will work
        real LustSin_IgnoreAmount = 100 // ignore 90% of shield
//----------------------Envy_Sin----------------------------------------------
        real EnvySin_IgnoreAmount = 25 // ignore 90% of shield
//----------------------Wrath_Sin----------------------------------------------
        real WrathSin_IgnoreAmount = 25 // ignore 90% of shield
        real WrathSin_IgnoreAmountAdd = 65 // ignore 90% of shield
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
        real TsuchikageHatEvolve_AttackPerBounce = 100 // one extra bounce per full 100 ATK
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
        real NaofumiShield_Duration = 5   
//----------------------Nichirin----------------------------------------------
        real Nichirin_Decrease = 16   
//----------------------TrueZangetsu----------------------------------------------
        real TrueZangetsu_Decrease = 16  
//----------------------DeathNote----------------------------------------------
        integer DeathNote_ID = 'I044'
        integer DeathNote_CD_ID = 'A0I1'
        integer DeathNote_Abi_ID = 'A0I0'
        integer DeathNote_Buff_ID = 'B03B'
        real DeathNote_Damage = 30 // % of dealt dmg
        real DeathNote_CD = 5 // % of dealt dmg
        real DeathNote_MinDmg = 600 // % of dealt dmg
        real DeathNote_Time = 2.01 // max travel time
//----------------------SakuraSesshou----------------------------------------------
        integer SakuraSesshou_ID = 'A0HE'
        real SakuraSesshou_Duration = 10.0 // matches A0HE duration
        real SakuraSesshou_Interval = 2.0 // seconds between lightning strikes
        real SakuraSesshou_Aoe = 1100.0
        real SakuraSesshou_Damage = 1.25 // x main stat (reveal radius 1400 = A0HE area)
//----------------------KazekageHat----------------------------------------------
        real KazekageHat_Decrease = 50
//----------------------KanshoandBakuya----------------------------------------------
        real KanshoandBakuya_Decrease = 50  
//----------------------Okarun Egg----------------------------------------------
        real OkarunEggReduceCD = 14 // 15 = 15%   
//----------------------Prison Realm----------------------------------------------
        real PrisonRealmReduceCD = 22.5 // 15 = 15% 
        real PrisonRealmCD = 4 // 15 = 15% 
//----------------------Kurikara----------------------------------------------
        real Kurikara_MaxManaDmg = 4.5 // 5 = 5%, deal dmg each sec 5 
        real Kurikara_MinDmg = 200 // 5 = 5%, deal dmg each sec 5 
//----------------------Kusanagi (Attack Items)----------------------------------------------
        integer Kusanagi_ID = 'I046'
        integer KusanagiFire_ID = 'I047'
        integer KusanagiWater_ID = 'I048'
        integer KusanagiElectro_ID = 'I049'
        integer Kusanagi_Abi_ID = 'A102' // one active shared by all four swords (shared cooldown)
        integer Kusanagi_Atk_ID = 'A100' // +40 atk
        integer KusanagiGrade_Atk_ID = 'A101' // +60 atk
        real Kusanagi_Aoe = 700
        real Kusanagi_AtkMult = 2 // x ATK per target
        real KusanagiGrade_AtkMult = 3 // x ATK per target, elemental grades
        real Kusanagi_StrikeInterval = 0.21 // seconds between dashes (as Tomioka E)
        real Kusanagi_BehindDistance = 100
        real Kusanagi_SlashSpeed = 0.6 // slash animation speed (was 0.4)
//----------------------Hashirama Cells----------------------------------------------
        integer HashiramaCells_ID = 'I04A'
        integer HashiramaCells_Abi_ID = 'A10D'
        integer HashiramaCells_Str_ID = 'A10C' // +20 str while active
        real HashiramaCells_HpCost = 10 // % of current hp
        real HashiramaCells_HpRegen = 10 // ItemEnter / ItemLeave
        real HashiramaCells_Duration = 10
        real HashiramaCells_AllyHeal = 15 // % of damage taken healed to nearby allied heroes
        real HashiramaCells_AllyAoe = 700
//----------------------Shun Shun Rikka----------------------------------------------
        integer ShunShunRikka_ID = 'I04B'
        integer ShunShunRikka_Buff_ID = 'B03F'
        real ShunShunRikka_HealAmp = 18 // % more hp regen and healing
        real ShunShunRikka_StunReduce = 0.5 // sec
        real ShunShunRikka_CcReduce = 0.5 // sec off silences and roots
//----------------------Frozen Heart ally aura----------------------------------------------
        integer FrozenHeart_Buff_ID = 'B040'
        real FrozenHeart_ManaAmp = 20 // % more mana regen and mana restoration
//----------------------Ashisogi Jizo----------------------------------------------
        integer AshisogiJizo_ID = 'I04C'
        integer AshisogiJizo_Curse_ID = 'A110'
        integer AshisogiJizo_Buff_ID = 'B041'
        real AshisogiJizo_MinDmg = 100
        real AshisogiJizo_DamageAgi = 0.5 // x agi physical damage per tick
        real AshisogiJizo_Duration = 5 // sec: native curse A110 duration (buff B041), refreshed per hit
//----------------------Core Drill (Gurren Lagann)----------------------------------------------
        // Ability damage of a type grants a stack of that type; each stack: +5% damage of the same type.
        integer CoreDrill_ID = 'I04E'
        real CoreDrill_BonusPerStack = 5 // % per stack
        integer CoreDrill_MaxStacks = 5
        real CoreDrill_Duration = 4 // sec, refreshed by each new stack
        // Synced game clock for stack expiry; started on the first stack.
        timer CoreDrill_Clock = CreateTimer()
        boolean CoreDrill_ClockStarted = false
        integer SH_CORE_DRILL_PHYS = StringHash("core drill phys")
        integer SH_CORE_DRILL_PHYS_END = StringHash("core drill phys end")
        integer SH_CORE_DRILL_MAG = StringHash("core drill mag")
        integer SH_CORE_DRILL_MAG_END = StringHash("core drill mag end")
        // Last shown buff level / last dummy cast per type: repeated hits within
        // CoreDrill_RecastGap at the same level do not recast the visual buff.
        integer SH_CORE_DRILL_PHYS_SHOWN = StringHash("core drill phys shown")
        integer SH_CORE_DRILL_PHYS_CAST = StringHash("core drill phys cast")
        integer SH_CORE_DRILL_MAG_SHOWN = StringHash("core drill mag shown")
        integer SH_CORE_DRILL_MAG_CAST = StringHash("core drill mag cast")
        real CoreDrill_RecastGap = 0.25
        // Visible stacks: a dummy casts an Inner Fire copy (zero bonuses) whose level picks the buff.
        integer CoreDrill_PhysAbi = 'A12C' // buffs B04D..B051 = 1..5 stacks
        integer CoreDrill_MagAbi = 'A12D'  // buffs B052..B056 = 1..5 stacks
        // One permanent dummy per player. Both copies share the "innerfire" order,
        // so it holds only the type it casts now (swapped on a type change).
        unit array CoreDrill_Dummy // [pid]
        integer array CoreDrill_DummyAbi // ability currently on CoreDrill_Dummy[pid]
//----------------------Rhitta strength stacks----------------------------------------------
        integer array Rhitta_Str_ID // [1..7] +5 str each
        integer Rhitta_StrMaxStacks = 7
        real Rhitta_StrDuration = 10
//----------------------Anime items (2026-10-27 / 10-28)-----------------------------------
    // 2026-10-27 items. Rawcodes: object-data/items-2026-10-27-ids.json (tools/stage_items_2026_10_27.py).
    // Hooks: DmgSys (ItemsAnime_FinalDamage / ItemsAnime_OnAttack), CastAItems (ItemsAnime_Cast),
    // CastCheck (ItemsAnime_OnHeroCast), WoS_Pick_Init (ItemsAnime_RoundEnd). Systems1/2 read the buff
    // and item globals directly (heal/mana cuts, Armament Haki in DebuffImmune_Start, auras).
        integer ArmamentHaki_ID = 'I04F'
        integer ArmamentHakiEvolved_ID = 'I050'
        integer ArmamentHaki_CD_ID = 'A12E'
        integer ArmamentHakiEvolved_CD_ID = 'A12F'
        integer ArmamentHaki_BuffAbi_ID = 'A130'
        integer ArmamentHaki_Buff_ID = 'B057'
        real ArmamentHaki_CD = 15
        real ArmamentHaki_ImmuneTime = 3 // Evolved only
        integer SH_ARMAMENT_HAKI_IMMUNE = StringHash("armament haki immune")

        integer NaofumiShieldEvolved_ID = 'I051'
        real NaofumiShieldEvolved_Block = 40 // flat damage blocked from every hit
        real NaofumiShieldEvolved_BlockActive = 100 // while the shield active (A02T) runs
        integer SH_ItemsAnime_NAOFUMI_SHIELD = StringHash("naofumi shield")

        integer SukunaFinger_ID = 'I052'
        integer SukunaFinger_Abi_ID = 'A131'
        integer SukunaFinger_Curse_ID = 'A132'
        integer SukunaFinger_Buff_ID = 'B058' // healing and HP regeneration -100% (Systems1/2)
        real SukunaFinger_Duration = 7
        integer SukunaFinger_Slow = 15

        integer FiveElementsSeal_ID = 'I053'
        integer FiveElementsSeal_Abi_ID = 'A133'
        integer FiveElementsSeal_Curse_ID = 'A134'
        integer FiveElementsSeal_Buff_ID = 'B059' // mana regeneration and restoration -100% (Systems1/2)
        real FiveElementsSeal_Duration = 7
        real FiveElementsSeal_Silence = 2

        integer Tekkai_ID = 'I054'
        integer Tekkai_Abi_ID = 'A135'
        integer Tekkai_BuffAbi_ID = 'A136'
        integer Tekkai_Buff_ID = 'B05A'
        real Tekkai_HpRegen = 30 // ItemEnter / ItemLeave

        integer Samehada_ID = 'I055'
        integer Samehada_Atk_ID = 'A137' // +45 atk (GetAttack mirrors it)
        real Samehada_ManaRestore = 4 // % of own max MP per attack
        real Samehada_ManaDrain = 4 // % of the target's max MP per attack

        integer WillOfD_ID = 'I056'
        integer WillOfD_CD_ID = 'A138'
        integer WillOfD_BuffAbi_ID = 'A139'
        integer WillOfD_Buff_ID = 'B05B'
        real WillOfD_Duration = 3 // game time: does not grow while the hero is paused
        real WillOfD_CD = 600
        integer SH_WILL_OF_D_END = StringHash("will of d end")

        integer Kairoseki_ID = 'I057'
        integer Kairoseki_Abi_ID = 'A13A'
        integer Kairoseki_Curse_ID = 'A13B'
        integer Kairoseki_Buff_ID = 'B05C'
        real Kairoseki_DamageReduce = 18 // % less damage dealt by the target

        integer IceCoffin_ID = 'I058'
        integer IceCoffin_Abi_ID = 'A13C'
        integer IceCoffin_BuffAbi_ID = 'A13D'
        integer IceCoffin_Buff_ID = 'B05D'
        real IceCoffin_Duration = 2

        integer ReturnByDeath_ID = 'I059'
        integer ReturnByDeath_Abi_ID = 'A13E'
        integer ReturnByDeath_BuffAbi_ID = 'A155'
        integer ReturnByDeath_Buff_ID = 'B063'
        real ReturnByDeath_Delay = 4
        integer ReturnByDeath_FrameSlot = 5 // MyFrame icon slot (heroes use 0-2)

        integer FairyTailEvolved_ID = 'I05A'
        real FairyTailEvolved_ManaAmp = 20 // % mana regeneration and restoration
        real FairyTailEvolved_HpRestorePercent = 4 // % max HP added to the 350 HP of the proc
        real FairyTailEvolved_HeroHealAmp = 1 // % HP restoration for Fairy Tail heroes

        integer ChogurtEvolved_AuraBuff_ID = 'B05E'

        // 2026-10-28 (object-data/items-2026-10-28-ids.json, tools/stage_items_2026_10_28.py)
        integer FiveElementsSeal_LockCurse_ID = 'A144'
        integer FiveElementsSeal_LockBuff_ID = 'B061' // dispellable: removing it (or casting) silences once
        integer RyujinJakkaEvolved_ID = 'I05B'
        integer NejibanaEvolved_ID = 'I05C'
        integer GonryomaruEvolved_ID = 'I05D'
        real ZanpakutoEvolved_CdReduce = 1 // explosion cooldown -1 sec; the element applies on every 200+ hit
        integer YataMirrorEvolved_ID = 'I05E'
        integer YataMirrorEvolved_Abi_ID = 'A140'
        integer YataMirrorEvolved_BuffAbi_ID = 'A141'
        integer YataMirrorEvolved_Buff_ID = 'B05F'
        real YataMirrorEvolved_ReflectActive = 75 // % while the active buff lasts (no range limit)
        integer PhilosopherEvolved_ID = 'I05F'
        integer PhilosopherEvolved_Abi_ID = 'A142'
        integer PhilosopherEvolved_BuffAbi_ID = 'A143'
        integer PhilosopherEvolved_Buff_ID = 'B060'
        real PhilosopherEvolved_BonusLifesteal = 18 // % on top of the base 18% while active
        trigger ItemsAnime_NumpadKeys = null
        // Ice Coffin own hotkey: WUI_CoffinKey (custom, saved) or the digit of the slot it was picked up in.
        integer array ItemsAnime_CoffinDigit
        trigger ItemsAnime_CoffinClick = null
        timer ItemsAnime_CoffinBadgeClock = null
        framehandle array ItemsAnime_CoffinButton
        framehandle array ItemsAnime_CoffinBox
        framehandle array ItemsAnime_CoffinIcon
        framehandle array ItemsAnime_CoffinText
        framehandle array ItemsAnime_CoffinChange
        framehandle array ItemsAnime_CoffinHit
        string array ItemsAnime_CoffinShown
        real ChogurtEvolved_AuraMpRegen = 8 // mana per second for allies in 1500 range
//----------------------Elemental actives (2026-10-28b)-------------------------------------
        // Fire / Water / Lightning x single target / AOE for every stat (with Rhitta, Shark Trail,
        // Raijin's Wrath, Red Cup, Red Flower). Objects: tools/stage_2026_10_28b.py; logic at the end
        // of this library (ItemsElements_*). Nothing lands instantly: projectiles, delays, pulses and
        // burns spread the damage; displacements are smooth (0.03 s steps). Each item has its own cooldown.
        integer Emberbreaker_ID = 'I060'
        integer Emberbreaker_Abi_ID = 'A145'
        integer LeviathanGrasp_ID = 'I061'
        integer LeviathanGrasp_Abi_ID = 'A146'
        integer LeviathanAnchor_ID = 'I062'
        integer LeviathanAnchor_Abi_ID = 'A147'
        integer ThunderVerdict_ID = 'I063'
        integer ThunderVerdict_Abi_ID = 'A148'
        integer ThunderBastion_ID = 'I064'
        integer ThunderBastion_Abi_ID = 'A149'
        integer CinderFang_ID = 'I065'
        integer CinderFang_Abi_ID = 'A14A'
        integer AshenCrossfire_ID = 'I066'
        integer AshenCrossfire_Abi_ID = 'A14B'
        integer MirrorTide_ID = 'I067'
        integer MirrorTide_Abi_ID = 'A14C'
        integer VoltThread_ID = 'I068'
        integer VoltThread_Abi_ID = 'A14D'
        integer PhoenixSeal_ID = 'I069'
        integer PhoenixSeal_Abi_ID = 'A14E'
        integer CrimsonScripture_ID = 'I06A'
        integer CrimsonScripture_Abi_ID = 'A14F'
        integer SirenTear_ID = 'I06B'
        integer SirenTear_Abi_ID = 'A150'
        integer ConstellationCoil_ID = 'I06C'
        integer ConstellationCoil_Abi_ID = 'A151'
        integer BloodPactRing_ID = 'I06D'
        integer BloodPactRing_Abi_ID = 'A152'
        integer BloodPactRingEvolved_ID = 'I073'
        integer BloodPactRingEvolved_Abi_ID = 'A154'
        real BloodPactRingEvolved_Duration = 5
        real BloodPactRingEvolved_ManaFloor = 25
        // Own damage per cast <= 6x stat per target, including item follow-ups; external bonuses are separate.
        real Emberbreaker_Impact = 4.0
        real Emberbreaker_Burn = 1.25 // over 2 sec
        real Emberbreaker_Knock = 120 // pushed back over 0.25 sec
        real Emberbreaker_Retaliate = 0.75
        real LeviathanGrasp_Impact = 3.75
        real LeviathanGrasp_Squeeze = 2.25 // when the 0.5 sec drag ends
        real LeviathanGrasp_Pull = 250
        real LeviathanGrasp_Heal = 15 // % of the damage dealt, at most 1.2x STR
        real LeviathanGrasp_HealCap = 1.2
        real LeviathanAnchor_Damage = 5.75 // 3 waves
        real LeviathanAnchor_Aoe = 500
        real LeviathanAnchor_PullSpeed = 190 // per sec towards the centre, 1.5 sec
        real ThunderVerdict_Damage = 5.5 // 3 strikes
        real ThunderVerdict_Leash = 500
        real ThunderVerdict_Bonus = 0.5
        real ThunderBastion_Damage = 5.25 // 4 pulses
        real ThunderBastion_Aoe = 475
        real ThunderBastion_Counter = 0.25
        real CinderFang_Impact = 5.0
        real CinderFang_Ricochet = 2.5
        real CinderFang_Bonus = 1.0
        real AshenCrossfire_Damage = 5.5
        real AshenCrossfire_Aoe = 400
        real AshenCrossfire_Return = 3.8
        constant string MirrorTide_ProjectileModel = "war3mapImported\\wos_file00012198.mdx"
        real MirrorTide_ProjectileScale = 0.66
        constant string AshenCrossfire_ProjectileModel = "war3mapImported\\wos_mx-yx-tsw-a-1_fire.mdx"
        real AshenCrossfire_ProjectileScale = 1.0
        real AshenCrossfire_ProjectileHeight = 220
        constant string ConstellationCoil_ProjectileModel = "war3mapImported\\wos_tx28.mdx"
        real ConstellationCoil_ProjectileScale = 1.0
        real MirrorTide_Damage = 5.5
        real MirrorTide_Aoe = 600
        real MirrorTide_WaveAoe = 300
        real MirrorTide_Range = 1600
        real MirrorTide_Push = 150 // over 0.3 sec, along the wave
        real MirrorTide_Reflect = 0.5
        real VoltThread_Damage = 5.5
        real VoltThread_Bonus = 0.5
        real VoltThread_LineDamage = 0.9 // x AGI per second
        real VoltThread_LineRadius = 300
        real PhoenixSeal_Impact = 3.75
        real PhoenixSeal_Burn = 1.75 // over 2 sec
        real PhoenixSeal_Bonus = 0.5
        real CrimsonScripture_Damage = 4.0
        real CrimsonScripture_Ground = 1.5 // over 1.5 sec
        real CrimsonScripture_Aoe = 450
        real CrimsonScripture_Burning = 0.5
        real SirenTear_Damage = 6.0
        real SirenTear_IntCap = 2.5
        real SirenTear_MaxMpCap = 8 // % of the target's max mana
        real SirenTear_Return = 60 // % of the drained mana
        real ConstellationCoil_Damage = 5.5 // one hit per enemy along the projectile
        real ConstellationCoil_Range = 1800
        real ConstellationCoil_Width = 200
        real ConstellationCoil_Speed = 1400
        integer ConstellationCoil_Slow = 25
        integer ConstellationCoil_SlowDuration = 2
        real ConstellationCoil_Aoe = 450
        real ConstellationCoil_Spin = 260 // sideways speed of the spiral
        real ConstellationCoil_PullSpeed = 120
        real ConstellationCoil_Break = 650
        real ConstellationCoil_Bonus = 0.9
        real BloodPactRing_Cost = 400
        real BloodPactRing_Mana = 400
        group ItemsElements_Group = CreateGroup()
        // Universal Bleach zanpakuto for the element debuffs (read by AAADest ErzaPassive and Systems1).
        integer ZankaNoTachi_ID = 'I06E'
        real ZankaNoTachi_Stack = 40 // Fire damage per second added by each re-application on a burning enemy
        real ZankaNoTachi_MaxDamage = 300 // Fire damage per second cap
        real ZankaNoTachi_Extend = 2 // Fire lasts 5 + 2 = 7 sec with the item (each application restarts it)
        integer KyokaSuigetsu_ID = 'I06F'
        real KyokaSuigetsu_Bonus = 0.6 // x main stat when Water meets Steam
        real KyokaSuigetsu_CD = 1 // per target
        real KyokaSuigetsu_SteamBonus = 8 // % physical damage on enemies in Steam (on top of ErzaWape_IncreaseDmg)
        real KyokaSuigetsu_SteamCD = 3 // a lone Fire / Water turns into Steam once per 3 sec per target
        integer KokoGonryo_ID = 'I070'
        real KokoGonryo_Damage = 0.2 // x main stat each second of the Lightning debuff
        integer Tobiume_ID = 'I071'
        real Tobiume_DamageMult = 2.0 // Overload 1x -> 2x main stat (~ +1x per reaction, like the other zanpakuto)
        real Tobiume_Stun = 0.4
        integer Suzumebachi_ID = 'I072'
        real Suzumebachi_DamageMult = 1.8 // Electrized 0.3x -> 0.54x main stat per sec (6 sec)
//---------------W ability-----------------------------------------------------
    endglobals
    // Item hover rules: audited item->ability links in assets/AbilityRange/item-rules.json.
    // CD-only Channel abilities often contain a dummy range of 900: never infer from them.
    // Returned native ability is cached synchronously by AbilityRangePreview, not on hover.
    public function GetPreviewAbility takes integer itemId returns integer
        // 2026-10-28b elemental actives (ItemsElements.j).
        if itemId == Emberbreaker_ID then
            return Emberbreaker_Abi_ID
        endif
        if itemId == LeviathanGrasp_ID then
            return LeviathanGrasp_Abi_ID
        endif
        if itemId == LeviathanAnchor_ID then
            return LeviathanAnchor_Abi_ID
        endif
        if itemId == ThunderVerdict_ID then
            return ThunderVerdict_Abi_ID
        endif
        if itemId == ThunderBastion_ID then
            return ThunderBastion_Abi_ID
        endif
        if itemId == CinderFang_ID then
            return CinderFang_Abi_ID
        endif
        if itemId == AshenCrossfire_ID then
            return AshenCrossfire_Abi_ID
        endif
        if itemId == MirrorTide_ID then
            return MirrorTide_Abi_ID
        endif
        if itemId == VoltThread_ID then
            return VoltThread_Abi_ID
        endif
        if itemId == PhoenixSeal_ID then
            return PhoenixSeal_Abi_ID
        endif
        if itemId == CrimsonScripture_ID then
            return CrimsonScripture_Abi_ID
        endif
        if itemId == SirenTear_ID then
            return SirenTear_Abi_ID
        endif
        if itemId == ConstellationCoil_ID then
            return ConstellationCoil_Abi_ID
        endif
        if itemId == SukunaFinger_ID then
            return SukunaFinger_Abi_ID
        endif
        if itemId == FiveElementsSeal_ID then
            return FiveElementsSeal_Abi_ID
        endif
        if itemId == Kairoseki_ID then
            return Kairoseki_Abi_ID
        endif
        if itemId == ShunShunRikka_ID then
            return 'A10E'
        endif
        if itemId == 'I00G' then
            return 'A00Z'
        endif
        if itemId == 'I00P' then
            return 'A01Z'
        endif
        if itemId == 'I00S' then
            return 'A02G'
        endif
        if itemId == 'I00U' then
            return 'A06S'
        endif
        if itemId == 'I015' then
            return 'A06O'
        endif
        if itemId == 'I016' then
            return 'A06P'
        endif
        if itemId == 'I017' then
            return 'A06R'
        endif
        if itemId == 'I01N' then
            return 'A076'
        endif
        if itemId == 'I01U' then
            return 'A09M'
        endif
        if itemId == 'I02A' then
            return 'A0CX'
        endif
        if itemId == 'I02C' then
            return 'A0DD'
        endif
        if itemId == 'I02L' then
            return 'A0F5'
        endif
        if itemId == 'I03U' then
            return 'A06R'
        endif
        if itemId == 'I03V' then
            return 'A0GX'
        endif
        if itemId == 'I03W' then
            return 'A0HE'
        endif
        if itemId == 'I01K' then
            return 'A07M'
        endif
        if itemId == 'I021' then
            return 'A09X'
        endif
        if itemId == 'I02B' then
            return 'A0CY'
        endif
        return 0
    endfunction

    // Pure presentation read. Script reach wins; native instances supply live cast/aura fields.
    // Exported fallback keeps passive item auras available if a native ability is absent.
    // Outer (grey) ring of an item preview: cast range + area for point-target dashes; 0 = none.
    public function GetItemPreviewReach takes integer itemId, ability nativeAbility returns real
        local real range = 1400.00
        if nativeAbility != null then
            set range = BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
        endif
        // Elemental AOE actives: white ring = click range + blast radius.
        if itemId == LeviathanAnchor_ID then
            return range + LeviathanAnchor_Aoe
        endif
        if itemId == ThunderBastion_ID then
            return range + ThunderBastion_Aoe
        endif
        if itemId == AshenCrossfire_ID then
            return range + AshenCrossfire_Aoe
        endif
        if itemId == MirrorTide_ID then
            return range + MirrorTide_Aoe
        endif
        if itemId == CrimsonScripture_ID then
            return range + CrimsonScripture_Aoe
        endif
        if itemId == ConstellationCoil_ID then
            return ConstellationCoil_Range + ConstellationCoil_Width
        endif
        if itemId == Kusanagi_ID or itemId == KusanagiFire_ID or itemId == KusanagiWater_ID or itemId == KusanagiElectro_ID then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0) + Kusanagi_Aoe
            endif
            return 1425.00 + Kusanagi_Aoe
        endif
        return 0.00
    endfunction

    public function GetItemPreviewRadius takes integer itemId, ability nativeAbility returns real
        if itemId == Emberbreaker_ID or itemId == LeviathanGrasp_ID or itemId == LeviathanAnchor_ID or itemId == ThunderVerdict_ID or itemId == ThunderBastion_ID or itemId == CinderFang_ID or itemId == AshenCrossfire_ID or itemId == MirrorTide_ID or itemId == VoltThread_ID or itemId == PhoenixSeal_ID or itemId == CrimsonScripture_ID or itemId == SirenTear_ID or itemId == ConstellationCoil_ID then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            if itemId == MirrorTide_ID then
                return MirrorTide_Range
            elseif itemId == ConstellationCoil_ID then
                return ConstellationCoil_Range
            endif
            return 1400.00
        endif
        if itemId == SukunaFinger_ID or itemId == FiveElementsSeal_ID or itemId == Kairoseki_ID then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 900.00
        endif
        // Kusanagi: red ring = click range; the grey ring (GetItemPreviewReach) adds the 700 dash area.
        if itemId == Kusanagi_ID or itemId == KusanagiFire_ID or itemId == KusanagiWater_ID or itemId == KusanagiElectro_ID then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1425.00
        endif
        if itemId == HashiramaCells_ID then
            return HashiramaCells_AllyAoe
        endif
        if itemId == ShunShunRikka_ID then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_AREA_OF_EFFECT, 0)
            endif
            return 1200.00
        endif
        if itemId == 'I00E' then
            return Incursio_Range
        endif
        if itemId == 'I00O' then
            return UraharaSet_Range
        endif
        if itemId == 'I014' then
            return RockleeWeights_Range
        endif
        if itemId == 'I01S' then
            return RedCup_Range
        endif
        if itemId == 'I01V' then
            return TuskBarrel_Range
        endif
        if itemId == 'I02G' then
            return MeraMera_Aoe
        endif
        if itemId == 'I02H' then
            return YataMirror_Range
        endif
        if itemId == 'I02P' then
            return ShikiKnife_RangeCheck
        endif
        if itemId == 'I042' then
            return ShikiKnifeEvolved_Range
        endif
        if itemId == 'I00G' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1300.00
        endif
        if itemId == 'I00P' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1100.00
        endif
        if itemId == 'I00S' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1400.00
        endif
        if itemId == 'I00U' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1250.00
        endif
        if itemId == 'I015' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1600.00
        endif
        if itemId == 'I016' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1400.00
        endif
        if itemId == 'I017' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1450.00
        endif
        if itemId == 'I01K' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_AREA_OF_EFFECT, 0)
            endif
            return 1500.00
        endif
        if itemId == 'I01N' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1100.00
        endif
        if itemId == 'I01U' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1400.00
        endif
        if itemId == 'I021' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_AREA_OF_EFFECT, 0)
            endif
            return 1200.00
        endif
        if itemId == 'I02A' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1250.00
        endif
        if itemId == 'I02B' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_AREA_OF_EFFECT, 0)
            endif
            return 1500.00
        endif
        if itemId == 'I02C' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1400.00
        endif
        if itemId == 'I02L' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1400.00
        endif
        if itemId == 'I03U' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1450.00
        endif
        if itemId == 'I03V' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 1250.00
        endif
        if itemId == 'I03W' then
            if nativeAbility != null then
                return BlzGetAbilityRealLevelField(nativeAbility, ABILITY_RLF_CAST_RANGE, 0)
            endif
            return 8000.00
        endif
        return 0.00
    endfunction

    function SacredGearBooster takes unit c, real dmg returns real 
    if HasCachedItem(c,SacredGearBooster_Item_ID ) > 0 and GetUnitAbilityLevel(c,SacredGearBooster_CDAbility_ID)>0 and BlzGetUnitAbilityCooldownRemaining(c,SacredGearBooster_CDAbility_ID) == 0  then 
            set dmg = dmg + ( GetMainStatValue(c,true)*SacredGearBooster_Damage )
            call BlzStartUnitAbilityCooldown(c,SacredGearBooster_CDAbility_ID,SacredGearBooster_CD)
            if SacredGearBooster_CastAbil != 0 then
                set SacredGearBooster_Proc = true
            endif
            endif
            return dmg 
    endfunction
    // Любой нажатый активный предмет (не только с уроном): SGB уходит в КД, а CastCheck режет КД предмета.
    // Предметы с уроном уже прокнули через SacredGearBooster (урон + КД) — повторно не срабатывает.
    function SacredGearBooster_ItemCast takes unit c, integer abilId returns nothing
        local integer slot = 0
        local item it
        if SacredGearBooster_Proc or HasCachedItem(c,SacredGearBooster_Item_ID) == 0 or GetUnitAbilityLevel(c,SacredGearBooster_CDAbility_ID) == 0 or BlzGetUnitAbilityCooldownRemaining(c,SacredGearBooster_CDAbility_ID) > 0 then
            return
        endif
        loop
            exitwhen slot > 5
            set it = UnitItemInSlot(c, slot)
            if it != null and BlzGetItemAbility(it, abilId) != null then
                call BlzStartUnitAbilityCooldown(c,SacredGearBooster_CDAbility_ID,SacredGearBooster_CD)
                set SacredGearBooster_Proc = true
                set slot = 6
            endif
            set slot = slot + 1
        endloop
        set it = null
    endfunction
    // Kusanagi active: one dash + strike per enemy in range, then back to the cast point.
    // Paused (not invulnerable) while dashing.
    private struct ItemsSpells_Kusanagi
        private static integer array m_Kus
        private static integer MUI_Kus = -1
        unit c
        group g
        real x
        real y
        real r
        real mult
        integer elem
        integer source
        string slash
        effect aura

        private method finish takes nothing returns nothing
            if GetWidgetLife(c) > 0.405 then
                call BlinkEff(c)
                call PosUnit(c, x, y)
                call BlinkEff(c)
            endif
            call StopSpellUnit2(c)
            call DestroyEffect(aura)
            call DestroyGroup(g)
            set aura = null
            set g = null
            set c = null
        endmethod

        private method strike takes nothing returns boolean
            local unit u
            local real a
            local real ux
            local real uy
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call GroupRemoveUnit(g, u)
                exitwhen SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c))
            endloop
            if u == null then
                return false
            endif
            set ux = GetUnitX(u)
            set uy = GetUnitY(u)
            set a = GetRandomReal(0, 359) * bj_DEGTORAD
            call BlinkEff(c)
            call PosUnit(c, ux - Kusanagi_BehindDistance * Cos(a), uy - Kusanagi_BehindDistance * Sin(a))
            call SetUnitFacing(c, GAngle(c, u) * bj_RADTODEG)
            call SetUnitTimeScale(c, 3)
            call SetUnitAnimation(c, "attack")
            call DamageSource(source)
            call dmgatk(c, u, GetAttack(c) * mult)
            if elem > 0 then
                call DamageSource(source)
                call ErzaPassive(c, u, elem)
            endif
            call DestroyEffect(EffectSpawn(slash, ux, uy, GetRandomReal(0, 359), Kusanagi_SlashSpeed, 2.5, 25))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", ux, uy, a * bj_RADTODEG, 0.35, 3, 145))
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
            call MakeSound("war3mapimported\\Hero_Tomioka_F_Cut")
            if elem == 1 then
                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_fire explosion.mdl", u, "chest"))
            elseif elem == 2 then
                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_waterexplosion.mdl", u, "chest"))
            elseif elem == 3 then
                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_SasukeYh-41.mdl", u, "chest"))
            else
                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", u, "chest"))
            endif
            set u = null
            return true
        endmethod

        static method Loop_Kusanagi takes nothing returns nothing
            local thistype this
            local integer i = 0
            local boolean alive
            loop
                exitwhen i > MUI_Kus
                set this = m_Kus[i]
                set alive = SpellBoolCaster(c)
                if alive then
                    set r = r + 0.03
                    if r >= Kusanagi_StrikeInterval then
                        set r = 0
                        set alive = strike()
                    endif
                endif
                if not alive then
                    call finish()
                    set m_Kus[i] = m_Kus[MUI_Kus]
                    set MUI_Kus = MUI_Kus - 1
                    set i = i - 1
                    if MUI_Kus == -1 then
                        call ItemsTick_Off(17)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method Kusanagi_Start takes unit NewC, real tx, real ty returns nothing
            local thistype this = thistype.create()
            local string auraModel
            set MUI_Kus = MUI_Kus + 1
            set m_Kus[MUI_Kus] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set mult = KusanagiGrade_AtkMult
            if HasCachedItem(c, KusanagiFire_ID) > 0 then
                set elem = 1
                set source = KusanagiFire_ID
                set slash = "war3mapImported\\wos_KusanagiSlashFire.mdx"
                set auraModel = "war3mapImported\\wos_KusanagiAuraFire.mdx"
            elseif HasCachedItem(c, KusanagiWater_ID) > 0 then
                set elem = 2
                set source = KusanagiWater_ID
                set slash = "war3mapImported\\wos_BrightBlueSlash.mdx"
                set auraModel = "war3mapImported\\wos_KusanagiAuraWater.mdx"
            elseif HasCachedItem(c, KusanagiElectro_ID) > 0 then
                set elem = 3
                set source = KusanagiElectro_ID
                set slash = "war3mapImported\\wos_KusanagiSlashElectro.mdx"
                set auraModel = "war3mapImported\\wos_KusanagiAuraElectro.mdx"
            else
                set elem = 0
                set source = Kusanagi_ID
                set mult = Kusanagi_AtkMult
                set slash = "war3mapImported\\wos_KusanagiSlashWhite.mdx"
                set auraModel = "war3mapImported\\wos_KusanagiAuraWhite.mdx"
            endif
            set aura = AddSpecialEffectTarget(auraModel, c, "chest")
            set g = CreateGroup()
            call GroupEnumUnitsInRange(g, tx, ty, Kusanagi_Aoe, NoDecor_Cond)
            set r = Kusanagi_StrikeInterval // first dash on the next tick
            call StartSpellUnit2(c)
            if MUI_Kus == 0 then
                call ItemsTick_On(17)
            endif
        endmethod
    endstruct

    // Timed green strength: Hashirama Cells (+15, refresh) and Rhitta (+5 per hit, up to +35).
    private struct ItemsSpells_TimedStr
        private static integer array m_Str
        private static integer MUI_Str = -1
        unit c
        integer kind // 1 Hashirama, 2 Rhitta
        item indicator
        boolean indicatorPending
        integer stacks
        real left

        private static method find takes unit u, integer whichKind returns thistype
            local integer i = 0
            local thistype this
            loop
                exitwhen i > MUI_Str
                set this = m_Str[i]
                if c == u and kind == whichKind then
                    return this
                endif
                set i = i + 1
            endloop
            return 0
        endmethod

        private method setStacks takes integer newStacks returns nothing
            local integer n = 1
            if kind == 1 then
                if newStacks > 0 then
                    call UnitAddAbility(c, HashiramaCells_Str_ID)
                    call UnitMakeAbilityPermanent(c, true, HashiramaCells_Str_ID)
                    if indicator != null then
                        call SetItemCharges(indicator, 15)
                        set indicatorPending = true
                    endif
                else
                    call UnitRemoveAbility(c, HashiramaCells_Str_ID)
                    if indicator != null then
                        call SetItemCharges(indicator, 0)
                        set indicator = null
                        set indicatorPending = false
                    endif
                endif
            else
                loop
                    exitwhen n > Rhitta_StrMaxStacks
                    if n <= newStacks then
                        if GetUnitAbilityLevel(c, Rhitta_Str_ID[n]) == 0 then
                            call UnitAddAbility(c, Rhitta_Str_ID[n])
                            call UnitMakeAbilityPermanent(c, true, Rhitta_Str_ID[n])
                        endif
                    else
                        call UnitRemoveAbility(c, Rhitta_Str_ID[n])
                    endif
                    set n = n + 1
                endloop
            endif
            set stacks = newStacks
        endmethod

        static method Loop_TimedStr takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_Str
                set this = m_Str[i]
                // Warcraft consumes one charge after SPELL_EFFECT; repair once after that event.
                if indicatorPending then
                    set indicatorPending = false
                    if indicator != null then
                        call SetItemCharges(indicator, 15)
                    endif
                endif
                set left = left - 0.05
                if left <= 0 then
                    call setStacks(0)
                    set c = null
                    set m_Str[i] = m_Str[MUI_Str]
                    set MUI_Str = MUI_Str - 1
                    set i = i - 1
                    if MUI_Str == -1 then
                        call ItemsTick05_Off(2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method Add takes unit u, integer whichKind, integer addStacks, integer maxStacks, real duration returns nothing
            local thistype this = find(u, whichKind)
            if this == 0 then
                set this = thistype.create()
                set MUI_Str = MUI_Str + 1
                set m_Str[MUI_Str] = this
                set c = u
                set kind = whichKind
                set indicator = null
                set indicatorPending = false
                set stacks = 0
                if MUI_Str == 0 then
                    call ItemsTick05_On(2)
                endif
            endif
            if whichKind == 1 then
                if indicator != null then
                    call SetItemCharges(indicator, 0)
                endif
                set indicator = GetItemOfTypeFromUnitBJ(u, HashiramaCells_ID)
            endif
            call setStacks(IMinBJ(maxStacks, stacks + addStacks))
            set left = duration
        endmethod
    endstruct

    function Kusanagi_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_Kusanagi.Kusanagi_Start(c, x, y)
    endfunction

    function HashiramaCells_Start takes unit c returns nothing
        local real cost = GetUnitState(c, UNIT_STATE_LIFE) * (HashiramaCells_HpCost / 100)
        call SetUnitState(c, UNIT_STATE_LIFE, RMaxBJ(1, GetUnitState(c, UNIT_STATE_LIFE) - cost))
        call ItemsSpells_TimedStr.Add(c, 1, 1, 1, HashiramaCells_Duration)
        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_bashenan_juqi_2_2.mdl", GetUnitX(c), GetUnitY(c), 0.0, 0.5, 3.0, 155.0, 125, 255, 100, 255))
    endfunction

    // Hashirama Cells passive: allied heroes near the damaged owner heal 15% of the damage.
    function HashiramaCells_AllyHeal_Start takes unit td, real dmg returns nothing
        local group g = CreateGroup()
        local unit u
        local real heal = dmg * (HashiramaCells_AllyHeal / 100)
        call GroupEnumUnitsInRange(g, GetUnitX(td), GetUnitY(td), HashiramaCells_AllyAoe, NoDecor_Cond)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            call GroupRemoveUnit(g, u)
            if u != td and IsUnitType(u, UNIT_TYPE_HERO) and not IsUnitIllusion(u) and GetWidgetLife(u) > 0.405 and IsUnitAlly(u, GetOwningPlayer(td)) then
                call SetHpCurrent2(td, u, heal)
            endif
        endloop
        call DestroyGroup(g)
        set g = null
    endfunction

    function CoreDrill_Buff takes integer typedmg, integer level returns integer
        if typedmg == 1 then
            if level == 1 then
                return 'B052'
            elseif level == 2 then
                return 'B053'
            elseif level == 3 then
                return 'B054'
            elseif level == 4 then
                return 'B055'
            endif
            return 'B056'
        endif
        if level == 1 then
            return 'B04D'
        elseif level == 2 then
            return 'B04E'
        elseif level == 3 then
            return 'B04F'
        elseif level == 4 then
            return 'B050'
        endif
        return 'B051'
    endfunction

    // Shows the current stack count of one type on the holder; the previously shown
    // level's buff is removed first, so only one icon per type remains. Multi-hit
    // abilities do not recast it on every hit: same level within the gap is skipped
    // (the visual buff still has >= Duration - Gap left; stacks live in hs anyway).
    private function CoreDrill_ShowBuff takes unit c, integer typedmg, integer stacks, real now returns nothing
        local integer h = GetHandleId(c)
        local integer pid = GetPlayerId(GetOwningPlayer(c))
        local integer abi = CoreDrill_PhysAbi
        local unit d
        local integer shownKey = SH_CORE_DRILL_PHYS_SHOWN
        local integer castKey = SH_CORE_DRILL_PHYS_CAST
        local integer shown
        if typedmg == 1 then
            set abi = CoreDrill_MagAbi
            set shownKey = SH_CORE_DRILL_MAG_SHOWN
            set castKey = SH_CORE_DRILL_MAG_CAST
        endif
        set shown = LoadInteger(hs, h, shownKey)
        if shown == stacks and HaveSavedReal(hs, h, castKey) and now - LoadReal(hs, h, castKey) < CoreDrill_RecastGap then
            return
        endif
        if shown != 0 and shown != stacks then
            call UnitRemoveAbility(c, CoreDrill_Buff(typedmg, shown))
        endif
        call SaveInteger(hs, h, shownKey, stacks)
        call SaveReal(hs, h, castKey, now)
        if CoreDrill_Dummy[pid] == null or GetUnitTypeId(CoreDrill_Dummy[pid]) == 0 or GetWidgetLife(CoreDrill_Dummy[pid]) < 1 then
            set CoreDrill_Dummy[pid] = CreateUnit(Player(pid), 'h0C9', GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 0)
            set CoreDrill_DummyAbi[pid] = 0
        endif
        set d = CoreDrill_Dummy[pid]
        if CoreDrill_DummyAbi[pid] != abi then
            if CoreDrill_DummyAbi[pid] != 0 then
                call UnitRemoveAbility(d, CoreDrill_DummyAbi[pid])
            endif
            call UnitAddAbility(d, abi)
            set CoreDrill_DummyAbi[pid] = abi
        endif
        call SetUnitAbilityLevel(d, abi, stacks)
        call SetUnitFacing(d, GAngle(d, c) * bj_RADTODEG)
        call IssueTargetOrder(d, "innerfire", c)
        set d = null
    endfunction

    // Core Drill: physical (2) or magic (1) ability damage adds a stack of that type.
    // Expired stacks restart at 1; each new stack refreshes the duration of its type.
    function CoreDrill_AddStack takes unit c, integer typedmg returns nothing
        local integer h = GetHandleId(c)
        local integer stacksKey = SH_CORE_DRILL_PHYS
        local integer endKey = SH_CORE_DRILL_PHYS_END
        local integer stacks = 0
        local real now
        if not CoreDrill_ClockStarted then
            set CoreDrill_ClockStarted = true
            call TimerStart(CoreDrill_Clock, 1000000.0, false, null)
        endif
        set now = TimerGetElapsed(CoreDrill_Clock)
        if typedmg == 1 then
            set stacksKey = SH_CORE_DRILL_MAG
            set endKey = SH_CORE_DRILL_MAG_END
        endif
        if now < LoadReal(hs, h, endKey) then
            set stacks = LoadInteger(hs, h, stacksKey)
        endif
        set stacks = IMinBJ(CoreDrill_MaxStacks, stacks + 1)
        call SaveInteger(hs, h, stacksKey, stacks)
        call SaveReal(hs, h, endKey, now + CoreDrill_Duration)
        call CoreDrill_ShowBuff(c, typedmg, stacks, now)
    endfunction

    function RhittaStr_Add takes unit c, integer hits returns nothing
        if hits > 0 then
            call ItemsSpells_TimedStr.Add(c, 2, hits, Rhitta_StrMaxStacks, Rhitta_StrDuration)
        endif
    endfunction

    private struct ItemsSpells_FunnyBarrel
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

        static method Loop_FunnyBarrel takes nothing returns nothing
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
                            call DamageSource('I00G')
                            call dmgmag(c, u, dmg)
                            call DamageSource('I00G')
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
                        call ItemsTick_Off(0)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item1 == 0 then
                call ItemsTick_On(0)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TsuchikageHat
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

        static method Loop_TsuchikageHat takes nothing returns nothing
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
                    call DamageSource('I00P')
                    call dmgatk(c, td, dmg)
                    call SlowUnit(c,td,TsuchikageHat_Slow,TsuchikageHat_SlowTime)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl",GetUnitX(td),GetUnitY(td),1,1,1,1))
                    set c = null
                    set td = null
                    set e = null
                    set m_Item2[i] = m_Item2[ MUI_Item2]
                    set MUI_Item2 = MUI_Item2 - 1
                    if MUI_Item2 == -1 then
                        call ItemsTick_Off(1)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif
            set e = EffectSpawnScale("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 1.5)
            if MUI_Item2 == 0 then
                call ItemsTick_On(1)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_FunnyPresent
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

        static method Loop_FunnyPresent takes nothing returns nothing
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
                    call DamageSource('I00S')
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
                        call ItemsTick_Off(2)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item3 == 0 then
                call ItemsTick_On(2)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_NaofumiShield
        private static integer array m_Item4
        private static integer MUI_Item4 = -1
        unit c
        unit u
        real r
        effect e
        real rmax

         static method Loop_NaofumiShield takes nothing returns nothing
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
                    call SaveInteger(hs,GetHandleId(c),SH_NAOFUMI_SHIELD,0)
                    //call DestroyEffect(e)
                    set c = null
                    set u = null
                    set m_Item4[i] = m_Item4[ MUI_Item4]
                    set MUI_Item4 = MUI_Item4 - 1
                    if MUI_Item4 == -1 then
                        call ItemsTick_Off(3)
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
            call SaveInteger(hs,GetHandleId(c),SH_NAOFUMI_SHIELD,1)
           // set e = AddSpecialEffectTarget("war3mapImported\\wos_mei-torb.mdl", c, "origin")
            if MUI_Item4 == 0 then
                call ItemsTick_On(3)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RaijinWrath
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

        static method Loop_RaijinWrath takes nothing returns nothing
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
                            call DamageSource('I015')
                            call dmgmag(c, u, dmg)
                            call DamageSource('I015')
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
                        call ItemsTick05_Off(0)
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
            set rmax = 0.55 
            set k3 = 0
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            endif
            set k3 = 1
            endif

           call DestroyEffect(EffectSpawn("war3mapImported\\wos_lightningStomp.mdl",x,y,GetRandomReal(0,359),1.15,1.35,1))
            if MUI_Item5 == 0 then
                call ItemsTick05_On(0)
            endif
        endmethod

    endstruct
    private struct ItemsSpells_Rhitta
        private static integer array m_Item5
        private static integer MUI_Item5 = -1
        integer hits
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

        static method Loop_Rhitta takes nothing returns nothing
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
                            call DamageSource('I02L')
                            call dmgphys(c, u, dmg)
                            call DamageSource('I02L')
                            call ErzaPassive(c, u, 1)
                            set hits = hits + 1
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    call RhittaStr_Add(c, hits)
                    set hits = 0
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
                        call ItemsTick05_Off(1)
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
            set hits = 0
            set dmg = Rhitta_Damage * GetHeroStr(c,true) 
            set aoe = Rhitta_Aoe
            set dmg = SacredGearBooster(c,dmg)
            
            set r = 0
            set rmax = 0.5
            set k3 = 0
            set a = GAngle2(c,x,y)
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 0.01, 100)
            endif
            set k3 = 1  
            endif
           call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_item_rhita.mdl",x-650*Cos(a),y-650*Sin(a),a*bj_RADTODEG,0.8,4,100),0.5,255,255,255,1)
            if MUI_Item5 == 0 then
                call ItemsTick05_On(1)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_SharkTrail
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

        static method Loop_SharkTrail takes nothing returns nothing
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
                    call DamageSource('I016')
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
                    call DamageSource('I016')
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
                        call ItemsTick_Off(4)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_Cz14_1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 0.66)
            if MUI_Item6 == 0 then
                call ItemsTick_On(4)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RockleeWeight
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

        static method Loop_RockleeWeight takes nothing returns nothing
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
                        call DamageSource('I014')
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
                        call DamageSource('I014')
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
                        call ItemsTick_Off(5)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 200)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 200)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_AirEssence.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG+90, 1, 0.01, 100, 0.15, 0.01, 4*r5)
            if MUI_Item7 == 0 then
                call ItemsTick_On(5)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_Chogurt
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
        static method Loop_Chogurt takes nothing returns nothing
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
                        call SetHpCurrent2Quiet(c,u, dmg)
                        else
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_HealBlue.mdl",u,"origin"))
                        call SetMpCurrentQuiet(u, dmg)
                        endif
                        else                        
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_HealBlue.mdl",u,"origin"))
                        call SetMpCurrentQuiet(u, dmg)
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
                        call ItemsTick_Off(6)
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
                call ItemsTick_On(6)
            endif
        endmethod

    endstruct
    private struct ItemsSpells_HokageHatEvolved
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
        static method Loop_HokageHatEvolved takes nothing returns nothing
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
                        call ItemsTick_Off(7)
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
                call ItemsTick_On(7)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_EarthPower
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

        static method Loop_EarthPower takes nothing returns nothing
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
                    call DamageSource('I019')
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
                        call ItemsTick_Off(8)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",x, y, a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",x,y, a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_obr08 (698)2.mdl", x,y, a * bj_RADTODEG, 0.43, 0.01, 0, 0.15, 0.01, 0.5)
            if MUI_Item9 == 0 then
                call ItemsTick_On(8)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RedCup
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
        real grow

         static method Loop_RedCup takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Item10
                set this = m_Item10[i]
                if grow < RedCup_GrowTime then
                    set grow = RoundReal(grow + 0.03, 3)
                    if grow >= RedCup_GrowTime then
                        call BlzSetSpecialEffectTimeScale(e, 0.6*r5)
                        call BlzSetSpecialEffectTimeScale(e2, 0.75)
                    endif
                elseif  r <= rmax then
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
                        call DamageSource('I01S')
                        call ErzaPassive(c,u,2)
                        call DamageSource('I01S')
                        call dmgphys(c,u,dmg)
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
                        call ItemsTick_Off(9)
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
            set a = GAngle2(c, x, y)
            set x1 = GetUnitX(c)+100*Cos(a)
            set y1 = GetUnitY(c)+100*Sin(a)
            set u = null
            set grow = 0
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 250)
            else
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 250)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_watertornado.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0, 0.01, 100, RedCup_GrowTime, 0.01, 1.265*r5)
            set e2 = EffectSpawnScale("war3mapImported\\wos_Bubbles2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0, 0.01, 100, RedCup_GrowTime, 0.01, 9*r5)
            if MUI_Item10 == 0 then
                call ItemsTick_On(9)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_RedFlower
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

        static method Loop_RedFlower takes nothing returns nothing
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
                    call DamageSource('I01U')
                    call dmgmag(c, td, dmg)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call DamageSource('I01U')
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
                        call ItemsTick_Off(10)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e5 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            set e6 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e5 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            set e6 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item11 == 0 then
                call ItemsTick_On(10)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TuskBarrel
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

        static method Loop_TuskBarrel takes nothing returns nothing
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
                        call DamageSource('I01V')
                        call ErzaPassive(c,u,1)
                        call DamageSource('I01V')
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
                        call DamageSource('I01V')
                        call ErzaPassive(c,u,1)
                        call MUE(u,TuskBarrel_PushRange,rmax-r,GAngle3(x1,y1,u))
                        call DamageSource('I01V')
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
                        call ItemsTick_Off(11)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            set e = EffectSpawnScale("war3mapImported\\wos_jntxa_30a.mdl", GetUnitX(c)+110*Cos(a), GetUnitY(c)+110*Sin(a), a * bj_RADTODEG, 0.75, 0.01, 100, 0.3, 0.01, 1.15*r5)
            //set e2 = EffectSpawnScale("war3mapImported\\wos_Bubbles2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.75, 0.01, 100, 0.15, 0.01, 9*r5)
            if MUI_Item12 == 0 then
                call ItemsTick_On(11)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TurboNeko
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

        static method Loop_TurboNeko takes nothing returns nothing
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
                        call ItemsTick_Off(12)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TurboNeko_Start takes unit NewC, unit NewTd returns nothing
            local thistype this
            if GearCCProtected(NewTd) then
                return
            endif
            set this = thistype.create( )
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
            if GetUnitTypeId(c) == Bambietta_ID and IsUnitEnemy(td,GetOwningPlayer(c)) and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
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
                call ItemsTick_On(12)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_TsuchikageHatEvolve
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

         static method Loop_TsuchikageHatEvolve takes nothing returns nothing
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
                    call DamageSource('I02C')
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
                    if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
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
                        call ItemsTick_Off(13)
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
            set check2 = IMaxBJ(0, R2I(GetAttack(c) / TsuchikageHatEvolve_AttackPerBounce))
            set r2 = 0
            set r3 = 0
            set dmg = SacredGearBooster(c,dmg)
            
            call SetUnitAnimation(c, "attack")
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e3 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif
            set e = EffectSpawnScale("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 100, 0.15, 0.01, 1.5)
            set e2 = EffectSpawnScale("war3mapImported\\wos_Windwalk.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.01, 80, 0.15, 0.01, 1.5)
            if MUI_Item14 == 0 then
                call ItemsTick_On(13)
            endif
        endmethod

    endstruct
    private struct ItemsSpells_ShikiKnifeEvolved
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

        static method Loop_ShikiKnifeEvolved takes nothing returns nothing
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
                    call DamageSource('I042')
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
                        call ItemsTick_Off(14)
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
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then 
            call BambiettaG_Start(c)
            if  LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), SH_MORPH_T) >0 then 
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2red.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            else
            set e2 = EffectSpawn("war3mapimported\\wos_3yifu_2.mdx",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 100)
            endif
            set k3 = 1
            endif

            if MUI_Item3 == 0 then
                call ItemsTick_On(14)
            endif
        endmethod

    endstruct
private struct ItemsSpells_DeathNote
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

        static method Loop_DeathNote takes nothing returns nothing
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
                    
                    else
                    call ColorEffDummy3(e,0,255,255,255,0.5)
                    if GetUnitAbilityLevel(td,DeathNote_Buff_ID )>0 then 
                    call DamageSource('I044')
                    call dmgmag(c, td, dmg)
                   
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
                        call ItemsTick_Off(15)
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
            

            set e = null // wos_.mdl is not imported
            if MUI_Item9 == 0 then
                call ItemsTick_On(15)
            endif
        endmethod

    endstruct

    private struct ItemsSpells_SakuraSesshou
        private static integer array m_Item16
        private static integer MUI_Item16 = -1
        effect area
        unit c
        real x
        real y
        real r
        real r2
        real dmg
        real firstBonus
        group g
        effect e

        private static method IsInvisible takes unit u returns boolean
            return GetUnitAbilityLevel(u, 'Apiv') > 0 or GetUnitAbilityLevel(u, 'A03W') > 0 or GetUnitAbilityLevel(u, 'A0HZ') > 0 or GetUnitAbilityLevel(u, 'Binv') > 0 or GetUnitAbilityLevel(u, 'BOwk') > 0 or GetUnitAbilityLevel(u, 'Bshm') > 0
        endmethod

        // Случайный враг в зоне; невидимые юниты в приоритете.
        private method Strike takes nothing returns nothing
            local unit u
            local unit pick = null
            local unit pickInvis = null
            local integer n = 0
            local integer nInvis = 0
            call GroupClear(g)
            call GroupEnumUnitsInRange(g, x, y, SakuraSesshou_Aoe, NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                    if thistype.IsInvisible(u) then
                        set nInvis = nInvis + 1
                        if GetRandomInt(1, nInvis) == 1 then
                            set pickInvis = u
                        endif
                    else
                        set n = n + 1
                        if GetRandomInt(1, n) == 1 then
                            set pick = u
                        endif
                    endif
                endif
                call GroupRemoveUnit(g, u)
            endloop
            if pickInvis != null then
                set pick = pickInvis
            endif
            if pick != null then
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdx", GetUnitX(pick), GetUnitY(pick), GetRandomReal(0, 359), 1, 1, 0))
                call DamageSource('I03W')
                call dmgmag(c, pick, dmg + firstBonus)
            endif
            set firstBonus = 0
            set u = null
            set pick = null
            set pickInvis = null
        endmethod

        static method Loop_SakuraSesshou takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_Item16
                set this = m_Item16[i]
                if r < SakuraSesshou_Duration and GetUnitTypeId(c) != 0 then
                    set r = I2R(R2I((r + 0.03) * 1000.0 + 0.5)) / 1000.0
                    set r2 = I2R(R2I((r2 + 0.03) * 1000.0 + 0.5)) / 1000.0
                    if r2 >= SakuraSesshou_Interval then
                        set r2 = r2 - SakuraSesshou_Interval
                        call this.Strike()
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    set c = null
                    set e = null
                    set g = null
                    call DestroyEffect(area)
                    set area = null
                    set m_Item16[i] = m_Item16[MUI_Item16]
                    set MUI_Item16 = MUI_Item16 - 1
                    if MUI_Item16 == -1 then
                        call ItemsTick_Off(16)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method SakuraSesshou_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_Item16 = MUI_Item16 + 1
            set m_Item16[MUI_Item16] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set dmg = GetMainStatValue(c, true) * SakuraSesshou_Damage
            // Sacred Gear Booster: бонус только на первый тик, прок считается при касте (КД режет CastCheck).
            set firstBonus = SacredGearBooster(c, 0)
            set g = CreateGroup()
            set e = EffectSpawn("war3mapimported\\wos_file00001256.mdx", x, y, GetRandomReal(0, 359), 1, 1, 0)
            // Raiden R's circle is calibrated to 650 radius at scale 2.3.
            set area = EffectSpawn("war3mapImported\\wos_lightning circle.mdl", x, y, 0, 1, 2.3 * 1.05 * SakuraSesshou_Aoe / 650.0, 3) // +5%: the circle read slightly small
            if GetUnitTypeId(c) == Bambietta_ID and BlzGetUnitAbilityCooldownRemaining(c,BambiettaG_ID)==0 and GetHeroLevel(c)>=BambiettaG_Lvl_CD then
                call BambiettaG_Start(c)
                call BambiettaG2_Start(c,x,y)
            endif
            if MUI_Item16 == 0 then
                call ItemsTick_On(16)
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
    function SakuraSesshou_Start takes unit c, real x, real y returns nothing
        call ItemsSpells_SakuraSesshou.SakuraSesshou_Start( c, x, y )
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
    call DamageSource('I023')
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
    call DamageSource('I02S')
    call NextDmg(c,td,Tachikaze_DamageBase*GetMainStatValue(c,true),4,0.06)
    call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_dianjishanghai.mdx", td, "chest"))
    endif
    endfunction

    private struct ItemsTick05_Loop extends array
        static method Loop takes nothing returns nothing
            if ItemsTick05_Active[0] then
                call ItemsSpells_RaijinWrath.Loop_RaijinWrath()
            endif
            if ItemsTick05_Active[1] then
                call ItemsSpells_Rhitta.Loop_Rhitta()
            endif
            if ItemsTick05_Active[2] then
                call ItemsSpells_TimedStr.Loop_TimedStr()
            endif
        endmethod

        private static method onInit takes nothing returns nothing
            set ItemsTick05_Callback = function thistype.Loop
            set Rhitta_Str_ID[1] = 'A103'
            set Rhitta_Str_ID[2] = 'A104'
            set Rhitta_Str_ID[3] = 'A105'
            set Rhitta_Str_ID[4] = 'A106'
            set Rhitta_Str_ID[5] = 'A107'
            set Rhitta_Str_ID[6] = 'A10A'
            set Rhitta_Str_ID[7] = 'A10B'
        endmethod
    endstruct


    private struct ItemsTick_Loop extends array
        static method Loop takes nothing returns nothing
            if ItemsTick_Active[0] then
                call ItemsSpells_FunnyBarrel.Loop_FunnyBarrel()
            endif
            if ItemsTick_Active[1] then
                call ItemsSpells_TsuchikageHat.Loop_TsuchikageHat()
            endif
            if ItemsTick_Active[2] then
                call ItemsSpells_FunnyPresent.Loop_FunnyPresent()
            endif
            if ItemsTick_Active[3] then
                call ItemsSpells_NaofumiShield.Loop_NaofumiShield()
            endif
            if ItemsTick_Active[4] then
                call ItemsSpells_SharkTrail.Loop_SharkTrail()
            endif
            if ItemsTick_Active[5] then
                call ItemsSpells_RockleeWeight.Loop_RockleeWeight()
            endif
            if ItemsTick_Active[6] then
                call ItemsSpells_Chogurt.Loop_Chogurt()
            endif
            if ItemsTick_Active[7] then
                call ItemsSpells_HokageHatEvolved.Loop_HokageHatEvolved()
            endif
            if ItemsTick_Active[8] then
                call ItemsSpells_EarthPower.Loop_EarthPower()
            endif
            if ItemsTick_Active[9] then
                call ItemsSpells_RedCup.Loop_RedCup()
            endif
            if ItemsTick_Active[10] then
                call ItemsSpells_RedFlower.Loop_RedFlower()
            endif
            if ItemsTick_Active[11] then
                call ItemsSpells_TuskBarrel.Loop_TuskBarrel()
            endif
            if ItemsTick_Active[12] then
                call ItemsSpells_TurboNeko.Loop_TurboNeko()
            endif
            if ItemsTick_Active[13] then
                call ItemsSpells_TsuchikageHatEvolve.Loop_TsuchikageHatEvolve()
            endif
            if ItemsTick_Active[14] then
                call ItemsSpells_ShikiKnifeEvolved.Loop_ShikiKnifeEvolved()
            endif
            if ItemsTick_Active[15] then
                call ItemsSpells_DeathNote.Loop_DeathNote()
            endif
            if ItemsTick_Active[16] then
                call ItemsSpells_SakuraSesshou.Loop_SakuraSesshou()
            endif
            if ItemsTick_Active[17] then
                call ItemsSpells_Kusanagi.Loop_Kusanagi()
            endif
        endmethod

        private static method onInit takes nothing returns nothing
            set ItemsTick_Callback = function thistype.Loop
        endmethod
    endstruct

    // ================= Anime items (2026-10-27 / 10-28): effects, casts, hooks =================

    // Enemy debuff: a curse copy cast by a far dummy of the caster's owner (range 99999).
    function ItemsAnime_Curse takes unit c, unit u, integer abil returns nothing
        local unit d = CreateUnit(GetOwningPlayer(c), 'h0C9', GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 0)
        call UnitAddAbility(d, abil)
        call IssueTargetOrder(d, "curse", u)
        call MyRemoveUnit(d, 0.5)
        set d = null
    endfunction

    private function IsFairyTailHero takes unit u returns boolean
        local integer id = GetUnitTypeId(u)
        return id == Natsu_ID or id == Erza_ID or id == Laxus_ID
    endfunction

    // HP restoration bonus of Fairy Tail Emblem Evolved (added to GetHealAmp).
    function ItemsAnime_HealAmp takes unit u returns real
        if HasCachedItem(u, FairyTailEvolved_ID) > 0 and IsFairyTailHero(u) then
            return FairyTailEvolved_HeroHealAmp / 100.0
        endif
        return 0.0
    endfunction

    private struct ItemsAnimeEffect
        static constant integer KIND_SUKUNA = 1
        static constant integer KIND_SEAL = 2
        static constant integer KIND_COFFIN = 3
        static constant integer KIND_RETURN = 4
        static thistype array list
        static integer count = 0
        static timer clock = CreateTimer()
        integer kind
        unit c
        unit u
        real left
        real step
        real x
        real y
        integer round
        boolean armed
        real returnAt
        effect e
        effect e2

        static method Find takes integer kind, unit u returns thistype
            local integer i = 0
            loop
                exitwhen i >= count
                if list[i].kind == kind and list[i].u == u then
                    return list[i]
                endif
                set i = i + 1
            endloop
            return 0
        endmethod

        method Finish takes integer index returns nothing
            if .kind == KIND_SUKUNA then
                call UnitRemoveAbility(.u, SukunaFinger_Buff_ID)
            elseif .kind == KIND_SEAL then
                call UnitRemoveAbility(.u, FiveElementsSeal_Buff_ID)
                call UnitRemoveAbility(.u, FiveElementsSeal_LockBuff_ID)
            elseif .kind == KIND_COFFIN then
                call UnitRemoveAbility(.u, 'Avul')
                call UnitRemoveAbility(.u, IceCoffin_Buff_ID)
                call BlzPauseUnitEx(.u, false)
            elseif .kind == KIND_RETURN then
                call UnitRemoveAbility(.u, ReturnByDeath_Buff_ID)
            endif
            if .e != null then
                call DestroyEffect(.e)
            endif
            if .e2 != null then
                call DestroyEffect(.e2)
            endif
            set .e = null
            set .e2 = null
            set .c = null
            set .u = null
            set count = count - 1
            set list[index] = list[count]
            if count == 0 then
                call PauseTimer(clock)
            endif
            call .destroy()
        endmethod

        static method Tick takes nothing returns nothing
            local integer i = count - 1
            local thistype this
            loop
                exitwhen i < 0
                set this = list[i]
                set .left = .left - 0.10
                set .step = .step + 0.10
                if GetUnitTypeId(.u) == 0 or IsUnitType(.u, UNIT_TYPE_DEAD) then
                    call .Finish(i)
                elseif .kind == KIND_SUKUNA then
                    if .left <= 0.0 then
                        call .Finish(i)
                    else
                        // Not in DebuffClear; a dispel (e.g. Bunshin Scroll) only hides it until the next tick.
                        if GetUnitAbilityLevel(.u, SukunaFinger_Buff_ID) == 0 then
                            call ItemsAnime_Curse(.c, .u, SukunaFinger_Curse_ID)
                        endif
                        if .step >= 0.95 then
                            set .step = 0.0
                            call SlowUnit(.c, .u, SukunaFinger_Slow, 1)
                        endif
                    endif
                elseif .kind == KIND_SEAL then
                    if .left <= 0.0 then
                        call .Finish(i)
                    else
                        // The mana seal cannot be dispelled: a dispel only hides it until this tick.
                        if GetUnitAbilityLevel(.u, FiveElementsSeal_Buff_ID) == 0 then
                            call ItemsAnime_Curse(.c, .u, FiveElementsSeal_Curse_ID)
                        endif
                        if .armed and .step >= 0.3 and GetUnitAbilityLevel(.u, FiveElementsSeal_LockBuff_ID) == 0 then
                            // The lock was removed: it snaps shut once.
                            set .armed = false
                            call SilenceUnit(.c, .u, FiveElementsSeal_Silence)
                        endif
                    endif
                elseif .kind == KIND_COFFIN then
                    if .left > 0.0 and GetUnitAbilityLevel(.u, 'Avul') == 0 then
                        call UnitAddAbility(.u, 'Avul') // a spell ending its own pause may have taken it
                    endif
                    if .left <= 0.0 then
                        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", GetUnitX(.u), GetUnitY(.u)))
                        call .Finish(i)
                    endif
                elseif .kind == KIND_RETURN then
                    // A positive-buff dispel permanently cancels this pending return.
                    if .round != CurrentRound or GetUnitAbilityLevel(.u, ReturnByDeath_Buff_ID) == 0 then
                        call .Finish(i)
                    elseif TimerGetElapsed(HealRegenClock) >= .returnAt then
                        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(.u), GetUnitY(.u)))
                        call SetUnitPosition(.u, .x, .y)
                        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", .x, .y))
                        call MakeSound("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget")
                        call .Finish(i)
                    endif
                endif
                set i = i - 1
            endloop
        endmethod

        static method Add takes integer kind, unit c, unit u, real duration returns thistype
            local thistype this = thistype.create()
            set .kind = kind
            set .c = c
            set .u = u
            set .left = duration
            set .step = 0.0
            set .e = null
            set .e2 = null
            set .armed = false
            set list[count] = this
            set count = count + 1
            if count == 1 then
                call TimerStart(clock, 0.10, true, function thistype.Tick)
            endif
            return this
        endmethod

        // Seal: a hero ability cast while the lock is on silences once; the mana seal stays.
        static method OnHeroCast takes unit u returns nothing
            local integer i = 0
            loop
                exitwhen i >= count
                if list[i].kind == KIND_SEAL and list[i].u == u and list[i].armed then
                    set list[i].armed = false
                    call UnitRemoveAbility(u, FiveElementsSeal_LockBuff_ID)
                    call SilenceUnit(list[i].c, u, FiveElementsSeal_Silence)
                    return
                endif
                set i = i + 1
            endloop
        endmethod
    endstruct

    private function SukunaStart takes unit c, unit td returns nothing
        local ItemsAnimeEffect fx
        if td == null or not SpellBool(td) or not IsUnitEnemy(td, GetOwningPlayer(c)) or DebuffImmune_Start(td, 1) == 0 then
            return
        endif
        set fx = ItemsAnimeEffect.Find(ItemsAnimeEffect.KIND_SUKUNA, td)
        if fx == 0 then
            set fx = ItemsAnimeEffect.Add(ItemsAnimeEffect.KIND_SUKUNA, c, td, SukunaFinger_Duration)
        else
            set fx.c = c
            set fx.left = SukunaFinger_Duration
        endif
        call ItemsAnime_Curse(c, td, SukunaFinger_Curse_ID)
        call SlowUnit(c, td, SukunaFinger_Slow, 1)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", td, "chest"))
    endfunction

    private function SealStart takes unit c, unit td returns nothing
        local ItemsAnimeEffect fx
        if td == null or not SpellBool(td) or not IsUnitEnemy(td, GetOwningPlayer(c)) or DebuffImmune_Start(td, 1) == 0 then
            return
        endif
        set fx = ItemsAnimeEffect.Find(ItemsAnimeEffect.KIND_SEAL, td)
        if fx == 0 then
            set fx = ItemsAnimeEffect.Add(ItemsAnimeEffect.KIND_SEAL, c, td, FiveElementsSeal_Duration)
        else
            set fx.c = c
            set fx.left = FiveElementsSeal_Duration
            set fx.step = 0.0
        endif
        set fx.armed = true
        call ItemsAnime_Curse(c, td, FiveElementsSeal_Curse_ID)
        call ItemsAnime_Curse(c, td, FiveElementsSeal_LockCurse_ID)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl", td, "chest"))
    endfunction

    private function KairosekiStart takes unit c, unit td returns nothing
        if td == null or not SpellBool(td) or not IsUnitEnemy(td, GetOwningPlayer(c)) then
            return
        endif
        // Every positive buff (incl. buff-backed shields); hero states without a buff stay.
        call UnitRemoveBuffs(td, true, false)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", td, "origin"))
        if DebuffImmune_Start(td, 1) == 1 then
            call ItemsAnime_Curse(c, td, Kairoseki_Curse_ID)
        endif
    endfunction

    private function CoffinStart takes unit c returns nothing
        local ItemsAnimeEffect fx
        if ItemsAnimeEffect.Find(ItemsAnimeEffect.KIND_COFFIN, c) != 0 then
            return
        endif
        set fx = ItemsAnimeEffect.Add(ItemsAnimeEffect.KIND_COFFIN, c, c, IceCoffin_Duration)
        call IssueImmediateOrder(c, "stop")
        call BlzPauseUnitEx(c, true)
        call UnitAddAbility(c, 'Avul')
        call BuffUnit01(c, c, IceCoffin_BuffAbi_ID, "innerfire", 1)
        set fx.e = AddSpecialEffectTarget("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl", c, "origin")
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", GetUnitX(c), GetUnitY(c)))
    endfunction

    private function ReturnStart takes unit c returns nothing
        local ItemsAnimeEffect fx = ItemsAnimeEffect.Find(ItemsAnimeEffect.KIND_RETURN, c)
        if fx != 0 then
            // Recast: the new position replaces the old one.
            call DestroyEffect(fx.e)
            call DestroyEffect(fx.e2)
            set fx.left = ReturnByDeath_Delay
        else
            set fx = ItemsAnimeEffect.Add(ItemsAnimeEffect.KIND_RETURN, c, c, ReturnByDeath_Delay)
        endif
        call BuffUnit01(c, c, ReturnByDeath_BuffAbi_ID, "innerfire", 1)
        set fx.returnAt = TimerGetElapsed(HealRegenClock) + ReturnByDeath_Delay
        set fx.x = GetUnitX(c)
        set fx.y = GetUnitY(c)
        set fx.round = CurrentRound
        set fx.e = AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", fx.x, fx.y)
        set fx.e2 = AddSpecialEffectTarget("Abilities\\Spells\\Undead\\Curse\\CurseTarget.mdl", c, "overhead")
        call MyFrameBuffSlot(c, ReturnByDeath_Buff_ID, ReturnByDeath_Delay, "BTNItem_ReturnByDeath", false, ReturnByDeath_FrameSlot)
    endfunction

    // Item actives (CastAItems.ItemsCast).
    function ItemsAnime_Cast takes unit c, unit td, real x, real y, integer id returns nothing
        if id == SukunaFinger_Abi_ID then
            call SukunaStart(c, td)
        elseif id == FiveElementsSeal_Abi_ID then
            call SealStart(c, td)
        elseif id == Kairoseki_Abi_ID then
            call KairosekiStart(c, td)
        elseif id == Tekkai_Abi_ID then
            call BuffUnit01(c, c, Tekkai_BuffAbi_ID, "innerfire", 1)
            call MyRemoveEff(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl", c, "origin"), 4.0)
        elseif id == IceCoffin_Abi_ID then
            call CoffinStart(c)
        elseif id == ReturnByDeath_Abi_ID then
            call ReturnStart(c)
        elseif id == YataMirrorEvolved_Abi_ID then
            call BuffUnit01(c, c, YataMirrorEvolved_BuffAbi_ID, "innerfire", 1)
            call MyRemoveEff(AddSpecialEffectTarget("Abilities\\Spells\\Human\\ManaShield\\ManaShieldCaster.mdl", c, "origin"), 4.0)
        elseif id == PhilosopherEvolved_Abi_ID then
            call BuffUnit01(c, c, PhilosopherEvolved_BuffAbi_ID, "innerfire", 1)
            call MyRemoveEff(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", c, "origin"), 3.0)
        endif
    endfunction

    // Ice Coffin from an item hotkey while stunned or paused (the native button is disabled then).
    private function CanUseOnlyByKey takes unit u returns boolean
        return IsUnitPaused(u) or GetUnitAbilityLevel(u, 'BPSE') > 0 or GetUnitAbilityLevel(u, 'BSTN') > 0
    endfunction

    function ItemsAnime_ItemKey takes integer pid, integer slot returns nothing
        local unit u
        local item it
        if pid < 0 or pid >= 10 or slot < 0 or slot > 5 then
            return
        endif
        set u = Hero[pid]
        if u != null and not IsUnitType(u, UNIT_TYPE_DEAD) and CanUseOnlyByKey(u) then
            set it = UnitItemInSlot(u, slot)
            if GetItemTypeId(it) == IceCoffin_ID and BlzGetUnitAbilityCooldownRemaining(u, IceCoffin_Abi_ID) == 0.0 then
                call BlzStartUnitAbilityCooldown(u, IceCoffin_Abi_ID, BlzGetUnitAbilityCooldown(u, IceCoffin_Abi_ID, 0))
                call CoffinStart(u)
            endif
            set it = null
        endif
        set u = null
    endfunction

    private function OnItemKeyHook takes nothing returns boolean
        call ItemsAnime_ItemKey(WUI_ItemKeyPlayer, WUI_ItemKeySlot)
        return false
    endfunction

    // Stock inventory keys (Numpad 7 8 / 4 5 / 1 2) for players without custom item hotkeys.
    private function OnNumpadKey takes nothing returns boolean
        local oskeytype key = BlzGetTriggerPlayerKey()
        local integer slot = -1
        if key == OSKEY_NUMPAD7 then
            set slot = 0
        elseif key == OSKEY_NUMPAD8 then
            set slot = 1
        elseif key == OSKEY_NUMPAD4 then
            set slot = 2
        elseif key == OSKEY_NUMPAD5 then
            set slot = 3
        elseif key == OSKEY_NUMPAD1 then
            set slot = 4
        elseif key == OSKEY_NUMPAD2 then
            set slot = 5
        endif
        call ItemsAnime_ItemKey(GetPlayerId(GetTriggerPlayer()), slot)
        set key = null
        return false
    endfunction

    private function CoffinDigitKey takes integer digit returns oskeytype
        if digit == 1 then
            return OSKEY_1
        elseif digit == 2 then
            return OSKEY_2
        elseif digit == 3 then
            return OSKEY_3
        elseif digit == 4 then
            return OSKEY_4
        elseif digit == 5 then
            return OSKEY_5
        elseif digit == 6 then
            return OSKEY_6
        endif
        return null
    endfunction

    // Key that fires Ice Coffin for pid (null: none; the slot digit is skipped when another key uses it).
    function ItemsAnime_CoffinKey takes integer pid returns oskeytype
        if WUI_CoffinKey[pid] != null then
            return WUI_CoffinKey[pid]
        elseif ItemsAnime_CoffinDigit[pid] > 0 and WUI_CoffinKeyConflict(pid, CoffinDigitKey(ItemsAnime_CoffinDigit[pid]), I2S(ItemsAnime_CoffinDigit[pid])) == "" then
            return CoffinDigitKey(ItemsAnime_CoffinDigit[pid])
        endif
        return null
    endfunction

    function ItemsAnime_CoffinKeyLabel takes integer pid returns string
        if WUI_CoffinKey[pid] != null then
            return WUI_CoffinKeyName[pid]
        elseif ItemsAnime_CoffinKey(pid) != null then
            return I2S(ItemsAnime_CoffinDigit[pid])
        endif
        return "-"
    endfunction

    // Synced key: Ice Coffin from its own hotkey. Stunned/paused: scripted cast (ItemsAnime_ItemKey);
    // otherwise the native item use. Needs the item in the inventory and its cooldown ready.
    private function OnCoffinKey takes nothing returns boolean
        local integer pid = GetPlayerId(GetTriggerPlayer())
        local integer slot = 0
        local unit u
        local item it
        if not WUI_AcceptKeyDown() or pid < 0 or pid >= 10 then
            return false
        endif
        if BlzGetTriggerPlayerKey() != ItemsAnime_CoffinKey(pid) then
            return false
        endif
        set u = Hero[pid]
        if u == null or IsUnitType(u, UNIT_TYPE_DEAD) or BlzGetUnitAbilityCooldownRemaining(u, IceCoffin_Abi_ID) > 0.0 then
            set u = null
            return false
        endif
        loop
            exitwhen slot > 5
            set it = UnitItemInSlot(u, slot)
            if GetItemTypeId(it) == IceCoffin_ID then
                if CanUseOnlyByKey(u) then
                    call ItemsAnime_ItemKey(pid, slot)
                else
                    call UnitUseItem(u, it)
                endif
                exitwhen true
            endif
            set slot = slot + 1
        endloop
        set it = null
        set u = null
        return false
    endfunction

    // Default key = the digit of the slot the item landed in when picked up / bought.
    private function OnCoffinPickup takes nothing returns boolean
        local unit u = GetTriggerUnit()
        local item it = GetManipulatedItem()
        local integer pid = GetPlayerId(GetOwningPlayer(u))
        local integer slot = 0
        if GetItemTypeId(it) == IceCoffin_ID and pid >= 0 and pid < 10 and u == Hero[pid] then
            loop
                exitwhen slot > 5
                if UnitItemInSlot(u, slot) == it then
                    set ItemsAnime_CoffinDigit[pid] = slot + 1
                    call WUI_RegisterCoffinKey(pid, CoffinDigitKey(slot + 1))
                    exitwhen true
                endif
                set slot = slot + 1
            endloop
        endif
        set it = null
        set u = null
        return false
    endfunction

    private function OnCoffinChange takes nothing returns nothing
        call WUI_BeginCoffinCapture(GetTriggerPlayer())
        call WUI_ResetClickedButtonFocus()
    endfunction

    // -coffin <key> | -coffin default | -coffin
    private function OnCoffinChat takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local string arg = GetEventPlayerChatString()
        if SubString(arg, 0, 7) != "-coffin" then
            set p = null
            return
        endif
        set arg = StringCase(SubString(arg, 7, StringLength(arg)), true)
        loop
            exitwhen SubString(arg, 0, 1) != " "
            set arg = SubString(arg, 1, StringLength(arg))
        endloop
        loop
            exitwhen StringLength(arg) == 0 or SubString(arg, StringLength(arg) - 1, StringLength(arg)) != " "
            set arg = SubString(arg, 0, StringLength(arg) - 1)
        endloop
        if arg == "" then
            call DisplayTimedTextToPlayer(p, 0, 0, 6.00, WUI_GOLD + "Ice Coffin hotkey: " + ItemsAnime_CoffinKeyLabel(GetPlayerId(p)) + "|r|n" + WUI_TEXT + "-coffin <key> sets it (letter, digit, F1-F9), -coffin default = number of its slot. Or click CHANGE on the item.|r")
        elseif arg == "DEFAULT" or arg == "RESET" then
            call WUI_SetCoffinKey(p, "", true)
        else
            call WUI_SetCoffinKey(p, arg, true)
        endif
        set p = null
    endfunction

    // Shared 0.25 s clock, frame work local only: key badge in the corner of the Ice Coffin item
    // and CHANGE on its lower edge, for the own hero while it is the displayed unit.
    private function CoffinBadges takes nothing returns nothing
        local integer pid = GetPlayerId(GetLocalPlayer())
        local unit u = null
        local integer slot = 0
        local string label = null
        local string want
        if ItemsAnime_CoffinChange[0] == null then
            return
        endif
        if pid >= 0 and pid < 10 then
            set u = Hero[pid]
            static if LIBRARY_TasAbilityChargeBox then
                if TasAbilityChargeBox_Unit[pid] != u then
                    set u = null
                endif
            endif
        endif
        loop
            exitwhen slot > 5
            set want = ""
            if u != null and GetItemTypeId(UnitItemInSlot(u, slot)) == IceCoffin_ID and WUI_RangeNativeItemVisible(slot) then
                if label == null then
                    set label = ItemsAnime_CoffinKeyLabel(pid)
                endif
                set want = label
                if WUI_SlotKeyLabel(pid, 7 + slot) != "" then
                    // The custom item-slot key badge owns the top-right corner.
                    set want = label + "<"
                endif
            endif
            if want != ItemsAnime_CoffinShown[slot] then
                set ItemsAnime_CoffinShown[slot] = want
                call BlzFrameSetVisible(ItemsAnime_CoffinChange[slot], want != "")
                call BlzFrameSetVisible(ItemsAnime_CoffinHit[slot], want != "")
                if ItemsAnime_CoffinBox[slot] != null then
                    if want != "" then
                        call BlzFrameSetText(ItemsAnime_CoffinText[slot], WUI_GOLD + label + "|r")
                        call BlzFrameClearAllPoints(ItemsAnime_CoffinIcon[slot])
                        call BlzFrameClearAllPoints(ItemsAnime_CoffinText[slot])
                        if want == label then
                            call BlzFrameSetPoint(ItemsAnime_CoffinIcon[slot], FRAMEPOINT_TOPRIGHT, ItemsAnime_CoffinButton[slot], FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
                            call BlzFrameSetPoint(ItemsAnime_CoffinText[slot], FRAMEPOINT_TOPRIGHT, ItemsAnime_CoffinButton[slot], FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
                        else
                            call BlzFrameSetPoint(ItemsAnime_CoffinIcon[slot], FRAMEPOINT_TOPLEFT, ItemsAnime_CoffinButton[slot], FRAMEPOINT_TOPLEFT, -0.001, 0.001)
                            call BlzFrameSetPoint(ItemsAnime_CoffinText[slot], FRAMEPOINT_TOPLEFT, ItemsAnime_CoffinButton[slot], FRAMEPOINT_TOPLEFT, -0.001, 0.001)
                        endif
                    endif
                    call BlzFrameSetVisible(ItemsAnime_CoffinBox[slot], want != "")
                endif
            endif
            set slot = slot + 1
        endloop
        set u = null
    endfunction

    // Synchronous, once the HUD exists: 6 badges (charge-box look) on the item buttons + 6 CHANGE buttons.
    private function CoffinFrames takes nothing returns nothing
        local integer slot = 0
        local framehandle back
        local framehandle text
        local real size = 0.0135
        local real font = 0.009
        static if LIBRARY_TasAbilityChargeBox then
            set size = TasAbilityChargeBox_BOX_SIZE
            set font = TasAbilityChargeBox_FONT_SIZE
        endif
        set ItemsAnime_CoffinClick = CreateTrigger()
        call TriggerAddAction(ItemsAnime_CoffinClick, function OnCoffinChange)
        loop
            exitwhen slot > 5
            set ItemsAnime_CoffinButton[slot] = BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON, slot)
            if WUI_HasChargeDefinitions() and ItemsAnime_CoffinButton[slot] != null then
                set ItemsAnime_CoffinBox[slot] = BlzCreateSimpleFrame("TasAbilityChargeBox", ItemsAnime_CoffinButton[slot], 40 + slot)
                set ItemsAnime_CoffinText[slot] = BlzGetFrameByName("TasAbilityChargeBoxText", 40 + slot)
                set ItemsAnime_CoffinIcon[slot] = BlzGetFrameByName("TasAbilityChargeBoxTexture", 40 + slot)
                call BlzFrameClearAllPoints(ItemsAnime_CoffinIcon[slot])
                call BlzFrameSetPoint(ItemsAnime_CoffinIcon[slot], FRAMEPOINT_TOPRIGHT, ItemsAnime_CoffinButton[slot], FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
                call BlzFrameSetSize(ItemsAnime_CoffinIcon[slot], size, size)
                call BlzFrameSetTexture(ItemsAnime_CoffinIcon[slot], "UI\\WOS\\button.tga", 0, true)
                call BlzFrameClearAllPoints(ItemsAnime_CoffinText[slot])
                call BlzFrameSetPoint(ItemsAnime_CoffinText[slot], FRAMEPOINT_TOPRIGHT, ItemsAnime_CoffinButton[slot], FRAMEPOINT_TOPRIGHT, 0.001, 0.001)
                call BlzFrameSetSize(ItemsAnime_CoffinText[slot], size, size)
                call BlzFrameSetFont(ItemsAnime_CoffinText[slot], "Fonts/FRIZQT__.TTF", font, 0)
                call BlzFrameSetVisible(ItemsAnime_CoffinBox[slot], false)
            endif
            // CHANGE under the cell, in the gap between the item rows (below the screen-bottom row too).
            set ItemsAnime_CoffinHit[slot] = BlzCreateSimpleFrame("WOSQBHUDRemove", WUI_GetSimpleRoot(), 9320 + slot)
            call WUI_PlaceShift(ItemsAnime_CoffinHit[slot], WUI_ITEM_X + I2R(ModuloInteger(slot, 3) - 1) * WUI_ITEM_STEP_X, WUI_ITEM_Y - I2R(slot / 3) * WUI_ITEM_STEP_Y - WUI_ITEM_SIZE * 0.5 - 0.0040, 0.0260, 0.0062)
            call BlzFrameSetLevel(ItemsAnime_CoffinHit[slot], 55)
            call BlzTriggerRegisterFrameEvent(ItemsAnime_CoffinClick, ItemsAnime_CoffinHit[slot], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetVisible(ItemsAnime_CoffinHit[slot], false)
            set ItemsAnime_CoffinChange[slot] = BlzCreateFrameByType("BUTTON", "WOSCoffinChange", WUI_GetRoot(), "", slot)
            call WUI_PlaceShift(ItemsAnime_CoffinChange[slot], WUI_ITEM_X + I2R(ModuloInteger(slot, 3) - 1) * WUI_ITEM_STEP_X, WUI_ITEM_Y - I2R(slot / 3) * WUI_ITEM_STEP_Y - WUI_ITEM_SIZE * 0.5 - 0.0040, 0.0260, 0.0062)
            call BlzFrameSetLevel(ItemsAnime_CoffinChange[slot], 46)
            set back = BlzCreateFrameByType("BACKDROP", "WOSCoffinChangeBack", ItemsAnime_CoffinChange[slot], "", slot)
            call BlzFrameSetAllPoints(back, ItemsAnime_CoffinChange[slot])
            call BlzFrameSetTexture(back, WUI_FILL_NORMAL, 0, true)
            call BlzFrameSetAlpha(back, 225)
            call BlzFrameSetEnable(back, false)
            set text = BlzCreateFrameByType("TEXT", "WOSCoffinChangeText", ItemsAnime_CoffinChange[slot], "", slot)
            call BlzFrameSetAllPoints(text, ItemsAnime_CoffinChange[slot])
            call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
            call BlzFrameSetScale(text, 0.55)
            call BlzFrameSetText(text, "|cffe8e8e8CHANGE|r")
            call BlzFrameSetEnable(text, false)
            call WUI_Tooltip(ItemsAnime_CoffinChange[slot], "|cffd5b876ICE COFFIN HOTKEY|r|nClick, then press a letter, digit or F1-F9.|nBackspace: number of its slot, Esc: keep.|nChat: -coffin <key> / -coffin default.|nWorks while stunned or paused; Save Keys keeps it.")
            // The face only draws: input goes to the SIMPLEBUTTON below it.
            call BlzFrameSetEnable(ItemsAnime_CoffinChange[slot], false)
            call BlzFrameSetVisible(ItemsAnime_CoffinChange[slot], false)
            set ItemsAnime_CoffinShown[slot] = "?"
            set slot = slot + 1
        endloop
        set ItemsAnime_CoffinBadgeClock = CreateTimer()
        call TimerStart(ItemsAnime_CoffinBadgeClock, 0.25, true, function CoffinBadges)
        set back = null
        set text = null
    endfunction

    function ItemsAnime_OnHeroCast takes unit c returns nothing
        call ItemsAnimeEffect.OnHeroCast(c)
    endfunction

    // Applied damage (DmgSys, before phase 3 listeners).
    function ItemsAnime_FinalDamage takes unit c, unit td, real dmg, integer typedmg, boolean isAttack returns real
        local integer h
        local real now
        local real life
        if dmg <= 0.0 then
            return dmg
        endif
        if ItemsAnimeEffect.Find(ItemsAnimeEffect.KIND_COFFIN, td) != 0 then
            return 0.0
        endif
        if c != null and GetUnitAbilityLevel(c, Kairoseki_Buff_ID) > 0 then
            set dmg = dmg * (1.0 - Kairoseki_DamageReduce / 100.0)
        endif
        // Tekkai: every basic attack, whatever its damage type (magic attacks, Starrk's Cero).
        if (typedmg == 0 or isAttack) and GetUnitAbilityLevel(td, Tekkai_Buff_ID) > 0 then
            set dmg = ApplyFullDamageShield(c, td, dmg, dmg, typedmg, DAMAGE_SHIELD_TYPE_ALL)
        endif
        if dmg > 0.0 and HasCachedItem(td, NaofumiShieldEvolved_ID) > 0 then
            if LoadInteger(hs, GetHandleId(td), SH_ItemsAnime_NAOFUMI_SHIELD) == 1 then
                set dmg = RMaxBJ(0.0, dmg - NaofumiShieldEvolved_BlockActive)
            else
                set dmg = RMaxBJ(0.0, dmg - NaofumiShieldEvolved_Block)
            endif
        endif
        if dmg > 0.0 and HasCachedItem(td, WillOfD_ID) > 0 and IsUnitType(td, UNIT_TYPE_HERO) and not IsUnitIllusion(td) then
            set h = GetHandleId(td)
            set now = TimerGetElapsed(HealRegenClock)
            set life = GetWidgetLife(td)
            if now < LoadReal(hs, h, SH_WILL_OF_D_END) then
                set dmg = RMinBJ(dmg, RMaxBJ(0.0, life - 1.0))
            elseif dmg >= life - 1.0 and BlzGetUnitAbilityCooldownRemaining(td, WillOfD_CD_ID) == 0.0 then
                call SaveReal(hs, h, SH_WILL_OF_D_END, now + WillOfD_Duration)
                call BlzStartUnitAbilityCooldown(td, WillOfD_CD_ID, WillOfD_CD)
                call BuffUnit01(td, td, WillOfD_BuffAbi_ID, "innerfire", 1)
                call MyRemoveEff(AddSpecialEffectTarget("Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl", td, "origin"), WillOfD_Duration)
                set dmg = RMaxBJ(0.0, life - 1.0)
            endif
        endif
        return dmg
    endfunction

    // Basic attack that hit an enemy (DmgSys).
    function ItemsAnime_OnAttack takes unit c, unit td returns nothing
        if c != null and td != null and not IsUnitIllusion(c) and not IsUnitIllusion(td) and IsUnitEnemy(td, GetOwningPlayer(c)) and GetUnitAbilityLevel(td, Tekkai_Buff_ID) == 0 and HasCachedItem(c, Samehada_ID) > 0 then
            call SetMpCurrentQuiet(c, GetUnitState(c, UNIT_STATE_MAX_MANA) * Samehada_ManaRestore / 100.0)
            call SetMpCurrent(td, -GetUnitState(td, UNIT_STATE_MAX_MANA) * Samehada_ManaDrain / 100.0)
        endif
    endfunction

    // Will of D.: one cooldown reset at the end of every round.
    function ItemsAnime_RoundEnd takes nothing returns nothing
        local integer i = 0
        loop
            exitwhen i >= 10
            if Hero[i] != null and HasCachedItem(Hero[i], WillOfD_ID) > 0 then
                call BlzEndUnitAbilityCooldown(Hero[i], WillOfD_CD_ID)
                call SaveReal(hs, GetHandleId(Hero[i]), SH_WILL_OF_D_END, 0.0)
            endif
            set i = i + 1
        endloop
    endfunction

    private function ItemsAnime_Init takes nothing returns nothing
        local integer pid = 0
        local trigger t
        local trigger chat
        set WUI_ItemKeyHook = CreateTrigger()
        call TriggerAddCondition(WUI_ItemKeyHook, Condition(function OnItemKeyHook))
        set ItemsAnime_NumpadKeys = CreateTrigger()
        loop
            exitwhen pid >= 10
            call BlzTriggerRegisterPlayerKeyEvent(ItemsAnime_NumpadKeys, Player(pid), OSKEY_NUMPAD7, 0, true)
            call BlzTriggerRegisterPlayerKeyEvent(ItemsAnime_NumpadKeys, Player(pid), OSKEY_NUMPAD8, 0, true)
            call BlzTriggerRegisterPlayerKeyEvent(ItemsAnime_NumpadKeys, Player(pid), OSKEY_NUMPAD4, 0, true)
            call BlzTriggerRegisterPlayerKeyEvent(ItemsAnime_NumpadKeys, Player(pid), OSKEY_NUMPAD5, 0, true)
            call BlzTriggerRegisterPlayerKeyEvent(ItemsAnime_NumpadKeys, Player(pid), OSKEY_NUMPAD1, 0, true)
            call BlzTriggerRegisterPlayerKeyEvent(ItemsAnime_NumpadKeys, Player(pid), OSKEY_NUMPAD2, 0, true)
            set pid = pid + 1
        endloop
        call TriggerAddCondition(ItemsAnime_NumpadKeys, Condition(function OnNumpadKey))
        call TriggerAddCondition(WUI_CoffinKeyTrigger, Condition(function OnCoffinKey))
        set t = CreateTrigger()
        call TriggerAddCondition(t, Condition(function OnCoffinPickup))
        set chat = CreateTrigger()
        call TriggerAddAction(chat, function OnCoffinChat)
        set pid = 0
        loop
            exitwhen pid >= 10
            call TriggerRegisterPlayerUnitEvent(t, Player(pid), EVENT_PLAYER_UNIT_PICKUP_ITEM, null)
            call TriggerRegisterPlayerChatEvent(chat, Player(pid), "-coffin", false)
            set pid = pid + 1
        endloop
        call WUI_OnReady(function CoffinFrames)
        set t = null
        set chat = null
    endfunction

    // ================= Elemental actives (2026-10-28b): casts, marks, reactions =================
    // Hooks: CastAItems (ItemsElements_Cast), DmgSys (ItemsElements_OnDamage), CastCheck
    // (ItemsElements_OnHeroCast). Sacred Gear Booster is added once per cast to its first damage.
    private function ElemStr takes unit c returns real
        return I2R(GetHeroStr(c, true))
    endfunction

    private function ElemAgi takes unit c returns real
        return I2R(GetHeroAgi(c, true))
    endfunction

    private function ElemInt takes unit c returns real
        return I2R(GetHeroInt(c, true))
    endfunction

    private function ElemValid takes unit c, unit u returns boolean
        return u != null and GetUnitTypeId(u) != 0 and SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c))
    endfunction

    private function ElemAlive takes unit u returns boolean
        return u != null and GetUnitTypeId(u) != 0 and not IsUnitType(u, UNIT_TYPE_DEAD)
    endfunction

    // One damage instance credited to the item, then its element. Returns the HP actually lost.
    private function ElemHit takes unit c, unit u, integer itemId, real dmg, boolean magic, integer element returns real
        local real life = GetWidgetLife(u)
        call DamageSource(itemId)
        if magic then
            call dmgmag(c, u, dmg)
        else
            call dmgphys(c, u, dmg)
        endif
        if element > 0 then
            call DamageSource(itemId)
            call ErzaPassive(c, u, element)
        endif
        return RMaxBJ(0.0, life - GetWidgetLife(u))
    endfunction

    private function ElemFx takes string model, real x, real y, real scale returns nothing
        call DestroyEffect(EffectSpawn(model, x, y, GetRandomReal(0, 359), 1, scale, 0))
    endfunction

    // Distance to the finite thread segment, including a radius around its endpoints.
    private function ElemNearSegment takes real px, real py, real ax, real ay, real bx, real by, real radius returns boolean
        local real dx = bx - ax
        local real dy = by - ay
        local real length2 = dx * dx + dy * dy
        local real t = 0.0
        if length2 > 0.0 then
            set t = RMaxBJ(0.0, RMinBJ(1.0, ((px - ax) * dx + (py - ay) * dy) / length2))
        endif
        set dx = px - ax - t * dx
        set dy = py - ay - t * dy
        return dx * dx + dy * dy <= radius * radius
    endfunction

    // One smooth displacement step; walkable ground inside the playable map only.
    private function ElemStep takes unit u, real dx, real dy returns boolean
        local real nx = GetUnitX(u) + dx
        local real ny = GetUnitY(u) + dy
        if IsUnitType(u, UNIT_TYPE_STRUCTURE) or IsTerrainPathable(nx, ny, PATHING_TYPE_WALKABILITY) then
            return false
        endif
        if nx <= GetRectMinX(bj_mapInitialPlayableArea) or nx >= GetRectMaxX(bj_mapInitialPlayableArea) or ny <= GetRectMinY(bj_mapInitialPlayableArea) or ny >= GetRectMaxY(bj_mapInitialPlayableArea) then
            return false
        endif
        call SetUnitX(u, nx)
        call SetUnitY(u, ny)
        return true
    endfunction

    struct ItemsElementsFx
        static constant real DT = 0.03
        // movers / damage carriers
        static constant integer PROJ = 1
        static constant integer MOVE = 2
        static constant integer DOT = 3
        static constant integer ANCHOR = 4
        static constant integer STORM = 5
        static constant integer RUNE = 6
        static constant integer SPIRAL = 7
        static constant integer ASHEN = 8
        static constant integer WAVE = 9
        static constant integer STRIKES = 10
        static constant integer COILSHOT = 11
        // marks
        static constant integer EMBER = 20
        static constant integer VERDICT = 21
        static constant integer BASTION = 22
        static constant integer CINDER = 23
        static constant integer MIRROR = 24
        static constant integer VOLT = 25
        static constant integer PHOENIX = 26
        static constant integer SIREN = 27
        static constant integer COIL = 28
        static thistype array list
        static integer count = 0
        static timer clock = CreateTimer()
        static code tickCode = null
        integer kind
        integer src // item id (damage source / behaviour of PROJ and DOT)
        integer phase
        integer charges
        unit c
        unit u
        unit u2
        real left
        real x
        real y
        real tx
        real ty
        real vx
        real vy
        real dmg
        real dmg2
        real step
        real next
        group g
        group g2
        effect e
        effect e2
        effect e3
        lightning ln

        method finish takes nothing returns nothing
            if .e != null then
                call DestroyEffect(.e)
            endif
            if .e2 != null then
                call DestroyEffect(.e2)
            endif
            if .e3 != null then
                call DestroyEffect(.e3)
            endif
            if .ln != null then
                call DestroyLightning(.ln)
            endif
            if .g != null then
                call DestroyGroup(.g)
            endif
            if .g2 != null then
                call DestroyGroup(.g2)
            endif
            set .e = null
            set .e2 = null
            set .e3 = null
            set .ln = null
            set .g = null
            set .g2 = null
            set .c = null
            set .u = null
            set .u2 = null
            call .destroy()
        endmethod

        static method Add takes integer kind, integer src, unit c, unit u, real duration returns thistype
            local thistype this = thistype.create()
            set .kind = kind
            set .src = src
            set .phase = 0
            set .charges = 0
            set .c = c
            set .u = u
            set .u2 = null
            set .left = duration
            set .x = 0.0
            set .y = 0.0
            set .tx = 0.0
            set .ty = 0.0
            set .vx = 0.0
            set .vy = 0.0
            set .dmg = 0.0
            set .dmg2 = 0.0
            set .step = 0.0
            set .next = 0.0
            set .g = null
            set .g2 = null
            set .e = null
            set .e2 = null
            set .e3 = null
            set .ln = null
            set list[count] = this
            set count = count + 1
            if count == 1 then
                call TimerStart(clock, DT, true, tickCode)
            endif
            return this
        endmethod

        static method Find takes integer kind, unit c, unit u returns thistype
            local integer i = 0
            loop
                exitwhen i >= count
                if list[i].kind == kind and list[i].left > 0.0 and (c == null or list[i].c == c) and (u == null or list[i].u == u) then
                    return list[i]
                endif
                set i = i + 1
            endloop
            return 0
        endmethod

        // A repeat cast refreshes the mark on the same target instead of stacking a second one.
        static method Mark takes integer kind, integer src, unit c, unit u, real duration, string model returns thistype
            local thistype this = Find(kind, c, u)
            if this == 0 then
                set this = Add(kind, src, c, u, duration)
                if model != "" then
                    set .e = AddSpecialEffectTarget(model, u, "overhead")
                endif
            else
                set .left = duration
                set .charges = 0
            endif
            return this
        endmethod

        // Smooth push / pull of u over `time`.
        static method Push takes unit c, unit u, real angle, real dist, real time returns nothing
            local thistype this
            local integer ticks = IMaxBJ(1, R2I(time / DT + 0.5))
            if dist <= 0.0 or not ElemAlive(u) then
                return
            endif
            set this = Add(MOVE, 0, c, u, time + DT)
            set .charges = ticks
            set .vx = dist / I2R(ticks) * Cos(angle)
            set .vy = dist / I2R(ticks) * Sin(angle)
        endmethod

        static method Burn takes integer src, unit c, unit u, real total, integer pulses, real interval, boolean magic returns thistype
            local thistype this = Add(DOT, src, c, u, I2R(pulses) * interval + 0.1)
            set .charges = pulses
            set .dmg = total / I2R(pulses)
            set .step = interval
            set .next = interval
            set .phase = IntegerTertiaryOp(magic, 1, 0)
            return this
        endmethod

        static method Missile takes integer src, unit c, real fromX, real fromY, unit u, real speed, string model, real dmg returns thistype
            local thistype this = Add(PROJ, src, c, u, 4.0)
            set .x = fromX
            set .y = fromY
            set .vx = speed * DT
            set .dmg = dmg
            set .e = EffectSpawn(model, fromX, fromY, Atan2(GetUnitY(u) - fromY, GetUnitX(u) - fromX) * bj_RADTODEG, 1, 1.0, 70)
            if src == Emberbreaker_ID then
                call BlzSetSpecialEffectScale(.e, 2.0)
                call BlzSetSpecialEffectZ(.e, BlzGetLocalSpecialEffectZ(.e) + 100.0)
            elseif src == VoltThread_ID then
                call BlzSetSpecialEffectZ(.e, BlzGetLocalSpecialEffectZ(.e) + 80.0) // 70 + 80 = 150
            elseif src == CinderFang_ID then
                call BlzSetSpecialEffectZ(.e, BlzGetLocalSpecialEffectZ(.e) + 150.0)
            elseif src == MirrorTide_ID then
                call BlzSetSpecialEffectScale(.e, MirrorTide_ProjectileScale)
            elseif src == SirenTear_ID then
                call BlzSetSpecialEffectScale(.e, 2.0)
            endif
            return this
        endmethod

        // Damage pulse on enemies in range; heroes hit are remembered in .g (Bastion charges, Coil chain).
        method Pulse takes real radius, real dmg, boolean magic, integer element, integer slow returns nothing
            local unit v
            call GroupEnumUnitsInRange(ItemsElements_Group, .x, .y, radius, NoDecor_Cond)
            loop
                set v = FirstOfGroup(ItemsElements_Group)
                exitwhen v == null
                call GroupRemoveUnit(ItemsElements_Group, v)
                if ElemValid(.c, v) then
                    call ElemHit(.c, v, .src, dmg, magic, element)
                    if slow > 0 then
                        call SlowUnit(.c, v, slow, 1)
                    endif
                    if .g != null and IsUnitType(v, UNIT_TYPE_HERO) and not IsUnitIllusion(v) then
                        call GroupAddUnit(.g, v)
                    endif
                endif
            endloop
        endmethod

        // Drag enemies in range towards (x, y); `spin` adds a sideways (spiral) component.
        method Drag takes real radius, real inward, real spin returns nothing
            local unit v
            local real a
            local real d
            local real m
            call GroupEnumUnitsInRange(ItemsElements_Group, .x, .y, radius, NoDecor_Cond)
            loop
                set v = FirstOfGroup(ItemsElements_Group)
                exitwhen v == null
                call GroupRemoveUnit(ItemsElements_Group, v)
                if ElemValid(.c, v) then
                    set a = Atan2(.y - GetUnitY(v), .x - GetUnitX(v))
                    set d = SquareRoot((.x - GetUnitX(v)) * (.x - GetUnitX(v)) + (.y - GetUnitY(v)) * (.y - GetUnitY(v)))
                    set m = RMinBJ(inward * DT, RMaxBJ(0.0, d - 60.0))
                    call ElemStep(v, m * Cos(a) + spin * DT * Cos(a + bj_PI * 0.5), m * Sin(a) + spin * DT * Sin(a + bj_PI * 0.5))
                endif
            endloop
        endmethod

        // A shuriken / wave at (px, py) hits enemies not yet in `hit` (and not in `skip`).
        method Sweep takes real px, real py, real radius, group hit, group skip, real dmg, boolean magic, integer element, real push, integer slow returns nothing
            local unit v
            call GroupEnumUnitsInRange(ItemsElements_Group, px, py, radius, NoDecor_Cond)
            loop
                set v = FirstOfGroup(ItemsElements_Group)
                exitwhen v == null
                call GroupRemoveUnit(ItemsElements_Group, v)
                if ElemValid(.c, v) and not IsUnitInGroup(v, hit) and (skip == null or not IsUnitInGroup(v, skip)) then
                    call GroupAddUnit(hit, v)
                    call ElemHit(.c, v, .src, dmg, magic, element)
                    if slow > 0 then
                        call SlowUnit(.c, v, slow, ConstellationCoil_SlowDuration)
                    endif
                    if push > 0.0 then
                        call thistype.Push(.c, v, Atan2(.vy, .vx), push, 0.3)
                    endif
                endif
            endloop
        endmethod

        method ThreadPulse takes nothing returns nothing
            local real ax = GetUnitX(.c)
            local real ay = GetUnitY(.c)
            local real bx = GetUnitX(.u)
            local real by = GetUnitY(.u)
            local real dx = bx - ax
            local real dy = by - ay
            local unit v
            call GroupEnumUnitsInRange(.g, (ax + bx) * 0.5, (ay + by) * 0.5, SquareRoot(dx * dx + dy * dy) * 0.5 + VoltThread_LineRadius, NoDecor_Cond)
            loop
                set v = FirstOfGroup(.g)
                exitwhen v == null
                call GroupRemoveUnit(.g, v)
                if v != .u and ElemValid(.c, v) and ElemNearSegment(GetUnitX(v), GetUnitY(v), ax, ay, bx, by, VoltThread_LineRadius) then
                    call ElemHit(.c, v, .src, .dmg, true, 0)
                endif
            endloop
            set v = null
        endmethod

        // Homing projectile reached its target.
        method Arrive takes nothing returns nothing
            local thistype m
            local real dealt
            local real best = 250000.0
            local real d
            local unit v
            local unit near = null
            if .src == Emberbreaker_ID then
                call ElemFx("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(.u), GetUnitY(.u), 1.0)
                call ElemHit(.c, .u, .src, .dmg, false, 1)
                call thistype.Push(.c, .u, Atan2(GetUnitY(.u) - GetUnitY(.c), GetUnitX(.u) - GetUnitX(.c)), Emberbreaker_Knock, 0.25)
                call thistype.Burn(.src, .c, .u, Emberbreaker_Burn * ElemStr(.c), 4, 0.5, true)
                set m = thistype.Mark(EMBER, .src, .c, .u, 3.0, "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl")
                set m.dmg2 = Emberbreaker_Retaliate * ElemStr(.c)
            elseif .src == LeviathanGrasp_ID then
                call ElemFx("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl", GetUnitX(.u), GetUnitY(.u), 2.4)
                set dealt = ElemHit(.c, .u, .src, .dmg, false, 2)
                // The claw drags the target in, then squeezes (heal on both hits, capped per cast).
                set m = thistype.Burn(.src, .c, .u, LeviathanGrasp_Squeeze * ElemStr(.c), 1, 0.5, false)
                set m.dmg2 = LeviathanGrasp_HealCap * ElemStr(.c)
                set m.phase = 2
                set d = SquareRoot((GetUnitX(.c) - GetUnitX(.u)) * (GetUnitX(.c) - GetUnitX(.u)) + (GetUnitY(.c) - GetUnitY(.u)) * (GetUnitY(.c) - GetUnitY(.u)))
                call thistype.Push(.c, .u, Atan2(GetUnitY(.c) - GetUnitY(.u), GetUnitX(.c) - GetUnitX(.u)), RMinBJ(LeviathanGrasp_Pull, d - 120.0), 0.5)
                set dealt = RMinBJ(dealt * LeviathanGrasp_Heal / 100.0, m.dmg2)
                if dealt > 0.0 then
                    set m.dmg2 = m.dmg2 - dealt
                    call SetHpCurrent2(.c, .c, dealt)
                endif
                set m.e = AddSpecialEffectTarget("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl", .u, "origin")
            elseif .src == CinderFang_ID and .phase == 0 then
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", .u, "chest"))
                call ElemHit(.c, .u, .src, .dmg, false, 1)
                set m = thistype.Mark(CINDER, .src, .c, .u, 3.0, "Environment\\SmallBuildingFire\\SmallBuildingFire2.mdl")
                set m.dmg2 = CinderFang_Bonus * ElemAgi(.c)
                // Ricochet to the nearest other enemy.
                call GroupEnumUnitsInRange(ItemsElements_Group, GetUnitX(.u), GetUnitY(.u), 500, NoDecor_Cond)
                loop
                    set v = FirstOfGroup(ItemsElements_Group)
                    exitwhen v == null
                    call GroupRemoveUnit(ItemsElements_Group, v)
                    if v != .u and ElemValid(.c, v) then
                        set d = (GetUnitX(v) - GetUnitX(.u)) * (GetUnitX(v) - GetUnitX(.u)) + (GetUnitY(v) - GetUnitY(.u)) * (GetUnitY(v) - GetUnitY(.u))
                        if d < best then
                            set best = d
                            set near = v
                        endif
                    endif
                endloop
                if near != null then
                    set m = thistype.Missile(.src, .c, GetUnitX(.u), GetUnitY(.u), near, 2200, "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", CinderFang_Ricochet * ElemAgi(.c))
                    set m.phase = 1
                endif
            elseif .src == CinderFang_ID then
                call ElemHit(.c, .u, .src, .dmg, false, 1)
            elseif .src == MirrorTide_ID then
                call ElemFx("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl", GetUnitX(.u), GetUnitY(.u), 2.0)
                call ElemHit(.c, .u, .src, .dmg, false, 0)
            elseif .src == VoltThread_ID then
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\Bolt\\BoltImpact.mdl", .u, "chest"))
                call ElemHit(.c, .u, .src, .dmg, true, 3)
                set m = thistype.Mark(VOLT, .src, .c, .u, 3.0, "")
                set m.dmg2 = VoltThread_Bonus * ElemAgi(.c)
                set m.dmg = VoltThread_LineDamage * ElemAgi(.c)
                set m.next = 1.0
                if m.g == null then
                    set m.g = CreateGroup()
                endif
                set m.step = -1.0
                if m.ln == null then
                    set m.ln = AddLightningEx("CLSB", true, GetUnitX(.c), GetUnitY(.c), 60, GetUnitX(.u), GetUnitY(.u), 60)
                endif
            elseif .src == PhoenixSeal_ID then
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", .u, "chest"))
                call ElemHit(.c, .u, .src, .dmg, true, 1)
                call thistype.Burn(.src, .c, .u, PhoenixSeal_Burn * ElemInt(.c), 4, 0.5, true)
                set m = thistype.Mark(PHOENIX, .src, .c, .u, 3.0, "Abilities\\Spells\\Other\\SoulBurn\\SoulBurnbuff.mdl")
                set m.dmg2 = PhoenixSeal_Bonus * ElemInt(.c)
            elseif .src == SirenTear_ID then
                call ElemFx("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl", GetUnitX(.u), GetUnitY(.u), 2.0)
                call ElemHit(.c, .u, .src, .dmg, true, 2)
                if GetWidgetLife(.u) > 0.405 then
                    set m = thistype.Mark(SIREN, .src, .c, .u, 2.0, "Abilities\\Spells\\Other\\Drain\\ManaDrainTarget.mdl")
                    // 8 drains over 2 sec: min(2.5x INT, 8% max mana) in total.
                    set m.dmg2 = RMinBJ(SirenTear_IntCap * ElemInt(.c), GetUnitState(.u, UNIT_STATE_MAX_MANA) * SirenTear_MaxMpCap / 100.0) / 8.0
                    set m.next = 0.25
                endif
            endif
            set v = null
            set near = null
        endmethod

        // Returns true when the instance is finished.
        method update takes nothing returns boolean
            local real dx
            local real dy
            local real d
            local real a
            local real take
            local thistype m
            local unit v
            local unit a1
            local unit b1
            local real best
            local real px
            local real py
            local unit array hits
            set .left = .left - DT
            if .c == null or GetUnitTypeId(.c) == 0 then
                return true
            endif
            if .kind == PROJ then
                if not ElemAlive(.u) then
                    return true
                endif
                set dx = GetUnitX(.u) - .x
                set dy = GetUnitY(.u) - .y
                if dx * dx + dy * dy <= (.vx + 40.0) * (.vx + 40.0) then
                    call .Arrive()
                    return true
                endif
                set a = Atan2(dy, dx)
                set .x = .x + .vx * Cos(a)
                set .y = .y + .vx * Sin(a)
                call BlzSetSpecialEffectX(.e, .x)
                call BlzSetSpecialEffectY(.e, .y)
                call BlzSetSpecialEffectYaw(.e, a)
                return .left <= 0.0
            elseif .kind == MOVE then
                if not ElemAlive(.u) or .charges <= 0 or not ElemStep(.u, .vx, .vy) then
                    return true
                endif
                set .charges = .charges - 1
                return .charges <= 0
            elseif .kind == DOT then
                if not ElemAlive(.u) then
                    return true
                endif
                set .next = .next - DT
                if .next <= 0.0 then
                    set .next = .step
                    set .charges = .charges - 1
                    if SpellBool(.u) then
                        set d = ElemHit(.c, .u, .src, .dmg, .phase == 1, 0)
                        if .phase == 2 and .dmg2 > 0.0 then
                            set d = RMinBJ(d * LeviathanGrasp_Heal / 100.0, .dmg2)
                            set .dmg2 = .dmg2 - d
                            if d > 0.0 then
                                call SetHpCurrent2(.c, .c, d)
                            endif
                        endif
                    endif
                    return .charges <= 0
                endif
                return .left <= 0.0
            elseif .kind == ANCHOR then
                // Absolute impact times: 0.60, 1.10, 1.60 sec; motion and damage share the clock.
                set .step = .step + DT
                if .charges > 0 then
                    call .Drag(LeviathanAnchor_Aoe, LeviathanAnchor_PullSpeed, 0.0)
                endif
                if .charges < 3 then
                    if .step >= .next then
                        call BlzSetSpecialEffectZ(.e, .dmg2)
                        call BlzSetSpecialEffectPitch(.e, 0.0)
                        set .charges = .charges + 1
                        set .next = .next + 0.5
                        if .charges == 1 then
                            set .e2 = EffectSpawn("Abilities\\Spells\\Other\\Tornado\\TornadoElementalSmall.mdl", .x, .y, 0, 1, 2.2, 0)
                        endif
                        call ElemFx("war3mapImported\\wos_ZarakiWCrack1.mdx", .x, .y, 1.5)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", .x, .y, GetRandomReal(0, 359), 0.65, 1.5, 1))
                        call .Pulse(LeviathanAnchor_Aoe, .dmg, false, IntegerTertiaryOp(.charges == 1, 2, 0), 15)
                        if .charges == 3 then
                            call DestroyEffect(.e)
                            set .e = null
                        endif
                    elseif .charges == 0 then
                        set d = RMaxBJ(0.0, 1.0 - .step / 0.6)
                        call BlzSetSpecialEffectZ(.e, .dmg2 + 1200.0 * d)
                        call BlzSetSpecialEffectPitch(.e, -0.5 * bj_PI * d)
                    else
                        set d = RMaxBJ(0.0, RMinBJ(1.0, (.step - (.next - 0.5)) / 0.5))
                        call BlzSetSpecialEffectZ(.e, .dmg2 + 2880.0 * d * (1.0 - d))
                        call BlzSetSpecialEffectPitch(.e, -0.5 * bj_PI * Sin(bj_PI * d))
                    endif
                endif
                return .left <= 0.0
            elseif .kind == STORM or .kind == SPIRAL then
                if .kind == SPIRAL then
                    call .Drag(ConstellationCoil_Aoe, ConstellationCoil_PullSpeed, ConstellationCoil_Spin)
                endif
                set .next = .next - DT
                if .next <= 0.0 and .charges < 4 then
                    set .next = .step
                    set .charges = .charges + 1
                    set a = GetRandomReal(0, 2 * bj_PI)
                    call ElemFx("war3mapimported\\wos_longskill_point_10.mdl", .x + 160 * Cos(a), .y + 160 * Sin(a), 1.0)
                    call ElemFx("war3mapimported\\wos_longskill_point_10.mdl", .x - 160 * Cos(a), .y - 160 * Sin(a), 1.0)
                    if .kind == STORM then
                        call .Pulse(ThunderBastion_Aoe, .dmg, true, IntegerTertiaryOp(.charges == 1, 3, 0), 0)
                    else
                        call .Pulse(ConstellationCoil_Aoe, .dmg, true, IntegerTertiaryOp(.charges == 1, 3, 0), 0)
                    endif
                endif
                if .left > 0.0 then
                    return false
                endif
                if .kind == STORM then
                    set .charges = 0
                    loop
                        set v = FirstOfGroup(.g)
                        exitwhen v == null
                        call GroupRemoveUnit(.g, v)
                        set .charges = .charges + 1
                    endloop
                    if .charges > 0 then
                        set m = Find(BASTION, .c, null)
                        if m == 0 then
                            set m = Add(BASTION, ThunderBastion_ID, .c, null, 4.0)
                            set m.e = AddSpecialEffectTarget("Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl", .c, "origin")
                        endif
                        set m.left = 4.0
                        set m.charges = IMinBJ(3, m.charges + .charges)
                        set m.dmg2 = ThunderBastion_Counter * ElemStr(.c)
                    endif
                else
                    // Chain the nearest pair of the living enemy heroes the spiral caught.
                    set best = 99999999.0
                    set a1 = null
                    set b1 = null
                    set d = 0
                    loop
                        set v = FirstOfGroup(.g)
                        exitwhen v == null or d >= 10
                        call GroupRemoveUnit(.g, v)
                        if ElemAlive(v) then
                            set hits[R2I(d)] = v
                            set d = d + 1
                        endif
                    endloop
                    set dx = 0
                    loop
                        exitwhen dx >= d
                        set dy = dx + 1
                        loop
                            exitwhen dy >= d
                            set px = GetUnitX(hits[R2I(dx)]) - GetUnitX(hits[R2I(dy)])
                            set py = GetUnitY(hits[R2I(dx)]) - GetUnitY(hits[R2I(dy)])
                            if px * px + py * py < best then
                                set best = px * px + py * py
                                set a1 = hits[R2I(dx)]
                                set b1 = hits[R2I(dy)]
                            endif
                            set dy = dy + 1
                        endloop
                        set hits[R2I(dx)] = null
                        set dx = dx + 1
                    endloop
                    if a1 != null and b1 != null then
                        set m = Add(COIL, ConstellationCoil_ID, .c, a1, 3.0)
                        set m.u2 = b1
                        set m.dmg2 = ConstellationCoil_Bonus * ElemInt(.c)
                        set m.ln = AddLightningEx("CLSB", true, GetUnitX(a1), GetUnitY(a1), 60, GetUnitX(b1), GetUnitY(b1), 60)
                    endif
                endif
                return true
            elseif .kind == RUNE then
                if .phase == 0 then
                    if .left <= 1.5 then
                        set .phase = 1
                        set .next = 0.5
                        set .e2 = EffectSpawn("Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl", .x, .y, 0, 1, 1.6, 0)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_yc_firebeam2.mdx", .x, .y, 0, 2.0, 0.7, 0), 0.3, 255, 255, 255, 0.5)
                        // Eruption: burning before it adds the bonus.
                        call GroupEnumUnitsInRange(ItemsElements_Group, .x, .y, CrimsonScripture_Aoe, NoDecor_Cond)
                        loop
                            set v = FirstOfGroup(ItemsElements_Group)
                            exitwhen v == null
                            call GroupRemoveUnit(ItemsElements_Group, v)
                            if ElemValid(.c, v) then
                                if GetUnitAbilityLevel(v, ErzaFire_ID) > 0 then
                                    call ElemHit(.c, v, .src, .dmg + CrimsonScripture_Burning * ElemInt(.c), true, 1)
                                else
                                    call ElemHit(.c, v, .src, .dmg, true, 1)
                                endif
                            endif
                        endloop
                    endif
                    return false
                endif
                set .next = .next - DT
                if .next <= 0.0 and .charges < 3 then
                    set .next = 0.5
                    set .charges = .charges + 1
                    call .Pulse(CrimsonScripture_Aoe, .dmg2, true, 0, 0)
                endif
                return .left <= 0.0
            elseif .kind == ASHEN or .kind == WAVE then
                // .step = travelled distance, .next = total distance; .vx / .vy = unit direction.
                set .step = .step + IntegerTertiaryOp(.phase == 0, 1, -1) * 1100.0 * DT
                if .kind == WAVE then
                    set px = .x + .vx * .step
                    set py = .y + .vy * .step
                    call BlzSetSpecialEffectX(.e, px)
                    call BlzSetSpecialEffectY(.e, py)
                    call .Sweep(px, py, MirrorTide_WaveAoe, .g, null, .dmg, false, 2, MirrorTide_Push, 0)
                    if .step >= .next then
                        set m = Add(MIRROR, MirrorTide_ID, .c, null, 3.0)
                        set m.x = .tx
                        set m.y = .ty
                        set m.charges = 1
                        set m.dmg2 = MirrorTide_Reflect * ElemAgi(.c)
                        set m.e = EffectSpawn("Abilities\\Spells\\Other\\Monsoon\\MonsoonRain.mdl", .tx, .ty, 0, 0.6, 0.8, 0)
                        return true
                    endif
                    return false
                endif
                set a = Atan2(.vy, .vx)
                set px = .x + .step * Cos(a - 0.35)
                set py = .y + .step * Sin(a - 0.35)
                call BlzSetSpecialEffectX(.e, px)
                call BlzSetSpecialEffectY(.e, py)
                if .phase == 0 then
                    call .Sweep(px, py, 110, .g, null, .dmg, false, 1, 0.0, 0)
                else
                    call .Sweep(px, py, 110, .g2, .g, .dmg2, false, 1, 0.0, 0)
                endif
                set px = .x + .step * Cos(a)
                set py = .y + .step * Sin(a)
                call BlzSetSpecialEffectX(.e2, px)
                call BlzSetSpecialEffectY(.e2, py)
                if .phase == 0 then
                    call .Sweep(px, py, 110, .g, null, .dmg, false, 1, 0.0, 0)
                else
                    call .Sweep(px, py, 110, .g2, .g, .dmg2, false, 1, 0.0, 0)
                endif
                set px = .x + .step * Cos(a + 0.35)
                set py = .y + .step * Sin(a + 0.35)
                call BlzSetSpecialEffectX(.e3, px)
                call BlzSetSpecialEffectY(.e3, py)
                if .phase == 0 then
                    call .Sweep(px, py, 110, .g, null, .dmg, false, 1, 0.0, 0)
                else
                    call .Sweep(px, py, 110, .g2, .g, .dmg2, false, 1, 0.0, 0)
                endif
                if .phase == 0 and .step >= .next then
                    set .phase = 1
                endif
                return .phase == 1 and .step <= 0.0
            elseif .kind == COILSHOT then
                set .step = RMinBJ(.next, .step + ConstellationCoil_Speed * DT)
                set px = .x + .vx * .step
                set py = .y + .vy * .step
                call BlzSetSpecialEffectX(.e, px)
                call BlzSetSpecialEffectY(.e, py)
                call .Sweep(px, py, ConstellationCoil_Width, .g, null, .dmg, true, 3, 0.0, ConstellationCoil_Slow)
                return .step >= .next or .left <= 0.0
            elseif .kind == STRIKES then
                if not ElemAlive(.u) then
                    return true
                endif
                set .next = .next - DT
                if .next <= 0.0 then
                    set .next = 0.3
                    set .charges = .charges + 1
                    call ElemFx("war3mapimported\\wos_WTW-whitethunder-Zi.mdx", GetUnitX(.u), GetUnitY(.u), 1.0)
                    if SpellBool(.u) then
                        call ElemHit(.c, .u, .src, .dmg, true, IntegerTertiaryOp(.charges == 1, 3, 0))
                    endif
                    if .charges == 1 then
                        set m = Mark(VERDICT, .src, .c, .u, 3.0, "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl")
                        set m.x = GetUnitX(.u)
                        set m.y = GetUnitY(.u)
                        set m.dmg2 = ThunderVerdict_Bonus * ElemStr(.c)
                    endif
                    return .charges >= 3
                endif
                return false
            endif
            // ---- marks
            if .kind != BASTION and .kind != MIRROR and not ElemAlive(.u) then
                return true
            endif
            if .kind == VERDICT then
                set dx = GetUnitX(.u) - .x
                set dy = GetUnitY(.u) - .y
                if dx * dx + dy * dy > ThunderVerdict_Leash * ThunderVerdict_Leash then
                    call ElemFx("war3mapimported\\wos_WTW-whitethunder-Zi.mdx", GetUnitX(.u), GetUnitY(.u), 1.0)
                    call ElemHit(.c, .u, ThunderVerdict_ID, .dmg2, true, 0)
                    call SlowUnit(.c, .u, 25, 1)
                    return true
                endif
            elseif .kind == VOLT then
                if not ElemAlive(.c) then
                    return true
                endif
                set .next = .next - DT
                if .next <= 0.0001 then
                    set .next = .next + 1.0
                    call .ThreadPulse()
                endif
                if .ln != null then
                    call MoveLightningEx(.ln, true, GetUnitX(.c), GetUnitY(.c), 60, GetUnitX(.u), GetUnitY(.u), 60)
                endif
            elseif .kind == COIL then
                if not ElemAlive(.u2) then
                    return true
                endif
                set dx = GetUnitX(.u) - GetUnitX(.u2)
                set dy = GetUnitY(.u) - GetUnitY(.u2)
                if dx * dx + dy * dy > ConstellationCoil_Break * ConstellationCoil_Break then
                    call ElemHit(.c, .u, ConstellationCoil_ID, .dmg2, true, 0)
                    call ElemHit(.c, .u2, ConstellationCoil_ID, .dmg2, true, 0)
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\Bolt\\BoltImpact.mdl", .u, "chest"))
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\Bolt\\BoltImpact.mdl", .u2, "chest"))
                    return true
                endif
                call MoveLightningEx(.ln, true, GetUnitX(.u), GetUnitY(.u), 60, GetUnitX(.u2), GetUnitY(.u2), 60)
            elseif .kind == SIREN then
                set .next = .next - DT
                if .next <= 0.0 then
                    set .next = 0.25
                    set take = RMinBJ(.dmg2, GetUnitState(.u, UNIT_STATE_MANA))
                    if take > 0.0 then
                        call SetMpCurrentQuiet(.u, -take)
                        call SetMpCurrentQuiet(.c, take * SirenTear_Return / 100.0)
                    endif
                endif
            endif
            set v = null
            set a1 = null
            set b1 = null
            return .left <= 0.0
        endmethod

        static method Tick takes nothing returns nothing
            local integer i = 0
            local thistype this
            loop
                exitwhen i >= count
                set this = list[i]
                if .update() then
                    set count = count - 1
                    set list[i] = list[count]
                    call .finish()
                else
                    set i = i + 1
                endif
            endloop
            if count == 0 then
                call PauseTimer(clock)
            endif
        endmethod

        private static method onInit takes nothing returns nothing
            set tickCode = function thistype.Tick
        endmethod
    endstruct

    // ---------------------------------------------------------------- casts
    function ItemsElements_Cast takes unit c, unit td, real x, real y, integer id returns nothing
        local ItemsElementsFx fx
        local real life
        local real cost
        local real a
        local real d
        if id == BloodPactRingEvolved_Abi_ID then
            call GearManaFloorStart(c, BloodPactRingEvolved_Duration, BloodPactRingEvolved_ManaFloor / 100.0)
            call MyRemoveEff(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", c, "origin"), BloodPactRingEvolved_Duration)
            return
        endif
        if id == BloodPactRing_Abi_ID then
            set life = GetWidgetLife(c)
            set cost = RMinBJ(BloodPactRing_Cost, life - 1.0)
            if cost > 0.0 then
                call SetWidgetLife(c, life - cost)
                call SetMpCurrent(c, BloodPactRing_Mana)
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl", c, "origin"))
            endif
            return
        endif
        // ---- single target: a projectile carries the first damage (Booster added once there)
        if id == Emberbreaker_Abi_ID or id == LeviathanGrasp_Abi_ID or id == ThunderVerdict_Abi_ID or id == CinderFang_Abi_ID or id == VoltThread_Abi_ID or id == PhoenixSeal_Abi_ID or id == SirenTear_Abi_ID then
            if not ElemValid(c, td) then
                return
            endif
            if id == Emberbreaker_Abi_ID then
                call ItemsElementsFx.Missile(Emberbreaker_ID, c, GetUnitX(c), GetUnitY(c), td, 1400, "war3mapImported\\wos_summon3missle.mdl", SacredGearBooster(c, Emberbreaker_Impact * ElemStr(c)))
            elseif id == LeviathanGrasp_Abi_ID then
                call ItemsElementsFx.Missile(LeviathanGrasp_ID, c, GetUnitX(c), GetUnitY(c), td, 1300, "war3mapimported\\wos_EF_AZ_Leviathan_G1.mdl", SacredGearBooster(c, LeviathanGrasp_Impact * ElemStr(c)))
            elseif id == ThunderVerdict_Abi_ID then
                set fx = ItemsElementsFx.Add(ItemsElementsFx.STRIKES, ThunderVerdict_ID, c, td, 2.0)
                set fx.dmg = SacredGearBooster(c, ThunderVerdict_Damage * ElemStr(c)) / 3.0
                set fx.next = 0.10
            elseif id == CinderFang_Abi_ID then
                call ItemsElementsFx.Missile(CinderFang_ID, c, GetUnitX(c), GetUnitY(c), td, 2400, "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", SacredGearBooster(c, CinderFang_Impact * ElemAgi(c)))
            elseif id == VoltThread_Abi_ID then
                call ItemsElementsFx.Missile(VoltThread_ID, c, GetUnitX(c), GetUnitY(c), td, 2000, "war3mapImported\\wos_obr08 (166).mdx", SacredGearBooster(c, VoltThread_Damage * ElemAgi(c)))
            elseif id == PhoenixSeal_Abi_ID then
                call ItemsElementsFx.Missile(PhoenixSeal_ID, c, GetUnitX(c), GetUnitY(c), td, 1000, "war3mapImported\\wos_Windwalk Fire2.mdl", SacredGearBooster(c, PhoenixSeal_Impact * ElemInt(c)))
            else
                call ItemsElementsFx.Missile(SirenTear_ID, c, GetUnitX(c), GetUnitY(c), td, 1100, "Abilities\\Weapons\\SeaElementalMissile\\SeaElementalMissile.mdl", SacredGearBooster(c, SirenTear_Damage * ElemInt(c)))
            endif
            return
        endif
        // ---- area: delayed blasts, pulses, sweeps
        if id == LeviathanAnchor_Abi_ID then
            set fx = ItemsElementsFx.Add(ItemsElementsFx.ANCHOR, LeviathanAnchor_ID, c, null, 2.1)
            set fx.dmg = SacredGearBooster(c, LeviathanAnchor_Damage * ElemStr(c)) / 3.0
            set fx.e = EffectSpawn("war3mapimported\\wos_EF_AZ_Leviathan_G2.mdl", x, y, 0, 1, 0.9, 1200)
            set fx.dmg2 = BlzGetLocalSpecialEffectZ(fx.e) - 1200.0
            set fx.next = 0.6
            call BlzSetSpecialEffectPitch(fx.e, -0.5 * bj_PI)
        elseif id == ThunderBastion_Abi_ID then
            set fx = ItemsElementsFx.Add(ItemsElementsFx.STORM, ThunderBastion_ID, c, null, 1.9)
            set fx.dmg = SacredGearBooster(c, ThunderBastion_Damage * ElemStr(c)) / 4.0
            set fx.step = 0.5
            set fx.next = 0.2
            set fx.g = CreateGroup()
            set fx.e = AddSpecialEffect("Abilities\\Spells\\Human\\ManaFlare\\ManaFlareTarget.mdl", x, y)
            call BlzSetSpecialEffectScale(fx.e, 1.25)
        elseif id == CrimsonScripture_Abi_ID then
            set fx = ItemsElementsFx.Add(ItemsElementsFx.RUNE, CrimsonScripture_ID, c, null, 2.3)
            set fx.dmg = SacredGearBooster(c, CrimsonScripture_Damage * ElemInt(c))
            set fx.dmg2 = CrimsonScripture_Ground * ElemInt(c) / 3.0
            set fx.e = AddSpecialEffect("Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl", x, y)
        elseif id == ConstellationCoil_Abi_ID then
            set a = Atan2(y - GetUnitY(c), x - GetUnitX(c))
            set fx = ItemsElementsFx.Add(ItemsElementsFx.COILSHOT, ConstellationCoil_ID, c, null, 2.0)
            set fx.dmg = SacredGearBooster(c, ConstellationCoil_Damage * ElemInt(c))
            set fx.next = ConstellationCoil_Range
            set fx.vx = Cos(a)
            set fx.vy = Sin(a)
            set fx.g = CreateGroup()
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set fx.e = EffectSpawn(ConstellationCoil_ProjectileModel, x, y, a * bj_RADTODEG, 1, ConstellationCoil_ProjectileScale, 100)
        elseif id == AshenCrossfire_Abi_ID or id == MirrorTide_Abi_ID then
            set a = Atan2(y - GetUnitY(c), x - GetUnitX(c))
            set d = SquareRoot((x - GetUnitX(c)) * (x - GetUnitX(c)) + (y - GetUnitY(c)) * (y - GetUnitY(c)))
            if id == AshenCrossfire_Abi_ID then
                set fx = ItemsElementsFx.Add(ItemsElementsFx.ASHEN, AshenCrossfire_ID, c, null, 4.0)
                set fx.dmg = SacredGearBooster(c, AshenCrossfire_Damage * ElemAgi(c))
                set fx.dmg2 = AshenCrossfire_Return * ElemAgi(c)
                set fx.next = RMinBJ(RMaxBJ(d + AshenCrossfire_Aoe * 0.5, 300.0), 1000.0)
                set fx.g2 = CreateGroup()
                set fx.e = EffectSpawn(AshenCrossfire_ProjectileModel, GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, AshenCrossfire_ProjectileScale, AshenCrossfire_ProjectileHeight)
                set fx.e2 = EffectSpawn(AshenCrossfire_ProjectileModel, GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, AshenCrossfire_ProjectileScale, AshenCrossfire_ProjectileHeight)
                set fx.e3 = EffectSpawn(AshenCrossfire_ProjectileModel, GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, AshenCrossfire_ProjectileScale, AshenCrossfire_ProjectileHeight)
            else
                set fx = ItemsElementsFx.Add(ItemsElementsFx.WAVE, MirrorTide_ID, c, null, 4.0)
                set fx.dmg = SacredGearBooster(c, MirrorTide_Damage * ElemAgi(c))
                set fx.next = MirrorTide_Range
                set fx.tx = GetUnitX(c) + Cos(a) * fx.next
                set fx.ty = GetUnitY(c) + Sin(a) * fx.next
                set fx.e = EffectSpawn(MirrorTide_ProjectileModel, GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, MirrorTide_ProjectileScale, 0)
            endif
            set fx.vx = Cos(a)
            set fx.vy = Sin(a)
            set fx.g = CreateGroup()
            set x = GetUnitX(c)
            set y = GetUnitY(c)
        else
            return
        endif
        set fx.x = x
        set fx.y = y
    endfunction

    // ---------------------------------------------------------------- reactions
    // Applied damage (DmgSys). Follow-ups are spell damage, so they never re-enter the attack
    // branches; enemy -> owner reactions need td == owner and spend their mark / charge first.
    function ItemsElements_OnDamage takes unit c, unit td, real dmg, boolean isAttack returns nothing
        local ItemsElementsFx fx
        local unit v
        local unit near = null
        local real best = 99999999.0
        local real d
        local real now
        if ItemsElementsFx.count == 0 or dmg <= 0.0 or c == null or td == null or c == td then
            return
        endif
        // Enemy hits the owner.
        set fx = ItemsElementsFx.Find(ItemsElementsFx.EMBER, td, c)
        if fx != 0 then
            set fx.left = 0.0
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", c, "chest"))
            call ElemHit(td, c, Emberbreaker_ID, fx.dmg2, true, 0)
        endif
        set fx = ItemsElementsFx.Find(ItemsElementsFx.BASTION, td, null)
        if fx != 0 and fx.charges > 0 and IsUnitEnemy(c, GetOwningPlayer(td)) and SpellBool(c) then
            set now = TimerGetElapsed(HealRegenClock)
            if now >= fx.step then
                set fx.step = now + 0.8
                set fx.charges = fx.charges - 1
                if fx.charges == 0 then
                    set fx.left = 0.0
                endif
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\Bolt\\BoltImpact.mdl", c, "chest"))
                call ElemHit(td, c, ThunderBastion_ID, fx.dmg2, true, 0)
                call SlowUnit(td, c, 20, 1)
            endif
        endif
        if not isAttack then
            return
        endif
        // Owner's basic attacks.
        set fx = ItemsElementsFx.Find(ItemsElementsFx.CINDER, c, td)
        if fx != 0 then
            set fx.left = 0.0
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", td, "chest"))
            call ElemHit(c, td, CinderFang_ID, fx.dmg2, false, 0)
        endif
        set fx = ItemsElementsFx.Find(ItemsElementsFx.VOLT, c, td)
        if fx != 0 then
            set now = TimerGetElapsed(HealRegenClock)
            if now >= fx.step + 0.4 then
                set fx.step = now
                set fx.charges = fx.charges + 1
                if fx.charges >= 3 then
                    set fx.left = 0.0
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", td, "origin"))
                    call ElemHit(c, td, VoltThread_ID, fx.dmg2, true, 0)
                    call SlowUnit(c, td, 20, 1)
                endif
            endif
        endif
        set fx = ItemsElementsFx.Find(ItemsElementsFx.MIRROR, c, null)
        if fx != 0 and fx.charges > 0 and IsUnitInRangeXY(td, fx.x, fx.y, MirrorTide_Aoe) then
            call GroupEnumUnitsInRange(ItemsElements_Group, fx.x, fx.y, MirrorTide_Aoe, NoDecor_Cond)
            loop
                set v = FirstOfGroup(ItemsElements_Group)
                exitwhen v == null
                call GroupRemoveUnit(ItemsElements_Group, v)
                if v != td and ElemValid(c, v) then
                    set d = (GetUnitX(v) - GetUnitX(td)) * (GetUnitX(v) - GetUnitX(td)) + (GetUnitY(v) - GetUnitY(td)) * (GetUnitY(v) - GetUnitY(td))
                    if d < best then
                        set best = d
                        set near = v
                    endif
                endif
            endloop
            if near != null then
                set fx.charges = 0
                set fx.left = 0.0
                // The reflected blade flies to its target (no instant hit).
                call ItemsElementsFx.Missile(MirrorTide_ID, c, GetUnitX(td), GetUnitY(td), near, 1600, MirrorTide_ProjectileModel, fx.dmg2)
            endif
        endif
        set v = null
        set near = null
    endfunction

    // A hero ability cast by a Phoenix Seal target (CastCheck, real casts only).
    function ItemsElements_OnHeroCast takes unit u returns nothing
        local integer i = 0
        local ItemsElementsFx fx
        loop
            exitwhen i >= ItemsElementsFx.count
            set fx = ItemsElementsFx.list[i]
            if fx.kind == ItemsElementsFx.PHOENIX and fx.u == u and fx.left > 0.0 then
                set fx.left = 0.0
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", u, "chest"))
                call ElemHit(fx.c, u, PhoenixSeal_ID, fx.dmg2, true, 0)
            endif
            set i = i + 1
        endloop
    endfunction

    endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com

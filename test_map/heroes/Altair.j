library AltairSpells initializer InitAltairSpells uses GearSystems
    globals
        // ==================== COMMON: hero ID, forms and shared state ====================
        integer Altair_ID = 'H004'
        private hashtable AltairTable = InitHashtable()
        private boolean AltairListenerOn = false
        private group AltairGroup = CreateGroup()
        private rect AltairEnumRect = Rect(0.0, 0.0, 0.0, 0.0)
        private location AltairLoc = Location(0.0, 0.0)
        private real AltairEnumX = 0.0
        private real AltairEnumY = 0.0
        private real AltairEnumRadius = 0.0
        private boolean AltairEnumTrain = false
        // Slots 0-6 = Q W E R T F G of each form.
        private integer array AltairHoloAbility
        private integer array AltairSwordAbility
        integer Altair_FormHolopsicon = 0
        integer Altair_FormSword = 1
        real Altair_SwitchLock = 10.0
        string Altair_SwitchModel = "war3mapImported\\wos_blackblink.mdx"
        string Altair_ImageModel = "war3mapImported\\wos_Mdx_Effect_MirrorImage_White.mdx"
        string Altair_DarkImageModel = "war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx"
        // The sword model lies flat along X: yaw is the direction of the blade (as Erza TW).
        string Altair_SwordModel = "war3mapImported\\wos_Erza_sword2.mdx"
        string Altair_SlashModel = "war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl"
        string Altair_SwordHitModel = "war3mapImported\\wos_daoguang_blue_hitsword.mdx"
        string Altair_HitModel = "war3mapImported\\wos_Opdef (571)2.mdl"
        string Altair_StampedeModel = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
        string Altair_DustModel = "war3mapImported\\wos_dustbrown.mdl"
        string Altair_RingModel = "war3mapImported\\wos_whitering.mdx"
        string Altair_CircleModel = "war3mapImported\\wos_yc_bluemorphcircle3.mdl"
        string Altair_PortalModel = "war3mapImported\\wos_effect_mythic_VoidRiftPurple.mdx" // flat disc: pitch -90 stands it up
        // AltairTable keys on the hero: 0 state, 2 R, 3 T, 5 SE, 6 SR, 7 ST; on any unit: 1 W block.
        // Voice lines cut from the anime: Hero_Altair_<slot><n>.mp3, G<slot> for the Sword Princess form.
        string AltairSoundPath = "war3mapImported\\Hero_Altair_"

        // ==================== Q: PPSH Spray (Holopsicon) ====================
        integer AltairQ_ID = 'A11E'
        real AltairQ_DamageIntBase = 3.0
        real AltairQ_DamageIntStep = 1.0
        real AltairQ_DamageStatic = 75.0
        real AltairQ_DamageStaticStep = 25.0
        real AltairQ_Aoe = 300.0
        real AltairQ_Stun = 0.5
        real AltairQ_DamageDelay = 0.15
        real AltairQ_SprayTime = 0.6
        real AltairQ_ShotPeriod = 0.03
        real AltairQ_BulletSpeed = 2600.0
        string AltairQ_MuzzleModel = "war3mapImported\\wos_huoqiang02_T1.mdx"
        string AltairQ_FlashModel = "war3mapImported\\wos_alucard bulletfire.mdl"
        string AltairQ_BulletModel = "war3mapImported\\wos_alucard bullet.mdl"
        string AltairQ_HitModel = "war3mapImported\\wos_hit-juhuang1.mdl"

        // ==================== W: Third / Ninth Movement (Holopsicon) ====================
        integer AltairW_ID = 'A11F'
        real AltairW_Speed = 2000.0
        real AltairW_ContactRange = 90.0
        real AltairW_MaxDashTime = 1.2
        real AltairW_Duration = 3.0 // ally block + heal over time, +1 sec per level
        real AltairW_DurationStep = 1.0
        real AltairW_HealIntBase = 1.0
        real AltairW_HealIntStep = 0.25
        real AltairW_DamageIntBase = 2.0
        real AltairW_DamageIntStep = 0.4
        real AltairW_DamageStatic = 50.0
        real AltairW_DamageStaticStep = 25.0
        string AltairW_PetalModel = "war3mapImported\\wos_KyorakuPetals.mdx"
        string AltairW_AllyModel = "war3mapImported\\wos_HealBlue.mdl"
        string AltairW_BlockModel = "war3mapImported\\wos_title_shielded.mdl"
        string AltairW_EraseModel = "war3mapImported\\wos_mirrorzi_effect_ansekuosanbo.mdx"

        // ==================== E: Outline Origin (Holopsicon) ====================
        integer AltairE_ID = 'A120'
        real AltairE_Aoe = 650.0
        real AltairE_CooldownReduction = 5.0
        real AltairE_DamageIntBase = 1.5
        real AltairE_DamageIntStep = 0.4
        real AltairE_StringTime = 0.3 // PPSH strung with a sword before the release
        real AltairE_VisualTime = 1.4
        string AltairE_SphereModel = "war3mapImported\\wos_cronosphere.mdx"
        real AltairE_SphereScale = 1.3
        string AltairE_ClockModel = "war3mapImported\\wos_clockwisetimer3.mdl"
        real AltairE_ClockScale = 2.5

        // ==================== R: Factor Mimic (Holopsicon) ====================
        integer AltairR_ID = 'A121'
        real AltairR_Aoe = 600.0
        integer AltairR_MaxCopies = 24 // everything inside the marker is copied, up to this many
        real AltairR_Window = 30.0
        real AltairR_Cooldown = 16.0
        real AltairR_DamageIntBase = 2.5
        real AltairR_DamageIntStep = 0.5
        real AltairR_DamageStatic = 100.0
        real AltairR_DamageStaticStep = 50.0
        real AltairR_PathDamage = 0.35 // share of the impact damage dealt along the flight path
        real AltairR_ThrowSpeed = 1600.0
        real AltairR_PortalOpen = 0.15
        real AltairR_ThrowStagger = 0.06 // one copy leaves the portal every 0.06 sec
        real AltairR_PortalLife = 0.8
        real AltairR_PortalHeight = 260.0
        real AltairR_PortalScale = 1.6
        real AltairR_PortalSpread = 110.0
        real AltairR_ArcHeight = 120.0
        real AltairR_HeavyTilt = 0.12 // heavy copies (houses, bus, trains) glide level with a slight nose-down tilt
        real AltairR_OverloadStun = 0.5
        real AltairR_MaxStun = 1.5
        real AltairR_HydrantPush = 300.0
        real AltairR_CopyScale = 0.18
        real AltairR_CopyRadius = 120.0
        real AltairR_CopyHeight = 260.0
        real AltairR_CopyFlyTime = 0.45
        integer AltairR_TrainHeroLevel = 35
        integer AltairR_TrainDecorID = 'B017' // invisible blocker that follows the round-end train
        integer AltairR_TrainMetroID = 'h00G'
        integer AltairR_TrainThomasID = 'h02N'
        string AltairR_TrainMetroModel = "land_wos\\Train Metro.mdl"
        string AltairR_TrainThomasModel = "war3mapImported\\wos_Model Thomas.mdl"
        real AltairR_TrainSearch = 900.0
        string AltairR_ImpactModel = "war3mapImported\\wos_fbt-dilie22.mdl"
        string AltairR_BarrelModel = "war3mapImported\\wos_GZ_jntxn (11)_R1-200.mdl"
        string AltairR_HydrantModel = "war3mapImported\\wos_obr08 (171).mdl"
        string AltairR_MetalModel = "war3mapImported\\wos_solaire_lightning_impact.mdl"
        string AltairR_TrainImpactModel = "war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl"
        string AltairR_TrainSlashModel = "war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl"
        // Copyable decor: type, model, average object scale, weight (1 light, 2 medium, 3 heavy).
        private integer array AltairDecorId
        private string array AltairDecorModel
        private real array AltairDecorScale
        private integer array AltairDecorWeight
        private integer AltairDecorCount = 0
        private destructable array AltairRCandidate
        private real array AltairRCandidateDistance
        private integer AltairRCandidateCount = 0
        private integer AltairRThrowCounter = 0
        // Kinds: decor table index >= 0, train skins below zero.
        integer AltairR_KindMetro = -1
        integer AltairR_KindThomas = -2

        // ==================== T: Fate Reconstruction (Holopsicon) ====================
        integer AltairT_ID = 'A122'
        real AltairT_Aoe = 300.0
        real AltairT_EnterRadius = 140.0
        integer AltairT_MaxMembers = 4
        real AltairT_Duration = 20.0
        real AltairT_DurationLevel35 = 5.0
        real AltairT_Cooldown = 60.0
        real AltairT_PullTime = 0.35
        real AltairT_RealmSpread = 380.0
        real AltairT_PortalScale = 3.2
        real AltairT_PortalHeight = 230.0
        string AltairT_GroundModel = "war3mapImported\\wos_yc_bluemorphcircle2.mdl"
        string AltairT_TeleportModel = "war3mapImported\\wos_blackblink.mdx"

        // ==================== F: The Vicissitudes of Fortune (Holopsicon) ====================
        integer AltairF_ID = 'A123'
        real AltairF_Duration = 6.0
        real AltairF_Reflect = 1.0
        string AltairF_Model = "war3mapImported\\wos_AsNodtSphere.mdx"
        real AltairF_ModelScale = 0.28
        string AltairF_ReflectModel = "war3mapImported\\wos_effect_fate_jiujian_chongjibo.mdx"

        // ==================== G: Meta Change (Holopsicon -> Sword Princess) ====================
        integer AltairG_ID = 'A124'
        integer AltairG_BurstBlades = 12

        // ==================== SQ: Sword Rush ====================
        integer AltairSQ_ID = 'A125'
        integer AltairSQ_Cost = 3
        real AltairSQ_Range = 700.0
        real AltairSQ_Speed = 2400.0
        real AltairSQ_Width = 150.0
        real AltairSQ_DamageIntBase = 1.0
        real AltairSQ_DamageIntStep = 0.2
        real AltairSQ_DamageAtk = 1.0
        string AltairSQ_SlashModel = "war3mapImported\\wos_LXY-ZK_BM_The might of a sword_LAN-2.mdx"

        // ==================== SW: Sword Storm ====================
        integer AltairSW_ID = 'A126'
        integer AltairSW_Cost = 6
        integer AltairSW_Swords = 9
        real AltairSW_Cone = 40.0 // degrees between the outer swords
        real AltairSW_Range = 1000.0
        real AltairSW_Speed = 1800.0
        real AltairSW_Width = 110.0
        real AltairSW_DamageIntBase = 1.2
        real AltairSW_DamageIntStep = 0.3
        real AltairSW_DamageAtk = 0.8
        string AltairSW_GateModel = "war3mapImported\\wos_effect_fate_jiujian_galibang_qixuan.mdx"

        // ==================== SE: Spinning Swords ====================
        integer AltairSE_ID = 'A127'
        integer AltairSE_Cost = 2
        integer AltairSE_CostStep = 2
        integer AltairSE_CostMax = 6
        real AltairSE_RecastWindow = 4.0
        real AltairSE_Duration = 1.5
        real AltairSE_Period = 0.25
        real AltairSE_Aoe = 300.0
        real AltairSE_Radius = 190.0
        real AltairSE_Height = 60.0
        real AltairSE_SpinSpeed = 12.0 // radians per second
        integer AltairSE_Blades = 8
        integer AltairSE_BladesStep = 4
        real AltairSE_PowerStep = 0.5
        real AltairSE_DamageIntBase = 0.3
        real AltairSE_DamageIntStep = 0.05
        real AltairSE_DamageAtk = 0.15
        string AltairSE_SlashModel = "war3mapImported\\wos_az_erdaoliujianqi.mdx"

        // ==================== SR: Shield of Swords ====================
        integer AltairSR_ID = 'A128'
        integer AltairSR_Cost = 8
        real AltairSR_Duration = 3.0
        real AltairSR_DurationStep = 0.5
        real AltairSR_Arc = 120.0 // degrees, centred on the cast direction
        integer AltairSR_RingBlades = 16
        integer AltairSR_WallBlades = 6
        real AltairSR_Radius = 170.0
        real AltairSR_WallRadius = 120.0
        real AltairSR_SpinSpeed = 6.0
        real AltairSR_Period = 0.3
        real AltairSR_DamageInt = 0.15
        real AltairSR_DamageAtk = 0.1

        // ==================== ST: Rain of Swords ====================
        integer AltairST_ID = 'A129'
        integer AltairST_Cost = 30
        real AltairST_Duration = 3.0
        real AltairST_Height = 450.0
        real AltairST_RiseTime = 0.4
        real AltairST_Aoe = 700.0
        real AltairST_SpawnPeriod = 0.06
        real AltairST_DropHeight = 900.0
        real AltairST_DropSpeed = 2400.0
        real AltairST_ImpactAoe = 160.0
        real AltairST_DamageInt = 0.5
        real AltairST_DamageAtk = 0.3

        // ==================== SF: Endless Swords ====================
        integer AltairSF_ID = 'A12A'
        integer AltairSF_StackBonus = 15 // max stacks = hero level + bonus
        real AltairSF_StackPeriod = 4.0
        integer AltairSF_DeathStacks = 8
        real AltairSF_AttackTaken = 0.9 // toggle: attacks deal 10% less
        integer AltairSF_AttackCost = 2
        integer AltairSF_GuardBlades = 4
        real AltairSF_GuardRadius = 110.0

        // ==================== SG: Meta Change (Sword Princess -> Holopsicon) ====================
        integer AltairSG_ID = 'A12B'
    endglobals

    // ==================== COMMON: helpers ====================
    private function AltairGroundZ takes real x, real y returns real
        call MoveLocation(AltairLoc, x, y)
        return GetLocationZ(AltairLoc)
    endfunction

    // Rings/circles without a death animation fade instead of lingering after DestroyEffect.
    private function AltairFade takes effect whichEffect returns nothing
        call ColorEffDummy3(whichEffect, 0.25, 255, 255, 255, 0.35)
    endfunction

    // A dead hero may keep life above 0.405.
    private function AltairAlive takes unit whichUnit returns boolean
        return GetUnitTypeId(whichUnit) != 0 and not IsUnitType(whichUnit, UNIT_TYPE_DEAD) and GetWidgetLife(whichUnit) > 0.405
    endfunction

    private function AltairIsEnemy takes unit hero, unit target returns boolean
        return SpellBool(target) and IsUnitEnemy(target, GetOwningPlayer(hero))
    endfunction

    // Sword Princess spells hit as attacks: on-hit items trigger (Endless Swords) and attack items scale them.
    private function AltairSwordDamage takes unit hero, real intCoefficient, real atkCoefficient returns real
        return GetHeroInt(hero, true)*intCoefficient + GetAttack(hero)*atkCoefficient
    endfunction

    private function AltairDecor takes integer id, string model, real scale, integer weight returns nothing
        set AltairDecorId[AltairDecorCount] = id
        set AltairDecorModel[AltairDecorCount] = model
        set AltairDecorScale[AltairDecorCount] = scale
        set AltairDecorWeight[AltairDecorCount] = weight
        set AltairDecorCount = AltairDecorCount + 1
    endfunction

    private function AltairDecorIndex takes integer id returns integer
        local integer index = 0
        loop
            exitwhen index >= AltairDecorCount
            if AltairDecorId[index] == id then
                return index
            endif
            set index = index + 1
        endloop
        return -1
    endfunction

    private function AltairKindModel takes integer kind returns string
        if kind == AltairR_KindMetro then
            return AltairR_TrainMetroModel
        elseif kind == AltairR_KindThomas then
            return AltairR_TrainThomasModel
        endif
        return AltairDecorModel[kind]
    endfunction

    private function AltairKindScale takes integer kind returns real
        if kind == AltairR_KindMetro then
            return 1.0
        elseif kind == AltairR_KindThomas then
            return 3.15
        endif
        return AltairDecorScale[kind]
    endfunction

    // 4 = train.
    private function AltairKindWeight takes integer kind returns integer
        if kind < 0 then
            return 4
        endif
        return AltairDecorWeight[kind]
    endfunction

    private function AltairKindDecorId takes integer kind returns integer
        if kind < 0 then
            return AltairR_TrainDecorID
        endif
        return AltairDecorId[kind]
    endfunction

    // A blue Holopsicon rift standing upright and facing the given direction.
    private function AltairPortal takes real x, real y, real height, real facing, real scale, integer red, integer green, integer blue returns effect
        local effect portal = AddSpecialEffect(Altair_PortalModel, x, y)
        call BlzSetSpecialEffectScale(portal, scale)
        call BlzSetSpecialEffectColor(portal, red, green, blue)
        call BlzSetSpecialEffectOrientation(portal, facing, -bj_PI/2.0, 0.0)
        call BlzSetSpecialEffectPosition(portal, x, y, AltairGroundZ(x, y) + height)
        call BlzPlaySpecialEffect(portal, ANIM_TYPE_BIRTH)
        return portal
    endfunction

    // ==================== COMMON: flying sword (Sword Storm, Meta Change burst) ====================
    private struct AltairBlade_KS
        static integer array active
        static integer count = 0
        unit hero
        effect art
        real angle
        real speed
        real travelled
        real range
        real width
        real damage
        group hits // shared by one cast, destroyed by the last blade

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local real step
            local real nextX
            local real nextY
            local integer users
            local unit target
            loop
                exitwhen index >= count
                set this = active[index]
                set step = speed*0.03
                set nextX = BlzGetLocalSpecialEffectX(art) + step*Cos(angle)
                set nextY = BlzGetLocalSpecialEffectY(art) + step*Sin(angle)
                set travelled = travelled + step
                if travelled >= range or not PathableCheck(nextX, nextY) then
                    call ColorEffDummy3(art, 0.0, 255, 255, 255, 0.15)
                    if hits != null then
                        set users = LoadInteger(AltairTable, GetHandleId(hits), 0) - 1
                        if users <= 0 then
                            call RemoveSavedInteger(AltairTable, GetHandleId(hits), 0)
                            call DestroyGroup(hits)
                        else
                            call SaveInteger(AltairTable, GetHandleId(hits), 0, users)
                        endif
                    endif
                    set art = null
                    set hits = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    call BlzSetSpecialEffectX(art, nextX)
                    call BlzSetSpecialEffectY(art, nextY)
                    if damage > 0.0 then
                        call GroupEnumUnitsInRange(AltairGroup, nextX, nextY, width, NoDecor_Cond)
                        loop
                            set target = FirstOfGroup(AltairGroup)
                            exitwhen target == null
                            call GroupRemoveUnit(AltairGroup, target)
                            if AltairIsEnemy(hero, target) and not IsUnitInGroup(target, hits) then
                                call GroupAddUnit(hits, target)
                                call DamageSource(AltairSW_ID)
                                call dmgatk(hero, target, damage)
                                call DestroyEffect(AddSpecialEffectTarget(Altair_StampedeModel, target, "chest"))
                                call DestroyEffect(EffectSpawn(Altair_HitModel, GetUnitX(target), GetUnitY(target), 0.0, 1.0, 1.5, 76.0))
                            endif
                        endloop
                        call DecorRemove(hero, nextX, nextY, width, damage)
                    endif
                    set index = index + 1
                endif
            endloop
            set target = null
        endmethod

        static method Launch takes unit caster, real x, real y, real height, real facing, real bladeSpeed, real bladeRange, real bladeWidth, real bladeDamage, group shared returns nothing
            local thistype this = allocate()
            set hero = caster
            set angle = facing
            set speed = bladeSpeed
            set range = bladeRange
            set width = bladeWidth
            set damage = bladeDamage
            set travelled = 0.0
            set hits = shared
            if hits != null then
                call SaveInteger(AltairTable, GetHandleId(hits), 0, LoadInteger(AltairTable, GetHandleId(hits), 0) + 1)
            endif
            set art = EffectSpawn(Altair_SwordModel, x, y, facing*bj_RADTODEG, 1.0, 0.45, height)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    // ==================== COMMON: form, sword stacks and pending refunds ====================
    private struct AltairState
        static integer array active
        static integer count = 0
        unit hero
        integer form
        integer stacks
        integer shownStacks
        real stackTimer
        boolean swordToggle
        effect array guard[4]
        real guardAngle
        integer array holoLevel[7]
        boolean array swordDisabled[7]
        integer seCost
        real seWindow
        real fRemaining
        effect fEffect
        unit reflectTarget
        real reflectAmount
        real shieldRemaining
        real shieldAngle
        integer refundAbility
        integer array voiceCycle[20]

        // Every cast plays its next line at once; each slot cycles its own variants.
        method Voice takes integer slot, string key, integer first, integer variants returns nothing
            call MakeSound(AltairSoundPath + key + I2S(first + ModuloInteger(voiceCycle[slot], variants)))
            set voiceCycle[slot] = voiceCycle[slot] + 1
        endmethod

        method MaxStacks takes nothing returns integer
            return GetHeroLevel(hero) + AltairSF_StackBonus
        endmethod

        method AddStacks takes integer amount returns nothing
            set stacks = IMinBJ(MaxStacks(), IMaxBJ(0, stacks + amount))
        endmethod

        method SwordCost takes integer slot returns integer
            if slot == 0 then
                return AltairSQ_Cost
            elseif slot == 1 then
                return AltairSW_Cost
            elseif slot == 2 then
                return seCost
            elseif slot == 3 then
                return AltairSR_Cost
            elseif slot == 4 then
                return AltairST_Cost
            endif
            return 0
        endmethod

        method TrySpend takes integer cost returns boolean
            if stacks < cost then
                return false
            endif
            set stacks = stacks - cost
            return true
        endmethod

        // The native cooldown may be applied after SPELL_EFFECT; clear it on the next tick.
        method Refuse takes integer abilityId, string reason returns nothing
            set refundAbility = abilityId
            call DisplayTimedTextToPlayer(GetOwningPlayer(hero), 0.0, 0.0, 2.0, "|cffff6060" + reason + "|r")
        endmethod

        // Toggled Endless Swords: four swords guard the hero.
        method SetToggle takes boolean enabled returns nothing
            local integer slot = 0
            set swordToggle = enabled
            loop
                exitwhen slot >= AltairSF_GuardBlades
                if enabled and guard[slot] == null then
                    set guard[slot] = AddSpecialEffect(Altair_SwordModel, GetUnitX(hero), GetUnitY(hero))
                    call BlzSetSpecialEffectScale(guard[slot], 0.3)
                elseif not enabled and guard[slot] != null then
                    call ColorEffDummy3(guard[slot], 0.0, 255, 255, 255, 0.2)
                    set guard[slot] = null
                endif
                set slot = slot + 1
            endloop
        endmethod

        method ApplyForm takes integer newForm returns nothing
            local integer slot = 0
            local player owner = GetOwningPlayer(hero)
            set form = newForm
            loop
                exitwhen slot > 6
                call SetPlayerAbilityAvailable(owner, AltairHoloAbility[slot], form == Altair_FormHolopsicon)
                call SetPlayerAbilityAvailable(owner, AltairSwordAbility[slot], form == Altair_FormSword)
                set slot = slot + 1
            endloop
            if form == Altair_FormHolopsicon then
                call SetToggle(false)
            endif
            set shownStacks = -1
            set owner = null
        endmethod

        method SwitchForm takes integer newForm returns nothing
            local integer slot = 0
            local real angle
            call ApplyForm(newForm)
            if newForm == Altair_FormSword then
                call Voice(11, "G", 1, 1)
            else
                call Voice(12, "GG", 1, 1)
            endif
            call BlzStartUnitAbilityCooldown(hero, AltairG_ID, Altair_SwitchLock)
            call BlzStartUnitAbilityCooldown(hero, AltairSG_ID, Altair_SwitchLock)
            call DestroyEffect(EffectSpawn(Altair_SwitchModel, GetUnitX(hero), GetUnitY(hero), GetUnitFacing(hero), 1.0, 1.2, 0.0))
            call DestroyEffect(EffectSpawn(Altair_ImageModel, GetUnitX(hero), GetUnitY(hero), GetUnitFacing(hero), 1.0, 1.4, 0.0))
            call AltairFade(EffectSpawnScale(Altair_RingModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.0, 0.5, 10.0, 0.3, 0.5, 2.5))
            if newForm == Altair_FormSword then
                // Endless swords burst out radially.
                loop
                    exitwhen slot >= AltairG_BurstBlades
                    set angle = slot*2.0*bj_PI/AltairG_BurstBlades
                    call AltairBlade_KS.Launch(hero, GetUnitX(hero), GetUnitY(hero), 90.0, angle, 1200.0, 260.0, 0.0, 0.0, null)
                    set slot = slot + 1
                endloop
            else
                call AltairFade(EffectSpawn(Altair_CircleModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.0, 1.2, 5.0))
            endif
            call SetUnitAnimation(hero, "spell")
        endmethod

        // Sword levels follow the learned Holopsicon slot; buttons grey out without stacks.
        method Refresh takes nothing returns nothing
            local integer slot = 0
            local integer level
            local boolean disable
            loop
                exitwhen slot > 4
                set level = GetUnitAbilityLevel(hero, AltairHoloAbility[slot])
                if level != holoLevel[slot] then
                    set holoLevel[slot] = level
                    if level > 0 and slot < 4 then
                        call SetUnitAbilityLevel(hero, AltairSwordAbility[slot], level)
                    endif
                endif
                set disable = level == 0 or stacks < SwordCost(slot)
                if disable != swordDisabled[slot] then
                    set swordDisabled[slot] = disable
                    call BlzUnitDisableAbility(hero, AltairSwordAbility[slot], disable, false)
                endif
                set slot = slot + 1
            endloop
            if stacks != shownStacks then
                set shownStacks = stacks
                call TasAbilityChargeBox_SetValue(hero, AltairSF_ID, I2S(stacks))
            endif
        endmethod

        method UpdateVisuals takes nothing returns nothing
            local integer slot = 0
            local real angle
            local real z = BlzGetUnitZ(hero)
            if fEffect != null then
                call BlzSetSpecialEffectPosition(fEffect, GetUnitX(hero), GetUnitY(hero), z)
            endif
            if swordToggle then
                set guardAngle = guardAngle + 0.06
                loop
                    exitwhen slot >= AltairSF_GuardBlades
                    set angle = guardAngle + slot*2.0*bj_PI/AltairSF_GuardBlades
                    call BlzSetSpecialEffectPosition(guard[slot], GetUnitX(hero) + AltairSF_GuardRadius*Cos(angle), GetUnitY(hero) + AltairSF_GuardRadius*Sin(angle), z + 90.0)
                    call BlzSetSpecialEffectYaw(guard[slot], angle)
                    set slot = slot + 1
                endloop
            endif
        endmethod

        method Activate takes nothing returns nothing
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            loop
                exitwhen index >= count
                set this = active[index]
                if GetUnitTypeId(hero) == 0 then
                    call SetToggle(false)
                    call DestroyEffect(fEffect)
                    set fEffect = null
                    call RemoveSavedInteger(AltairTable, GetHandleId(hero), 0)
                    set hero = null
                    set reflectTarget = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    if AltairAlive(hero) then
                        set stackTimer = stackTimer + 0.03
                        if stackTimer >= AltairSF_StackPeriod then
                            set stackTimer = stackTimer - AltairSF_StackPeriod
                            call AddStacks(1)
                        endif
                    endif
                    if seWindow > 0.0 then
                        set seWindow = seWindow - 0.03
                        if seWindow <= 0.0 then
                            set seCost = AltairSE_Cost
                        endif
                    endif
                    if fRemaining > 0.0 then
                        set fRemaining = fRemaining - 0.03
                    endif
                    if (fRemaining <= 0.0 or not AltairAlive(hero)) and fEffect != null then
                        set fRemaining = 0.0
                        call ColorEffDummy3(fEffect, 0.0, 255, 255, 255, 0.25)
                        set fEffect = null
                    endif
                    // Reflection is deferred out of the damage event that blocked it.
                    if reflectTarget != null then
                        if AltairIsEnemy(hero, reflectTarget) then
                            call DestroyEffect(AddSpecialEffectTarget(AltairW_EraseModel, reflectTarget, "chest"))
                            call DestroyEffect(EffectSpawn(AltairF_ReflectModel, GetUnitX(hero), GetUnitY(hero), Atan2(GetUnitY(reflectTarget) - GetUnitY(hero), GetUnitX(reflectTarget) - GetUnitX(hero))*bj_RADTODEG, 1.0, 1.0, 80.0))
                            call DamageSource(AltairF_ID)
                            call dmgmag(hero, reflectTarget, reflectAmount*AltairF_Reflect)
                            call Voice(10, "F", 3, 1)
                        endif
                        set reflectTarget = null
                        set reflectAmount = 0.0
                    endif
                    if refundAbility != 0 then
                        call BlzEndUnitAbilityCooldown(hero, refundAbility)
                        set refundAbility = 0
                    endif
                    if swordToggle and (stacks < AltairSF_AttackCost or not AltairAlive(hero)) then
                        call SetToggle(false)
                    endif
                    call UpdateVisuals()
                    call Refresh()
                    set index = index + 1
                endif
            endloop
        endmethod
    endstruct

    // ==================== Q: PPSH Spray ====================
    private struct AltairBullet_KS
        static integer array active
        static integer count = 0
        effect art
        real targetX
        real targetY
        real remaining
        real angle

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local real step = AltairQ_BulletSpeed*0.03
            loop
                exitwhen index >= count
                set this = active[index]
                set remaining = remaining - step
                if remaining <= 0.0 then
                    call DestroyEffect(art)
                    call DestroyEffect(EffectSpawn(AltairQ_HitModel, targetX, targetY, GetRandomReal(0.0, 359.0), 1.5, 0.5, 5.0))
                    if GetRandomInt(1, 3) == 1 then
                        call DestroyEffect(EffectSpawn(Altair_DustModel, targetX, targetY, GetRandomReal(0.0, 359.0), 1.5, 0.4, 0.0))
                    endif
                    set art = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    call BlzSetSpecialEffectX(art, BlzGetLocalSpecialEffectX(art) + step*Cos(angle))
                    call BlzSetSpecialEffectY(art, BlzGetLocalSpecialEffectY(art) + step*Sin(angle))
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Fire takes real x, real y, real hitX, real hitY returns nothing
            local thistype this = allocate()
            set targetX = hitX
            set targetY = hitY
            set angle = Atan2(hitY - y, hitX - x)
            set remaining = SquareRoot((hitX - x)*(hitX - x) + (hitY - y)*(hitY - y))
            set art = EffectSpawn(AltairQ_BulletModel, x, y, angle*bj_RADTODEG, 2.0, 0.8, 70.0)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    private struct AltairQ_KS
        static integer array active
        static integer count = 0
        unit hero
        real targetX
        real targetY
        real elapsed
        real shotTimer
        real flashTimer
        real damage
        boolean dealt

        method Hit takes nothing returns nothing
            local unit target
            call GroupEnumUnitsInRange(AltairGroup, targetX, targetY, AltairQ_Aoe, NoDecor_Cond)
            loop
                set target = FirstOfGroup(AltairGroup)
                exitwhen target == null
                call GroupRemoveUnit(AltairGroup, target)
                if AltairIsEnemy(hero, target) then
                    call DamageSource(AltairQ_ID)
                    call dmgphys(hero, target, damage)
                    call StunUnit(hero, target, AltairQ_Stun)
                    call DestroyEffect(AddSpecialEffectTarget(AltairQ_HitModel, target, "chest"))
                endif
            endloop
            call DecorRemove(hero, targetX, targetY, AltairQ_Aoe, damage)
            set dealt = true
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local real distance
            local real angle
            local real muzzleX
            local real muzzleY
            loop
                exitwhen index >= count
                set this = active[index]
                set elapsed = elapsed + 0.03
                set angle = GAngle2(hero, targetX, targetY)
                set muzzleX = GetUnitX(hero) + 75.0*Cos(angle)
                set muzzleY = GetUnitY(hero) + 75.0*Sin(angle)
                if not dealt and elapsed >= AltairQ_DamageDelay then
                    call Hit()
                endif
                set shotTimer = shotTimer + 0.03
                loop
                    exitwhen shotTimer < AltairQ_ShotPeriod
                    set shotTimer = shotTimer - AltairQ_ShotPeriod
                    set distance = AltairQ_Aoe*SquareRoot(GetRandomReal(0.0, 1.0))
                    set angle = GetRandomReal(0.0, 2.0*bj_PI)
                    call AltairBullet_KS.Fire(muzzleX, muzzleY, targetX + distance*Cos(angle), targetY + distance*Sin(angle))
                endloop
                set flashTimer = flashTimer + 0.03
                if flashTimer >= 0.12 then
                    set flashTimer = 0.0
                    set angle = GAngle2(hero, targetX, targetY)
                    call DestroyEffect(EffectSpawn(AltairQ_MuzzleModel, muzzleX, muzzleY, angle*bj_RADTODEG, 2.0, 0.35, 90.0))
                    call DestroyEffect(EffectSpawn(AltairQ_FlashModel, muzzleX, muzzleY, angle*bj_RADTODEG, 1.5, 0.8, 90.0))
                endif
                if elapsed >= AltairQ_SprayTime or not AltairAlive(hero) then
                    if not dealt then
                        call Hit()
                    endif
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Start takes unit caster, real positionX, real positionY returns nothing
            local thistype this = allocate()
            local integer level = IMaxBJ(1, GetUnitAbilityLevel(caster, AltairQ_ID))
            set hero = caster
            set targetX = positionX
            set targetY = positionY
            set elapsed = 0.0
            set shotTimer = AltairQ_ShotPeriod
            set flashTimer = 0.12
            set dealt = false
            set damage = GetHeroInt(hero, true)*(AltairQ_DamageIntBase + AltairQ_DamageIntStep*(level - 1)) + AltairQ_DamageStatic + AltairQ_DamageStaticStep*(level - 1)
            call SetUnitFacing(hero, GAngle2(hero, targetX, targetY)*bj_RADTODEG)
            call SetUnitAnimation(hero, "attack")
            call AltairFade(EffectSpawn(Altair_CircleModel, targetX, targetY, 0.0, 2.0, AltairQ_Aoe/220.0, 5.0))
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    // ==================== W: free block granted by the Third Movement ====================
    private struct AltairWBlock_KS
        static integer array active
        static integer count = 0
        unit target
        real remaining
        effect art

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            loop
                exitwhen index >= count
                set this = active[index]
                set remaining = remaining - 0.03
                if remaining <= 0.0 or not AltairAlive(target) then
                    call DestroyEffect(art)
                    call RemoveSavedInteger(AltairTable, GetHandleId(target), 1)
                    set art = null
                    set target = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Grant takes unit whichUnit, real duration returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(whichUnit), 1)
            if this == 0 then
                set this = allocate()
                set target = whichUnit
                set remaining = 0.0
                set art = AddSpecialEffectTarget(AltairW_BlockModel, target, "overhead")
                call SaveInteger(AltairTable, GetHandleId(target), 1, this)
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
            endif
            set remaining = RMaxBJ(remaining, duration)
        endmethod

        static method Consume takes unit whichUnit returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(whichUnit), 1)
            if this == 0 or remaining <= 0.0 then
                return false
            endif
            set remaining = 0.0
            call AltairFade(AddSpecialEffectTarget(Altair_RingModel, target, "origin"))
            return true
        endmethod
    endstruct

    // ==================== W: dash to an ally or an enemy ====================
    private struct AltairW_KS
        static integer array active
        static integer count = 0
        unit hero
        unit target
        boolean ally
        integer level
        real elapsed
        real trailTimer

        method Arrive takes nothing returns nothing
            local real duration = AltairW_Duration + AltairW_DurationStep*(level - 1)
            local real x = GetUnitX(target)
            local real y = GetUnitY(target)
            if ally then
                // Third Movement: the plot element is rewritten into flowers.
                call UnitRemoveBuffs(target, false, true)
                call AltairWBlock_KS.Grant(target, duration)
                call HPS(hero, target, GetHeroInt(hero, true)*(AltairW_HealIntBase + AltairW_HealIntStep*(level - 1)), duration)
                call DestroyEffect(EffectSpawn(AltairW_PetalModel, x, y, GetRandomReal(0.0, 359.0), 1.0, 1.6, 0.0))
                call DestroyEffect(EffectSpawn(AltairW_PetalModel, x, y, GetRandomReal(0.0, 359.0), 1.3, 1.1, 60.0))
                call DestroyEffect(AddSpecialEffectTarget(AltairW_AllyModel, target, "origin"))
                call AltairFade(EffectSpawn(Altair_CircleModel, x, y, 0.0, 1.0, 0.8, 5.0))
            elseif AltairIsEnemy(hero, target) then
                // Ninth Movement: every buff, shields included, is erased.
                call UnitRemoveBuffs(target, true, false)
                call AltairWBlock_KS.Consume(target)
                call SaveInteger(hs, GetHandleId(target), KEY_SHIELD, 0)
                call DestroyEffect(EffectSpawn(AltairW_EraseModel, x, y, GetRandomReal(0.0, 359.0), 1.0, 1.3, 0.0))
                call DestroyEffect(EffectSpawn(Altair_DarkImageModel, x, y, GetUnitFacing(target), 1.0, 1.3, 0.0))
                call DamageSource(AltairW_ID)
                call dmgmag(hero, target, GetHeroInt(hero, true)*(AltairW_DamageIntBase + AltairW_DamageIntStep*(level - 1)) + AltairW_DamageStatic + AltairW_DamageStaticStep*(level - 1))
            endif
            call DestroyEffect(EffectSpawn(Altair_SlashModel, x, y, GetUnitFacing(hero), 1.5, 0.8, 60.0))
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local real distance
            local real angle
            local real step
            local boolean finished
            loop
                exitwhen index >= count
                set this = active[index]
                set elapsed = elapsed + 0.03
                set finished = elapsed >= AltairW_MaxDashTime or not AltairAlive(target) or not AltairAlive(hero)
                if not finished then
                    set distance = SR2(hero, target)
                    set angle = GAngle(hero, target)
                    if distance <= AltairW_ContactRange then
                        call Arrive()
                        set finished = true
                    else
                        set step = RMinBJ(AltairW_Speed*0.03, distance - AltairW_ContactRange*0.5)
                        if PathableCheck(GetUnitX(hero) + step*Cos(angle), GetUnitY(hero) + step*Sin(angle)) then
                            call SetUnitX(hero, GetUnitX(hero) + step*Cos(angle))
                            call SetUnitY(hero, GetUnitY(hero) + step*Sin(angle))
                        endif
                        call SetUnitFacing(hero, angle*bj_RADTODEG)
                        set trailTimer = trailTimer + 0.03
                        if trailTimer >= 0.06 then
                            set trailTimer = 0.0
                            // After-images: white for an ally, black for an enemy.
                            if ally then
                                call DestroyEffect(EffectSpawn(Altair_ImageModel, GetUnitX(hero), GetUnitY(hero), angle*bj_RADTODEG, 1.5, 1.0, 0.0))
                            else
                                call DestroyEffect(EffectSpawn(Altair_DarkImageModel, GetUnitX(hero), GetUnitY(hero), angle*bj_RADTODEG, 1.5, 1.0, 0.0))
                            endif
                        endif
                    endif
                endif
                if finished then
                    call StopSpellUnit2(hero)
                    set hero = null
                    set target = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Start takes unit caster, unit whichTarget returns boolean
            local thistype this
            if whichTarget == null or whichTarget == caster then
                return false
            endif
            set this = allocate()
            set hero = caster
            set target = whichTarget
            set ally = IsUnitAlly(target, GetOwningPlayer(hero))
            set level = IMaxBJ(1, GetUnitAbilityLevel(hero, AltairW_ID))
            set elapsed = 0.0
            set trailTimer = 0.0
            call StartSpellUnit2(hero)
            call SetUnitAnimation(hero, "spell")
            call DestroyEffect(EffectSpawn(Altair_SwitchModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.5, 0.8, 0.0))
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
            return true
        endmethod
    endstruct

    // ==================== E: Outline Origin ====================
    private function AltairE_RestoreDecor takes nothing returns nothing
        local destructable decor = GetEnumDestructable()
        local real dx = GetDestructableX(decor) - AltairEnumX
        local real dy = GetDestructableY(decor) - AltairEnumY
        if GetDestructableLife(decor) <= 0.405 and dx*dx + dy*dy <= AltairEnumRadius*AltairEnumRadius and AltairDecorIndex(GetDestructableTypeId(decor)) >= 0 then
            call DestructableRestoreLife(decor, GetDestructableMaxLife(decor), true)
            call AltairFade(EffectSpawn(Altair_CircleModel, GetDestructableX(decor), GetDestructableY(decor), 0.0, 1.0, 0.6, 10.0))
            call AltairFade(EffectSpawn(AltairE_ClockModel, GetDestructableX(decor), GetDestructableY(decor), 0.0, 1.5, 0.8, 40.0))
        endif
        set decor = null
    endfunction

    private struct AltairE_KS
        static integer array active
        static integer count = 0
        unit hero
        effect sword
        real elapsed
        boolean released

        static method ReduceCooldowns takes unit target returns nothing
            local integer index = 0
            local ability spell = BlzGetUnitAbilityByIndex(target, 0)
            loop
                exitwhen spell == null
                call ReduceCooldown(target, BlzGetAbilityId(spell), AltairE_CooldownReduction)
                set index = index + 1
                set spell = BlzGetUnitAbilityByIndex(target, index)
            endloop
            set spell = null
        endmethod

        method Release takes nothing returns nothing
            local integer level = IMaxBJ(1, GetUnitAbilityLevel(hero, AltairE_ID))
            local real damage = GetHeroInt(hero, true)*(AltairE_DamageIntBase + AltairE_DamageIntStep*(level - 1))
            local real x = GetUnitX(hero)
            local real y = GetUnitY(hero)
            local effect sphere = EffectSpawn(AltairE_SphereModel, x, y, 0.0, 1.0, AltairE_SphereScale, 0.0)
            local unit target
            set released = true
            call ColorEffDummy3(sword, 0.0, 255, 255, 255, 0.2)
            set sword = null
            call ColorEffDummy3(sphere, AltairE_VisualTime - 0.4, 255, 255, 255, 0.4)
            call AltairFade(EffectSpawnScale(AltairE_ClockModel, x, y, 0.0, 1.0, 0.5, 5.0, 0.4, 0.5, AltairE_ClockScale))
            call AltairFade(EffectSpawnScale(Altair_RingModel, x, y, 0.0, 1.0, 0.5, 10.0, 0.35, 0.5, AltairE_Aoe/120.0))
            call GroupEnumUnitsInRange(AltairGroup, x, y, AltairE_Aoe, NoDecor_Cond)
            loop
                set target = FirstOfGroup(AltairGroup)
                exitwhen target == null
                call GroupRemoveUnit(AltairGroup, target)
                if target != hero and AltairAlive(target) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) then
                    // Every ally and enemy returns to its origin: 5 sec off all cooldowns.
                    call ReduceCooldowns(target)
                    call AltairFade(AddSpecialEffectTarget(AltairE_ClockModel, target, "overhead"))
                    if AltairIsEnemy(hero, target) then
                        call DamageSource(AltairE_ID)
                        call dmgmag(hero, target, damage)
                        call DestroyEffect(AddSpecialEffectTarget(Altair_StampedeModel, target, "chest"))
                    endif
                endif
            endloop
            set AltairEnumX = x
            set AltairEnumY = y
            set AltairEnumRadius = AltairE_Aoe
            call SetRect(AltairEnumRect, x - AltairE_Aoe, y - AltairE_Aoe, x + AltairE_Aoe, y + AltairE_Aoe)
            call EnumDestructablesInRect(AltairEnumRect, null, function AltairE_RestoreDecor)
            set sphere = null
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            loop
                exitwhen index >= count
                set this = active[index]
                set elapsed = elapsed + 0.03
                if not released and elapsed >= AltairE_StringTime then
                    call Release()
                endif
                if released or not AltairAlive(hero) then
                    if sword != null then
                        call DestroyEffect(sword)
                        set sword = null
                    endif
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Start takes unit caster returns nothing
            local thistype this = allocate()
            set hero = caster
            set elapsed = 0.0
            set released = false
            // The PPSH is strung with a sword before the aura is released.
            set sword = EffectSpawn(Altair_SwordModel, GetUnitX(hero) + 60.0*Cos(GetUnitFacing(hero)*bj_DEGTORAD), GetUnitY(hero) + 60.0*Sin(GetUnitFacing(hero)*bj_DEGTORAD), GetUnitFacing(hero), 1.0, 0.2, 110.0)
            call SetUnitAnimation(hero, "spell")
            call AltairFade(EffectSpawn(Altair_CircleModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.0, 1.5, 5.0))
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    // ==================== R: Factor Mimic ====================
    private function AltairR_CollectDecor takes nothing returns nothing
        local destructable decor = GetEnumDestructable()
        local real dx = GetDestructableX(decor) - AltairEnumX
        local real dy = GetDestructableY(decor) - AltairEnumY
        local integer id = GetDestructableTypeId(decor)
        if AltairRCandidateCount < 64 and GetDestructableLife(decor) > 0.405 and dx*dx + dy*dy <= AltairEnumRadius*AltairEnumRadius then
            if AltairDecorIndex(id) >= 0 or (id == AltairR_TrainDecorID and AltairEnumTrain) then
                set AltairRCandidate[AltairRCandidateCount] = decor
                set AltairRCandidateDistance[AltairRCandidateCount] = dx*dx + dy*dy
                set AltairRCandidateCount = AltairRCandidateCount + 1
            endif
        endif
        set decor = null
    endfunction

    // The train dummies have Locust, so range enumeration cannot see them.
    private function AltairR_TrainKind takes real positionX, real positionY returns integer
        local unit train
        local integer kind = AltairR_KindMetro
        local real best = AltairR_TrainSearch*AltairR_TrainSearch
        local real dx
        local real dy
        call GroupEnumUnitsOfPlayer(AltairGroup, Player(PLAYER_NEUTRAL_PASSIVE), null)
        loop
            set train = FirstOfGroup(AltairGroup)
            exitwhen train == null
            call GroupRemoveUnit(AltairGroup, train)
            if GetUnitTypeId(train) == AltairR_TrainMetroID or GetUnitTypeId(train) == AltairR_TrainThomasID then
                set dx = GetUnitX(train) - positionX
                set dy = GetUnitY(train) - positionY
                if dx*dx + dy*dy <= best then
                    set best = dx*dx + dy*dy
                    if GetUnitTypeId(train) == AltairR_TrainThomasID then
                        set kind = AltairR_KindThomas
                    else
                        set kind = AltairR_KindMetro
                    endif
                endif
            endif
        endloop
        return kind
    endfunction

    // One copy: leaves the portal together with the others, smashes everything on its way, then lands.
    private struct AltairRMissile_KS
        static integer array active
        static integer count = 0
        unit hero
        effect art
        group path
        integer kind
        integer level
        integer throwKey
        real startX
        real startY
        real startZ
        real targetX
        real targetY
        real delay
        real elapsed
        real duration
        real yaw
        real spin
        real damage

        method Impact takes nothing returns nothing
            local integer weight = AltairKindWeight(kind)
            local integer decorId = AltairKindDecorId(kind)
            local real aoe = 220.0
            local real hitDamage = damage
            local real stun = 0.3
            local integer hits
            local unit target
            if weight == 2 then
                set aoe = 280.0
            elseif weight == 3 then
                set aoe = 360.0
                set stun = 0.5
            elseif weight == 4 then
                set aoe = 500.0
                set stun = 1.5
                call DestroyEffect(EffectSpawn(AltairR_TrainSlashModel, targetX, targetY, GetRandomReal(0.0, 359.0), 1.0, 1.33, 1.0))
                call DestroyEffect(EffectSpawn(AltairR_TrainImpactModel, targetX, targetY, GetRandomReal(0.0, 359.0), 1.0, 2.0, 1.0))
            endif
            if decorId == 'B00O' then // explosive barrel
                set aoe = aoe + 80.0
                set hitDamage = hitDamage*1.5
                call DestroyEffect(EffectSpawn(AltairR_BarrelModel, targetX, targetY, 0.0, 1.0, 0.65, 1.0))
            elseif decorId == 'B00T' then // hydrant
                call DestroyEffect(EffectSpawn(AltairR_HydrantModel, targetX, targetY, GetRandomReal(0.0, 359.0), 0.75, 1.25, 1.0))
            elseif decorId == 'B00S' or decorId == 'B00X' or decorId == 'B00Y' or decorId == 'B014' then // metal
                call DestroyEffect(EffectSpawn(AltairR_MetalModel, targetX, targetY, GetRandomReal(0.0, 359.0), 0.4, 2.15, 51.0))
            endif
            call DestroyEffect(EffectSpawn(AltairR_ImpactModel, targetX, targetY, GetRandomReal(0.0, 359.0), 1.0, 0.6 + 0.3*weight, 1.0))
            call DestroyEffect(EffectSpawn(Altair_DustModel, targetX, targetY, GetRandomReal(0.0, 359.0), 1.0, 0.7 + 0.3*weight, 1.0))
            call AltairFade(EffectSpawnScale(Altair_RingModel, targetX, targetY, 0.0, 1.0, 0.5, 10.0, 0.25, 0.5, aoe/100.0))
            call GroupEnumUnitsInRange(AltairGroup, targetX, targetY, aoe, NoDecor_Cond)
            loop
                set target = FirstOfGroup(AltairGroup)
                exitwhen target == null
                call GroupRemoveUnit(AltairGroup, target)
                if AltairIsEnemy(hero, target) then
                    // Several copies landing on one enemy overload it.
                    set hits = LoadInteger(AltairTable, throwKey, GetHandleId(target)) + 1
                    call SaveInteger(AltairTable, throwKey, GetHandleId(target), hits)
                    call DamageSource(AltairR_ID)
                    call dmgphys(hero, target, hitDamage)
                    call StunUnit(hero, target, RMinBJ(AltairR_MaxStun, stun + AltairR_OverloadStun*(hits - 1)))
                    call DestroyEffect(AddSpecialEffectTarget(Altair_StampedeModel, target, "chest"))
                    if decorId == 'B00T' then
                        call MUE(target, AltairR_HydrantPush, 0.42, Atan2(GetUnitY(target) - targetY, GetUnitX(target) - targetX))
                    endif
                endif
            endloop
            call DecorRemove(hero, targetX, targetY, aoe, hitDamage)
        endmethod

        // Everything on the flight path is broken: decor and enemies (once per copy).
        method Smash takes real x, real y returns nothing
            local real width = 80.0 + 40.0*AltairKindWeight(kind)
            local unit target
            call DecorRemove(hero, x, y, width, damage)
            call GroupEnumUnitsInRange(AltairGroup, x, y, width, NoDecor_Cond)
            loop
                set target = FirstOfGroup(AltairGroup)
                exitwhen target == null
                call GroupRemoveUnit(AltairGroup, target)
                if AltairIsEnemy(hero, target) and not IsUnitInGroup(target, path) then
                    call GroupAddUnit(path, target)
                    call DamageSource(AltairR_ID)
                    call dmgphys(hero, target, damage*AltairR_PathDamage)
                    call DestroyEffect(AddSpecialEffectTarget(Altair_HitModel, target, "chest"))
                endif
            endloop
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local real progress
            local real positionX
            local real positionY
            local integer remainingCopies
            loop
                exitwhen index >= count
                set this = active[index]
                if delay > 0.0 then
                    set delay = delay - 0.03
                    if delay <= 0.0 then
                        set art = AddSpecialEffect(AltairKindModel(kind), startX, startY)
                        call BlzSetSpecialEffectScale(art, AltairKindScale(kind)*0.7)
                        call BlzSetSpecialEffectZ(art, startZ)
                        call DestroyEffect(EffectSpawn(Altair_SwitchModel, startX, startY, 0.0, 1.5, 0.7, startZ - AltairGroundZ(startX, startY)))
                    endif
                    set index = index + 1
                else
                    set elapsed = elapsed + 0.03
                    set progress = RMinBJ(1.0, elapsed/duration)
                    set positionX = startX + (targetX - startX)*progress
                    set positionY = startY + (targetY - startY)*progress
                    // Light and medium copies tumble; heavy ones fly flat, without spinning.
                    if AltairKindWeight(kind) < 3 then
                        set spin = spin + 0.22
                    endif
                    call BlzSetSpecialEffectPosition(art, positionX, positionY, startZ + (AltairGroundZ(targetX, targetY) - startZ)*progress + 4.0*AltairR_ArcHeight*progress*(1.0 - progress))
                    call BlzSetSpecialEffectOrientation(art, yaw, spin, 0.0)
                    call Smash(positionX, positionY)
                    if progress >= 1.0 then
                        call Impact()
                        call DestroyEffect(art)
                        call DestroyGroup(path)
                        set remainingCopies = LoadInteger(AltairTable, throwKey, 0) - 1
                        if remainingCopies <= 0 then
                            call FlushChildHashtable(AltairTable, throwKey)
                        else
                            call SaveInteger(AltairTable, throwKey, 0, remainingCopies)
                        endif
                        set art = null
                        set path = null
                        set hero = null
                        set count = count - 1
                        set active[index] = active[count]
                        call deallocate()
                        call GearTimer03Release()
                    else
                        set index = index + 1
                    endif
                endif
            endloop
        endmethod

        static method Launch takes unit caster, integer copyKind, real fromX, real fromY, real fromZ, real positionX, real positionY, real delayTime, integer key returns nothing
            local thistype this = allocate()
            local integer weight = AltairKindWeight(copyKind)
            set hero = caster
            set kind = copyKind
            set level = IMaxBJ(1, GetUnitAbilityLevel(caster, AltairR_ID))
            set throwKey = key
            set startX = fromX
            set startY = fromY
            set startZ = fromZ
            set targetX = positionX
            set targetY = positionY
            set delay = RMaxBJ(0.03, delayTime)
            set elapsed = 0.0
            set duration = RMaxBJ(0.3, SquareRoot((targetX - startX)*(targetX - startX) + (targetY - startY)*(targetY - startY))/AltairR_ThrowSpeed)
            set yaw = Atan2(targetY - startY, targetX - startX)
            // The Metro model faces backwards (RoundEnd turns it by 180 degrees).
            if copyKind == AltairR_KindMetro then
                set yaw = yaw + bj_PI
            endif
            set spin = 0.0
            if weight >= 3 then
                set spin = AltairR_HeavyTilt
                if copyKind == AltairR_KindMetro then
                    set spin = -AltairR_HeavyTilt
                endif
            endif
            set art = null
            set path = CreateGroup()
            set damage = GetHeroInt(caster, true)*(AltairR_DamageIntBase + AltairR_DamageIntStep*(level - 1)) + AltairR_DamageStatic + AltairR_DamageStaticStep*(level - 1)
            if weight == 2 then
                set damage = damage*1.4
            elseif weight == 3 then
                set damage = damage*2.0
            elseif weight == 4 then
                set damage = damage*3.0
            endif
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    private struct AltairR_KS
        static integer array active
        static integer count = 0
        unit hero
        integer stored
        integer array kind[24]
        effect array copy[24]
        real array fromX[24]
        real array fromY[24]
        real window
        real orbit
        real absorbTime

        method UpdateCopies takes nothing returns nothing
            local integer slot = 0
            local real angle
            local real progress = RMinBJ(1.0, absorbTime/AltairR_CopyFlyTime)
            local real positionX
            local real positionY
            loop
                exitwhen slot >= stored
                set angle = orbit + slot*2.0*bj_PI/stored
                set positionX = GetUnitX(hero) + AltairR_CopyRadius*Cos(angle)
                set positionY = GetUnitY(hero) + AltairR_CopyRadius*Sin(angle)
                // Fresh copies fly from the destroyed object into the orbit.
                set positionX = fromX[slot] + (positionX - fromX[slot])*progress
                set positionY = fromY[slot] + (positionY - fromY[slot])*progress
                call BlzSetSpecialEffectPosition(copy[slot], positionX, positionY, BlzGetUnitZ(hero) + AltairR_CopyHeight*progress + 40.0)
                call BlzSetSpecialEffectYaw(copy[slot], angle)
                set slot = slot + 1
            endloop
        endmethod

        method Release takes nothing returns nothing
            local integer slot = 0
            loop
                exitwhen slot >= stored
                call DestroyEffect(EffectSpawn(Altair_SwitchModel, BlzGetLocalSpecialEffectX(copy[slot]), BlzGetLocalSpecialEffectY(copy[slot]), 0.0, 1.5, 0.5, AltairR_CopyHeight))
                call DestroyEffect(copy[slot])
                set copy[slot] = null
                set slot = slot + 1
            endloop
            set stored = 0
            call RemoveSavedInteger(AltairTable, GetHandleId(hero), 2)
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            loop
                exitwhen index >= count
                set this = active[index]
                set window = window - 0.03
                set orbit = orbit + 0.06
                set absorbTime = absorbTime + 0.03
                if stored == 0 or window <= 0.0 or not AltairAlive(hero) then
                    if stored > 0 then
                        call BlzStartUnitAbilityCooldown(hero, AltairR_ID, AltairR_Cooldown)
                    endif
                    call Release()
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    call UpdateCopies()
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Absorb takes unit caster, real positionX, real positionY returns boolean
            local thistype this
            local integer best
            local integer slot
            local integer id
            local boolean trainTaken = false
            local destructable decor
            local real decorX
            local real decorY
            call AltairFade(EffectSpawn(Altair_CircleModel, positionX, positionY, 0.0, 1.0, AltairR_Aoe/160.0, 5.0))
            set AltairEnumX = positionX
            set AltairEnumY = positionY
            set AltairEnumRadius = AltairR_Aoe
            set AltairEnumTrain = GetHeroLevel(caster) >= AltairR_TrainHeroLevel
            set AltairRCandidateCount = 0
            call SetRect(AltairEnumRect, positionX - AltairR_Aoe, positionY - AltairR_Aoe, positionX + AltairR_Aoe, positionY + AltairR_Aoe)
            call EnumDestructablesInRect(AltairEnumRect, null, function AltairR_CollectDecor)
            if AltairRCandidateCount == 0 then
                return false
            endif
            set this = allocate()
            set hero = caster
            set stored = 0
            set window = AltairR_Window
            set orbit = 0.0
            set absorbTime = 0.0
            call SetUnitAnimation(hero, "spell")
            loop
                exitwhen stored >= AltairR_MaxCopies or AltairRCandidateCount == 0
                set best = 0
                set slot = 1
                loop
                    exitwhen slot >= AltairRCandidateCount
                    if AltairRCandidateDistance[slot] < AltairRCandidateDistance[best] then
                        set best = slot
                    endif
                    set slot = slot + 1
                endloop
                set decor = AltairRCandidate[best]
                set id = GetDestructableTypeId(decor)
                if id != AltairR_TrainDecorID or not trainTaken then
                    set decorX = GetDestructableX(decor)
                    set decorY = GetDestructableY(decor)
                    if id == AltairR_TrainDecorID then
                        set trainTaken = true
                        set kind[stored] = AltairR_TrainKind(decorX, decorY)
                    else
                        set kind[stored] = AltairDecorIndex(id)
                    endif
                    // A marker under the object, the original breaks, a perfect copy is stored.
                    // Destroyed decor returns on the round reset (DecorRestore) or by Outline Origin.
                    call AltairFade(EffectSpawn(Altair_CircleModel, decorX, decorY, 0.0, 1.5, 0.4 + 0.25*AltairKindWeight(kind[stored]), 8.0))
                    call AltairFade(EffectSpawnScale(Altair_RingModel, decorX, decorY, 0.0, 1.0, 0.3, 20.0, 0.3, 0.3, 1.5))
                    call KillDestructable(decor)
                    set fromX[stored] = decorX
                    set fromY[stored] = decorY
                    set copy[stored] = AddSpecialEffect(AltairKindModel(kind[stored]), decorX, decorY)
                    call BlzSetSpecialEffectScale(copy[stored], AltairKindScale(kind[stored])*AltairR_CopyScale)
                    call BlzSetSpecialEffectColor(copy[stored], 120, 190, 255)
                    call BlzSetSpecialEffectAlpha(copy[stored], 210)
                    set stored = stored + 1
                endif
                set AltairRCandidateCount = AltairRCandidateCount - 1
                set AltairRCandidate[best] = AltairRCandidate[AltairRCandidateCount]
                set AltairRCandidateDistance[best] = AltairRCandidateDistance[AltairRCandidateCount]
                set AltairRCandidate[AltairRCandidateCount] = null
            endloop
            loop
                exitwhen AltairRCandidateCount == 0
                set AltairRCandidateCount = AltairRCandidateCount - 1
                set AltairRCandidate[AltairRCandidateCount] = null
            endloop
            set decor = null
            call SaveInteger(AltairTable, GetHandleId(hero), 2, this)
            call AltairState(LoadInteger(AltairTable, GetHandleId(hero), 0)).Voice(4, "R", 1, 1)
            call UpdateCopies()
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
            return true
        endmethod

        // A blue portal opens behind her; every copy leaves it at once towards the point.
        method Throw takes real positionX, real positionY returns nothing
            local integer slot = 0
            local integer key
            local real angle = GAngle2(hero, positionX, positionY)
            local real portalX = GetUnitX(hero) - 90.0*Cos(angle)
            local real portalY = GetUnitY(hero) - 90.0*Sin(angle)
            local real portalZ = AltairGroundZ(portalX, portalY) + AltairR_PortalHeight
            local real offset
            local effect portal = AltairPortal(portalX, portalY, AltairR_PortalHeight, angle, AltairR_PortalScale, 60, 150, 255)
            call ColorEffDummy3(portal, AltairR_PortalLife + stored*AltairR_ThrowStagger, 255, 255, 255, 0.3)
            call AltairFade(EffectSpawnScale(Altair_RingModel, portalX, portalY, 0.0, 1.0, 0.4, AltairR_PortalHeight, 0.3, 0.4, 2.5))
            call AltairState(LoadInteger(AltairTable, GetHandleId(hero), 0)).Voice(5, "R", 2, 2)
            set AltairRThrowCounter = AltairRThrowCounter + 1
            // Negative parent keys cannot collide with unit handle ids.
            set key = -AltairRThrowCounter
            call SaveInteger(AltairTable, key, 0, stored)
            call SetUnitFacing(hero, angle*bj_RADTODEG)
            call SetUnitAnimation(hero, "spell")
            loop
                exitwhen slot >= stored
                set offset = GetRandomReal(-AltairR_PortalSpread, AltairR_PortalSpread)
                call AltairRMissile_KS.Launch(hero, kind[slot], portalX + offset*Cos(angle + bj_PI/2.0), portalY + offset*Sin(angle + bj_PI/2.0), portalZ, positionX + offset*0.6*Cos(angle + bj_PI/2.0), positionY + offset*0.6*Sin(angle + bj_PI/2.0), AltairR_PortalOpen + slot*AltairR_ThrowStagger, key)
                set slot = slot + 1
            endloop
            call BlzStartUnitAbilityCooldown(hero, AltairR_ID, AltairR_Cooldown)
            call Release()
            set portal = null
        endmethod

        static method Start takes unit caster, real positionX, real positionY returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(caster), 2)
            if this != 0 and stored > 0 then
                call Throw(positionX, positionY)
                return true
            endif
            return Absorb(caster, positionX, positionY)
        endmethod
    endstruct

    // ==================== T: Fate Reconstruction ====================
    private struct AltairT_KS
        static integer array active
        static integer count = 0
        unit hero
        rect realm
        real portalX
        real portalY
        effect portal
        effect ground
        effect gate // mirror gate inside the realm
        real remaining
        real total
        real pullTime
        boolean relocated
        group members
        group pulling
        integer memberCount

        method CanEnter takes unit target returns boolean
            return target != hero and AltairAlive(target) and IsUnitType(target, UNIT_TYPE_HERO) and GetUnitAbilityLevel(target, 'Aloc') == 0 and not IsUnitInGroup(target, members) and not IsUnitInGroup(target, pulling) and not CheckCoordsInRect(realm, GetUnitX(target), GetUnitY(target))
        endmethod

        method AddMember takes unit target returns nothing
            local real angle = GetRandomReal(0.0, 2.0*bj_PI)
            local real distance = GetRandomReal(0.0, AltairT_RealmSpread)
            call DestroyEffect(EffectSpawn(AltairT_TeleportModel, GetUnitX(target), GetUnitY(target), 0.0, 1.0, 1.0, 0.0))
            call GroupAddUnit(members, target)
            call SetUnitPosition(target, GetRectCenterX(realm) + distance*Cos(angle), GetRectCenterY(realm) + distance*Sin(angle))
            call DestroyEffect(EffectSpawn(AltairT_TeleportModel, GetUnitX(target), GetUnitY(target), 0.0, 1.0, 1.0, 0.0))
            call DestroyEffect(EffectSpawn(Altair_ImageModel, GetUnitX(target), GetUnitY(target), GetUnitFacing(target), 1.0, 1.2, 0.0))
            if GetLocalPlayer() == GetOwningPlayer(target) then
                call PanCameraToTimed(GetUnitX(target), GetUnitY(target), 0.0)
            endif
        endmethod

        method Pull takes unit target returns nothing
            call GroupAddUnit(pulling, target)
            set memberCount = memberCount + 1
            call AltairFade(AddSpecialEffectTarget(Altair_RingModel, target, "origin"))
        endmethod

        method End takes nothing returns nothing
            local integer slot = 0
            local unit target
            loop
                set target = FirstOfGroup(pulling)
                exitwhen target == null
                call GroupRemoveUnit(pulling, target)
            endloop
            loop
                set target = FirstOfGroup(members)
                exitwhen target == null
                call GroupRemoveUnit(members, target)
                if GetUnitTypeId(target) != 0 then
                    call SetUnitPosition(target, portalX + 130.0*Cos(slot*bj_PI/2.0), portalY + 130.0*Sin(slot*bj_PI/2.0))
                    call DestroyEffect(EffectSpawn(AltairT_TeleportModel, GetUnitX(target), GetUnitY(target), 0.0, 1.0, 1.0, 0.0))
                    if GetLocalPlayer() == GetOwningPlayer(target) then
                        call PanCameraToTimed(GetUnitX(target), GetUnitY(target), 0.0)
                    endif
                endif
                set slot = slot + 1
            endloop
            set memberCount = 0
            set remaining = 0.0
            call ColorEffDummy3(portal, 0.0, 255, 255, 255, 0.4)
            call ColorEffDummy3(ground, 0.0, 255, 255, 255, 0.4)
            call ColorEffDummy3(gate, 0.0, 255, 255, 255, 0.4)
            call AltairFade(EffectSpawnScale(Altair_RingModel, portalX, portalY, 0.0, 1.0, 0.5, 10.0, 0.35, 0.5, 4.0))
            set portal = null
            set ground = null
            set gate = null
            call WUI_HeroProgress(hero, AltairT_ID, "Fate Reconstruction", 0.0, 0.0, true)
            call AltairState(LoadInteger(AltairTable, GetHandleId(hero), 0)).Voice(8, "T", 5, 1)
            call BlzStartUnitAbilityCooldown(hero, AltairT_ID, AltairT_Cooldown)
            call RemoveSavedInteger(AltairTable, GetHandleId(hero), 3)
        endmethod

        // Members stay inside the realm; heroes walking into the open portal join while it has room.
        method Tick takes nothing returns nothing
            local integer slot = 0
            local unit target
            local real angle
            local real minX = GetRectMinX(realm) + 48.0
            local real minY = GetRectMinY(realm) + 48.0
            local real maxX = GetRectMaxX(realm) - 48.0
            local real maxY = GetRectMaxY(realm) - 48.0
            if pullTime > 0.0 then
                // The portal drags its victims in before they vanish.
                set pullTime = pullTime - 0.03
                loop
                    exitwhen slot >= BlzGroupGetSize(pulling)
                    set target = BlzGroupUnitAt(pulling, slot)
                    set angle = Atan2(portalY - GetUnitY(target), portalX - GetUnitX(target))
                    if SR3(target, portalX, portalY) > 30.0 then
                        call SetUnitX(target, GetUnitX(target) + 30.0*Cos(angle))
                        call SetUnitY(target, GetUnitY(target) + 30.0*Sin(angle))
                    endif
                    set slot = slot + 1
                endloop
                if pullTime <= 0.0 then
                    if BlzGroupGetSize(pulling) > 0 then
                        call AltairState(LoadInteger(AltairTable, GetHandleId(hero), 0)).Voice(7, "T", 2, 3)
                    endif
                    loop
                        set target = FirstOfGroup(pulling)
                        exitwhen target == null
                        call GroupRemoveUnit(pulling, target)
                        if AltairAlive(target) then
                            call AddMember(target)
                        endif
                    endloop
                endif
            endif
            set slot = 0
            loop
                exitwhen slot >= BlzGroupGetSize(members)
                set target = BlzGroupUnitAt(members, slot)
                if AltairAlive(target) then
                    if GetUnitX(target) < minX or GetUnitX(target) > maxX or GetUnitY(target) < minY or GetUnitY(target) > maxY then
                        call SetUnitX(target, RMaxBJ(minX, RMinBJ(maxX, GetUnitX(target))))
                        call SetUnitY(target, RMaxBJ(minY, RMinBJ(maxY, GetUnitY(target))))
                    endif
                endif
                set slot = slot + 1
            endloop
            if memberCount < AltairT_MaxMembers then
                call GroupEnumUnitsInRange(AltairGroup, portalX, portalY, AltairT_EnterRadius, NoDecor_Cond)
                loop
                    set target = FirstOfGroup(AltairGroup)
                    exitwhen target == null
                    call GroupRemoveUnit(AltairGroup, target)
                    if memberCount < AltairT_MaxMembers and CanEnter(target) then
                        set memberCount = memberCount + 1
                        call AddMember(target)
                    endif
                endloop
            endif
            // The portal stays castable for one relocation; afterwards it waits for the realm.
            if not relocated and BlzGetUnitAbilityCooldownRemaining(hero, AltairT_ID) > 0.0 then
                call BlzEndUnitAbilityCooldown(hero, AltairT_ID)
            elseif relocated and BlzGetUnitAbilityCooldownRemaining(hero, AltairT_ID) < remaining then
                call BlzStartUnitAbilityCooldown(hero, AltairT_ID, remaining + 0.1)
            endif
            call WUI_HeroProgress(hero, AltairT_ID, "Fate Reconstruction", remaining, total, true)
            set target = null
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            loop
                exitwhen index >= count
                set this = active[index]
                if remaining > 0.0 then
                    set remaining = remaining - 0.03
                    if remaining <= 0.0 or not AltairAlive(hero) then
                        call End()
                    else
                        call Tick()
                    endif
                endif
                if remaining <= 0.0 then
                    call DestroyGroup(members)
                    call DestroyGroup(pulling)
                    set members = null
                    set pulling = null
                    set realm = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set index = index + 1
                endif
            endloop
        endmethod

        method PlacePortal takes real x, real y returns nothing
            local real facing = GAngle2(hero, x, y) + bj_PI
            set portalX = x
            set portalY = y
            set portal = AltairPortal(portalX, portalY, AltairT_PortalHeight, facing, AltairT_PortalScale, 255, 225, 150)
            set ground = EffectSpawn(AltairT_GroundModel, portalX, portalY, 0.0, 1.0, 2.2, 5.0)
            call AltairFade(EffectSpawnScale(Altair_RingModel, portalX, portalY, 0.0, 1.0, 0.5, 10.0, 0.35, 0.5, 4.0))
        endmethod

        static method Start takes unit caster, real positionX, real positionY returns boolean
            local thistype this = LoadInteger(AltairTable, GetHandleId(caster), 3)
            local unit target
            local unit nearest
            local real best
            local real distance
            if this != 0 then
                if relocated then
                    return false
                endif
                set relocated = true
                call ColorEffDummy3(portal, 0.0, 255, 255, 255, 0.3)
                call ColorEffDummy3(ground, 0.0, 255, 255, 255, 0.3)
                call PlacePortal(positionX, positionY)
                return true
            endif
            set this = allocate()
            set hero = caster
            set realm = gg_rct_AltairRealm
            // Kenjaku interaction: during an active Prison Realm the alternate world is the prison itself.
            static if LIBRARY_KenjakuSpells then
                call GroupEnumUnitsInRect(AltairGroup, gg_rct_Cage, null)
                loop
                    set target = FirstOfGroup(AltairGroup)
                    exitwhen target == null
                    call GroupRemoveUnit(AltairGroup, target)
                    if GetUnitAbilityLevel(target, KenjakuF2_Prison_Abi_ID) > 0 and AltairAlive(target) then
                        set realm = gg_rct_Cage
                    endif
                endloop
            endif
            set relocated = false
            set memberCount = 0
            set pullTime = AltairT_PullTime
            set members = CreateGroup()
            set pulling = CreateGroup()
            set total = AltairT_Duration
            if GetHeroLevel(hero) >= 35 then
                set total = total + AltairT_DurationLevel35
            endif
            set remaining = total
            call PlacePortal(positionX, positionY)
            call AltairState(LoadInteger(AltairTable, GetHandleId(hero), 0)).Voice(6, "T", 1, 1)
            set gate = AltairPortal(GetRectCenterX(realm), GetRectCenterY(realm), AltairT_PortalHeight, 0.0, AltairT_PortalScale*0.6, 255, 225, 150)
            call SetUnitAnimation(hero, "spell")
            // Nearest heroes first, up to the member limit.
            loop
                exitwhen memberCount >= AltairT_MaxMembers
                set nearest = null
                set best = 999999999.0
                call GroupEnumUnitsInRange(AltairGroup, portalX, portalY, AltairT_Aoe, NoDecor_Cond)
                loop
                    set target = FirstOfGroup(AltairGroup)
                    exitwhen target == null
                    call GroupRemoveUnit(AltairGroup, target)
                    if CanEnter(target) then
                        set distance = SR3(target, portalX, portalY)
                        if distance < best then
                            set best = distance
                            set nearest = target
                        endif
                    endif
                endloop
                exitwhen nearest == null
                call Pull(nearest)
            endloop
            call SaveInteger(AltairTable, GetHandleId(hero), 3, this)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
            set target = null
            set nearest = null
            return true
        endmethod

        static method EndFor takes unit caster returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(caster), 3)
            if this != 0 and remaining > 0.0 then
                call End()
            endif
        endmethod
    endstruct

    // ==================== SQ: Sword Rush ====================
    private struct AltairSQ_KS
        static integer array active
        static integer count = 0
        unit hero
        real angle
        real remaining
        real damage
        real trailTimer
        group hits
        effect left
        effect right

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local real step = AltairSQ_Speed*0.03
            local real nextX
            local real nextY
            local unit target
            loop
                exitwhen index >= count
                set this = active[index]
                set nextX = GetUnitX(hero) + step*Cos(angle)
                set nextY = GetUnitY(hero) + step*Sin(angle)
                if remaining <= 0.0 or not PathableCheck(nextX, nextY) or not AltairAlive(hero) then
                    call StopSpellUnit2(hero)
                    call DestroyEffect(EffectSpawn(Altair_SlashModel, GetUnitX(hero), GetUnitY(hero), angle*bj_RADTODEG, 1.5, 1.2, 60.0))
                    call ColorEffDummy3(left, 0.0, 255, 255, 255, 0.15)
                    call ColorEffDummy3(right, 0.0, 255, 255, 255, 0.15)
                    call DestroyGroup(hits)
                    set left = null
                    set right = null
                    set hits = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set remaining = remaining - step
                    call SetUnitX(hero, nextX)
                    call SetUnitY(hero, nextY)
                    call BlzSetSpecialEffectPosition(left, nextX + 70.0*Cos(angle + bj_PI/2.0), nextY + 70.0*Sin(angle + bj_PI/2.0), BlzGetUnitZ(hero) + 70.0)
                    call BlzSetSpecialEffectPosition(right, nextX + 70.0*Cos(angle - bj_PI/2.0), nextY + 70.0*Sin(angle - bj_PI/2.0), BlzGetUnitZ(hero) + 70.0)
                    set trailTimer = trailTimer + 0.03
                    if trailTimer >= 0.06 then
                        set trailTimer = 0.0
                        call DestroyEffect(EffectSpawn(Altair_ImageModel, nextX, nextY, angle*bj_RADTODEG, 1.5, 1.0, 0.0))
                    endif
                    call GroupEnumUnitsInRange(AltairGroup, nextX, nextY, AltairSQ_Width, NoDecor_Cond)
                    loop
                        set target = FirstOfGroup(AltairGroup)
                        exitwhen target == null
                        call GroupRemoveUnit(AltairGroup, target)
                        if AltairIsEnemy(hero, target) and not IsUnitInGroup(target, hits) then
                            call GroupAddUnit(hits, target)
                            call DamageSource(AltairSQ_ID)
                            call dmgatk(hero, target, damage)
                            call DestroyEffect(AddSpecialEffectTarget(Altair_SwordHitModel, target, "chest"))
                            call DestroyEffect(EffectSpawn(Altair_HitModel, GetUnitX(target), GetUnitY(target), 0.0, 1.0, 1.5, 76.0))
                        endif
                    endloop
                    call DecorRemove(hero, nextX, nextY, AltairSQ_Width, damage)
                    set index = index + 1
                endif
            endloop
            set target = null
        endmethod

        static method Start takes unit caster, real positionX, real positionY returns nothing
            local thistype this = allocate()
            local integer level = IMaxBJ(1, GetUnitAbilityLevel(caster, AltairSQ_ID))
            set hero = caster
            set angle = GAngle2(hero, positionX, positionY)
            set remaining = AltairSQ_Range
            set trailTimer = 0.0
            set damage = AltairSwordDamage(hero, AltairSQ_DamageIntBase + AltairSQ_DamageIntStep*(level - 1), AltairSQ_DamageAtk)
            set hits = CreateGroup()
            set left = EffectSpawn(Altair_SwordModel, GetUnitX(hero), GetUnitY(hero), angle*bj_RADTODEG, 1.0, 0.4, 70.0)
            set right = EffectSpawn(Altair_SwordModel, GetUnitX(hero), GetUnitY(hero), angle*bj_RADTODEG, 1.0, 0.4, 70.0)
            call StartSpellUnit2(hero)
            call SetUnitFacing(hero, angle*bj_RADTODEG)
            call SetUnitAnimation(hero, "attack")
            call DestroyEffect(EffectSpawn(AltairSQ_SlashModel, GetUnitX(hero) + 150.0*Cos(angle), GetUnitY(hero) + 150.0*Sin(angle), angle*bj_RADTODEG, 1.5, 1.0, 60.0))
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    // ==================== SW: Sword Storm (cone of swords) ====================
    private function AltairSW_Cast takes unit hero, real positionX, real positionY returns nothing
        local integer sword = 0
        local integer level = IMaxBJ(1, GetUnitAbilityLevel(hero, AltairSW_ID))
        local real center = GAngle2(hero, positionX, positionY)
        local real damage = AltairSwordDamage(hero, AltairSW_DamageIntBase + AltairSW_DamageIntStep*(level - 1), AltairSW_DamageAtk)
        local real angle
        local group hits = CreateGroup()
        call SetUnitFacing(hero, center*bj_RADTODEG)
        call SetUnitAnimation(hero, "spell")
        call DestroyEffect(EffectSpawn(AltairSW_GateModel, GetUnitX(hero), GetUnitY(hero), center*bj_RADTODEG, 1.0, 1.4, 90.0))
        loop
            exitwhen sword >= AltairSW_Swords
            set angle = center + (sword - (AltairSW_Swords - 1)*0.5)*AltairSW_Cone*bj_DEGTORAD/(AltairSW_Swords - 1)
            call AltairBlade_KS.Launch(hero, GetUnitX(hero) - 40.0*Cos(angle), GetUnitY(hero) - 40.0*Sin(angle), 80.0 + GetRandomReal(0.0, 60.0), angle, AltairSW_Speed + GetRandomReal(-150.0, 150.0), AltairSW_Range, AltairSW_Width, damage, hits)
            set sword = sword + 1
        endloop
        set hits = null
    endfunction

    // ==================== SE: Spinning Swords (horizontal ring, blades point outward as Erza TW) ====================
    private struct AltairSE_KS
        static integer array active
        static integer count = 0
        unit hero
        real remaining
        real power
        real damage
        real angle
        real tickTimer
        integer blades
        effect array blade[24]

        method AddBlades takes integer wanted returns nothing
            loop
                exitwhen blades >= IMinBJ(24, wanted)
                set blade[blades] = AddSpecialEffect(Altair_SwordModel, GetUnitX(hero), GetUnitY(hero))
                call BlzSetSpecialEffectScale(blade[blades], 0.3)
                set blades = blades + 1
            endloop
        endmethod

        static method Loop takes nothing returns nothing
            local integer index = 0
            local integer slot
            local thistype this
            local real bladeAngle
            local real z
            local unit target
            loop
                exitwhen index >= count
                set this = active[index]
                set remaining = remaining - 0.03
                if remaining <= 0.0 or not AltairAlive(hero) then
                    set slot = 0
                    loop
                        exitwhen slot >= blades
                        call ColorEffDummy3(blade[slot], 0.0, 255, 255, 255, 0.12)
                        set blade[slot] = null
                        set slot = slot + 1
                    endloop
                    call RemoveSavedInteger(AltairTable, GetHandleId(hero), 5)
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set angle = angle + AltairSE_SpinSpeed*0.03*(0.75 + 0.25*power)
                    set z = BlzGetUnitZ(hero) + AltairSE_Height
                    set slot = 0
                    loop
                        exitwhen slot >= blades
                        set bladeAngle = angle + slot*2.0*bj_PI/blades
                        call BlzSetSpecialEffectPosition(blade[slot], GetUnitX(hero) + AltairSE_Radius*Cos(bladeAngle), GetUnitY(hero) + AltairSE_Radius*Sin(bladeAngle), z)
                        call BlzSetSpecialEffectYaw(blade[slot], bladeAngle)
                        set slot = slot + 1
                    endloop
                    set tickTimer = tickTimer + 0.03
                    if tickTimer >= AltairSE_Period then
                        set tickTimer = tickTimer - AltairSE_Period
                        call DestroyEffect(EffectSpawn(AltairSE_SlashModel, GetUnitX(hero), GetUnitY(hero), angle*bj_RADTODEG, 2.0, 0.8, 30.0))
                        call GroupEnumUnitsInRange(AltairGroup, GetUnitX(hero), GetUnitY(hero), AltairSE_Aoe, NoDecor_Cond)
                        loop
                            set target = FirstOfGroup(AltairGroup)
                            exitwhen target == null
                            call GroupRemoveUnit(AltairGroup, target)
                            if AltairIsEnemy(hero, target) then
                                call DamageSource(AltairSE_ID)
                                call dmgatk(hero, target, damage*power)
                                call DestroyEffect(AddSpecialEffectTarget(Altair_StampedeModel, target, "chest"))
                                call DestroyEffect(AddSpecialEffectTarget(Altair_SwordHitModel, target, "chest"))
                            endif
                        endloop
                        call DecorRemove(hero, GetUnitX(hero), GetUnitY(hero), AltairSE_Aoe, damage*power)
                    endif
                    set index = index + 1
                endif
            endloop
            set target = null
        endmethod

        // recast: 0 for the first cast in the window, then 1, 2.
        static method Start takes unit caster, integer recast returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(caster), 5)
            local integer level = IMaxBJ(1, GetUnitAbilityLevel(caster, AltairSE_ID))
            if this == 0 then
                set this = allocate()
                set hero = caster
                set blades = 0
                set angle = GetUnitFacing(hero)*bj_DEGTORAD
                set tickTimer = AltairSE_Period
                call SaveInteger(AltairTable, GetHandleId(hero), 5, this)
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
            endif
            set power = 1.0 + AltairSE_PowerStep*recast
            set damage = AltairSwordDamage(hero, AltairSE_DamageIntBase + AltairSE_DamageIntStep*(level - 1), AltairSE_DamageAtk)
            set remaining = AltairSE_Duration
            call AddBlades(AltairSE_Blades + AltairSE_BladesStep*recast)
            call AltairFade(EffectSpawnScale(Altair_RingModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.0, 0.5, 10.0, 0.2, 0.5, AltairSE_Aoe/110.0))
            call SetUnitAnimation(hero, "spell")
        endmethod
    endstruct

    // ==================== SR: Shield of Swords ====================
    private struct AltairSR_KS
        static integer array active
        static integer count = 0
        unit hero
        real remaining
        real blockAngle
        real angle
        real tickTimer
        real damage
        effect array blade[24]

        static method Loop takes nothing returns nothing
            local integer index = 0
            local integer slot
            local thistype this
            local AltairState state
            local real bladeAngle
            local real z
            local unit target
            loop
                exitwhen index >= count
                set this = active[index]
                set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
                set remaining = remaining - 0.03
                if state != 0 then
                    set state.shieldRemaining = remaining
                endif
                if remaining <= 0.0 or not AltairAlive(hero) then
                    if state != 0 then
                        set state.shieldRemaining = 0.0
                    endif
                    set slot = 0
                    loop
                        exitwhen slot >= AltairSR_RingBlades + AltairSR_WallBlades
                        call ColorEffDummy3(blade[slot], 0.0, 255, 255, 255, 0.2)
                        set blade[slot] = null
                        set slot = slot + 1
                    endloop
                    call RemoveSavedInteger(AltairTable, GetHandleId(hero), 6)
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    set angle = angle + AltairSR_SpinSpeed*0.03
                    set z = BlzGetUnitZ(hero)
                    set slot = 0
                    loop
                        exitwhen slot >= AltairSR_RingBlades
                        set bladeAngle = angle + slot*2.0*bj_PI/AltairSR_RingBlades
                        call BlzSetSpecialEffectPosition(blade[slot], GetUnitX(hero) + AltairSR_Radius*Cos(bladeAngle), GetUnitY(hero) + AltairSR_Radius*Sin(bladeAngle), z + 60.0)
                        call BlzSetSpecialEffectYaw(blade[slot], bladeAngle)
                        set slot = slot + 1
                    endloop
                    // A fixed wall of blades marks the blocked direction.
                    loop
                        exitwhen slot >= AltairSR_RingBlades + AltairSR_WallBlades
                        set bladeAngle = blockAngle + (slot - AltairSR_RingBlades - (AltairSR_WallBlades - 1)*0.5)*AltairSR_Arc*bj_DEGTORAD/AltairSR_WallBlades
                        call BlzSetSpecialEffectPosition(blade[slot], GetUnitX(hero) + AltairSR_WallRadius*Cos(bladeAngle), GetUnitY(hero) + AltairSR_WallRadius*Sin(bladeAngle), z + 40.0 + 45.0*ModuloInteger(slot, 2))
                        call BlzSetSpecialEffectYaw(blade[slot], bladeAngle)
                        set slot = slot + 1
                    endloop
                    set tickTimer = tickTimer + 0.03
                    if tickTimer >= AltairSR_Period then
                        set tickTimer = tickTimer - AltairSR_Period
                        call GroupEnumUnitsInRange(AltairGroup, GetUnitX(hero), GetUnitY(hero), AltairSR_Radius + 60.0, NoDecor_Cond)
                        loop
                            set target = FirstOfGroup(AltairGroup)
                            exitwhen target == null
                            call GroupRemoveUnit(AltairGroup, target)
                            if AltairIsEnemy(hero, target) then
                                call DamageSource(AltairSR_ID)
                                call dmgatk(hero, target, damage)
                                call DestroyEffect(AddSpecialEffectTarget(Altair_SwordHitModel, target, "chest"))
                            endif
                        endloop
                    endif
                    set index = index + 1
                endif
            endloop
            set target = null
        endmethod

        static method Start takes unit caster, real positionX, real positionY returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(caster), 6)
            local integer level = IMaxBJ(1, GetUnitAbilityLevel(caster, AltairSR_ID))
            local integer slot = 0
            local AltairState state = LoadInteger(AltairTable, GetHandleId(caster), 0)
            if this == 0 then
                set this = allocate()
                set hero = caster
                set angle = 0.0
                set tickTimer = 0.0
                loop
                    exitwhen slot >= AltairSR_RingBlades + AltairSR_WallBlades
                    set blade[slot] = AddSpecialEffect(Altair_SwordModel, GetUnitX(hero), GetUnitY(hero))
                    call BlzSetSpecialEffectScale(blade[slot], 0.25)
                    set slot = slot + 1
                endloop
                call SaveInteger(AltairTable, GetHandleId(hero), 6, this)
                set active[count] = this
                set count = count + 1
                call GearTimer03Acquire()
            endif
            set blockAngle = GAngle2(hero, positionX, positionY)
            set remaining = AltairSR_Duration + AltairSR_DurationStep*(level - 1)
            set damage = AltairSwordDamage(hero, AltairSR_DamageInt, AltairSR_DamageAtk)
            if state != 0 then
                set state.shieldAngle = blockAngle
                set state.shieldRemaining = remaining
            endif
            call SetUnitFacing(hero, blockAngle*bj_RADTODEG)
            call SetUnitAnimation(hero, "spell")
            call AltairFade(EffectSpawnScale(Altair_RingModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.0, 0.5, 10.0, 0.2, 0.5, 2.0))
        endmethod
    endstruct

    // ==================== ST: Rain of Swords ====================
    private struct AltairSTSword_KS
        static integer array active
        static integer count = 0
        unit hero
        effect art
        real positionX
        real positionY
        real height
        real damage

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            local unit target
            loop
                exitwhen index >= count
                set this = active[index]
                set height = height - AltairST_DropSpeed*0.03
                if height <= 0.0 then
                    call ColorEffDummy3(art, 0.25, 255, 255, 255, 0.2)
                    call DestroyEffect(EffectSpawn(Altair_SlashModel, positionX, positionY, GetRandomReal(0.0, 359.0), 1.5, 0.6, 5.0))
                    if GetRandomInt(1, 3) == 1 then
                        call DestroyEffect(EffectSpawn(Altair_DustModel, positionX, positionY, GetRandomReal(0.0, 359.0), 1.5, 0.6, 0.0))
                    endif
                    call GroupEnumUnitsInRange(AltairGroup, positionX, positionY, AltairST_ImpactAoe, NoDecor_Cond)
                    loop
                        set target = FirstOfGroup(AltairGroup)
                        exitwhen target == null
                        call GroupRemoveUnit(AltairGroup, target)
                        if AltairIsEnemy(hero, target) then
                            call DamageSource(AltairST_ID)
                            call dmgatk(hero, target, damage)
                            call DestroyEffect(AddSpecialEffectTarget(Altair_StampedeModel, target, "chest"))
                        endif
                    endloop
                    call DecorRemove(hero, positionX, positionY, AltairST_ImpactAoe, damage)
                    set art = null
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    call BlzSetSpecialEffectZ(art, AltairGroundZ(positionX, positionY) + height)
                    set index = index + 1
                endif
            endloop
            set target = null
        endmethod

        static method Drop takes unit caster, real centerX, real centerY returns nothing
            local thistype this = allocate()
            local real distance = AltairST_Aoe*SquareRoot(GetRandomReal(0.0, 1.0))
            local real angle = GetRandomReal(0.0, 2.0*bj_PI)
            set hero = caster
            set positionX = centerX + distance*Cos(angle)
            set positionY = centerY + distance*Sin(angle)
            set height = AltairST_DropHeight
            set damage = AltairSwordDamage(hero, AltairST_DamageInt, AltairST_DamageAtk)
            set art = AddSpecialEffect(Altair_SwordModel, positionX, positionY)
            // Blade along X: pitch it to point straight down.
            call BlzSetSpecialEffectOrientation(art, angle, bj_PI/2.0, 0.0)
            call BlzSetSpecialEffectScale(art, 0.45)
            call BlzSetSpecialEffectZ(art, AltairGroundZ(positionX, positionY) + height)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    private struct AltairST_KS
        static integer array active
        static integer count = 0
        unit hero
        real centerX
        real centerY
        real elapsed
        real spawnTimer
        effect circle

        static method Loop takes nothing returns nothing
            local integer index = 0
            local thistype this
            loop
                exitwhen index >= count
                set this = active[index]
                set elapsed = elapsed + 0.03
                if elapsed >= AltairST_Duration or not AltairAlive(hero) then
                    call SetFly(hero, 0.0)
                    call StopSpellUnit(hero)
                    call ColorEffDummy3(circle, 0.0, 255, 255, 255, 0.3)
                    set circle = null
                    call AltairFade(EffectSpawnScale(Altair_RingModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.0, 0.5, 10.0, 0.3, 0.5, AltairST_Aoe/100.0))
                    call WUI_HeroProgress(hero, AltairST_ID, "Rain of Swords", 0.0, 0.0, true)
                    call RemoveSavedInteger(AltairTable, GetHandleId(hero), 7)
                    set hero = null
                    set count = count - 1
                    set active[index] = active[count]
                    call deallocate()
                    call GearTimer03Release()
                else
                    call SetFly(hero, AltairST_Height*RMinBJ(1.0, elapsed/AltairST_RiseTime))
                    set spawnTimer = spawnTimer + 0.03
                    loop
                        exitwhen spawnTimer < AltairST_SpawnPeriod
                        set spawnTimer = spawnTimer - AltairST_SpawnPeriod
                        call AltairSTSword_KS.Drop(hero, centerX, centerY)
                    endloop
                    call WUI_HeroProgress(hero, AltairST_ID, "Rain of Swords", AltairST_Duration - elapsed, AltairST_Duration, true)
                    set index = index + 1
                endif
            endloop
        endmethod

        static method Start takes unit caster returns nothing
            local thistype this = LoadInteger(AltairTable, GetHandleId(caster), 7)
            if this != 0 then
                return
            endif
            set this = allocate()
            set hero = caster
            set centerX = GetUnitX(hero)
            set centerY = GetUnitY(hero)
            set elapsed = 0.0
            set spawnTimer = 0.0
            set circle = EffectSpawn(AltairT_GroundModel, centerX, centerY, 0.0, 1.0, AltairST_Aoe/150.0, 5.0)
            call StartSpellUnit(hero)
            call SetUnitAnimation(hero, "spell")
            call DestroyEffect(EffectSpawn(Altair_SwitchModel, centerX, centerY, 0.0, 1.0, 1.2, 0.0))
            call SaveInteger(AltairTable, GetHandleId(hero), 7, this)
            set active[count] = this
            set count = count + 1
            call GearTimer03Acquire()
        endmethod
    endstruct

    // ==================== COMMON: one timer listener and hero lifecycle ====================
    private function AltairTimer03Loop takes nothing returns boolean
        call AltairBlade_KS.Loop()
        call AltairBullet_KS.Loop()
        call AltairQ_KS.Loop()
        call AltairW_KS.Loop()
        call AltairWBlock_KS.Loop()
        call AltairE_KS.Loop()
        call AltairRMissile_KS.Loop()
        call AltairR_KS.Loop()
        call AltairT_KS.Loop()
        call AltairSQ_KS.Loop()
        call AltairSE_KS.Loop()
        call AltairSR_KS.Loop()
        call AltairSTSword_KS.Loop()
        call AltairST_KS.Loop()
        call AltairState.Loop()
        return false
    endfunction

    function Altair_Register takes unit hero returns nothing
        local AltairState state
        local integer slot = 0
        if GetUnitTypeId(hero) != Altair_ID or IsUnitIllusion(hero) then
            return
        endif
        if not AltairListenerOn then
            set AltairListenerOn = true
            call TriggerAddCondition(GearTimer03Listeners, Condition(function AltairTimer03Loop))
        endif
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if state == 0 then
            set state = AltairState.create()
            set state.hero = hero
            set state.stacks = 0
            set state.shownStacks = -1
            set state.stackTimer = 0.0
            set state.swordToggle = false
            set state.guardAngle = 0.0
            set state.seCost = AltairSE_Cost
            set state.seWindow = 0.0
            set state.fRemaining = 0.0
            set state.fEffect = null
            set state.reflectTarget = null
            set state.reflectAmount = 0.0
            set state.shieldRemaining = 0.0
            set state.shieldAngle = 0.0
            set state.refundAbility = 0
            loop
                exitwhen slot > 6
                set state.holoLevel[slot] = 0
                set state.voiceCycle[slot] = 0
                set state.voiceCycle[slot + 7] = 0
                set state.voiceCycle[slot + 13] = 0
                set state.swordDisabled[slot] = false
                if slot < AltairSF_GuardBlades then
                    set state.guard[slot] = null
                endif
                if slot >= 5 then
                    call UnitAddAbility(hero, AltairHoloAbility[slot])
                    call UnitMakeAbilityPermanent(hero, true, AltairHoloAbility[slot])
                endif
                call UnitAddAbility(hero, AltairSwordAbility[slot])
                call UnitMakeAbilityPermanent(hero, true, AltairSwordAbility[slot])
                set slot = slot + 1
            endloop
            call SaveInteger(AltairTable, GetHandleId(hero), 0, state)
            call state.ApplyForm(Altair_FormHolopsicon)
            call state.Activate()
        endif
    endfunction

    function Altair_ResetForTest takes unit hero returns nothing
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if state != 0 then
            set state.stacks = state.MaxStacks()
            set state.seCost = AltairSE_Cost
        endif
    endfunction

    // Death.j: hero deaths feed Endless Swords; Altair's own death closes her realm.
    function Altair_Death takes unit dying returns nothing
        local integer index = 0
        local AltairState state
        if GetUnitTypeId(dying) == Altair_ID then
            call AltairT_KS.EndFor(dying)
            set state = LoadInteger(AltairTable, GetHandleId(dying), 0)
            if state != 0 then
                set state.fRemaining = 0.0
                call state.SetToggle(false)
            endif
        endif
        if IsUnitType(dying, UNIT_TYPE_HERO) and not IsUnitIllusion(dying) then
            loop
                exitwhen index >= AltairState.count
                set state = AltairState.active[index]
                if state.hero != dying then
                    call state.AddStacks(AltairSF_DeathStacks)
                endif
                set index = index + 1
            endloop
        endif
    endfunction

    // DmgSys, incoming phase: W block, F reflection, SR directional shield, SF toggle.
    function Altair_IncomingDamage takes unit source, unit target, real damage, integer damageType returns real
        local AltairState state
        local boolean enemy
        local real angle
        if damage <= 0.0 or source == null or target == null then
            return damage
        endif
        set enemy = IsUnitEnemy(source, GetOwningPlayer(target))
        if enemy and AltairWBlock_KS.Consume(target) then
            return LustSin(source, target, damage, damage)
        endif
        if GetUnitTypeId(target) != Altair_ID then
            return damage
        endif
        set state = LoadInteger(AltairTable, GetHandleId(target), 0)
        if state == 0 then
            return damage
        endif
        if enemy and state.fRemaining > 0.0 then
            set state.fRemaining = 0.0
            set state.reflectTarget = source
            set state.reflectAmount = damage
            return LustSin(source, target, damage, damage)
        endif
        if enemy and state.shieldRemaining > 0.0 then
            set angle = Atan2(GetUnitY(source) - GetUnitY(target), GetUnitX(source) - GetUnitX(target))
            if Cos(angle - state.shieldAngle) >= Cos(AltairSR_Arc*0.5*bj_DEGTORAD) then
                call DestroyEffect(AddSpecialEffectTarget(Altair_SwordHitModel, target, "chest"))
                return LustSin(source, target, damage, damage)
            endif
        endif
        // Toggled Endless Swords: every received attack is 10% weaker and costs 2 stacks.
        if state.swordToggle and damageType == 0 then
            set damage = damage*AltairSF_AttackTaken
            call state.AddStacks(-AltairSF_AttackCost)
        endif
        return damage
    endfunction

    // ==================== Holopsicon: CastCheck entry points ====================
    function AltairQ_Start takes unit hero, real positionX, real positionY returns nothing
        call Altair_Register(hero)
        call AltairQ_KS.Start(hero, positionX, positionY)
        call AltairState(LoadInteger(AltairTable, GetHandleId(hero), 0)).Voice(0, "Q", 1, 4)
    endfunction

    function AltairW_Start takes unit hero, unit target returns boolean
        local AltairState state
        call Altair_Register(hero)
        if not AltairW_KS.Start(hero, target) then
            return false
        endif
        // Third Movement for an ally, Ninth Movement for an enemy.
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if IsUnitAlly(target, GetOwningPlayer(hero)) then
            call state.Voice(1, "W", 1, 1)
        else
            call state.Voice(2, "W", 2, 2)
        endif
        return true
    endfunction

    function AltairE_Start takes unit hero returns nothing
        call Altair_Register(hero)
        call AltairE_KS.Start(hero)
        call AltairState(LoadInteger(AltairTable, GetHandleId(hero), 0)).Voice(3, "E", 1, 2)
    endfunction

    function AltairR_Start takes unit hero, real positionX, real positionY returns boolean
        local AltairState state
        call Altair_Register(hero)
        if AltairR_KS.Start(hero, positionX, positionY) then
            return true
        endif
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        call state.Refuse(AltairR_ID, "Factor Mimic: no decorations to copy here")
        return false
    endfunction

    function AltairT_Start takes unit hero, real positionX, real positionY returns boolean
        call Altair_Register(hero)
        return AltairT_KS.Start(hero, positionX, positionY)
    endfunction

    function AltairF_Start takes unit hero returns nothing
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        set state.fRemaining = AltairF_Duration
        call state.Voice(9, "F", 1, 2)
        if state.fEffect == null then
            set state.fEffect = AddSpecialEffect(AltairF_Model, GetUnitX(hero), GetUnitY(hero))
            call BlzSetSpecialEffectScale(state.fEffect, AltairF_ModelScale)
            call BlzPlaySpecialEffect(state.fEffect, ANIM_TYPE_BIRTH)
        endif
        call AltairFade(EffectSpawn(Altair_CircleModel, GetUnitX(hero), GetUnitY(hero), 0.0, 1.0, 0.9, 5.0))
        call SetUnitAnimation(hero, "spell")
    endfunction

    // Meta Change during the realm ends it early.
    function AltairG_Start takes unit hero returns nothing
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        call AltairT_KS.EndFor(hero)
        call state.SwitchForm(Altair_FormSword)
    endfunction

    // ==================== Sword Princess: CastCheck entry points ====================
    function AltairSQ_Start takes unit hero, real positionX, real positionY returns boolean
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if not state.TrySpend(AltairSQ_Cost) then
            call state.Refuse(AltairSQ_ID, "Not enough sword stacks")
            return false
        endif
        call AltairSQ_KS.Start(hero, positionX, positionY)
        call state.Voice(13, "GQ", 1, 3)
        return true
    endfunction

    function AltairSW_Start takes unit hero, real positionX, real positionY returns boolean
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if not state.TrySpend(AltairSW_Cost) then
            call state.Refuse(AltairSW_ID, "Not enough sword stacks")
            return false
        endif
        call AltairSW_Cast(hero, positionX, positionY)
        call state.Voice(14, "GW", 1, 2)
        return true
    endfunction

    // Each recast inside the window costs 2 more stacks (up to 6) and spins harder.
    function AltairSE_Start takes unit hero returns boolean
        local AltairState state
        local integer cost
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        set cost = state.seCost
        if not state.TrySpend(cost) then
            call state.Refuse(AltairSE_ID, "Not enough sword stacks")
            return false
        endif
        call AltairSE_KS.Start(hero, (cost - AltairSE_Cost)/AltairSE_CostStep)
        call state.Voice(15, "GE", 1, 2)
        set state.seCost = IMinBJ(AltairSE_CostMax, cost + AltairSE_CostStep)
        set state.seWindow = AltairSE_RecastWindow
        return true
    endfunction

    function AltairSR_Start takes unit hero, real positionX, real positionY returns boolean
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if not state.TrySpend(AltairSR_Cost) then
            call state.Refuse(AltairSR_ID, "Not enough sword stacks")
            return false
        endif
        call AltairSR_KS.Start(hero, positionX, positionY)
        call state.Voice(16, "GR", 1, 2)
        return true
    endfunction

    function AltairST_Start takes unit hero returns boolean
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if not state.TrySpend(AltairST_Cost) then
            call state.Refuse(AltairST_ID, "Not enough sword stacks")
            return false
        endif
        call AltairST_KS.Start(hero)
        call state.Voice(17, "GT", 1, 2)
        return true
    endfunction

    function AltairSF_Start takes unit hero returns nothing
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        if not state.swordToggle and state.stacks < AltairSF_AttackCost then
            call state.Refuse(AltairSF_ID, "Not enough sword stacks")
            return
        endif
        call state.SetToggle(not state.swordToggle)
        if state.swordToggle then
            call state.Voice(18, "GF", 1, 1)
        endif
    endfunction

    function AltairSG_Start takes unit hero returns nothing
        local AltairState state
        call Altair_Register(hero)
        set state = LoadInteger(AltairTable, GetHandleId(hero), 0)
        call state.SwitchForm(Altair_FormHolopsicon)
    endfunction

    private function InitAltairSpells takes nothing returns nothing
        set AltairHoloAbility[0] = AltairQ_ID
        set AltairHoloAbility[1] = AltairW_ID
        set AltairHoloAbility[2] = AltairE_ID
        set AltairHoloAbility[3] = AltairR_ID
        set AltairHoloAbility[4] = AltairT_ID
        set AltairHoloAbility[5] = AltairF_ID
        set AltairHoloAbility[6] = AltairG_ID
        set AltairSwordAbility[0] = AltairSQ_ID
        set AltairSwordAbility[1] = AltairSW_ID
        set AltairSwordAbility[2] = AltairSE_ID
        set AltairSwordAbility[3] = AltairSR_ID
        set AltairSwordAbility[4] = AltairST_ID
        set AltairSwordAbility[5] = AltairSF_ID
        set AltairSwordAbility[6] = AltairSG_ID
        // Copyable decor (models/scales mirror object-data destructables; B016/B017/B018 excluded).
        call AltairDecor('B000', "land_wos\\000_Trees1.mdl", 3.0, 2)
        call AltairDecor('B001', "land_wos\\Wood Fence 1.mdl", 3.2, 1)
        call AltairDecor('B002', "land_wos\\Wood Fence 2.mdl", 3.2, 1)
        call AltairDecor('B003', "land_wos\\ironfencec1_2.mdl", 1.25, 1)
        call AltairDecor('B004', "land_wos\\ironfencec1_1.mdl", 1.25, 1)
        call AltairDecor('B005', "land_wos\\naruto_house1-1.mdl", 1.25, 3)
        call AltairDecor('B006', "land_wos\\ironfencec.mdl", 2.0, 1)
        call AltairDecor('B007', "land_wos\\000_Trees2.mdl", 3.0, 2)
        call AltairDecor('B008', "land_wos\\Pack Targets 1.mdl", 0.8, 1)
        call AltairDecor('B009', "land_wos\\000_Trees3.mdl", 3.0, 2)
        call AltairDecor('B00A', "land_wos\\Poneglyph.mdl", 0.85, 2)
        call AltairDecor('B00B', "land_wos\\naruto_house2.mdl", 1.25, 3)
        call AltairDecor('B00C', "land_wos\\naruto_house3.mdl", 1.25, 3)
        call AltairDecor('B00D', "land_wos\\naruto_house5-1.mdl", 1.5, 3)
        call AltairDecor('B00E', "land_wos\\naruto_house5-2.mdl", 1.5, 3)
        call AltairDecor('B00F', "land_wos\\000_Trees0.mdl", 3.0, 2)
        call AltairDecor('B00G', "land_wos\\Wood Fence 4.mdl", 3.2, 1)
        call AltairDecor('B00H', "land_wos\\Wood Fence 3.mdl", 3.2, 1)
        call AltairDecor('B00I', "land_wos\\biwutai.mdl", 3.0, 2)
        call AltairDecor('B00J', "land_wos\\city_abandonedbuilding_11.mdl", 5.0, 3)
        call AltairDecor('B00K', "land_wos\\city_abandonedbuilding_13.mdl", 5.0, 3)
        call AltairDecor('B00L', "land_wos\\city_abandonedbuilding_15.mdl", 4.5, 3)
        call AltairDecor('B00M', "land_wos\\city_abandonedbuilding_17.mdl", 9.0, 3)
        call AltairDecor('B00N', "land_wos\\city_abandonedbuilding_15_01.mdl", 4.5, 3)
        call AltairDecor('B00O', "land_wos\\Barrel Explosive.mdl", 2.0, 1)
        call AltairDecor('B00P', "land_wos\\Barrel.mdl", 2.0, 1)
        call AltairDecor('B00Q', "land_wos\\Opdef17 (450).mdl", 2.4, 2)
        call AltairDecor('B00R', "land_wos\\Pirate island house.mdl", 0.75, 2)
        call AltairDecor('B00S', "land_wos\\ZS-798.mdl", 1.0, 1)
        call AltairDecor('B00T', "land_wos\\ZS-804.mdl", 1.5, 1)
        call AltairDecor('B00U', "land_wos\\DBObox2.mdl", 0.5, 1)
        call AltairDecor('B00V', "land_wos\\DBORRbox.mdl", 0.8, 1)
        call AltairDecor('B00W', "land_wos\\ArcheryRange.mdl", 2.0, 2)
        call AltairDecor('B00X', "land_wos\\ZS-797.mdl", 1.25, 1)
        call AltairDecor('B00Y', "land_wos\\ZS-796.mdl", 1.25, 1)
        call AltairDecor('B00Z', "land_wos\\plastic table.mdl", 1.0, 1)
        call AltairDecor('B010', "land_wos\\plastic chair.mdl", 0.95, 1)
        call AltairDecor('B011', "land_wos\\huachi1.mdl", 1.25, 1)
        call AltairDecor('B012', "land_wos\\huachi4.mdl", 1.1, 1)
        call AltairDecor('B013', "land_wos\\File00006677.mdl", 1.5, 1)
        call AltairDecor('B014', "land_wos\\ZS-129.mdl", 1.5, 3)
        call AltairDecor('B015', "war3mapImported\\wos_Model Thomas.mdl", 1.0, 3)
        call AltairDecor('B019', "war3mapImported\\wos_jiejin.mdl", 0.55, 1)
        call AltairDecor('B01A', "war3mapImported\\Wos_InoriCrystall.mdl", 0.55, 1)
        call AltairDecor('B01B', "land_wos\\city_abandonedbuilding_15_02.mdl", 4.5, 3)
        // Lazy listener registration in Altair_Register; no private timer.
    endfunction
endlibrary

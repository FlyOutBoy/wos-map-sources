globals
    // Hashed once at map load (was StringHash(...) on every call).
        integer SH_ButtonPressed_CAST_R = StringHash("cast r")
        integer SH_ButtonPressed_CHAT_CD = StringHash("chat cd")
        integer SH_ButtonPressed_ESC = StringHash("esc")
        integer SH_ButtonPressed_INVUL = StringHash("invul")
        integer SH_ButtonPressed_KYORAKU_ESC = StringHash("kyoraku esc")
        integer SH_ButtonPressed_NATSU_R = StringHash("natsu r")
        integer SH_ButtonPressed_NATSU_R_ADD = StringHash("natsu r add")
        integer SH_ButtonPressed_PURPLE = StringHash("purple")
        integer SH_ButtonPressed_SKIP_T = StringHash("skip t")
        integer SH_ButtonPressed_STOP_R = StringHash("stop r")
        integer SH_ButtonPressed_TAKESHI_ESC = StringHash("takeshi esc")
        integer SH_ButtonPressed_TOMIOKA_ESC = StringHash("tomioka esc")
        integer SH_ButtonPressed_TOMIOKA_F_INVUL = StringHash("tomioka f invul")
        integer SH_ButtonPressed_TSUNA_ESC = StringHash("tsuna esc")
        integer SH_ButtonPressed_W_ACTIVE = StringHash("w active")
        integer SH_ButtonPressed_YAMAMOTO_FR = StringHash("yamamoto fr")
        integer SH_ButtonPressed_ZERO_KAI = StringHash("zero kai")
endglobals
globals
    boolean array Chat_Active
    boolean array EffectActive
endglobals

// The toolbar and all shop hotkeys share this existing catalogue state.

function Trig_ButtonPressed_Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer id = GetPlayerId(p)
    local unit hero = Hero[id]
    local integer heroHandleId
    local integer playerHandleId = GetHandleId(p)
    local integer heroTypeId
    local oskeytype but = BlzGetTriggerPlayerKey()
    local boolean isVIP
    local boolean isShopKey

    set isShopKey = but == OSKEY_B or but == OSKEY_TAB or but == OSKEY_SPACE or but == OSKEY_I

    // Spectators can open the shop as a catalogue, while every hero/gameplay
    // hotkey remains disabled because they return before the normal handler.
    // Checkpoint 27: the shop key is the rebindable WUI_HOTKEY_SHOP (toolbar
    // badge, HeroUnitPanelStats) for players and spectators alike.
    if IsObserverSlot(id) then
        set hero = null
        set p = null
        return
    endif

    if hero != null then
        set heroHandleId = GetHandleId(hero)
        set heroTypeId = GetUnitTypeId(hero)
        set isVIP = VIPCheckLvl2(FramePlayerFirstName[id]) or VIPCheckLvl3(FramePlayerFirstName[id])
        if but == OSKEY_R then
            if heroTypeId == Natsu_ID and LoadInteger(hs, heroHandleId, SH_ButtonPressed_NATSU_R) == 1 and IntegerCdKey(hero, SH_ICD_CD_R_BUT, 0.06) then
                call SaveInteger(hs, heroHandleId, SH_ButtonPressed_NATSU_R_ADD, 1)
            endif

        /*elseif but == OSKEY_1 or but == OSKEY_2 or but == OSKEY_3 or but == OSKEY_4 or but == OSKEY_5 or but == OSKEY_6 then
            if  LoadInteger(hs, playerHandleId, SH_ButtonPressed_CHAT_CD) == 0 then
                if but == OSKEY_1 then
                    call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_11.mdx", hero, "origin"), 3.5)
                elseif but == OSKEY_2 then
                    call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_3.mdx", hero, "origin"), 3.5)
                elseif but == OSKEY_3 then
                    call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_5.mdx", hero, "origin"), 3.5)
                elseif but == OSKEY_4 then
                    call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_7.mdx", hero, "origin"), 3.5)
                elseif but == OSKEY_5 then
                    call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_8.mdx", hero, "origin"), 3.5)
                else
                    call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_emoji_9.mdx", hero, "origin"), 3.5)
                endif
                call SaveInteger(hs, playerHandleId, SH_ButtonPressed_CHAT_CD, 1)
                call MyFlush(playerHandleId, SH_ButtonPressed_CHAT_CD, 0, 3.25)
            endif*/

        elseif but == OSKEY_B then
            if TestMode then
                set EffectActive[id] = not EffectActive[id]
                if EffectActive[id] then
                    call DisplayTimedTextToPlayer(p, 0, 0, 1, "aura on")
                else
                    call DisplayTimedTextToPlayer(p, 0, 0, 1, "aura off")
                endif
            endif

        elseif but == OSKEY_T then
            if heroTypeId == Gojo_ID and LoadInteger(hs, playerHandleId, SH_ButtonPressed_PURPLE) == 1 and LoadInteger(hs, playerHandleId, SH_ButtonPressed_SKIP_T) == 0 then
                call SaveInteger(hs, playerHandleId, SH_ButtonPressed_SKIP_T, 1)
            endif

        elseif but == OSKEY_S then
            if heroTypeId == Tomioka_ID and LoadInteger(hs, playerHandleId, SH_ButtonPressed_TOMIOKA_F_INVUL) == 1 and LoadInteger(hs, playerHandleId, SH_ButtonPressed_TOMIOKA_ESC) == 0 then
                call SaveInteger(hs, playerHandleId, SH_ButtonPressed_TOMIOKA_ESC, 1)
            endif
            if LoadInteger(hs, heroHandleId, SH_ButtonPressed_INVUL) == 1 and LoadInteger(hs, heroHandleId, SH_ButtonPressed_ESC) == 0 then
                call SaveInteger(hs, heroHandleId, SH_ButtonPressed_ESC, 1)
            endif
            if LoadInteger(hs, heroHandleId, SH_ButtonPressed_CAST_R) == 1 and LoadInteger(hs, heroHandleId, SH_ButtonPressed_STOP_R) == 0 then
                call SaveInteger(hs, heroHandleId, SH_ButtonPressed_STOP_R, 1)
            endif
            if heroTypeId == Tsuna_ID and LoadInteger(hs, playerHandleId, SH_ButtonPressed_ZERO_KAI) == 1 and LoadInteger(hs, playerHandleId, SH_ButtonPressed_TSUNA_ESC) == 0 then
                call SaveInteger(hs, playerHandleId, SH_ButtonPressed_TSUNA_ESC, 1)
            endif
            if heroTypeId == Takeshi_ID and LoadInteger(hs, playerHandleId, SH_ButtonPressed_YAMAMOTO_FR) == 1 and LoadInteger(hs, playerHandleId, SH_ButtonPressed_TAKESHI_ESC) == 0 then
                call SaveInteger(hs, playerHandleId, SH_ButtonPressed_TAKESHI_ESC, 1)
            endif
            if heroTypeId == Kyoraku_ID and LoadInteger(hs, playerHandleId, SH_ButtonPressed_W_ACTIVE) == 1 and LoadInteger(hs, playerHandleId, SH_ButtonPressed_KYORAKU_ESC) == 0 then
                call SaveInteger(hs, playerHandleId, SH_ButtonPressed_KYORAKU_ESC, 1)
            endif

        elseif but == OSKEY_F3 then
            set PlayerDamageTakenMag[id] = 0
            set PlayerDamageTakenPhys[id] = 0
            set PlayerDamagePhys[id] = 0
            set PlayerDamageMag[id] = 0
            set PlayerHeal[id] = 0

        elseif but == OSKEY_F4 then
            set PlayerDamageTakenMag[id] = PlayerDamageTakenMagAll[id]
            set PlayerDamageTakenPhys[id] = PlayerDamageTakenPhysAll[id]
            set PlayerDamagePhys[id] = PlayerDamagePhysAll[id]
            set PlayerDamageMag[id] = PlayerDamageMagAll[id]
            set PlayerHeal[id] = PlayerHealAll[id]

        // K is owned by EmojiStandalone (its registered key-up event).
        endif

    endif

    set hero = null
    set p = null
endfunction

//===========================================================================
function InitTrig_ButtonPressed takes nothing returns nothing
    set gg_trg_ButtonPressed = CreateTrigger()
    call TriggerAddAction(gg_trg_ButtonPressed, function Trig_ButtonPressed_Actions)
endfunction

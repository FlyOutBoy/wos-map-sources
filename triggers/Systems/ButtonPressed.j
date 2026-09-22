globals
    boolean array Chat_Active
    boolean array EffectActive
endglobals

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
    if IsObserverSlot(id) then
        if isShopKey and LoadInteger(hs, playerHandleId, StringHash("shop key guard")) == 0 then
            call SaveInteger(hs, playerHandleId, StringHash("shop key guard"), 1)
            call MyFlush(playerHandleId, StringHash("shop key guard"), 0, 0.15)
            if Shop_Active[id] then
                set Shop_Active[id] = false
                if ShopUICreated and FRAME_ShopMAIN != null and GetLocalPlayer() == p then
                    call BlzFrameSetVisible(FRAME_ShopMAIN, false)
                endif
            elseif END1 == 0 and ShopUICreated and FRAME_ShopMAIN != null then
                set Shop_Active[id] = true
                set ItemsCraftPlayerDebug_ID[id] = -1
                call ReloadItemPage(ItemsFrameCurrentPage_ID[id], p)
                call ShopUpdateCatalogueNavigation(id, p)
                if GetLocalPlayer() == p then
                    call BlzFrameSetVisible(FRAME_AutoBuyCheckbox, false)
                    call BlzFrameSetVisible(FRAME_AutoBuyText, false)
                    call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[6], false)
                    call BlzFrameSetEnable(FRAME_ShopItemInventorySlot[7], false)
                    call BlzFrameSetVisible(FRAME_ShopMAIN, true)
                endif
            endif
        endif
        set hero = null
        set p = null
        return
    endif

    if hero != null then
        set heroHandleId = GetHandleId(hero)
        set heroTypeId = GetUnitTypeId(hero)
        set isVIP = VIPCheckLvl2(FramePlayerFirstName[id]) or VIPCheckLvl3(FramePlayerFirstName[id])
        if but == OSKEY_R then
            if heroTypeId == Natsu_ID and LoadInteger(hs, heroHandleId, StringHash("natsu r")) == 1 and IntegerCd(hero, "cd r but", 0.06) then
                call SaveInteger(hs, heroHandleId, StringHash("natsu r add"), 1)
            endif

        elseif but == OSKEY_1 or but == OSKEY_2 or but == OSKEY_3 or but == OSKEY_4 or but == OSKEY_5 or but == OSKEY_6 then
            if  LoadInteger(hs, playerHandleId, StringHash("chat cd")) == 0 then
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
                call SaveInteger(hs, playerHandleId, StringHash("chat cd"), 1)
                call MyFlush(playerHandleId, StringHash("chat cd"), 0, 3.25)
            endif

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
            if heroTypeId == Gojo_ID and LoadInteger(hs, playerHandleId, StringHash("purple")) == 1 and LoadInteger(hs, playerHandleId, StringHash("skip t")) == 0 then
                call SaveInteger(hs, playerHandleId, StringHash("skip t"), 1)
            endif

        elseif but == OSKEY_S then
            if heroTypeId == Tomioka_ID and LoadInteger(hs, playerHandleId, StringHash("tomioka f invul")) == 1 and LoadInteger(hs, playerHandleId, StringHash("tomioka esc")) == 0 then
                call SaveInteger(hs, playerHandleId, StringHash("tomioka esc"), 1)
            endif
            if LoadInteger(hs, heroHandleId, StringHash("invul")) == 1 and LoadInteger(hs, heroHandleId, StringHash("esc")) == 0 then
                call SaveInteger(hs, heroHandleId, StringHash("esc"), 1)
            endif
            if LoadInteger(hs, heroHandleId, StringHash("cast r")) == 1 and LoadInteger(hs, heroHandleId, StringHash("stop r")) == 0 then
                call SaveInteger(hs, heroHandleId, StringHash("stop r"), 1)
            endif
            if heroTypeId == Tsuna_ID and LoadInteger(hs, playerHandleId, StringHash("zero kai")) == 1 and LoadInteger(hs, playerHandleId, StringHash("tsuna esc")) == 0 then
                call SaveInteger(hs, playerHandleId, StringHash("tsuna esc"), 1)
            endif
            if heroTypeId == Takeshi_ID and LoadInteger(hs, playerHandleId, StringHash("yamamoto fr")) == 1 and LoadInteger(hs, playerHandleId, StringHash("takeshi esc")) == 0 then
                call SaveInteger(hs, playerHandleId, StringHash("takeshi esc"), 1)
            endif
            if heroTypeId == Kyoraku_ID and LoadInteger(hs, playerHandleId, StringHash("w active")) == 1 and LoadInteger(hs, playerHandleId, StringHash("kyoraku esc")) == 0 then
                call SaveInteger(hs, playerHandleId, StringHash("kyoraku esc"), 1)
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

        elseif but == OSKEY_K then
            if true then
                if Chat_Active[id] then
                    set Chat_Active[id] = false
                    if GetLocalPlayer() == p then
                        call BlzFrameSetVisible(FRAME_Chat0, false)
                    endif
                elseif LoadInteger(hs, playerHandleId, StringHash("chat cd")) == 0 then
                    if GetLocalPlayer() == p then
                        call BlzFrameSetVisible(FRAME_Chat0, true)
                    endif
                    set Chat_Active[id] = true
                else
                    call DisplayTimedTextToPlayer(p, 0, 0, 0.01, "emoji cd")
                endif
            endif
        endif

        // Магазин обрабатывается отдельно: B может одновременно переключать тестовую ауру.
        // Защита от двойной регистрации события и автоповтора одного физического нажатия.
        if isShopKey and LoadInteger(hs, playerHandleId, StringHash("shop key guard")) == 0 then
            call SaveInteger(hs, playerHandleId, StringHash("shop key guard"), 1)
            call MyFlush(playerHandleId, StringHash("shop key guard"), 0, 0.15)
            if PlayerShopButton[id] == null then
                set PlayerShopButton[id] = but
                if but == OSKEY_B then
                    set PlayerShopBut[id] = "B"
                    call DisplayTimedTextToPlayer(p, 0, 0, 1, "Shop button changed to |c00FFFC01'B'|r ")
                elseif but == OSKEY_TAB then
                    set PlayerShopBut[id] = "TAB"
                    call DisplayTimedTextToPlayer(p, 0, 0, 1, "Shop button changed to |c00FFFC01'TAB'|r ")
                elseif but == OSKEY_I then
                    set PlayerShopBut[id] = "I"
                    call DisplayTimedTextToPlayer(p, 0, 0, 1, "Shop button changed to |c00FFFC01'I'|r ")
                endif
            endif
            // Первое нажатие не только назначает клавишу, но и сразу открывает магазин.
            if PlayerShopButton[id] == but then
                if Shop_Active[id] then
                    set Shop_Active[id] = false
                    if ShopUICreated and FRAME_ShopMAIN != null and GetLocalPlayer() == p then
                        call BlzFrameSetVisible(FRAME_ShopMAIN, false)
                    endif
                elseif END1 == 0 then
                    // До завершения CreateItemUI обращаться к framehandle нельзя.
                    if not ShopUICreated or FRAME_ShopMAIN == null then
                        call DisplayTimedTextToPlayer(p, 0, 0, 1.50, "Shop UI is not ready yet")
                    else
                        set Shop_Active[id] = true
                        set ItemsCraftPlayerDebug_ID[id] = -1
                        // ItemsFrameCurrentPage_ID хранится отдельно для каждого игрока.
                        // Не сбрасываем его при закрытии: повторное открытие возвращает
                        // игрока на последнюю выбранную страницу магазина.
                        call ReloadItemPage(ItemsFrameCurrentPage_ID[id], p)
                        call ShopUpdateCatalogueNavigation(id, p)
                        if GetLocalPlayer() == p then
                            call BlzFrameSetVisible(FRAME_ShopMAIN, true)
                        endif
                    endif
                endif
            endif
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

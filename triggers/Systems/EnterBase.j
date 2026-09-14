globals 
unit array atbase_cond
integer atbase_cond_id = 'h019'
endglobals
function Trig_EnterBase_Conditions takes nothing returns boolean
   return IsUnitType(GetEnteringUnit(),UNIT_TYPE_HERO) and IsUnitIllusion(GetEnteringUnit())== false
endfunction

function Trig_EnterBase_Actions takes nothing returns nothing
local unit c = GetEnteringUnit()
local integer id = GetUnitTypeId(c)
local integer i = GetPlayerId(GetOwningPlayer(c))
call UnitAddAbility(c,'Avul')
call SetMpCurrent(c,888888)
call SetHpCurrent(c,888888)
call UnitAddAbility(c,'A01C')
call UnitMakeAbilityPermanent(c,true,'A01C')
call UnitResetCooldown(c)
 if  atbase_cond[i] == null then 
    set atbase_cond[i] = CreateUnit(Player(i),atbase_cond_id,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
    endif
if id == AlterSaber_ID then 
call AlterSaberW_Start(c)
endif
if id == Rimuru_ID and (LoadReal(hs, GetHandleId(c), StringHash("evol dmg")) >= RimuruEvol1_MagiculeDmg or GetHeroLevel(c)>=25) and LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 1")) == 0 then 
call SaveInteger(hs,GetHandleId(c),StringHash("rimuru evol 1"),1)
call RimuruEvol_Start(c,false)
endif
if id == Rimuru_ID and  LoadInteger(hs, GetHandleId(c), StringHash("evol kill")) >= RimuruEvol2_Counter and LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 0 and LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 1")) == 1 then 
call SaveInteger(hs,GetHandleId(c),StringHash("rimuru evol 2"),1)
call RimuruEvol2_Start(c,false)
endif
if IsUnitType(c,UNIT_TYPE_DEAD) then 
call ReviveHero(c,GetUnitX(c),GetUnitY(c),true)
endif
if GetLocalPlayer() == GetOwningPlayer(c) then
call ClearSelection()
call SelectUnit(c,true)
call PanCameraToTimed(GetUnitX(c),GetUnitY(c),0.5)
endif
call UnitRemoveAbility(c,'BTLF')
set c = null
endfunction

//===========================================================================
function InitTrig_EnterBase takes nothing returns nothing
    set gg_trg_EnterBase = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_EnterBase, gg_rct_Base )
    call TriggerAddCondition( gg_trg_EnterBase, Condition( function Trig_EnterBase_Conditions ) )
    call TriggerAddAction( gg_trg_EnterBase, function Trig_EnterBase_Actions )
endfunction


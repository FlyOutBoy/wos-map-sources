// Inlined into TEST WoS_Shop_Init.j. Cache only passive UI geometry, never game
// data. Reapply existing frames on a viewport change without creating handles.
globals
    private hashtable Shop_Position = InitHashtable()
    private integer Shop_PositionCount = 0
    private framehandle array Shop_Frame
    private framepointtype array Shop_Point
    private boolean array Shop_PlaceMode
    private real array Shop_X
    private real array Shop_Y
    private real array Shop_W
    private real array Shop_H
endglobals

function Shop_Shift takes nothing returns real
    return 0.400 - (0.022 + RMinBJ(0.910, WUI_ScreenRight() - 0.012)) * 0.50
endfunction

private function Shop_PositionIndex takes framehandle frame returns integer
    local integer index = LoadInteger(Shop_Position, GetHandleId(frame), 0)
    if index == 0 then
        set Shop_PositionCount = Shop_PositionCount + 1
        set index = Shop_PositionCount
        set Shop_Frame[index] = frame
        call SaveInteger(Shop_Position, GetHandleId(frame), 0, index)
    endif
    return index
endfunction

function Shop_Place takes framehandle frame, real x, real y, real width, real height returns nothing
    local integer index
    if frame == null then
        return
    endif
    set index = Shop_PositionIndex(frame)
    set Shop_PlaceMode[index] = true
    set Shop_X[index] = x
    set Shop_Y[index] = y
    set Shop_W[index] = width
    set Shop_H[index] = height
    call WUI_Place(frame, x + Shop_Shift(), y, width, height)
endfunction

function Shop_SetAbsPoint takes framehandle frame, framepointtype point, real x, real y returns nothing
    local integer index
    if frame == null then
        return
    endif
    set index = Shop_PositionIndex(frame)
    set Shop_PlaceMode[index] = false
    set Shop_Point[index] = point
    set Shop_X[index] = x
    set Shop_Y[index] = y
    call BlzFrameSetAbsPoint(frame, point, x + Shop_Shift(), y)
endfunction

function Shop_Recenter takes nothing returns nothing
    local integer index = 1
    local real shift = Shop_Shift()
    loop
        exitwhen index > Shop_PositionCount
        if Shop_PlaceMode[index] then
            call WUI_Place(Shop_Frame[index], Shop_X[index] + shift, Shop_Y[index], Shop_W[index], Shop_H[index])
        else
            call BlzFrameSetAbsPoint(Shop_Frame[index], Shop_Point[index], Shop_X[index] + shift, Shop_Y[index])
        endif
        set index = index + 1
    endloop
endfunction

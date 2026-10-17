"""Exercise real DamageStats constructors with the working F2 text/bounds contract.

This checks geometry/anchors, not Warcraft font rasterization or multiplayer.
"""
from collections import defaultdict
from pathlib import Path
import math
import re
import unittest

import test_damage_stats as damage_data

ROOT=Path(__file__).resolve().parents[1]
POINTS={'center':(.5,.5),'top':(.5,1.),'bottom':(.5,0.),
        'top-left':(0.,1.),'top-right':(1.,1.),
        'bottom-left':(0.,0.),'bottom-right':(1.,0.),'left':(0.,.5),'right':(1.,.5)}


class LayoutFixture:
    def __init__(self):
        self.base=damage_data.DamageStats();self.base.setUp();self.vm=self.base.vm;self.g=self.vm.g
        self.frames={'root':dict(kind='FRAME',parent=None,rect=(-.133333,0.,.933333,.6),visible=True)}
        self.events=[];self.calls=[];self.created=[];self.passive=[];self.event_frame=None;self.event='enter'
        self.fillinfo={};self.texture_flags={};self.timer=[];self.column_open=False;self.columns=[];self.hotkeys=[]
        self.g.update(DS_Keys={},DS_BuildRow=0,DS_Timer='timer',DS_PollTimer='poll',DS_Ready=False,
            DS_ClickTrigger=None,DS_KeyTrigger=None,DS_Minimized=True,WUI_PANEL_TEXTURE='panel',
            WUI_HOTKEY_DAMAGE=7,OSKEY_L='L',WUI_RegisterHotkeyEx=lambda *a:self.hotkeys.append(a),
            WUI_SetFillWidth=self.fill_width,
            BlzCreateFrameByType=self.create,CreateTrigger=lambda:object(),
            TriggerAddAction=lambda *_:None,BlzTriggerRegisterFrameEvent=lambda *a:self.events.append(a),
            BlzFrameSetPoint=self.point,BlzFrameSetAbsPoint=self.abs_point,
            BlzFrameSetSize=lambda f,w,h:self.set(f,'size',(w,h)),
            BlzFrameSetAllPoints=lambda f,p:self.set(f,'allpoints',p),
            BlzFrameClearAllPoints=self.clear,
            BlzFrameSetScale=lambda f,s:self.set(f,'scale',s),
            BlzFrameSetFont=lambda f,p,h,v:self.set(f,'font',(p,h,v)),
            BlzFrameSetAlpha=lambda f,a:self.set(f,'alpha',a),
            BlzFrameSetVertexColor=lambda f,a:self.set(f,'color',a),
            BlzConvertColor=lambda *a:a,BlzFrameSetEnable=lambda f,v:self.set(f,'enabled',v),
            BlzFrameSetLevel=lambda f,v:self.set(f,'level',v),
            BlzFrameSetTexture=self.texture,
            BlzFrameSetText=lambda f,t:self.set(f,'text',t),
            BlzFrameSetTextAlignment=lambda f,a,b:self.set(f,'align',(a,b)),
            BlzFrameSetVisible=lambda f,v:self.set(f,'visible',v),
            BlzFrameIsVisible=self.visible,GetHandleId=lambda f:f,
            BlzFrameSetTooltip=lambda f,t:self.set(f,'tooltip',t),
            WUI_EnterExclusiveWindow=lambda *_:None,WUI_ResetClickedButtonFocus=lambda:None,WUI_CreateFill=self.fill,WUI_SetValue=self.value,WUI_ScreenRight=lambda:.933333,
            WUI_TextButton=self.button,WUI_SetButtonMinimal=lambda *_:None,
            WUI_SetButtonTextScale=lambda f,s:self.set(f,'scale',s),
            WUI_RegisterPassiveFocus=lambda f:self.passive.append(f),
            WUI_GetRoot=lambda:'root',WUI_GetTopActionOwner=lambda:'root',
            WUI_Panel=self.panel,WUI_RegisterColumnPanelEx=self.column,
            WUI_ColumnShow=lambda f,v:self.set(f,'visible',v and self.column_open),
            WUI_ColumnHeight=self.column_height,WUI_MinimalEdge=lambda *_:None,
            WUI_RegisterModal=lambda *_:None,WUI_RegisterWindowPart=lambda *_:None,
            WUI_TooltipBelow=lambda *_:None,WUI_TooltipBox=self.tooltip,
            WUI_SetButtonCaption=lambda f,t:self.set(f,'text',t),
            WUI_SetButtonSelected=lambda f,v:self.set(f,'selected',v),
            TimerStart=lambda *a:self.timer.append(a),
            GetTriggerPlayer=lambda:0,BlzGetTriggerFrame=lambda:self.event_frame,
            BlzGetTriggerFrameEvent=lambda:self.event,
            DS_SourceName=lambda s:'Burning Finger' if s==100000 else 'Ryujin Jakka',
            DS_SourceIcon=lambda s:'icon',
            GetPlayerName=lambda p:['ThunderGear[VIP]','BleachWos','Player 3'][p%3],
            DS_HeroName=lambda p:['Neuvillette','Tsuna','Erza'][p%3])
        for k in POINTS:self.g['FRAMEPOINT_'+k.upper().replace('-','')]=k
        for k in ['LEFT','RIGHT','CENTER','MIDDLE']:self.g['TEXT_JUSTIFY_'+k]=k.lower()
        for k in ['CONTROL_CLICK','MOUSE_ENTER','MOUSE_LEAVE']:
            self.g['FRAMEEVENT_'+k]={'MOUSE_ENTER':'enter','MOUSE_LEAVE':'leave'}.get(k,k)
        self.vm.run('DS_Build')
        for _ in range(20):self.vm.run('DS_BuildStep')
        for i in range(10):self.g['DS_Order'][i]=i

    def create(self,kind,name,parent,*_):
        f=len(self.created)+1000;self.created.append(f)
        self.frames[f]=dict(kind=kind,name=name,parent=parent,points=[],visible=True,
                            size=(0.,0.),scale=1.,alpha=255,enabled=True,text='')
        return f

    def texture(self,f,t,flag,blend):
        self.texture_flags[f]=(flag,blend);self.set(f,'texture',t)

    def fill(self,name,parent,w,h,maximum,texture):
        f=self.panel(name,parent,w,h);self.texture(f,texture,0,True)
        self.fillinfo[f]=(w,h,maximum);return f

    def fill_width(self,f,w):
        _,h,maximum=self.fillinfo[f];self.fillinfo[f]=(w,h,maximum)

    def value(self,f,value):
        w,h,maximum=self.fillinfo[f]
        self.set(f,'size',(w*max(0,min(maximum,value))/maximum,h))
        self.set(f,'value',value)

    def set(self,f,k,v):
        self.calls.append((f,k,v));self.frames[f][k]=v

    def clear(self,f):
        self.frames[f]['points']=[];self.frames[f].pop('allpoints',None)

    def point(self,f,p,target,tp,x,y):
        self.calls.append((f,'point',(p,target,tp,x,y)))
        pts=self.frames[f]['points'];pts[:]=[a for a in pts if a[0]!=p]
        pts.append((p,target,tp,x,y))

    def abs_point(self,f,p,x,y):
        self.point(f,p,'screen','bottom-left',x,y)

    def panel(self,name,parent,w,h):
        f=self.create('BACKDROP',name,parent);self.set(f,'size',(w,h));return f

    def button(self,name,parent,text,w,h):
        f=self.create('BUTTON',name,parent);self.set(f,'size',(w,h));self.set(f,'text',text)
        self.set(f,'template',True);return f

    def tooltip(self,parent,w,h):return self.panel('tooltip',parent,w,h)

    def column(self,p,title,h,remember,opened):
        self.columns.append((p,title,h,remember,opened));self.column_open=opened
        self.point(p,'top-right','screen','bottom-left',.910,.510)
        self.set(p,'visible',opened)

    def column_height(self,p,h):self.set(p,'size',(.180,h))

    def visible(self,f):
        if f=='root':return True
        d=self.frames[f]
        return d.get('visible',True) and self.visible(d['parent'])

    def rect(self,f):
        if f=='screen':return (0.,0.,0.,0.)
        d=self.frames[f]
        if 'rect' in d:return d['rect']
        if 'allpoints' in d:return self.rect(d['allpoints'])
        w,h=d['size'];pts=d['points'];coords=[]
        for p,target,tp,ox,oy in pts:
            tx,ty,tr,tt=self.rect(target);ax,ay=POINTS[tp]
            coords.append((POINTS[p],tx+(tr-tx)*ax+ox,ty+(tt-ty)*ay+oy))
        if not coords:raise AssertionError(('unanchored',f,d))
        if not w:
            for a in coords:
                for b in coords:
                    if a[0][0]!=b[0][0]:w=(a[1]-b[1])/(a[0][0]-b[0][0])
        if not h:
            for a in coords:
                for b in coords:
                    if a[0][1]!=b[0][1]:h=(a[2]-b[2])/(a[0][1]-b[0][1])
        a,x,y=coords[0];x-=a[0]*w;y-=a[1]*h
        return x,y,x+w,y+h

    def render(self,view,count):
        self.set(self.g['DS_Small' if view==0 else 'DS_Large'],'visible',True)
        self.vm.run('DS_RenderView',(view,count))


class DamageLayout(unittest.TestCase):
    def setUp(self):self.fx=LayoutFixture();self.vm=self.fx.vm;self.g=self.fx.g
    def expand(self):
        self.fx.event_frame=self.g['DS_Tab'][2];self.vm.run('DS_Click')
        self.assertFalse(self.g['DS_Minimized'])
    def hover(self,sensor,shown):
        self.fx.set(sensor,'visible',shown);self.vm.run('DS_Poll')
    def inside(self,child,parent):
        a=self.fx.rect(child);b=self.fx.rect(parent)
        for val,limit in [(a[0],b[0]),(a[1],b[1])]:self.assertGreaterEqual(val+1e-8,limit,(child,a,parent,b))
        for val,limit in [(a[2],b[2]),(a[3],b[3])]:self.assertLessEqual(val-1e-8,limit,(child,a,parent,b))
    def populate(self):
        self.g['GetPlayerSlotState']=lambda p:'playing' if p<10 else 'empty'
        for pid in range(10):
            for n in range(10):self.vm.run('DamageStatsRecordHit',(pid,(pid+1)%10,100000+n,1234.*(pid+1),0.))
        self.vm.run('DS_RankPlayers')

    def test_compact_is_narrow_at_screen_top_and_closed_until_toggle(self):
        self.assertFalse(self.fx.visible(self.g['DS_Small']))
        toggle=self.fx.rect(self.g['DS_Toggle'])
        self.assertAlmostEqual(.598,toggle[3]);self.assertAlmostEqual(.190,toggle[2]-toggle[0])
        self.assertAlmostEqual(-.131333,toggle[0]);self.assertFalse(self.fx.columns)
        self.fx.event_frame=self.g['DS_Toggle'];self.vm.run('DS_Click')
        self.assertTrue(self.fx.visible(self.g['DS_Small']))
        self.vm.run('DS_Click');self.assertFalse(self.fx.visible(self.g['DS_Small']))
        channel,trigger,key,name,both,owner,parent,release=self.fx.hotkeys[0]
        self.assertEqual((7,'L','L',False,True),(channel,key,name,both,release));self.assertEqual(self.g['DS_Toggle'],owner)
        small=self.fx.rect(self.g['DS_Small']);self.assertLessEqual(toggle[1]-small[3],.0015)

    def test_minimize_expand_toggles_caption_portraits_sources_and_bar_width(self):
        self.populate();self.fx.render(0,10);tab=self.g['DS_Tab'][2]
        self.assertEqual('Expand',self.fx.frames[tab]['text'])
        row=self.fx.rect(self.g['DS_Row'][0]);bar=self.fx.rect(self.g['DS_BarBack'][0]);fill=self.fx.rect(self.g['DS_Fill'][0])
        self.assertFalse(self.fx.visible(self.g['DS_Portrait'][0]));self.assertFalse(self.fx.visible(self.g['DS_Icon'][0]))
        self.assertAlmostEqual(.0015,bar[0]-row[0]);self.assertAlmostEqual(.1885,bar[2]-bar[0]);self.assertAlmostEqual(.1885,fill[2]-fill[0])
        self.assertAlmostEqual(bar[3]-bar[1],row[3]-row[1])
        details=self.fx.rect(self.g['DS_Details']);last=self.fx.rect(self.g['DS_Row'][9])
        self.assertLessEqual(last[1]-details[3],.003);self.assertGreater(last[1],details[3])
        self.expand();self.assertEqual('Minimize',self.fx.frames[tab]['text'])
        self.assertTrue(self.fx.visible(self.g['DS_Portrait'][0]));self.assertTrue(self.fx.visible(self.g['DS_Icon'][0]))
        bar=self.fx.rect(self.g['DS_BarBack'][0]);self.assertAlmostEqual(.161,bar[2]-bar[0])
        details=self.fx.rect(self.g['DS_Details']);last=self.fx.rect(self.g['DS_Row'][9])
        self.assertLessEqual(last[1]-details[3],.003);self.assertGreater(last[1],details[3])
        self.fx.event_frame=tab;self.vm.run('DS_Click')
        self.assertFalse(self.fx.visible(self.g['DS_Icon'][0]));self.assertEqual(0,self.g['DS_SlotSource'][0])

    def test_details_cells_are_narrower_and_wrap_to_a_smaller_second_line(self):
        for n in range(20):self.vm.run('DamageStatsRecordHit',(0,2,100000+n,100.+n,0.))
        self.fx.render(1,3);row=self.g['DS_Row'][10]
        first=[self.fx.rect(self.g['DS_Icon'][240+j]) for j in range(20)]
        # ~15% narrower than the old .03048 pitch: exactly 12 cells per bar line.
        self.assertAlmostEqual(.3048/12,first[0][2]-first[0][0]);self.assertLess(first[0][2]-first[0][0],.03048*.86)
        self.assertAlmostEqual(.046,self.fx.rect(row)[3]-self.fx.rect(row)[1])
        for j in range(20):self.assertTrue(self.fx.visible(self.g['DS_Icon'][240+j]));self.inside(self.g['DS_Icon'][240+j],row)
        self.assertAlmostEqual(first[0][0],first[12][0]);self.assertAlmostEqual(first[0][1],first[12][3])
        self.assertLess(self.fx.frames[self.g['DS_Number'][240]]['font'][1],.0065)
        self.assertLess(self.fx.rect(self.g['DS_Row'][11])[3],self.fx.rect(row)[1])

    def test_amount_is_anchored_inside_right_bar_edge_with_space_before_it(self):
        self.populate()
        for view in [0,1]:
            self.fx.render(view,10)
            for row in range(view*10,view*10+10):
                back=self.g['DS_BarBack'][row];value=self.g['DS_Value'][row];label=self.g['DS_Label'][row]
                pt=self.fx.frames[value]['points'][0]
                self.assertEqual(('right',back,'right'),pt[:3])
                self.inside(value,back);self.inside(label,back)
                self.assertAlmostEqual(.003,self.fx.rect(back)[2]-self.fx.rect(value)[2])
                self.assertLess(self.fx.rect(label)[2],self.fx.rect(value)[0])

    def test_large_portraits_span_bar_and_sources_not_one_tiny_line(self):
        self.expand()
        for view in [0,1]:
            self.fx.render(view,3);r=view*10
            portrait=self.fx.rect(self.g['DS_Portrait'][r]);bar=self.fx.rect(self.g['DS_BarBack'][r]);cell=self.fx.rect(self.g['DS_Icon'][r*24])
            self.assertAlmostEqual(portrait[3],bar[3])
            self.assertGreater(portrait[3]-portrait[1],1.8*(bar[3]-bar[1]))
            self.assertLessEqual(portrait[1],cell[1]+.003+1e-8)
            self.assertLess(portrait[2],bar[0]);self.inside(self.g['DS_Portrait'][r],self.g['DS_Row'][r])

    def test_all_10_players_have_10_cells_covering_both_art_and_digits(self):
        self.populate();self.expand()
        for view in [0,1]:
            self.fx.render(view,10)
            for row in range(view*10,view*10+10):
                owner=self.g['DS_Row'][row];last=None
                for j in range(8 if view==0 else 10):
                    slot=row*24+j;cell=self.g['DS_Icon'][slot];art=self.g['DS_Art'][slot];number=self.g['DS_Number'][slot]
                    self.assertTrue(self.fx.visible(cell));self.inside(cell,owner)
                    self.inside(art,cell);self.inside(number,cell)
                    self.assertLessEqual(self.fx.rect(number)[3],self.fx.rect(art)[1]+1e-8)
                    rect=self.fx.rect(cell)
                    if last:self.assertAlmostEqual(last[2],rect[0])
                    last=rect
                    self.assertEqual((0,False),self.fx.texture_flags[art])
                    sensor=self.fx.frames[cell]['tooltip'];self.assertEqual('FRAME',self.fx.frames[sensor]['kind'])
                    self.assertFalse(self.fx.visible(sensor))
                self.inside(owner,self.g['DS_Small' if view==0 else 'DS_Large'])

    def test_font_size_changes_no_frame_scale_or_anchor_dimensions(self):
        for view in [0,1]:
            self.fx.render(view,3);r=view*10
            label=self.fx.frames[self.g['DS_Label'][r]]
            self.assertEqual(1.0,label['scale']);self.assertGreaterEqual(label['font'][1],.0080)
            self.assertNotIn('|n',label['text']);self.assertNotIn('Neuvillette',label['text'])
            self.assertEqual(1.0,self.fx.frames[self.g['DS_Value'][r]]['scale'])
        source=(ROOT/'triggers/WOS_Start/DamageStats.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('BlzFrameSetScale',source)

    def test_smaller_art_retains_legible_digit_boxes_and_translucent_background(self):
        for view,old_portrait,old_art in [(0,.0315,.0105),(1,.034,.0165)]:
            r=view*10;portrait=self.fx.frames[self.g['DS_Portrait'][r]]
            self.assertAlmostEqual(old_portrait*.8*(1.045 if view==0 else 1.),portrait['size'][0])
            art=self.fx.frames[self.g['DS_Art'][r*24]]
            self.assertAlmostEqual(old_art*.8,art['size'][0])
            number=self.g['DS_Number'][r*24];box=self.fx.rect(number)
            self.assertGreaterEqual(box[3]-box[1]+1e-8,self.fx.frames[number]['font'][1])
        backgrounds=[v for v in self.fx.frames.values() if v.get('name')=='DamageStatsBackground']
        self.assertEqual(2,len(backgrounds))
        self.assertTrue(all(v['alpha']==205 and not v['enabled'] for v in backgrounds))

    def test_new_hits_do_not_reanchor_controls_text_icons_or_resize_windows(self):
        self.populate();self.fx.render(0,10);self.fx.render(1,10)
        fixed={self.g['DS_Small'],self.g['DS_Large']}
        for name in ['DS_Row','DS_Label','DS_Value','DS_Icon']:
            fixed.update(self.g[name].values())
        self.fx.calls.clear();self.vm.run('DamageStatsRecordHit',(9,0,100000,300.,0.))
        self.fx.render(0,10);self.fx.render(1,10)
        self.assertFalse([c for c in self.fx.calls if c[0] in fixed and c[1] in ['point','size','scale']])

    def test_hover_has_one_manual_box_stable_across_ticks_and_leaves_cleanly(self):
        self.populate();self.expand();self.fx.render(0,10);self.fx.render(1,10)
        for row in [0,9,10,19]:
            for n in ([0,7] if row<10 else [0,9]):
                slot=row*24+n;sensor=self.g['DS_Sensor'][slot]
                before=len(self.fx.created);self.hover(sensor,True)
                self.assertEqual(slot,self.g['DS_HoverSlot'])
                self.assertEqual(before,len(self.fx.created));self.assertTrue(self.fx.visible(self.g['DS_Tooltip']))
                tip=self.g['DS_Tooltip'];self.assertEqual(self.g['DS_Small' if slot<240 else 'DS_Large'],self.fx.frames[tip]['points'][0][1])
                x,y,r,t=self.fx.rect(tip)
                self.assertGreaterEqual(x,-.133334);self.assertLessEqual(r,.933334);self.assertLessEqual(t,.60001)
                self.fx.calls.clear();self.vm.run('DS_Tick');self.vm.run('DS_Poll')
                self.assertFalse([c for c in self.fx.calls if c[1]=='point'])
                self.hover(sensor,False);self.assertFalse(self.fx.visible(tip));self.assertEqual(-1,self.g['DS_HoverSlot'])

    def test_hover_keeps_source_cells_under_cursor_fixed_until_real_leave(self):
        self.populate();self.expand();self.fx.render(0,10);slot=0;sensor=self.g['DS_Sensor'][slot]
        self.hover(sensor,True)
        source=self.g['DS_SlotSource'][slot];pid=self.g['DS_RowPid'][0]
        self.vm.run('DamageStatsRecordHit',(pid,(pid+1)%10,900000,500.,0.))
        self.vm.run('DS_Tick');self.assertEqual(source,self.g['DS_SlotSource'][slot])
        self.hover(sensor,False);self.assertEqual(source,self.g['DS_SlotSource'][slot])
        self.vm.run('DS_Tick');self.assertEqual(900000,self.g['DS_SlotSource'][slot])

    def test_source_hover_uses_no_synced_mouse_events_and_never_touches_focus(self):
        self.populate();self.expand();self.fx.render(0,10);calls=[]
        self.g['WUI_ResetClickedButtonFocus']=lambda:calls.append('cleanup')
        self.hover(self.g['DS_Sensor'][0],True);self.hover(self.g['DS_Sensor'][0],False);self.assertFalse(calls)
        self.assertFalse([e for e in self.fx.events if e[2] in ('enter','leave')])
        self.assertFalse([e for e in self.fx.events if e[1] in self.g['DS_Icon'].values()])
        self.assertEqual('GLUEBUTTON',self.fx.frames[self.g['DS_Icon'][0]]['kind'])
        self.assertFalse(self.fx.passive)

    def test_details_source_row_icon_hover_reads_its_row_source(self):
        for n in range(3):self.vm.run('DamageStatsRecordHit',(0,2,100000+n,100.+n,0.))
        self.g.update(DS_Selected=0);self.fx.render(1,3)
        self.hover(self.g['DS_RowSensor'][11],True)
        self.assertTrue(self.g['DS_HoverDetail']);self.assertEqual(11*24,self.g['DS_HoverSlot'])
        self.assertTrue(self.fx.visible(self.g['DS_Tooltip']))
        self.hover(self.g['DS_RowSensor'][11],False);self.assertFalse(self.fx.visible(self.g['DS_Tooltip']))

    def test_source_page_shows_big_source_icon_and_second_line_share_then_restores_players(self):
        for n in range(23):self.vm.run('DamageStatsRecordHit',(0,2,100000+n,100.+n,0.))
        self.fx.render(1,3);value=self.fx.rect(self.g['DS_Value'][10]);icon=self.fx.rect(self.g['DS_Icon'][240])
        self.g.update(DS_Selected=0,DS_SourcePage=2);self.fx.render(1,3)
        self.assertFalse(self.fx.visible(self.g['DS_Portrait'][10]))
        self.assertTrue(self.fx.visible(self.g['DS_SourceRowIcon'][10]))
        self.assertEqual('icon',self.fx.frames[self.g['DS_SourceRowArt'][10]]['texture'])
        self.assertIn('%',self.fx.frames[self.g['DS_SubLabel'][10]]['text'])
        self.assertFalse(self.fx.visible(self.g['DS_Icon'][240]));self.assertFalse(self.fx.visible(self.g['DS_Row'][13]))
        self.g['DS_Selected']=-1;self.fx.render(1,3)
        self.assertEqual(value,self.fx.rect(self.g['DS_Value'][10]));self.assertEqual(icon,self.fx.rect(self.g['DS_Icon'][240]))
        self.assertTrue(self.fx.visible(self.g['DS_Portrait'][10]))

    def test_dealt_taken_tabs_switch_totals_sources_and_selection_together(self):
        self.vm.run('DamageStatsRecordHit',(0,2,100000,200.,0.))
        self.vm.run('DamageStatsRecordHit',(2,0,100001,50.,0.));self.expand()
        self.fx.set(self.g['DS_Small'],'visible',True);self.vm.run('DS_Tick')
        self.assertEqual(0,self.g['DS_RowPid'][0]);self.assertIn('200',self.fx.frames[self.g['DS_Value'][0]]['text'])
        self.fx.event_frame=self.g['DS_DirTab'][1];self.vm.run('DS_Click')
        self.assertEqual(1,self.g['DS_Direction']);self.assertEqual(2,self.g['DS_RowPid'][0])
        self.assertEqual(100000,self.g['DS_SlotSource'][0]);self.assertTrue(self.fx.frames[self.g['DS_DirTab'][1]]['selected'])

    def test_1_3_10_rows_fit_screen_and_footer_is_below_last_row(self):
        for count in [1,3,10]:
            for view in [0,1]:
                self.fx.render(view,count);panel=self.g['DS_Small' if view==0 else 'DS_Large']
                self.assertGreaterEqual(self.fx.rect(panel)[1],0.)
                last=self.g['DS_Row'][view*10+count-1];self.inside(last,panel)
                footer=self.g['DS_Details' if view==0 else 'DS_Footer'];self.inside(footer,panel)
                self.assertLess(self.fx.rect(footer)[3],self.fx.rect(last)[1])
        self.assertAlmostEqual(.360,self.fx.rect(self.g['DS_Large'])[2]-self.fx.rect(self.g['DS_Large'])[0])

    def test_escape_closes_details_and_tooltip_keeps_compact_panel_and_respects_capture(self):
        text=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        body=re.search(r'private function WUI_OnWindowEscape takes.*?endfunction',text,re.S)[0]
        vm=damage_data.JassState(body);sent=[];parts={12:self.g['DS_Large'],13:self.g['DS_Small'],14:self.g['DS_Tooltip']}
        vm.g.update(self.g)
        vm.g.update(WUI_AcceptKeyDown=lambda:True,WUI_WindowPart=parts,WUI_HotkeyEdit=defaultdict(bool),WUI_CaptureChannel=defaultdict(lambda:-1),
            WUI_SlotCapture=defaultdict(lambda:-1),BlzSendSyncData=lambda *a:sent.append(a),WUI_CloseMenuDrop=lambda:None)
        for f in parts.values():self.fx.set(f,'visible',True)
        vm.run('WUI_OnWindowEscape');self.assertFalse(self.fx.visible(parts[12]) or self.fx.visible(parts[14]))
        self.assertTrue(self.fx.visible(parts[13]))
        self.assertEqual([('WUIWCLOSE','-1')],sent)
        vm.g['WUI_HotkeyEdit'][0]=True;self.fx.set(parts[12],'visible',True)
        vm.run('WUI_OnWindowEscape');self.assertTrue(self.fx.visible(parts[12]));self.assertEqual(1,len(sent))

    def test_outline_assets_are_thin_transparent_and_row_and_window_have_no_fill(self):
        import struct
        from build_damage_stats_assets import outline,texture,COLORS,NAMES
        for name,size in [('damage-row-edge',(256,64)),('damage-icon-edge',(64,64)),('damage-window-edge',(512,512))]:
            raw=(ROOT/'assets/UI/WOS'/f'{name}.tga').read_bytes();self.assertEqual(outline(*size),raw)
            w,h=struct.unpack_from('<HH',raw,12);self.assertEqual(size,(w,h))
            alpha=raw[21::4];self.assertEqual(0,alpha[(h//2)*w+w//2]);self.assertGreater(alpha[0],0)
        for name,color in zip(NAMES,COLORS):self.assertEqual(texture(color),(ROOT/'assets/UI/WOS'/f'{name}.tga').read_bytes())
        self.assertEqual('FRAME',self.fx.frames[self.g['DS_Large']]['kind'])
        for n in ['DS_Row','DS_Icon']:
            for f in self.g[n].values():self.assertNotIn('template',self.fx.frames[f])

    def test_engine_unit_messages_are_never_relaid_out(self):
        # CP53/54 changed this engine-owned region through generic frame setters.
        # Both native crash dumps contain its matching .180/.290 width and a
        # corrupted vtable. A generic FRAME mock cannot validate this native type.
        text=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('ORIGIN_FRAME_UNIT_MSG',text)

    def test_resize_reanchors_compact_panel_and_toggle_while_collapsed_then_sleeps(self):
        self.g['WUI_ScreenRight']=lambda:.800
        self.fx.calls.clear();self.vm.run('DS_Tick')
        for name in ['DS_Toggle','DS_Small']:
            self.assertAlmostEqual(.002,self.fx.rect(self.g[name])[0])
        self.assertAlmostEqual(.598,self.fx.rect(self.g['DS_Toggle'])[3])
        self.assertFalse(self.fx.visible(self.g['DS_Small']))
        self.fx.calls.clear()
        for _ in range(10):self.vm.run('DS_Tick')
        self.assertFalse([c for c in self.fx.calls if c[1] in ['point','size','scale']])
        self.g['WUI_ScreenRight']=lambda:1.200;self.vm.run('DS_Tick')
        self.assertAlmostEqual(-.398,self.fx.rect(self.g['DS_Toggle'])[0])
        self.assertAlmostEqual(-.398,self.fx.rect(self.g['DS_Small'])[0])

    def test_actual_feed_reflows_right_of_clocks_and_only_on_viewport_change(self):
        text=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        body='\n'.join(re.search(r'private function '+name+r' takes.*?endfunction',text,re.S)[0] for name in ['WUI_CreateFeed','WUI_LayoutFeed'])
        vm=damage_data.JassState(body);vm.g.update(self.g)
        vm.g.update(WUI_Root='root',WUI_FEED_LINES=6,WUI_FeedText={},WUI_FeedAge={},WUI_FeedRight=-1.,
            CreateTimer=lambda:'feed-clock',WUI_FeedTick=lambda:None)
        vm.g['WUI_LayoutFeed']=lambda:vm.run('WUI_LayoutFeed')
        width=[1920];vm.g['WUI_ScreenRight']=lambda:.400+.300*width[0]/1080
        vm.run('WUI_CreateFeed')
        for pixels in [1440,1920,2560,3440,1440]:
            width[0]=pixels;vm.run('WUI_LayoutFeed');right=.400+.300*pixels/1080
            for i in range(6):
                f=vm.g['WUI_FeedText'][i];rect=self.fx.rect(f)
                self.assertEqual('TEXT',self.fx.frames[f]['kind'])
                self.assertAlmostEqual(min(.442,right-.250),rect[0])
                self.assertAlmostEqual(.540-i*.015,(rect[1]+rect[3])/2)
                self.assertGreater(rect[0],.435)  # Existing centre clock's right edge.
                self.assertAlmostEqual(.240/.86,rect[2]-rect[0])
                self.assertAlmostEqual(.86,self.fx.frames[f]['scale'])
                self.assertFalse(self.fx.visible(f))
            self.fx.calls.clear();vm.run('WUI_LayoutFeed')
            self.assertFalse(self.fx.calls)



if __name__=='__main__':unittest.main()

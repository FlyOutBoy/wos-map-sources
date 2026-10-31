"""Execute tooltip transforms and startup metadata/render contracts with native mocks.

These count script work and compare text; they are not engine load-time benchmarks.
"""
from collections import defaultdict
from pathlib import Path
from types import SimpleNamespace
import json,re,unittest
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]

def read(name):return (ROOT/'triggers/WOS_Start'/name).read_text(encoding='utf-8-sig')
def functions(text,*names):
 return '\n'.join(re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?endfunction',text,re.S)[0] for name in names)

def text_natives(vm):
 vm.g.update(StringLength=lambda s:len(s or ''),SubString=lambda s,a,b:(s or '')[int(a):int(b)],
  I2S=lambda n:str(int(n)),R2SW=lambda n,w,p:format(n,'.'+str(p)+'f'))
 return vm

def builder_vm():
 text=read('TooltipBuilder.j').replace('    struct TooltipBuilder','    private struct TooltipBuilder')
 vm=text_natives(JassState(text))
 for key,value in re.findall(r'constant string (C_\w+)\s*=\s*"([^"]*)"',text):vm.g[key]=value
 values={};calls=[]
 def put(kind,key,text):values[kind,key]=text;calls.append((kind,key,text))
 vm.g.update(TooltipTextRevision=0,
  BlzGetAbilityExtendedTooltip=lambda a,l:values.get(('spell',(a,l)),''),
  BlzSetAbilityExtendedTooltip=lambda a,t,l:put('spell',(a,l),t),
  BlzGetAbilityResearchExtendedTooltip=lambda a,l:values.get(('learn',(a,l)),''),
  BlzSetAbilityResearchExtendedTooltip=lambda a,t,l:put('learn',(a,l),t),
  BlzGetItemExtendedTooltip=lambda i:values.get(('item',i),''),
  BlzSetItemExtendedTooltip=lambda i,t:put('item',i,t))
 def create():return vm.run('create')
 return vm,values,calls,SimpleNamespace(create=create)

class TooltipTransforms(unittest.TestCase):
 def test_zero_and_percent_cleanup_preserves_fractional_values_and_rank_lists(self):
  vm=text_natives(JassState(read('TooltipBuilder.j')))
  pairs=[('Heal x 1 + 0 per sec','Heal x 1 per sec'),('Damage - 0, range 0/1/2','Damage, range 0/1/2'),
   ('Damage + 0.5 - 0.75 + 0/1','Damage + 0.5 - 0.75 + 0/1'),
   ('10 percentage points; 1 percentage point','10%; 1%'),
   ('20 percent. 10 percent|n5 percent ','20%. 10%|n5% '),
   ('Restores a percentage of MP','Restores a percentage of MP'),('5 percent','5%')]
  for before,after in pairs:self.assertEqual(after,vm.run('TooltipCleanText',(before,)))

 def test_same_builder_normalizes_once_for_all_research_ranks_and_rechecks_after_edit(self):
  vm,values,writes,fac=builder_vm();data=fac.create();calls=[]
  clean=data.TooltipCleanText
  data.TooltipCleanText=lambda text:calls.append(text) or clean(text)
  data.addDescription('Lethal damage leaves 1 HP. Heal x 1 + 0 per sec.')
  for rank in range(1,6):data.applyToAbilityLearn(123,rank)
  data.get();data.applyToItem(5)
  self.assertEqual(1,len(calls));self.assertEqual(6,len(writes))
  data.addMechanic('Only at hero level 35')
  data.get();data.get()
  self.assertEqual(2,len(calls));self.assertIn('hero level 35',data.buffer)

 def test_unchanged_long_input_returns_the_same_string_and_has_bounded_reads(self):
  vm=text_natives(JassState(read('TooltipBuilder.j')));calls=[]
  sub=vm.g['SubString'];vm.g['SubString']=lambda s,a,b:calls.append((a,b)) or sub(s,a,b)
  text=('Preserve unlock levels 1/5/9/13/17 and damage x 0.5. '*40)
  result=vm.run('TooltipCleanText',(text,))
  self.assertIs(text,result)
  self.assertLess(len(calls),len(text)*3)

 def test_lore_resumes_after_every_inline_color_without_changing_content(self):
  vm,_,_,fac=builder_vm();data=fac.create()
  text='Level 12: |cffff0000Fire|r then |cff00ff00Water|R. Levels 1/5/9/13/17.'
  data.addDescription(text)
  expected='|cffcccccc'+text.replace('|r','|r|cffcccccc').replace('|R','|r|cffcccccc')+'|r'
  self.assertEqual(expected,data.get())

 def test_native_newline_normalization_and_replacement_preserve_formatting(self):
  vm=text_natives(JassState(functions(read('UniversalTooltips.j'),'NormalizeDesc','StringReplace')))
  for before,after in [('A\r\nB\n\n  ','A|nB'),('Level 1/5/9/13/17|n|n ','Level 1/5/9/13/17'),
                       ('x 0.5 + 0.75','x 0.5 + 0.75'),('','')]:
   self.assertEqual(after,vm.run('NormalizeDesc',(before,)))
  for text,old,new,expected in [('a<V1>b<V1>c','<V1>','12','a12b12c'),
                               ('Levels 1/5/9','<V1>','0','Levels 1/5/9'),('aaaa','aa','b','bb')]:
   self.assertEqual(expected,vm.run('StringReplace',(text,old,new)))

 def test_plain_level_template_is_resolved_once_and_tagged_template_keeps_all_ranks(self):
  vm=text_natives(JassState(functions(read('UniversalTooltips.j'),'ParseLevelTags','ResolveLevelTags','GetListElement')))
  vm.g.update(HT_DESC={},LoadStr=lambda t,k,l:t.get((k,l)),SaveStr=lambda t,k,l,v:t.update({(k,l):v}))
  resolve=vm.g['ResolveLevelTags'];calls=[]
  vm.g['ResolveLevelTags']=lambda text,lvl:calls.append((text,lvl)) or resolve(text,lvl)
  for rank in (0,1,2,3,4,5,6,1,6):
   self.assertEqual('Unlocks at level 35',vm.run('ParseLevelTags',('Unlocks at level 35',rank)))
  self.assertEqual(1,len(calls))
  template='Requires level <L:1/5/9/13/17/25>'
  for rank,level in enumerate((1,5,9,13,17,25),1):
   self.assertEqual('Requires level '+str(level),vm.run('ParseLevelTags',(template,rank)))
  self.assertEqual('Requires level 1/5/9/13/17/25',vm.run('ParseLevelTags',(template,0)))


def spell_fixture(text=None):
 text=text or read('UniversalTooltips.j')
 struct=re.search(r'    struct SpellData\b.*?    endstruct',text,re.S)[0].replace('    struct SpellData','    private struct SpellData')
 helpernames=('ReadCastRange','ListRealField','ListCooldown','FormulaList','FormulaStr','FormatReal','FilterIframe','GetListElement','ResolveLevelTags','ParseLevelTags','StringReplace')
 helpers=functions(text,*helpernames)
 extra=functions(text,'WOS_UTB_FlushInitialTips') if 'function WOS_UTB_FlushInitialTips takes' in text else ''
 vm=text_natives(JassState(struct+'\n'+helpers+'\n'+extra))
 ns=vm.structs['SpellData'];allocate=ns.allocate
 def alloc():
  d=allocate()
  for kind,name,value in re.findall(r'^        (integer|real|string|boolean) (\w+) = ([^\n]+)',struct,re.M):
   setattr(d,name,eval(value.replace('false','False').replace('true','True')))
  return d
 ns.allocate=alloc
 ns.create=lambda *args:vm.run('create',args)
 bvm,values,writes,fac=builder_vm();created=[];removed=[];probes=[]
 probe=vm.unit(owner=15)
 vm.g.update(UTB_InitComplete=False,UTB_PendingTips={},UTB_PendingCount=0,TOOLTIP_FIELD_PROBE=probe,
  TooltipBuilder=fac,HT_DATA={},HT_DESC={},LoadStr=lambda t,k,l:t.get((k,l)),
  SaveStr=lambda t,k,l,v:t.update({(k,l):v}),GetDesc=lambda _:"Unlocked at level 12. Damage never loses its source.",
  CaptureDesc=lambda _:None,Player=lambda n:n,CreateUnit=lambda *a:created.append(a) or probe,
  RemoveUnit=lambda u:removed.append(u),UnitAddAbility=lambda u,aid:probes.append((u,aid)),
  BlzGetUnitAbility=lambda u,aid:aid,UnitRemoveAbility=lambda u,aid:probes.append(('remove',aid)),
  ABILITY_RLF_CAST_RANGE='range',BlzGetAbilityRealLevelField=lambda a,f,l:800.+100.*l,
  BlzGetAbilityCooldown=lambda a,l:25.-l if a==99 else 20.-l,
  BlzGetAbilityManaCost=lambda a,l:125+5*l)
 return vm,values,writes,created,removed,probes

class InitialTooltipRendering(unittest.TestCase):
 def test_all_chained_configuration_renders_once_with_final_properties_and_every_rank(self):
  vm,values,writes,created,removed,probes=spell_fixture()
  data=vm.run('create',(123,5,2,3,1.,.5,0.,0.,'Slow <L:10/15/20/25/30>%','Available at level 25'))
  data.setDecor('50');data.setSecondDamage(1,'Second hit',2,.5,.1,0.,0.)
  data.setCdAfterDuration(True);data.setCooldownFrom(99)
  self.assertEqual([],writes)
  self.assertEqual(1,vm.g['UTB_PendingCount'])
  vm.run('WOS_UTB_FlushInitialTips')
  self.assertEqual(10,len(writes))
  self.assertEqual(0,vm.g['UTB_PendingCount'])
  self.assertEqual([],created);self.assertEqual([],removed)
  self.assertEqual(2,len(probes))
  for rank in range(5):
   learned=values['spell',(123,rank)]
   self.assertIn('level 12',learned);self.assertIn('level 25',learned)
   self.assertIn('Second hit',learned);self.assertIn('50',learned)
   self.assertIn(str(10+rank*5)+'%',learned)
   self.assertIn('25',learned)
  self.assertEqual(1,len({values['learn',(123,r)] for r in range(5)}))
  vm.run('WOS_UTB_FlushInitialTips');self.assertEqual(10,len(writes))

 def test_alt_forms_keep_their_separate_metadata_and_do_not_overwrite_base_initial_tips(self):
  vm,values,writes,*_=spell_fixture()
  data=vm.run('createAlt',(123,2,5,2,3,2.,1.,0.,0.,'Alternate form','Level 35'))
  data.setDecor('80');data.setSecondDamage(1,'Second',2,1.,0.,0.,0.)
  self.assertEqual(0,vm.g['UTB_PendingCount']);self.assertEqual([],writes)
  self.assertEqual(2,data.formId);self.assertEqual('80',data.decor)

 def test_runtime_setter_still_refreshes_tips_after_startup(self):
  vm,values,writes,*_=spell_fixture()
  data=vm.run('createUtility',(123,1,'Utility','Level 12'))
  vm.run('WOS_UTB_FlushInitialTips');vm.g['UTB_InitComplete']=True
  data.setDecor('60')
  self.assertEqual(0,vm.g['UTB_PendingCount'])
  self.assertIn('60',values['spell',(123,0)])

 def test_flush_execute_func_name_resolves_and_runs_before_startup_end(self):
  text=read('UniversalTooltips.j')
  name=re.search(r'ExecuteFunc\("(WOS_UTB_FlushInitialTips)"\)',text)[1]
  self.assertRegex(text,r'(?m)^    function '+name+r' takes nothing')
  step=functions(text,'InitTooltipStep')
  self.assertLess(step.index('ExecuteFunc("'+name+'")'),step.index('call WUI_StartupEnd()'))
  body=re.search(r'method SetInitialTips takes.*?endmethod',text,re.S)[0]
  self.assertNotIn('CreateUnit(',body);self.assertNotIn('RemoveUnit(',body)
  self.assertIn('UnitRemoveAbility(dummy, this.abilId)',body)

if __name__=='__main__':unittest.main()

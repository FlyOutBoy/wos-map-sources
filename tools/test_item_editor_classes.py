"""Check complete editor grouping and that sorting touches only native icla."""
from pathlib import Path
import copy,json,unittest
import war3_object_workspace as ws
from stage_item_editor_classes import configure,desired_classes,CLASSES,catalogue
ROOT=Path(__file__).resolve().parents[1]

class EditorClasses(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  cls.items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
 def test_every_item_has_the_same_explicit_class_in_both_native_layers(self):
  wanted=desired_classes(self.items);self.assertEqual(197,len(wanted))
  for doc in self.docs:
   if doc['kind']!='items':continue
   self.assertEqual(197,len(doc['custom_objects']))
   for obj in doc['custom_objects']:
    iid=ws.object_id(obj);mods=[m for m in obj['modifications'] if m['field']['text']=='icla']
    self.assertEqual(1,len(mods),iid);self.assertEqual(wanted[iid],ws.value_for_user(mods[0]),iid)
 def test_catalogue_families_and_base_stat_tomes_keep_their_own_groups(self):
  expected={'I060':'STRENGTH','I067':'AGILITY','I069':'INTELLIGENCE','I06F':'UNIVERSAL',
   'I02Z':'STRENGTH','I032':'AGILITY','I02U':'INTELLIGENCE','I00C':'BASE','I00Z':'DEFENSIVE','I046':'ATTACK'}
  for iid,group in expected.items():self.assertEqual(CLASSES[group],self.items[iid]['classification'],iid)
  self.assertIn('BASE',catalogue()['I03Z']);self.assertEqual(CLASSES['ATTACK'],self.items['I03Z']['classification'])
 def test_sort_is_idempotent_and_never_changes_price_abilities_powerup_or_other_fields(self):
  docs=copy.deepcopy(self.docs);configure(docs,self.items);self.assertEqual(self.docs,docs)
  # Remove all class mods, then verify that a complete re-sort restores only them.
  for d in docs:
   if d['kind']=='items':
    for obj in d['custom_objects']:obj['modifications']=[m for m in obj['modifications'] if m['field']['text']!='icla']
  before=copy.deepcopy(docs);configure(docs,self.items)
  for d in docs:
   if d['kind']=='items':
    for obj in d['custom_objects']:obj['modifications']=[m for m in obj['modifications'] if m['field']['text']!='icla']
  self.assertEqual(before,docs)

if __name__=='__main__':unittest.main()

import tempfile
import unittest
from unittest.mock import patch
from pathlib import Path

import extract_war3_triggers as fmt
import sync_war3_triggers as sync


class TriggerSourceMappingTests(unittest.TestCase):
    def test_main_push_inserts_new_start_trigger_before_later_categories(self):
        """RoundEnd must not become TeamMapPings when the editor loads WCT."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            map_dir = root/'map'
            map_dir.mkdir()
            trigger_dir = root/'triggers'
            trigger_dir.mkdir()
            header = {'object_type':fmt.OBJECT_MAP_HEADER,'object_id':0,'name':'Map Header',
                      'is_comment':False,'is_expandable':True,'parent_id':-1}
            def category(identity,name,parent=0):
                return {'object_type':fmt.OBJECT_CATEGORY,'object_id':identity,'name':name,
                        'is_category':True,'is_expandable':True,'parent_id':parent}
            def trigger(identity,name,parent,enabled=True,kind=fmt.OBJECT_TRIGGER):
                return {'object_type':kind,'object_id':identity,'name':name,'comment':'note '+name,
                        'is_comment':False,'enabled':enabled,'is_custom_text':True,
                        'initially_off':False,'run_on_map_init':False,'parent_id':parent,'function_count':0}
            objects = [header,category(0x02000000,'WOS Start'),
                       trigger(0x03000000,'ShowCD',0x02000000),
                       trigger(0x03000001,'Loan',0x02000000,False),
                       category(0x02000001,'Round End'),trigger(0x03000002,'RoundEnd',0x02000001),
                       category(0x02000002,'Systems'),trigger(0x05000000,'Systems1',0x02000002,kind=fmt.OBJECT_SCRIPT),
                       category(0x02000003,'Heroes'),category(0x02000004,'Nested',0x02000003),
                       trigger(0x03000003,'Crocodile',0x02000004)]
            info = {name:{'total':total,'deleted_ids':[]} for name,total in
                    [('map_header',1),('library',0),('category',5),('trigger',4),('comment',0),('script',1),('variable',0)]}
            wtg = {'magic_number':'0x80000004','format_version':7,'type_info':info,
                   'unknown':[0,0],'trigger_definition_version':2,'variables':[],'objects':objects}
            originals = [b'library AllyHeroAbilityUI\r\nendlibrary\r\n',b'library Loan\r\nendlibrary\r\n',
                         b'library RoundSpells\r\nendlibrary\r\n',b'library GearSystems\r\nendlibrary\r\n',
                         b'library CrocodileSpells\r\nendlibrary\r\n']
            paths = ['WOS_Start/ShowCD.j','WOS_Start/Loan.j','Round_End/RoundEnd.j','Systems/Systems1.j','Heroes/Nested/Crocodile.j']
            for path,source in zip(paths,originals):
                target = trigger_dir/path
                target.parent.mkdir(parents=True,exist_ok=True)
                target.write_bytes(source)
            (trigger_dir/'WOS_Start/TeamMapPings.j').write_bytes(b'library TeamMapPings\r\nendlibrary\r\n')
            wct = {'magic_number':'0x80000004','format_version':1,'header_comment':'header note',
                   'header_source':b'// header\r\n','sources':originals}
            (map_dir/'war3map.wtg').write_bytes(sync.encode_wtg(wtg))
            (map_dir/'war3map.wct').write_bytes(sync.encode_wct(wct))
            config = root/'config.json'
            config.write_text('{}')  # MAIN: no TEST stale-counter option.
            with patch.object(sync,'load_map',return_value=map_dir):
                sync.push(config,trigger_dir,root/'backups')
                first_wtg = (map_dir/'war3map.wtg').read_bytes()
                first_wct = (map_dir/'war3map.wct').read_bytes()
                parsed = fmt.parse_wtg(map_dir/'war3map.wtg')
                sources = fmt.parse_wct(map_dir/'war3map.wct',6)['sources']
                triggers = [o for o in parsed['objects'] if o['object_type'] in (fmt.OBJECT_TRIGGER,fmt.OBJECT_SCRIPT)]
                # Simulate the editor independently using its category tree.
                def editor_sources(parent):
                    result = []
                    for item in parsed['objects']:
                        if item['parent_id'] != parent:
                            continue
                        if item['object_type'] == fmt.OBJECT_CATEGORY:
                            result.extend(editor_sources(item['object_id']))
                        elif item['object_type'] in (fmt.OBJECT_TRIGGER,fmt.OBJECT_SCRIPT):
                            result.append(item)
                    return result
                editor_order = editor_sources(0)
                self.assertEqual(['ShowCD','Loan','TeamMapPings','RoundEnd','Systems1','Crocodile'],[o['name'] for o in editor_order])
                self.assertEqual([o['object_id'] for o in editor_order],[o['object_id'] for o in triggers])
                actual = {o['name']:source for o,source in zip(editor_order,sources)}
                for name,source in zip(['ShowCD','Loan','RoundEnd','Systems1','Crocodile'],originals):
                    self.assertEqual(source,actual[name])
                self.assertIn(b'library TeamMapPings',actual['TeamMapPings'])
                self.assertFalse(next(o for o in triggers if o['name']=='Loan')['enabled'])
                for old in objects:
                    now = next(o for o in parsed['objects'] if o['object_id']==old['object_id'])
                    self.assertEqual(old,{k:v for k,v in now.items() if k!='object_order'})
                sync.push(config,trigger_dir,root/'backups')
                self.assertEqual(first_wtg,(map_dir/'war3map.wtg').read_bytes())
                self.assertEqual(first_wct,(map_dir/'war3map.wct').read_bytes())

    def test_validator_rejects_flat_append_into_earlier_category(self):
        objects = [{'object_type':fmt.OBJECT_CATEGORY,'object_id':1,'parent_id':0},
                   {'object_type':fmt.OBJECT_TRIGGER,'object_id':2,'parent_id':1},
                   {'object_type':fmt.OBJECT_CATEGORY,'object_id':3,'parent_id':0},
                   {'object_type':fmt.OBJECT_TRIGGER,'object_id':4,'parent_id':3},
                   {'object_type':fmt.OBJECT_TRIGGER,'object_id':5,'parent_id':1}]
        with self.assertRaisesRegex(ValueError,'outside its category subtree'):
            sync.validate_editor_order({'objects':objects})

    def test_current_wtg_name_wins_over_reused_manifest_id(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            expected = root / "Heroes" / "Milim.j"
            wrong = root / "Heroes" / "Bambietta.j"
            expected.parent.mkdir(parents=True)
            expected.write_text("library MilimSpells\nendlibrary\n", encoding="utf-8")
            wrong.write_text("library BambiettaSpells\nendlibrary\n", encoding="utf-8")
            category_id = 0x02000001
            item = {
                "object_id": 0x0300007A,
                "name": "Milim",
                "parent_id": category_id,
            }
            objects = {
                category_id: {
                    "object_type": fmt.OBJECT_CATEGORY,
                    "object_id": category_id,
                    "name": "Heroes",
                    "parent_id": 0,
                }
            }
            result = sync.find_source_path(
                item,
                objects,
                root,
                {item["object_id"]: "Heroes/Bambietta.j"},
                ["Heroes/Bambietta.j", "Heroes/Milim.j"],
            )
            self.assertEqual("Heroes/Milim.j", result)


if __name__ == "__main__":
    unittest.main()

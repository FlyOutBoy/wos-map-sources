"""Preservation checks for the additive Frostnova field objects and hit model."""
from pathlib import Path
import copy
import struct
import unittest
from PIL import Image

import war3_object_data as raw
from integrate_crocodile_main_objects import code, set_field
from stage_frostnova_field_buffs import add_objects
from build_frostnova_impact import dark_impact

ROOT=Path(__file__).resolve().parents[1]


class FieldObjects(unittest.TestCase):
    def test_additions_preserve_existing_records_and_are_idempotent(self):
        docs={}
        for name,kind in [('war3map.w3a','abilities'),('war3map.w3h','buffs'),('war3map.w3b','destructables')]:
            docs[name]=dict(_format="warcraft-3-object-data-json-v1",kind=kind,source_file=name,format_version=3,
                record_mode='level' if kind=='abilities' else 'simple',
                original_objects=[],custom_objects=[],trailing_bytes_base64='')
        template=dict(old_id=code('YTct'),new_id=code('B044'),v3_unknown=[0],modifications=[])
        set_field(template,'bnam','User crystal',leveled=False)
        set_field(template,'bfil','UserEdited.mdl',leveled=False)
        docs['war3map.w3b']['custom_objects'].append(template)
        before=copy.deepcopy(docs)
        self.assertEqual(5,len(add_objects(docs,{})))
        self.assertEqual(before['war3map.w3b']['custom_objects'][0],docs['war3map.w3b']['custom_objects'][0])
        after=copy.deepcopy(docs)
        self.assertEqual([],add_objects(docs,{}))
        self.assertEqual(after,docs)
        for name,doc in docs.items():
            encoded=raw.encode_object_file(doc,name)
            self.assertEqual(encoded,raw.encode_object_file(raw.parse_object_file(encoded,name,*raw.FORMAT_BY_EXTENSION[Path(name).suffix],{}),name))
        for obj in docs['war3map.w3a']['custom_objects']:
            fields={m['field']['text']:m['data']['value'] for m in obj['modifications']}
            self.assertEqual(.36,fields['adur']);self.assertEqual(0,fields['amcs'])
            self.assertEqual(0,fields.get('Inf1',fields.get('Cri1')))

    def test_colliding_helper_id_blocks_staging(self):
        conflicting=dict(old_id=code('Aslo'),new_id=code('B0F0'),modifications=[])
        with self.assertRaisesRegex(ValueError,'collision'):
            add_objects({'war3map.w3h':dict(custom_objects=[conflicting],original_objects=[])},{})

    def test_dark_hit_copy_retains_geometry_and_animations(self):
        source=(ROOT/'assets/FrostnovaEffects/source/wos_file00003436_2.mdx').read_bytes()
        before=bytes(source);result=dark_impact(source)
        self.assertEqual(before,source)
        self.assertNotEqual(source,result)
        self.assertEqual(len(source),len(result))
        offset=4;changed=[]
        while offset<len(source):
            tag,size=struct.unpack_from('<4sI',source,offset)
            a,b=offset+8,offset+8+size
            if source[a:b]!=result[a:b]:changed.append(tag)
            if tag==b'TEXS':
                textures=[]
                for at in range(a,b,268):
                    name=result[at+4:at+264].split(b'\0')[0].decode()
                    textures.append(name)
                    self.assertTrue((ROOT/'assets/FrostnovaEffects/files'/name.replace('\\','/')).is_file(),name)
            if tag==b'PRE2':
                at=a
                while at<b:
                    length=struct.unpack_from('<I',result,at)[0]
                    q=at+4+struct.unpack_from('<I',result,at+4)[0]
                    self.assertEqual((1,1),struct.unpack_from('<2I',result,q+36))
                    for interval in (107,119,131,143):
                        self.assertEqual((0,0,1),struct.unpack_from('<3I',result,q+interval))
                    texture=struct.unpack_from('<I',result,q+155)[0]
                    im=Image.open(ROOT/'assets/FrostnovaEffects/files'/textures[texture].replace('\\','/')).convert('RGBA')
                    self.assertEqual(0,im.getextrema()[3][0])
                    for xy in [(0,0),(im.width-1,0),(0,im.height-1),(im.width-1,im.height-1)]:
                        self.assertLessEqual(im.getpixel(xy)[3],2)
                    at+=length
            if tag==b'MTLS':
                at=a
                while at<b:
                    size=struct.unpack_from('<I',result,at)[0]
                    count=struct.unpack_from('<I',result,at+16)[0];layer=at+20
                    for _ in range(count):
                        self.assertEqual(0xFFFFFFFF,struct.unpack_from('<I',result,layer+16)[0])
                        layer+=struct.unpack_from('<I',result,layer)[0]
                    at+=size
            if tag==b'GEOS':
                at=a
                while at<b:
                    size=struct.unpack_from('<I',result,at)[0]
                    uv=result.find(b'UVBS',at,at+size)
                    count=struct.unpack_from('<I',result,uv+4)[0]
                    values=struct.unpack_from('<'+str(count*2)+'f',result,uv+8)
                    for axis in (0,1):
                        self.assertAlmostEqual(0,min(values[axis::2]))
                        self.assertAlmostEqual(1,max(values[axis::2]))
                    self.assertEqual(source[at:uv+8],result[at:uv+8])
                    at+=size
            offset=b
        self.assertEqual({b'TEXS',b'MTLS',b'PRE2',b'GEOS'},set(changed))


if __name__=='__main__':unittest.main()

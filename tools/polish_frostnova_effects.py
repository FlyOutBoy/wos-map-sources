"""Stage mixed blue/black TQ ice, a separate dark haze and level W fog.

Transforms only reviewed packet models. Original geometry, UVs and textures stay
intact; the crystal receives a translucent material layer instead of a recolor.
Does not write maps. Saved inputs make repeated runs byte-identical.
"""
from pathlib import Path
import argparse,json,hashlib,struct
from fix_frostnova_model import chunks,records
from prepare_frostnova_release_assets import textures

W_FOG_EMISSION_SCALE = .8  # Slightly fewer W particles; retain opacity/plane.


def encoded(parts):
    return b'MDLX'+b''.join(tag+struct.pack('<I',len(body))+body for tag,body in parts)


def mixed_ice(data):
    parts=dict(chunks(data));texture_id=len(parts[b'TEXS'])//268
    texture=struct.pack('<I',0)+b'war3mapImported\\wos_FrostnovaBlackIce.tga'.ljust(260,b'\0')+struct.pack('<I',0)
    materials=[]
    for material in records(parts[b'MTLS']):
        count=struct.unpack_from('<I',material,16)[0];at=20;ice=False
        for _ in range(count):
            ice|=struct.unpack_from('<I',material,at+12)[0]==2
            at+=struct.unpack_from('<I',material,at)[0]
        if ice:
            # Classic layer: size, Blend, flags, texture, no animation, coord, alpha.
            overlay=struct.pack('<6If',28,2,48,texture_id,0xffffffff,0,.40)
            material=bytearray(material+overlay)
            struct.pack_into('<I',material,0,len(material));struct.pack_into('<I',material,16,count+1)
        materials.append(bytes(material))
    return encoded((tag,body+texture if tag==b'TEXS' else b''.join(materials) if tag==b'MTLS' else body) for tag,body in chunks(data))


def smoke_only(data):
    output=[]
    for tag,body in chunks(data):
        if tag in (b'GEOS',b'GEOA'):continue
        if tag==b'BONE':
            body=bytearray(body);at=0
            while at<len(body):
                size=struct.unpack_from('<I',body,at)[0]
                if size<96 or at+size+8>len(body):raise ValueError('Invalid bone')
                struct.pack_into('<2I',body,at+size,0xffffffff,0xffffffff);at+=size+8
        output.append((tag,bytes(body)))
    return encoded(output)


def track_values(record,tag,dimensions,transform):
    at=record.find(tag)
    if at<0:return
    count,mode=struct.unpack_from('<2I',record,at+4)
    if mode>3:raise ValueError('Invalid interpolation')
    tangent_count=3 if mode>=2 else 1
    stride=4+4*dimensions*tangent_count
    if at+16+count*stride>len(record):raise ValueError('Invalid track length')
    for key in range(count):
        for tangent in range(tangent_count):
            offset=at+20+key*stride+tangent*dimensions*4
            values=struct.unpack_from('<'+'f'*dimensions,record,offset)
            struct.pack_into('<'+'f'*dimensions,record,offset,*transform(values,tangent))


def level_fog(data):
    names=textures(data);pivots=set();output=[];changes=[]
    for tag,body in chunks(data):
        if tag==b'PRE2':
            emitters=[]
            for original in records(body):
                record=bytearray(original);end=4+struct.unpack_from('<I',record,4)[0]
                texture=names[struct.unpack_from('<I',record,end+155)[0]].lower()
                if 'smoke' in texture or 'fog' in texture:
                    pivots.add(struct.unpack_from('<I',record,88)[0])
                    peaks=[struct.unpack_from('<f',record,end+20)[0]]
                    track_values(record,b'KP2E',1,lambda v,t:(peaks.append(v[0]) or v) if t==0 else v)
                    peak=max(peaks);factor=min(1.4,max(peak,160.)/max(1.,peak))*W_FOG_EMISSION_SCALE
                    struct.pack_into('<f',record,end+20,struct.unpack_from('<f',record,end+20)[0]*factor)
                    track_values(record,b'KP2E',1,lambda v,t:(v[0]*factor,))
                    for field in (0,4,8,12):struct.pack_into('<f',record,end+field,0.)
                    for track in (b'KP2S',b'KP2R',b'KP2L',b'KP2G'):
                        track_values(record,track,1,lambda v,t:(0.,))
                    track_values(record,b'KGTR',3,lambda v,t:(v[0],v[1],0.))
                    for field in (24,28):
                        size=struct.unpack_from('<f',record,end+field)[0]
                        struct.pack_into('<f',record,end+field,max(230.,size))
                    before=list(record[end+92:end+95])
                    record[end+92:end+95]=bytes(0 if value==0 else min(255,max(170,value)) for value in before)
                    changes.append(dict(texture=texture,emission_factor=factor,alpha_before=before,alpha_after=list(record[end+92:end+95])))
                emitters.append(bytes(record))
            body=b''.join(emitters)
        output.append((tag,body))
    for i,(tag,body) in enumerate(output):
        if tag==b'PIVT':
            body=bytearray(body)
            for node in pivots:
                if node*12+12>len(body):raise ValueError('Missing emitter pivot')
                struct.pack_into('<f',body,node*12+8,0.)
            output[i]=(tag,bytes(body))
    return encoded(output),changes


def stage(packet):
    files=packet/'files/war3mapImported';saved=packet/'source-polish';saved.mkdir(exist_ok=True)
    manifest=json.loads((packet/'manifest.json').read_text('utf8'))
    def source(name):
        path=saved/name
        if not path.exists():path.write_bytes((files/name).read_bytes())
        return path.read_bytes()
    original_ice=source('wos_ice_shard-7716D.mdx')
    original_dark=source('wos_ice_shard-7716D-dark.mdx')
    (files/'wos_ice_shard-7716D-dark.mdx').write_bytes(mixed_ice(original_ice))
    smoke='wos_Frostnova_TQ_Smoke.mdx'
    (files/smoke).write_bytes(smoke_only(original_dark))
    report={}
    for name in ('wos_file00002579_1.mdx','wos_tx026_1.mdx'):
        data,report[name]=level_fog(source(name));(files/name).write_bytes(data)
    target='war3mapImported\\'+smoke
    if not any(m['target']==target for m in manifest['models']):
        manifest['models'].append(dict(source=str((saved/'wos_ice_shard-7716D-dark.mdx').relative_to(packet)),target=target,particles=[],skin=None))
    manifest['imports']=[dict(path=str(p.relative_to(packet/'files')).replace('/','\\'),bytes=p.stat().st_size,sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in (packet/'files').rglob('*') if p.is_file()]
    manifest['polish']=dict(tq='Original blue ice plus a 40% black-ice material; separate dark particles',fog=report)
    (packet/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('packet',type=Path)
    print(json.dumps(stage(parser.parse_args().packet),indent=2))

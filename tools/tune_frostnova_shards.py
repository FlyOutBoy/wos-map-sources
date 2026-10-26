"""Tune Q particle size and build a transparent black-ice variant from an explicit source.

Does not write maps. The atlas is generated artwork; this tool only slices and
converts its four sprite cells, preserving their alpha. Geometry/nodes stay intact.
"""
from pathlib import Path
import argparse,struct,json,hashlib
from PIL import Image

ROOT=Path(__file__).resolve().parents[1]
PACKET=ROOT/'assets/FrostnovaEffects'
OUT=PACKET/'files/war3mapImported'
PARTICLE_SCALE=.8


def tune(data: bytes, dark: bool=False) -> bytes:
    if data[:4]!=b'MDLX':raise ValueError('Expected MDX model')
    result=bytearray(data);pos=4
    sprites=['FrostnovaDarkFrost.tga','FrostnovaDarkGlow.tga','FrostnovaBlackIce.tga',
             'FrostnovaDarkStar.tga','FrostnovaDarkFrost.tga','FrostnovaDarkRing.tga']
    while pos<len(result):
        tag,size=struct.unpack_from('<4sI',result,pos)
        start,end=pos+8,pos+8+size
        if end>len(result):raise ValueError('Truncated model chunk')
        if tag==b'TEXS' and dark:
            if size!=268*6:raise ValueError('Unexpected shard texture layout')
            for i,name in enumerate(sprites):
                at=start+i*268
                result[at+4:at+264]=('war3mapImported\\'+name).encode().ljust(260,b'\0')
        elif tag==b'MTLS' and dark:
            at=start
            while at<end:
                length=struct.unpack_from('<I',result,at)[0]
                if result[at+12:at+16]!=b'LAYS':raise ValueError('Unsupported material')
                layers=struct.unpack_from('<I',result,at+16)[0];layer=at+20
                for _ in range(layers):
                    length_layer=struct.unpack_from('<I',result,layer)[0]
                    struct.pack_into('<I',result,layer+4,2) # MDX layer Blend, not Additive.
                    struct.pack_into('<f',result,layer+24,.90)
                    layer+=length_layer
                at+=length
        elif tag==b'PRE2':
            at=start
            while at<end:
                length=struct.unpack_from('<I',result,at)[0]
                node_end=at+4+struct.unpack_from('<I',result,at+4)[0]
                if node_end+171>at+length:raise ValueError('Truncated emitter')
                for i in range(3):
                    scale=struct.unpack_from('<f',result,node_end+95+i*4)[0]
                    struct.pack_into('<f',result,node_end+95+i*4,scale*PARTICLE_SCALE)
                if dark:
                    struct.pack_into('<I',result,node_end+32,0) # PRE2 Blend (different enum).
                    for i,bgr in enumerate([(.65,.55,.45),(.45,.37,.32),(.25,.22,.20)]):
                        struct.pack_into('<3f',result,node_end+56+i*12,*bgr)
                    result[node_end+92:node_end+95]=bytes([200,150,0])
                at+=length
            if at!=end:raise ValueError('Invalid emitter records')
        pos=end
    return bytes(result)


def build(source: Path, atlas: Path) -> list[str]:
    data=source.read_bytes();OUT.mkdir(parents=True,exist_ok=True)
    image=Image.open(atlas).convert('RGBA');w,h=image.size
    if w%2 or h%2:raise ValueError('Expected an even 2x2 atlas')
    files=[]
    for i,name in enumerate(['Glow','Star','Frost','Ring']):
        x=(i%2)*w//2;y=(i//2)*h//2
        sprite=image.crop((x,y,x+w//2,y+h//2)).resize((256,256),Image.Resampling.LANCZOS)
        if sprite.getextrema()[3][0]!=0 or sprite.getextrema()[3][1]==0:
            raise ValueError('Particle sprite must have actual transparency')
        target=OUT/('FrostnovaDark'+name+'.tga');sprite.save(target);files.append(target.name)
    for name,dark in [('ice_shard-7716D.mdx',False),('ice_shard-7716D-dark.mdx',True)]:
        (OUT/name).write_bytes(tune(data,dark));files.append(name)
    manifest_path=PACKET/'manifest.json'
    manifest=json.loads(manifest_path.read_text('utf8'))
    for entry in manifest['entries']:
        if entry['importPath'].casefold()=='war3mapimported\\ice_shard-7716d.mdx':
            payload=(OUT/'ice_shard-7716D.mdx').read_bytes()
            entry.update(sha256=hashlib.sha256(payload).hexdigest(),bytes=len(payload))
    manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    return ['war3mapImported\\'+n for n in files]


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source',required=True,type=Path)
    p.add_argument('--atlas',type=Path,default=PACKET/'dark-particles-source.png')
    a=p.parse_args();print(json.dumps(build(a.source,a.atlas)))

"""Repair depth visibility/culling for the selected TE area model, without scaling.

The marker overlays the stationary E splat. Geometry, textures, alpha, particle
settings and animation tracks remain byte-identical. Does not write any map.
"""
from pathlib import Path
import argparse
import math
import struct


def fix_area(data: bytes) -> bytes:
    if data[:4] != b'MDLX':
        raise ValueError('Expected an MDX model')
    result=bytearray(data);pos=4;model=None;bounds=[]
    while pos<len(result):
        tag,size=struct.unpack_from('<4sI',result,pos)
        start,end=pos+8,pos+8+size
        if end>len(result):raise ValueError('Truncated MDX chunk')
        if tag==b'MODL':
            if size<372:raise ValueError('Truncated model extent')
            model=start+340  # name[80] + animationFile[260]
        elif tag==b'SEQS':
            if size%132:raise ValueError('Invalid sequence layout')
            for at in range(start,end,132):
                extent=struct.unpack_from('<7f',result,at+104)
                if all(math.isfinite(v) for v in extent) and extent[0]>0:
                    bounds.append(extent)
        elif tag==b'MTLS':
            at=start
            while at<end:
                length=struct.unpack_from('<I',result,at)[0]
                if length<20 or at+length>end or result[at+12:at+16]!=b'LAYS':
                    raise ValueError('Invalid material')
                count=struct.unpack_from('<I',result,at+16)[0];layer=at+20
                for _ in range(count):
                    size_layer=struct.unpack_from('<I',result,layer)[0]
                    if size_layer<28 or layer+size_layer>at+length:
                        raise ValueError('Invalid layer')
                    flags=struct.unpack_from('<I',result,layer+8)[0]
                    # NoDepthTest keeps the marker visible over E; NoDepthSet
                    # prevents the marker itself from occluding the hero.
                    struct.pack_into('<I',result,layer+8,flags|0x40|0x80)
                    layer+=size_layer
                at+=length
        pos=end
    if model is None or not bounds:raise ValueError('Missing usable model bounds')
    minimum=[min(e[axis+1] for e in bounds) for axis in range(3)]
    maximum=[max(e[axis+4] for e in bounds) for axis in range(3)]
    radius=max(max(e[0] for e in bounds),math.sqrt(sum(max(abs(a),abs(b))**2 for a,b in zip(minimum,maximum))))
    struct.pack_into('<7f',result,model,radius,*minimum,*maximum)
    return bytes(result)


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path);parser.add_argument('output',type=Path)
    args=parser.parse_args();args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_bytes(fix_area(args.source.read_bytes()))

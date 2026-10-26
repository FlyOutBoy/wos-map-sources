"""Bake a uniform size change into TE art; never scale unit attachments at runtime."""
import struct
from dataclasses import replace
from fix_frostnova_model import chunks, records, parse_geoset, encode_geoset


def scale_track(body, tag, dimensions, factor):
    at=0
    while True:
        at=body.find(tag,at)
        if at<0:return
        count,interpolation,_=struct.unpack_from('<3I',body,at+4)
        if interpolation>3 or count>10000:raise ValueError('Invalid spatial animation track')
        components=dimensions*(3 if interpolation>=2 else 1)
        stride=4+components*4
        if at+16+count*stride>len(body):raise ValueError('Truncated spatial animation')
        for key in range(count):
            position=at+20+key*stride
            values=struct.unpack_from('<'+'f'*components,body,position)
            struct.pack_into('<'+'f'*components,body,position,*(value*factor for value in values))
        at+=16+count*stride


def resized(data,factor):
    output=[]
    for tag,body in chunks(data):
        result=bytearray(body)
        if tag in (b'PREM',b'RIBB',b'LITE',b'CLID',b'CAMS'):
            raise ValueError('Review additional spatial chunk before scaling: '+repr(tag))
        if tag==b'GEOS':
            meshes=[]
            for record in records(body):
                mesh=parse_geoset(record)
                vertices=[struct.pack('<3f',*(v*factor for v in struct.unpack('<3f',vertex))) for vertex in mesh.vertices]
                metadata=bytearray(mesh.metadata)
                for at in [12,*range(44,len(metadata),28)]:
                    extent=struct.unpack_from('<7f',metadata,at)
                    struct.pack_into('<7f',metadata,at,*(v*factor for v in extent))
                meshes.append(encode_geoset(replace(mesh,vertices=vertices,metadata=bytes(metadata))))
            result=bytearray(b''.join(meshes))
        elif tag in (b'MODL',b'SEQS'):
            # MODL: name[80] + animationFile[260], then the 28-byte extent.
            positions=[340] if tag==b'MODL' else range(104,len(body),132)
            for at in positions:
                extent=struct.unpack_from('<7f',result,at)
                struct.pack_into('<7f',result,at,*(v*factor for v in extent))
        elif tag==b'PIVT':
            for at in range(0,len(body),4):
                struct.pack_into('<f',result,at,struct.unpack_from('<f',result,at)[0]*factor)
        elif tag==b'PRE2':
            offset=0
            for record in records(body):
                node_end=4+struct.unpack_from('<I',record,4)[0]
                for field in (0,12,24,28,95,99,103):
                    at=offset+node_end+field
                    struct.pack_into('<f',result,at,struct.unpack_from('<f',result,at)[0]*factor)
                offset+=len(record)
            for track in (b'KP2S',b'KP2G',b'KP2W',b'KP2L'):
                scale_track(result,track,1,factor)
        if tag in (b'BONE',b'HELP',b'ATCH',b'PRE2',b'EVTS'):
            scale_track(result,b'KGTR',3,factor)
        output.append(tag+struct.pack('<I',len(result))+result)
    return b'MDLX'+b''.join(output)

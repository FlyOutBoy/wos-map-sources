"""Copy the saved Q hit model and bind the existing black-ice artwork.

Only texture paths, blend modes, UV mapping and particle colors/alpha change.
Geometry positions, bones, animation tracks and particle sizes stay intact.
"""
from pathlib import Path
import argparse
import struct


def dark_impact(source: bytes) -> bytes:
    if source[:4] != b'MDLX':
        raise ValueError('Expected an MDX model')
    result = bytearray(source)
    textures = ['FrostnovaDarkFrost.tga', 'FrostnovaDarkGlow.tga',
                'FrostnovaDarkRing.tga', 'FrostnovaDarkGlow.tga',
                'FrostnovaDarkStar.tga', 'FrostnovaDarkFrost.tga',
                'FrostnovaDarkRing.tga']
    pos = 4
    while pos < len(result):
        tag, size = struct.unpack_from('<4sI', result, pos)
        start, end = pos+8, pos+8+size
        if end > len(result):
            raise ValueError('Truncated model chunk')
        if tag == b'TEXS':
            if size != 268*len(textures):
                raise ValueError('Unexpected hit-model texture layout')
            for index, name in enumerate(textures):
                offset = start+268*index
                result[offset+4:offset+264] = ('war3mapImported\\'+name).encode().ljust(260, b'\0')
        elif tag == b'MTLS':
            offset = start
            while offset < end:
                length = struct.unpack_from('<I', result, offset)[0]
                if result[offset+12:offset+16] != b'LAYS' or length < 20:
                    raise ValueError('Invalid material')
                layers = struct.unpack_from('<I', result, offset+16)[0]
                layer = offset+20
                for _ in range(layers):
                    layer_size = struct.unpack_from('<I', result, layer)[0]
                    if layer_size < 28:
                        raise ValueError('Invalid layer')
                    struct.pack_into('<I', result, layer+4, 2)  # Blend: black stays visible.
                    struct.pack_into('<I', result, layer+16, 0xFFFFFFFF)  # No old atlas translation.
                    layer += layer_size
                offset += length
        elif tag == b'GEOS':
            offset = start
            while offset < end:
                length = struct.unpack_from('<I', result, offset)[0]
                if length < 4 or offset+length > end:
                    raise ValueError('Invalid geoset')
                uv = result.find(b'UVBS', offset+4, offset+length)
                if uv < 0:
                    raise ValueError('Missing geoset UVs')
                count = struct.unpack_from('<I', result, uv+4)[0]
                values = list(struct.unpack_from('<'+str(count*2)+'f', result, uv+8))
                # One source plane samples one cell of a 3x3 texture sheet.
                # Our replacement is a complete sprite, so use its complete alpha mask.
                for axis in (0, 1):
                    minimum, maximum = min(values[axis::2]), max(values[axis::2])
                    if maximum > minimum:
                        for index in range(axis, len(values), 2):
                            values[index] = (values[index]-minimum)/(maximum-minimum)
                struct.pack_into('<'+str(count*2)+'f', result, uv+8, *values)
                offset += length
        elif tag == b'PRE2':
            offset = start
            while offset < end:
                length = struct.unpack_from('<I', result, offset)[0]
                node_end = offset+4+struct.unpack_from('<I', result, offset+4)[0]
                if node_end+171 > offset+length:
                    raise ValueError('Invalid particle emitter')
                struct.pack_into('<I', result, node_end+32, 0)  # PRE2 Blend enum.
                # These textures are individual RGBA sprites, not the source's
                # 2x2 / 4x4 atlases. Never crop them into opaque square fragments.
                struct.pack_into('<2I', result, node_end+36, 1, 1)
                for interval in (107, 119, 131, 143):
                    struct.pack_into('<3I', result, node_end+interval, 0, 0, 1)
                for index, color in enumerate([(.70, .65, .60), (.48, .43, .39), (.28, .26, .24)]):
                    struct.pack_into('<3f', result, node_end+56+12*index, *color)
                result[node_end+92:node_end+95] = bytes([210, 160, 0])
                offset += length
        pos = end
    return bytes(result)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(dark_impact(args.source.read_bytes()))

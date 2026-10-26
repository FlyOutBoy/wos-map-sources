"""Split oversized MDX 800 skin palettes without changing triangle attributes.

The affected Warcraft renderer increments an 8-bit palette counter and hangs at
256 groups. Keep at most 255 groups per geoset. Imports retain their own names;
this tool only writes the explicitly selected output file.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
from pathlib import Path
import struct

U32 = struct.Struct('<I')
MAX_GROUPS = 255


def chunks(data: bytes):
    if data[:4] != b'MDLX':
        raise ValueError('Not an MDX model')
    offset = 4
    while offset < len(data):
        tag, size = struct.unpack_from('<4sI', data, offset)
        end = offset + 8 + size
        if end > len(data):
            raise ValueError('Truncated MDX chunk')
        yield tag, data[offset+8:end]
        offset = end


def records(data: bytes):
    offset = 0
    while offset < len(data):
        size = U32.unpack_from(data, offset)[0]
        if size < 4 or offset+size > len(data):
            raise ValueError('Invalid MDX record')
        yield data[offset:offset+size]
        offset += size


@dataclass
class Geoset:
    vertices: list[bytes]
    normals: list[bytes]
    faces: list[tuple[int, int, int]]
    vertex_groups: list[int]
    groups: list[tuple[int, ...]]
    metadata: bytes
    uvs: list[list[bytes]]


def parse_geoset(data: bytes) -> Geoset:
    offset = 4

    def array(tag, width):
        nonlocal offset
        if data[offset:offset+4] != tag:
            raise ValueError('Unsupported geoset layout at '+repr(tag))
        count = U32.unpack_from(data, offset+4)[0]
        start = offset+8
        offset = start+width*count
        if offset > len(data):
            raise ValueError('Truncated geoset array')
        return [data[i:i+width] for i in range(start, offset, width)]

    vertices = array(b'VRTX', 12)
    normals = array(b'NRMS', 12)
    if array(b'PTYP', 4) != [U32.pack(4)]:
        raise ValueError('Only triangle-list geosets are supported')
    face_counts = array(b'PCNT', 4)
    indices = [struct.unpack('<H', v)[0] for v in array(b'PVTX', 2)]
    if face_counts != [U32.pack(len(indices))] or len(indices) % 3:
        raise ValueError('Invalid triangle-list indices')
    vertex_groups = [v[0] for v in array(b'GNDX', 1)]
    counts = [U32.unpack(v)[0] for v in array(b'MTGC', 4)]
    matrices = [U32.unpack(v)[0] for v in array(b'MATS', 4)]
    groups, start = [], 0
    for count in counts:
        groups.append(tuple(matrices[start:start+count]))
        start += count
    if start != len(matrices) or not groups:
        raise ValueError('Invalid matrix groups')
    begin = offset
    # Material, selection fields, model extent, animation extents.
    sequence_count = U32.unpack_from(data, offset+40)[0]
    offset += 44+sequence_count*28
    metadata = data[begin:offset]
    if data[offset:offset+4] != b'UVAS':
        raise ValueError('Unsupported geoset extension')
    uv_count = U32.unpack_from(data, offset+4)[0]
    offset += 8
    uvs = [array(b'UVBS', 8) for _ in range(uv_count)]
    if offset != len(data) or len(normals) != len(vertices) or len(vertex_groups) != len(vertices):
        raise ValueError('Invalid vertex attribute counts')
    if any(len(layer) != len(vertices) for layer in uvs):
        raise ValueError('Invalid UV attribute count')
    if any(v >= len(vertices) for v in indices) or max(vertex_groups) >= len(groups):
        raise ValueError('Invalid geoset index')
    return Geoset(vertices, normals, list(zip(indices[::3], indices[1::3], indices[2::3])), vertex_groups, groups, metadata, uvs)


def encode_geoset(g: Geoset) -> bytes:
    def array(tag, rows):
        return tag+U32.pack(len(rows))+b''.join(rows)
    indices = [struct.pack('<H', v) for face in g.faces for v in face]
    body = b''.join((array(b'VRTX', g.vertices), array(b'NRMS', g.normals),
        array(b'PTYP', [U32.pack(4)]), array(b'PCNT', [U32.pack(len(indices))]),
        array(b'PVTX', indices), array(b'GNDX', [bytes([v]) for v in g.vertex_groups]),
        array(b'MTGC', [U32.pack(len(v)) for v in g.groups]),
        array(b'MATS', [U32.pack(v) for group in g.groups for v in group]),
        g.metadata, b'UVAS'+U32.pack(len(g.uvs)),
        b''.join(array(b'UVBS', layer) for layer in g.uvs)))
    return U32.pack(len(body)+4)+body


def split_geoset(g: Geoset) -> list[Geoset]:
    if len(g.groups) <= MAX_GROUPS:
        return [g]
    batches = []
    faces, vertices, groups = [], set(), set()
    for face in g.faces:
        incoming = {g.vertex_groups[v] for v in face}
        if len(groups | incoming) > MAX_GROUPS:
            batches.append((faces, vertices, groups))
            faces, vertices, groups = [], set(), set()
        faces.append(face)
        vertices.update(face)
        groups.update(incoming)
    if faces:
        batches.append((faces, vertices, groups))
    # Retain unused vertices too, including their original skin/UV attributes.
    used = set().union(*(v for _, v, _ in batches))
    for v in sorted(set(range(len(g.vertices)))-used):
        group = g.vertex_groups[v]
        batch = next((b for b in batches if group in b[2] or len(b[2]) < MAX_GROUPS), None)
        if batch is None:
            batch = ([], set(), set())
            batches.append(batch)
        batch[1].add(v)
        batch[2].add(group)
    result = []
    for faces, vertices, groups in batches:
        order = sorted(vertices)
        lookup = {old: new for new, old in enumerate(order)}
        palette = sorted(groups)
        palette_lookup = {old: new for new, old in enumerate(palette)}
        result.append(Geoset([g.vertices[v] for v in order], [g.normals[v] for v in order],
            [tuple(lookup[v] for v in face) for face in faces],
            [palette_lookup[g.vertex_groups[v]] for v in order],
            [g.groups[v] for v in palette], g.metadata,
            [[layer[v] for v in order] for layer in g.uvs]))
    return result


def fix_model(data: bytes) -> tuple[bytes, dict]:
    parts = list(chunks(data))
    if dict(parts).get(b'VERS') != U32.pack(800):
        raise ValueError('Only MDX 800 models are supported')
    original = list(records(dict(parts)[b'GEOS']))
    geosets = [parse_geoset(g) for g in original]
    output, extra, mapping = [], [], {}
    for index, g in enumerate(geosets):
        split = split_geoset(g)
        output.append(original[index] if len(split) == 1 else encode_geoset(split[0]))
        if len(split) > 1:
            mapping[index] = [index]+list(range(len(original)+len(extra), len(original)+len(extra)+len(split)-1))
            extra.extend(encode_geoset(part) for part in split[1:])
    result = bytearray(b'MDLX')
    for tag, body in parts:
        if tag == b'GEOS':
            body = b''.join(output+extra)
        elif tag == b'GEOA' and mapping:
            additions = []
            for record in records(body):
                source = U32.unpack_from(record, 24)[0]
                for target in mapping.get(source, [])[1:]:
                    copy = bytearray(record)
                    U32.pack_into(copy, 24, target)
                    additions.append(bytes(copy))
            body += b''.join(additions)
        elif tag == b'BONE' and mapping:
            copy = bytearray(body)
            offset = 0
            while offset < len(copy):
                size = U32.unpack_from(copy, offset)[0]
                if size < 96 or offset+size+8 > len(copy):
                    raise ValueError('Invalid bone record')
                if U32.unpack_from(copy, offset+size)[0] in mapping:
                    # One source geoset now spans several: keep the same node
                    # animation and mark its binding as Multiple geosets.
                    U32.pack_into(copy, offset+size, 0xFFFFFFFF)
                offset += size+8
            body = bytes(copy)
        result += tag+U32.pack(len(body))+body
    final = [parse_geoset(g) for g in records(dict(chunks(result))[b'GEOS'])]
    if any(len(g.groups) > MAX_GROUPS for g in final):
        raise ValueError('Oversized matrix palette remains')
    report = dict(original_groups=[len(g.groups) for g in geosets],
        fixed_groups=[len(g.groups) for g in final], split_geosets=mapping,
        original_triangles=sum(len(g.faces) for g in geosets),
        fixed_triangles=sum(len(g.faces) for g in final))
    return bytes(result), report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('destination', type=Path)
    args = parser.parse_args()
    result, report = fix_model(args.source.read_bytes())
    args.destination.parent.mkdir(parents=True, exist_ok=True)
    args.destination.write_bytes(result)
    print(json.dumps(report))

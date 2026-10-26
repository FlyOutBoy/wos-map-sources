"""Name each TEST map after its selected hero in W3I, config and lobby header."""
from __future__ import annotations

import argparse
from pathlib import Path
import re
import struct


def map_title(hero: str) -> str:
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", hero):
        raise ValueError("Invalid TEST hero name")
    return f"{hero} — TEST"


def rename_info(data: bytes, title: str) -> bytes:
    if len(data) < 12:
        raise ValueError("Truncated W3I header")
    version = struct.unpack_from("<I", data)[0]
    offset = 28 if version >= 28 else 12
    end = data.find(b"\0", offset)
    if end == -1:
        raise ValueError("W3I map name has no terminator")
    # Replace only the first string; all remaining native map fields stay intact.
    return data[:offset] + title.encode("utf-8") + data[end:]


def rename_source(text: str, title: str) -> str:
    pattern = r'(?m)^([ \t]*call\s+SetMapName\s*\()[^\r\n]*(\)[ \t]*)(?=\r?$)'
    result, count = re.subn(pattern, lambda m: m[1]+'"'+title+'"'+m[2], text)
    if count != 1:
        raise ValueError(f"Expected one TEST SetMapName call, found {count}")
    return result


def rename_staged(directory: Path, source: Path, title: str) -> None:
    info = directory/"war3map.w3i"
    old_info = info.read_bytes()
    old_source = source.read_bytes()
    info_data = rename_info(old_info, title)
    bom = old_source.startswith(b"\xef\xbb\xbf")
    source_data = rename_source(old_source.decode("utf-8-sig"), title).encode("utf-8")
    source_data = (b"\xef\xbb\xbf" if bom else b"") + source_data
    # Validate both inputs before changing either generated file.
    if info_data != old_info:
        info.write_bytes(info_data)
    if source_data != old_source:
        source.write_bytes(source_data)


def rename_archive_header(archive: Path, title: str) -> None:
    with archive.open("r+b") as stream:
        header = stream.read(512)
        # MPQ-only maps get their name from W3I/config, without adding a header.
        if header[:4] != b"HM3W":
            return
        end = header.find(b"\0", 8)
        name = title.encode("utf-8") + b"\0"
        if len(header) != 512 or end < 8 or end+9 > 512 or len(name)+16 > 512:
            raise ValueError("Invalid Warcraft lobby header")
        updated = (header[:8] + name + header[end+1:end+9]).ljust(512, b"\0")
        if updated != header:
            stream.seek(0)
            stream.write(updated)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--hero", required=True)
    parser.add_argument("--directory", type=Path)
    parser.add_argument("--source", type=Path)
    parser.add_argument("--archive", type=Path)
    args = parser.parse_args()
    if (args.directory is None) != (args.source is None) or not (args.archive or args.directory):
        parser.error("provide --directory with --source, or --archive")
    title = map_title(args.hero)
    if args.directory:
        rename_staged(args.directory, args.source, title)
    if args.archive:
        rename_archive_header(args.archive, title)
    print(f"TEST map title: {title}")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Prepare TEST sources from their recorded origins; never write MAIN sources."""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from pathlib import Path

import extract_war3_triggers as fmt


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json(path: Path, value: dict) -> None:
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def inside(root: Path, relative: str) -> Path:
    result = (root / relative).resolve()
    if not result.is_relative_to(root.resolve()):
        raise ValueError(f"Source path escapes {root}: {relative}")
    return result


def stage(workspace: Path, output: Path, base: Path | None = None) -> dict:
    base = base or workspace / "test_map/base"
    workspace, output = workspace.resolve(), output.resolve()
    if not output.is_relative_to(workspace) or any(
        output.is_relative_to(protected) or protected.is_relative_to(output)
        for protected in (workspace / "triggers", workspace / "test_map")
    ):
        raise ValueError("TEST staging must be inside the workspace, outside source directories")
    manifest = read_json(base / "test-source-manifest.json")
    if manifest.get("format") != 2:
        raise ValueError("TEST source manifest must use format 2 (explicit origins)")
    sources = manifest["sources"]
    paths = [entry["path"] for entry in sources]
    if len(set(paths)) != len(paths):
        raise ValueError("Duplicate paths in TEST source manifest")
    if not set(manifest["enabledImports"]).issubset(paths):
        raise ValueError("TEST enabledImports contains an unknown source")
    output.mkdir(parents=True, exist_ok=True)
    # This dedicated generated directory must not retain removed WTG sources.
    for old in output.rglob("*.j"):
        if old.relative_to(output).as_posix() not in paths:
            old.unlink()
    metadata = []
    provenance = []
    for entry in sources:
        relative = entry["path"]
        origin = entry["origin"]
        if origin["kind"] == "shared":
            source = inside(workspace / "triggers", origin["path"])
        elif origin["kind"] == "test":
            if not origin.get("reason"):
                raise ValueError(f"TEST override needs a reason: {relative}")
            source = inside(base, relative)
        elif origin["kind"] == "testHero":
            source = inside(workspace / "test_map/heroes", origin["path"])
        elif origin["kind"] == "testOnly":
            source = inside(workspace / "test_map", origin["path"])
        else:
            raise ValueError(f"Unknown source origin: {origin}")
        target = inside(output, relative)
        target.parent.mkdir(parents=True, exist_ok=True)
        data = source.read_bytes()
        if relative == "Init/Start.j":
            data = data.replace(b"call Crocodile_Register(Hero[i])", b"call TestHero_Register(Hero[i])")
        target.write_bytes(data)
        item = {**entry, **fmt.source_metadata(data), "sha256": hashlib.sha256(data).hexdigest()}
        metadata.append(item)
        provenance.append({"path": relative, "source": str(source), "kind": origin["kind"], "sha256": item["sha256"]})
    for name in ("trigger-manifest.json", "trigger-settings.json"):
        shutil.copy2(base / name, output / name)
    # Refresh declaration metadata after copying current MAIN sources.
    trigger_manifest = read_json(output / "trigger-manifest.json")
    trigger_manifest["sources"] = metadata
    write_json(output / "trigger-manifest.json", trigger_manifest)
    fmt.write_dependency_manifest(output, trigger_manifest)
    write_json(output / "source-provenance.json", {"format": 1, "sources": provenance})
    return manifest


def configure_import(workspace: Path, base: Path, map_dir: Path, archive: Path | None = None) -> None:
    """Retain reviewed override policy while replacing imported map sources."""
    policy_path = workspace / "test_map/base/test-source-manifest.json"
    policy = read_json(policy_path)
    overrides = policy["overrides"]
    shared_mappings = policy.get("sharedMappings", {})
    main = workspace / "triggers"
    main_files = list(main.rglob("*.j"))
    build_config = read_json(workspace / ".vscode/wos-build.json")
    hero = build_config["testHero"]
    manifest = read_json(base / "trigger-manifest.json")
    enabled = []
    for entry in manifest["sources"]:
        relative = entry["path"]
        compatibility = relative.removeprefix("TEST_Compatibility/")
        if relative.startswith("TEST_Compatibility/") and (workspace/"test_map"/compatibility).is_file():
            entry["origin"] = {"kind":"testOnly", "path":compatibility}
        elif Path(relative).name.lower() == f"{hero}.j".lower():
            canonical = main / "Heroes" / f"{hero}.j"
            if canonical.is_file():
                entry["origin"] = {"kind": "shared", "path": canonical.relative_to(main).as_posix()}
            else:
                entry["origin"] = {"kind": "testHero", "path": f"{hero}.j", "reason": "Selected TEST-only hero, imported without enabling it in MAIN."}
        elif relative in overrides:
            entry["origin"] = {"kind": "test", **overrides[relative]}
        else:
            match = main / shared_mappings.get(relative, relative)
            if not match.is_file():
                matches = [p for p in main_files if p.name.lower() == Path(relative).name.lower()]
                match = matches[0] if len(matches) == 1 else None
            if match is not None and match.is_file():
                entry["origin"] = {"kind": "shared", "path": match.relative_to(main).as_posix()}
            else:
                entry["origin"] = {"kind": "test", "reason": "Source exists only in the TEST map; retain its WTG/WCT implementation."}
        if entry["enabled"] and not any(part in [*policy["excludedGameplayCategories"], "TEST_Compatibility"] for part in Path(relative).parts):
            enabled.append(relative)
    result = {"format": 2, "representativeMap": f"{hero}.w3x", "wtgSha256": hashlib.sha256((map_dir / 'war3map.wtg').read_bytes()).hexdigest(),
              "wctSha256": hashlib.sha256((map_dir / 'war3map.wct').read_bytes()).hexdigest(),
              "excludedGameplayCategories": policy["excludedGameplayCategories"], "overrides": overrides,
              "sharedMappings": shared_mappings,
              "sources": manifest["sources"], "enabledImports": enabled}
    archive = archive or Path(build_config.get("testMap", str(Path(build_config["testMapsDir"])/f"{hero}.w3x")))
    if not archive.is_absolute():
        archive = workspace / archive
    result["representativeMapSha256"] = hashlib.sha256(archive.read_bytes()).hexdigest()
    write_json(base / "test-source-manifest.json", result)


def include_resolved(workspace: Path, output: Path, resolution: Path) -> dict:
    """Materialize the actual compiler closure for WTG/WCT, including new roots."""
    workspace, output = workspace.resolve(), output.resolve()
    if not output.is_relative_to(workspace) or any(
        output.is_relative_to(p) or p.is_relative_to(output)
        for p in (workspace / "triggers", workspace / "test_map")
    ):
        raise ValueError("Invalid TEST staging directory")
    report = read_json(resolution)
    manifest = read_json(output / "trigger-manifest.json")
    provenance = read_json(output / "source-provenance.json")
    settings = read_json(output / "trigger-settings.json")
    entries = {s["path"]: s for s in manifest["sources"]}
    origins = {}
    for s in provenance["sources"]:
        origins.setdefault(Path(s["source"]).resolve(), []).append(s["path"])
    resolved = []
    for source_path in report["resolvedSources"]:
        source = Path(source_path).resolve()
        if source.is_relative_to(output):
            relative = source.relative_to(output).as_posix()
            if relative not in entries:
                raise ValueError(f"Unrecorded staged source: {source}")
        elif source in origins:
            matches = origins[source]
            enabled = [p for p in matches if entries[p].get("enabled")]
            if len(enabled or matches) != 1:
                raise ValueError(f"Ambiguous TEST source origin: {source}")
            relative = (enabled or matches)[0]
        else:
            if source.is_relative_to(workspace / "triggers"):
                relative = source.relative_to(workspace / "triggers").as_posix()
                kind = "shared"
            elif source.is_relative_to(workspace / "test_map"):
                relative = "TEST_Compatibility/" + source.relative_to(workspace / "test_map").as_posix()
                kind = "testOnly"
            else:
                raise ValueError(f"Resolved TEST source outside approved roots: {source}")
            if relative in entries:
                raise ValueError(f"Resolved TEST source collides with staged override: {relative}")
            data = source.read_bytes()
            target = inside(output, relative)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(data)
            digest = hashlib.sha256(data).hexdigest()
            entry = {"path": relative, "order": len(entries), "enabled": True,
                     "category": str(Path(relative).parent), "trigger_name": Path(relative).stem,
                     "run_on_map_init": False, "source_bytes": len(data), "sha256": digest,
                     **fmt.source_metadata(data)}
            entries[relative] = entry
            manifest["sources"].append(entry)
            provenance["sources"].append({"path": relative, "source": str(source), "kind": kind, "sha256": digest})
        resolved.append(str(inside(output, relative)))
    enabled_paths = {Path(p).relative_to(output).as_posix() for p in resolved}
    # The editor must compile exactly the same source set as JassHelper, retaining
    # historical triggers as disabled snapshots rather than duplicate providers.
    for entry in manifest["sources"]:
        entry["enabled"] = entry["path"] in enabled_paths
        settings["triggers"][entry["path"]] = entry["enabled"]
    report.setdefault("resolvedOrigins", report["resolvedSources"])
    report["resolvedSources"] = resolved
    write_json(output / "trigger-manifest.json", manifest)
    write_json(output / "trigger-settings.json", settings)
    write_json(output / "source-provenance.json", provenance)
    fmt.write_dependency_manifest(output, manifest)
    write_json(resolution, report)
    return report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("stage", "configure-import", "include-resolved"))
    parser.add_argument("--workspace", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--map-directory", type=Path)
    parser.add_argument("--resolution", type=Path)
    parser.add_argument("--base", type=Path)
    parser.add_argument("--archive", type=Path)
    args = parser.parse_args()
    if args.command == "stage":
        result = stage(args.workspace.resolve(), args.output.resolve(), args.base)
        print(f"TEST sources staged: {len(result['sources'])}")
    elif args.command == "include-resolved":
        if args.resolution is None:
            parser.error("include-resolved requires --resolution")
        result = include_resolved(args.workspace, args.output, args.resolution)
        print(f"TEST editor closure staged: {len(result['resolvedSources'])}")
    else:
        configure_import(args.workspace.resolve(), args.output.resolve(), args.map_directory.resolve(), args.archive)


if __name__ == "__main__":
    main()

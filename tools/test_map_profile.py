"""Select a TEST map by testHero, retaining independent editable data per hero."""
from __future__ import annotations

import argparse
import contextlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

import test_map_sources as sources
import war3_object_workspace as objects


def read(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")


def hero_name(value: str) -> str:
    if not isinstance(value, str) or not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", value):
        raise ValueError("testHero must be a simple hero name, for example Crocodile or Beluga")
    if value.upper() in {"CON","PRN","AUX","NUL",*(f"COM{i}" for i in range(1,10)),*(f"LPT{i}" for i in range(1,10))}:
        raise ValueError("testHero is a reserved Windows filename")
    return value


def absolute(workspace: Path, value: str) -> Path:
    return (workspace/Path(os.path.expandvars(value))).resolve()


def powershell(workspace: Path, script: Path, *args: str) -> None:
    exe = Path(os.environ.get("SystemRoot","C:/Windows"))/"System32/WindowsPowerShell/v1.0/powershell.exe"
    subprocess.run([str(exe),"-NoProfile","-ExecutionPolicy","Bypass","-File",str(script),*map(str,args)],
                   cwd=workspace, check=True, stdout=sys.stderr,
                   creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)


def seed_map(target: Path, candidates: list[Path]) -> Path | None:
    if target.exists():
        if not target.is_file():
            raise ValueError(f"TEST map must be a .w3x file: {target}")
        return None
    previous = next((p for p in candidates if p.is_file() and p.resolve() != target.resolve()),None)
    if previous is None:
        raise ValueError(f"No previous TEST map to copy to {target}; set testMapTemplate once")
    target.parent.mkdir(parents=True,exist_ok=True)
    # Exclusive creation avoids replacing a map created concurrently by the editor.
    with target.open("xb") as output, previous.open("rb") as source:
        shutil.copyfileobj(source,output)
    return previous


def ensure_source(workspace: Path, config: dict, hero: str) -> Path:
    for directory in config.get("testHeroSourceDirs",["triggers/Heroes","test_map/heroes"]):
        folder = absolute(workspace,directory)
        if (folder/f"{hero}.j").is_file():
            return folder/f"{hero}.j"
        nested = sorted((folder/hero).glob("**/*.j"))
        if nested:
            return nested[0]
    target = workspace/"test_map/heroes"/f"{hero}.j"
    target.parent.mkdir(parents=True,exist_ok=True)
    with target.open("x",encoding="utf-8"):
        pass
    return target


def initialize(workspace: Path, config: dict, profile: dict) -> None:
    unpacked, base, template = map(Path,[profile["testMapDirectory"],profile["base"],profile["testBaseSource"]])
    library = absolute(workspace,config["jassHelper"]).parent/"sfmpq.dll"
    powershell(workspace,workspace/".vscode/test-map-archive.ps1","-Mode","Extract",
               "-Map",profile["testMap"],"-Directory",str(unpacked),"-Library",str(library))
    subprocess.run([sys.executable,str(workspace/"tools/extract_war3_triggers.py"),"--wtg",str(unpacked/"war3map.wtg"),
                    "--wct",str(unpacked/"war3map.wct"),"--output",str(base),"--allow-stale-counts"],
                   cwd=workspace,check=True,stdout=sys.stderr)
    sources.configure_import(workspace,base,unpacked,archive=Path(profile["testMap"]))
    # Keep the reviewed arena overrides, rather than compiled copies of old shared systems.
    policy = read(workspace/"test_map/base/test-source-manifest.json")
    for relative in policy["overrides"]:
        source = workspace/"test_map/base"/relative
        destination = base/relative
        if source.is_file() and destination.is_file():
            shutil.copy2(source,destination)
    imports = base.parent/"template-imports.j"
    enabled = read(base/"test-source-manifest.json")["enabledImports"]
    compile_sources = [base/p for p in enabled]
    compile_sources += [absolute(workspace,p) for p in config.get("testOnlySources",[])]
    imports.write_text("\n".join(f'//! import "{p}"' for p in compile_sources),encoding="utf-8")
    template.parent.mkdir(parents=True,exist_ok=True)
    powershell(workspace,workspace/"tools/create-main-mapscript.ps1","-War3MapJ",str(unpacked/"war3map.j"),
               "-CompileInput",str(imports),"-Output",str(template),"-Profile","TEST","-TestTemplate")
    with contextlib.redirect_stdout(sys.stderr):
        objects.export_workspace(unpacked,Path(profile["json_directory"]),Path(profile["raw_json_directory"]),
                                 absolute(workspace,config.get("commonJ","libs/common.j")),False)


def ensure(workspace: Path, config_path: Path | None = None) -> dict:
    workspace = workspace.resolve()
    config_path = (config_path or workspace/".vscode/wos-build.json").resolve()
    config = read(config_path)
    hero = hero_name(config.get("testHero"))
    maps = absolute(workspace,config["testMapsDir"])
    target = maps/f"{hero}.w3x"
    build = absolute(workspace,config.get("buildDir","_build"))
    state_path = workspace/"test_map/profiles/state.json"
    legacy_state = build/"test-profile-state.json"
    state = read(state_path) if state_path.is_file() else read(legacy_state) if legacy_state.is_file() else {"profiles":{}}
    previous = state.get("active",{})
    fallback = config.get("testMapTemplate",config.get("testMap",""))
    candidates = []
    if previous:
        candidates += [Path(previous["testMap"]),build/f'{previous["hero"]}_Test.w3x']
    if fallback:
        candidates.append(absolute(workspace,fallback))
    copied = seed_map(target,candidates)
    source = ensure_source(workspace,config,hero)
    profile = state.get("profiles",{}).get(hero)
    if profile and Path(profile["testMap"]).resolve() != target.resolve():
        raise ValueError("testMapsDir differs from the saved profile; keep the profile's map directory or use a separate workspace")
    if not profile:
        # Adopt the original editable Crocodile workspace once; never re-export its local JSON.
        legacy = workspace/"test_map/unpacked"
        use_legacy = not state.get("profiles") and fallback and Path(fallback).stem.casefold() == hero.casefold() and (legacy/"war3map.wct").is_file()
        root = workspace/"test_map" if use_legacy else workspace/"test_map/profiles"/hero
        profile = {"hero":hero,"testMap":str(target),"testMapDirectory":str(root/"unpacked"),
                   "base":str(root/"base"),"testBaseSource":str(root/"map_source/TestBase.vj"),
                   "json_directory":str(root/"object-data"),"raw_json_directory":str(root/".object-data-raw")}
        if use_legacy:
            profile["testBaseSource"] = str(absolute(workspace,config.get("testBaseSource","test_map/map_source/TestBase.vj")))
        else:
            initialize(workspace,config,profile)
    imported_hero = workspace/"test_map/profiles"/hero/"imported-hero"/f"{hero}.j"
    test_hero = workspace/"test_map/heroes"/f"{hero}.j"
    manifest_path = Path(profile['base'])/'test-source-manifest.json'
    manifest = read(manifest_path) if manifest_path.is_file() else {}
    imported_into_test = any(Path(entry['path']).name.casefold() == f'{hero}.j'.casefold()
                             and entry.get('origin',{}).get('kind') == 'testHero'
                             for entry in manifest.get('sources',[]))
    if test_hero.is_file() and (imported_into_test or profile.get('heroSource') == str(test_hero)):
        source = test_hero
    elif imported_hero.is_file():
        source = imported_hero
    profile = dict(profile,heroSource=str(source),configPath=str(config_path))
    effective = dict(config,**profile)
    if source in (imported_hero,test_hero):
        effective["testHeroSourceDirs"] = [str(source.parent),*config.get("testHeroSourceDirs",["triggers/Heroes","test_map/heroes"])]
    hook = workspace/"test_map/profiles"/hero/"compatibility/TestHero.j"
    hook.parent.mkdir(parents=True,exist_ok=True)
    hero_files = [source] if source.parent.name != hero else list(source.parent.rglob("*.j"))
    registration = f"{hero}_Register"
    has_registration = any(re.search(rf"^[ \t]*function\s+{re.escape(registration)}\s+takes\s+unit\s+\w+\s+returns\s+nothing", p.read_text(encoding="utf-8-sig"), re.MULTILINE) for p in hero_files)
    call = f"    call {registration}.evaluate(u)\n" if has_registration else ""
    hook.write_text(f"library TestHeroAdapter\nfunction TestHero_Register takes unit u returns nothing\n{call}endfunction\nendlibrary\n",encoding="utf-8")
    effective["testOnlySources"] = [*config.get("testOnlySources",[]),str(hook)]
    effective_path = build/"test-profile.json"
    write(effective_path,effective)
    sync = {"build_config":str(effective_path),"map_key":"testMapDirectory",
            "json_directory":profile["json_directory"],"raw_json_directory":profile["raw_json_directory"],
            "common_j":str(absolute(workspace,config.get("commonJ","libs/common.j"))),
            "backup_directory":str(workspace/"backups/test-objects"/hero),
            "trigger_directory":str(build/"test-sources"),"trigger_backup_directory":str(workspace/"backups/test-triggers"/hero),
            "prepare_test_sources":True,"allow_stale_wtg_counts":True}
    write(build/"test-profile-sync.json",sync)
    state.setdefault("profiles",{})[hero] = profile
    state["active"] = profile
    write(state_path,state)
    if copied:
        print(f"TEST map created: {target} (copied from {copied})",file=sys.stderr)
    return effective


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace",type=Path,default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--config",type=Path)
    args = parser.parse_args()
    try:
        context = ensure(args.workspace,args.config)
        print(str(absolute(args.workspace,context.get("buildDir","_build"))/"test-profile.json"))
    except (OSError,ValueError,objects.raw.FormatError,subprocess.CalledProcessError) as exc:
        parser.exit(1,f"TEST PROFILE ERROR: {exc}\n")


if __name__ == "__main__":
    main()

"""Disable custom presentation in TEST while retaining normal gameplay systems.

Generated guards are reversible on map import; canonical MAIN sources stay intact.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import re

import extract_war3_triggers as fmt
from test_map_sources import read_json, write_json


BEGIN = "    // WOS_TEST_RUNTIME_BEGIN\n    static if not LIBRARY_WOSTestMinimalRuntime then\n"
END = "    endif\n    // WOS_TEST_RUNTIME_END\n"
HOOK_BEGIN = "    // WOS_TEST_COMBAT_BEGIN\n    static if LIBRARY_WOSTestMinimalRuntime then\n"
HOOK_END = "    endif\n    // WOS_TEST_COMBAT_END\n"
FUNCTION = re.compile(r"^[ \t]*(?:(?:private|public|static|stub|constant)\s+)*(function|method)\s+(\w+)\b[^\n]*\n", re.M)
TOKENS = re.compile(r'//[^\n]*|/\*[\s\S]*?\*/|"(?:\\.|[^"\\])*"')
DISABLED_UI_SOURCES = ("TooltipBuilder.j", "UniversalTooltips.j", "WOSUI.j")
UI_OWNER_SOURCES = {
    "AbilityRangePreview.j", "ArenaMinimap.j", "Captain_Draft.j", "EMOTES.j",
    "MatchVotes.j", "MusicPlayer.j", "Player_Pick_Mode.j", "Scoreboard.j",
    "ShowCD.j", "ShowTextCD.j", "TeamMapPings.j", "UI_CAREER.j",
    "WoS_Hero_Icons_Init.j", "WoS_Pick_Init.j", "WoS_Shop_Init.j", "Starts.j",
}


def minimal_ui(workspace: Path, destination: Path) -> None:
    """Keep legacy APIs inert except the requested isolated hero progress bars.

    The real libraries remain disabled WCT snapshots. Generate the compatibility
    declarations from current MAIN APIs so companion hero references still link.
    """
    blocks = ["// Generated TEST UI compatibility; only isolated hero bars render.\n"]
    for filename, library in (("WOSUI.j", "WOSUI"), ("UniversalTooltips.j", "AAUniversalTooltips")):
        source = workspace/"triggers/WOS_Start"/filename
        text = source.read_text(encoding="utf-8-sig") if source.is_file() else ""
        blocks.append(f"library {library}\n")
        if library == "WOSUI":
            declarations = []
            for section in re.findall(r"(?m)^globals\r?\n([\s\S]*?)^endglobals", text):
                for line in section.splitlines():
                    code = line.strip()
                    if not code or code.startswith(("private ", "//")):
                        continue
                    # Public declarations retain constants, but never allocate UI state.
                    code = code.replace("InitHashtable()", "null").replace("CreateTrigger()", "null")
                    if re.search(r"\w+\s*\(", mask(code)):
                        raise ValueError(f"Unsafe minimal UI global: {code}")
                    declarations.append("    "+code)
            if declarations:
                blocks.append("globals\n"+"\n".join(declarations)+"\nendglobals\n")
            # Reuse the actual meter frame/placement helpers, not the HUD
            # bootstrap, docking loop, tooltip queues or their global state.
            bar_helpers = ("WUI_Passive", "WUI_Piece", "WUI_Pin", "WUI_GoldFrame")
            for helper in bar_helpers:
                match = re.search(r"(?m)^[ \t]*(?:private )?function "+helper+r" takes[^\n]*\n[\s\S]*?^[ \t]*endfunction", text)
                if match is None:
                    raise ValueError("Missing TEST hero-bar helper: "+helper)
                body = match[0].strip()
                for original in bar_helpers:
                    body = re.sub(r"\b"+original+r"\b", "WUI_Test"+original[4:], body)
                body = re.sub(r"^(?:private )?function", "private function", body)
                blocks.append(body+"\n")
            blocks.append((Path(__file__).parent/"templates/test_hero_bars.j").read_text(encoding="utf-8"))
        pattern = r"(?m)^[ \t]*(public )?function (\w+) takes ([^\r\n]+) returns (\w+)[ \t]*\r?$"
        for visibility, name, parameters, result in re.findall(pattern, text):
            if name.startswith("WOS_UTB_Init_"):
                continue
            blocks.append(f"{visibility}function {name} takes {parameters} returns {result}\n")
            if library == "WOSUI" and name in {"WUI_HeroProgress", "WUI_HeroProgressText"}:
                value = 'valueText' if name.endswith('Text') else '""'
                blocks.append(f"    call WUI_TestHeroProgress(hero, abilityId, title, remaining, total, seconds, {value})\n")
            elif result != "nothing":
                value = {"string": '\"\"', "integer": "0", "real": "0.0", "boolean": "false"}.get(result, "null")
                if name in {"WUI_OwnersDone", "WUI_StartupComplete"}:
                    value = "true"
                blocks.append(f"    return {value}\n")
            blocks.append("endfunction\n")
        blocks.append("endlibrary\n")
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text("".join(blocks), encoding="utf-8")


def unguard(text: str) -> str:
    if text.count(HOOK_BEGIN) != text.count(HOOK_END):
        raise ValueError("Incomplete generated TEST combat hook")
    text = re.sub(re.escape(HOOK_BEGIN)+r"[\s\S]*?"+re.escape(HOOK_END), "", text)
    if text.count(BEGIN) != text.count(END):
        raise ValueError("Incomplete generated TEST runtime guard; restore its paired markers before importing")
    return text.replace(BEGIN, "").replace(END, "")


def mask(text: str) -> str:
    return TOKENS.sub(lambda m: re.sub(r"[^\n]", " ", m.group()), text)


def lighten(text: str, relative: str, hero: str, minimal: bool) -> tuple[str, list[str]]:
    text = unguard(text)
    if not minimal:
        return text, []
    code = mask(text)
    # TEST keeps normal gameplay initialization. Only presentation owners are
    # suppressed; disabling their dependencies broke shared system contracts.
    ui_owner = ("wos_start" in [part.casefold() for part in Path(relative).parts]
                and Path(relative).name in UI_OWNER_SOURCES)
    disabled_initializers = {
        match[2] for match in re.finditer(r"^[ \t]*(?:library|scope)\s+(\w+)[^\n]*?\binitializer\s+(\w+)", code, re.M)
        if ui_owner
    }
    ranges = []
    suppressed = []
    for match in FUNCTION.finditer(code):
        kind, name = match[1], match[2]
        disabled = (name in disabled_initializers
                    or (ui_owner and name.startswith("InitTrig_"))
                    or name in {"InitSounds", "Trig_Start_Actions3", "InitAllyCDTimer", "InitTrig_ESC"})
        # TEST Start already owns Escape. Registering the MAIN ESC as well runs
        # both the targeted reset and the legacy UnitResetCooldown on one key.
        # Direct TEST subscription stays unique even when normal LvlUpCheck is
        # active; its player-specific subscription is guarded below.
        hook = {"InitTrig_CastCheck": "    call TriggerRegisterAnyUnitEventBJ(gg_trg_CastCheck, EVENT_PLAYER_UNIT_SPELL_EFFECT)\n",
                "Trig_Start_Actions3": "    call TestHero_Reset.evaluate(Hero[GetPlayerId(GetTriggerPlayer())])\n",
                "Trig_Start_Actions4": "    call CreateKeys()\n"}.get(name)
        if hook:
            end = re.search(r"^[ \t]*end" + kind + r"\b", code[match.end():], re.M)
            if end is None:
                raise ValueError(f"Cannot find end of {relative}:{name}")
            # Keys must exist before hero registration and any combat callback.
            offset = match.end()+end.start()
            if name == "Trig_Start_Actions4":
                locals_prefix = re.match(r'(?:[ \t]*(?:local\b[^\n]*)?\n)*', code[match.end():])
                offset = match.end()+locals_prefix.end()
            ranges.append((offset, offset, HOOK_BEGIN+hook+HOOK_END))
        if not disabled:
            continue
        end = re.search(r"^[ \t]*end" + kind + r"\b", code[match.end():], re.M)
        if end is None:
            raise ValueError(f"Cannot find end of {relative}:{name}")
        ranges.append((match.end(), match.end()+end.start(), None))
        suppressed.append(name)

    # TEST's historical startup probes a foreign MP3 for every local player.
    for match in re.finditer(r"^[ \t]*loop\b[\s\S]*?^[ \t]*endloop[^\n]*\n", code, re.M):
        if "GetSoundFileDuration" in match.group() and not any(a <= match.start() < b for a, b, _ in ranges):
            ranges.append((*match.span(), None))
            suppressed.append("sound-duration-probe")
    calls = r"SetMapMusic|PlayMusic|PlayMusicEx|PlayThematicMusic|SetAmbientDaySound|SetAmbientNightSound|BlzLoadTOCFile"
    for match in re.finditer(r"^[ \t]*call\s+(?:"+calls+r")\s*\([^\n]*\n", code, re.M):
        if not any(a <= match.start() < b for a, b, _ in ranges):
            ranges.append((*match.span(), None))
            suppressed.append(match.group().strip().split("(")[0])
    # hs already exists at library initialization; replacing it loses live keys.
    for match in re.finditer(r"^[ \t]*set\s+hs\s*=\s*InitHashtable\(\)[^\n]*\n", code, re.M):
        if not any(a <= match.start() < b for a, b, _ in ranges):
            ranges.append((*match.span(), None))
            suppressed.append("hashtable-reset")
    # MAIN registers SPELL_EFFECT once per player from the level-up handler.
    # TEST already registers the same handler for all players directly.
    for match in re.finditer(r"^[ \t]*call\s+TriggerRegisterPlayerUnitEvent\s*\(\s*gg_trg_CastCheck\s*,[^\n]*\n", code, re.M):
        if not any(a <= match.start() < b for a, b, _ in ranges):
            ranges.append((*match.span(), None))
            suppressed.append("duplicate-cast-subscription")
    for start, end, insertion in sorted(ranges, key=lambda value: (value[0], value[1]), reverse=True):
        text = text[:start] + (insertion if insertion is not None else BEGIN + text[start:end] + END) + text[end:]
    return text, suppressed


def read_source(path: Path) -> tuple[str, bool, bool]:
    data = path.read_bytes()
    return data.decode("utf-8-sig").replace("\r\n", "\n"), data.startswith(b"\xef\xbb\xbf"), b"\r\n" in data


def write_source(path: Path, text: str, bom: bool, crlf: bool) -> None:
    data = (text.replace("\n", "\r\n") if crlf else text).encode("utf-8")
    path.write_bytes((b"\xef\xbb\xbf" if bom else b"") + data)


def refresh_metadata(stage: Path) -> None:
    manifest = read_json(stage/"trigger-manifest.json")
    for entry in manifest["sources"]:
        data = (stage/entry["path"]).read_bytes()
        entry.update(fmt.source_metadata(data), sha256=hashlib.sha256(data).hexdigest(), source_bytes=len(data))
    write_json(stage/"trigger-manifest.json", manifest)
    fmt.write_dependency_manifest(stage, manifest)


def restore_import(stage: Path) -> None:
    for path in stage.rglob("*.j"):
        text, bom, crlf = read_source(path)
        restored = unguard(text)
        if restored != text:
            write_source(path, restored, bom, crlf)
    refresh_metadata(stage)


def apply(resolution: Path, template: Path, source: Path, minimal: bool) -> dict:
    report = read_json(resolution)
    stage = Path(report["stage"]).resolve()
    suppressed = {}
    for value in report["resolvedSources"]:
        path = Path(value).resolve()
        if not path.is_relative_to(stage):
            raise ValueError(f"TEST runtime may only change staged sources: {path}")
        text, bom, crlf = read_source(path)
        transformed, disabled = lighten(text, path.relative_to(stage).as_posix(), report["hero"], minimal)
        if transformed != text:
            write_source(path, transformed, bom, crlf)
        if disabled:
            suppressed[path.relative_to(stage).as_posix()] = disabled
    refresh_metadata(stage)
    provenance = read_json(stage/"source-provenance.json")
    for entry in provenance["sources"]:
        entry["sha256"] = hashlib.sha256((stage/entry["path"]).read_bytes()).hexdigest()
    write_json(stage/"source-provenance.json", provenance)
    text, bom, crlf = read_source(template)
    text, disabled = lighten(text, "TestBase.vj", report["hero"], minimal)
    if disabled:
        suppressed["TestBase.vj"] = disabled
    marker = "// __TEST_SOURCE_IMPORTS__"
    if text.count(marker) != 1:
        raise ValueError("TEST template must contain exactly one source marker")
    imports = "\n".join(f'//! import "{p}"' for p in report["resolvedSources"])
    write_source(source, text.replace(marker, imports), bom, crlf)
    report["minimalRuntime"] = minimal
    report["suppressedRuntime"] = suppressed
    write_json(resolution, report)
    return report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("apply", "restore-import"))
    parser.add_argument("--workspace", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--stage", type=Path)
    parser.add_argument("--resolution", type=Path)
    parser.add_argument("--template", type=Path)
    parser.add_argument("--source", type=Path)
    parser.add_argument("--minimal", action="store_true")
    args = parser.parse_args()
    if args.command == "restore-import":
        if args.stage is None:
            parser.error("restore-import requires --stage")
        stage = args.stage.resolve()
    else:
        if any(value is None for value in (args.resolution, args.template, args.source)):
            parser.error("apply requires --resolution, --template and --source")
        stage = Path(read_json(args.resolution)["stage"]).resolve()
    root = args.workspace.resolve()
    if not stage.is_relative_to(root) or any(stage.is_relative_to(root/p) or (root/p).is_relative_to(stage) for p in ("triggers", "test_map")):
        parser.error("runtime operations require a generated directory inside the workspace")
    if args.command == "restore-import":
        restore_import(stage)
        print("TEST generated runtime guards restored before source import")
    else:
        result = apply(args.resolution, args.template, args.source, args.minimal)
        count = sum(map(len, result["suppressedRuntime"].values()))
        print(f"TEST native UI/audio policy: {args.minimal}; {count} sources with presentation/startup guards; gameplay retained")


if __name__ == "__main__":
    main()

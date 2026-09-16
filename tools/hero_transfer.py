#!/usr/bin/env python3
"""Register one hero J source in the WoS pick/build systems."""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path


CATEGORIES = {
    1: ("Gacha", 0, 1),
    2: ("Bleach", 1, 2),
    3: ("Fairy Tail", 2, 3),
    4: ("One Piece", 3, 4),
    5: ("Jujutsu Kaisen", 4, 5),
    6: ("Other", 5, 6),
}

DIFFICULTIES = {
    1: ("Easy", "|c0028E800Easy|r"),
    2: ("Normal", "|c00FF9428Normal|r"),
    3: ("Hard", "|c00FF0303Hard|r"),
}

DEFAULT_ITEMS = ["I00O", "I024", "I00M", "I00T", "I01Q", "I03T"]


class TransferError(RuntimeError):
    pass


@dataclass
class TextFile:
    path: Path
    text: str
    newline: str
    bom: bool

    @classmethod
    def load(cls, path: Path) -> "TextFile":
        if not path.is_file():
            raise TransferError(f"Required file not found: {path}")
        data = path.read_bytes()
        bom = data.startswith(b"\xef\xbb\xbf")
        if bom:
            data = data[3:]
        try:
            decoded = data.decode("utf-8")
        except UnicodeDecodeError as exc:
            raise TransferError(f"Expected UTF-8 text: {path}: {exc}") from exc
        newline = "\r\n" if b"\r\n" in data else "\n"
        return cls(path=path, text=decoded.replace("\r\n", "\n"), newline=newline, bom=bom)

    def encoded(self) -> bytes:
        data = self.text.replace("\n", self.newline).encode("utf-8")
        return (b"\xef\xbb\xbf" + data) if self.bom else data


def marker(hero: str, part: str) -> str:
    return f"HERO TRANSFER: {hero} / {part}"


def function_span(text: str, name: str) -> tuple[int, int]:
    start_match = re.search(rf"(?m)^\s*function\s+{re.escape(name)}\s+takes\b", text)
    if not start_match:
        raise TransferError(f"Function not found: {name}")
    end_match = re.search(r"(?m)^\s*endfunction\s*$", text[start_match.start():])
    if not end_match:
        raise TransferError(f"Function has no endfunction: {name}")
    return start_match.start(), start_match.start() + end_match.end()


def edit_function(text: str, name: str, editor) -> str:
    start, end = function_span(text, name)
    old = text[start:end]
    new = editor(old)
    if old == new:
        return text
    return text[:start] + new + text[end:]


def insert_once(text: str, anchor: str, block: str, description: str, *, before: bool = True) -> str:
    count = text.count(anchor)
    if count != 1:
        raise TransferError(f"{description}: expected one insertion anchor, found {count}")
    return text.replace(anchor, block + anchor if before else anchor + block, 1)


def parse_hero(hero_file: Path) -> tuple[str, dict[str, str]]:
    source = TextFile.load(hero_file).text
    declarations: dict[str, str] = {}
    for found in re.finditer(
        r"(?m)^\s*(?:private\s+|public\s+)?(?:constant\s+)?integer\s+"
        r"([A-Za-z_][A-Za-z0-9_]*)\s*=\s*'([^'\r\n]{4})'",
        source,
    ):
        declarations[found.group(1)] = found.group(2)

    stem = hero_file.stem
    if f"{stem}_ID" in declarations:
        hero = stem
    else:
        candidates = [name[:-3] for name in declarations if name.endswith("_ID") and len(name) > 3]
        primary = [candidate for candidate in candidates if f"{candidate}Q_ID" in declarations]
        if len(primary) != 1:
            raise TransferError(
                f"Cannot determine hero prefix from {hero_file}. Expected {stem}_ID and {stem}Q_ID."
            )
        hero = primary[0]

    required = [f"{hero}_ID"] + [f"{hero}{slot}_ID" for slot in "QWERT"]
    missing = [name for name in required if name not in declarations]
    if missing:
        raise TransferError("Hero source is missing required ID declarations: " + ", ".join(missing))
    return hero, declarations


def choose_number(prompt: str, choices: dict[int, tuple], supplied: int | None) -> int:
    if supplied is not None:
        if supplied not in choices:
            raise TransferError(f"Invalid value {supplied} for {prompt}")
        return supplied
    while True:
        answer = input(prompt).strip()
        if answer.isdigit() and int(answer) in choices:
            return int(answer)
        print("Please enter one of: " + ", ".join(str(value) for value in choices))


def load_items(workspace: Path) -> dict[str, str]:
    path = workspace / "object-data" / "items.json"
    if not path.is_file():
        raise TransferError(f"Item object data not found: {path}")
    document = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(document, dict):
        raise TransferError(f"Expected an object at the root of {path}")
    return {
        rawcode.upper(): str(value.get("name") or "<unnamed item>")
        for rawcode, value in document.items()
        if isinstance(rawcode, str) and isinstance(value, dict)
    }


def normalize_item_input(value: str) -> list[str]:
    if value.strip().casefold() in {"", "d", "default"}:
        return DEFAULT_ITEMS.copy()
    result = [part.strip().strip("'\"").upper() for part in re.split(r"[\s,;]+", value) if part.strip()]
    if len(result) != 6:
        raise TransferError("Recommended items must contain exactly six rawcodes")
    for rawcode in result:
        if not re.fullmatch(r"[A-Za-z0-9_]{4}", rawcode):
            raise TransferError(f"Invalid item rawcode: {rawcode}")
    return result


def choose_items(item_names: dict[str, str], supplied: str | None) -> list[str]:
    print("\nDefault recommended items:")
    for rawcode in DEFAULT_ITEMS:
        print(f"  {rawcode}  {item_names.get(rawcode, '<not found>')}")
    if supplied is None:
        supplied = input(
            "Press Enter for defaults, or enter six item IDs separated by spaces (without quotes): "
        )
    result = normalize_item_input(supplied)
    missing = [rawcode for rawcode in result if rawcode not in item_names]
    if missing:
        raise TransferError("Item IDs not found in object-data/items.json: " + ", ".join(missing))
    return result


def find_existing_slot(builds: str, hero: str) -> tuple[int, int] | None:
    match = re.search(rf"Hero_ID([0-5])\[(?:n|\d+)\]\s*=\s*{re.escape(hero)}_ID\b", builds)
    if not match:
        return None
    category_index = int(match.group(1))
    before = builds[:match.start()]
    slot_matches = list(re.finditer(r"(?m)^\s*set\s+n\s*=\s*(\d+)\s*$", before))
    if not slot_matches:
        raise TransferError(f"Cannot determine the existing slot for {hero}_ID")
    return category_index, int(slot_matches[-1].group(1))


def next_slot(builds: str, category_index: int) -> int:
    values: list[int] = []
    for found in re.finditer(rf"Hero_ID{category_index}\[(?:n|(\d+))\]\s*=", builds):
        if found.group(1) is not None:
            values.append(int(found.group(1)))
            continue
        before = builds[:found.start()]
        prior = list(re.finditer(r"(?m)^\s*set\s+n\s*=\s*(\d+)\s*$", before))
        if prior:
            values.append(int(prior[-1].group(1)))
    return max(values, default=-1) + 1


def add_build_entry(text: str, hero: str, category_index: int, slot: int, has_f: bool, has_g: bool) -> str:
    part = marker(hero, "BuildsForChars")
    if part in text or re.search(rf"Hero_ID{category_index}\[(?:n|{slot})\]\s*=\s*{re.escape(hero)}_ID\b", text):
        return text
    start, end = function_span(text, "MyHeroIdInit")
    body = text[start:end]
    separators = list(re.finditer(r"(?m)^\s*//=+.*?=+\s*$", body))
    assignment = re.search(rf"Hero_ID{category_index}\[", body)
    if not assignment:
        raise TransferError(f"BuildsForChars: category Hero_ID{category_index} not found")
    following = [match.start() for match in separators if match.start() > assignment.start()]
    if not following:
        raise TransferError("BuildsForChars: category boundary not found")
    insert_at = min(following)
    ability_lines = "\n".join(
        f"    call UnitAddAbility(Hero_ID{category_index}_Dummy[n], {hero}{letter}_ID)"
        for letter in "QWERT" + ("F" if has_f else "") + ("G" if has_g else "")
    )
    block = (
        f"    // {part}\n"
        f"    set n = {slot}\n"
        "    set MaxHeroes = MaxHeroes + 1\n"
        f"    set Hero_ID{category_index}[n] = {hero}_ID // {hero}\n"
        f"    set Hero_ID{category_index}_Dummy[n] = CreateUnit(Player(12), Hero_ID{category_index}[n], GetRectCenterX(gg_rct_Test), GetRectCenterY(gg_rct_Test), 0)\n"
        f"    call ShowUnit(Hero_ID{category_index}_Dummy[n], false)\n"
        f"{ability_lines}\n"
    )
    new_body = body[:insert_at] + block + body[insert_at:]
    return text[:start] + new_body + text[end:]


def add_random_pick(text: str, hero: str, category_index: int, slot: int) -> str:
    part = marker(hero, "RandomPick")
    if part in text:
        return text
    def editor(body: str) -> str:
        anchor = '        endif\n        call MakeSoundLocal("Pick\\\\PickPick2",p)'
        block = (
            f"        // {part}\n"
            f"        elseif k2 == Hero_ID{category_index}[{slot}] then\n"
            f"            set FRAME_PlayerPickString[pid] = \"{hero}\"\n"
            f"            call MakeSoundLocal(\"war3mapimported\\\\Hero_{hero}_Pick1\", p)\n"
        )
        return insert_once(body, anchor, block, "RandomPick")
    return edit_function(text, "RandomPick", editor)


def add_picker_details(text: str, hero: str, page: int, mode: int, difficulty_text: str) -> str:
    part = marker(hero, "OnClick details")
    if part in text:
        return text
    def editor(body: str) -> str:
        icon_pos = body.find('            set iconQ = "ReplaceableTextures\\\\CommandButtons\\\\BTNHero_"')
        if icon_pos < 0:
            raise TransferError("OnClick details: icon setup anchor not found")
        selection = body[:icon_pos]
        outer_pattern = re.compile(r"(?m)^            (?:if|elseif) \(?PlayerFrameCurrentPage_ID\[pid\].*$")
        outer = list(outer_pattern.finditer(selection))
        selected = None
        for index, found in enumerate(outer):
            line = found.group(0)
            if page in (5, 6):
                matches = "== 5" in line and "== 6" in line
            else:
                matches = f"== {page}" in line and "== 5" not in line and "== 6" not in line
            if matches:
                selected = (found.start(), outer[index + 1].start() if index + 1 < len(outer) else icon_pos)
                break
        if selected is None:
            raise TransferError(f"OnClick details: page {page} branch not found")
        section_start, section_end = selected
        section = body[section_start:section_end]
        block = (
            f"                // {part}\n"
            f"                elseif GetHeroId(PlayerFrameCurrentPage_ID[pid], k3) == {hero}_ID then\n"
            f"                    set s = \"{hero}\"\n"
            f"                    set b = {mode}\n"
            f"                    set s_name = \"{hero}\"\n"
            "                    if GetLocalPlayer() == p then\n"
            f"                        call BlzFrameSetText(FRAME_PlayerPickDifficultText, \"|c00FFFC01Difficulty: \" + \"{difficulty_text}\")\n"
            "                    endif\n"
        )
        closing = list(re.finditer(
            r"(?m)^                endif\n"
            r"                set PlayerFrameCurrent_ID\[pid\]\s*=.*$",
            section,
        ))
        if len(closing) != 1:
            raise TransferError(
                f"OnClick details: expected one category-chain end, found {len(closing)}"
            )
        insert_at = closing[0].start()
        section = section[:insert_at] + block + section[insert_at:]
        return body[:section_start] + section + body[section_end:]
    return edit_function(text, "OnClick", editor)


def add_picker_sounds(text: str, hero: str, category_index: int, slot: int) -> str:
    part = marker(hero, "OnClick sounds")
    if part in text:
        return text
    def editor(body: str) -> str:
        anchor = "        endif\n    endif\n    if clicked == FRAME_Pick[3] then"
        sound_lines = "\n".join(
            (
                f"            {'if' if index == 0 else 'elseif'} i == {index} then\n"
                f"                call MakeSoundLocal(\"war3mapimported\\\\Hero_{hero}_Pick{index + 1}\", p)"
            )
            for index in range(5)
        )
        block = (
            f"        // {part}\n"
            f"        elseif PlayerFrameCurrent_ID[pid] == Hero_ID{category_index}[{slot}] then\n"
            f"{sound_lines}\n"
            "            endif\n"
        )
        return insert_once(body, anchor, block, "OnClick sounds")
    return edit_function(text, "OnClick", editor)


def add_confirm_pick(text: str, hero: str, category_index: int, slot: int) -> str:
    part = marker(hero, "OnClick confirm")
    if part in text:
        return text
    def editor(body: str) -> str:
        anchor = "        endif\n       // set Hero_ID0[0] = 12"
        block = (
            f"        // {part}\n"
            f"        elseif id == Hero_ID{category_index}[{slot}] then\n"
            f"            set FRAME_PlayerPickString[pid] = \"{hero}\"\n"
            f"            call MakeSoundLocal(\"war3mapimported\\\\Hero_{hero}_Pick2\", p)\n"
        )
        return insert_once(body, anchor, block, "OnClick confirm")
    return edit_function(text, "OnClick", editor)


def add_guide_tooltips(
    text: str, hero: str, category_index: int, slot: int, has_f: bool, has_g: bool
) -> str:
    part = marker(hero, "GuideRefreshAbilityTooltip")
    if part in text:
        return text
    def editor(body: str) -> str:
        anchor = "        endif\n        if id != 0 then"
        slots = list("QWERT") + (["F"] if has_f else []) + (["G"] if has_g else [])
        ability_lines = "\n".join(
            f"            {'if' if index == 0 else 'elseif'} hoverSlot == {index} then\n"
            f"                set id = {hero}{letter}_ID"
            for index, letter in enumerate(slots)
        )
        # G always belongs to UI slot 6 even when F is absent.
        if has_g and not has_f:
            ability_lines = ability_lines.replace("elseif hoverSlot == 5 then\n                set id = " + hero + "G_ID",
                                                    "elseif hoverSlot == 6 then\n                set id = " + hero + "G_ID")
        block = (
            f"        // {part}\n"
            f"        elseif PlayerFrameCurrent_ID[pid] == Hero_ID{category_index}[{slot}] then\n"
            f"            set i = {slot}\n"
            f"            set d = Hero_ID{category_index}_Dummy[i]\n"
            f"{ability_lines}\n"
            "            endif\n"
        )
        return insert_once(body, anchor, block, "GuideRefreshAbilityTooltip")
    return edit_function(text, "GuideRefreshAbilityTooltip", editor)


def add_shop_registry(text: str, hero: str, page: int, slot: int) -> str:
    part = marker(hero, "InitHeroShopRegistry")
    if part in text:
        return text
    def editor(body: str) -> str:
        shops = [int(value) for value in re.findall(r"//\s*shop\s+(\d+)", body, re.IGNORECASE)]
        shop = max(shops, default=-1) + 1
        anchor = "endfunction"
        block = (
            f"    // {part}\n"
            f"    call RegisterShopHero({hero}_ID, {page}, {slot})  // shop {shop}\n"
        )
        return insert_once(body, anchor, block, "InitHeroShopRegistry")
    return edit_function(text, "InitHeroShopRegistry", editor)


def add_learn_spells(text: str, hero: str) -> str:
    part = marker(hero, "LearnHeroSpells")
    if part in text:
        return text
    def editor(body: str) -> str:
        anchor = "endif\nloop\nexitwhen i == 5"
        block = (
            f"// {part}\n"
            f"elseif id == {hero}_ID then\n"
            f"set q = {hero}Q_ID\n"
            f"set w = {hero}W_ID\n"
            f"set e = {hero}E_ID\n"
            f"set r = {hero}R_ID\n"
            f"set t = {hero}T_ID\n"
        )
        return insert_once(body, anchor, block, "LearnHeroSpells")
    return edit_function(text, "LearnHeroSpells", editor)


def add_recommended_items(text: str, hero: str, items: list[str], item_names: dict[str, str]) -> str:
    part = marker(hero, "RecommenedItems")
    if part in text:
        return text
    def editor(body: str) -> str:
        anchor = "set ItemsFrameCurrentPage_ID[i] = 0"
        lines = "\n".join(
            f"    set ItemsPage0_ID[i2+{index}] = '{rawcode}' // {item_names[rawcode]}"
            for index, rawcode in enumerate(items)
        )
        block = (
            f"// {part}\n"
            f"if id == {hero}_ID then\n"
            f"{lines}\n"
            "endif\n"
        )
        return insert_once(body, anchor, block, "RecommenedItems")
    return edit_function(text, "RecommenedItems", editor)


def add_death_sound(text: str, hero: str) -> str:
    part = marker(hero, "Death")
    if part in text:
        return text
    def editor(body: str) -> str:
        anchor = '    else\n    call MakeSound("war3mapimported\\\\Hero_Gojo_RW3")'
        block = (
            f"    // {part}\n"
            f"    elseif td_id == {hero}_ID then\n"
            f"    call MakeSound(\"war3mapimported\\\\Hero_{hero}_Death\")\n"
        )
        return insert_once(body, anchor, block, "Death")
    return edit_function(text, "Trig_Death_Actions", editor)


def add_level_up(text: str, hero: str, has_f: bool, has_g: bool) -> str:
    part = marker(hero, "LvlUpCheck")
    if part in text or not (has_f or has_g):
        return text
    check = f"{hero}G_ID" if has_g else f"{hero}F_ID"
    additions: list[str] = []
    for letter in (("F",) if has_f else ()) + (("G",) if has_g else ()):
        additions.extend([
            f"    call UnitAddAbility(c,{hero}{letter}_ID)",
            f"    call UnitMakeAbilityPermanent(c,true,{hero}{letter}_ID)",
        ])
    def editor(body: str) -> str:
        anchor = "    set c = null"
        block = (
            f"    // {part}\n"
            f"    if {hero}_ID == id and GetUnitAbilityLevel(c,{check}) == 0 then\n"
            + "\n".join(additions)
            + "\n    endif\n"
        )
        return insert_once(body, anchor, block, "LvlUpCheck")
    return edit_function(text, "Trig_LvlUpCheck_Actions", editor)


def load_main_map(workspace: Path) -> Path | None:
    object_config = workspace / "object-data.config.json"
    if not object_config.is_file():
        return None
    config = json.loads(object_config.read_text(encoding="utf-8-sig"))
    build_config_value = config.get("build_config")
    map_key = config.get("map_key", "mainMap")
    if not isinstance(build_config_value, str):
        return None
    build_path = (workspace / build_config_value).resolve()
    if not build_path.is_file():
        return None
    build = json.loads(build_path.read_text(encoding="utf-8-sig"))
    value = build.get(map_key)
    return Path(value).resolve() if isinstance(value, str) and value else None


def has_imported_sound(map_dir: Path | None, stem: str) -> bool:
    if map_dir is None or not map_dir.is_dir():
        return False
    target = stem.casefold()
    for path in map_dir.rglob("*"):
        if path.is_file() and (path.stem.casefold() == target or path.name.casefold() == target):
            return True
    return False


def update_trigger_setting(workspace: Path, hero_file: Path, enabled: bool) -> TextFile | None:
    trigger_root = (workspace / "triggers").resolve()
    try:
        relative = hero_file.resolve().relative_to(trigger_root).as_posix()
    except ValueError as exc:
        raise TransferError(f"Hero file must be inside {trigger_root}: {hero_file}") from exc
    path = trigger_root / "trigger-settings.json"
    if not path.is_file():
        return None
    file = TextFile.load(path)
    document = json.loads(file.text)
    configured = document.get("triggers")
    if not isinstance(configured, dict):
        raise TransferError(f"Invalid trigger settings: {path}")
    if relative not in configured:
        configured[relative] = enabled
        file.text = json.dumps(document, ensure_ascii=False, indent=2) + "\n"
    elif enabled and configured[relative] is False:
        configured[relative] = True
        file.text = json.dumps(document, ensure_ascii=False, indent=2) + "\n"
    return file


def resolve_hero_file(workspace: Path, supplied: str | None) -> Path:
    value = supplied or ""
    candidate = Path(value) if value else Path()
    if not value or not candidate.is_file() or candidate.suffix.casefold() != ".j":
        print("The currently active VS Code file is not a usable hero .j file.")
        value = input("Enter the hero J file path: ").strip().strip('"')
        candidate = Path(value)
    if not candidate.is_absolute():
        candidate = workspace / candidate
    candidate = candidate.resolve()
    if not candidate.is_file() or candidate.suffix.casefold() != ".j":
        raise TransferError(f"Hero J file not found: {candidate}")
    return candidate


def confirm(question: str, assume_yes: bool) -> bool:
    if assume_yes:
        return True
    return input(question).strip().casefold() in {"y", "yes", "д", "да"}


def write_transaction(files: list[TextFile], workspace: Path, hero: str) -> Path | None:
    changed = [file for file in files if file.encoded() != file.path.read_bytes()]
    if not changed:
        return None
    stamp = datetime.now().strftime("%Y-%m-%d_%H%M%S_%f")
    backup = workspace / "backups" / "hero-transfer" / f"{stamp}_{hero}"
    backup.mkdir(parents=True, exist_ok=False)
    for file in changed:
        relative = file.path.resolve().relative_to(workspace.resolve())
        destination = backup / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(file.path, destination)
    try:
        for file in changed:
            temporary = file.path.with_name(file.path.name + ".hero-transfer.tmp")
            temporary.write_bytes(file.encoded())
            temporary.replace(file.path)
    except Exception:
        for file in changed:
            relative = file.path.resolve().relative_to(workspace.resolve())
            saved = backup / relative
            if saved.is_file():
                shutil.copy2(saved, file.path)
        raise
    return backup


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--hero-file")
    parser.add_argument("--workspace", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--category", type=int)
    parser.add_argument("--difficulty", type=int)
    parser.add_argument("--items", help="default, or six rawcodes separated by spaces/commas")
    parser.add_argument("--yes", action="store_true", help="accept confirmations (for automated tests)")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        workspace = args.workspace.resolve()
        hero_file = resolve_hero_file(workspace, args.hero_file)
        hero, declarations = parse_hero(hero_file)
        has_f = f"{hero}F_ID" in declarations
        has_g = f"{hero}G_ID" in declarations

        print("\nHERO TRANSFER")
        print(f"Selected source: {hero_file}")
        print(f"Detected hero:  {hero} ({hero}_ID = '{declarations[f'{hero}_ID']}')")
        print("Abilities:      " + ", ".join(letter for letter in "QWERTFG" if f"{hero}{letter}_ID" in declarations))
        if not confirm("Use exactly this J file for Hero Transfer? Type Y to continue: ", args.yes):
            print("CANCELLED: no files were changed")
            return 0

        print("\nChoose hero section:")
        for number, (name, _, _) in CATEGORIES.items():
            print(f"  {number} - {name}")
        category = choose_number("Section [1-6]: ", CATEGORIES, args.category)
        category_name, category_index, page = CATEGORIES[category]

        print("\nChoose difficulty:")
        for number, (name, _) in DIFFICULTIES.items():
            print(f"  {number} - {name}")
        difficulty = choose_number("Difficulty [1-3]: ", DIFFICULTIES, args.difficulty)
        difficulty_name, difficulty_text = DIFFICULTIES[difficulty]

        item_names = load_items(workspace)
        items = choose_items(item_names, args.items)

        paths = {
            "builds": workspace / "triggers" / "WOS_Start" / "BuildsForChars.j",
            "picker": workspace / "triggers" / "WOS_Start" / "WoS_Pick_Init.j",
            "systems": workspace / "triggers" / "Systems" / "Systems1.j",
            "death": workspace / "triggers" / "Systems" / "Death.j",
            "level": workspace / "triggers" / "Systems" / "LvlUpCheck.j",
        }
        files = {name: TextFile.load(path) for name, path in paths.items()}
        existing = find_existing_slot(files["builds"].text, hero)
        if existing is not None and existing[0] != category_index:
            raise TransferError(
                f"{hero} is already in Hero_ID{existing[0]}[{existing[1]}], not in the selected {category_name} section"
            )
        slot = existing[1] if existing else next_slot(files["builds"].text, category_index)
        mode = 2 if has_f and has_g else 3 if has_g else 4 if has_f else 0

        main_map = load_main_map(workspace)
        death_sound = has_imported_sound(main_map, f"Hero_{hero}_Death")
        trigger_settings_path = workspace / "triggers" / "trigger-settings.json"
        trigger_setting_missing = False
        if trigger_settings_path.is_file():
            settings = json.loads(trigger_settings_path.read_text(encoding="utf-8-sig"))
            relative = hero_file.relative_to((workspace / "triggers").resolve()).as_posix()
            trigger_setting_missing = relative not in settings.get("triggers", {})

        print("\nTransfer summary:")
        print(f"  Hero:        {hero}")
        print(f"  Section:     {category} - {category_name}")
        print(f"  Array slot:  Hero_ID{category_index}[{slot}]")
        print(f"  Shop:        page {page}, slot {slot}")
        print(f"  F ability:   {'yes' if has_f else 'no'}")
        print(f"  G ability:   {'yes' if has_g else 'no'}")
        print(f"  UI mode b:   {mode}")
        print(f"  Difficulty:  {difficulty_name}")
        print(f"  Death sound: {'found; Death.j will be updated' if death_sound else 'not found; Death.j will not be changed'}")
        print("  Items:")
        for rawcode in items:
            print(f"    {rawcode}  {item_names[rawcode]}")

        add_trigger = True
        if trigger_setting_missing:
            add_trigger = confirm(
                f"\n{hero_file.name} is not in trigger-settings.json. Add it enabled so task 3 creates it under Heroes? [Y/N]: ",
                args.yes,
            )

        if not confirm("\nApply this Hero Transfer? Type Y to write the files: ", args.yes):
            print("CANCELLED: no files were changed")
            return 0

        files["builds"].text = add_build_entry(
            files["builds"].text, hero, category_index, slot, has_f, has_g
        )
        picker = files["picker"].text
        picker = add_random_pick(picker, hero, category_index, slot)
        picker = add_picker_details(picker, hero, page, mode, difficulty_text)
        picker = add_picker_sounds(picker, hero, category_index, slot)
        picker = add_confirm_pick(picker, hero, category_index, slot)
        picker = add_guide_tooltips(picker, hero, category_index, slot, has_f, has_g)
        files["picker"].text = picker

        systems = files["systems"].text
        systems = add_shop_registry(systems, hero, page, slot)
        systems = add_learn_spells(systems, hero)
        systems = add_recommended_items(systems, hero, items, item_names)
        files["systems"].text = systems

        if death_sound:
            files["death"].text = add_death_sound(files["death"].text, hero)
        files["level"].text = add_level_up(files["level"].text, hero, has_f, has_g)

        write_files = list(files.values())
        if add_trigger:
            settings_file = update_trigger_setting(workspace, hero_file, True)
            if settings_file is not None:
                write_files.append(settings_file)

        if args.dry_run:
            changed = [file.path for file in write_files if file.encoded() != file.path.read_bytes()]
            print("\nDRY RUN OK: no files were written")
            for path in changed:
                print(f"  WOULD UPDATE {path}")
            return 0

        backup = write_transaction(write_files, workspace, hero)
        if backup is None:
            print("\nHERO TRANSFER ALREADY APPLIED: no duplicate code was added")
        else:
            print("\nHERO TRANSFER OK")
            print(f"Backup: {backup}")
            print("Next: run 'WOS Objects: 3. Save JSON and J into map folder' with World Editor closed.")
            print("That task will create/update the WTG trigger under Heroes and write the J source into WCT.")
        return 0
    except (TransferError, OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"\nHERO TRANSFER FAILED: {exc}", file=sys.stderr)
        print("No partial Hero Transfer changes were intentionally kept.", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())

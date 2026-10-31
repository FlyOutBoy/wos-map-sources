"""Build 64x64 item icons (BTN + DISBTN) with Button Manager borders and install them.

Sources live in assets/item_icons_src/ (anime frames, see SOURCES). Borders are the
Button Manager originals (D:/WoS Requirment/Button Manager Clear/standard): grey border
pixels shade the picture by their intensity, coloured pixels are drawn as they are -
the same rule Button Manager uses. DISBTN = greyscale picture shaded by bm_disbtn.

    python tools/build_item_icons.py            # build into assets/ReplaceableTextures
    python tools/build_item_icons.py --install  # also copy into the MAIN map + war3map.imp
"""
from pathlib import Path
import argparse
import json
import shutil
import struct
from datetime import datetime

from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'assets/item_icons_src'
OUT = ROOT / 'assets'
BORDERS = Path(r'D:\WoS Requirment\Button Manager Clear\standard')
BTN_DIR = 'ReplaceableTextures/CommandButtons'
DIS_DIR = 'ReplaceableTextures/CommandButtonsDisabled'

# icon name -> (source file, crop box as fractions l, t, r, b, tint)
FULL = (0.00, 0.00, 1.00, 1.00)
ICONS = {
    'Kusanagi': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), None),
    'KusanagiFire': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), 'fire'),
    'KusanagiWater': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), 'water'),
    'KusanagiElectro': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), 'electro'),
    'HashiramaCells': ('hashirama_cells.png', (0.25, 0.12, 0.75, 0.95), None),
    'ShunShunRikka': ('shun_shun_rikka.png', (0.36, 0.26, 0.84, 0.90), None),
    'AshisogiJizo': ('ashisogi_jizo.png', (0.10, 0.00, 0.90, 0.90), None),
    'CoreDrill': ('core_drill.png', (0.00, 0.00, 1.00, 1.00), None),
    'CoreDrillPhys': ('core_drill_phys.png', (0.00, 0.00, 1.00, 1.00), None),  # physical stack buff (red)
    'CoreDrillMag': ('core_drill_mag.png', (0.00, 0.00, 1.00, 1.00), None),    # magic stack buff (blue)
    # 2026-10-27 items: fandom wiki frames (SOURCES); Evolved copies via GOLD
    'ArmamentHaki': ('armament_haki_art.png', (0.28, 0.0, 0.72, 0.78), None),
    'ArmamentHakiEvolved': ('armament_haki_art.png', (0.28, 0.0, 0.72, 0.78), None),
    'NaofumiShieldEvolved': ('naofumi_shield_btn.png', FULL, None),
    'SukunaFinger': ('sukuna_finger_art.png', (0.5, 0.0, 1.0, 0.9), None),
    'FiveElementsSeal': ('five_elements_seal_art.png', (0.15, 0.1, 0.8, 0.98), None),
    'Tekkai': ('tekkai_art.png', (0.55, 0.2, 0.85, 0.65), None),
    'Samehada': ('samehada_art.png', (0.55, 0.25, 0.95, 0.95), None),
    'WillOfD': ('will_of_d_art.png', (0.33, 0.45, 0.98, 0.85), None),
    'Kairoseki': ('kairoseki_art.png', (0.0, 0.2, 0.45, 0.85), None),
    'IceCoffin': ('ice_coffin_art.png', (0.2, 0.0, 0.8, 1.0), None),
    'ReturnByDeath': ('return_by_death_art.png', (0.0, 0.0, 0.6, 1.0), None),
    'FairyTailEvolved': ('fairy_tail_btn.png', FULL, None),
    # 2026-10-28 universal zanpakuto: bleach.fandom.com frames (SOURCES).
    'ZankaNoTachi': ('zanka_no_tachi_art.png', (0.50, 0.08, 0.86, 0.64), None),
    'KyokaSuigetsu': ('kyoka_suigetsu_art.png', (0.30, 0.02, 0.72, 0.58), None),
    'KokoGonryoRikyu': ('koko_gonryo_rikyu_art.png', (0.22, 0.00, 0.72, 0.78), None),
    'Tobiume': ('tobiume_art.png', (0.05, 0.05, 0.85, 0.95), None),
    'Suzumebachi': ('suzumebachi_art.png', (0.08, 0.02, 0.58, 0.80), None),
    # 2026-10-28 elemental actives: user's 64x64 art (Desktop/64x64), Button Manager frame.
    'BloodPactRing': ('blood_pact_ring_art.png', FULL, None),
    'BloodPactRingEvolved': ('blood_pact_ring_art.png', FULL, None),
    'Emberbreaker': ('elem_str_fire_target_emberbreaker.png', FULL, None),
    'LeviathanGrasp': ('elem_str_water_target_leviathans_grasp.png', FULL, None),
    'LeviathanAnchor': ('elem_str_water_aoe_leviathans_anchor.png', FULL, None),
    'ThunderVerdict': ('elem_str_lightning_target_thunder_verdict.png', FULL, None),
    'ThunderBastion': ('elem_str_lightning_aoe_thunder_bastion.png', FULL, None),
    'CinderFang': ('elem_agi_fire_target_cinder_fang.png', FULL, None),
    'AshenCrossfire': ('elem_agi_fire_aoe_ashen_crossfire.png', FULL, None),
    'Shark': ('elem_agi_water_target_shark_trail.png', FULL, None),
    'MirrorTide': ('elem_agi_water_aoe_mirror_tide.png', FULL, None),
    'VoltThread': ('elem_agi_lightning_target_volt_thread.png', FULL, None),
    'RaijinWrath': ('elem_agi_lightning_aoe_raijins_wrath.png', FULL, None),
    'PhoenixSeal': ('elem_int_fire_target_phoenix_seal.png', FULL, None),
    'CrimsonScripture': ('elem_int_fire_aoe_crimson_scripture.png', FULL, None),
    'SirenTear': ('elem_int_water_target_sirens_tear.png', FULL, None),
    'RedCup': ('elem_int_water_aoe_red_cup.png', FULL, None),
    'RedFlower': ('elem_int_lightning_target_red_flower.png', FULL, None),
    'ConstellationCoil': ('elem_int_lightning_aoe_constellation_coil.png', FULL, None),
    'RyujinJakkaEvolved': ('ryujin_jakka_btn.png', FULL, None),
    'NejibanaEvolved': ('nejibana_btn.png', FULL, None),
    'GonryomaruEvolved': ('gonryomaru_btn.png', FULL, None),
    'MirrorYataEvolved': ('mirror_yata_btn.png', FULL, None),
    'PhilosopherStoneEvolved': ('philosopher_stone_btn.png', FULL, None),
}
# Evolved tier: the gold frame of the existing Evolved icons over the Button Manager border.
GOLD = {'BloodPactRingEvolved', 'ArmamentHakiEvolved', 'NaofumiShieldEvolved', 'FairyTailEvolved', 'RyujinJakkaEvolved', 'NejibanaEvolved', 'GonryomaruEvolved', 'MirrorYataEvolved', 'PhilosopherStoneEvolved'}
SOURCES = {  # where the frames come from (fandom wikis)
    'kusanagi_sword.png': 'naruto.fandom.com File:Kusanagi_no_Tsurugi.PNG',
    'hashirama_cells.png': "naruto.fandom.com File:Hashirama's_Cells.png",
    'shun_shun_rikka.png': 'bleach.fandom.com File:Ep13OrihimesClip.png',
    'ashisogi_jizo.png': 'bleach.fandom.com File:Ashisogi_Jizo_(spirit)_Full_body_1.png',
    'blood_pact_ring_art.png': 'Generated with built-in ImageGen 2026-10-28; crimson bloodstone ring, Warcraft III item art',
    'core_drill.png': 'drawn procedurally (Gurren Lagann Core Drill), no external image',
    'core_drill_phys.png': 'drawn procedurally, red background (physical buff)',
    'core_drill_mag.png': 'drawn procedurally, blue background (magic buff)',
    'gold_frame.png': 'cut from BTNItem_LustSin2 vs BTNItem_LustSin (Evolved gold frame)',
    'naofumi_shield_btn.png': 'existing BTNItem_NaofumiShield (Evolved copy)',
    'fairy_tail_btn.png': 'existing BTNItem_FairyTail (Evolved copy)',
    'ryujin_jakka_btn.png': 'existing BTNItem_RyujinJakka (Evolved copy)',
    'nejibana_btn.png': 'existing BTNItem_Nejibana (Evolved copy)',
    'gonryomaru_btn.png': 'existing BTNItem_Gonryomaru (Evolved copy)',
    'mirror_yata_btn.png': 'existing BTNItem_MirrorYata (Evolved copy)',
    'philosopher_stone_btn.png': 'existing BTNItem_PhilosopherStone (Evolved copy)',
}
SOURCES['elem_str_fire_target_emberbreaker.png'] = 'user art 2026-10-28: STR_Fire_Target_Emberbreaker.png'
SOURCES['elem_str_fire_aoe_rhitta.png'] = 'user art 2026-10-28: STR_Fire_AOE_Rhitta.png'
SOURCES['elem_str_water_target_leviathans_grasp.png'] = 'user art 2026-10-28: STR_Water_Target_Leviathans_Grasp.png'
SOURCES['elem_str_water_aoe_leviathans_anchor.png'] = 'user art 2026-10-28: STR_Water_AOE_Leviathans_Anchor.png'
SOURCES['elem_str_lightning_target_thunder_verdict.png'] = 'user art 2026-10-28: STR_Lightning_Target_Thunder_Verdict.png'
SOURCES['elem_str_lightning_aoe_thunder_bastion.png'] = 'user art 2026-10-28: STR_Lightning_AOE_Thunder_Bastion.png'
SOURCES['elem_agi_fire_target_cinder_fang.png'] = 'user art 2026-10-28: AGI_Fire_Target_Cinder_Fang.png'
SOURCES['elem_agi_fire_aoe_ashen_crossfire.png'] = 'user art 2026-10-28: AGI_Fire_AOE_Ashen_Crossfire.png'
SOURCES['elem_agi_water_target_shark_trail.png'] = 'user art 2026-10-28: AGI_Water_Target_Shark_Trail.png'
SOURCES['elem_agi_water_aoe_mirror_tide.png'] = 'user art 2026-10-28: AGI_Water_AOE_Mirror_Tide.png'
SOURCES['elem_agi_lightning_target_volt_thread.png'] = 'user art 2026-10-28: AGI_Lightning_Target_Volt_Thread.png'
SOURCES['elem_agi_lightning_aoe_raijins_wrath.png'] = 'user art 2026-10-28: AGI_Lightning_AOE_Raijins_Wrath.png'
SOURCES['elem_int_fire_target_phoenix_seal.png'] = 'user art 2026-10-28: INT_Fire_Target_Phoenix_Seal.png'
SOURCES['elem_int_fire_aoe_crimson_scripture.png'] = 'user art 2026-10-28: INT_Fire_AOE_Crimson_Scripture.png'
SOURCES['elem_int_water_target_sirens_tear.png'] = 'user art 2026-10-28: INT_Water_Target_Sirens_Tear.png'
SOURCES['elem_int_water_aoe_red_cup.png'] = 'user art 2026-10-28: INT_Water_AOE_Red_Cup.png'
SOURCES['elem_int_lightning_target_red_flower.png'] = 'user art 2026-10-28: INT_Lightning_Target_Red_Flower.png'
SOURCES['elem_int_lightning_aoe_constellation_coil.png'] = 'user art 2026-10-28: INT_Lightning_AOE_Constellation_Coil.png'
SOURCES['zanka_no_tachi_art.png'] = 'bleach.fandom.com File:Ep372YamamotoBankaiZankaNoTachi.png'
SOURCES['kyoka_suigetsu_art.png'] = 'bleach.fandom.com File:Ep60KyokaSuigetsu.png (Kyoka with macron)'
SOURCES['koko_gonryo_rikyu_art.png'] = 'bleach.fandom.com File:Ep371ChojiroBankaiKokoGonryoRikyu.png'
SOURCES['tobiume_art.png'] = "bleach.fandom.com File:101Hinamori's Shikai, Tobiume.png"
SOURCES['suzumebachi_art.png'] = 'bleach.fandom.com File:E245suzsoi.png'
SOURCES['armament_haki_art.png'] = "onepiece.fandom.com File:Armament_Hardening.png"
SOURCES['sukuna_finger_art.png'] = "jujutsu-kaisen.fandom.com File:Sukuna's_fingers_(Anime).png"
SOURCES['five_elements_seal_art.png'] = "naruto.fandom.com File:Five_Elements_Seal.png"
SOURCES['tekkai_art.png'] = "onepiece.fandom.com File:Tekkai_Infobox.png"
SOURCES['samehada_art.png'] = "naruto.fandom.com File:Samehada_unwrapped.png"
SOURCES['will_of_d_art.png'] = "onepiece.fandom.com File:Will_of_D._Infobox.png"
SOURCES['kairoseki_art.png'] = "onepiece.fandom.com File:Seastone_Infobox.png"
SOURCES['ice_coffin_art.png'] = "bleach.fandom.com File:239Hyorinmaru_stands.png"
SOURCES['return_by_death_art.png'] = "rezero.fandom.com File:Subaru_-_Return_by_Death.gif (frame 53)"
TINTS = {
    'fire': ('#1a0200', '#ff4a00', '#ffe27a'),
    'water': ('#000a1c', '#1e78ff', '#d2f4ff'),
    'electro': ('#06001c', '#8a63ff', '#f2f7ff'),
}


def picture(name):
    source, (l, t, r, b), tint = ICONS[name]
    image = Image.open(SRC / source).convert('RGB')
    w, h = image.size
    image = image.crop((round(l * w), round(t * h), round(r * w), round(b * h)))
    side = min(image.size)
    image = ImageOps.fit(image, (side, side), Image.Resampling.LANCZOS)
    image = image.resize((64, 64), Image.Resampling.LANCZOS)
    if tint:
        black, mid, white = TINTS[tint]
        coloured = ImageOps.colorize(ImageOps.autocontrast(image.convert('L')), black, white, mid)
        image = Image.blend(image, coloured, 0.78)
    return image


def apply_border(image, border_name, grey=False):
    border = Image.open(BORDERS / border_name).convert('RGB')
    base = image.convert('L').convert('RGB') if grey else image
    out = Image.new('RGB', (64, 64))
    src, bd, dst = base.load(), border.load(), out.load()
    for y in range(64):
        for x in range(64):
            r, g, b = bd[x, y]
            if r == g == b:
                p = src[x, y]
                dst[x, y] = tuple(c * r // 255 for c in p)
            else:
                dst[x, y] = (r, g, b)
    return out


def write_blp1(image, destination):
    """Paletted BLP1 (256 colours, no alpha) with a full mipmap chain."""
    image = image.convert('RGB')
    quantized = image.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.FLOYDSTEINBERG)
    palette = (quantized.getpalette() + [0] * 768)[:768]
    palette_bytes = b''.join(bytes((palette[i + 2], palette[i + 1], palette[i], 0)) for i in range(0, 768, 3))
    levels, level = [], image
    while True:
        levels.append(level.quantize(palette=quantized, dither=Image.Dither.NONE).tobytes())
        if level.size == (1, 1) or len(levels) == 16:
            break
        level = level.resize((max(1, level.width // 2), max(1, level.height // 2)), Image.Resampling.LANCZOS)
    offsets, at = [], 156 + 1024
    for data in levels:
        offsets.append(at)
        at += len(data)
    header = struct.pack('<4s6I', b'BLP1', 1, 0, image.width, image.height, 5, 1)
    header += struct.pack('<16I', *(offsets + [0] * (16 - len(offsets))))
    header += struct.pack('<16I', *([len(x) for x in levels] + [0] * (16 - len(levels))))
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(header + palette_bytes + b''.join(levels))


def build():
    built = []
    preview = Image.new('RGB', (64 * len(ICONS), 128), 'black')
    for i, name in enumerate(ICONS):
        image = picture(name)
        btn = apply_border(image, 'bm_btn.tga')
        dis = apply_border(image, 'bm_disbtn.tga', grey=True)
        if name in ('BloodPactRing', 'BloodPactRingEvolved'):
            btn = Image.open(SRC / 'blood_pact_ring_btn.png').convert('RGB')
            dis = Image.open(SRC / 'blood_pact_ring_disbtn.png').convert('RGB')
        if name in GOLD:
            frame = Image.open(SRC / 'gold_frame.png').convert('RGBA')
            btn = btn.convert('RGBA')
            btn.alpha_composite(frame)
            btn = btn.convert('RGB')
            dis = dis.convert('RGBA')
            dis.alpha_composite(ImageOps.grayscale(frame.convert('RGB')).convert('RGBA'), (0, 0))
            dis = Image.composite(dis, apply_border(image, 'bm_disbtn.tga', grey=True).convert('RGBA'), frame.split()[3]).convert('RGB')
        for folder, prefix, art in ((BTN_DIR, 'BTN', btn), (DIS_DIR, 'DISBTN', dis)):
            path = f'{folder}/{prefix}Item_{name}.blp'
            write_blp1(art, OUT / path)
            built.append(path)
        preview.paste(btn, (64 * i, 0))
        preview.paste(dis, (64 * i, 64))
    preview.save(OUT / 'item_icons_src/preview.png')
    return built


def install(map_dir, paths):
    imp = map_dir / 'war3map.imp'
    original = imp.read_bytes()
    version, count = struct.unpack_from('<II', original)
    offset, registered = 8, set()
    for _ in range(count):
        end = original.index(0, offset + 1)
        name = original[offset + 1:end].decode('utf-8')
        if original[offset] in (5, 8):
            name = 'war3mapImported\\' + name
        registered.add(name.replace('\\', '/').casefold())
        offset = end + 1
    if version not in (1, 2) or offset != len(original):
        raise ValueError('Invalid war3map.imp; icon installation stopped')
    backup = ROOT / 'backups/item-icons' / datetime.now().strftime('%Y%m%d-%H%M%S')
    backup.mkdir(parents=True)
    shutil.copy2(imp, backup / imp.name)
    additions = [p for p in paths if p.casefold() not in registered]
    for path in paths:
        destination = map_dir / path
        if destination.exists():
            saved = backup / path
            saved.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(destination, saved)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(OUT / path, destination)
    if additions:
        imp.write_bytes(struct.pack('<II', version, count + len(additions)) + original[8:] +
                        b''.join(b'\x0d' + p.replace('/', '\\').encode('utf-8') + b'\0' for p in additions))
    print(f'Installed {len(paths)} icons ({len(additions)} new imports); backup: {backup}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--install', action='store_true')
    args = parser.parse_args()
    paths = build()
    print('\n'.join(paths))
    if args.install:
        config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8'))
        install(Path(config['mainMap']), paths)

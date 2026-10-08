"""Register shared UI resources without changing existing imports."""
from pathlib import Path
import argparse
from install_team_ping_assets import install

ROOT = Path(__file__).resolve().parents[1]
ASSET_NAMES = {'panel','border','button','hover','pressed','selected','disabled','hp','mp','bar-back','checked','unchecked'}

def install_ui(map_dir):
    install(map_dir,ROOT/'assets/UI/WOS',ROOT/'backups/ui-redesign/assets',ASSET_NAMES,'UI/WOS')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map',required=True,type=Path)
    args = parser.parse_args()
    install_ui(args.map.resolve())

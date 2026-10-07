import contextlib
import io
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import test_map_profile as profiles


class TestHeroProfiles(unittest.TestCase):
    def fixture(self, root, hero="Crocodile"):
        template = root/"template.w3x"
        template.write_bytes(b"original map")
        config = root/".vscode/wos-build.json"
        profiles.write(config,{"testHero":hero,"testMapsDir":"maps/Heroes",
                               "testMapTemplate":str(template),"buildDir":"_build",
                               "testHeroSourceDirs":["triggers/Heroes","test_map/heroes"]})
        return config

    def select(self, root, config, hero):
        value = profiles.read(config)
        value["testHero"] = hero
        profiles.write(config,value)
        return profiles.ensure(root)

    def test_create_switch_back_and_preserve_existing_map_code_and_json(self):
        with tempfile.TemporaryDirectory() as temp, patch.object(profiles,"initialize") as initialize, contextlib.redirect_stderr(io.StringIO()):
            root = Path(temp)
            config = self.fixture(root)
            crocodile = profiles.ensure(root)
            Path(crocodile["testMap"]).write_bytes(b"latest original")
            (root/"_build/Crocodile_Test.w3x").write_bytes(b"older compiled copy")
            beluga = self.select(root,config,"Beluga")
            self.assertEqual(b"latest original",Path(beluga["testMap"]).read_bytes())
            self.assertEqual(b"",Path(beluga["heroSource"]).read_bytes())
            source = Path(beluga["heroSource"])
            source.write_text("// my Beluga implementation")
            Path(beluga["testMap"]).write_bytes(b"my existing Beluga map")
            objects = Path(beluga["json_directory"])/"units.json"
            objects.parent.mkdir(parents=True)
            objects.write_text("my edited object data")
            self.select(root,config,"Crocodile")
            selected = self.select(root,config,"Beluga")
            self.assertEqual(beluga["json_directory"],selected["json_directory"])
            self.assertEqual("my edited object data",objects.read_text())
            self.assertEqual("// my Beluga implementation",source.read_text())
            self.assertEqual(b"my existing Beluga map",Path(selected["testMap"]).read_bytes())
            self.assertEqual(2,initialize.call_count)
            # Clearing generated build files must not discard editable profile state.
            for cache in (root/"_build").glob("*.json"):
                cache.unlink()
            self.select(root,config,"Crocodile")
            self.select(root,config,"Beluga")
            self.assertEqual("my edited object data",objects.read_text())
            self.assertEqual(2,initialize.call_count)

    def test_existing_named_map_wins_over_template_and_existing_main_source_wins(self):
        with tempfile.TemporaryDirectory() as temp, patch.object(profiles,"initialize"), contextlib.redirect_stderr(io.StringIO()):
            root = Path(temp)
            self.fixture(root,"Beluga")
            target = root/"maps/Heroes/Beluga.w3x"
            target.parent.mkdir(parents=True)
            target.write_bytes(b"existing map")
            main = root/"triggers/Heroes/Beluga.j"
            main.parent.mkdir(parents=True)
            main.write_text("library BelugaSpells\nfunction Beluga_Register takes unit u returns nothing\nendfunction\nendlibrary\n")
            result = profiles.ensure(root)
            self.assertEqual(str(main),result["heroSource"])
            self.assertEqual(b"existing map",target.read_bytes())
            self.assertFalse((root/"test_map/heroes/Beluga.j").exists())
            hook = Path(result["testOnlySources"][-1]).read_text()
            self.assertIn("Beluga_Register.evaluate(u)",hook)

    def test_initial_crocodile_adopts_local_json_without_reexporting(self):
        with tempfile.TemporaryDirectory() as temp, patch.object(profiles,"initialize") as initialize:
            root = Path(temp)
            config = self.fixture(root)
            value = profiles.read(config)
            previous = root/"maps/Heroes/Crocodile.w3x"
            previous.parent.mkdir(parents=True)
            previous.write_bytes(b"existing")
            value["testMapTemplate"] = str(previous)
            profiles.write(config,value)
            unpacked = root/"test_map/unpacked"
            unpacked.mkdir(parents=True)
            (unpacked/"war3map.wct").write_bytes(b"editable")
            result = profiles.ensure(root)
            self.assertEqual(str(root/"test_map/object-data"),result["json_directory"])
            initialize.assert_not_called()

    def test_invalid_names_and_missing_template_do_not_create_placeholder_code(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            config = self.fixture(root)
            for hero in ["../Beluga","Beluga.w3x","CON",""]:
                with self.subTest(hero=hero), self.assertRaises(ValueError):
                    self.select(root,config,hero)
            value = profiles.read(config)
            value.update(testHero="Beluga",testMapTemplate="missing.w3x")
            profiles.write(config,value)
            with self.assertRaises(ValueError):
                profiles.ensure(root)
            self.assertFalse((root/"test_map/heroes/Beluga.j").exists())

    def test_imported_test_hero_wins_over_main_and_legacy_import_and_survives_reselection(self):
        with tempfile.TemporaryDirectory() as temp, patch.object(profiles,'initialize'), contextlib.redirect_stderr(io.StringIO()):
            root = Path(temp)
            config = self.fixture(root)
            initial = profiles.ensure(root)
            main = root/'triggers/Heroes/Crocodile.j'
            main.parent.mkdir(parents=True)
            main.write_text('// MAIN implementation')
            legacy = root/'test_map/profiles/Crocodile/imported-hero/Crocodile.j'
            legacy.parent.mkdir(parents=True)
            legacy.write_text('// older hidden import')
            hero = root/'test_map/heroes/Crocodile.j'
            hero.write_text('library CrocodileSpells\nfunction Crocodile_Register takes unit u returns nothing\nendfunction\nendlibrary\n')
            manifest = Path(initial['base'])/'test-source-manifest.json'
            profiles.write(manifest,{'sources':[{'path':'Thunder_Gear/Heroes/Crocodile.j','origin':{'kind':'testHero','path':'Crocodile.j'}}]})
            selected = profiles.ensure(root)
            self.assertEqual(str(hero),selected['heroSource'])
            self.assertEqual(str(hero.parent),selected['testHeroSourceDirs'][0])
            self.assertIn('Crocodile_Register.evaluate(u)',Path(selected['testOnlySources'][-1]).read_text())
            self.assertEqual('// MAIN implementation',main.read_text())
            self.assertEqual('// older hidden import',legacy.read_text())
            for cache in (root/'_build').glob('*.json'):
                cache.unlink()
            selected = profiles.ensure(root)
            self.assertEqual(str(hero),selected['heroSource'])

    def test_legacy_import_remains_active_until_explicit_map_import(self):
        with tempfile.TemporaryDirectory() as temp, patch.object(profiles,'initialize'), contextlib.redirect_stderr(io.StringIO()):
            root = Path(temp)
            self.fixture(root)
            main = root/'triggers/Heroes/Crocodile.j'
            main.parent.mkdir(parents=True)
            main.write_text('// MAIN implementation')
            profiles.ensure(root)
            hero = root/'test_map/heroes/Crocodile.j'
            hero.parent.mkdir(parents=True)
            hero.write_text('// old visible snapshot')
            legacy = root/'test_map/profiles/Crocodile/imported-hero/Crocodile.j'
            legacy.parent.mkdir(parents=True)
            legacy.write_text('// latest active legacy code')
            selected = profiles.ensure(root)
            self.assertEqual(str(legacy),selected['heroSource'])
            self.assertEqual('// old visible snapshot',hero.read_text())


if __name__ == "__main__":
    unittest.main()

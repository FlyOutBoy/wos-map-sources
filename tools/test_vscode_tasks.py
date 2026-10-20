"""Read-only audit of VS Code task targets, arguments and PowerShell syntax."""
from pathlib import Path
import json
import os
import re
import shutil
import subprocess
import sys
import hashlib
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class VscodeTasks(unittest.TestCase):
    def setUp(self):
        self.tasks = json.loads((ROOT/'.vscode/tasks.json').read_text('utf-8-sig'))['tasks']

    def resolve(self, value):
        value = value.replace('${workspaceFolder}', str(ROOT))
        return re.sub(r'\$\{env:(\w+)\}', lambda m: os.environ[m[1]], value)

    def test_commands_paths_labels_and_working_directory(self):
        labels = [task['label'] for task in self.tasks]
        self.assertEqual(len(labels), len(set(labels)))
        for task in self.tasks:
            with self.subTest(task=task['label']):
                self.assertEqual('${workspaceFolder}', task['options']['cwd'])
                command = self.resolve(task['command'])
                self.assertTrue(Path(command).is_file() or shutil.which(command), command)
                for arg in task.get('args', []):
                    if arg.startswith('${workspaceFolder}'):
                        self.assertTrue(Path(self.resolve(arg)).exists(), arg)

    def test_python_task_entrypoints_accept_help(self):
        scripts = {self.resolve(task['args'][0]) for task in self.tasks if task['command']=='python'}
        for script in scripts:
            with self.subTest(script=script):
                result = subprocess.run([sys.executable, script, '--help'], cwd=ROOT,
                                        capture_output=True, timeout=15)
                self.assertEqual(0, result.returncode, result.stderr.decode(errors='replace'))

    def test_main_and_test_routes_and_checked_save(self):
        primary = [task for task in self.tasks if not task['label'].startswith('COMMON |')]
        self.assertEqual(6, len(primary))
        for target in ('Test', 'Main'):
            selected = [t for t in primary if t['label'].startswith(target.upper()+':')]
            self.assertEqual(3, len(selected))
            for task, command in zip(selected, ('receive', 'build', 'build')):
                args = task['args']
                self.assertTrue(args[0].endswith('wos_map_workflow.py'))
                self.assertEqual(command, args[1])
                self.assertEqual(target, args[args.index('--target')+1])
            self.assertNotIn('--no-launch', selected[1]['args'])
            self.assertIn('--no-launch', selected[2]['args'])
        default = [t for t in self.tasks if isinstance(t.get('group'), dict) and t['group'].get('isDefault')]
        self.assertEqual(1, len(default))
        self.assertTrue(default[0]['label'].startswith('TEST: 3.'))
        signatures = [(t['command'], tuple(t['args'])) for t in self.tasks]
        self.assertEqual(len(signatures), len(set(signatures)), 'Duplicate task commands')

    @unittest.skipUnless(os.name=='nt', 'Windows PowerShell AST audit')
    def test_powershell_syntax_and_task_parameter_names(self):
        # Parse scripts with the installed Windows PowerShell used by VS Code.
        # Parsing does not execute imports, saves, clipboard operations or launches.
        command = r'''
$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$items = @(Get-ChildItem -LiteralPath (Join-Path $root '.vscode') -Filter '*.ps1' -File | ForEach-Object {
    $tokens=$null; $errors=$null
    $ast=[System.Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$tokens,[ref]$errors)
    @{ path=$_.FullName; parameters=@($ast.ParamBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath }); errors=@($errors | ForEach-Object { $_.Message }) }
})
ConvertTo-Json -InputObject $items -Depth 5 -Compress
'''
        powershell = Path(os.environ['WINDIR'])/'System32/WindowsPowerShell/v1.0/powershell.exe'
        result = subprocess.run([str(powershell), '-NoProfile', '-Command', command], cwd=ROOT,
                                capture_output=True, timeout=20, encoding='utf-8', errors='replace')
        self.assertEqual(0, result.returncode, result.stderr)
        parsed = {Path(item['path']).resolve(): item for item in json.loads(result.stdout)}
        for path, item in parsed.items():
            self.assertEqual([], item['errors'], str(path))
        for task in self.tasks:
            args=task['args']
            if '-File' not in args:
                continue
            with self.subTest(task=task['label']):
                start=args.index('-File')+1
                item=parsed[Path(self.resolve(args[start])).resolve()]
                names={name.casefold() for name in item['parameters']}
                for arg in args[start+1:]:
                    if arg.startswith('-'):
                        self.assertIn(arg.lstrip('-').casefold(),names,arg)

    @unittest.skipUnless(os.name=='nt', 'Windows source resolver')
    def test_main_compile_resolves_live_sources_without_test_or_recovery_snapshots(self):
        powershell=Path(os.environ['WINDIR'])/'System32/WindowsPowerShell/v1.0/powershell.exe'
        result=subprocess.run([str(powershell),'-NoProfile','-ExecutionPolicy','Bypass','-File',
            str(ROOT/'.vscode/compile-vjass.ps1'),'-SourceRoot',str(ROOT/'triggers'),'-ResolveOnly'],
            cwd=ROOT,capture_output=True,timeout=20)
        self.assertEqual(0,result.returncode,result.stderr.decode(errors='replace'))
        source=(ROOT/'.vscode/build/wos_compile_input.j').read_text('utf-8-sig')
        imported=re.findall(r'^//! import "([^"]+)"',source,re.M)
        self.assertGreater(len(imported),100)
        for name in imported:
            path=Path(name).resolve()
            self.assertTrue(path.is_relative_to(ROOT/'triggers') or path.is_relative_to(ROOT/'.vscode/build'),name)

    @unittest.skipUnless(os.name=='nt', 'Windows packed script hash')
    def test_packed_script_hash_works_without_powershell_modules(self):
        command = r'''
$ErrorActionPreference = 'Stop'
$tokens=$null; $errors=$null
$ast=[System.Management.Automation.Language.Parser]::ParseFile(
    (Join-Path (Get-Location) '.vscode/build-run-w3-map.ps1'), [ref]$tokens, [ref]$errors)
$definition=$ast.Find({param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Get-MapScriptHash'}, $true)
. ([scriptblock]::Create($definition.Extent.Text))
$env:PSModulePath=''
Get-MapScriptHash -Path $env:WOS_HASH_FIXTURE
'''
        with tempfile.TemporaryDirectory() as directory:
            fixture = Path(directory)/'war3map.j'
            powershell=Path(os.environ['WINDIR'])/'System32/WindowsPowerShell/v1.0/powershell.exe'
            hashes = []
            for payload in (b'function main takes nothing returns nothing\r\nendfunction', b'changed script'):
                fixture.write_bytes(payload)
                result=subprocess.run([str(powershell), '-NoProfile', '-Command', command], cwd=ROOT,
                    env={**os.environ, 'WOS_HASH_FIXTURE':str(fixture)}, capture_output=True, timeout=15)
                self.assertEqual(0, result.returncode, result.stderr.decode(errors='replace'))
                actual=result.stdout.decode().strip().replace('-', '').lower()
                self.assertEqual(hashlib.sha256(payload).hexdigest(), actual)
                hashes.append(actual)
            self.assertNotEqual(*hashes)


if __name__=='__main__':
    unittest.main()

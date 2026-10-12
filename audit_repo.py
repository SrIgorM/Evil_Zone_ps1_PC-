"""Audit the tracked public kit (or all files when used without Git)."""
from pathlib import Path
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
ALLOWED_SUFFIXES = {'.md', '.txt', '.json', '.toml', '.patch', '.ps1', '.cmd', '.py', '.yml'}
ALLOWED_SPECIAL = {'LICENSE', '.gitignore', '.gitattributes'}
PRIVATE_DIRS = {'disc', 'bios', 'assets', 'cache', 'generated', 'saves', 'diagnosticos', 'build', 'dist'}

def paths():
    if (ROOT / '.git').exists():
        result = subprocess.run(['git', '-C', str(ROOT), 'ls-files', '-z'], check=True, capture_output=True)
        return [ROOT / p.decode('utf-8') for p in result.stdout.split(b'\0') if p]
    return [p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts]

def main():
    errors = []
    files = paths()
    for path in files:
        rel = path.relative_to(ROOT)
        if path.is_symlink():
            errors.append(f'{rel}: symbolic link')
            continue
        if any(part.lower() in PRIVATE_DIRS for part in rel.parts[:-1]):
            errors.append(f'{rel}: private directory')
        if path.name not in ALLOWED_SPECIAL and path.suffix.lower() not in ALLOWED_SUFFIXES:
            errors.append(f'{rel}: unsupported file type')
        data = path.read_bytes()
        if len(data) > 200_000 or b'\x00' in data:
            errors.append(f'{rel}: oversized or binary content')
            continue
        try:
            content = data.decode('utf-8-sig')
        except UnicodeDecodeError:
            errors.append(f'{rel}: not UTF-8 text')
            continue
        private_path_pattern = r'[A-Za-z]:[\\/]Users[\\/]|/ho' + r'me/[^/\s]+/'
        if re.search(private_path_pattern, content, re.I):
            errors.append(f'{rel}: personal absolute path')
        if re.search(r'gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----', content):
            errors.append(f'{rel}: possible credential')
        if path.suffix == '.json':
            try:
                json.loads(content)
            except ValueError as exc:
                errors.append(f'{rel}: invalid JSON: {exc}')
    if not files:
        errors.append('No files found; stage the kit before auditing a Git repository.')
    if errors:
        print('\n'.join(errors), file=sys.stderr)
        return 1
    print(f'PASS: {len(files)} text files checked; no prohibited types or known private patterns found.')
    return 0

if __name__ == '__main__':
    sys.exit(main())

#!/usr/bin/env python3
from pathlib import Path
from subprocess import run
from os import walk
from shutil import copy
import sys


USAGE = f'{__file__} [NERD FONTS DIRECTORY]'
HERE = Path.home() / 'dotfiles' / 'fonts'


try:
    fonts_repo = Path(sys.argv[1])
except IndexError:
    fonts_repo = Path.home() / 'nerd-fonts'

if not fonts_repo.is_dir():
    print(USAGE, file=sys.stderr)
    sys.exit(1)

run(['git', '-C', str(fonts_repo), 'pull'])

current_fonts = set(p.name for p in HERE.iterdir() if p.name.endswith('.otf') or p.name.endswith('.ttf'))

for root, dirs, files in walk(fonts_repo):
    for file in files:
        if file in current_fonts:
            full_path = Path(root, file)
            print(copy(full_path, HERE))

run(['fc-cache'])

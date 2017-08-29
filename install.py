#!/bin/env python3

"""
MIT License

Copyright (c) 2017 MaT1g3R

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

from argparse import ArgumentParser
from collections import OrderedDict
from json import load
from os import devnull
from pathlib import Path

here = Path(Path(__file__).parent)
home = str(Path.home())


def main():
    with here.joinpath('mapping.json').open() as f:
        mapping = load(f, object_pairs_hook=OrderedDict)
    parse = ArgumentParser(description='Dotfiles installer')
    parse.add_argument(
        '-v', '--verbose', help='Verbose mode', action='store_true'
    )
    parse.add_argument(
        '-f', '--force', help='Force mode, remove existing configs',
        action='store_true'
    )
    for key in mapping:
        parse.add_argument(
            '-{}'.format(key),
            help='Install {} dotfiles'.format(prettify(key)),
            action='store_true'
        )

    args = parse.parse_args()
    types = vars(args)
    verbose = types.pop('verbose')
    force = types.pop('force')
    if not any(types.values()):
        print('You must choose at lesat one type of dotfiles to install.')
        parse.print_help()
        return

    print('Installing...')
    for key, val in types.items():
        if val:
            link(verbose, force, mapping[key])
    print('Done!')


def prettify(s):
    if s == 'linux':
        return 'GNU/Linux'
    if s == 'macos':
        return 'macOS'
    if s == 'kde':
        return 'KDE'
    return s


def link(verbose, force, files):
    for src, dest in files.items():
        dest = dest.replace('~', home)
        if src.endswith('*'):
            link_many(verbose, force, src, dest)
        else:
            link_one(verbose, force, src, dest)


def link_one(verbose, force, src, dest):
    out = None if verbose else open(devnull, 'w')

    if not isinstance(src, Path):
        src = here.joinpath(src).resolve()
    if not isinstance(dest, Path):
        dest = Path(dest).absolute()

    is_dir = src.is_dir()
    parent = Path(dest.parent)
    if not parent.exists():
        parent.mkdir(parents=True)

    if force and dest.is_dir() and not dest.is_symlink():
        dest.rmdir()
    elif force:
        dest.unlink()

    if force:
        print('Removed {}'.format(dest), file=out)
    try:
        dest.symlink_to(src, is_dir)
    except OSError:
        if force:
            raise
        print('{} already exists, skipping'.format(dest), file=out)
    else:
        print('Made symlink from {} to {}'.format(src, dest), file=out)


def link_many(verbose, force, src, dest):
    for file in Path(src.strip('*')).iterdir():
        file = Path(file)
        link_one(
            verbose, force, file.resolve(),
            Path(dest.strip('*')).joinpath(file.name).absolute()
        )


if __name__ == '__main__':
    main()

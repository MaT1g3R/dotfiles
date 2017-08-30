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
from codecs import decode
from collections import OrderedDict
from json import load
from os import devnull
from pathlib import Path
from subprocess import PIPE, Popen, STDOUT

here = Path(Path(__file__).parent)
home = str(Path.home())


def main():
    """
    Main function.
    """
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
    for key, val in mapping.items():
        name = val.pop('name', key)
        parse.add_argument(
            '-{}'.format(key),
            help='Install {} dotfiles'.format(name),
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
    shell_command('git config --get core.excludesfile ~/.gitignore_global')
    print('Done!')


def shell_command(cmd, print_output=True):
    """
    Run a shell command and prints its output to stdout

    Parameters
    ----------
    cmd
        the shell command
    print_output
        if True this will print the output to stdout.
    Returns
    -------
        The output lines
    """
    if print_output:
        print('$ {}'.format(cmd))
    process = Popen(cmd, stdout=PIPE, stderr=STDOUT, shell=True)
    lines = []
    for line in process.stdout:
        res = decode(line)
        if print_output:
            print(res)
        else:
            lines.append(res)
    return lines


def link(verbose, force, files):
    """
    Make symlinks from a set of files.

    Parameters
    ----------
    verbose
        True for verbose mode
    force
        True to remove existing files on the file system
    files
        The set of files

    """
    for src, dest in files.items():
        dest = dest.replace('~', home)
        if src.endswith('*'):
            link_many(verbose, force, src, dest)
        else:
            link_one(verbose, force, src, dest)


def link_one(verbose, force, src, dest):
    """
    Make one symlink

    Parameters
    ----------
    verbose
        True for verbose mode
    force
        True to remove existing files on the file system
    src
        The source file
    dest
        The destination path
    """
    out = None if verbose else open(devnull, 'w')

    if not isinstance(src, Path):
        src = here.joinpath(src).resolve()
    if not isinstance(dest, Path):
        dest = Path(dest).absolute()

    parent = Path(dest.parent)
    if not parent.exists():
        parent.mkdir(parents=True)

    if dest.exists() and force:
        if dest.is_dir() and not dest.is_symlink():
            dest.rmdir()
        else:
            dest.unlink()
        print('Removed {}'.format(dest), file=out)

    try:
        dest.symlink_to(src, src.is_dir())
    except OSError as e:
        if force:
            raise e
        print('{} already exists, skipping'.format(dest), file=out)
    else:
        print('Made symlink from {} to {}'.format(src, dest), file=out)


def link_many(verbose, force, src, dest):
    """
    Make many symlinks (to handle wild cards)

    Parameters
    ----------
    verbose
        True for verbose mode
    force
        True to remove existing files on the file system
    src
        The source directory
    dest
        The destination directory path
    """
    for file in Path(src.strip('*')).iterdir():
        file = Path(file)
        link_one(
            verbose, force, file.resolve(),
            Path(dest.strip('*')).joinpath(file.name).absolute()
        )


if __name__ == '__main__':
    main()

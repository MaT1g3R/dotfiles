#!/usr/bin/env python3

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
from subprocess import PIPE, Popen, STDOUT, run


here = Path(Path(__file__).parent)
home = Path.home()


def main():
    """
    Main function. Parse the cli arguments.
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
    parse.add_argument(
        '-i', '--init', help='Init mode, do some initial setup',
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
    init = types.pop('init')
    if not any(types.values()):
        print('You must choose at lesat one type of dotfiles to install.')
        parse.print_help()
        return 1
    install(types, init, verbose, force, mapping)
    return 0


def install(types, init, verbose, force, mapping):
    """
    Install function.

    Parameters
    ----------
    types
        Types of dotfiles to be installed.
    init
        True to run the init scripts
    verbose
        True for verbose mode
    force
        True to remove existing files on the file system
    mapping
        Symlink mapping dictionary
    """
    print('Installing...')
    common_commands(verbose, force, init)
    for key, val in types.items():
        if val:
            if key == 'macos':
                mac_commands(init)
            link(verbose, force, mapping[key])
    print('Done!')


def common_commands(verbose, force, init):
    """
    Shell commands for all installation types.

    Parameters
    ----------
    verbose
        True for verbose mode
    force
        True to remove existing files on the file system
    init
        True to run the init scripts
    """
    if init:
        if not home.joinpath('.oh-my-zsh').is_dir():
            sh('sh {}'.format(here.joinpath('shell').joinpath('oh-my-zsh')))

    global_gitig_path = home.joinpath('.gitignore_global')
    link_one(verbose, force, 'git/.gitignore_global', global_gitig_path)
    sh('git config --get core.excludesfile {}'.format(global_gitig_path))

    with here.joinpath('vscode').joinpath('extensions').open() as f:
        code_pkgs = f.read().splitlines()
    for pkg in code_pkgs:
        sh('code --install-extension {}'.format(pkg))


def sh(cmd, print_output=True):
    """
    Run a shell command.

    Parameters
    ----------
    cmd
        the shell command
    print_output
        if True this will print the output

    Returns
    -------
    The process return code
    """
    res = run(cmd, shell=True, stdout=PIPE, stderr=STDOUT)
    out = decode(res.stdout)
    if print_output:
        print(out)
    return res.returncode


def mac_commands(init):
    """
    Shell commands for macOS

    Parameters
    ----------
    init
        True to run the init scripts
    """
    mac = here.joinpath('macos')
    if init:
        sh('bash {}'.format(mac.joinpath('brew.sh')))
        sh('bash {}'.format(mac.joinpath('macos.sh')))


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
        dest = dest.replace('~', str(home))
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
    exit(main())

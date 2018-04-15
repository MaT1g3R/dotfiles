#!/usr/bin/env python3

"""
MIT License

Copyright (c) 2017-2018 MaT1g3R

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
from glob import glob
from json import loads
from pathlib import Path
from os.path import expanduser, basename, join
from subprocess import PIPE, STDOUT, run


HERE = Path(__file__).parent
HOME = Path.home()


def main():
    """
    Main function. Parse the cli arguments.
    """
    mapping = loads((HERE / 'mapping.json').read_text())
    parse = ArgumentParser(description='Dotfiles Installer')
    parse.add_argument(
        '-v', '--verbose', help='verbose mode', action='store_true'
    )
    parse.add_argument(
        '-f', '--force', help='force mode, remove existing configs',
        action='store_true'
    )
    parse.add_argument(
        '-i', '--init', help='init mode, do some initial setup',
        action='store_true'
    )
    parse.add_argument(
        'targets', help='installation targets', choices=mapping, nargs='+'
    )
    args = parse.parse_args()
    install(args.verbose, args.force, args.init, args.targets, mapping)
    return 0


def install(verbose, force, init, targets, mapping):
    """
    Install function.

    Parameters
    ----------
    verbose
        True for verbose mode
    force
        True to remove existing files
    init
        True to run the init scripts
    targets
        Installation targets
    mapping
        Symlink mapping dictionary
    """
    print('Installing...')
    common_commands(verbose, force, init)
    for key, val in filter(lambda x: x[0] in targets, mapping.items()):
        if key == 'macos' and init:
            mac = HERE / 'macos'
            sh(f'bash {(mac / "brew.sh")}')
            sh(f'bash {(mac / "macos.sh")}')
        link(verbose, force, val)
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
        if not (HOME / '.oh-my-zsh').is_dir():
            sh(f'sh {(HERE / "shell" / "oh-my-zsh")}')

    global_gitig_path = HOME / '.gitignore_global'
    link_one(
        verbose, force, Path('git').resolve() / '.gitignore_global', global_gitig_path
    )
    sh(f'git config --get core.excludesfile {global_gitig_path}')


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
    res = run(cmd, shell=True, stdout=PIPE, stderr=STDOUT, encoding='utf8')
    if print_output:
        print(res.stdout)
    return res.returncode


def maybe_print(s, verbose):
    """
    Print string ``s`` if verbose

    Parameters
    ----------
    s
        the string to print
    verbose
        wether to print or not
    """
    if verbose:
        print(s)


def process_paths(files):
    """
    Process source, destination pairs

    Parameters
    ----------
    files
        A dictionary of {src: dest} file paths

    Returns
    -------
    A generator of resolved file paths
    """
    for src, dest in files.items():
        for file in glob(src):
            if dest.endswith('*'):
                yield file, join(expanduser(dest.rstrip('*')), basename(file))
            else:
                yield file, dest


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
    for src, dest in process_paths(files):
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
    if not isinstance(src, Path):
        src = (HERE / src).resolve()
    if not isinstance(dest, Path):
        dest = Path(dest).expanduser().absolute()

    if not dest.parent.exists():
        dest.parent.mkdir(parents=True)

    if dest.exists() and force:
        if dest.is_dir() and not dest.is_symlink():
            dest.rmdir()
        else:
            dest.unlink()
        maybe_print(f'Removed {dest}', verbose)

    try:
        dest.symlink_to(src, src.is_dir())
    except OSError as e:
        if force:
            raise e
        maybe_print(f'{dest} already exists, skipping', verbose)
    else:
        maybe_print(f'{src} -> {dest}', verbose)


if __name__ == '__main__':
    exit(main())

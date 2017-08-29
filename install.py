#!/bin/env python3
from argparse import ArgumentParser
from json import load
from os import devnull
from pathlib import Path

here = Path(Path(__file__).parent)
home = str(Path.home())


def main():
    with here.joinpath('mapping.json').open() as f:
        mapping = load(f)

    parse = ArgumentParser(description='Dotfiles installer')

    parse.add_argument(
        '-v', '--verbose', help='Verbose mode', action='store_true'
    )

    parse.add_argument(
        '-f', '--force', help='Force mode, remove existing configs',
        action='store_true'
    )

    parse.add_argument(
        '-common', help='Install common dotfiles', action='store_true'
    )

    parse.add_argument(
        '-kde', help='Install KDE specific dotfiles', action='store_true'
    )

    parse.add_argument(
        '-linux', help='Install Linux specific dotfiles', action='store_true'
    )

    parse.add_argument(
        '-macos', help='Install macOS specific dotfiles',
        action='store_true'
    )

    args = parse.parse_args()

    if not args.common and not args.kde and not args.macos and not args.linux:
        parse.print_help()
        return

    print('Installing...')
    if args.common:
        link(args.verbose, args.force, mapping['common'])

    if args.kde:
        link(args.verbose, args.force, mapping['kde'])

    if args.linux:
        link(args.verbose, args.force, mapping['linux'])

    if args.macos:
        link(args.verbose, args.force, mapping['macos'])
    print('Done!')


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

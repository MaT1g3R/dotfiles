#!/usr/bin/env python3
import sys
from os import chdir, curdir
from subprocess import run
from pathlib import Path


USAGE = f'{__file__} DIR'
LOGS = []


def decue_one(files, cue):
    print(cue)
    name = cue.name.rsplit('.')[0]
    for file in files:
        if file.name.rsplit('.')[0] == name and file.suffix != '.cue':
            run(['flacon', '-s', str(cue)], check=False)
    LOGS.append(str(cue))
    print(f'Could not find audio file matching {cue}', file=sys.stderr)


def decue(path):
    found = 0
    files = list(path.iterdir())
    for file in files:
        if file.suffix == '.cue':
            found += 1
            decue_one(files, file)
        elif file.is_dir():
            found += decue(file.resolve())
    return found


def main(args):
    if len(args) == 2:
        _, path = args
    else:
        print(USAGE, file=sys.stderr)
        return 1
    path = Path(path)
    if not path.is_dir():
        print('path is not a valid directory', file=sys.stderr)
        return 1

    found = decue(path)
    with open('./log', 'w+') as f:
        stri = '\n'.join(LOGS)
        f.write(stri)
    if found:
        return 0
    print('Could not find cue file', file=sys.stderr)
    return 1


if __name__ == '__main__':
    sys.exit(main(sys.argv))

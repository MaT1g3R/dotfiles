#!/usr/bin/env python3

"""
Dynamically generate GHCI prompt based on pwd
"""
from pathlib import Path
from os import getcwd
from sys import argv
from shutil import which
from subprocess import Popen

BASE = r'\ESC[{}m\STX'
COLOUR = BASE.format
GREY = COLOUR(30)
RED = COLOUR(31)
GREEN = COLOUR(32)
YELLOW = COLOUR(33)
BLUE = COLOUR(34)
PURPLE = COLOUR(35)
CYAN = COLOUR(36)
WHITE = COLOUR(37)
RESET = COLOUR(0)


BOILER_PLATE = '''\
import qualified IPPrint
import qualified Language.Haskell.HsColour as HsColour
import qualified Language.Haskell.HsColour.Colourise as HsColour
import qualified Language.Haskell.HsColour.Output as HsColour

let myColourPrefs = HsColour.defaultColourPrefs { HsColour.conid = [HsColour.Foreground HsColour.Yellow, HsColour.Bold], HsColour.conop = [HsColour.Foreground HsColour.Yellow], HsColour.string = [HsColour.Foreground HsColour.Green], HsColour.char = [HsColour.Foreground HsColour.Cyan], HsColour.number = [HsColour.Foreground HsColour.Red, HsColour.Bold], HsColour.layout = [HsColour.Foreground HsColour.White], HsColour.keyglyph = [HsColour.Foreground HsColour.White] }

let myPrint = putStrLn . HsColour.hscolour (HsColour.TTYg HsColour.XTerm256Compatible) myColourPrefs False False "" False . IPPrint.pshow

:set -interactive-print=myPrint
'''

FILE = Path().cwd() / '.ghci'


def main():
    pwd = getcwd().replace(str(Path.home()), '~').split('/')[-3:]
    pwd = '/'.join(pwd)
    prompt = f':set prompt "{CYAN}λ {WHITE}ghci {BLUE}{pwd} {RESET}"'
    FILE.write_text(BOILER_PLATE + prompt)
    with Popen([which('ghci')] + argv[1:]) as proc:
        proc.wait()
    FILE.unlink()


if __name__ == '__main__':
    main()

#!/usr/bin/env python3

"""
Dynamically generate GHCI prompt based on pwd
"""
from time import sleep
from pathlib import Path
from os import getcwd
from shutil import which
from subprocess import Popen

GREEN = r'\ESC[32m\STX'
YELLOW = r'\ESC[33m\STX'
PURPLE = r'\ESC[35m\STX'
CYAN = r'\ESC[36m\STX'
RESET = r'\ESC[0m\STX'

BOILER_PLATE = '''\
import qualified IPPrint
import qualified Language.Haskell.HsColour as HsColour
import qualified Language.Haskell.HsColour.Colourise as HsColour
import qualified Language.Haskell.HsColour.Output as HsColour

let myColourPrefs = HsColour.defaultColourPrefs { HsColour.conid = [HsColour.Foreground HsColour.Yellow, HsColour.Bold], HsColour.conop = [HsColour.Foreground HsColour.Yellow], HsColour.string = [HsColour.Foreground HsColour.Green], HsColour.char = [HsColour.Foreground HsColour.Cyan], HsColour.number = [HsColour.Foreground HsColour.Red, HsColour.Bold], HsColour.layout = [HsColour.Foreground HsColour.White], HsColour.keyglyph = [HsColour.Foreground HsColour.White] }

let myPrint = putStrLn . HsColour.hscolour (HsColour.TTYg HsColour.XTerm256Compatible) myColourPrefs False False "" False . IPPrint.pshow

:set -interactive-print=myPrint
'''

FILE = Path().home() / '.ghci'


def main():
    pwd = getcwd().replace(str(Path.home()), '~').split('/')[-3:]
    pwd = '/'.join(pwd)
    prompt = f':set prompt "{GREEN}λ {YELLOW}ghci {PURPLE}[{pwd}] {CYAN}→ {RESET}"'
    FILE.write_text(BOILER_PLATE + prompt)
    with Popen([which('ghci')]) as proc:
        proc.wait()
    FILE.unlink()


if __name__ == '__main__':
    main()

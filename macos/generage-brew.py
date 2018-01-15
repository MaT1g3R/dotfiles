#!/usr/bin/env python3


from subprocess import Popen, PIPE


BP = """\
#!/usr/bin/env bash

brew update
brew upgrade
brew cask upgrade

# Brew
{brew}

# Casks
{cask}

# Chunkwm
brew tap crisidev/homebrew-chunkwm
brew install chunkwm

# Cleanup
brew cleanup
brew cask cleanup
"""

specials = {
    'gnu-sed': '--with-default-names',
    'wget': '--with-iri',
    'imagemagick': '--with-webp'
}

formulaes = Popen('brew ls', shell=True, stdout=PIPE)
casks = Popen('brew cask ls', shell=True, stdout=PIPE)

formulaes.wait()
casks.wait()


def convert_to_special(s):
    arg = specials.get(s)
    if not arg:
        return s
    return f'{s} {arg}'


def special_key(s):
    if s.split()[0] in specials:
        return 0
    return 1


formulaes = [convert_to_special(s.decode().rstrip()) for s in formulaes.stdout]
casks = [convert_to_special(s.decode().rstrip()) for s in casks.stdout]

formulaes.sort(key=special_key)
casks.sort(key=special_key)

formulaes = [f'brew install {f}' for f in formulaes]
casks = [f'brew cask install {f}' for f in casks]

brew_file = BP.format(brew='\n'.join(formulaes), cask='\n'.join(casks))

with open('brew.sh', 'w') as f:
    f.writelines(brew_file)

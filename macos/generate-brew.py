#!/usr/bin/env python3


from subprocess import Popen, PIPE


BP = """\
#!/usr/bin/env bash

brew update
brew upgrade
brew cask upgrade

# Notes:
# GNU core utilities: Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
# GNU `find`, `locate`, `updatedb`, and `xargs` are `g`-prefixed.
# GNU `sed` overwrites the built-in `sed`.
# Bash: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# Wget: with IRI support.

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
    'imagemagick': '--with-webp',
    'ffmpeg': '--with-sdl2',
}

formulaes = Popen('brew ls', shell=True, stdout=PIPE)
casks = Popen('brew cask ls', shell=True, stdout=PIPE)

formulaes.wait()
casks.wait()


def brew_list(is_cask):
    lst = []
    it = casks.stdout if is_cask else formulaes.stdout
    install = 'brew cask install' if is_cask else 'brew install'
    for f in it:
        f = f.decode().rstrip()
        spec = specials.get(f)
        if spec:
            yield f'{install} {f} {spec}'
        else:
            lst.append(f'{install} {f}')
    yield from lst


formulae_list = list(brew_list(False))
cask_list = list(brew_list(True))
brew_file = BP.format(brew='\n'.join(formulae_list), cask='\n'.join(cask_list))

with open('brew.sh', 'w') as f:
    f.writelines(brew_file)

with Popen('chmod +x brew.sh', shell=True) as proc:
    proc.wait()

print(f'Done! Total of {len(formulae_list)} formulaes and {len(cask_list)} casks.')

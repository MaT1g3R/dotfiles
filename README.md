# My dotfiles

![](https://github.com/MaT1g3R/dotfiles/raw/master/screenshot.png)

# Install

**Warning**: Before you proceed with the installation, please review the code 
beforehand. Optionally, fork this repository and remove things you don't want. 
Don’t blindly use my settings unless you know what that entails. 
Use at your own risk!

After you have reviewed the code, clone the repo, then run the install script:

```bash
chmod +x install.py
./install.py -h
```

The `-h` flag will display the help message, and you can proceed to run the 
script again with the options you want. An example might be like this:

```bash
./install.py -v -common -linux
```

# The mapping file
The `mapping.json` file contains the symbolic link paths from this directory
to the file system. The top level key names are the categories of the settings.
They will be read by the install script and show up as options for the install.
For example `common` will be used by the `-common` flag.


The keys under the categories are the paths to the config file/directory source
relative to the `dotfiles` directory, the values are the absolute paths on the
file system to symbolic link the config files to.

Optionally, you may provide a key called `name` to specify the name that will 
be printed on the screen by the help message for each category.

# Credits and software used

* [zsh](http://www.zsh.org/) with 
  [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* Lambda-mod zsh theme: https://github.com/halfo/lambda-mod-zsh-theme
* Even-better-ls: https://github.com/illinoisjackson/even-better-ls
* Base16 colour theme: https://github.com/chriskempson/base16
* [Tmux](https://github.com/tmux/tmux) and 
  [Powerline](https://github.com/powerline/powerline)
* Tmux config borrowed from: https://github.com/tony/tmux-config
* [Patched Hack font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack) 
  for the terminal
* [San Francisco Font](https://github.com/supermarin/YosemiteSanFranciscoFont) 
  for rest of the system
* Latte-dock: https://github.com/psifidotos/Latte-Dock
* Custom cowsay files: https://github.com/WolfgangAxel/Random-Projects/blob/master/ruri.cow
* KWin tile script: https://github.com/Jazqa/kwin-quarter-tiling
* Modified macOS install script from here: https://github.com/mathiasbynens/dotfiles/blob/master/.macos
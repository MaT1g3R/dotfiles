# My dotfiles

![](https://github.com/MaT1g3R/dotfiles/raw/master/screenshot.png)

# Installation

**Warning**: Before you proceed with the installation, please review the configurations beforehand. Don't blindly use settings unless you know what that entails. Use at your own risk!

Clone the repository and run the install script:

```bash
chmod +x install.py
./install.py -h
```

By default, the installer automatically detects your operating system and installs `common/` plus your current platform (`linux/` or `macos/`):

```bash
# Dry run to preview what will be installed
./install.py -n

# Normal installation (hard links with fallback to symlinks)
./install.py

# Force overwrite existing conflicting files
./install.py -f

# Create timestamped backups before overwriting conflicting files
./install.py -b

# Install using symbolic links only
./install.py -s

# Run initial setup (global git excludesfile, macOS setup scripts)
./install.py -i
```

# Directory Structure Mapping

Instead of a centralized mapping file, configurations are organized directly by platform directory mirroring `$HOME`:

```
dotfiles/
├── common/             # Installed on all platforms (Linux & macOS)
│   ├── .config/
│   │   ├── fish/       # -> ~/.config/fish/
│   │   ├── nvim/       # -> ~/.config/nvim/
│   │   └── ...
│   ├── .tmux.conf      # -> ~/.tmux.conf
│   └── bin/            # -> ~/bin/
├── linux/              # Installed on Linux
│   ├── .local/share/
│   │   ├── fonts/      # -> ~/.local/share/fonts/
│   │   └── konsole/    # -> ~/.local/share/konsole/
│   ├── .config/
│   │   └── shortcuts.kksrc
│   └── .Xresources     # -> ~/.Xresources
├── macos/              # Installed on macOS
└── setup/              # Platform setup & helper scripts
    ├── fonts/
    └── macos/
```

Any file placed under `common/`, `linux/`, or `macos/` automatically maps to the corresponding relative path under `$HOME`.

Files are linked using hard links by default when on the same filesystem (saving inodes and keeping edits in sync), automatically falling back to symbolic links across filesystems or partitions.

# Credits and software used

* [Fish Shell](https://fishshell.com/)
* Base16 colour theme: https://github.com/chriskempson/base16
* [Tmux](https://github.com/tmux/tmux)
* Tmux config borrowed from: https://github.com/gpakosz/.tmux
* [Patched FiraCode font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) for the terminal
* [San Francisco Font](https://github.com/supermarin/YosemiteSanFranciscoFont) for rest of the system
* Latte-dock: https://github.com/psifidotos/Latte-Dock
* KWin tile script: https://github.com/Jazqa/kwin-quarter-tiling
* Modified macOS install script from here: https://github.com/mathiasbynens/dotfiles/blob/master/.macos

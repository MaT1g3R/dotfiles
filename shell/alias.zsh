alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/dotfiles/neovim/init.vim'
alias sudo='sudo '
alias rurisay='cowsay -f ~/scripts/ruri.cow'
alias rurithink='cowthink -f ~/scripts/ruri_think.cow'
alias pp='git pull; git push'
alias gdbstack='gdb --batch --ex r --ex bt --ex q --args'
alias ghci='python3 ~/scripts/ghci_prompt.py'
alias vim='nvim'
alias vi='nvim'
alias die='shutdown now'
alias coala='~/venv/coala/bin/coala'
alias what-the-commit='git commit -m "$(echo $(curl -s http://whatthecommit.com/index.txt))"'
alias gpa='git pushall'
alias l='ls -l'
alias ll='ls -l'
alias la='ls -la'
alias reload='exec zsh'

update_plugins() {
    antibody update;
    antibody bundle < $HOME/dotfiles/shell/plugins.txt > $HOME/.plugins.zsh
}

if [ `uname` = 'Linux' ]; then # Linux
    wd() {
        . /usr/share/wd/wd.sh
    }
    alias buku='~/venv/buku/bin/buku'
    alias aur='trizen'
    alias yolo='trizen -Syu;bash ~/scripts/update_quarter_tiling.sh'
    alias pac-optimize='trizen -Sc; sudo pacman-optimize'
    alias pac-orphans='trizen -Rns $(trizen -Qtdq)'
    alias pac-mirror='sudo pacman-mirrors -f 0 && trizen -Syy'
    alias open='xdg-open'
    alias play='sudo mount -a;mpd;ncmpcpp'
else # Macos
    alias gcc='gcc-7'
    alias cc='gcc-7'
    alias yolo='brew update; brew upgrade; brew cask upgrade; brew cleanup; brew cask cleanup;' 
fi

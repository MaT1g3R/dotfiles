#alias
alias ..="builtin cd .."
alias coala='~/venv/coala/bin/coala'
alias die='shutdown now'
alias gdbstack='gdb --batch --ex r --ex bt --ex q --args'
alias ghci='python3 ~/scripts/ghci_prompt.py'
alias gpa='git pushall'
alias gpp='git pull; git push'
alias ls='ls_extended'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias p='python'
alias reload='exec zsh'
alias rurisay='cowsay -f ~/scripts/ruri.cow'
alias rurithink='cowthink -f ~/scripts/ruri_think.cow'
alias sudo='sudo '
alias vi='nvim'
alias vim='nvim'
alias vimrc='nvim ~/dotfiles/neovim/init.vim'
alias what-the-commit='git commit -m "$(echo $(curl -s http://whatthecommit.com/index.txt))"'
alias zshrc='nvim ~/.zshrc'

#functions
update_plugins() {
    antibody update;
    antibody bundle < $HOME/dotfiles/shell/plugins.txt > $HOME/.plugins.zsh
}

yt-play() {
    youtube-dl $1 -o - | mpv -;
}

yt-best() {
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 $1;
}

nuclear-warhead() {
    find / -name .git | while read d; do cd "$(dirname "$d")"; git add -A; git commit -m "last words"; git push --all origin; done
}

# OS dependent
if [ `uname` = 'Linux' ]; then # Linux
    alias aur='trizen'
    alias buku='~/venv/buku/bin/buku'
    alias open='mimeopen'
    alias pac-mirror='sudo pacman-mirrors -f 0 && trizen -Syy'
    alias pac-optimize='trizen -Sc; sudo pacman-optimize'
    alias pac-orphans='trizen -Rns $(trizen -Qtdq)'
    alias play='mpd;ncmpcpp'
    alias yolo='trizen -Syu;bash ~/scripts/update_quarter_tiling.sh'

    wd() {
        . /usr/share/wd/wd.sh
    }
else # macOS
    alias cc='gcc-8'
    alias gcc='gcc-8'
    alias yolo='brew update; brew upgrade; brew cask upgrade; brew cleanup;'


fi

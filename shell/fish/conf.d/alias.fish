#alias
alias die='shutdown now'
alias fd="fdfind"
alias gdbstack='gdb --batch --ex r --ex bt --ex q --args'
alias gpa='git pushall'
alias gpp='git pull; git push'
alias gssg="git status -s | awk -F / '{ print $NF, $0 }' | sed -e 's/\.scala/A/' | sort -k 1 | sed 's/.* //'"
alias grep='rg'
alias lg='lazygit'
alias ls='ls_extended'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias p='python'
alias rurisay='cowsay -f ~/scripts/ruri.cow'
alias rurithink='cowthink -f ~/scripts/ruri_think.cow'
alias sudo='sudo '
alias vi='nvim'
alias vim='nvim'
alias vimrc='nvim ~/dotfiles/neovim/init.vim'
alias what-the-commit='git commit -m (echo (curl -s http://whatthecommit.com/index.txt))'


# OS dependent
if [ (uname) = 'Linux' ] # Linux
    alias aur='trizen'
    alias buku='~/venv/buku/bin/buku'
    alias open='mimeopen'
    alias pac-mirror='sudo pacman-mirrors -f 0 && trizen -Syy'
    alias pac-optimize='trizen -Sc; sudo pacman-optimize'
    alias pac-orphans='trizen -Rns (trizen -Qtdq)'
    alias play='mpd;ncmpcpp'
    alias yolo='trizen -Syu;bash ~/scripts/update_quarter_tiling.sh'
else # macOS
    alias cc='gcc-8'
    alias gcc='gcc-8'
    alias yolo='brew update; brew upgrade; brew cask upgrade; brew cleanup;'
end

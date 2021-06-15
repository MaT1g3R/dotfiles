#alias
alias cat=bat
alias clip='xclip -selection clipboard'
alias d='docker'
alias dc='docker-compose'
alias die='shutdown now'
alias gdbstack='gdb --batch --ex r --ex bt --ex q --args'
alias glom="git pull origin master"
alias gpa='git pushall'
alias gpp='git pull; git push'
alias gssg="git status -s | awk -F / '{ print $NF, $0 }' | sed -e 's/\.scala/A/' | sort -k 1 | sed 's/.* //'"
alias gsw='git switch'
alias grep='rg'
alias k='kubectl'
alias lg='lazygit'
alias ls='exa --icons'
alias l='ls -laah'
alias la='ls -lah'
alias ll='ls -lh'
alias lzd='lazydocker'
alias p='python'
alias rs='rsync'
alias rurisay='cowsay -f ~/scripts/ruri.cow'
alias rurithink='cowthink -f ~/scripts/ruri_think.cow'
alias sudo='sudo '
alias vi='nvim'
alias vim='nvim'
alias vimrc='nvim ~/dotfiles/neovim/init.vim'

# OS dependent
if [ (uname) = 'Linux' ] # Linux
    alias fd="fdfind"
    alias aur='yay'
    alias buku='~/venv/buku/bin/buku'

    function open --wraps=mimeopen
      mimeopen $argv &;
      disown;
    end

    alias pac-mirror='sudo pacman-mirrors -f 0 && yay -Syy'
    alias pac-optimize='yay -Sc; sudo pacman-optimize'
    alias pac-orphans='yay -Rns (yay -Qtdq)'
    alias play='mpd;ncmpcpp'
    alias yolo='yay -Syu'
    alias restart-plasma='killall plasmashell; kstart5 plasmashell'
else # macOS
    alias cc='gcc-8'
    alias gcc='gcc-8'
    alias yolo='brew update; brew upgrade; brew cask upgrade; brew cleanup;'
end

#!/bin/fish
echo config.fish

set -U fish_greeting

set -x -g PATH ~/kde/src/kdesrc-build ~/.local/bin ~/bin /snap/bin $PATH

source ~/private.fish

# prompt
eval (starship init fish)

set -x EDITOR nvim
set -x VISUAL nvim

# set -x BAT_PAGER "less -R"
# set -x PAGER "page"
# set -x MANPAGER "page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'"

#GPG stuff
set -x GPG_TTY (tty)
set -x GPG_AGENT_INFO
if [ (uname) = 'Linux' ]
    set prev_shell $SHELL
    set -x SHELL fish
    eval (keychain --eval -Q --quiet id_dsa id_rsa)
    set -x SHELL $prev_shell
end

# direnv
direnv hook fish | source

# color scheme
set -u fish_color_end blue

# zoxide
zoxide init fish | source

# fzf
set -x FZF_DEFAULT_COMMAND 'fd --type f'
set -x FZF_DEFAULT_OPTS '--preview "bat --style=numbers --color=always {} 2> /dev/null | head -500"'

# startup
clear

if [ -z $TMUX ] && status is-interactive
    if [ (uname) != 'Linux' ] || [ (basename '/'(ps -f -p (cat /proc/(echo $fish_pid)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //')) != "yakuake" ]
        curl -s v2.wttr.in/Toronto -m 2 || true
    end
end

# cheat.sh
function cheat.sh
    curl cheat.sh/$argv
end

# register completions (on-the-fly, non-cached, because the actual command won't be cached anyway
complete -c cheat.sh -xa '(curl -s cheat.sh/:list)'

mcfly init fish | source

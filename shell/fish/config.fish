#!/bin/fish

set -U fish_greeting

set -x -g PATH ~/kde/src/kdesrc-build ~/.local/bin ~/bin /snap/bin $PATH

if [ (uname) != 'Linux' ]
    set -x -g PATH /usr/local/opt/qt/bin /usr/local/opt/llvm/bin /usr/local/bin /usr/local/opt/coreutils/libexec/gnubin $PATH
    set -x MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH
end

source ~/private.fish

# prompt
eval (starship init fish)

set -x EDITOR 'emacsclient -t -a ""'
set -x VISUAL 'emacsclient -c -a ""'
set -x PAGER nvimpager
set -x BAT_PAGER less
set -x TASKRC ~/.config/task/taskrc

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

# fzf
set -x FZF_DEFAULT_COMMAND 'fdfind --type f'
set -x FZF_DEFAULT_OPTS '--preview "bat --style=numbers --color=always {} 2> /dev/null | head -500"'

# startup
clear
if [ -z $TMUX ]
    if [ (uname) != 'Linux' ] || [ (basename '/'(ps -f -p (cat /proc/(echo $fish_pid)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //')) != "yakuake" ]
        curl -s wttr.in/Toronto -m 2 | head -n 17 || true
    end
    task
end

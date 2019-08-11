#!/bin/fish

set -U fish_greeting

set -x -g PATH ~/.local/bin ~/bin $PATH

if [ (uname) != 'Linux' ]
    set -x -g PATH /usr/local/opt/qt/bin /usr/local/opt/llvm/bin /usr/local/bin /usr/local/opt/coreutils/libexec/gnubin $PATH
    set -x MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH
end

# prompt
eval (starship init fish)

set -x EDITOR nvim
set -x VISUAL $EDITOR
set -x PAGER nvimpager
set -x BAT_PAGER less
set -x TASKRC ~/.config/task/taskrc

# direnv
direnv hook fish | source

# startup
clear
if [ -z $TMUX ]
    if [ (uname) != 'Linux' ] || [ (basename '/'(ps -f -p (cat /proc/(echo $fish_pid)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //')) != "yakuake" ]
        curl -s wttr.in/Toronto | head -n 17
    end
    task
end

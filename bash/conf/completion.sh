#!/usr/bin/env bash


# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


[[ -f ~/.fzf.bash ]] && source $HOME/.fzf.bash

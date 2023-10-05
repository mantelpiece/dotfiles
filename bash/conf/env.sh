#!/usr/bin/env bash


# Add my local opt directory to path, bpstudds 2013-12-12
export PATH="$HOME/opt/bin:$PATH"


export EDITOR=vim
hash fzf && hash fd && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

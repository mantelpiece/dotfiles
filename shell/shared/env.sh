#!/usr/bin/env bash

# You may need to manually set your language environment
export LANG=en_AU.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="vim"

export TERM="xterm-256color"

# Add my local opt directory to path, bpstudds 2013-12-12
export PATH="$HOME/opt/bin:$PATH"
export PATH="$HOME/.dotfiles/shared/bin:$PATH"


hash fzf && hash fd && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

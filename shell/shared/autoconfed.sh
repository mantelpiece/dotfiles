#!/usr/bin/env bash

# shellcheck disable=SC1091

# Autcompletion for bash
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# GNU core utils to path
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# GNU core utils man pages
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"

# Enable AWS CLI completion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

# Configuring jEnv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"


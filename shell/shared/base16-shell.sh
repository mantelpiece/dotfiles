#!/usr/bin/env bash

defaultDir="$HOME/.config/base16-shell"
base16ShellDir="${base16ShellDir:-$defaultDir}"

[[ -n "$PS1" ]] || { echo "Not configuring base16-shell: non-interactive shell"; exit; }
[[ -d "$base16ShellDir" ]] || { echo "Base16 shell not installed"; exit; }

# shellcheck disable=SC1091
source "$base16ShellDir/profile_helper.sh"

base16_tomorrow-night-eighties

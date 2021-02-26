#!/usr/bin/env bash

defaultDir="$HOME/.config/base16-shell"
base16ShellDir="${base16ShellDir:-$defaultDir}"

[[ -d "$base16ShellDir" ]] || { echo "Base16 shell not installed"; exit; }


# Load Base16 terminal helper doodad
[[ -n "$PS1" ]] || { echo "Not configuring base16-shell: non-interactive shell"; exit; }

eval "$($base16ShellDir/profile_helper.sh)"

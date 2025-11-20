#!/usr/bin/env bash

export NVM_DIR=~/.nvm

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # Load NVM
  if ! . "$NVM_DIR/nvm.sh"; then
    echo "Failed to load nvm"
    return
  fi

  if [[ -s "$NVM_DIR/bash_completion" ]]; then
    . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  fi

  load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
      nvm use --delete-prefix
    elif [[ $(nvm version) != $(nvm version default) ]]; then
      nvm use --delete-prefix default
    fi
  }

  cd() { builtin cd "$@"; 'load-nvmrc'; }

fi


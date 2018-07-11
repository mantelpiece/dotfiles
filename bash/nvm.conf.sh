export NVM_DIR=~/.nvm

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # Load NVM
  . "$NVM_DIR/nvm.sh"  # This loads nvm

  if [[ $? -ne 0 ]]; then
    exit 0;
  fi

  if [[ -s "$NVM_DIR/bash_completion" ]]; then
    . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  fi

  load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
      nvm use
    elif [[ `nvm version` != `nvm version default` ]]; then
      nvm use default
    fi
  }

  cd() { builtin cd "$@"; 'load-nvmrc'; }

fi


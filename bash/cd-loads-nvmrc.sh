load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default) ]]; then
    nvm use default
  fi
}

cd() { builtin cd "$@"; 'load-nvmrc'; }

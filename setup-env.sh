#!/usr/bin/env bash

# set -euo pipefail

die () { echo "$1" >&2; exit "$2-1"; }

hash curl 2>/dev/null || { die "Missing dep: wget"; }

tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'tmp')
[[ -d $tmpdir ]] || { die "Failed to create temp dir"; }
trap 'rm -rf $tmpdir' EXIT ERR


env="macos"
opts="myob imaging"


autoconf () {
  if ! grep -o "'$2'" $HOME/.dotfiles/bash/conf/autoconfed.sh; then
    echo -e "\n# $1\n$2\n" >> $HOME/.dotfiles/bash/conf/autoconfed.sh
  fi
}

if [[ $env = "macos" ]]; then
  if ! hash brew 2>/dev/null; then
    echo -e "\n\nInstalling homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  install="brew install";
fi


echo -e "\n\n\nInstalling core deps"
coreDeps="ack bash docker git jq nvm tmux tmuxinator tree vim xsv colordiff"
$install $coreDeps


if [[ $opts =~ "myob" ]]; then
  echo -e "\n\nInstalling MYOB options"
  brew tap myob-technology/helpers git@github.com:MYOB-Technology/homebrew-helpers.git
  brew install myob-auth awscli kubectl

  autoconf "Autocompletion for aws cli" "complete -C /usr/local/bin/aws_completer aws"
  # if ! grep -o "complete -C '/usr/local/bin/aws_completer' aws" $HOME/.dotfiles/bash/conf/autoconfed.sh; then
  #   echo -e "\n# Autocompletion for aws cli\ncomplete -C /usr/local/bin/aws_completer aws\n" >> $HOME/.dotfiles/bash/conf/autoconfed.sh
  # fi
fi


if [[ $opts =~ "imaging" ]]; then
  echo -e "\n\nInstalling imaging options"
  $install siril
  brew cask install gimp darktable
fi



if [[ $env = "macos" ]]; then
  echo -e "\n\nInstalling mac fixes"
  deps="bash-completion@2 coreutils"
  $install $deps

  autoconf "Autcompletion for bash" '[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"'
fi


# Install and configure base16-shell
if [[ ! -d $HOME/.config/base16-shell ]]; then
  git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
fi


# Install fonts
if [[ $env = "macos" ]]; then
  echo -e "\n\nInstalling fonts"
  brew tap homebrew/cask-fonts
  brew cask install font-dejavu-sans-mono-for-powerline
fi


# Install miniconda
if ! hash conda 2>/dev/null; then
  echo -e "\n\n\nInstalling miniconda"
  binary="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
  curl -s $binary -o $tmpdir/miniconda.sh
  bash $tmpdir/miniconda.sh -b -p $HOME/miniconda
fi


# Install poetry
if ! hash poetry 2>/dev/null; then
  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
  poetry completions bash > ~/.config/ /poetry.bash-completion
else
  poetry self update
fi
autoconf "Add poetry to PATH" 'export PATH="~/.poetry/bin:$PATH"'


echo -e "\n\nPost installation"
cat <<'EOF'
exec "$SHELL"
base16_tomorrow-night
EOF

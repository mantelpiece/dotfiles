#!/usr/bin/env bash

# set -euo pipefail

good () { echo -e "\e[32m$*\e[0m"; }
info () { echo -e "\e[34m$*\e[0m"; }
errr () { echo -e "\e[31m$*\e[0m"; }

die () { errr "${1:-""}" >&2; exit "${2:-1}"; }
usage () { die "usage: $0 -e OS [-o OPTIONS]"; }


tmpDir=$(mktemp -d 2>/dev/null || mktemp -d -t 'tmp')
[[ -d $tmpDir ]] || { die "Failed to create temp dir"; }
trap 'echo "YOU HAVE TRIGGERED MY TRAP CARD"; rm -rf $tmpDir' EXIT ERR

touch $tmpDir/hello
[[ -f $tmpDir/hello ]] || { die "wh?"; }

scriptDir="$(realpath "$(dirname "$0")")"

env=
options=
while getopts ":e:o:" arg; do
  case $arg in
    e) env=$OPTARG;;
    o) options=$OPTARG;;
    :) usage;;
    ?) usage;;
  esac
done

[[ -n "$env" ]] || { usage; }

echo "Installing for OS $env with options $options";


base16ShellTheme="base16_tomorrow-night-eighties"


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

  install="brew install"

  echo -e "\n\nInstalling mac fixes"
  deps="bash-completion@2 coreutils"
  $install $deps

  autoconf "Autcompletion for bash" '[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"'

elif [[ $env = "ubuntu" ]]; then
  echo "Unfortunately I need to sudo to install - sudo password will be requested during installation"
  install="sudo apt install -y"
fi



coreDeps="ack bash colordiff curl docker git jq nvm python3 tmux tmuxinator tree vim xsv"
if [[ $env = "ubuntu" ]]; then
  coreDeps="$coreDeps python-is-python3"
fi
good "\n\n#### Installing core deps"
info "  deps: $coreDeps"
$install $coreDeps


# Install dotfiles
good "\n\n#### Linking dotfiles"
(
  cd $HOME &&
    {
      rm -f ~/.bashrc && ln -s "$scriptDir/bash/bashrc" ~/.bashrc;
      ln -s "$scriptDir/tmux.conf" ~/.tmux.conf;
      ln -s "$scriptDir/vim" ~/.vim;
      ln -s "$scriptDir/vimrc" ~/.vimrc;
    }
)


# Install and configure base16-shell
if [[ ! -d $HOME/.config/base16-shell ]]; then
  good -e "\n\n\n#### Installing base16 shell colorschemes"
  git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
  eval "$($HOME/.config/base16-shell/profile_helper.sh)"

  $base16ShellTheme
fi


# Install fonts
good "\n\n#### Installing fonts"
if [[ $env = "macos" ]]; then
  brew tap homebrew/cask-fonts
  brew cask install font-dejavu-sans-mono-for-powerline
else
  if [[ ! -r "$HOME/.local/share/fonts/Droid Sans Mono Dotted for Powerline.ttf" ]]; then
    if ! git clone git@github.com:powerline/fonts.git "$tmpDir/fonts" --depth 1; then
      echo "Failed to download fonts";
    else
      ( cd "$tmpDir/fonts" && ./install.sh "Droid Sans Mono Dotted"; )
    fi
  fi
fi


if [[ $options =~ "imaging" ]]; then
  good "\n\n#### Installing imaging options"
  $install siril
  if [[ $env = "macos" ]]; then
     brew cask install gimp darktable
  else
     $install gimp darktable
  fi
fi


if [[ $options =~ "myob" ]]; then
  good "\n\n#### Installing MYOB options"
  brew tap myob-technology/helpers git@github.com:MYOB-Technology/homebrew-helpers.git
  brew install myob-auth awscli kubectl

  autoconf "Autocompletion for aws cli" "complete -C /usr/local/bin/aws_completer aws"
fi


if [[ $options =~ "python" ]]; then
  good "\n\n#### Installing python options"
  info "   deps: miniconda poetry"
  # Install miniconda

  if hash conda 2>/dev/null; then
    echo "... updating conda"
    conda update conda
  else
    if [[ $env = "macos" ]]; then
      binary="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    elif [[ $env = "ubuntu" ]]; then
      binary="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    else
      die "I dont know how to install python for env $env"
    fi

    echo "... downloading conda"
    # touch $tmpDir/miniconda.sh
    # vim $tmpDir/miniconda.sh
    # exit 
    # curl -sSL $binary -o $tmpDir/miniconda.sh
    # [[ -f $tmpDir/miniconda.sh ]] || { die "what"; }

    if ! curl -sSL $binary -o $tmpDir/miniconda.sh; then
      errr "... failed to download miniconda installer";
    else
      echo "... installing conda"
      if ! bash $tmpDir/miniconda.sh -b -p $HOME/.miniconda; then
        errr "Failed to install miniconda"
      fi
      # autoconf "Add conda to environment" ''
    fi
  fi


  # Install poetry
  if ! hash poetry 2>/dev/null; then
    if ! curl \
        -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py \
        -o $tmpDir/poetry.sh; then
      errr "... failed to download poetry"
    else
      echo "... installing poetry"
      if ! $tmpDir/poetry.sh; then
        errr "... failed to install poetry"
      else
        autoconf "Add poetry to PATH" 'export PATH="~/.poetry/bin:$PATH"'
        poetry completions bash > ~/.config/ /poetry.bash-completion
      fi
    fi

  else
    echo "... updating poetry"
    poetry self update
  fi
fi


good "\n\nDone"

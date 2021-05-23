#!/usr/bin/env bash


good () { echo -e "\e[32m$*\e[0m"; }
info () { echo -e "\e[34m$*\e[0m"; }
errr () { echo -e "\e[31m$*\e[0m"; }

die () { errr "${1:-""}" >&2; exit "${2:-1}"; }
usage () { die "usage: $0 -e OS [-o OPTIONS]"; }


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


tmpDir=$(mktemp -d 2>/dev/null || mktemp -d -t 'tmp')
[[ -d $tmpDir ]] || { die "Failed to create temp dir"; }
trap 'rm -rf $tmpDir' EXIT


echo "Installing for OS $env with options $options";


base16ShellTheme="base16_tomorrow-night-eighties"


autoconf () {
  touch "$HOME/.dotfiles/bash/conf/autoconfed.sh"
  if ! grep -o "'$2'" "$HOME/.dotfiles/bash/conf/autoconfed.sh"; then
    echo -e "\n# $1\n$2\n" >> "$HOME/.dotfiles/bash/conf/autoconfed.sh"
  fi
}

linkIfNotExists () {
    local target="$1"
    local linkName="$2"
    [[ -r "$linkName" ]] && return;

    ln -s "$target" "$linkName"
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



coreDeps="ack bash colordiff curl docker git jq python3 tmux tmuxinator tree vim"
# nonCoreDeps="nvm xsv"
if [[ $env = "ubuntu" ]]; then
  coreDeps="$coreDeps python-is-python3"
fi
good "\n\n#### Installing core deps"
info "  deps: $coreDeps"
if ! $install $coreDeps; then
  errr "Core install failed"
fi


# Install dotfiles
good "\n\n#### Linking dotfiles"
(
  cd "$HOME" || die "Failed to cd into \$HOME"
  rm -f ~/.bashrc && ln -s "$scriptDir/bash/bashrc" "$HOME/.bashrc";
  linkIfNotExists "$scriptDir/tmux.conf" "$HOME/.tmux.conf";
  linkIfNotExists "$scriptDir/vim" "$HOME/.vim";
  linkIfNotExists "$scriptDir/vimrc" "$HOME/.vimrc";
)

# Install mac "fixes"
if [[ $env = "macos" ]]; then
  echo -e "\n\nInstalling mac fixes"
  deps="bash-completion@2 coreutils gnu-sed"
  $install $deps

  # shellcheck disable=SC2016
  autoconf "GNU core utils to path" 'export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"'
  # shellcheck disable=SC2016
  autoconf "GNU core utils man pages" 'export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"'
  autoconf "Autcompletion for bash" '[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"'
fi


# Install and configure base16-shell
if [[ ! -d $HOME/.config/base16-shell ]]; then
  good -e "\n\n\n#### Installing base16 shell colorschemes"
  git clone https://github.com/chriskempson/base16-shell.git "$HOME/.config/base16-shell"
  eval "$("$HOME/.config/base16-shell/profile_helper.sh")"

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
    if ! curl -o "$tmpDir/miniconda.sh" -sSL "$binary"; then
      errr "... failed to download miniconda installer";
    else
      echo "... installing conda"
      if ! bash "$tmpDir/miniconda.sh" -b -p "$HOME/.miniconda"; then
        errr "Failed to install miniconda"
      fi
      # shellcheck disable=SC2116
      condaAutoConf=$(echo "\
__conda_setup=\"\$('$HOME/.miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)\"
if [ \$? -eq 0 ]; then
    eval \"\$__conda_setup\"
else
    if [ -f \"$HOME/.miniconda/etc/profile.d/conda.sh\" ]; then
        . \"$HOME/.miniconda/etc/profile.d/conda.sh\"
    else
        export PATH=\"$HOME/.miniconda/bin:\$PATH\"
    fi
fi
unset __conda_setup")
      autoconf "Add conda to path" "$condaAutoConf"
    fi
  fi
fi

  # Install poetry
if [[ $options =~ "poetry" ]]; then
  if ! hash poetry 2>/dev/null; then
    if ! curl \
        -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py \
        -o "$tmpDir/poetry.sh"; then
      errr "... failed to download poetry"
    else
      echo "... installing poetry"
      if ! "$tmpDir/poetry.sh"; then
        errr "... failed to install poetry"
      else
        # shellcheck disable=SC2016
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

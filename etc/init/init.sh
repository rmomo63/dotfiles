if has "brew"; then
  echo "$(tput setaf 2)Already installed Homebrew ✔︎$(tput sgr0)"
else
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

which brew > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Updating Homebrew..."
  brew update && brew upgrade
  [[ $? ]] && echo "$(tput setaf 2)Update Homebrew complete. ✔︎$(tput sgr0)"

  brew tap 'caskroom/cask'
  brew tap 'sanemat/font'

  local list_formulae
  local -a missing_formulae
  local -a desired_formulae=(
    'brew-cask'
    'git'
    'ruby-build'
    'rbenv'
    'nodenv'
    'pyenv'
    'tmux'
    'docker-compose'
    'tig'
    'peco'
    'awscli'
    'node'
    'zsh'
  )

  local installed=`brew list`

  # desired_formulaeで指定していて、インストールされていないものだけ入れましょ
  for index in ${!desired_formulae[*]}
  do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      echo "Installed ${formula}"
      [[ "${formula}" = "ricty" ]] && local installed_ricty=true
    fi
  done

  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )

    echo "Installing missing Homebrew formulae..."
    brew install $list_formulae

    [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
  fi

  # コマンド類の初期処理
  ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents

  local -a missing_formulae=()
  local -a desired_formulae=(
    'sublime-text'
    'google-chrome'
    'atom'
    'iterm2'
    'clipmenu'
    'the-unarchiver'
    'bettertouchtool'
    ''
  )
  # cask
  local installed=`brew cask list`

  for index in ${!desired_formulae[*]}
  do
    let formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      echo "Installed ${formula}"
    fi
  done

  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )

    echo "Installing missing Homebrew formulae..."
    brew cask install $list_formulae

    [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
  fi

  echo "Cleanup Homebrew..."
  brew cleanup
  echo "$(tput setaf 2)Cleanup Homebrew complete. ✔︎$(tput sgr0)"
fi

# Brewで入れたプログラム言語管理コマンドの初期処理
which rbenv > /dev/null 2>&1
if [ $? -eq 0 ]; then
  # 最新のRubyを入れる
  latest=`rbenv install --list | grep -v - | tail -n 1`
  current=`rbenv versions | tail -n 1 | cut -d' ' -f 2`
  if [ ${current} != ${latest} ]; then
    rbenv install ${latest}
    rbenv global ${latest}
  fi
fi

# シェルをzshにする
[ ${SHELL} != "/bin/zsh"  ] && chsh -s /bin/zsh
echo "$(tput setaf 2)Initialize complete!. ✔︎$(tput sgr0)"

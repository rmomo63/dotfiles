########################################
# 環境変数
export LANG=ja_JP.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

#色設定
if [[ $TERM = xterm ]]; then
    TERM=xterm-256color
fi

# 色を使用出来るようにする
autoload -Uz colors
colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# ?: 直前のコマンドの返り値
# 失敗したら色を赤くする

# sshで接続されている時は[REMOTE]と赤文字で表示されるようにする

if [ ${SSH_CLIENT:-undefined} = "undefined" ] && [ ${SSH_CONECTION:-undefined} = "undefined" ]; then
    REMOTE_PROMPT=""
  else
    REMOTE_PROMPT="%F{red}[REMOTE]%f "
fi

HOST_NAME="%F{250} %m %f"
CURRENT_DIR="%F{250}| %~ %f"
INPUT_ARROW="%(?,>>,%F{red}>>%f)"

# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%K{208}%F{250} * %f%k"
zstyle ':vcs_info:git:*' unstagedstr "%K{196}%F{250} + %f%k"
zstyle ':vcs_info:*' formats '%K{92}%F{250} %b %f%k%c%u'
zstyle ':vcs_info:*' actionformats '%K{92}%F{red} %b %a %f%k%c%u'

# プロンプトが表示されるたびに実行される
precmd () { vcs_info }
setopt prompt_subst

# プロンプトの表示
PROMPT='%K{240}${HOST_NAME}${REMOTE_PROMPT}${CURRENT_DIR}${vcs_info_msg_0_}%k
${INPUT_ARROW} '


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 訂正
setopt correct

# 候補ハイライト
zstyle ':completion:*:default' menu select=1

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# 履歴検索peco

# OS別の設定(peco)
case ${OSTYPE} in
    darwin*)
        # Mac
        export GOROOT=/usr/local/opt/go/libexec
        export GOPATH=$HOME
        export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    ;;
    linux*)
        # Linux
        export GOROOT=/usr/local/go
        export GOPATH=$HOME/go
        # ssh接続した時にローカルの環境変数がリモートに送信されるのでその対処
        export LC_ALL=en_US.UTF-8
        export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    ;;
esac

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history


# ls色設定
export LSCOLORS=Exfxcxdxbxegedabagacad

# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true

# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# 履歴検索
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

# エイリアス集を読み込む
source ~/.dotfiles/.zsh_alias

# 環境変数のセット
eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(pyenv init -)"
eval "$(dinghy shellinit)"

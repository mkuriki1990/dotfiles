################################
# コマンド履歴に関する設定 ここから
# 
HISTFILE=~/.histfile
HISTSIZE=10000000000000
SAVEHIST=10000000000000
# history の時刻と実行時間を追加
setopt extended_history
# history に同じ内容が連続するのを避ける
setopt HIST_IGNORE_DUPS
# 頭にスペースを入れることでコマンド履歴を残さない
setopt HIST_IGNORE_SPACE
# 
# コマンド履歴に関する設定 ここまで
################################


bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mkuriki/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit

# autoload predict-on
# predict-on

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -CF'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# alias 群の設定
alias ll='ls -l'
alias la='ls -A'
# alias ls='ls -CF'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g W='| wc'
alias -g S='| sed'
alias -g A='| awk'
alias -g W='| wc'

# 移動によって上書きするときは確認する. 
alias mv='mv -i'
alias cp='cp -i'

autoload -Uz zmv
alias zmv='noglob zmv -W'

# End of lines added by compinstall

# 入力補完の候補をカラー表示する
# zmodload zsh/complist
# export ZLS_COLORS='di=01;34'
# 名前で色を付けるようにする
autoload colors
colors

# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

################################
# zsh で特殊なキーを動作させる設定 ここから
# 

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# 
# zsh で特殊なキーを動作させる設定 ここまで
################################

################################
# ディレクトリ移動履歴を残す設定 ここから
# 

DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt LIST_PACKED

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHDMINUS

# 
# ディレクトリ移動履歴を残す設定 ここまで
################################

# 補完時に大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# scp で補完しない
setopt NO_NO_MATCH

# グロッピング
setopt EXTENDED_GLOB

# 補完システム
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

## --prefix=~/localというように「=」の後でも
## 「~」や「=コマンド」などのファイル名展開を行う。
setopt magic_equal_subst

## beep 音を消す
setopt no_beep

## 実行したプロセスの消費時間が3秒以上かかったら
## 自動的に消費時間の統計情報を表示する。
REPORTTIME=3

###################################### 
# コマンドラインスタックの vi モードにおける設定はじまり
# 

show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack
setopt NO_FLOW_CONTROL
bindkey '^Q' show_buffer_stack

# 
# コマンドラインスタックの vi モードにおける設定おわり
###################################### 

# コマンドやファイル名を訂正してくれる
setopt CORRECT
setopt CORRECT_ALL

# 日本語が使える仮想コンソールなら UTF, そうじゃなければ英語表記
case $TERM in
  linux)LANG=C ;;
  *)LANG=ja_JP.UTF-8 ;;
esac

export LC_ALL="ja_JP.UTF-8"


# ターミナルのタイトルに "ユーザ名 @ ホスト名 : カレントパス" を表示
case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac

# vi を vim に
alias vi=vim
# git を g に
alias g=git

alias ks='printf "
      人
    （＿）
 ＼（＿＿）／ ｳﾝｺｰ!
 （ ・∀・ ）
\n" 2> /dev/null '

# OS のタイプによって設定ファイルを使い分ける
case ${OSTYPE} in
	darwin*)
		# ここに Mac 向けの設定
        [ -f $CONFDIR/zshrc_darwin ] && source $CONFDIR/zshrc_darwin
		;;
	linux*)
		# ここに Linux 向けの設定
        [ -f $CONFDIR/zshrc_linux ] && source $CONFDIR/zshrc_linux
		;;
esac

# crontab -r を無効化する設定
# CRON が削除されてしまうご動作を防ぐ
# 参考 : 危険な crontab -r を封印する - Qiita
# https://qiita.com/kawaz/items/1620300551b5b3f2eccc
function crontab() {
  local opt
  for opt in "$@"; do
    if [[ $opt == -r ]]; then
      echo 'crontab -r is sealed!'
      return 1
    fi
  done
  command crontab "$@"
}
# crontab -r を無効化する設定 終わり

# 端末起動時に tmux を自動起動 / 選択するための設定
# 参考 : [tmux] 端末起動時に自動で新規セッションを作成 or 既存セッションにアタッチ - Qiita
# https://qiita.com/ssh0/items/a9956a74bff8254a606a
# if [[ ! -n $TMUX && $- == *l* ]]; then
# 	# get the IDs
# 	ID="`tmux list-sessions`"
# 	if [[ -z "$ID" ]]; then
# 		tmux new-session
# 	fi
# 	create_new_session="Create New Session"
# 	ID="$ID\n${create_new_session}:"
# 	ID="`echo $ID | $PERCOL | cut -d: -f1`"
# 	if [[ "$ID" = "${create_new_session}" ]]; then
# 		tmux new-session
# 	elif [[ -n "$ID" ]]; then
# 		tmux attach-session -t "$ID"
# 	else
# 		:  # Start terminal normally
# 	fi
# fi
# 端末起動時に tmux を自動起動 / 選択するための設定 終わり

# マシンごとの設定を読み込む. zshrc_local が存在すれば読み込むし, なければ何もしない
[ -f $CONFDIR/zshrc_local ] && source $CONFDIR/zshrc_local

#######################
# プロンプトの表示設定はじまり
# マシンごとのローカル色設定を読み込んでから設定したいので, 
# ファイル末尾に記載
# zshrc_local に
## export PROMPT_COLOR_FRONT="black"
## export PROMPT_COLOR_BACK="green"
# を設定する必要がある
#

## PROMPT内で変数展開・コマンド置換・算術演算を実行する。
setopt prompt_subst
## PROMPT内で「%」文字から始まる置換機能を有効にする。
setopt prompt_percent

### プロンプトバーの左側
###   %{%B%}...%{%b%}: 「...」を太字にする。
###   %{%F{cyan}%}...%{%f%}: 「...」をシアン色の文字にする。
###   %n: ユーザ名
###   %m: ホスト名（完全なホスト名ではなくて短いホスト名）
###   %{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%f%k%b%}:
###                           最後に実行したコマンドが正常終了していれば
###                           太字で白文字で緑背景にして異常終了していれば
###                           太字で白文字で赤背景にする。
###   %{%F{white}%}: 白文字にする。
###     %(x.true-text.false-text): xが真のときはtrue-textになり
###                                偽のときはfalse-textになる。
###       ?: 最後に実行したコマンドの終了ステータスが0のときに真になる。
###       %K{green}: 緑景色にする。
###       %K{red}: 赤景色を赤にする。
###   %?: 最後に実行したコマンドの終了ステータス
###   %{%k%}: 背景色を元に戻す。
###   %{%f%}: 文字の色を元に戻す。
###   %{%b%}: 太字を元に戻す。
###
###   ${VAR:=hoge}: シェル変数 VAR が未定義の場合 hoge を代入する.
prompt_bar_left_self="[%{%B%K{${PROMPT_COLOR_BACK:=black}}%F{${PROMPT_COLOR_FRONT:=white}}%}%n%{%b%}@%{%B%}%m%{%f%k%b%}]"
prompt_bar_left_status="(%{%B%F{black}%(?.%K{green}.%K{red})%}%?%{%k%f%b%})"
prompt_bar_left_path="[%{%B%K{${PROMPT_COLOR_BACK}}%F{${PROMPT_COLOR_FRONT}}%}%d%{%f%k%b%}]-" # カレントディレクトリのプロンプト
prompt_bar_left="-${prompt_bar_left_self}-${prompt_bar_left_path}-${prompt_bar_left_status}"

### プロンプトバーの右側
###   %D{%Y/%m/%d %H:%M}: 日付。「年/月/日 時:分」というフォーマット。
prompt_bar_date="%{%B%}%D{%Y/%m/%d %H:%M:%S}%{%b%}"

### 2行目左にでるプロンプト。
###   %h: ヒストリ数。
###   %(1j,(%j),): 実行中のジョブ数が1つ以上ある場合だけ「(%j)」を表示。
###     %j: 実行中のジョブ数。
###   %{%B%}...%{%b%}: 「...」を太字にする。
###   %#: 一般ユーザなら「%」、rootユーザなら「#」になる。
prompt_left="-[%h]%(1j,(%j),)%{%B%}%#%{%b%} "

## バージョン管理システムの情報も表示する
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats \
    '(%{%F{red}%K{green}%}%s%{%f%k%})-[%{%F{red}%K{blue}%}%b%{%f%k%}]'
zstyle ':vcs_info:*' actionformats \
    '(%{%F{red}%K{green}%}%s%{%f%k%})-[%{%F{red}%K{blue}%}%b%{%f%k%}|%{%F{white}%K{red}%}%a%{%f%k%}]'

## プロンプトを更新する。
update_prompt()
{
    # プロンプトバーと左プロンプトを設定
    #   "${bar_left}${bar_right}": プロンプトバー
    #   $'\n': 改行
    #   "${prompt_left}": 2行目左のプロンプト
    PROMPT="${prompt_bar_left}"$'\n'"${prompt_left}"
    # 右プロンプト
    #   %{%B%F{black}%K{yellow}}...%{%k%f%b%}:
    #       「...」を太字で黒背景の黄文字にする。
    #   %~: カレントディレクトリのフルパス（可能なら「~」で省略する）
    RPROMPT="[%{%B%F{black}%K{yellow}%}${prompt_bar_date}%{%k%f%b%}]"

    # バージョン管理システムの情報を取得する。
    LANG=C vcs_info >&/dev/null
    # バージョン管理システムの情報があったら右プロンプトに表示する。
    if [ -n "$vcs_info_msg_0_" ]; then
        RPROMPT="${vcs_info_msg_0_}-${RPROMPT}"
    fi
}

## コマンド実行前に呼び出されるフック。
precmd_functions=($precmd_functions update_prompt)

#
# プロンプトの表示設定おわり
#######################

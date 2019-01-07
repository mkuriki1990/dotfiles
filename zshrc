# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000000000000
SAVEHIST=10000000000000
# history の一覧を読みやすい形に変更
setopt extended_history
# history に同じ内容が連続するのを避ける
setopt HIST_IGNORE_DUPS



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


# プロンプトの表示設定
autoload colors
colors
PROMPT="%{$fg_bold[black]$bg[green]%}%n@%m:%2~%(!.#.$) %{$reset_color%}"
PROMPT2="%{$fg[green]%}%_> %{$reset_color%}"
SPROMPT="%{$fg_bold[red]$bg[white]%}correct: %R -> %r [nyae]? %{$reset_color%}"
# RPROMPT="%{$fg[white]$bg[cyan]%}[%~]%{$reset_color%}"
RPROMPT="%{$fg_bold[black]$bg[white]%}[%D %*]%{$reset_color%}"

# プロンプトをカラー表示する
# setopt prompt_subst
# PROMPT=$'%{\e[1;34m%}[%n@%m:%~ ]%{\e[0m%} '

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

# zsh で特殊なキーを動作させる設定 ここから

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

# zsh で特殊なキーを動作させる設定 ここまで


# ディレクトリ移動履歴を残す設定 ここから
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
# ディレクトリ移動履歴を残す設定 ここまで

# 補完時に大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# scp で補完しない
setopt NO_NO_MATCH

# グロッピング
setopt EXTENDED_GLOB

# 頭にスペースを入れることでコマンド履歴を残さない
setopt HIST_IGNORE_SPACE

# 補完システム
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# コマンドラインスタックの vi モードにおける設定
show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack
setopt NO_FLOW_CONTROL
bindkey '^Q' show_buffer_stack

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

# マシンごとの設定を読み込む. zshrc_local が存在すれば読み込むし, なければ何もしない
[ -f $CONFDIR/zshrc_local ] && source $CONFDIR/zshrc_local

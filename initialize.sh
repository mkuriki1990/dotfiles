#!/bin/sh
# 各設定ファイルのシンボリックリンクを作成し, 
# 必要なディレクトリをつくるためのスクリプト
# その他メモなど

ln -sf ~/.dotfiles/zshenv ~/.zshenv
ln -sf ~/.dotfiles/vimrc ~/.vimrc
ln -sf ~/.dotfiles/zshrc ~/.zshrc
ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf

mkdir -p ~/.cache/zsh
mkdir -p ~/.vim/colors/molokai
git clone https://github.com/tomasr/molokai ~/.vim/colors/molokai
ln -sf ${HOME}/.vim/colors/molokai/colors/molokai.vim ${HOME}/.vim/colors/

# 自動で設定ファイルを更新するためには以下のコマンド列を
# crontab に登録すればよい (時間は任意)
# 28 6 * * * cd ${HOME}/.dotfiles/ && git pull && ${HOME}/.dotfiles/mklink.sh

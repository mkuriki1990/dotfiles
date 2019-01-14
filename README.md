# 各種設定ファイル
自分用の設定ファイルたち. 
どうでもいいけど rc というのは, Run Commands の略らしい. 

## 含まれるファイル
* tmux.conf : tmux の設定ファイル
* vimrc : Vim の設定ファイル
* Zsh
    * zshenv : Zsh の設定ファイル (シェルスクリプト起動時に読み込み)
    * zshrc : Zsh の設定ファイル (端末ごとに読み込み)
    * zshrc_darwin : macOS 向けの Zsh の設定ファイル
    * zshrc_linux : Linux 向けの Zsh の設定ファイル
* mklink.sh : 設定ファイルのシンボリックリンクを作成するスクリプト
* README.md : このファイル

## 実際の使用にあたって
### シンボリックリンクの作成
mklink.sh を実行してホームディレクトリに設定ファイルのシンボリックリンクを作成する. 

### Vim のプラグインマネージャ NeoBundle のインストール
以下のコマンドを実行して NeoBundle をインストールしておく. 
```
curl -sf https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh -s
```
(ホントは違うプラグインマネージャに乗り換えたい...)

### zsh_local の作成
各環境毎に異なる設定を書いておくファイル
    * zshrc_local
を作成する. ローカルに必要な設定 ($PATH の指定など) があればここに記述する. 
特に各環境毎に Zsh のプロンプトの色の設定を変えたいので, 
以下のようにシェル変数を指定する. 
```
export PROMPT_COLOR_FRONT="black"
export PROMPT_COLOR_BACK="green"
```
これらの値はデフォルトでは zshrc 内に
```
PROMPT_COLOR_FRONT="white"
PROMPT_COLOR_BACK="black"
```
と設定されている. 

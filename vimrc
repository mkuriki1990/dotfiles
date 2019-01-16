set nocompatible
set laststatus=2

" spell checker
" set spell

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

syntax on
colorscheme murphy

" ファイルを開いたときに前の編集位置に戻る. 
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif

" ====================================
" 文字コードの自動認識 
" ====================================
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
		" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932','euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis.','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','.s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings.','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings.','.s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif

" 日本語を含まない場合はfileencodingにencodingを使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]",'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	set ambiwidth=double
endif

" underline of cursor
set norelativenumber number
set nocursorline
" set cursorcolumn

" コマンド補間
set wildmenu
set wildchar=<tab>

" 文字コード認識
set encoding=utf-8
set fileencodings=iso2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set fenc=utf-8

" C-a で 8 進数扱いしない
set nrformats=""

" 表示方法の設定
set list
set listchars=tab:»-,eol:↲,extends:»,precedes:«,nbsp:%
set ruler

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermbg=red guibg=#666666
au BufWinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
au WinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')

" ビープ音の停止設定 ここから
" Vim のバージョンによって場合分け
if v:version > 704
    set belloff=all
else
    set vb t_vb=
endif
" ビープ音の停止設定 ここまで

" タブ幅の設定
set shiftwidth=4
set tabstop=4
set expandtab " タブをスペースにする

" カーソル位置前後に表示する最低行数
set scrolloff=7

" for tree looks of Explore
let g:netrw_liststyle=3

" オートタブ
set autoindent

" ステータスバー関係
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

"左右のカーソル移動で行間移動可能にする. 
set whichwrap=b,s,h,l,<,>,[,]

" 折り返された行も表示行単位で移動可能にする. 
" nnoremap j gj
" nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

set backspace=indent,eol,start

" システムのクリップボードにもヤンク
set clipboard=unnamed,autoselect

" yank の繰り返しを防ごう！
vnoremap <silent> <C-p> "0p<CR>"

" Lilypond のため
filetype off
set runtimepath+=/usr/share/lilypond/2.14.2/vim/
filetype on

" 
" vim-latex Settings!
" 
filetype plugin on
filetype indent on
set shellslash
set grepprg=grep\ -nH\ $*
runtime macros/matchit.vimr

" コンパイル時に使用するコマンド
" let g:Tex_CompileRule_dvi = '/usr/texbin/platex --interaction=nonstopmode $*'
let g:Tex_CompileRule_dvi = '/Library/TeX/texbin/platex --interaction=nonstopmode $*'
let g:Tex_BibtexFlavor = 'jbibtex'
let g:Tex_CompileRule_pdf = '/usr/texbin/dvipdfmx $*.dvi'

" ファイルのビューワー
let g:Tex_ViewRule_dvi = '/usr/texbin/xdvi'
let g:Tex_ViewRule_pdf = '/usr/bin/open'
" 
" vim-latex Settings!
" end

" 
" Neobundle Settings!
" 
" bundle で管理するディレクトリ
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" neobundle 自体を neobundle で管理
NeoBundleFetch 'Shougo/neobundle.vim'

" 追加プラグインを入れていく !

" for use reclusive yank
NeoBundle 'YankRing.vim'

" undo履歴を表示する。? でヘルプを表示
" undotree.vim
NeoBundle 'mbbill/undotree'
" http://vimblog.com/blog/2012/09/02/undotree-dot-vim-display-your-undo-history-in-a-graph/
" https://github.com/r1chelt/dotfiles/blob/master/.vimrc
nmap <Leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 'topleft'
let g:undotree_SplitWidth = 35
let g:undotree_diffAutoOpen = 1
let g:undotree_diffpanelHeight = 25
let g:undotree_RelativeTimestamp = 1
let g:undotree_TreeNodeShape = '*'
let g:undotree_HighlightChangedText = 1
let g:undotree_HighlightSyntax = "UnderLined""

" vim-latexプラグイン
" ここから

" 北大のクソネットワークでは git 経由の clone ができない
" 仕方がないので https: 的な書き方をする. 
NeoBundle 'https://github.com/jcf/vim-latex'
" プラグインを使うようにする
filetype plugin on
" おまじない
set shellslash
set grepprg=grep\ -nH\ $*
" .texファイルのコンパイルプログラムを指定(エラーで停止しないようオプション指定)
let g:Tex_CompileRule_dvi = '/library/TeX/texbin/platex --interaction=nonstopmode $*'
" .bibファイルのコンパイルプログラムを指定
let g:Tex_BibtexFlavor = 'jbibtex'
" .dviファイルのビュープログラムを指定
let g:Tex_ViewRule_dvi = 'xdvi'
" pdfファイル生成のための依存関係を記述。
" 以下の設定の場合、ターゲットにpdfを指定して\llでコンパイルすると、
" まず.dviファイルが作られ、次にそれをもとに.pdfファイルが作られる
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_FormatDependency_pdf = 'dvi,pdf'
" .dviファイルのコンパイルプログラムを指定
let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
" .pdfファイルのビュープログラムを指定
let g:Tex_ViewRule_pdf = '/usr/bin/open'
let g:Tex_AutoFolding = 0
"let g:Tex_IgnoredWarnings = '~~'
"let g:Tex_IgnoreLevel = ~~

" filetype [PLAINTEX > TEX]
let g:tex_flavor='latex'

" vim-latex プラグイン
" ここまで

" 括弧を勝手に閉じてくれる
" NeoBundle 'Townk/vim-autoclose'

" neoComplete プラグイン
" ここから
" if_luaが有効ならneocompleteを使う
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

if neobundle#is_installed('neocomplete')
	" neocomplete用設定
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_ignore_case = 1
	let g:neocomplete#enable_smart_case = 1
	if !exists('g:neocomplete#keyword_patterns')
		let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns._ = '\h\w*'
elseif neobundle#is_installed('neocomplcache')
	" neocomplcache用設定
	let g:neocomplcache_enable_at_startup = 1
	let g:neocomplcache_enable_ignore_case = 1
	let g:neocomplcache_enable_smart_case = 1
	if !exists('g:neocomplcache_keyword_patterns')
		let g:neocomplcache_keyword_patterns = {}
	endif
	let g:neocomplcache_keyword_patterns._ = '\h\w*'
	let g:neocomplcache_enable_camel_case_completion = 1
	let g:neocomplcache_enable_underbar_completion = 1
endif
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" neoComplete プラグイン
" ここまで

" インデントに色をつけて見やすくする. 
NeoBundle 'nathanaelkane/vim-indent-guides'

" vim 起動時に自動的に vim-indent-guides をオンにする
let g:indent_guides_enable_on_vim_startup = 1


call neobundle#end()

" Required:
filetype plugin indent on

" 未インストールのプラグインがある場合に, 確認されるかどうか
NeoBundleCheck


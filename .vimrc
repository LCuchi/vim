" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
" Last Change: 24-Jul-2015.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 0 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for path in split(glob($VIM.'/plugins/*'), '\n')
  if isdirectory(path) | let &runtimepath = &runtimepath.','.path | end
endfor

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
" source $VIM/plugins/kaoriya/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif


"----------------------------------------------------
" neobundle.vim
" 2013-06-18
"----------------------------------------------------
set nocompatible
filetype plugin indent off

" neobundle.vim: Ultimate Vim package manager
if has('vim_starting')
  set runtimepath+=~/dotfiles/vimfiles/bundle/neobundle.vim/
  call neobundle#begin(expand('~/dotfiles/vimfiles/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplete.vim'    " Ultimate auto-completion system for Vim.
NeoBundle 'Shougo/unite.vim'            " Unite and create user interfaces
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimproc.vim'          " Interactive command execution in Vim.
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'Shougo/unite-outline'        " outline source for unite.vim (fork)
NeoBundle 'tsukkee/unite-help'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'tacroe/unite-mark'
"NeoBundle 'violetyk/cake.vim'
NeoBundle 'tpope/vim-surround'          " surround.vim: quoting/parenthesizing made simple
"NeoBundle 'vimplugin/project.vim'       " Organize/Navigate projects of files (like IDE/buffer explorer) 
NeoBundle 'taglist.vim'
NeoBundle 'ZenCoding.vim'

" vim-ref: Integrated reference viewer.
NeoBundle 'thinca/vim-ref'
NeoBundle 'mojako/ref-sources.vim'
NeoBundle 'mustardamus/jqapi'
NeoBundle 'tokuhirom/jsref'
let g:ref_jquery_doc_path = '~/dotfiles/vimfiles/bundle/jqapi'
let g:ref_javascript_doc_path = '~/dotfiles/vimfiles/bundle/jsref/htdocs'

NeoBundle 'The-NERD-tree'
NeoBundle 'The-NERD-Commenter'
"NeoBundle 'TwitVim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'dbext.vim'
"NeoBundle 'rails.vim'
NeoBundle 'Gist.vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/unite-advent_calendar'
NeoBundle 'open-browser.vim'
NeoBundle 'ctrlp.vim'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'einars/js-beautify'
NeoBundle 'maksimr/vim-jsbeautify'
NeoBundle 'tpope/vim-fugitive.vim'
NeoBundle 'rhysd/committia.vim'
NeoBundle 'itchyny/lightline.vim'
" molokai カラースキーム
NeoBundle 'tomasr/molokai'

  call neobundle#end()
endif

filetype plugin indent on


"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=2
" シフト移動幅
set shiftwidth=2
" 行頭の余白内でTabを打ち込むと、'shiftwidth'の数だけインデントする
set smarttab
" タブをスペースに展開する (noexpandtab:展開しない)
set expandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" 括弧入力時に対応する括弧を表示する時間（0.1sec単位）
set matchtime=1
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 自動改行しない
set textwidth=0

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を表示する (nonumber:表示しない)
set number
" ルーラーを表示する (noruler:表示しない)
set ruler
" タブや改行を表示しない (list:表示する)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 一行の文字数が多くてもきちんと描画されるようになる
set display=lastline
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set notitle
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)
" カーソル行をハイライト表示
set nocursorline

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup
" swapファイルを作成しない
set noswapfile
" undoファイルを作成しない (Vim7.4.227以降)
set noundofile


"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let uname = system('uname')
  if uname =~? "linux"
    set term=builtin_linux
  elseif uname =~? "freebsd"
    set term=builtin_cons25
  elseif uname =~? "Darwin"
    "set term=beos-ansi
    set term=builtin_xterm
  else
    set term=builtin_xterm
  endif
  unlet uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
"if kaoriya#switch#enabled('disable-vimdoc-ja')
"  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "vimdoc-ja"'), ',')
"endif

" Copyright (C) 2011 KaoriYa/MURAOKA Taro

"---------------------------------------------------------------------------
" 補完（NeoComplete） 
let g:neocomplete#enable_at_startup = 1 "起動時に有効にする
set pumheight=10 "補完メニューの高さ

"---------------------------------------------------------------------------
" 構文チェック（Syntastic） 
let g:syntastic_check_on_open = 0 "ファイルを開いたときにチェック
let g:syntastic_check_on_save = 1 "保存時にチェック
let g:syntastic_auto_loc_list = 0 "エラーがあったら自動でロケーションリストを開く
let g:syntastic_loc_list_height = 6 "エラー表示ウィンドウの高さ
"set statusline+=%#warningmsg# "エラーメッセージの書式
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_javascript_checkers = ['jshint'] "jshintを使う
let g:syntastic_mode_map = {
      \ 'mode': 'active',
      \ 'active_filetypes': ['ruby', 'javascript'],
      \ 'passive_filetypes': ['html']
      \ }
"エラー表示マークを変更
"let g:syntastic_enable_signs=1
"let g:syntastic_error_symbol='✗'
"let g:syntastic_warning_symbol='⚠'

"---------------------------------------------------------------------------
" .vimrc を編集する
nnoremap  <silent><Space>.   :<C-u>tabedit $MYVIMRC<CR>

" vim-jsbeautify
nnoremap  [jsbeautify]   <Nop>
nmap      <Space>f  [jsbeautify]
autocmd FileType javascript nnoremap <buffer>  [jsbeautify] :<C-u>call JsBeautify()<CR>
autocmd FileType javascript vnoremap <buffer>  [jsbeautify] :<C-u>call RangeJsBeautify()<CR>
autocmd FileType html nnoremap <buffer> [jsbeautify] :<C-u>call HtmlBeautify()<CR>
autocmd FileType html vnoremap <buffer> [jsbeautify] :<C-u>call RangeHtmlBeautify()<CR>
autocmd FileType css nnoremap <buffer> [jsbeautify] :<C-u>call CSSBeautify()<CR>
autocmd FileType css vnoremap <buffer> [jsbeautify] :<C-u>call RangeCSSBeautify()<CR>

" Unite.vim を起動する
nnoremap  [unite]   <Nop>
nmap      <Space>u  [unite]
nnoremap  <silent> [unite]s   :<C-u>Unite source<CR>
nnoremap  <silent> [unite]f   :<C-u>Unite file<CR>
nnoremap  <silent> [unite]r   :<C-u>Unite file_mru<CR>
nnoremap  <silent> [unite]b   :<C-u>Unite buffer<CR>
nnoremap  <silent> [unite]t   :<C-u>Unite tab<CR>

" 構文チェック（Syntastic）を起動する
nnoremap  [syntastic]   <Nop>
nmap      <Space>s  [syntastic]
nnoremap  <silent> [syntastic]c   :<C-u>SyntasticCheck<CR>
nnoremap  <silent> [syntastic]e   :<C-u>Errors<CR>

" 括弧の中にカーソルを移動する
imap {} {}<Left>
imap [] []<Left>
imap () ()<Left>
imap "" ""<Left>
imap '' ''<Left>
imap <> <><Left>
"imap // //<left>

" 行末までをヤンク
nnoremap  Y y$

"---------------------------------------------------------------------------
" 2014-11-08
" 自動的にコメント文字列が挿入されるのをやめる
" http://d.hatena.ne.jp/hyuki/20140122/vim
" https://gist.github.com/rbtnn/8540338 （一部修正）
augroup auto_comment_off
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=r
  autocmd BufEnter * setlocal formatoptions-=o
augroup END


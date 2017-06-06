scriptencoding utf-8

let s:is_windows = has('win32') || has('win64')

function! IsWindows() abort
  return s:is_windows
endfunction

function! IsMac() abort
  return !s:is_windows && !has('win32unix')
        \ && (has('mac') || has('macunix') || has('gui_macvim')
        \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))
endfunction

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if has('vim_starting') && &encoding !=# 'utf-8'
  if IsWindows() && !has('gui_running')
    set encoding=cp932
  else
    set encoding=utf-8
  endif
endif

" Build encodings.
let &fileencodings = join([
      \ 'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932'])

" Setting of terminal encoding.
if !has('gui_running') && IsWindows()
  " For system.
  set termencoding=cp932
endif

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif

if !&compatible
  set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein settings {{{
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml = fnamemodify(expand('<sfile>'), ':h').'/.dein.toml'
let s:lazy_toml = fnamemodify(expand('<sfile>'), ':h').'/.deinlazy.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}


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
if 1 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

if IsWindows()
  " plugins下のディレクトリをruntimepathへ追加する。
  for s:path in split(glob($VIM.'/plugins/*'), '\n')
    if s:path !~# '\~$' && isdirectory(s:path)
      let &runtimepath = &runtimepath.','.s:path
    end
  endfor
  unlet s:path
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
" タブをスペースに展開しない (expandtab:展開する)
"set noexpandtab
set expandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" undoファイルを作成しない
set noundofile

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を表示
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示
set list
" どの文字でタブや改行を表示するかを設定
set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返さない
set nowrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)
" undoファイルを生成しない
set noundofile

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup


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
  let s:uname = system('uname')
  if s:uname =~? "linux"
    set term=builtin_linux
  elseif s:uname =~? "freebsd"
    set term=builtin_cons25
  elseif s:uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet s:uname
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

if IsWindows()
  " KaoriYaでバンドルしているプラグインのための設定

  " autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
  "set formatexpr=autofmt#japanese#formatexpr()

  " vimdoc-ja: 日本語ヘルプを無効化する.
  if kaoriya#switch#enabled('disable-vimdoc-ja')
    let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimdoc-ja"'), ',')
  endif

  " vimproc: 同梱のvimprocを無効化する
  if kaoriya#switch#enabled('disable-vimproc')
    let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimproc$"'), ',')
  endif
endif


"---------------------------------------------------------------------------
"標準設定

" ビープ音を無効
set t_vb=
set novisualbell
set belloff=all
" swapを作成しない
set noswapfile
" vモードの置換連続ペースト用
function! Put_text_without_override_register()
  let line_len = strlen(getline('.'))
  execute "normal! `>"
  let col_loc = col('.')
  execute 'normal! gv"_x'
  if line_len == col_loc
    execute 'normal! p'
  else 
    execute 'normal! P'
  endif
endfunction
xnoremap <silent> p :call Put_text_without_override_register()<CR>
set clipboard=unnamed "ヤンクした時に自動でクリップボードにコピー(autoselectを指定するとvモードの置換連続ペーストができない)
" 起動時に最大化
au GUIEnter * simalt ~x

" ヘルプを日本語優先に
set helplang=ja
"---------------------------------------------------------------------------
" 編集関係
set tabstop=2 " 画面上でタブ文字が占める幅
set shiftwidth=2 " 自動インデントでずれる幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
" txtの折り返しを無効化
autocmd FileType text setlocal textwidth=0
" 不可視文字の可視化
set lcs=tab:>.,trail:_,extends:\

" 全角スペースのハイライト(文字コードの関係で動かない)
highlight JpSpace cterm=underline ctermfg=Blue guifg=Blue
au BufRead,BufNew * match JpSpace /　/
"---------------------------------------------------------------------------
" Fortran設定
let fortran_free_source=1
let fortran_more_precise=1

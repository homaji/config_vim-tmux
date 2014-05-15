""NeoBundle
set nocompatible
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
	\'build' : {
	\	'mac' : 'make -f make_mac.mak',
	\	'windows' : 'make -f make_mingw32.mak',
	\	'cygwin' : 'make -f make_cygwin.mak',
	\	'unix' : 'make -f make_unix.mak'
	\	},
	\}
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'deton/jasegment.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'basyura/jslint.vim'
NeoBundle 'JavaScript-Indent'
NeoBundle 'smartchr'
NeoBundle 'vim-scripts/spec.vim'
NeoBundle 'vim-scripts/project.tar.gz'
filetype plugin on 
filetype indent on "Required!


"""Basic Config"""
set backup
set backupdir=$HOME/.vimtemp
set directory=$HOME/.vimtemp
"Use Clipboard"
set clipboard=unnamed,autoselect

""AutoChangeDirectory
au BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))


"""Key Config"""
"macvimではoption+\がleaderになるので変更
let g:mapleader = ','
"map \ <leader>

""Edit .vimrc""
"http://whileimautomaton.net/2008/08/vimworkshop3-kana-presentation
nnoremap <Space>. :<C-u>tabedit $MYVIMRC<CR>
""Reload .vimrc""
nnoremap <Space>s. :<C-u>source $MYVIMRC<CR>

"runtimepath
if isdirectory($HOME . '.vim')
  let $MY_VIMRUNTIME = $HOME.'.vim'
elseif isdirectory($HOME . 'vimfiles')
  let $MY_VIMRUNTIME = $HOME.'vimfiles'
elseif isdirectory($VIM . 'vimfiles')
  let $MY_VIMRUNTIME = $VIM.'vimfiles'
endif
""StatusLine""
""set laststatus=2
""set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

""Encoding""
scriptencoding utf-8
set encoding=utf-8
"""Plugin Configrations"""

""Changelog""
let g:changelog_username = "homaji"
let g:changelog_timeformat = "%Y-%m-%d"
runtime vimfiles/ftplugin/changelog.vim

""Spec""
"http://nanasi.jp/articles/vim/spec_vim.html
let spec_chglog_format = "%c homaji"
au BufNewFile,BufRead *.changelog setf spec

""Clever-f"
"大文字を入力したときだけ、大文字小文字を区別
let g:clever_f_smart_case = 1
"migemoっぽい検索
let g:clever_f_use_migemo = 1

""Vim-Over""
"Highlight subsutitute"
let g:over_enable_cmd_window = 1

""quickrun.vim""
" 新しいウィンドウを下に開く
set splitbelow

""vimfiler""
"set default explor open in :e .
let g:vimfiler_as_default_explorer = 1

""Project.vim""
".projectvimがそのフォルダにあれば自動で読み込み
"Vimテクニックバイブルより
if getcwd() != $HOME
	if filereadable(getcwd(). '/.vimprojects')
		Project .vimprojects
	endif
endif
"Projectをトグルで開閉
:nmap <silent> <Leader>p <Plug>ToggleProject


""smartchr""
inoremap <expr> = smartchr#loop(' = ', ' == ')

""lightline""
let g:lightline = { 
		\'colorscheme': 'wombat'
		\,
		\'active': {
		\  'left':[ ['mode', 'paste'], ['readonly','modified'],['filename'] ],
		\  'right':[ ['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype'] ],
		\},
		\'component_function': {
		\    'mode': 'Mymode',
		\ },
 		\ 'separator': { 'left': "\u2b80", 'right': "\u2b82" }, 
		\ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
		\}
function! Mymode()
	return  &ft == 'unite' ? 'Unite' :
	      \ &ft == 'vimfiler' ? 'VimFiler' :
	      \ &ft == 'vimshell' ? 'VimShell' :
	      \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction
function! MyFilename()
	return  ' ' ! = expand('%:F') ? expand('%:F') : '[No Name]'
endfunction
	


""Scouter
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)


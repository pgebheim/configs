""""""""""""""""""""
" functions
"
function! ToggleRelativeNumber()
  if &rnu == 1
    set number
  else
    set relativenumber
  endif
endfunction
""""""""""""""""""""

if has('vim_starting')
  set nocompatible               " Be iMproved
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" https://github.com/Shougo/neobundle.vim
"  " Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'ervandew/supertab'
NeoBundle 'altercation/vim-colors-solarized.git'
NeoBundle 'gregsexton/gitv.git'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'tpope/vim-characterize'
NeoBundle 'bling/vim-airline'
NeoBundle 'kchmck/vim-coffee-script.git'
NeoBundle 'jamessan/vim-gnupg'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'jason0x43/vim-js-indent'
NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
NeoBundle 'junegunn/fzf.vim'
NeoBundle 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql'] }

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \    },
      \ }

NeoBundle 'Quramy/tsuquyomi'

call neobundle#end()
NeoBundleCheck

" =================== Plugin Config ================
let do_syntax_sel_menu = 1 " Show the languages in the syntax menu by default

" =================== General Config ================
set mouse=a
set nowrap
set go=grtbLmet "no toolbar/menu gmrbLetT for menu
set smartcase
set smartindent
set smarttab
set lazyredraw
set autoindent
set expandtab
set shiftwidth=2
set tabstop=2
set number
set ruler
set sta
set ls=2                       " show a status line even when only one window is shown
set backspace=indent,eol,start whichwrap+=<,>,[,] " Lets make backspace work right!
set splitbelow splitright
set noswapfile
set nobackup

set wildmenu
set wildignore+=*.o,*.obj,.git,*.swp,*.pyc
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Spelling ========================
set spelllang=en
set spellfile=$HOME/.vim/spellfile.en.add

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" My color scheme

if has("gui_running")
  set background=dark
  colors solarized
  let g:airline_theme='solarized'
" test for term colors and set colorscheme based on that
" 7;0 == default black background in iTerm2
elseif ($COLORFGBG) == "7;0"        " black background
  colorscheme desert
  let g:airline_theme='light'
elseif ($COLORFGBG) == "0;15"   " light background
  colorscheme neverland
  let g:airline_theme='dark'
elseif ($COLORFGBG) == "11;15"  " solarized theme
  colorscheme solarized
  let g:airline_theme='solarized'
elseif ($COLORFGBG) == "12;8"  " solarized theme
  colorscheme solarized
  let g:airline_theme='solarized'
else
    colorscheme torte
endif




" Keep the cursor at the pre-editing positing when using .
" http://vim.wikia.com/wiki/VimTip1142
nmap . .`[

map <Leader>n :call ToggleRelativeNumber()<cr>
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
inoremap <S-Tab> <ESC><<i
nnoremap j gj
nnoremap k gk
nnoremap K i<CR><Esc>
inoremap <C-s> <Esc>

runtime macros/matchit.vim
" filetype settings
filetype plugin indent on

syntax on

augroup cursors
  au InsertEnter * set cursorline
  au InsertLeave * set nocursorline
augroup END

" Make SuperTab use OmniCompletion by default for programming languages that
" we know about

augroup filetypes
  autocmd!

  au BufRead,BufNewFile *.vhost set ft=nginx
  au FileType vim set sw=2 ts=2
  au FileType erlang,ruby,rb,javascript,html,django,coffee set sw=2 ts=2
  au FileType python,actionscript set sw=4 ts=4
  au FileType stylus,css,jade set sw=2 sw=2
  au FileType htmldjango set filetype=html
  au Filetype gitcommit set spell textwidth=72

  " Clojure
  au FileType clj let vimclojure#NailgunClient = "~/.vim/vimclojure/ng"
  au FileType clj let g:clj_want_gorilla = 1
  au FileType clj let g:clj_rainbow_paren = 1
  au FileType clj let g:clj_highlight_builtins = 1
  au FileType clj let g:clj_highlight_contrib = 1

  au FileType fear inoremap <buffer> <CR> <CR>I have fear that
augroup END

let python_highlight_all=1

if version >= 703
  set undodir=~/.vim/backups
  set undofile
endif


" Syntax Dependent Folding for C/C++/Java/(C#)
set nofoldenable
augroup folding
  au filetype stylus,jade set fdm=indent
  au filetype c,cpp set fdm=marker
augroup END

set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
set title

" Searching
set incsearch scs hls
"After a search hit CTRL-CR to remove hls
nnoremap <c-cr> :noh<CR>
nnoremap <leader><space> :noh<CR>
nnoremap <leader><leader> :noh<CR>

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif


let $FZF_DEFAULT_COMMAND= 'ag -g ""'
nnoremap <silent> <Leader>b :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>
nnoremap <leader>t :FZF<CR>
nnoremap <leader>s :Tags<CR>
nnoremap <leader>cs :BTags<CR>

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
set tags=./tags;
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'
imap <c-x><c-f> <plug>(fzf-complete-path)

" yank and paste from system buffer
noremap <leader>p "+p
noremap <leader>y "+y

"search options for visual mode (* searches for highlighted text, # backwards)
vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" Format the statusline
set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
set statusline+=%{fugitive#statusline()}     " git status
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset


let g:airline#extensions#tabline#enabled = 1

if has("autocmd")
  augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source %
  augroup END
endif

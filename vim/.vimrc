""""""""""""""""""""
" functions
"
function! ToggleRelativeNumber()
  if &rnu == 1
    set number
    set relativenumber!
  else
    set relativenumber
  endif
endfunction
""""""""""""""""""""

"set cpoptions=ces$

if has('vim_starting')
  set nocompatible               " Be iMproved
endif

call plug#begin('~/.vim/plugged')

Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
Plug 'ervandew/supertab'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'tpope/vim-characterize'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jamessan/vim-gnupg'
Plug 'digitaltoad/vim-jade'
Plug 'janko-m/vim-test'
Plug 'mileszs/ack.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'pangloss/vim-javascript'
Plug 'jason0x43/vim-js-indent'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql'] }

Plug 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \    },
      \ }

if has("nvim")
  Plug 'radenling/vim-dispatch-neovim'
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
  let $NVIM_NODE_LOG_FILE='/tmp/nvim-node.log'
  let $NVIM_NODE_LOG_LEVEL='info'
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif


" Enable deoplete at startup
let g:deoplete#enable_at_startup = 1

call plug#end()

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

if has('nvim')
  tmap <C-o> <C-\><C-n>
end


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
  function! SetClojureOptions()
    let vimclojure#NailgunClient = "~/.vim/vimclojure/ng"
    let g:clj_want_gorilla = 1
    let g:clj_rainbow_paren = 1
    let g:clj_highlight_builtins = 1
    let g:clj_highlight_contrib = 1
  endfunction
  au FileType clj call SetClojureOptions()

  au FileType fear inoremap <buffer> <CR> <CR>I have fear that


  function! SetEMCAOptions()
    nmap <buffer> <Leader>e <Plug>(TSRename)
    set makeprg=npm\ run\ build
  endfunction
  au FileType typescript,javascript call SetEMCAOptions()

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
  let $FZF_DEFAULT_COMMAND= 'ag -g ""'
endif


nnoremap <silent> <Leader>b :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>
nnoremap <leader>t :FZF<CR>
nnoremap <leader>s :Tags<CR>
nnoremap <leader>cs :BTags<CR>
nnoremap <leader>fg :GGrep 
nnoremap <leader>fa :Ack 

let test#strategy = "neovim"
let g:test#javascript#jest#file_pattern = '\v(__tests__|spec|test)/.*\.(js|jsx|coffee|ts|tsx)$'
nnoremap <Leader>af :TestFile<CR>
nnoremap <Leader>an :TestNearest<CR>
nnoremap <Leader>al :TestLast<CR>
nnoremap <Leader>as :TestSuite<CR>
nnoremap <Leader>av :TestVisit<CR>

nnoremap <Leader>m :Make<CR>

au filetype typescript,javascript nnoremap <leader>fs :TSSearchFZF 

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

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

if has("nvim")
  set inccommand=nosplit
endif

" yank and paste from system buffer
noremap <leader>p "+p
noremap <leader>y "+y

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

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
let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_selectionUI = "fzf"
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ }

nnoremap <silent> <leader>k LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

if has("autocmd")
  augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source %
  augroup END
endif


" TABSSSS
" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>


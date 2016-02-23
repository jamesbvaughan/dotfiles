" James Vaughan's vimrc =========================================
set nocompatible              " be iMproved, required
filetype off                  " required

" Plugins =======================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'				" Vundle

" Plugins that I like
Plugin 'kien/ctrlp.vim'						" CtrlP
Plugin 'scrooloose/syntastic'			" Syntastic
Plugin 'myint/syntastic-extras'		" Syntastic Extras
Plugin 'tpope/vim-commentary'			" Vim Commentary
Plugin 'bling/vim-airline'				" Vim Airline
Plugin 'chriskempson/base16-vim'	" Base16 Theme
Plugin 'tpope/vim-fugitive'				" Vim Fugitive
Plugin 'Valloric/YouCompleteMe'		" YouCompleteMe

" Language Syntax Support
Plugin 'pangloss/vim-javascript'	" Javascript
Plugin 'mxw/vim-jsx'							" JSX
Plugin 'othree/html5.vim'					" HTML5
Plugin 'tpope/vim-markdown'				" Markdown
Plugin 'groenewege/vim-less'			" Less
Plugin 'hail2u/vim-css3-syntax'		" CSS3
call vundle#end()            " required
filetype plugin indent on    " required


" My Settings ===================================================

set scrolloff=5					" start scrolling before bottom of pane
set hidden							" allow background buffers
set shell=bash\ --norc	" set bash as default vim shell

set hlsearch						" highlight search terms as I search
set incsearch						" incremental search

set nu									" show line numbers
set rnu									" show relative line numbers

set background=dark			" set theme
colorscheme ron					" set colorscheme

" change tab length
set tabstop=2
set shiftwidth=2

" no backup files
set nobackup
set noswapfile


" My Keybindings ================================================

" set leader to space
:let mapleader=" "

set pastetoggle=<F2>		" set F2 to paste toggle

" toggle line numbers
nnoremap <F3> :set nonumber !<CR>

" toggle relative line numbers in normal mode
nnoremap <C-n> :set rnu!<cr>

" use ; for commands
map ; :

" set C-v and C-b to open new panes
map <C-v> :sp <CR>
map <C-b> :vsp <CR>

" set Shift-h and Shift-l to move between open buffers
map <S-h> :bp <CR>
map <S-l> :bn <CR>

" set better pane navigation shortcuts
map <C-h> :wincmd h <CR>
map <C-j> :wincmd j <CR>
map <C-k> :wincmd k <CR>
map <C-l> :wincmd l <CR>

" open up Explore with space-k
map <leader>k :Explore<cr>

" clear search highlights
map <leader>o :noh<cr>

" toggle word wrap
map <leader>w :set wrap !<cr>

" toggle spelling mistake highlighting
map <F5> :setlocal spell! spelllang=en_us <CR>


" Plugin Settings ===============================================

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler_options = '-std=c++0x'
let g:syntastic_javascript_checkers = ['jsxhint']

" YouCompleteMe
let g:ycm_confirm_extra_conf = 1

" Airline
set laststatus=2
let g:airline_theme = 'bubblegum'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" CtrlP
let g:ctrlp_custom_ignore = 'node_modules'

" JSX
let g:jsx_ext_required = 0

" Explore
let g:netrw_liststyle=3


" Other =========================================================

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Only rln in normal mode
  autocmd InsertEnter * :set rnu!
  autocmd InsertLeave * :set rnu

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif

" auto reload .vimrc on save
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

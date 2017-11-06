" James Vaughan's vimrc ========================================================
set nocompatible
filetype plugin on

" Download vim-plug if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Plugins ======================================================================
call plug#begin('~/.vim/plugged')
  Plug 'altercation/vim-colors-solarized'
  Plug 'elixir-lang/vim-elixir'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'mxw/vim-jsx'
  Plug 'ryanoasis/vim-devicons'
  Plug 'pangloss/vim-javascript'
  Plug 'slashmili/alchemist.vim'
  Plug 'ternjs/tern_for_vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'w0rp/ale'
  Plug 'Valloric/YouCompleteMe'
call plug#end()

" My Settings ==================================================================
color solarized           " set colorscheme
set background=dark       " use a dark background
set colorcolumn=80        " highlight max length column
set encoding=utf-8        " set encoding
set autoread              " auto read files changed outside vim
" set clipboard=unnamedplus " use the system clipboard
set hidden                " allow background buffers
set hlsearch              " highlight the search query
set ignorecase            " case insensitive searching
set smartcase             " only use case sensitive search when uppercase
set laststatus=2          " always show airline
set mouse=a               " enable the mouse
set nobackup              " no backup files
set noswapfile            " no swap files
set number                " show line numbers
set relativenumber        " show relative line numbers
set scrolloff=5           " start scrolling 5 lines before bottom of pane
set scrolljump=1          " scroll 1 line at a time
set expandtab             " tabs to spaces
set tabstop=2             " change default tab length
set shiftwidth=2          " shift lines by 2 characters
let g:filetype_pl="prolog"

" Airline
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#ale#enabled = 1
let g:airline_left_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_right_sep = ''
let g:airline_section_y = ''
let g:airline_theme = 'solarized'

" YCM
let g:ycm_autoclose_preview_window_after_completion = 1

" FZF
map <C-p> :Files<cr>

" Ale
let g:ale_lint_on_text_changed = 'never'

" My Keybindings ===============================================================
map ; :
let mapleader=" "
map <leader>o :nohlsearch<cr>|                      " clear search highlights
map <leader>w :set wrap!<cr>|                       " toggle word wrap
map <leader>s :setlocal spell! spelllang=en_us<cr>| " toggle spell checking
map <leader>a :sort<cr>|                            " sort lines
map <leader>r :source ~/.vimrc<cr>|                     " reload vimrc
map <S-h>     :bprevious<cr>|                              " previous buffer
map <S-l>     :bnext<cr>|                              " next buffer
map <C-h>     :wincmd h<cr>|                        " window left
map <C-j>     :wincmd j<cr>|                        " window below
map <C-k>     :wincmd k<cr>|                        " window above
map <C-l>     :wincmd l<cr>|                        " window right
map <C-w>     :bprevious\|bdelete #<CR>|            " close the current buffer

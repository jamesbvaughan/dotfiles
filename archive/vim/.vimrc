" James' vim config
set nocompatible

" Load extra config
if filereadable(expand('~/.vimrc.extra'))
  source ~/.vimrc.extra
endif

" My Settings ==================================================================
syntax on
set autoindent
set autoread              " auto read files changed outside vim
set breakindent           " indent line wraps
set clipboard=unnamedplus " use the system clipboard
set expandtab             " tabs to spaces
set hidden                " allow background buffers
set hlsearch              " highlight the search query
set ignorecase            " case insensitive searching
set laststatus=2          " always show airline
set lazyredraw            " don't redraw during macro execution
set linebreak             " break on word boundaries
set mouse=a               " enable the mouse
set nobackup              " no backup files
set noswapfile            " no swap files
set number                " show line numbers
set scrolljump=1          " scroll 1 line at a time
set scrolloff=5           " start scrolling 5 lines before bottom of pane
set shiftwidth=2          " shift lines by 2 characters
set smartcase             " only use case sensitive search when uppercase
set tabstop=2             " change default tab length
set updatetime=300        " lower the updatetime for shorter delays


" My Keybindings ===============================================================
nnoremap <C-h>     :wincmd h<cr>|                            " window left
nnoremap <C-j>     :wincmd j<cr>|                            " window below
nnoremap <C-k>     :wincmd k<cr>|                            " window above
nnoremap <C-l>     :wincmd l<cr>|                            " window right
nnoremap <S-h>     :bprevious<cr>|                           " previous buffer
nnoremap <S-l>     :bnext<cr>|                               " next buffer
nnoremap <leader>d :bnext\|bdelete #<CR>|                    " close the current buffer
nnoremap <leader>o :nohlsearch<cr>|                          " clear search highlights
nnoremap <leader>p :set paste!<cr>|                          " toggle paste mode
nnoremap <leader>r :source ~/.vimrc<cr>|                     " reload vimrc
nnoremap <leader>s :setlocal spell! spelllang=en_us<cr>|     " toggle spell checking
nnoremap <leader>w :set wrap!<cr>|                           " toggle word wrap
nnoremap <leader>v :e ~/.vimrc<cr>|                          " open vimrc
vnoremap <leader>a :sort<cr>|                                " sort lines

" vim: filetype=vim

" Plugins ======================================================================
call plug#begin('~/.config/nvim/plugged')
  Plug 'Valloric/YouCompleteMe'
  Plug 'dracula/vim'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'mxw/vim-jsx'
  Plug 'myint/syntastic-extras'
  Plug 'pangloss/vim-javascript'
  Plug 'rdnetto/YCM-Generator'
  Plug 'scrooloose/syntastic'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

" My Settings ==================================================================
set scrolloff=5        " start scrolling before bottom of pane
set hidden             " allow background buffers
set number             " show line numbers
set relativenumber     " show relative line numbers
color dracula          " set colorscheme
set tabstop=2          " change tab length
set shiftwidth=2
set expandtab
set colorcolumn=80     " highlight max length column
set ignorecase
set smartcase
set nobackup           " no backup files
set noswapfile

" Airline
let g:airline_theme = 'dracula'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" My Keybindings ===============================================================
" use ; for commands
map ; :

" set leader to space
let mapleader=" "

" clear search highlights
map <leader>o :noh<cr>

" set Shift-h and Shift-l to move between open buffers
map <S-h> :bp<cr>
map <S-l> :bn<cr>

" set better pane navigation shortcuts
map <C-h> :wincmd h<cr>
map <C-j> :wincmd j<cr>
map <C-k> :wincmd k<cr>
map <C-l> :wincmd l<cr>

" better navigation with wrapped lines
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" toggle spelling mistake highlighting
map <F5> :setlocal spell! spelllang=en_us<cr>

" fuzzy finder
map <C-p> :FZF<cr>

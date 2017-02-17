" James Vaughan's vimrc ========================================================
filetype plugin on
" Plugins ======================================================================
call plug#begin('~/.config/nvim/plugged')
  Plug 'ElmCast/elm-vim'
  Plug 'Shougo/deoplete.nvim'
  Plug 'carlitux/deoplete-ternjs'
  Plug 'dracula/vim'
  Plug 'eagletmt/neco-ghc'
  Plug 'elixir-lang/vim-elixir'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'mattn/emmet-vim'
  Plug 'mxw/vim-jsx'
  Plug 'neomake/neomake'
  Plug 'pangloss/vim-javascript'
  Plug 'ternjs/tern_for_vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'wlangstroth/vim-racket'
call plug#end()

" My Settings ==================================================================
color dracula          " set colorscheme
set autoread           " auto read files changed outside vim
set colorcolumn=80     " highlight max length column
set expandtab          " tabs to spaces
set fillchars=vert:\│  " change vertical split character
set hidden             " allow background buffers
set ignorecase         " case insensitive searching
set nobackup           " no backup files
set noswapfile         " no swap files
set number             " show line numbers
set relativenumber     " show relative line numbers
set scrolloff=5        " start scrolling before bottom of pane
set shiftwidth=2       " shift width 2
set smartcase          " only use case sensitive search when uppercase
set tabstop=2          " change tab length
let g:filetype_pl="prolog"

" Airline
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_left_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_right_sep = ''
let g:airline_section_y = ''
let g:airline_theme = 'dracula'

" Neomake
autocmd BufWritePost * Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_cpp_enabled_makers = ['gcc']
let g:neomake_open_list = 0

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.elm = '[^ ,;\t\[()\]]'
let g:deoplete#omni#input_patterns.javascript = '[^. *\t]\.\w*'
let g:deoplete#omni#input_patterns.ocaml = '[^. *\t]\.\w*\|\h\w*|#'
let g:tern_request_timeout = 1
let g:tern_show_signature_in_pum = '0'
let g:tern#filetypes = ["js","javascript.jsx","jsx","javascript"]
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" My Keybindings ===============================================================
map ; :
let mapleader=" "
map <leader>o :nohlsearch<cr>|                      " clear search highlights
map <leader>w :set wrap!<cr>|                       " toggle word wrap
map <leader>s :setlocal spell! spelllang=en_us<cr>| " toggle spell checking
map <leader>a :sort<cr>|                            " sort lines
map <leader>r :so ~/.vimrc<cr>|                     " reload vimrc
map <C-p>     :FZF<cr>|                             " fuzzy file searching
map <S-h>     :bp<cr>|                              " previous buffer
map <S-l>     :bn<cr>|                              " next buffer
map <C-h>     :wincmd h<cr>|                        " window left
map <C-j>     :wincmd j<cr>|                        " window below
map <C-k>     :wincmd k<cr>|                        " window above
map <C-l>     :wincmd l<cr>|                        " window right

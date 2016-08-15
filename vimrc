" James Vaughan's vimrc ========================================================
" Plugins =====================================================================-
call plug#begin('~/.config/nvim/plugged')
  Plug 'Shougo/deoplete.nvim'
  Plug 'carlitux/deoplete-ternjs'
  Plug 'dracula/vim'
  Plug 'eagletmt/neco-ghc'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'lambdatoast/elm.vim'
  Plug 'mxw/vim-jsx'
  Plug 'myint/syntastic-extras'
  Plug 'pangloss/vim-javascript'
  Plug 'scrooloose/syntastic'
  Plug 'ternjs/tern_for_vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

" My Settings ==================================================================
color dracula          " set colorscheme
set colorcolumn=80     " highlight max length column
set expandtab          " tabs to spaces
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

" Airline
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline_left_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_right_sep = ''
let g:airline_section_y = ''
let g:airline_theme = 'dracula'

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%{SyntasticStatuslineFlag()}

" Deoplete
let g:deoplete#enable_at_startup = 1
" if !exists('g:deoplete#omni#input_patterns')
"   let g:deoplete#omni#input_patterns = {}
" endif
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" omnifuncs
" augroup omnifuncs
"   autocmd!
"   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"   autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"   autocmd FileType javascript setlocal omnifunc=tern#Complete
"   autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" augroup end

" tern
" let g:tern_show_arguments_hints = 'on_hold'
" let g:tern_show_signature_in_pum = 1

" My Keybindings ===============================================================
map ; :
let mapleader=" "
map <leader>o :noh<cr>|                            " clear search highlights
map <leader>w :set wrap !<cr>|                     " toggle word wrap
map <leader>s :setlocal spell! spelllang=en_us<cr>|" toggle spell checking
map <leader>a :sort<cr>|                           " sort lines
map <C-p>     :FZF<cr>|                            " fuzzy file searching
map <S-h>     :bp<cr>|                             " previous buffer
map <S-l>     :bn<cr>|                             " next buffer
map <C-h>     :wincmd h<cr>|                       " window left
map <C-j>     :wincmd j<cr>|                       " window below
map <C-k>     :wincmd k<cr>|                       " window above
map <C-l>     :wincmd l<cr>|                       " window right
